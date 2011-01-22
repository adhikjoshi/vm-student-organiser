// File:			timeTableChange.as
// Date:			22.01.2011
// Author:			Joshua Lau
// Description:		Handles changes in the timetable and updates accordingly. Quite slow.

import mx.controls.DateField

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
		if(dateToString(curDate) >= refDateStart) {
			entries.appendChild(createEntries(curDate));
		}
	}
}

// update from TODAY
private function updateEntries():void {
	var today:Date = new Date;
	
	deleteAllAfterDate(today);
	
	var yearIndexToday:Number = getYearIndex(today);
	
	for(var i:Number=0;i<4;i++) {
		updateRange(refFile.year[yearIndexToday].term[i].start,refFile.year[yearIndexToday].term[i].end,dateToString(today));
	}
	
	// fix the diary entries :)
	changeDate(dateSelector.selectedDate);
}
