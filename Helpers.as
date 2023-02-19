/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {

    funcdef bool LessSort(const TickerItem@ &in a, const TickerItem@ &in b);
    bool LessSortFunc(const TickerItem@ &in a, const TickerItem@ &in b) {
        if (a is null || b is null) return false;
        return a.getSortTime() > b.getSortTime();
    }
    
    string OpenplanetColor(vec4 inCol) {
        uint r = uint(Math::Round(inCol.x * 15));
        uint g = uint(Math::Round(inCol.y * 15));
        uint b = uint(Math::Round(inCol.z * 15));
        return "\\$"+Text::Format("%x", r)+Text::Format("%x", g)+Text::Format("%x", b);
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
