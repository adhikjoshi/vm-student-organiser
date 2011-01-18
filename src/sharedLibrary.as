// File:			sharedLibrary.as
// Date:			15.01.2011
// Author:			Joshua Lau
// Description:		A collection of shared functions used throughout the application.

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
	var days:Array = ["Monday","Tuesday","Wednesday","Thursday","Friday"];
	return days[dateToConvert.getDay()];
}
