/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {
    class TMioCampaignLeaderboardProvider : TickerItemProvider {
        string getID() { return "Ticker/TMioCampaignLeaderboard"; }
        TickerItem@[] getItems() {
            TickerItem@[] ti;
            
            for (uint i = 0; i < 16; i++) {
                ti.InsertLast(TestTickerItem(i));
            }

            return ti;
        }

        void OnUpdate() {}
    }

    class TMIOImprovedTime : BaseTickerItem {
        
        Json::Value@ data;
        
        TMIOImprovedTime() {}
        TMIOImprovedTime(Json::Value@ inDat) {
            @data = inDat;
        }

        string getItemText() override {
            return "Test";
        }
    }
}
