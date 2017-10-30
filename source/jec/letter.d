//#maybe change to just 'char'
//#draw letter
/// Letter
module jec.letter;

import std.stdio, std.string;
import jec;

/**
 * The letters that make up the text
 * 
 * May have the text bounce up and down
 */
class Lettera {
private:
	static int m_idCurrent = 0;
	static RectangleShape m_selectedGfx;
	int m_id;

	double m_xpos, m_ypos,
		m_xdir, m_ydir, m_width, m_height, m_roof, m_floor, m_xoff, m_yoff,
		abcol;
	char m_letter; //#maybe change to just 'char'
	Color m_colour, acol, bcol,
		m_altColour;
	bool m_alternate;
	ubyte m_shade;
	bool m_lock;
	bool m_selected;
	
	LetterManager m_letterManager;
public:
	@property ref auto xpos() { return m_xpos; } /// x position
	@property ref auto ypos() { return m_ypos; } /// y position
	@property ref auto letter() { return m_letter; } /// letter
	@property ref auto lock() { return m_lock; } /// lock state
	@property ref auto alternate() { return m_alternate; } /// alterating colour on/off switch
	@property ref auto altColour() { return m_altColour; } /// second colour for the alterating colour being on
	@property ref auto letterManager() { return m_letterManager; } /// 
	@property {
		void selected(bool selected) { m_selected = selected; }
		auto selected() { return m_selected; }
	}
	
	//void setPostion( double x, double y ) { xpos = x; ypos = y; } /// postion the letter
	void setPostion( double x, double y ) {
		//letterManager(cast(int)x,cast(int)y);
		xpos = x;
		ypos = y;
	}
	
	/// ctor new letter
	this(LetterManager letterManager0, char letter) {
		letterManager = letterManager0;
		m_id = m_idCurrent;
		++m_idCurrent;
		m_colour = Color(255, 180, 0);
		alternate = false;
		this.letter = letter;
		m_xdir = 0;
		m_ydir = -1;
		m_roof = -999;
		m_floor = 0;
		m_height = 3;
		m_xoff = m_yoff = 0;
		m_shade = 0;
		acol = Color(255, 0, 0), bcol = Color(0, 0, 255), abcol =  0.0;

		m_selectedGfx =  new RectangleShape();
		with(m_selectedGfx) {
			//position = Vector2f(xpos, ypos);
			size(Vector2f(letterManager.width, letterManager.height));
			fillColor = Color(64,64,255, 128);
		}

		debug {
//			if (letterManager.letters.length > 0)
//				mixin( traceLine( //"letterManager.bmpLetters[0].width", "letterManager.bmpLetters[0].height",
//									"letter", "letter & 0xFF", "letterManager.bmpLetters.length" ) );
			//mixin(traceLine("letterManager.bmpLetters[0]"));
		}
	}
	
	/// dtor for any Allegro C created stuff
	~this() {
		//clear( bmp ); //#need this, or crashes
	}
	
	/**
	 * For the letter behaviour(sp)
	 * 
	 * May:
	 * 
	 * 1. Bounce the letter up and down
	 * 
	 * 2. Keep changing the colour of the letter
	 */
	void update() {
		if ( m_roof == -999 ) {
			m_roof = -3, m_floor = 0;
		} else {
			m_yoff += m_ydir;
			float tmp = m_ydir;
			if ( m_yoff < m_roof )
				m_ydir = 1;

			if ( m_yoff > m_floor )
				m_ydir = -1;

			if ( tmp != m_ydir )
				 m_yoff -= m_ydir;
		}
		m_yoff = 0; //#to stop bouncing
		version(Windows)
			m_colour = Color(m_shade, m_shade, m_shade); //makecol( m_shade, m_shade, m_shade );
		m_shade += 5;
		
		abcol += 256 / 100 * 3;
		if ( abcol > 100.0 )
			abcol = 0.0;
	}
	
	//#draw letter
	/**
	 * Draw the letter
	 * 
	 * Draws:
	 * 
	 * 1. Alternating
	 * 
	 * 2. Changing colour
	 */
	void draw(RenderTexture stamp, Square square) {
		//mixin(traceList("xpos ypos letter&0xFF letterManager.width letterManager.height square.width square.height".split));
		if ((letter & 0xFF) >= 32
		  && xpos + letterManager.width >= 0
		  && xpos <= square.width - letterManager.width
		  && ypos + letterManager.height >= 0
		  && ypos <= square.height + letterManager.height) {
			if ( ! alternate ) {
				m_selectedGfx.position = m_letterManager.bmpLetters[letter].position = Vector2f(xpos, ypos);
				stamp.draw(m_letterManager.bmpLetters[letter]);
				if (m_selected)
					stamp.draw(m_selectedGfx);
			 }
			else {
			}
		} // if letter
	}
}
