// File:			handleSubjects.as
// Date:			14.01.2011
// Author:			Joshua Lau
// Description:		A file which handles file i/o and changes to the diary section

import mx.collections.XMLListCollection;
import mx.events.DataGridEvent;
import mx.events.CalendarLayoutChangeEvent;
import flash.filesystem.*;

[Bindable]
public var entries:XML;

[Bindable]
public var curDayTasks:XMLList;
public var curDay:Number;

// might have to make this file beforehand
// files are in [documents]/Organiser/
private var subjectsFile:String = "Organiser/subjects.xml";

public function readSubjectsXML():void {
	var file:File = File.documentsDirectory.resolvePath(subjectsFile);
	
	if(file.exists) {
		var fileStream:FileStream = new FileStream();
		fileStream.open(file, FileMode.READ);
		entries = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
	
		fileStream.close();
		
		var now:Date = new Date();
		dateSelector.selectedDate = new Date();
		getDayTasks( getDayIndex(now) );
	}
}

public function writeSubjectsXML():void {
	var file:File = File.documentsDirectory.resolvePath(subjectsFile);
	var fileStream:FileStream = new FileStream();
	fileStream.open(file, FileMode.WRITE);
	
	var outputString:String = utfHeader + entries.toXMLString();
	
	fileStream.writeUTFBytes(outputString);
	fileStream.close();
}

// given an index for the xml's children,
// copy the data into the bindable xml structure
public function getDayTasks(index:Number):void {
	if(index < entries.day.length()) {
		curDay = index;
		curDayTasks = new XMLList(entries.day[index].toXMLString());
	} else {
		// handle error here: no entry for date
		curDayTasks = new XMLList("<day></day>");
	}
}

public function writeDayTasks():void {
	entries.day[curDay] = curDayTasks;
}

// given a Date object, finds the index
// of the XML child that matches the given day
// (or the day immediately after it) OPTIONAL
// returns N if there is none
public function getDayIndex(dateToSearch:Date):Number {
	var curDate:String = dateToString(dateToSearch);
	
	var curIndex:Number = 0;
	for(curIndex = 0;curIndex < entries.day.length() && entries.day[curIndex].attribute("date") != curDate;curIndex++) {
		// this block of code is only here so that Flex doesn't pull a WARNING on me :(
	}
	
	return curIndex;
}

// updates the day which is in focus
public function useDate(eventObj:CalendarLayoutChangeEvent):void {
	// Make sure selectedDate is not null.
	if (eventObj.currentTarget.selectedDate == null) {
		return 
	}

	var selectedDate:Date = eventObj.currentTarget.selectedDate;
	getDayTasks(getDayIndex(selectedDate));
}
