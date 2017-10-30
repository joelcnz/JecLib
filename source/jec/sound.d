//#hack, copied from dsfml.audio.soundsource;
//#not too flash!
module jec.sound;

import jec.base;

class JSound {
	string _fileName;
	SoundBuffer _buf;
	Sound _snd;
	float _pitch;

	//#hack, copied from dsfml.audio.soundsource;
	/// Enumeration of the sound source states.
	enum Status {
		/// Sound is not playing.
		Stopped,
		/// Sound is paused.
		Paused,
		/// Sound is playing.
		Playing
	}
	
	bool isPlaying() {
		import std.conv: asOriginalType;

		if (_snd.status.asOriginalType == Status.Playing)
			return true;
		else
			return false;
	}
	
	this(string fileName) {
		_fileName = fileName;
		_pitch = 0f;
		if (_buf is null) //#not too flash!
			load;
	}

	auto load() {
		import std.file : exists;
		import std.stdio : writeln;

		if (! _fileName.exists) {
			writeln(_fileName, " not found!");
			return ErrorType.notLoad;
		}

		_buf = new SoundBuffer;
		_buf.loadFromFile(_fileName);
		_snd = new Sound;
		_snd.setBuffer(_buf);

		return ErrorType.alright;
	}
	
	void setPitch(float pitch) {
		_snd.pitch(pitch);
	}
	
	void playSnd() {
		_snd.play;
	}
}

