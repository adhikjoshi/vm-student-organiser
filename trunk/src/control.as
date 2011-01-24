// File:			control.as
// Date:			15.01.2011
// Author:			Joshua Lau
// Description:		Calls all 'loading' and 'saving' i/o functions at beginning and end of program

public function readAll():void {
	readSubjectsXML();
	readNotes();
	
	getRefFile();
	updateHeaderBar();
	
	findOSUserName();
	getUserNamePrefs();
	
	readPeriods();
	
	getBellTimes();
	
	var todayDate:Date = new Date;
	getTodayPeriods(todayDate,weekType);
	displayPeriods();
	
	runTimer();
}

public function writeAll():void {
	writeSubjectsXML();
	writeNotes();
	writePeriods();
	writeUserNamePrefs();
}

private function runTimer():void {
	var secondTimer:Timer = new Timer(1000);
	
	secondTimer.addEventListener(TimerEvent.TIMER,runEverySecond);
	secondTimer.start();
}

private function runEverySecond(event:TimerEvent):void {
	updateHeaderBar();
	
	var todayDate:Date = new Date;
	getTodayPeriods(todayDate,weekType);
	displayPeriods();
}

