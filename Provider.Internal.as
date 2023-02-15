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
}
