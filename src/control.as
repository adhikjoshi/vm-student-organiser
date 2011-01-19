public function readAll():void {
	readSubjectsXML();
	readNotes();
	
	findOSUserName();
	getUserNamePrefs();
	
	getRefFile();
	updateHeaderBar();
	runTimer();
}

public function writeAll():void {
	writeSubjectsXML();
	writeNotes();
	writeUserNamePrefs();
}

