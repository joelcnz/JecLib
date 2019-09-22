module jec.gui;

import jec.base;

/// Root wedget
class Wedget {
//private:

    /// name
    string _name; 
    /// box or button dimentions
    Rect!float _box;
    /// Focus box
    RectangleShape _rectOutLineShp;
    /// box or button graphic
    RectangleShape _rectFillShp;
    /// box, button, icon, mouse over status
    Focus _focus = Focus.on;
    /// Font
    Font _font;
    /// Text
    Text _listTxt;
    /// My input text
    InputJex _input;
    /// List of text strings
    string[] _list;
    /// Show or hide
    bool _hidden;
    /// Does is show the focus outline with the mouse pointer
    bool _focusAble = true;
public:
    /// name
    auto name() { return _name; }
    /// box
    auto box() { return _box; }
    /// 1st text of strings setter
    void txtHead(string txt0) {
        if (_list.length)
            _list[0] = txt0;
    }
    /// 1st text of strings setter
    auto txtHead() { 
        if (_list.length)
            return _list[0];
        return "?";
    }
    /// list getter
    auto list() { return _list; }
    /// list setter
    void list(string[] list0) { _list = list0; }
    /// Input getter
    auto input() { return _input; }
    /// hide setter
    void hidden(bool hidden0) { _hidden = hidden0; } 
    /// hide getter
    auto hidden() { return _hidden; }
    /// Setter whether focusable or not
    void focusAble(bool focusAble0) { _focusAble = focusAble0; }
    /// focusable getter
    auto focusAble() { return _focusAble; }

    /// Ctor name and box (location and size)
    this(in string name, in Rect!float box0) {
        _name = name;
        _box = box0;
        _rectFillShp = new RectangleShape();
        with(_rectFillShp) {
            size(Vector2f(_box.width, _box.height));
            fillColor = Color(180, 64, 0);
            position(Vector2f(_box.left, _box.top));
        }
        _rectOutLineShp = new RectangleShape();
        with(_rectOutLineShp) {
            size(Vector2f(_box.width, _box.height));
            outlineColor = Color(255,255,255); 
            outlineThickness = 1;
            fillColor = Color(0,0,0,0);
            position(Vector2f(_box.left, _box.top));
        }
        _listTxt = new Text("", g_font);
        with(_listTxt) {
            setColor = Color(255,255,0);
            setCharacterSize = 15;
        }
    }

    /// Check for focus
    bool gotFocus(Point pos) {
        if (! hidden && pos.X >= _box.left && pos.X < _box.left + _box.width &&
            pos.Y >= _box.top && pos.Y < _box.top + _box.height)
            return true;
        return false;
    }

    /// Position filler
    void process() {}

    /// Minimal drawing
    void draw() {
        g_window.draw(_rectFillShp);
        if (_list.length) {
            auto pos = Point(box.left + 1, box.top + 1);
            foreach(item; _list) {
                _listTxt.setString = item.to!dstring;
                _listTxt.position = Vector2f(pos.X, pos.Y);
                g_window.draw(_listTxt);
                pos = Point(pos.X, pos.Y + _listTxt.getLocalBounds.height);
            }
        }
        if (focusAble && _focus == Focus.on)
            g_window.draw(_rectOutLineShp);
    }
}

/// Edit box wedget
class EditBox : Wedget {
    /// Ctor name, boc, and label
    this(in string name, Rect!float box0, dstring txt0) {
        super(name, box0);
       _input = new InputJex(/* position */ Vector2f(_box.left + 2, box.top + 2),
                    /* font size */ 12,
                    /* header */ txt0.to!string,
                    /* Type (oneLine, or history) */ InputType.oneLine);
    }

    override void process() {
        with(_input) {
            if (_focus == Focus.on) {
                    process; //#input
                    drawCursor = true;
            } else
                drawCursor = false;
        }
    }

    override void draw() {
        super.draw;
        _input.draw;
    }
}

/// Button wedget
class Button : Wedget {
    /// Ctor name, box, and text for button
    this(in string name, Rect!float box0, dstring txt0) {
        super(name, box0);
        _listTxt = new Text();
        with(_listTxt) {
            _font = new Font;
            _font.loadFromFile("Fonts/DejaVuSans.ttf");
            if (! _font) {
                import std.stdio : writeln;
                writeln("Font not load");
                return;
            }
            _list = [txt0.to!string];
            setCharacterSize = 15;
            setColor = Colour.yellow;
            setFont = _font;
            position = Vector2f(box.left + 1, box.top + 1);
        }
    }

    override void process() {
    }

    override void draw() {
        super.draw;
    }
}
