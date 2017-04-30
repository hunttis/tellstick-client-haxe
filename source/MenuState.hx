package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxInputText;
import flixel.util.FlxSave;
import TellStick;

enum ProgramState {
    Starting;
    Init;
    InitialConfig;
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

    private var deviceGroup: FlxGroup;
    private var inputGroup: FlxGroup;    

    private var configureButton: FlxUIButton;
    private var inputAddress: FlxInputText;
    private var inputPort: FlxInputText;
    private var saveInputButton: FlxUIButton;

    private var dataStorage: FlxSave;
    private var currentServerAddress: String;
    private var currentServerPort: String;

	override public function create():Void
	{
		super.create();

        deviceGroup = new FlxGroup();
        inputGroup = new FlxGroup();

        state = Starting;
        dataStorage = new FlxSave();
        dataStorage.bind("serverData");
	}

	public override function update(elapsed: Float){

        add(deviceGroup);
        add(inputGroup);

        if (state == Starting) {
            loadServerAddress();
        } else if (state == InitialConfig) {
            initialConfigState();
        } else if (state == Init){
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

    private function initialConfigState(){
        createInputsIfNotExist(true);
    }

	private function initState(){
    	state = Loading;

        createInputsIfNotExist(false);

        configureButton = new FlxUIButton(0, 0, "Conf", function() {
            inputGroup.visible = !inputGroup.visible;
            deviceGroup.visible = !deviceGroup.visible;
            trace("inputs: " + inputGroup.visible + " - devices: " + deviceGroup.visible);
        });
        configureButton.resize(32, 24);
        configureButton.x = FlxG.width / 2 - configureButton.width / 2;
        configureButton.y = FlxG.height - configureButton.height;

        add(configureButton);
    	tellStick.refreshDevices();
	}

	private function loadingState(){
		trace("Loading.. " + tellStick);
		if (tellStick != null && tellStick.getDevices().length > 0){
			trace("Done! " + tellStick + " \nDevices: " + tellStick.getDevices().length);
			state = Loaded;
		}
	}

	private function loadedState(){

		var xLoc = FlxG.width / 2;
		var yLoc = 0;
        
		for(device in tellStick.getDevices()){
			trace("Device: " + device.name);
			var button: FlxUIButton = new FlxUIButton(xLoc, yLoc, device.name, function(){
                if (visible){
                    trace("Clicked " + device.name + " - " + device.id);
                    tellStick.toggleDevice(device.id);
                }
			});

			button.x = xLoc - button.width / 2;

			yLoc += Std.int(button.height);
			deviceGroup.add(button);
		}

		var allOnButton: FlxUIButton = new FlxUIButton(0, FlxG.height, "All ON", tellStick.toggleAllOn);
		allOnButton.y -= allOnButton.height;
		add(allOnButton);

		var allOffButton: FlxUIButton = new FlxUIButton(FlxG.width, FlxG.height, "All OFF", tellStick.toggleAllOff);
		allOffButton.y -= allOffButton.height;
		allOffButton.x -= allOffButton.width;
		add(allOffButton);

		state = Ready;
	}

	private function readyState(){
		// TODO: Implement checking if refresh is necessary
	}

    private function createInputsIfNotExist(visibilityForInputs: Bool) {
        if (inputAddress == null) {
            
            inputAddress = new FlxInputText(0, 8, FlxG.width, "");
            inputAddress.x = FlxG.width / 2 - inputAddress.width / 2;
            inputGroup.add(inputAddress);
            
            inputPort = new FlxInputText(0, 24, FlxG.width, "");
            inputPort.x = FlxG.width / 2 - inputPort.width / 2;
            inputGroup.add(inputPort);

            saveInputButton = new FlxUIButton(FlxG.width / 2 - 16, 32 + 8, "Save", function() {
                saveServerAddress(inputAddress.text, inputPort.text);
            });
            saveInputButton.x = FlxG.width / 2 - saveInputButton.width / 2;
            inputGroup.add(saveInputButton);
        }
        inputGroup.visible = visibilityForInputs;
    }

    private function loadServerAddress() {
        if (dataStorage.data.serverAddress == null && dataStorage.data.serverAddress != "") {
            trace("Need to config server data!");
            state = InitialConfig;
        } else {
            trace("Server data saved, loading");
            currentServerAddress = dataStorage.data.serverAddress;
            currentServerPort = dataStorage.data.port;
            tellStick = new TellStick(currentServerAddress, currentServerPort);
            state = Init;
        }
    }

    private function saveServerAddress(address: String, port: String) {
        trace("Saving server address as: " + address + " - Port: " + port);
        dataStorage.data.serverAddress = address;
        dataStorage.data.port = port;
        dataStorage.flush();
        loadServerAddress();
    }

}
