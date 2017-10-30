//#not used
//#here
//#new, untested
//#hack
 //#new
module jec.input;

//#put some restriction
//#under construction
//#shouldn't be here
//#key doesn't work with DSFML!
//#up key press
//#define oneLine: just one line doesn't move. History: adds lines from input, and moves down
import std.stdio;
import std.conv;
import std.ascii;

import jec.base;

class InputJex {
private:
	dstring _str;
	bool _keyShift, _control, _alt, _keySystem;
	Text[] _history;
	int _inputHistoryPos;
	dstring[] _inputHistory;
	string _button;
	Text _txt,
		 _header;
	Color _colour;
	float _historyLineHeight;
	Vector2f _vect,
			 _mousePos;
	CircleShape _ss; //#not used
	bool _enterPressed;
	
	int _x;
	Text _measure; //cursor position

	InputType _inputType; //#define oneLine: just one line doesn't move. History: adds lines from input, and moves down

	RectangleShape _cursor; // for drawing the cursor

	bool _edge = false;

	bool _outPutToTerminal = true;
	bool _outPutOnlyToTerminal = false;
	bool _outPutToFile = true;

	bool _showHistory = true;

	dchar _lastKeyPressed;

	//#here
	JSound[char] _aphaNum;

	bool _backSpaceHit;
public:
	@property {
		/+
		auto () { return _; }
		void () { _ = 0; }
		+/

		auto lastKeyPressed() { return _lastKeyPressed; }
		void lastKeyPressed(dchar lastKeyPressed0) { _lastKeyPressed = lastKeyPressed0; }

		auto showHistory() { return _showHistory; }
		void showHistory(bool showHistory0) { _showHistory = showHistory0; }

		auto edge() { return _edge; }
		auto edge(bool edge0) { _edge = edge0; }
		
		auto xpos() { return _x; }
		void xpos(int x0) { _x = x0; }
		
		auto button() { return _button; }
		void button(string button0) { _button = button0; }
		
		auto inputType() { return _inputType; }
		void inputType(InputType inputType) { _inputType = inputType; }
	
		auto enterPressed() { return _enterPressed; }
		void enterPressed(bool ep) { _enterPressed = ep; }
	
		auto textStr() { return _str; }
		void textStr(dstring str) { _str = str; _txt.setString = _str; }
		
		void clearHistory() { _history.length = 0; }

		auto backSpaceHit() { return _backSpaceHit; }
		void backSpaceHit(in bool backSpaceHit0) { _backSpaceHit = backSpaceHit0; }

		void moveHistoryUp() {
			foreach(ref line; _history)
				line.position = Vector2f(_header.position.x, line.position.y - _historyLineHeight);
		}
		
		auto historyColour() { return _colour; }

		void historyColour(Color colour) {
			_colour = colour;
		}

		void setColour(Color colour) {
			historyColour = colour;
			_txt.setColor(_colour);
			_header.setColor(_colour);
			_cursor.fillColor = _colour;
		}

		auto keyShift() { return _keyShift; }
		auto keyControl() { return _control; }
		auto keySystem() { return _keySystem; }
		auto keyAlt() { return _alt; }
	}

	void placeTextLine(in uint index, in int x, int y, in string str) {
		assert(index < _history.length, "Error: index out of bounds");

		_history[index] = new Text(str.to!dstring, g_font, _txt.getCharacterSize);
		with(_history[index])
			position = Vector2f(x, y),
			setColor = _colour;
	}

	auto loadAphaNumSounds(in string dir) {
		import std.path : buildPath;

		
	}

	this(Vector2f pos, int fontSize, string header = "H for help: ", InputType inputType = InputType.oneLine) {
		gh("start of 'this' " ~ __FUNCTION__);
		_colour = Color(255, 255, 255);
		_header = new Text(header.to!dstring, g_font, fontSize);
		_header.position = pos;
		_inputType = inputType;
		
		_txt = new Text(""d, g_font, fontSize);
		_txt.position = Vector2f(pos.x + _header.getLocalBounds.width.to!float, pos.y);

		_historyLineHeight = _header.getLocalBounds.height.to!float;
		_inputHistory ~= "";
		
		_cursor = new RectangleShape;
		//_cursor.fillColor = Color(0,180,255);
		_cursor.fillColor = _colour; //Color(255,0,0);
		//_cursor.size = Vector2f(2, _header.getGlobalBounds.height);
		
		//_x = _txt.position.x;
		_measure = new Text(""d, g_font, fontSize);
		_measure.position = pos;
		debug mixin(trace("pos"));
	}

