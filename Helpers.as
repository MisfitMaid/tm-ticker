/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {
    string OpenplanetColor(vec4 inCol) {
        uint r = uint(Math::Round(inCol.x * 15));
        uint g = uint(Math::Round(inCol.y * 15));
        uint b = uint(Math::Round(inCol.z * 15));
        return "\\$"+Text::Format("%x", r)+Text::Format("%x", g)+Text::Format("%x", b);
    }
}
