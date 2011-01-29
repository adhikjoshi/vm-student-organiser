import mx.controls.TextInput;
import mx.events.DataGridEvent;
import mx.collections.ArrayCollection;
import flash.filesystem.*

[Bindable]
private var events:ArrayCollection;

private var eventsFile:String = "Organiser/events.txt";

private function readEvents():void {
	var file:File = File.userDirectory.resolvePath(eventsFile);
	
	if(file.exists) {
		var fileStream:FileStream = new FileStream();
		fileStream.open(file,FileMode.READ);
		events = fileStream.readObject() as ArrayCollection;
		fileStream.close();
	} else {
		events = new ArrayCollection();
	}
}

private function writeEvents():void {
	var file:File = File.userDirectory.resolvePath(eventsFile);
	var fileStream:FileStream = new FileStream();
	fileStream.open(file,FileMode.WRITE);
	fileStream.writeObject(events);
	fileStream.close();
}

public function addItem():void {
	events.addItem({name:"", date:new Date, type:""});
	events.refresh();
	
	var newItemPosition:Number;
	
	for(newItemPosition=0;newItemPosition < events.length-1 && events[newItemPosition].name != "";newItemPosition++) {
		// intentionally left blank
	}
	
	eventsAssignments.editedItemPosition = {rowIndex:newItemPosition, columnIndex:1};
}

public function deleteItem(event:MouseEvent):void {
	if(eventsAssignments.selectedIndex != -1) {
		events.removeItemAt(eventsAssignments.selectedIndex);
		events.refresh();
	}
}
