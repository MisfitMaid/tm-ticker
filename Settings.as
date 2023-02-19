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

    [Setting category="Display" name="Pause on hover" description="Stop the ticker from moving when hovering over it"]
    bool pauseOnHover = false;

    [Setting category="Display" name="Refresh time (sec)" description="How often to poll for updated items"]
    uint refreshTime = 300;

    [Setting category="Display" name="Scroll rate" description="How fast to scroll the ticker display (px/ms)"]
    float tickerRate = 0.05f;

    [Setting category="Display" name="Number of items" description="Number of ticker items to display. Set to 0 to show everything available"]
    uint tickerCount = 15;



    [Setting category="Components" name="Clock" description="Shows the current time. Requires plugin restart."]
    bool enableComponentClock = true;

    [Setting category="Components" name="Clock format" description="Time format in strftrime format. Requires plugin restart."]
    string clockFormat = "%X";
    
    [Setting category="Components" name="FPS" description="Shows your current frames per second. Requires plugin restart."]
    bool enableComponentFPS = true;
    
    [Setting category="Components" name="Ping" description="Shows the current ping when connected to a multiplayer server. Requires plugin restart."]
    bool enableComponentPing = true;

    [Setting category="Components" name="CotD Countdown" description="Shows a countdown to the next cup of the day/night/morning. Requires plugin restart."]
    bool enableComponentCotD = true;

    [Setting category="Components" name="Campaign Records" description="Show the latest campaign and competitive records. Requires plugin restart."]
    bool enableComponentCampaignRecords = true;

    [Setting category="Components" name="TotD Records" description="Show the latest Track of the Day records. Requires plugin restart."]
    bool enableComponentTotDRecords = true;



    [Setting category="Advanced Customization"]
    bool debugMenu = false;

    [Setting category="Advanced Customization"]
    float tickerItemPadding = 96.f;
}
