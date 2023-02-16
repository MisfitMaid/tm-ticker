/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {
    
    [Setting category="Display" name="Show on top" description="If toggled on, tickerbar will appear below the Openplanet menu rather than at the bottom"]
    bool showOnTop = false;

    [Setting category="Display" name="Show despite hidden overlay setting" description="Toggle on to keep the tickerbar visible when the Openplanet overlay is disabled"]
    bool showOnHiddenOverlay = false;

    [Setting category="Display" name="Show when driving" description="Toggle on to show even while driving"]
    bool showOnDriving = false;

#if DEVELOPER
    [Setting category="Display" name="Debug panel" description="Summons an imgui window showing all ticker items at once"]
#endif
    bool debugMenu = false;

    [Setting category="Display" name="Refresh time (sec)" description="How often to poll for updated items"]
    uint refreshTime = 300;

    [Setting category="Components" name="Clock" description="Shows the current time"]
    bool enableComponentClock = true;

    [Setting category="Components" name="Clock format" description="Time format in strftrime format"]
    string clockFormat = "%X";
}
