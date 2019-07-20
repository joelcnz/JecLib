module jec.guiconfirm;

import jec.base;

struct GuiConfirm {
    Wedget[] _wedgets;
    WedgetNum _fun;

    ref auto getWedgets() {
        return _wedgets;
    }

    void setup(Wedget[] wedgets) {
        _wedgets = wedgets;
        setHideAll(true);
    }

    void setHideAll(bool state) {
        import std.algorithm;
        _wedgets.each!(w => w.hidden = state);
    }

    void connect(string[] headerLines, WedgetNum fun) {
        _wedgets[WedgetConfirm.question].list(headerLines);
        _fun = fun;
    }

    FileAction process(in Point pos) {
        foreach(ref wedget; _wedgets) with(wedget) {
            process;
            if (gotFocus(pos)) {
                _focus = Focus.on;
                if (g_keys[Keyboard.Key.V].keyInput) {
                    setHideAll(true);
                    if (wedget.name == "yes")
                        switch(_fun) with(WedgetNum) {
                            default: break;
                            case save: return FileAction.save;
                            case load: return FileAction.load;
                            case del: return FileAction.del;
                            case rename: return FileAction.rename;
                        }
                }
            } else {
                _focus = Focus.off;
            }
        }
        return FileAction.nothing;
    }

    void draw() {
        foreach(w; _wedgets) {
            if (! w.hidden)
                w.draw;
        }
    }
}
