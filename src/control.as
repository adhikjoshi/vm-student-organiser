public function readAll():void {
	readSubjectsXML();
	readNotes();
	getRefFile();
	updateHeaderBar();
	runTimer();
}

public function writeAll():void {
	writeSubjectsXML();
	writeNotes();
}