	void updateMeasure() {
		if (_x <= _str.length)
			_measure.setString = _str[0 .. _x];
		else
			_x = cast(int)_str.length;
	}

	void insert(C)(C c)
		if (is(C == dstring))
	{
		debug(5) mixin(trace("c", "_x", "_str"));
		if (_x > _str.length)
			_x = cast(int)_str.length;
		else {
			_str = _str[0 .. _x] ~ c ~ _str[_x .. $];
			if (_x + 1 <= _str.length) {
				_x += 1;
				updateMeasure;
			}
		}
	}

	dstring getKeyDString() {
		_keyShift = _control = _alt = _keySystem = false;

		if (Keyboard.isKeyPressed(Keyboard.Key.LShift) ||
			Keyboard.isKeyPressed(Keyboard.Key.RShift))
			_keyShift = true;

		if (Keyboard.isKeyPressed(Keyboard.Key.LControl) ||
			Keyboard.isKeyPressed(Keyboard.Key.RControl)) {
			_control = true;
		}
		if (Keyboard.isKeyPressed(Keyboard.Key.LAlt) ||
			Keyboard.isKeyPressed(Keyboard.Key.RAlt)) {
			_alt = true;
		}

		if (Keyboard.isKeyPressed(Keyboard.Key.LSystem) ||
			Keyboard.isKeyPressed(Keyboard.Key.RSystem)) {
			_keySystem = true;
		}

		int i = 0;
		foreach(key; Keyboard.Key.A .. Keyboard.Key.Z + 1) {
			if (lkeys[i].keyInput) {
				if (_keyShift == true)
					return uppercase[i].to!dstring;
				else
					return lowercase[i].to!dstring;
			}
			i++;
		} // foreach

		i = 0;
		foreach(key; Keyboard.Key.Num0 .. Keyboard.Key.Num9 + 1) {
			if (nkeys[i].keyInput) {
				if (_keyShift)
					return ")!@#$%^&*("d[key - Keyboard.Key.Num0].to!dstring;
				else
					return i.to!dstring;
			}
			i++;
		} // foreach

		i = 0;
		foreach(key; Keyboard.Key.LBracket .. Keyboard.Key.Dash + 1) {
			if (! _control && ! _alt) {
				if (ekeys[i].keyInput) {
					if (_keyShift)
						return `{}:<>"?|#+~`d[key - Keyboard.Key.LBracket].to!dstring;
					else
						return "[];,.'/\\#=`"d[key - Keyboard.Key.LBracket].to!dstring;
				}
			} else {
				//#key doesn't work with DSFML!
				enum kProblem {slash = 6, backSlash = 7}
				if (_control && ekeys[kProb.slash].keyInput)
					return "-"d;
				if (_alt && ekeys[kProb.slash].keyInput)
					return "_"d;
			}
			i++;
		} // foreach

		if (kSpace.keyInput)
			return " "d;
		
		return ""d;
	} // get key dstring

