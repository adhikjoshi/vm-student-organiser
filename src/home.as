// File:			home.as
// Date:			01/02/2011
// Author:			Joshua Lau
// Description:		Computes data for the home tab

[Bindable]
public var latestHomeWork:Array;

private function updateAllSubjects():void {
	subjectsList.sort();

	latestHomeWork = new Array();
	for each (var subjectName:String in subjectsList) {
		findLastEntry(subjectName);
	}
}

private function findLastEntry(subjectName:String):void {
	var todayDate:Date = new Date;
	var todayIndex = getDayIndex(todayDate,false);

	for(var j:Number=todayIndex;j>=0;j--) {
		for(var i:Number=0;i<entries.day[j].period.length();i++) {
			if(entries.day[j].period[i].subject == subjectName) {
				latestHomeWork.push({subject:subjectName, lastEntry:entries.day[j].period[i].tasks});
				return;
			}
		}
	}
	
	latestHomeWork.push({subject:subjectName, lastEntry:""});
}
