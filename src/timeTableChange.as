// File:			timeTableChange.as
// Date:			22.01.2011
// Author:			Joshua Lau
// Description:		Handles changes in the timetable and updates accordingly. Quite slow.

import mx.controls.DateField

[Bindable]
public var subjectsList:Array;

// given a Date object, deletes all days after the given day
// inclusive!
private function deleteAllAfterDate(dateToDelete:Date):void {
	for(var i:Number = getDayIndex(dateToDelete,true);i < entries.day.length();i++) {
		entries.day[i].setName("toBeDeleted");
	}
	delete entries.toBeDeleted;
}

// given a Date object, return an XML containing
// blank entries for that day
private function createEntries(dateToCreate:Date):XML {
	var stub:XML = XML('<day date="' + dateToString(dateToCreate) + '"></day>');
	var curPeriodsToday:Array = [];
	
	var referencePackage:Object = getRefDate(dateToCreate);
	
	var weekDetailsObj:Object = findWeekDetails(referencePackage.rDate,referencePackage.rType,dateToCreate);
	var createWeekNum:Number = weekDetailsObj.weekNum;
	var createWeekType:Boolean = weekDetailsObj.weekType;
	
	for(var i:Number=0;i<curDisplay.period.length();i++) {
		var curPeriodName:String = curDisplay.period[i].child("day" + String(weekDetailsToIndex(dateToCreate.getDay(),createWeekType)));
		if(curPeriodName != "" && curPeriodsToday.indexOf(curPeriodName) == -1) {
			stub.appendChild(XML("<period><subject>" + curPeriodName + "</subject><tasks></tasks></period>"));
			curPeriodsToday.push(curPeriodName);
		}
	}
	return stub;
}

// update all in date range
private function updateRange(startRange:String,endRange:String,refDateStart:String):void {
	var startDate:Date = DateField.stringToDate(startRange,"YYYY/MM/DD");
	var endDate:Date = DateField.stringToDate(endRange,"YYYY/MM/DD");
	
	for(var curDate:Date=startDate;curDate <= endDate;curDate.setDate(curDate.getDate()+1)) {
		if(dateToString(curDate) >= refDateStart && curDate.getDay() != 0 && curDate.getDay() != 6) {
			entries.appendChild(createEntries(curDate));
		}
	}
}

// update from TODAY
private function updateEntries():void {
	cleanupXML();
	
	getSubjectsList();
	
	timeTable = XML(curDisplay.toXMLString());

	var today:Date = new Date;
	
	deleteAllAfterDate(today);
	
	var yearIndexToday:Number = getYearIndex(today);
	
	for(var i:Number=0;i<4;i++) {
		updateRange(refFile.year[yearIndexToday].term[i].start,refFile.year[yearIndexToday].term[i].end,dateToString(today));
	}
	
	// fix the diary entries :)
	changeDate(dateSelector.selectedDate);
}

private function cleanupXML():void {
	for(var j:Number=0;j<numPeriodsDay;j++) {
		for(var i:Number=0;i<numDaysCycle;i++) {
			while(curDisplay.period[j].child("day" + String(i)).mx_internal_uid.length() > 0)  {
				delete curDisplay.period[j].child("day" + String(i)).mx_internal_uid[curDisplay.period[j].child("day" + String(i)).mx_internal_uid.length()-1];
			}
		}
	}
}

private function getSubjectsList():void {
	subjectsList = [];
	for(var j:Number=0;j<numPeriodsDay;j++) {
		for(var i:Number=0;i<numDaysCycle;i++) {
			var thisSubject:String = curDisplay.period[j].child("day" + String(i));
			if(subjectsList.indexOf(thisSubject) == -1 && thisSubject != "") {
				subjectsList.push(thisSubject);
			}
		}
	}
	subjectsList.sort();
}
