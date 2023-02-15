/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {
    import bool registerTaskbarProviderAddon(TaskbarProvider@ provider) from "ticker";
    import bool hasTaskbarProvider(const string &in identifier) from "ticker";
    import TaskbarProvider@ getTaskbarProvider(const string &in identifier) from "ticker";
    import TaskbarProvider@[]@ getAllTaskbarProviders() from "ticker";

    import bool registerTickerItemProviderAddon(TickerItemProvider@ provider) from "ticker";
    import bool hasTickerItemProvider(const string &in identifier) from "ticker";
    import TickerItemProvider@ getTickerItemProvider(const string &in identifier) from "ticker";
    import TickerItemProvider@[]@ getAllTickerItemProviders() from "ticker";
}
