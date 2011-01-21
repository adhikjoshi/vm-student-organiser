import mx.core.ScrollPolicy

public function readAll():void {
	readSubjectsXML();
	readNotes();
	
	getRefFile();
	updateHeaderBar();
	runTimer();
	
	findOSUserName();
	getUserNamePrefs();
	
	readPeriods();
}

public function writeAll():void {
	writeSubjectsXML();
	writeNotes();
	writePeriods();
	writeUserNamePrefs();
}

