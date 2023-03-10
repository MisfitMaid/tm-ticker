/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {
        shared interface TaskbarProvider {
            string getID();
            string getItemText();
            void OnItemHovered();
            void OnItemClick();
        }

        shared class NullTaskbar : TaskbarProvider {
            string getID() { return "Ticker/NullTaskbar"; }
            string getItemText() { return ""; }
            void OnItemHovered() {}
            void OnItemClick() {}
        }

        shared interface TickerItem {
            string getItemText();
            uint64 getSortTime() const;
            void OnItemHovered();
            void OnItemClick();
        }

        shared interface TickerItemProvider {
            string getID();
            TickerItem@[] getItems();
            void OnUpdate();
        }

        shared class NullTickerItemProvider : TickerItemProvider {
            string getID() { return "Ticker/NullTickerItem"; }
            TickerItem@[] getItems() { TickerItem@[] ti; return ti; }
            void OnUpdate() {}
        }

        shared class BaseTickerItem : TickerItem {
            string getItemText() { return ""; }
            uint64 getSortTime() const { return 0; }
            void OnItemHovered() {}
            void OnItemClick() {}
        }
}
