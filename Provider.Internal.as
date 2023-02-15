/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {
        class Clock : TaskbarProvider {
            string getID() { return "Ticker/Clock"; }
            string getItemText() { 
                return Time::FormatString(clockFormat);
            }
            void OnItemHovered() {}
            void OnItemClick() {}
        }

        class TestTickerItemProvider : TickerItemProvider {
            string getID() { return "Ticker/TestTickerItem"; }
            TickerItem@[] getItems() {
                TickerItem@[] ti;
                
                for (uint i = 0; i < 16; i++) {
                    ti.InsertLast(TestTickerItem(i));
                }

                return ti;
                }
        }

        class TestTickerItem : BaseTickerItem {
            uint myNum;
            TestTickerItem() {}
            TestTickerItem(uint num) {
                myNum = num;
            }

            string getItemText() override {
                return "Test " + Text::Format("%d", myNum);
            }
        }
}
