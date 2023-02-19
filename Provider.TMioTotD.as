/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {

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
