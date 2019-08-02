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

	import std.math, std.conv, std.path;
}

import std.stdio;
import std.datetime: Duration;
import std.datetime.stopwatch: StopWatch;

public import jec.base, jec.input, jec.jexting, jec.setup, jec.sound, jmisc, jec.gui, jec.guifile, jec.guiconfirm;
//public import jec, jmisc;

enum ErrorType {notLoad = -1, alright = 0}
enum WedgetNum {projects, save, load, rename, del, current}
enum WedgetConfirm {question, no, yes}
enum FileAction {save, load, rename, del, nothing}

RenderWindow g_window;
GuiFile g_guiFile;
GuiConfirm g_guiConfirm;
RectangleShape g_progBarFill;
dstring g_currentProjectName;
dstring g_fileRootName;

byte decimalToByte(float value) {
	return cast(byte)(255 * value);
}

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
TKey[] g_keys; // g_keys[Keyboard.Key.T].keyTrigger

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

auto trim(T)(in T str) { //if (SomeString!T) {
	import std.path;
	if (str.length > 6 && str[0 .. 2] == "./")
		return str[2 .. $].stripExtension.dup;
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
enum Focus {off, on}
//enum EnterPressed {no, yes}

immutable int g_spriteSize;

shared static this() {
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

struct Colour {
	enum aliceblue = Color(240, 248, 255);
	enum antiquewhite = Color(250, 235, 215);
	enum aqua = Color(0, 255, 255);
	enum aquamarine = Color(127, 255, 212);
	enum azure = Color(240, 255, 255);
	enum beige = Color(245, 245, 220);
	enum bisque = Color(255, 228, 196);
	enum black = Color(0, 0, 0); // basic color
	enum blanchedalmond = Color(255, 235, 205);
	enum blue = Color(0, 0, 255); // basic color
	enum blueviolet = Color(138, 43, 226);
	enum brown = Color(165, 42, 42);
	enum burlywood = Color(222, 184, 135);
	enum cadetblue = Color(95, 158, 160);
	enum chartreuse = Color(127, 255, 0);
	enum chocolate = Color(210, 105, 30);
	enum coral = Color(255, 127, 80);
	enum cornflowerblue = Color(100, 149, 237);
	enum cornsilk = Color(255, 248, 220);
	enum crimson = Color(220, 20, 60);
	enum cyan = Color(0, 255, 255); // basic color
	enum darkblue = Color(0, 0, 139);
	enum darkcyan = Color(0, 139, 139);
	enum darkgoldenrod = Color(184, 134, 11);
	enum darkgray = Color(169, 169, 169);
	enum darkgreen = Color(0, 100, 0);
	enum darkgrey = Color(169, 169, 169);
	enum darkkhaki = Color(189, 183, 107);
	enum darkmagenta = Color(139, 0, 139);
	enum darkolivegreen = Color(85, 107, 47);
	enum darkorange = Color(255, 140, 0);
	enum darkorchid = Color(153, 50, 204);
	enum darkred = Color(139, 0, 0);
	enum darksalmon = Color(233, 150, 122);
	enum darkseagreen = Color(143, 188, 143);
	enum darkslateblue = Color(72, 61, 139);
	enum darkslategray = Color(47, 79, 79);
	enum darkslategrey = Color(47, 79, 79);
	enum darkturquoise = Color(0, 206, 209);
	enum darkviolet = Color(148, 0, 211);
	enum deeppink = Color(255, 20, 147);
	enum deepskyblue = Color(0, 191, 255);
	enum dimgray = Color(105, 105, 105);
	enum dimgrey = Color(105, 105, 105);
	enum dodgerblue = Color(30, 144, 255);
	enum firebrick = Color(178, 34, 34);
	enum floralwhite = Color(255, 250, 240);
	enum forestgreen = Color(34, 139, 34);
	enum fuchsia = Color(255, 0, 255);
	enum gainsboro = Color(220, 220, 220);
	enum ghostwhite = Color(248, 248, 255);
	enum gold = Color(255, 215, 0);
	enum goldenrod = Color(218, 165, 32);
	enum gray = Color(128, 128, 128); // basic color
	enum green = Color(0, 128, 0); // basic color
	enum greenyellow = Color(173, 255, 47);
	enum grey = Color(128, 128, 128); // basic color
	enum honeydew = Color(240, 255, 240);
	enum hotpink = Color(255, 105, 180);
	enum indianred = Color(205, 92, 92);
	enum indigo = Color(75, 0, 130);
	enum ivory = Color(255, 255, 240);
	enum khaki = Color(240, 230, 140);
	enum lavender = Color(230, 230, 250);
	enum lavenderblush = Color(255, 240, 245);
	enum lawngreen = Color(124, 252, 0);
	enum lemonchiffon = Color(255, 250, 205);
	enum lightblue = Color(173, 216, 230);
	enum lightcoral = Color(240, 128, 128);
	enum lightcyan = Color(224, 255, 255);
	enum lightgoldenrodyellow = Color(250, 250, 210);
	enum lightgray = Color(211, 211, 211);
	enum lightgreen = Color(144, 238, 144);
	enum lightgrey = Color(211, 211, 211);
	enum lightpink = Color(255, 182, 193);
	enum lightsalmon = Color(255, 160, 122);
	enum lightseagreen = Color(32, 178, 170);
	enum lightskyblue = Color(135, 206, 250);
	enum lightslategray = Color(119, 136, 153);
	enum lightslategrey = Color(119, 136, 153);
	enum lightsteelblue = Color(176, 196, 222);
	enum lightyellow = Color(255, 255, 224);
	enum lime = Color(0, 255, 0);
	enum limegreen = Color(50, 205, 50);
	enum linen = Color(250, 240, 230);
	enum magenta = Color(255, 0, 255); // basic color
	enum maroon = Color(128, 0, 0);
	enum mediumaquamarine = Color(102, 205, 170);
	enum mediumblue = Color(0, 0, 205);
	enum mediumorchid = Color(186, 85, 211);
	enum mediumpurple = Color(147, 112, 219);
	enum mediumseagreen = Color(60, 179, 113);
	enum mediumslateblue = Color(123, 104, 238);
	enum mediumspringgreen = Color(0, 250, 154);
	enum mediumturquoise = Color(72, 209, 204);
	enum mediumvioletred = Color(199, 21, 133);
	enum midnightblue = Color(25, 25, 112);
	enum mintcream = Color(245, 255, 250);
	enum mistyrose = Color(255, 228, 225);
	enum moccasin = Color(255, 228, 181);
	enum navajowhite = Color(255, 222, 173);
	enum navy = Color(0, 0, 128);
	enum oldlace = Color(253, 245, 230);
	enum olive = Color(128, 128, 0);
	enum olivedrab = Color(107, 142, 35);
	enum orange = Color(255, 165, 0);
	enum orangered = Color(255, 69, 0);
	enum orchid = Color(218, 112, 214);
	enum palegoldenrod = Color(238, 232, 170);
	enum palegreen = Color(152, 251, 152);
	enum paleturquoise = Color(175, 238, 238);
	enum palevioletred = Color(219, 112, 147);
	enum papayawhip = Color(255, 239, 213);
	enum peachpuff = Color(255, 218, 185);
	enum peru = Color(205, 133, 63);
	enum pink = Color(255, 192, 203);
	enum plum = Color(221, 160, 221);
	enum powderblue = Color(176, 224, 230);
	enum purple = Color(128, 0, 128);
	enum red = Color(255, 0, 0); // basic color
	enum rosybrown = Color(188, 143, 143);
	enum royalblue = Color(65, 105, 225);
	enum saddlebrown = Color(139, 69, 19);
	enum salmon = Color(250, 128, 114);
	enum sandybrown = Color(244, 164, 96);
	enum seagreen = Color(46, 139, 87);
	enum seashell = Color(255, 245, 238);
	enum sienna = Color(160, 82, 45);
	enum silver = Color(192, 192, 192);
	enum skyblue = Color(135, 206, 235);
	enum slateblue = Color(106, 90, 205);
	enum slategray = Color(112, 128, 144);
	enum slategrey = Color(112, 128, 144);
	enum snow = Color(255, 250, 250);
	enum springgreen = Color(0, 255, 127);
	enum steelblue = Color(70, 130, 180);
	enum ctan = Color(210, 180, 140);
	enum teal = Color(0, 128, 128);
	enum thistle = Color(216, 191, 216);
	enum tomato = Color(255, 99, 71);
	enum turquoise = Color(64, 224, 208);
	enum violet = Color(238, 130, 238);
	enum wheat = Color(245, 222, 179);
	enum white = Color(255, 255, 255); // basic color
	enum whitesmoke = Color(245, 245, 245);
	enum yellow = Color(255, 255, 0); // basic color
	enum yellowgreen = Color(154, 205, 50);
}
