/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

void Main() {
    Ticker::init();
    while(true) {
        Ticker::step();
        yield();
    }
}
void OnSettingsChanged() { Ticker::init(); }
void OnEnabled() { Ticker::init(); }

void Render() { Ticker::render(); }

void OnMouseButton(bool down, int button, int x, int y) {
    Ticker::OnMouseButton(down, button, x, y);
}
