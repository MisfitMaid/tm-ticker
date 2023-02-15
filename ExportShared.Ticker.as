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

        shared interface TickerItemProvider {
            string getID();
            string getItemText();
            void OnItemHovered();
            void OnItemClick();
        }

        shared class NullTickerItem : TickerItemProvider {
            string getID() { return "Ticker/NullTickerItem"; }
            string getItemText() { return ""; }
            void OnItemHovered() {}
            void OnItemClick() {}
        }
}
