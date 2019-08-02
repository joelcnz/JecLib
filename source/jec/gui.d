module jec.gui;

import jec.base;

class Wedget {
//private:
    string _name;
    Rect!float _box;
    RectangleShape _rectOutLineShp,
        _rectFillShp;
    Focus _focus = Focus.on;
    Font _font;
    Text _listTxt;
     
    InputJex _input;
    string[] _list;

    bool _hidden;
    bool _focusAble = true;
public:
    auto name() { return _name; }
    auto box() { return _box; }
    void txtHead(string txt0) {
        if (_list.length)
            _list[0] = txt0;
    }
    auto txtHead() { 
        if (_list.length)
            return _list[0];
        return "?";
    }
    auto list() { return _list; }
    void list(string[] list0) { _list = list0; }
    auto input() { return _input; }
    void hidden(bool hidden0) { _hidden = hidden0; } 
    auto hidden() { return _hidden; }
    void focusAble(bool focusAble0) { _focusAble = focusAble0; }
    auto focusAble() { return _focusAble; }

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

    bool gotFocus(Point pos) {
        if (! hidden && pos.X >= _box.left && pos.X < _box.left + _box.width &&
            pos.Y >= _box.top && pos.Y < _box.top + _box.height)
            return true;
        return false;
    }

    void process() {}

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

class EditBox : Wedget {

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

class Button : Wedget {

     this(in string name, Rect!float box0, dstring txt0) {
        super(name, box0);
        _listTxt = new Text();
        with(_listTxt) {
            _font = new Font;
            _font.loadFromFile("Fonts/DejaVuSans.ttf");
            if (! _font) {
                import std.stdio;
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