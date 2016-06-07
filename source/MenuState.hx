package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;
import haxe.Json;
import TellStick;

enum ProgramState {
    Init;
    Loading;
    Loaded;
    Ready;
}

class MenuState extends FlxState
{

	private var jsonResponse: String;
	private var state: ProgramState = Init;
	private var previousState: ProgramState = Init;
	private var tellStick: TellStick;
	
	override public function create():Void
	{
		super.create();
		tellStick = new TellStick();
	}
	
	public override function update(elapsed: Float){
		
		if (state == Init){
			initState();
		} else if (state == Loading){
			loadingState();
		} else if (state == Loaded){
			loadedState();
		} else if (state == Ready){
			readyState();
		}

		if (previousState != state){
			trace("State changed " + previousState + " -> " + state);
		}

		previousState = state;

		super.update(elapsed);
	}

	private function initState(){
    	state = Loading;
    	tellStick.refreshDevices();
	}

	private function loadingState(){
		trace("Loading..");
		if (tellStick.getDevices().length > 0){
			trace("Done!");
			state = Loaded;
		}
	}

	private function loadedState(){

		var xLoc = FlxG.width / 2;
		var yLoc = 0;

		for(device in tellStick.getDevices()){
			trace("Device: " + device.name);
			var button: FlxButton = new FlxButton(xLoc, yLoc, device.name, function(){
				trace("Clicked " + device.name + " - " + device.id);
				tellStick.toggleDevice(device.id);
			});

			button.x = xLoc - button.width / 2;
			
			yLoc += Std.int(button.height);
			add(button);
		}

		var allOnButton: FlxButton = new FlxButton(0, FlxG.height, "All ON", tellStick.toggleAllOn);
		allOnButton.y -= allOnButton.height;
		add(allOnButton);

		var allOffButton: FlxButton = new FlxButton(FlxG.width, FlxG.height, "All OFF", tellStick.toggleAllOff);
		allOffButton.y -= allOffButton.height;
		allOffButton.x -= allOffButton.width;		
		add(allOffButton);

		state = Ready;
	}

	private function readyState(){
		// TODO: Implement checking if refresh is necessary
	}



}

