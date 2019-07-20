module jec.setup;

import jec.base;

int setup() {
	foreach(tkey; Keyboard.Key.A .. Keyboard.Key.KeyCount)
		g_keys ~= new TKey(cast(Keyboard.Key)tkey);

	float take = 100;
	g_guiFile.setup([
		new Wedget("projects", Rect!float(20,20,300,400 - take)),
		new EditBox("save", Rect!float(20,425 - take,300,20), "Save name: "),
		new EditBox("load", Rect!float(20,450 - take,300,20), "Load name: "),
		new EditBox("rename", Rect!float(20,475 - take,300,20), "Rename: "),
		new EditBox("delete", Rect!float(20,500 - take,300,20), "Delete name: "),
		new Wedget("current", Rect!float(20,525 - take,300,20))
		]);
	g_guiFile.getWedgets[WedgetNum.projects].focusAble = false;
	g_guiFile.getWedgets[WedgetNum.current].focusAble = false;
	
	int xpos = 320;
	g_guiConfirm.setup([
		new Wedget("sure", Rect!float(xpos + 20,20,300,60)),
		new Button("no", Rect!float(xpos + 20,85,140,20), "No"),
		new Button("yes", Rect!float(xpos + 20 + 160,85,140,20), "Yes"),
	]);
	g_guiConfirm.getWedgets[WedgetConfirm.question].focusAble = false;

// (as follows) deprecated from now on (30 7 2017)
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