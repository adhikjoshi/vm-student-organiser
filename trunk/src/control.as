public function readAll():void {
	readSubjectsXML();
	readNotes();
	
	findOSUserName();
	getUserNamePrefs();
	
	readPeriods();
	
	getRefFile();
	updateHeaderBar();
	runTimer();
}

public function writeAll():void {
	writeSubjectsXML();
	writeNotes();
	writePeriods();
	writeUserNamePrefs();
}

