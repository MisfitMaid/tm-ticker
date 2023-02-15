/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {
    class TMioCampaignLeaderboardProvider : TickerItemProvider {
        string getID() { return "Ticker/TMioCampaignLeaderboard"; }

        TickerItem@[] items;

        TickerItem@[] getItems() {
            return items;
        }

        void OnUpdate() {
            auto req = Net::HttpGet("https://trackmania.io/api/leaderboard/activity/aa4c4c42-7a04-4558-aca9-88db835fb30a/0");
            while (!req.Finished()) yield();
            Json::Value data = Json::Parse(req.String());
            items.Resize(0);
            for (uint i = 0; i < data.Length; i++) {
                items.InsertLast(TMIOImprovedTime(data[i]));
            }
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
    }
}
