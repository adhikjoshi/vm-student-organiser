// File:			sidebar.as
// Date:			23.01.11
// Author:			Joshua Lau
// Description:		Controls the sidebar

import flash.filesystem.*

private var bellTimes:XML;
private var todayPeriods:Array;
private var bellTimesFile:String = "Organiser/bellTimes.xml";

private var pastPeriodColour:String = "#888888";
private var currentPeriodColour:String = "#000000";
private var upcomingPeriodColour:String = "#444444";

private var tabStopsSetting:String = "<TEXTFORMAT TABSTOPS='50'>";
private var closeTabStopsSetting:String = "</TEXTFORMAT>";

private function getBellTimes():void {
	var file:File = File.documentsDirectory.resolvePath(bellTimesFile);
	var fileStream:FileStream = new FileStream;
	
	fileStream.open(file,FileMode.READ);
	bellTimes = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
	fileStream.close();
}

private function displayPeriods():void {
	var periodDisplayString:String = "";
	var currentPeriod:Number = findCurrentPeriod();
	
	for(var i:Number=2;i<todayPeriods.length-2;i++) {
		if(i == currentPeriod || i == currentPeriod + 1) {
			periodDisplayString += '<font color="' + currentPeriodColour + '">';
		} else if(i < currentPeriod) {
			periodDisplayString += '<font color="' + pastPeriodColour + '">';
		} else {
			periodDisplayString += '<font color="' + upcomingPeriodColour + '">';
		}
		
		periodDisplayString += todayPeriods[i]
	
		if(i%2 == 0) {
			periodDisplayString += "\t\t| ";
		} else {
			periodDisplayString += "\n";
		}
		
		periodDisplayString += "</font>";
	}
	
	sideBarText.htmlText = tabStopsSetting + periodDisplayString + closeTabStopsSetting;
}

// finds for NOW
private function findCurrentPeriod():Number {
	var timeNow:Date = new Date;
	var timeNowString:String = getTimeString(timeNow);
	
	if(timeNowString < todayPeriods[0]) {
		return 0;
	} else {
		for(var i:Number=0;i<todayPeriods.length-2;i+=2) {
			if(todayPeriods[i+2] > timeNowString &&
				todayPeriods[i] <= timeNowString) {
				return i;
			}
		}
		return todayPeriods.length;
	}
}

// returns an array of periods and times
private function getTodayPeriods(dateToGet:Date,wt:Boolean):void {
	var weekIndexToGet:Number = weekDetailsToIndex(dateToGet.getDay(),wt);
	var dayTypeIndexToGet:Number = dayTypeIndex(dateToGet,wt);

	var periodAndTimes:Array = [];
	var curBreakIndex:Number = 0;
	
	periodAndTimes.push("00.00","Midnight");
	
	for(var i:Number=0;i<curDisplay.period.length();i++) {
		var periodHere:String = curDisplay.period[i].child("day" + String(weekIndexToGet));
		if(periodHere != "") {
			periodAndTimes.push(bellTimes.day[dayTypeIndexToGet].period[i]);
			periodAndTimes.push(periodHere);
		}
	}
	
	for(var i:Number=0;i<bellTimes.day[dayTypeIndexToGet].rest.length();i++) {
		var breakTime:String = bellTimes.day[dayTypeIndexToGet].rest[i];
	
		var j:Number;
		for(j=0;j<periodAndTimes.length;j+=2) {
			if( (j == 0 && breakTime < periodAndTimes[j]) ||
				(periodAndTimes[j-2] < breakTime && breakTime < periodAndTimes[j])) {
				break;
			}
		}
		
		periodAndTimes.splice(j,0,breakTime,bellTimes.day[dayTypeIndexToGet].rest[i].attribute("name"));
	}
	
	periodAndTimes.push("23.59","Midnight");
	
	todayPeriods = periodAndTimes;
}

private function dayTypeIndex(dateToCheck:Date,weekType:Boolean):Number {
	var dayNum:Number = dateToCheck.getDay();
	if(dayNum != 0 && dayNum != 6) {
		if(dayNum == 3) {
			return 1;
		} else if(dayNum == 5) {
			return 4;
		} else if(dayNum == 4) {
			if(weekType == true) {
				return 2;
			} else {
				return 3;
			}
		} else {
			return 0;
		}
	} else {
		return -1;
	}
}

