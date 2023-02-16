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
        void OnItemHovered() {}
        void OnItemClick() {}

        string getCOTDString(uint64 inTime) {
            uint64 frenchTime = inTime + getFrenchOffset(inTime);

            auto ti = Time::ParseUTC(frenchTime);
            uint64 beginningOfDay = frenchTime - (frenchTime % 86400);

            uint cotnStart = 3600 * 2;
            uint cotnEnd = cotnStart + 900;
            uint cotmStart = 3600 * 10;
            uint cotmEnd = cotmStart + 900;
            uint cotdStart = 3600 * 18;
            uint cotdEnd = cotdStart + 900;

            uint timeUntil = 0;
            uint timeElapsed = frenchTime - beginningOfDay;
            string nextEvent;
            if (timeElapsed <= cotnStart) {
                timeUntil = cotnStart - timeElapsed;
                nextEvent = "CotN";
            } else if (timeElapsed <= cotnEnd) {
                return "\\$3afCotN qualification in progress";
            } else if (timeElapsed <= cotmStart) {
                timeUntil = cotmStart - timeElapsed;
                nextEvent = "CotM";
            } else if (timeElapsed <= cotmEnd) {
                return "\\$3afCotM qualification in progress";
            } else if (timeElapsed <= cotdStart) {
                timeUntil = cotdStart - timeElapsed;
                nextEvent = "CotD";
            } else if (timeElapsed <= cotdEnd) {
                return "\\$3afCotD qualification in progress";
            } else {
                timeUntil = cotnStart + (86400 - timeElapsed);
                nextEvent = "CotN";
            }
            
            uint min = timeUntil / 60;
            uint h = min / 60;
            uint m = min % 60;

            if (h == 0) {
                return (m < 15 ? "\\$3af" : "") + m + "m until "+nextEvent;
            } else {
                return h+"h "+m+"m until "+nextEvent;
            }
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
