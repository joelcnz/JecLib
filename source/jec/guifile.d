module jec.guifile;

import jec.base;

/**
 * Handles file operations
 * load, save, delete, and rename
*/
struct GuiFile {
    /// list of boxes for each operation
    Wedget[] _wedgets;

    ref auto getWedgets() {
        return _wedgets;
    }

    /// Set up
    void setup(Wedget[] wedgets) {
        _wedgets = wedgets;
    }

    void process(in Point pos) {
        for1: foreach(ref wedget; _wedgets) with(wedget) {
            process;
            if (gotFocus(pos)) {
                _focus = Focus.on;
            } else {
                _focus = Focus.off;
            }
            if (_focus == Focus.on && input !is null && input.enterPressed) {
                input.enterPressed = false;
                import std.ascii : isDigit;
                import std.string : split;
                import std.algorithm : canFind;

                if ("save load delete".split.canFind(name) &&
                    input.textStr.length &&
                    input.textStr[0].to!char.isDigit) {
                    import std.string;
                    
                    auto i = input.textStr.to!size_t;
                    auto txts = g_guiFile.getWedgets[WedgetNum.projects].list;

                    if (i == 0 || i >= txts.length) {
                        //update(i, ", is out of bounds 1-", txts.length - 1);
                        break for1;
                    }
                    input.textStr = txts[i][txts[i].indexOf(" ") + 1 .. $].to!dstring;
                }
                import std.path;
                void set() {
                    g_guiConfirm.setHideAll(false);
                    g_fileRootName = input.textStr;
                }
                switch(name) {
                    default: break;
                    case "save":
                        set;
                        g_guiConfirm.connect(["Save '" ~ g_fileRootName.to!string ~ "'", "", "project: Yes or No?"], WedgetNum.save);
                    break;
                    case "load":
                        set;
                        g_guiConfirm.connect(["Load '" ~ g_fileRootName.to!string ~ "'", "", "project: Yes or No?"], WedgetNum.load);
                    break;
                    case "rename":
                        set;
                        import std.file, std.path, std.string;
                        g_guiConfirm.connect(["Rename '" ~ g_currentProjectName.trim.stripExtension.baseName.to!string ~ "'",
                            "to: '" ~ g_fileRootName.to!string ~ "'", "project: Yes or No"], WedgetNum.rename);
                    break;
                    case "delete":
                        set;
                        g_guiConfirm.connect(["Delete '" ~ g_fileRootName.to!string ~ "'", "", "project: Yes or No?"], WedgetNum.del);
                    break;
                }
                input.clearInput;
            }
        }
    }

    void draw() {
        foreach(w; _wedgets) {
            w.draw;
        }
    }
}
