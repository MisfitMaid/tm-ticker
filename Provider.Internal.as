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
        void OnItemHovered() {
            UI::BeginTooltip();
            UI::Text("UTC: " + Time::FormatStringUTC(clockFormat));
            UI::Text("CET: " + Time::FormatStringUTC(clockFormat, Time::Stamp + getFrenchOffset(Time::Stamp)));
            UI::EndTooltip();
        }
        void OnItemClick() {}
    }

    class COTD : TaskbarProvider {
        string getID() { return "Ticker/cotd"; }
        string getItemText() {
            return getCOTDString(Time::Stamp);
        }
        void OnItemHovered() {
            uint64 frenchTime = Time::Stamp + getFrenchOffset(Time::Stamp);
            UI::BeginTooltip();
            UI::Text(getCOTDString(Time::Stamp, secondsUntil(19, 0, frenchTime % 86400)));
            UI::Text(getCOTDString(Time::Stamp, secondsUntil(3, 0, frenchTime % 86400)));
            UI::Text(getCOTDString(Time::Stamp, secondsUntil(11, 0, frenchTime % 86400)));
            UI::EndTooltip();
        }
        void OnItemClick() {}

        string getCOTDString(uint64 inTime, uint forceGoal = 0) {
            uint64 frenchTime = inTime + getFrenchOffset(inTime);

            uint cotnStart = secondsUntil( 3,  0, frenchTime % 86400);
            uint cotnEnd   = secondsUntil( 3, 15, frenchTime % 86400);
            uint cotmStart = secondsUntil(11,  0, frenchTime % 86400);
            uint cotmEnd   = secondsUntil(11, 15, frenchTime % 86400);
            uint cotdStart = secondsUntil(19,  0, frenchTime % 86400);
            uint cotdEnd   = secondsUntil(19, 15, frenchTime % 86400);

            // i hate everything about this bit of code
            uint nextEvent;
            if (forceGoal == 0) {
                nextEvent = Math::Min(cotnStart, Math::Min(cotnEnd, Math::Min(cotmStart, Math::Min(cotmEnd, Math::Min(cotdStart, cotdEnd)))));
            } else {
                nextEvent = forceGoal;
            }
            

            string nextEventStr = Time::Format(nextEvent*1000, false, true, false, true);
            string cotdCol = "";
            if (nextEvent < 900) cotdCol = "\\$3af";

            if (nextEvent == cotnStart) {
                return cotdCol+"CotN in " + nextEventStr;
            } else if (nextEvent == cotnEnd) {
                return cotdCol+"CotN qualification in progress";
            } else if (nextEvent == cotmStart) {
                return cotdCol+"CotM in " + nextEventStr;
            } else if (nextEvent == cotmEnd) {
                return cotdCol+"CotM qualification in progress";
            } else if (nextEvent == cotdStart) {
                return cotdCol+"CotD in " + nextEventStr;
            } else {
                return cotdCol+"CotD qualification in progress";
            }
        }

        uint secondsUntil(uint h, uint m, uint64 cur) {
            uint goal = (h * 3600) + (m * 60);
            if (goal <= cur) goal += 86400;
            return goal - cur;
        }
    }

    class FPS : TaskbarProvider {
        string getID() { return "Ticker/FPS"; }
        string getItemText() { 
            if (GetApp().Viewport !is null) return Text::Format("%d", uint(GetApp().Viewport.AverageFps)) + " FPS";
            return "";
        }
        void OnItemHovered() {}
        void OnItemClick() {}
    }

    class Ping : TaskbarProvider {
        string getID() { return "Ticker/Ping"; }
        string getItemText() { 
            auto Network = cast<CTrackManiaNetwork>(GetApp().Network);
            auto ServerInfo = cast<CGameCtnNetServerInfo>(Network.ServerInfo);
            if (ServerInfo.JoinLink != "") {
                return Text::Format("%d", Network.LatestGamePing) + "ms";
            }
            return "";
        }
        void OnItemHovered() {}
        void OnItemClick() {}
    }
}
