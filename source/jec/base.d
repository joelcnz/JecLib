//#new
//# need to add like sleep(50.dur!msecs);, not that it stops the tight loop!
//jexa>>
//misc>>
module jec.base;

//#Auto repeat not working ?
public {
	import dsfml.graphics;
	import dsfml.audio;
	import dsfml.window;
}

import std.stdio;
import std.datetime: Duration;
import std.datetime.stopwatch: StopWatch;

public import jec.base, jec.input, jec.jexting, jec.setup, jec.sound, jmisc;

enum ErrorType {notLoad = -1, alright = 0}

RenderWindow g_window;

//#made template instead of normal functions
float makeSquare(float a) {
	return cast(int)(a / g_spriteSize) * cast(float)g_spriteSize;
}

Vector2f makeSquare(Vector2f a) {
	return Vector2f(makeSquare(a.x), makeSquare(a.y));
}
/+
float makeSquare(T : float)(T a) {
	return cast(int)(a / g_spriteSize) * cast(float)g_spriteSize;
}

Vector2f makeSquare(T : Vector2f)(T a) {
	return Vector2f(makeSquare(a.x), makeSquare(a.y));
}
+/

/**
 * Handle keys, one hit buttons
 */
//#Auto repeat not working ?
class TKey {
	enum KeyState {up, down, startGap, smallGap}
	KeyState _keyState;
	static int _startPause = 200, _pauseTime = 40; // msecs
	StopWatch _stopWatchPause, _stopWatchStart;
	
	Keyboard.Key tKey;
	bool _keyDown;
	
	/**
	 * Constructor
	 */
	this(Keyboard.Key tkey0) {
		tKey = tkey0;
		_keyDown = false;
		_keyState = KeyState.up;
	}

	bool keyPressed() {
		return Keyboard.isKeyPressed(tKey) != 0;
	}

	bool keyTrigger() {
		if (Keyboard.isKeyPressed(tKey) && _keyDown == false) {
			_keyDown = true;
			return true;
		} else if (! Keyboard.isKeyPressed(tKey)) {
			_keyDown = false;
		}
		
		return false;
	}
	
	// returns true doing trigger other wise false saying the key is already down
	/** One hit key */
	/+
		Press key down, print the character. Keep holding down the key and the cursor move at a staggered pace.
		+/
	bool keyInput() { // eg. g_keys[Keyboard.Key.A].keyInput
		if (! Keyboard.isKeyPressed(tKey))
			_keyState = KeyState.up;

		if (Keyboard.isKeyPressed(tKey) && _keyState == KeyState.up) {
			_keyState = KeyState.down;
			_stopWatchStart.reset;
			_stopWatchStart.start;

			return true;
		}
		
		if (_keyState == KeyState.down && _stopWatchStart.peek.total!"msecs" > _startPause)  {
			_keyState = KeyState.smallGap;
			_stopWatchPause.reset;
			_stopWatchPause.start;
		}
		
		if (_keyState == KeyState.smallGap && _stopWatchPause.peek.total!"msecs" > _pauseTime) {
			_keyState = KeyState.down;
			
			return true;
		}
		
		return false;
	}

	/** hold key */
//	bool keyPress() {
//		return Keyboard.isKeyPressed(tKey) > 0;
//	}
}
// eg lkeys[Letter.p].keyTrigger
TKey[] lkeys;
enum Letter {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}
TKey[] nkeys;
enum Number {n0,n1,n2,n3,n4,n5,n6,n7,n8,n9}
TKey kBackSpace, kReturn, kSpace, kTab, kZ; //#what is with kZ? (eg. if (kReturn.keyTrigger) { ... }
enum ExtraKeys {LBracket, RBracket, SemiColon, Comma, Period, 
	Quote, Slash, BackSlash, Tilde, 
	Equal, Dash}
// ExtraKeys[kProb.slash]
enum kProb {slash = 6}
TKey[] ekeys;
TKey kup, kright, kdown, kleft;

auto trim(in string str) {
	if (str.length > 6 && str[0 .. 2] == "./")
		return str[2 .. $ - 4].dup;
	else
		return str.dup;
}

void keyHold(int key) {
	while(Keyboard.isKeyPressed(cast(Keyboard.Key)key)) { } //# need to add like sleep(50.dur!msecs);, not that it stops the tight loop!
	//while(Keyboard.isKeyPressed(cast(Keyboard.Key)key)) { sleep(50.dur!msecs); } // eg. keyHold(Keyboard.Key.Num0 + i);
}

bool g_terminal;

Texture g_texture;

Font g_font;

enum InputType {oneLine, history}
InputJex g_inputJex;
alias jx = g_inputJex;

enum Mode {play, edit}
Mode g_mode = Mode.play;

immutable int g_spriteSize;

TKey[] g_keys;

static this() {
	g_spriteSize = 32;
}

//jexa>>
private:
import std.ascii, std.conv, std.file, std.stdio, std.string;

public:
/** switch for weather to draw text, or cursor {text, input} */
enum g_Draw {text, input}

//alias std.ascii.newline newline;
auto newLine = "\n";

version(Windows) {
	char g_cr = newline[0]; /// carrage(sp) return
	char g_lf = newline[1]; /// line feed - main one
} else {
	char g_cr = newline[0]; /// carrage(sp) return
	char g_lf = newline[0];
}

bool g_doLetUpdate = true;

/// display box
struct Square {
	int xpos, /// x postion
		ypos, /// y postion
		width, /// width of square
		height; /// height of square
}

ubyte chr( int c ) {
	return c & 0xFF;
}
//jexa<<

debug = TDD; //#hack

import std.math;
auto distance(T)(PointVec!(2, T) a, PointVec!(2, T) b) {
    auto deltaX = a.X - b.X;
    auto deltaY = a.Y - b.Y;

	return sqrt((deltaX * deltaX) + (deltaY * deltaY));
}

auto distance(T,T2,T3,T4)(T x, T2 y, T3 x2, T4 y2) {
    auto deltaX = x - x2;
    auto deltaY = y - y2;

	return sqrt((deltaX * deltaX) + (deltaY * deltaY));
}
