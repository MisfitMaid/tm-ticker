/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {
    class TMioCampaignLeaderboardProvider : TickerItemProvider {

        string[] leaderboards;

        TMioCampaignLeaderboardProvider() {
            auto req = Net::HttpGet("https://trackmania.io/api/campaigns/0");
            while (!req.Finished()) yield();
            Json::Value data = Json::Parse(req.String());
            Json::Value camps = data["campaigns"];
            for (uint i = 0; i < camps.Length; i++) {
                if (bool(camps[i]['tracked'])) {
                    string url;
                    Json::Value c = camps[i];
                    if (c["clubid"] == 0) {
                        url = "https://trackmania.io/api/officialcampaign/" + uint(c["id"]);
                    } else {
                        url = "https://trackmania.io/api/campaign/" + uint(c["clubid"]) + "/" + uint(c["id"]);
                    }
                    auto req2 = Net::HttpGet(url);
                    while (!req2.Finished()) yield();
                    Json::Value cData = Json::Parse(req2.String());
                    string leaderboardURL = "https://trackmania.io/api/leaderboard/activity/" + string(cData["leaderboarduid"]) + "/0";
                    leaderboards.InsertLast(leaderboardURL);
                }
            }
        }

        string getID() { return "Ticker/TMioCampaignLeaderboard"; }

        TickerItem@[]@ items;

        TickerItem@[] getItems() {
            return items;
        }

        void OnUpdate() {
            @items = fetchNewRecords();
        }

        TickerItem@[]@ fetchNewRecords() {
            TMIOImprovedTime@[] allRecords;
            for (uint i = 0; i < leaderboards.Length; i++) {
                auto req = Net::HttpGet(leaderboards[i]);
                while (!req.Finished()) yield();
                Json::Value lData = Json::Parse(req.String());

                for (uint k = 0; k < lData.Length; k++) {
                    allRecords.InsertLast(TMIOImprovedTime(lData[k]));
                }
            }
            allRecords.SortDesc();
            TickerItem@[] ret;
            for (uint i = 0; i < allRecords.Length; i++) {
                ret.InsertLast(allRecords[i]);
            }
            return ret;
        }
    }

    class TMIOImprovedTime : BaseTickerItem {
        
        Json::Value@ data;

        int64 parsedTime;
        
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

        int opCmp(TMIOImprovedTime &in other) {
            if (parsedTime == other.parsedTime) return 0;
            if (parsedTime > other.parsedTime) return 1;
            return -1;
        }
    }
}
