module jec.setup;

import jec.base;

int setup() {
	foreach(tkey; Keyboard.Key.A .. Keyboard.Key.KeyCount)
		g_keys ~= new TKey(cast(Keyboard.Key)tkey);
// deprecated from now on (30 7 2017)
	foreach(k; Keyboard.Key.A .. Keyboard.Key.Z + 1)
		lkeys ~= new TKey(cast(Keyboard.Key)k); //#why do I need the cast!?

	foreach(k; Keyboard.Key.Num0 .. Keyboard.Key.Num9 + 1)
			nkeys ~= new TKey(cast(Keyboard.Key)k);

	foreach(k; Keyboard.Key.LBracket .. Keyboard.Key.Dash + 1)
		ekeys ~= new TKey(cast(Keyboard.Key)k);

	kBackSpace = new TKey(Keyboard.Key.BackSpace);
	kReturn = new TKey(Keyboard.Key.Return);
	kSpace = new TKey(Keyboard.Key.Space);

	kup = new TKey(Keyboard.Key.Up);
	kright = new TKey(Keyboard.Key.Right);
	kdown = new TKey(Keyboard.Key.Down);
	kleft = new TKey(Keyboard.Key.Left);
	
	return 0;
}