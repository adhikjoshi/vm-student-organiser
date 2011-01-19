// File:			prefs.as
// Date:			19.01.2011
// Author:			Joshua Lau
// Description:		File handling the user preferences tab

import flash.filesystem.*

public var classList:Array = ["7A","7K","7L","7T","8A","8K","8L","8T","9A","9C","9K","9L","9T","10A","10C","10K","10L","10T","11A","11C","11K","11L","11T","11Z","12A","12C","12K","12L","12T","12Z"];

public var userName:String = "";
public var osUserName:String;
public var userClass:String;

private var userNamePrefs:XML;
private var userNameFile:String = "Organiser/userNamePrefs.xml";

private function findOSUserName():void {
	var userDir:String = File.userDirectory.nativePath;
	osUserName = userDir.substr(userDir.lastIndexOf(File.separator) + 1);
}

private function saveUserDetails():void {
	userName = userNameField.text;
	userClass = classField.selectedLabel;
	
	userNamePrefs.userName = userName;
	userNamePrefs.userClass = userClass;
	displayUserDetails();
}

private function displayUserDetails():void {
	userInfoLabel.text = "Personal Organiser for: " + userName + " (" + osUserName + ") Class: " + userClass;
}

private function getUserNamePrefs():void {
	var file:File = File.documentsDirectory.resolvePath(userNameFile);
	var fileStream:FileStream = new FileStream();
	fileStream.open(file,FileMode.READ);
	userNamePrefs = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
	fileStream.close();
	
	userName = userNamePrefs.userName;
	userClass = userNamePrefs.userClass;
	
	userNameField.text = userName;
	classField.selectedIndex = classList.indexOf(userClass);
	
	if(userName != "") {
		displayUserDetails();
	}
}

private function writeUserNamePrefs():void {
	var file:File = File.documentsDirectory.resolvePath(userNameFile);
	var fileStream:FileStream = new FileStream();
	fileStream.open(file,FileMode.WRITE);
	fileStream.writeUTFBytes(utfHeader + userNamePrefs.toXMLString());
	fileStream.close();
}
