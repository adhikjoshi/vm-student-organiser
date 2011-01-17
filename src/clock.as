// File:			clock.as
// Date:			17.01.2011
// Author:			Joshua Lau
// Description:		Controls timing and dates for both topbar and for the entire application.

import flash.utils.Timer
import flash.events.TimerEvent

private var now:Date;

// true if week A
// false otherwise
public var weekType:Boolean;
public var weekNum:Number;
public var isHols:Boolean;

private function runTimer():void {
	// makes a timer that ticks once per second
	// for infinity
	var secondTimer = new Timer(1000);
	
	// runs runEverySecond() once per second
	secondTimer.addEventListener(TimerEvent.TIMER,runEverySecond);
	secondTimer.start();
}

private function runEverySecond(event:TimerEvent):void {
	now = new Date();
	headerLabel.text = now.toString();
}

private function getTimeString():String {
	return ((padNum(now.getHours()%12)+1) + "." + padNum(now.getMinutes()));
}

private function findWeekDetails(termStartDate,termStartWeekType):void {
	weekType = termStartWeekType;
	weekNum = 1;
	
	var curDate:Date = now;
	
	while(curDate < termStartDate) {
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
