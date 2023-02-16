/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {


    uint64 initTime = 0;
    uint64 animStartTime = 0;
    uint64 tickerOffsetTime = 0;
    uint64 lastFrameTime = 0;
    uint64 lastRefresh = 0;
    TickerItem@[] tickerItems;

    SQLite::Database@ cursedTimeDB;

    void init() {
        initTime = Time::Now;
        animStartTime = Time::Now;
        @cursedTimeDB = SQLite::Database(":memory:");
        if (enableComponentClock) {
            registerTaskbarProviderAddon(Clock());
            registerTaskbarProviderAddon(FPS());
            registerTaskbarProviderAddon(Ping());
            registerTaskbarProviderAddon(COTD());

            registerTickerItemProviderAddon(TMioCampaignLeaderboardProvider());
        }
    }


    void step() {
        TickerItemProvider@[]@ tips = getAllTickerItemProviders();
        if (lastRefresh == 0 || lastRefresh + (refreshTime * 1000) < Time::Now) {
            lastRefresh = Time::Now;
            for (uint i = 0; i < tips.Length; i++) {
                tips[i].OnUpdate();
            }
        }

        if (!tickerItems.IsEmpty()) tickerItems.Resize(0);
        for (uint i = 0; i < tips.Length; i++) {
            TickerItem@[] ti = tips[i].getItems();
            for (uint ii = 0; ii < ti.Length; ii++) {
                tickerItems.InsertLast(ti[ii]);
            }
        }
    }

    void render() {
        uint dt = Time::Now - lastFrameTime;
        lastFrameTime = Time::Now;

        if (!showOnHiddenOverlay && !UI::IsOverlayShown()) {
            return;
        }

        if (GetApp().Editor !is null) return;

        auto cmap = GetApp().Network.ClientManiaAppPlayground;
        if (!showOnDriving && GetApp().RootMap !is null) {
            if (cmap.UI.UISequence == CGamePlaygroundUIConfig::EUISequence::Playing && !GetApp().Network.PlaygroundClientScriptAPI.IsInGameMenuDisplayed) {
                return;
            }
        }

        RenderTicker(dt);
        if (debugMenu) RenderDebug();
    }

    void RenderTicker(uint dt) {
        UI::DrawList@ dl = UI::GetBackgroundDrawList();

        vec4 bgCol = UI::GetStyleColor(UI::Col::MenuBarBg);
        vec4 bgHoveredCol = UI::GetStyleColor(UI::Col::ButtonHovered);
        vec4 textCol = UI::GetStyleColor(UI::Col::Text);
        vec4 textDisabledCol = UI::GetStyleColor(UI::Col::TextDisabled);
        vec4 textHoveredCol = UI::GetStyleColor(UI::Col::Text);
        vec2 spacing = UI::GetStyleVarVec2(UI::StyleVar::ItemInnerSpacing);

        float height = UI::GetTextLineHeight() + 2*spacing.y;
        vec4 tickerPos(0, Draw::GetHeight() - height, Draw::GetWidth(), height);
        if (showOnTop) {
            tickerPos.y = UI::IsOverlayShown() ? height : 0.f;
        }

        dl.AddRectFilled(tickerPos, bgCol);

        if (!IsHovered(tickerPos)) {
            tickerOffsetTime += dt;
        }

        // draw ticker here
        vec4 tickerTextPos = tickerPos * vec4(1, 1, 1.5, 1);
        float offset = tickerTextPos.z + ((0.05f * tickerOffsetTime) % tickerTextPos.z);

        if (tickerItems.Length > 0) {
            uint item = 0;
            while (offset > 0.f) {
                // i hate everything about this math
                TickerItem@ ti = tickerItems[item%tickerItems.Length];
                string tiText = ti.getItemText();
                vec2 myWidth = Draw::MeasureString(tiText) + spacing*2;
                float myPos = tickerTextPos.z - myWidth.x - offset - 96.f;
                vec2 finalPos = vec2(myPos, tickerTextPos.y)+spacing;
                dl.AddText(finalPos, textCol, tiText);

                vec4 rect(finalPos, myWidth);

                if (IsHovered(rect)) {
                    dl.AddRectFilled(rect, bgHoveredCol);
                    dl.AddText(rect.xy, textHoveredCol, tiText);
                    ti.OnItemHovered();
                } else {
                    dl.AddText(rect.xy, textCol, tiText);
                }
                

                if (InvisibleButton(rect)) {
                    ti.OnItemClick();
                }

                offset -= myWidth.x + 96.f;
                item++;
            }
        }

        // draw t.io blurb
        string opTag = "\\$3af" + Icons::Heartbeat + "\\$z";
        string opTagPlus = " Powered by Trackmania.io";

        uint startMS = 5000;
        uint animMS = 250;
        if (animStartTime + startMS > Time::Now) {
            opTag += opTagPlus;
        } else if (animStartTime + startMS + animMS > Time::Now) {
            uint len = opTagPlus.Length;
            float percentThroughAnim = 1.f - float(Time::Now - animStartTime - startMS) / float(animMS);
            opTag += opTagPlus.SubStr(0, uint(float(len)*percentThroughAnim));
        }

        vec2 opTagWidth = Draw::MeasureString(opTag);
        vec4 opTagBG(tickerPos.xy, opTagWidth + spacing*2);

        dl.AddRectFilled(opTagBG, bgCol);
        dl.AddText(opTagBG.xy + spacing, textDisabledCol, opTag);
        if (IsHovered(opTagBG)) {
            animStartTime = Time::Now;
        }
        

        if (InvisibleButton(opTagBG)) {
            OpenBrowserURL("https://trackmania.io");
        }


        // draw taskbar providers
        vec2 taskbarOffset(tickerPos.z, tickerPos.w+tickerPos.y);
        TaskbarProvider@[]@ taskbars = getAllTaskbarProviders();
        for (uint i = 0; i < taskbars.Length; i++) {
            string content = taskbars[i].getItemText();
            if (content.Length == 0) continue;
            vec2 cWid = Draw::MeasureString(content) + spacing*2 + vec2(10,0);
            taskbarOffset = vec2(taskbarOffset.x - cWid.x, taskbarOffset.y);
            vec4 taskbarBG = vec4(taskbarOffset - vec2(0, cWid.y), cWid) + vec4(5, 0, 0, 0);
            
            dl.AddRectFilled(taskbarBG, bgCol);
            dl.AddText(taskbarBG.xy + spacing, textDisabledCol, content);
            if (IsHovered(taskbarBG)) {
                taskbars[i].OnItemHovered();
            }
            if (InvisibleButton(taskbarBG)) {
                taskbars[i].OnItemClick();
            }
        }
    }

    void RenderDebug() {
        if (UI::Begin("\\$3af" + Icons::Heartbeat + "\\$z Latest records", debugMenu, UI::WindowFlags::None)) {
            TaskbarProvider@[]@ taskbars = getAllTaskbarProviders();
            for (uint i = 0; i < taskbars.Length; i++) {
                string content = taskbars[i].getItemText();
                if (content.Length == 0) continue;
                UI::Text(content);
                if (UI::IsItemHovered()) {
                    taskbars[i].OnItemHovered();
                }
                UI::SameLine();
                if (UI::Button("Click###debugIconTb_"+i)) {
                    taskbars[i].OnItemClick();
                }
            }
            UI::Separator();
            
            for (uint i = 0; i < tickerItems.Length; i++) {
                TickerItem@ ti = tickerItems[i];
                string tiText = ti.getItemText();
                if (tiText.Length == 0) continue;


                if (UI::Button("Click###debugIconTi_"+i)) {
                    tickerItems[i].OnItemClick();
                }
                UI::SameLine();
                UI::Text(tiText);
                if (UI::IsItemHovered()) {
                    tickerItems[i].OnItemHovered();
                }
            }
        }
        UI::End();
    }

    /**
     * UI::InvisibleButton only works inside windows i guess... so we make our own version
     */
    bool InvisibleButton(vec4 rect) {
        if (mouseDown && MouseIn(rect, mousePos)) {
            mouseDown = false;
            return true;
        }
        return false;
    }

    bool IsHovered(vec4 rect) {
        return MouseIn(rect);
    }

    bool MouseIn(vec4 rect, vec2 pos = UI::GetMousePos()) {
        return (pos.x >= rect.x && pos.x <= (rect.x + rect.z) && pos.y >= rect.y && pos.y <= (rect.y + rect.w));
    }

    bool mouseDown = false;
    int mouseButton;
    vec2 mousePos;

    bool _mouseDown = false;
    void OnMouseButton(bool down, int button, int x, int y) {

        if (!_mouseDown) {
            mouseDown = down;
            mouseButton = button;
            mousePos = vec2(x, y);
        }
        _mouseDown = down;
    }

    /**
     * yes i am aware this is cursed.
     */
    int64 ParseTime(const string &in inTime) {
        auto st = cursedTimeDB.Prepare("SELECT unixepoch(?) as x");
        st.Bind(1, inTime);
        st.Execute();
        st.NextRow();
        st.NextRow();
        return st.GetColumnInt64("x");
    }

    uint getFrenchOffset(uint64 inTime) {
        uint month = Text::ParseUInt(Time::FormatStringUTC("%m", inTime));
        // this is a little cursed
        if (month > 3 && month < 10) {
            return 7200;
        }
        if (month == 1 || month > 10) {
            return 3600;
        }
        
        uint switchDay;
        int64 firstOfMonth = ParseTime(Time::FormatStringUTC("%Y", inTime) + "-" + Time::FormatStringUTC("%m", inTime) + "-01");
        uint dow = Text::ParseUInt(Time::FormatStringUTC("%w", firstOfMonth));
        if (dow == 6) {
            switchDay = 30;
        } else {
            switchDay = (6-dow)+23;
        }

        bool isPast = switchDay < Text::ParseUInt(Time::FormatStringUTC("%d", inTime));

        if ((isPast && month == 3) || (!isPast && month == 10)) {
            return 7200;
        } else {
            return 3600;
        }
    }
}
