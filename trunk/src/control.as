// File:			control.as
// Date:			15.01.2011
// Author:			Joshua Lau
// Description:		Calls all 'loading' and 'saving' i/o functions at beginning and end of program

public function init():void {
	organisePeriods();
	readAll();
}

public function readAll():void {
	dateSelector.selectedDate = new Date;

	readSubjectsXML();
	readNotes();
	
	readEvents();
	
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
	updateAllSubjects();
	
	getUpcomingEvents();
	
	getSelectedDateDetails();
	
	// autosort
	eventsAssignments.dispatchEvent(new DataGridEvent(DataGridEvent.HEADER_RELEASE, false, true, 2, null, 0, null, null, 0));
	nextWeekAssignments.dispatchEvent(new DataGridEvent(DataGridEvent.HEADER_RELEASE, false, true, 1, null, 0, null, null, 0));
	nextWeekEvents.dispatchEvent(new DataGridEvent(DataGridEvent.HEADER_RELEASE, false, true, 1, null, 0, null, null, 0));
}

public function writeAll():void {
	writeSubjectsXML();
	writeNotes();
	writePeriods();
	writeUserNamePrefs();
	writeEvents();
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

private function organisePeriods():void {
	var storageDirectory:File = File.userDirectory.resolvePath("Organiser");
	storageDirectory.createDirectory();
	
	var destBellTimes:File = File.userDirectory.resolvePath("Organiser/bellTimes.xml");
	var srcBellTimes:File = File.applicationDirectory.resolvePath("data/bellTimes.xml");
	srcBellTimes.copyTo(destBellTimes,true);
	
	var destTermDates:File = File.userDirectory.resolvePath("Organiser/termDates.xml");
	var srcTermDates:File = File.applicationDirectory.resolvePath("data/termDates.xml");
	srcTermDates.copyTo(destTermDates,true);
}
