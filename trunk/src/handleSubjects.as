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
	var file:File = File.userDirectory.resolvePath(subjectsFile);
	
	if(file.exists) {
		var fileStream:FileStream = new FileStream();
		fileStream.open(file, FileMode.READ);
		entries = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
	
		fileStream.close();
		
		var now:Date = new Date();
		dateSelector.selectedDate = new Date();
		getDayTasks( getDayIndex(now,false) );
	} else {
		entries = XML("<subjects></subjects>");
	}
}

public function writeSubjectsXML():void {
	var file:File = File.userDirectory.resolvePath(subjectsFile);
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

// updates the day which is in focus
public function useDate(eventObj:CalendarLayoutChangeEvent):void {
	// Make sure selectedDate is not null.
	changeDate(eventObj.currentTarget.selectedDate);
}

public function changeDate(selectedDate:Date):void {
	if(selectedDate != null) {
		getDayTasks(getDayIndex(selectedDate,false));
	}
}
