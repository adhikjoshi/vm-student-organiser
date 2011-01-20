// File:			subjectListing.as
// Date:			19.01.2011
// Author:			Joshua Lau
// Description:		A file handling the user's subjects

import flash.filesystem.*

// "" represents no period
private var allSubjects:Array = ["","Maths","English","Science","History","Geography","Agriculture","PE","IPT","SDD","Commerce","Drama","Japanese","German","French","Music"];

public var numDaysCycle:Number = 10;

// before, [1..8], after
public var numPeriodsDay:Number = 10;

[Bindable]
public var curDisplayList:XMLList;
private var curDisplay:XML;
private var curPeriods:XML;

private var subjectsListingFile:String = "Organiser/subjectListing.xml";

private function readPeriods():void {
	var file:File = File.documentsDirectory.resolvePath(subjectsListingFile);
	
	if(file.exists) {
		var fileStream:FileStream = new FileStream();
		fileStream.open(file,FileMode.READ);
		curPeriods = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
		fileStream.close();
	} else {
		curPeriods = XML("<subjects></subjects>");
	
		var i:Number;
		var j:Number;
		
		for(i=0;i<numDaysCycle;i++) {
			curPeriods.appendChild(XML("<day></day>"));
			for(j=0;j<numPeriodsDay;j++) {
				curPeriods.day[i].appendChild(XML("<period></period>"));
			}
		}
	}
}

private function writePeriods():void {
	var file:File = File.documentsDirectory.resolvePath(subjectsListingFile);
	var fileStream:FileStream = new FileStream();
	fileStream.open(file,FileMode.WRITE);
	fileStream.writeUTFBytes(utfHeader + curPeriods.toXMLString());
	fileStream.close();
}

private function convertPeriodsToDisplay():void {
	curDisplay = XML("<subjects></subjects>");

	var i:Number;
	var j:Number;
	
	for(i=0;i<numPeriodsDay;i++) {
		curDisplay.appendChild(XML("<period></period>"));
	}
	
	for(i=0;i<curPeriods.day.length();i++) {
		for(j=0;j<curPeriods.day[i].period.length();j++) {
			if(i == 0) {
				var periodName:String;
				if(j == 0) {
					periodName = "B";
				} else if(j == curPeriods.day[i].period.length()-1) {
					periodName = "A";
				} else {
					periodName = String(j);
				}
				curDisplay.period[j].appendChild(XML("<periodName>" + periodName + "</periodName>"));
			}
			
			curDisplay.period[j].appendChild(XML("<day" + i + ">" + curPeriods.day[i].period[j] + "</day" + i + ">"));
		}
	}
	
	curDisplayList = curDisplay.period;
}
