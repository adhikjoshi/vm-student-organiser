// File:			handleNotes.as
// Date:			14.01.2011
// Author:			Joshua Lau
// Description:		Handles the notes section of the application, mainly file i/o.

import flash.filesystem.*

private var notesFile:String = "Organiser/notes.txt";

public function readNotes():void {
	var file:File = File.documentsDirectory.resolvePath(notesFile);
	
	if(file.exists) {
		var fileStream:FileStream = new FileStream();
		fileStream.open(file,FileMode.READ);
		var inputString:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
		notesArea.text = inputString;
		fileStream.close();
	}
}

public function writeNotes():void {
	var file:File = File.documentsDirectory.resolvePath(notesFile);
	var fileStream:FileStream = new FileStream();
	fileStream.open(file,FileMode.WRITE);
	fileStream.writeUTFBytes(notesArea.text);
	fileStream.close();
}
