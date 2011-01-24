// File:			sharedLibrary.as
// Date:			15.01.2011
// Author:			Joshua Lau
// Description:		A collection of shared functions used throughout the application.

public var utfHeader:String = '<?xml version="1.0" encoding="utf-8"?>\n';

// pads a number to 2 digits
public function padNum(numToPad:Number):String {
	var finalString:String = String(numToPad);
	if(numToPad < 10) {
		finalString = "0" + finalString;
	}
	return finalString;
}

// converts a Date object to a (padded)
// YYYY/MM/DD string
public function dateToString(dateToConvert:Date):String {
	var dateNum:Number = dateToConvert.getDate();
	var monthNum:Number = dateToConvert.getMonth() + 1;
	var yearNum:Number = dateToConvert.getFullYear();
	
	return String(yearNum) + "/" + padNum(monthNum) + "/" + padNum(dateNum);
}

// converts a date object into a string with format
// <date> <month name> <full year>
public function getDayString(dateToConvert:Date):String {
	var months:Array = ["January","February","March","April","May","June","July","August","September","October","November","December"];
	return String(dateToConvert.getDate()) + " " + months[dateToConvert.getMonth()] + " " + String(dateToConvert.getFullYear());
}

// converts a date object into a string with day's name
public function getDayNameString(dateToConvert:Date):String {
	var days:Array = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
	return days[dateToConvert.getDay()];
}

private function findWeekDetails(termStartDate:Date,termStartWeekType:Boolean,compDate:Date):Object {
	weekType = termStartWeekType;
	weekNum = 1;
	
	var curDate:Date = termStartDate;
	
	while(curDate < compDate) {
		curDate.setDate(curDate.getDate()+1);
		if(curDate.getDay() == 1) {
			// make weekly changes on mondays
			weekType = !weekType;
			weekNum++;
		}
	}
	
	var retObj:Object = {
		weekType:weekType,
		weekNum:weekNum
	};
	
	return retObj;
}

private function getYearIndex(dateToGet:Date):Number {
	var thisYearIndex:Number;
	for(thisYearIndex=0;thisYearIndex < refFile.firstChild.children().length && refFile.firstChild.children()[thisYearIndex].attribute("num")!=dateToGet.getFullYear();thisYearIndex++) {
		// random comment here
	}
	return thisYearIndex;
}

private function getTermIndex(yearIndex:Number,dateToGet:Date,adjustHols:Boolean):Number {
	var termIndex:Number;
	
	if(adjustHols) {
		isHols = false;
	}
	for(termIndex=0;termIndex < refFile.year[yearIndex].term.length();termIndex++) {
		var start:String = refFile.year[yearIndex].term[termIndex].start;
		var end:String = refFile.year[yearIndex].term[termIndex].end;

		var thisDay:String = dateToString(dateToGet);
		if(start <= thisDay && thisDay <= end) {
			return termIndex;
		}
	}
	if(adjustHols) {
		isHols = true;
	}
	return termIndex;
}

private function getWeekTypeString(wt:Boolean):String {
	if(wt == true) {
		return "A";
	} else {
		return "B";
	}
}

// given a Date object, finds the index
// of the XML child that matches the given day
// (or the day immediately after it) OPTIONAL
// returns N if there is none
public function getDayIndex(dateToSearch:Date,findNearest:Boolean):Number {
	var curDate:String = dateToString(dateToSearch);
	
	var curIndex:Number = 0;
	
	if(findNearest == true) {
		for(curIndex = 0;curIndex < entries.day.length() && entries.day[curIndex].attribute("date") < curDate;curIndex++) {
			// this block of code is only here so that Flex doesn't pull a WARNING on me :(
		}
	} else {
		for(curIndex = 0;curIndex < entries.day.length() && entries.day[curIndex].attribute("date") != curDate;curIndex++) {
			// this block of code is only here so that Flex doesn't pull a WARNING on me :(
		}
	}
	
	return curIndex;
}

// hashes a day and weekType to index
public function weekDetailsToIndex(dayNum:Number,wt:Boolean):Number {
	if(wt == true) {
		return dayNum-1;
	} else {
		return dayNum+4;
	}
}

private function getRefDate(dateToGet:Date):Object {
	var yearIndex:Number = getYearIndex(dateToGet);
	var termIndex:Number = getTermIndex(yearIndex,dateToGet,true);
	
	termNum = termIndex + 1;
	
	var finalRefDate:Date;
	var finalRefType:Boolean;
	
	if(isHols == false) {
		finalRefDate = DateField.stringToDate(refFile.year[yearIndex].term[termIndex].start,"YYYY/MM/DD");
		var refTypeWeekString:String = refFile.year[yearIndex].term[termIndex].type;
		if(refTypeWeekString == "A") {
			finalRefType = true;
		} else {
			finalRefType = false;
		}
	}
	
	var retObj:Object = {
		rDate:finalRefDate,
		rType:finalRefType
	};
	
	return retObj;
}

private function getTimeString(dateToConvert:Date):String {
	var numberToPad:Number = dateToConvert.getHours();
	return padNum(numberToPad) + "." + padNum(dateToConvert.getMinutes());
}

