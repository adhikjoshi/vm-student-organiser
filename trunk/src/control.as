// File:			control.as
// Date:			15.01.2011
// Author:			Joshua Lau
// Description:		Calls all 'loading' and 'saving' i/o functions at beginning and end of program

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

