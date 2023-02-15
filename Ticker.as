/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {

    void init() {}

    void step() {}

    void render() {
        if (!showOnHiddenOverlay && !UI::IsOverlayShown()) {
            return;
        }
        UI::DrawList@ dl = UI::GetBackgroundDrawList();

        vec4 bgCol = UI::GetStyleColor(UI::Col::MenuBarBg);
        vec4 textCol = UI::GetStyleColor(UI::Col::Text);
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

        uint item = 0;
        while (offset > 0.f) {
            item++;
            offset = drawTickerText(dl, items[item%items.Length], offset, 96.f, tickerTextPos, spacing, textCol);
        }

        // draw t.io blurb
        string opTag = "\\$3af" + Icons::Heartbeat + "\\$666 Powered by Trackmania.io |";
        vec2 opTagWidth = Draw::MeasureString(opTag);
        vec4 opTagBG(tickerPos.xy, opTagWidth + spacing*2);

        dl.AddRectFilled(opTagBG, bgCol);
        dl.AddText(opTagBG.xy + spacing, textCol, opTag);
    }

    float drawTickerText(UI::DrawList@ dl, const string &in text, float offset, float gapSize, vec4 tickerTextPos, vec2 spacing, vec4 textCol) {
        float myWidth = Draw::MeasureString(text).x + spacing.x*2 + gapSize;
        float myPos = tickerTextPos.z - myWidth - offset;
        dl.AddText(vec2(myPos, tickerTextPos.y)+spacing, textCol, text);
        return offset - myWidth;
    }

    string getTickerText(float repeatUntilWidth = 0.f) {
        string inText = "AAAAAAAAAA";
        string spacer = "    ";

        string outText = inText;

        while (Draw::MeasureString(outText).x < repeatUntilWidth) {
            outText += spacer + inText;
        }

        return outText;
    }

    float getTickerOffset(float rate, float width) {
        float offset = float(Time::Now) * rate;
        return width + (offset % width);
    }

}
