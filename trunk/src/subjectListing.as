// File:			subjectListing.as
// Date:			19.01.2011
// Author:			Joshua Lau
// Description:		A file handling the user's subjects

import flash.filesystem.*

public var numDaysCycle:Number = 10;

// before, [1..8], after
public var numPeriodsDay:Number = 10;

public var timeTable:XML;

[Bindable]
private var curDisplay:XML;

private var subjectsListingFile:String = "Organiser/subjectListing.xml";

private function readPeriods():void {
	var file:File = File.userDirectory.resolvePath(subjectsListingFile);
	
	var needRemake:Boolean = false;
	
	if(file.exists) {
		var fileStream:FileStream = new FileStream();
		fileStream.open(file,FileMode.READ);
		curDisplay = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
		fileStream.close();
		
		if(curDisplay.period.length == 0) {
			needRemake = true;
		}
	} else {
		needRemake = true;
	}
	
	if(needRemake == true) {
		curDisplay = XML("<subjects></subjects>");
	
		var i:Number;
		var j:Number;
		
		for(i=0;i<numPeriodsDay;i++) {
			curDisplay.appendChild(XML("<period></period>"));
			for(j=0;j<numDaysCycle;j++) {
				if(j == 0) {
					var periodName:String;
					if(i == 0) {
						periodName = "B";
					} else if(i == numPeriodsDay-1) {
						periodName = "A";
					} else {
						periodName = String(i);
					}
					curDisplay.period[i].appendChild(XML("<periodName>" + periodName + "</periodName>"));
				}
				curDisplay.period[i].appendChild(XML("<day" + j + "></day" + j + ">"));
			}
		}
	}
	cleanupXML();
	getSubjectsList();
	timeTable = XML(curDisplay.toXMLString());
}

private function writePeriods():void {
	cleanupXML();

	var file:File = File.userDirectory.resolvePath(subjectsListingFile);
	var fileStream:FileStream = new FileStream();
	fileStream.open(file,FileMode.WRITE);
	fileStream.writeUTFBytes(utfHeader + curDisplay.toXMLString());
	fileStream.close();
}
