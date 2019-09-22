module jec.guiconfirm;

import jec.base;

/// Confirm (yes/no) dialog box
struct GuiConfirm {
    Wedget[] _wedgets; /// List of wedgets

    ref auto getWedgets() {
        return _wedgets;
    }

    /// basic set up
    void setup(Wedget[] wedgets) {
        _wedgets = wedgets;
        setHideAll(true);
    }

    void setHideAll(bool state) {
        import std.algorithm : each;

        _wedgets.each!(w => w.hidden = state);
    }

    void setQuestion(string[] headerLines) {
        _wedgets[WedgetConfirm.question].list(headerLines);
    }

    /// Process checking for button press
    void process(in Point pos) {
        foreach(ref wedget; _wedgets) with(wedget) {
            process;
            if (gotFocus(pos)) {
                _focus = Focus.on;
                if (g_keys[Keyboard.Key.V].keyInput) {
                    setHideAll(true);
                    if (wedget.name == "yes")
                        g_stateConfirm = StateConfirm.yes;
                    else if (wedget.name == "no")
                        g_stateConfirm = StateConfirm.no;
                }
            } else {
                _focus = Focus.off;
            }
        }
    }

    /// Draw
    void draw() {
        foreach(w; _wedgets) {
            if (! w.hidden)
                w.draw;
        }
    }
}
