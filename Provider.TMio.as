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
            if (!req.Finished()) yield();
            string dr = req.String();
            Json::Value data = Json::Parse(dr);
            items.Resize(0);
            for (uint i = 0; i < data.Length; i++) {
                items.InsertLast(TMIOImprovedTime(data[i]));
            }
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
            return "Test";
        }
    }
}
