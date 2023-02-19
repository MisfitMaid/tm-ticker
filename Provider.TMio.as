/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {
    class TMioCampaignLeaderboardProvider : TickerItemProvider {

        string[] leaderboards;

        bool fetchingCampaign = false;
        void getCampaignList() {
            if (fetchingCampaign) return; // only one at a time pls
            fetchingCampaign = true;
            auto req = Net::HttpGet("https://trackmania.io/api/campaigns/0");
            while (!req.Finished()) yield();
            Json::Value data = Json::Parse(req.String());
            Json::Value camps = data["campaigns"];
            for (uint i = 0; i < camps.Length; i++) {
                if (bool(camps[i]['tracked'])) {
                    Json::Value c = camps[i];
                    string leaderboard = getCampaignLeaderboard(c["id"], c["clubid"]);
                    leaderboards.InsertLast("https://trackmania.io/api/leaderboard/activity/" + leaderboard + "/0");
                }
            }
            fetchingCampaign = false;
        }

        string getCampaignLeaderboard(uint id, uint clubid = 0) {
            if (IO::FileExists(IO::FromStorageFolder("campaigns/"+id))) {
                IO::File store(IO::FromStorageFolder("campaigns/"+id), IO::FileMode::Read);
                string lid = store.ReadToEnd();
                store.Close();
                return lid;
            }
            string url;
            if (clubid == 0) {
                url = "https://trackmania.io/api/officialcampaign/" + id;
            } else {
                url = "https://trackmania.io/api/campaign/" + clubid + "/" + id;
            }
            auto req2 = Net::HttpGet(url);
            while (!req2.Finished()) yield();
            Json::Value cData = Json::Parse(req2.String());
            string lid = string(cData["leaderboarduid"]);

            if (!IO::FolderExists(IO::FromStorageFolder("campaigns"))) IO::CreateFolder(IO::FromStorageFolder("campaigns"));
            IO::File store(IO::FromStorageFolder("campaigns/"+id), IO::FileMode::Write);
            store.Write(lid);
            store.Close();
            return lid;
        }

        string getID() { return "Ticker/TMioCampaignLeaderboard"; }

        TickerItem@[]@ items;

        TickerItem@[] getItems() {
            return items;
        }

        void OnUpdate() {
            if (leaderboards.Length == 0) getCampaignList();
            @items = fetchNewRecords();
        }

        TickerItem@[]@ fetchNewRecords() {
            TickerItem@[] allRecords;
            for (uint i = 0; i < leaderboards.Length; i++) {
                auto req = Net::HttpGet(leaderboards[i]);
                while (!req.Finished()) yield();
                Json::Value lData = Json::Parse(req.String());

                for (uint k = 0; k < lData.Length; k++) {
                    allRecords.InsertLast(TMIOImprovedTime(lData[k]));
                }
            }
            return allRecords;
        }
    }

    class TMioTotDLeaderboardProvider : TMioCampaignLeaderboardProvider {
        string cachedtotd = "";
        Json::Value@ mapInfo;

        TMioTotDLeaderboardProvider() {
        }

        string getID() override { return "Ticker/TMioTotDLeaderboard"; }

        TickerItem@[]@ fetchNewRecords() override {
            getTotDLeaderboard();
            TickerItem@[] allRecords;
            auto req = Net::HttpGet("https://trackmania.io/api/leaderboard/" + cachedtotd);
            while (!req.Finished()) yield();
            Json::Value lData = Json::Parse(req.String())["tops"];

            for (uint k = 0; k < uint(Math::Min(lData.Length, 5)); k++) {
                allRecords.InsertLast(TMIOTotDImprovedTime(lData[k], mapInfo, cachedtotd));
            }
            return allRecords;
        }

        string getTotDLeaderboard() {
            if (cachedtotd.Length > 0 && !isCotdInProgress()) {
                return cachedtotd;
            }
            auto req = Net::HttpGet("https://trackmania.io/api/totd/0");
            while (!req.Finished()) yield();
            Json::Value data = Json::Parse(req.String());
            Json::Value day = data["days"][data["days"].Length-1];
            @mapInfo = day;
            cachedtotd = string(day["leaderboarduid"]) + "/" + string(day["map"]["mapUid"]);
            return cachedtotd;
        }

        bool isCotdInProgress() {
            uint64 frenchTime = Time::Stamp + getFrenchOffset(Time::Stamp);

            uint64 beginningOfDay = frenchTime - (frenchTime % 86400);

            uint cotdStart = 3600 * 18;
            uint cotdEnd = cotdStart + 900;

            uint timeElapsed = frenchTime - beginningOfDay;
            return (timeElapsed >= cotdStart && timeElapsed <= cotdEnd);
        }
    }

    class TMIOImprovedTime : BaseTickerItem {
        
        Json::Value@ data;

        uint64 parsedTime;
        
        TMIOImprovedTime() {}
        TMIOImprovedTime(Json::Value@ inDat) {
            @data = inDat;
            parsedTime = ParseTime(inDat["drivenat"]);
        }

        string getItemText() override {
            string map = StripFormatCodes(data["map"]["name"]);
            string player = StripFormatCodes(data["player"]["name"]);
            string time = Time::Format(data["time"]);
            string diff = Time::Format(Math::Abs(int(data["timediff"])), true, false);
            string at = relTimeStr();
            return "\\$666" + at + " ago:\\$z " + map + " \\$666in\\$z " + time + " \\$66c(-" + diff + ")\\$666 by \\$z" + player;
        }

        uint64 getSortTime() const override {
            return parsedTime;
        }

        string relTimeStr() {
            int64 diff = Time::Stamp - parsedTime;

            int num = 0;
            string unit;
            if (diff > 86400) {
                num = int(Math::Floor(diff/86400));
                unit = "d";
            } else if (diff > 3600) {
                num = int(Math::Floor(diff/3600));
                unit = "h";
            } else if (diff > 60) {
                num = int(Math::Floor(diff/60));
                unit = "m";
            } else {
                num = diff;
                unit = "s";
            }
            return Text::Format("%d", num) + unit;
        }

        void OnItemClick() override {
            OpenBrowserURL("https://trackmania.io/#/leaderboard/" + string(data["map"]["mapUid"]));
        }
    }

    class TMIOTotDImprovedTime : TMIOImprovedTime {
        
        Json::Value@ map;
        string leaderboardUid;
        
        TMIOTotDImprovedTime() {}
        TMIOTotDImprovedTime(Json::Value@ inDat, Json::Value@ inMap, const string &in inLeaderboardUid) {
            @data = inDat;
            @map = inMap;
            leaderboardUid = inLeaderboardUid;
            parsedTime = ParseTime(inDat["timestamp"]);
        }

        string getItemText() override {
            string mapname = StripFormatCodes(map["map"]["name"]) + " (TotD)";
            string player = StripFormatCodes(data["player"]["name"]);
            string time = Time::Format(data["time"]);
            string at = relTimeStr();
            return "\\$666" + at + " ago:\\$z " + mapname + " \\$666in\\$z " + time + "\\$666 by \\$z" + player;
        }

        void OnItemClick() override {
            OpenBrowserURL("https://trackmania.io/#/totd/leaderboard/" + leaderboardUid);
        }
    }
}