	void process() {
		auto dkey = getKeyDString;
		if (dkey.length)
			_lastKeyPressed = dkey[0];
		if (dkey != ""d)
			insert(dkey),
			_txt.setString = _str,
			updateMeasure;

		if (kBackSpace.keyInput && _str.length > 0) {
			if (_x > 0) {
				if (_control) {
					_str = ""d;
					_x = 0;
				} else {
					_str = _str[0 .. _x - 1] ~ _str[_x .. $];
					if (_x > 0)
						_x -= 1;
				}
				updateMeasure;
				_txt.setString = _str;
				_backSpaceHit = true;
			}
		}
		
		if (kReturn.keyInput) {
			if (inputType == InputType.history) {
				addToHistory(_str);
				_inputHistory ~= _str;
				_inputHistoryPos = cast(int)(_inputHistory.length);
				_x = 0;
				updateMeasure; //#new, untested
			}
		 	_enterPressed = true;
		}

		//#up key press
		if (kup.keyInput) {
			if (_inputHistory.length && _inputHistoryPos > 0) {
				--_inputHistoryPos;
				debug(5) mixin(trace("/* key up */ _inputHistoryPos"));
				textStr = _inputHistory[_inputHistoryPos];
				_x = cast(int)textStr.length;
				updateMeasure;
			}
		}

		if (kdown.keyInput) {
			if (_inputHistoryPos >= 0 && (_inputHistory.length > 0 && _inputHistoryPos < _inputHistory.length - 1)) {
				++_inputHistoryPos;
				debug(5) mixin(trace("/* key down */ _inputHistoryPos"));
				textStr = _inputHistory[_inputHistoryPos];
				_x = cast(int)textStr.length;
				updateMeasure;
			}
		}
		
		//#under construction
		if (kleft.keyInput && _x - 1 >= 0) {
			if (_x > _str.length) //#hack
				_x = cast(int)_str.length;
			else
				_x -= 1;
			debug(5) mixin(trace("/* left */ _str[0 .. _x]"));
			_measure.setString = _str[0 .. _x];
		}

		if (kright.keyInput && _x + 1 <= _str.length) {
			if (_x >= _str.length) //#hack
				_x = cast(int)_str.length;
			else
				_x += 1;
			debug(5) mixin(trace("/* right */ _str[0 .. _x]"));
			_measure.setString = _str[0 .. _x];
		}
		
		//#new
		if (Mouse.isButtonPressed(Mouse.Button.Left)
			||
			textStr == "l,") {
			debug(5)
				writeln("Left mouse button pressed!");
			_mousePos = Mouse.getPosition(g_window);
			foreach(button; _history) {
				if (_mousePos.x >= button.position.x
					&&
					_mousePos.x < button.position.x + button.getGlobalBounds.width
					&&
					_mousePos.y >= button.position.y
					&&
					_mousePos.y < button.position.y + button.getGlobalBounds.height) {
						_button = button.getString;
						debug(5) mixin(trace("/* button: */ _button"));
					}
			}
		}

		_cursor.position = Vector2f(_txt.position.x + _measure.getGlobalBounds.width, _measure.position.y); //#shouldn't be here
		//_cursor.size = Vector2f(2, _header.getGlobalBounds.height);
		_cursor.size = Vector2f(2, _header.getCharacterSize);
	} // process
	
	void addToHistory(T...)(T args) {
		import std.typecons: tuple;
		import std.conv: text;

		immutable str = text(tuple(args).expand);

		import std.file;
		if (_outPutToFile)
			append("history.txt", dateTimeString ~ " " ~ str ~ "\n");

		if (_outPutToTerminal)
			writeln(str),
			stdout.flush;
		if (! _outPutOnlyToTerminal) {
			moveHistoryUp;
		
			_history ~= new Text(str.to!dstring, g_font, _txt.getCharacterSize);
			_history[$ - 1].position = Vector2f(_header.position.x, _txt.position.y - _historyLineHeight);
			_history[$ - 1].setColor = _colour;
			
			_inputHistoryPos = cast(int)_inputHistory.length - 1;
		} // onlyMirror
	}
	
	void draw() {
		if (inputType == InputType.history && g_mode == Mode.edit && showHistory) {
			if (_edge) {
				foreach(line; _history) {
					immutable orgColour = line.getColor;
					immutable orgPos = line.position;

					scope(exit) {
						line.setColor = orgColour;
						line.position = orgPos;
					}

					line.setColor = Color(0,0,0);
					float posx = line.position.x - 1,
						posy = line.position.y - 1;
					foreach(y; 0 .. 3)
						foreach(x; 0 .. 3) {
							if (! (x == 1 && y == 1)) {
								line.position = Vector2f(posx + x, posy + y);
								g_window.draw(line);
							}
						}
				}
			}
			version(none) {
				foreach(line; _history) {
					if (line.position.y > 0)
						g_window.draw(line);
				}
			}
			import std.algorithm: filter, each;

			_history
			.filter!((a) => a.position.y >= 0)
			.each!drawLine;
		}
		if (g_terminal) {
			if (_edge) {
			}

			g_window.draw(_header);
			g_window.draw(_txt);
			
			g_window.draw(_cursor);
		}
	}
}

/**
 * Draw line of history
 */
auto drawLine(R)(R r, Text line) {
	g_window.draw(line);

	return r;
}
