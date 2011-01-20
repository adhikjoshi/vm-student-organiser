// File:			clock.as
// Date:			17.01.2011
// Author:			Joshua Lau
// Description:		Controls timing and dates for both topbar and for the entire application.

import flash.filesystem.*
import flash.utils.Timer
import flash.events.TimerEvent
import mx.controls.DateField

private var now:Date;

// true if week A
// false otherwise
public var weekType:Boolean;
public var weekNum:Number;
public var isHols:Boolean;

private var refDate:Date;
private var termNum:Number;
private var termDatesFile:String = "Organiser/termDates.xml";
public var refFile:XML;

private function runTimer():void {
	// makes a timer that ticks once per second
	// for infinity
	var secondTimer:Timer = new Timer(1000);
	
	// runs runEverySecond() once per second
	secondTimer.addEventListener(TimerEvent.TIMER,runEverySecond);
	secondTimer.start();
}

private function runEverySecond(event:TimerEvent):void {
	updateHeaderBar();	
}

private function updateHeaderBar():void {
	now = new Date();
	getRefDate();
	
	if(isHols == false) {
		findWeekDetails(refDate,true);
		headerLabel.text = getTimeString() + " | " + getDayNameString(now) + " Term " + String(termNum) + ", Week " + String(weekNum) + getWeekTypeString() + " | " + getDayString(now);
	} else {
		headerLabel.text = getTimeString() + " | " + getDayNameString(now) + " Holidays | " + getDayString(now);
	}
}

private function getTimeString():String {
	var numberToPad:Number = (now.getHours()%12);
	if(numberToPad == 0) {
		numberToPad = 12;
	}
	
	return padNum(numberToPad) + "." + padNum(now.getMinutes());
}

private function getRefFile():void {
	var file:File = File.documentsDirectory.resolvePath(termDatesFile);
	var fileStream:FileStream = new FileStream();
	fileStream.open(file,FileMode.READ);
	refFile = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
	fileStream.close();
}

private function getRefDate():void {
	var yearIndex:Number = getYearIndex();
	var termIndex:Number = getTermIndex(yearIndex);
	
	termNum = termIndex + 1;
	
	if(isHols == false) {
		refDate = DateField.stringToDate(refFile.year[yearIndex].term[termIndex].start,"YYYY/MM/DD");
	}
}

private function getYearIndex():Number {
	var thisYearIndex:Number;
	for(thisYearIndex=0;thisYearIndex < refFile.firstChild.children().length && refFile.firstChild.children()[thisYearIndex].attribute("num")!=now.getFullYear();thisYearIndex++) {
		// random comment here
	}
	return thisYearIndex;
}

private function getTermIndex(yearIndex:Number):Number {
	var termIndex:Number;
	isHols = false;
	for(termIndex=0;termIndex < refFile.year[yearIndex].term.length();termIndex++) {
		var start:String = refFile.year[yearIndex].term[termIndex].start;
		var end:String = refFile.year[yearIndex].term[termIndex].end;

		var thisDay:String = dateToString(now);
		if(start <= thisDay && thisDay <= end) {
			return termIndex;
		}
	}
	isHols = true;
	return termIndex;
}

private function findWeekDetails(termStartDate:Date,termStartWeekType:Boolean):void {
	weekType = termStartWeekType;
	weekNum = 1;
	
	var curDate:Date = termStartDate;
	
	while(curDate < now) {
		trace(curDate);
		curDate.setDate(curDate.getDate()+1);
		if(curDate.getDay() == 1) {
			// make weekly changes on mondays
			turnWeek();
		}
	}
}

private function turnWeek():void {
	weekType = !(weekType);
	weekNum++;
}

private function getWeekTypeString():String {
	if(weekType == true) {
		return "A";
	} else {
		return "B";
	}
}
