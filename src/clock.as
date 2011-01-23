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
private var refType:Boolean;
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
	var referencePackage:Object = getRefDate(now);
	refDate = referencePackage.rDate;
	refType = referencePackage.rType;
	
	if(isHols == false) {
		var retObj:Object = findWeekDetails(refDate,refType,now);
		weekType = retObj.weekType;
		weekNum = retObj.weekNum;
		headerLabel.text = getTimeString() + " | " + getDayNameString(now) + " Term " + String(termNum) + ", Week " + String(weekNum) + getWeekTypeString(weekType) + " | " + getDayString(now);
	} else {
		headerLabel.text = getTimeString() + " | " + getDayNameString(now) + " Holidays | " + getDayString(now);
	}
}

private function getTimeString():String {
	var numberToPad:Number = now.getHours();

	return padNum(numberToPad) + "." + padNum(now.getMinutes());
}

private function getRefFile():void {
	var file:File = File.documentsDirectory.resolvePath(termDatesFile);
	var fileStream:FileStream = new FileStream();
	fileStream.open(file,FileMode.READ);
	refFile = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
	fileStream.close();
}

