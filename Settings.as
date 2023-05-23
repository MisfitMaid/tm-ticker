/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {
    
    [Setting category="Display" name="Show on top" description="If toggled on, tickerbar will appear below the Openplanet menu rather than at the bottom"]
    bool showOnTop = false;

    [Setting category="Display" name="Show despite hidden overlay setting" description="Toggle on to keep the tickerbar visible when the Openplanet overlay is disabled"]
    bool showOnHiddenOverlay = true;

    [Setting category="Display" name="Show when driving" description="Toggle on to show even while driving"]
    bool showOnDriving = false;

    [Setting category="Display" name="Pause on hover" description="Stop the ticker from moving when hovering over it"]
    bool pauseOnHover = false;

    [Setting category="Display" drag min=60 name="Refresh time (sec)" description="How often to poll for updated items"]
    uint refreshTime = 300;

    [Setting category="Display" drag name="Scroll rate" description="How fast to scroll the ticker display (px/ms)"]
    float tickerRate = 0.05f;

    [Setting category="Display" drag name="Number of items" description="Number of ticker items to display. Set to 0 to show everything available"]
    uint tickerCount = 15;



    [Setting category="Components" name="Close" description="A button to close Trackmania (useful if 'Show on top' is enabled)"]
    bool enableComponentClose = false;

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

    [Setting category="Advanced Customization" drag min=0.f max=4096.f]
    float tickerItemPadding = 96.f;

    [Setting category="Advanced Customization" drag min=1.f ]
    float tickerOverRender = 2.5f;

    [Setting category="Advanced Customization" drag]
    vec2 taskbarItemPadding = vec2(10,0);

    [Setting category="Advanced Customization" color]
    vec4 globalColorMult = vec4(1,1,1,1);

    [Setting category="Advanced Customization" color]
    vec4 bgColBase = UI::GetStyleColor(UI::Col::MenuBarBg);

    [Setting category="Advanced Customization" color description="Change the 4th value here to make the bar transparent"]
    vec4 bgColMult = vec4(1,1,1,1);
    
    [Setting category="Advanced Customization" color]
    vec4 textColBase = UI::GetStyleColor(UI::Col::Text);

    [Setting category="Advanced Customization" color]
    vec4 textColMult = vec4(1,1,1,1);
    
    [Setting category="Advanced Customization" color]
    vec4 textDisabledColBase = UI::GetStyleColor(UI::Col::TextDisabled);

    [Setting category="Advanced Customization" color]
    vec4 textDisabledColMult = vec4(1,1,1,1);
    
    [SettingsTab name="Help & Credits" order="2" icon="QuestionCircle"]
    void RenderSettingsHelp()
    {
        UI::TextWrapped("Ticker is currently in early development. If you encounter any issues or have a feature request, please reach out so that I can get it taken care of! :)");

        UI::Separator();

        UI::TextWrapped("If you are interested in supporting this project or just want to say hi, please consider taking a look at the below links "+Icons::Heart);

        UI::Markdown(Icons::Patreon + " [https://patreon.com/MisfitMaid](https://patreon.com/MisfitMaid)");
        UI::Markdown(Icons::Paypal + " [https://paypal.me/MisfitMaid](https://paypal.me/MisfitMaid)");
        UI::Markdown(Icons::Github + " [https://github.com/MisfitMaid/tm-ticker](https://github.com/MisfitMaid/tm-ticker)");
        UI::Markdown(Icons::Discord + " [https://discord.gg/BdKpuFcYzG](https://discord.gg/BdKpuFcYzG)");
        UI::Markdown(Icons::Twitch + " [https://twitch.tv/MisfitMaid](https://twitch.tv/MisfitMaid)");
    }
}
