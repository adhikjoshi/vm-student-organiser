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
		dateSelector.selectedDate = selectedDate;
		getDayTasks(getDayIndex(selectedDate,false));
	}
	getSelectedDateDetails();
}

public function changePrevDay():void {
	changeDate(new Date(dateSelector.selectedDate.time - MS_PER_DAY + 1));
}

public function changeNextDay():void {
	changeDate(new Date(dateSelector.selectedDate.time + MS_PER_DAY));
}

public function changeToday():void {
	changeDate(new Date);
}

public function getSelectedDateDetails():void {
	var selectedYearIndex:Number = getYearIndex(dateSelector.selectedDate);
	var selectedTermIndex:Number = getTermIndex(selectedYearIndex,dateSelector.selectedDate,false);
	
	if(selectedTermIndex == refFile.year[selectedYearIndex].term.length()) {
		selectedDateInfo.text = getDayNameString(dateSelector.selectedDate) + " Holidays " + String(dateSelector.selectedDate.getFullYear());
	} else {
		var selectedDateRef:Object = getRefDate(dateSelector.selectedDate);
		var selectedDateWeekDetails:Object = findWeekDetails(selectedDateRef.rDate, selectedDateRef.rType, dateSelector.selectedDate);
		selectedDateInfo.text = getDayNameString(dateSelector.selectedDate) + " Term " + String(selectedTermIndex+1) + ", Week " + String(selectedDateWeekDetails.weekNum) + getWeekTypeString(selectedDateWeekDetails.weekType) + " " + String(dateSelector.selectedDate.getFullYear());
	}
}
