/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {


    uint64 initTime = 0;
    TickerItem@[] tickerItems;

    void init() {
        initTime = Time::Now;
        if (enableComponentClock) {
            registerTaskbarProviderAddon(Clock());
            registerTickerItemProviderAddon(TestTickerItemProvider());
        }
    }


    void step() {
        if (!tickerItems.IsEmpty()) tickerItems.Resize(0);
        TickerItemProvider@[]@ tips = getAllTickerItemProviders();
        for (uint i = 0; i < tips.Length; i++) {
            TickerItem@[] ti = tips[i].getItems();
            for (uint ii = 0; ii < ti.Length; ii++) {
                tickerItems.InsertLast(ti[ii]);
            }
        }
    }

    void render() {
        if (!showOnHiddenOverlay && !UI::IsOverlayShown()) {
            return;
        }
        UI::DrawList@ dl = UI::GetBackgroundDrawList();

        vec4 bgCol = UI::GetStyleColor(UI::Col::MenuBarBg);
        vec4 bgColAlt = UI::GetStyleColor(UI::Col::TitleBg);
        vec4 textCol = UI::GetStyleColor(UI::Col::Text);
        vec4 textDisabledCol = UI::GetStyleColor(UI::Col::TextDisabled);
        vec2 spacing = UI::GetStyleVarVec2(UI::StyleVar::ItemInnerSpacing);

        float height = UI::GetTextLineHeight() + 2*spacing.y;
        vec4 tickerPos(0, Draw::GetHeight() - height, Draw::GetWidth(), height);
        if (showOnTop) {
            tickerPos.y = UI::IsOverlayShown() ? height : 0.f;
        }

        dl.AddRectFilled(tickerPos, bgCol);

        // draw ticker here
        vec4 tickerTextPos = tickerPos * vec4(-0.5, 1, 2, 1);
        float offset = getTickerOffset(0.05f, tickerTextPos.z);

        string[] items;
        items.InsertLast("Test 1");
        items.InsertLast("Test 2");
        items.InsertLast("Test 3");
        items.InsertLast("Test 4");
        items.InsertLast("Test 5");
        items.InsertLast("Test 6");
        items.InsertLast("Test 7");
        items.InsertLast("Test 8");
        items.InsertLast("Test 9");
        items.InsertLast("Test 10");
        items.InsertLast("Test 11");

        if (tickerItems.Length > 0) {
            uint item = 0;
            while (offset > 0.f) {
                item++;
                TickerItem@ ti = tickerItems[item%tickerItems.Length];
                string tiText = ti.getItemText();
                offset = drawTickerText(dl, tiText, offset, 96.f, tickerTextPos, spacing, textCol);
            }
        }

        // draw t.io blurb
        string opTag = "\\$3af" + Icons::Heartbeat + "\\$z";
        string opTagPlus = " Powered by Trackmania.io";

        uint startMS = 5000;
        uint animMS = 250;
        if (initTime + startMS > Time::Now) {
            opTag += opTagPlus;
        } else if (initTime + startMS + animMS > Time::Now) {
            uint len = opTagPlus.Length;
            float percentThroughAnim = 1.f - float(Time::Now - initTime - startMS) / float(animMS);
            opTag += opTagPlus.SubStr(0, uint(float(len)*percentThroughAnim));
        }

        vec2 opTagWidth = Draw::MeasureString(opTag);
        vec4 opTagBG(tickerPos.xy, opTagWidth + spacing*2);

        dl.AddRectFilled(opTagBG, bgCol);
        dl.AddText(opTagBG.xy + spacing, textDisabledCol, opTag);


        // draw taskbar providers
        vec2 taskbarOffset(tickerPos.z, tickerPos.w+tickerPos.y);
        TaskbarProvider@[]@ taskbars = getAllTaskbarProviders();
        for (uint i = 0; i < taskbars.Length; i++) {
            string content = taskbars[i].getItemText();
            vec2 cWid = Draw::MeasureString(content) + spacing*2;
            taskbarOffset = taskbarOffset - cWid;
            vec4 taskbarBG(taskbarOffset, cWid);
            
            dl.AddRectFilled(taskbarBG + vec4(-10, 0, 10, 0), bgCol);
            dl.AddText(taskbarBG.xy + spacing, textDisabledCol, content);
        }
    }

    float drawTickerText(UI::DrawList@ dl, const string &in text, float offset, float gapSize, vec4 tickerTextPos, vec2 spacing, vec4 textCol) {
        float myWidth = Draw::MeasureString(text).x + spacing.x*2 + gapSize;
        float myPos = tickerTextPos.z - myWidth - offset;
        dl.AddText(vec2(myPos, tickerTextPos.y)+spacing, textCol, text);
        return offset - myWidth;
    }

    float getTickerOffset(float rate, float width) {
        float offset = float(Time::Now) * rate;
        return width + (offset % width);
    }

}
