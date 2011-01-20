public function readAll():void {
	readSubjectsXML();
	readNotes();
	
	findOSUserName();
	getUserNamePrefs();
	
	readPeriods();
	convertPeriodsToDisplay();
	
	getRefFile();
	updateHeaderBar();
	runTimer();
	
	subjectChooser.height = subjectChooser.measureHeightOfItems(0, 10) + subjectChooser.headerHeight;
}

public function writeAll():void {
	writeSubjectsXML();
	writeNotes();
	writePeriods();
	writeUserNamePrefs();
}

