// File:			clock.as
// Date:			17.01.2011
// Author:			Joshua Lau
// Description:		Controls timing and dates for both topbar and for the entire application.

import flash.filesystem.*
import flash.utils.Timer
import flash.events.TimerEvent

private var now:Date;

// true if week A
// false otherwise
public var weekType:Boolean;
public var weekNum:Number;
public var isHols:Boolean;

var refDate:Date;
var termDatesFile:String = "Organiser/termDates.xml";
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
	now = new Date();
	headerLabel.text = getTimeString() + " " + weekNum;
}

private function getTimeString():String {
	return ((padNum(now.getHours()%12)+1) + "." + padNum(now.getMinutes()));
}

private function getRefFile():void {
	var file:File = File.documentsDirectory.resolvePath(termDatesFile);
	var fileStream:FileStream = new FileStream();
	fileStream.open(file,FileMode.READ);
	refFile = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
	trace(refFile):
	fileStream.close();
}

private function getYearIndex():Number{
	var thisYearIndex:Number;
	for(thisYearIndex=0;thisYearIndex < refFile.firstChild.children().length && refFile.firstChild.children()[thisYearIndex].attribute("num")!=now.getFullYear();thisYearIndex++) {
		// random comment here
	}
	return thisYearIndex;
}

private function findWeekDetails(termStartDate:Date,termStartWeekType:Boolean):void {
	weekType = termStartWeekType;
	weekNum = 1;
	
	var curDate:Date = termStartDate;
	
	while(curDate < now) {
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
