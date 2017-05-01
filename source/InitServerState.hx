package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxInputText;
import openfl.text.TextField;
import TsDao;
import TellStick;

class InitServerState extends FlxState {

	private var tellStick: TellStick;

    private var inputAddress: TextField;
    private var inputPort: TextField;
    private var saveInputButton: FlxUIButton;

    private var serverSet: Bool = false;
    private var confState: Bool;

    private var dao: TsDao;
    private var configureButton: FlxUIButton;

    override public function create(): Void {
        super.create();
        dao = new TsDao();
        confState = dao.getConfState();

    }

    public override function update(elapsed: Float) {
        super.update(elapsed);

        if (!confState && !serverSet) {
            trace("Configure state is not active");
            serverSet = true;
        } else if (!serverSet && inputAddress == null) {
            var existingAddress = dao.getServerAddress();
            var existingPort = dao.getServerPort();

            inputAddress = createTextField(0, 8, existingAddress);
            FlxG.addChildBelowMouse(inputAddress);

            inputPort = createTextField(0, 16 + inputAddress.height, existingPort);
            FlxG.addChildBelowMouse(inputPort);

            saveInputButton = new FlxUIButton(FlxG.width / 2 - 16, inputPort.x + inputPort.height + 8, "Save", function() {
                dao.saveServer(inputAddress.text, inputPort.text);
                serverSet = true;
            });
            saveInputButton.x = FlxG.width / 2 - saveInputButton.width / 2;
            add(saveInputButton);
        } else if (serverSet) {
            trace("--> All good in init! Heading to LoadDevicesState");
            dao.saveConfState(false);
            FlxG.switchState(new LoadDevicesState());
        }
    }

    public function createTextField(xLoc: Float, yLoc: Float, content: String): TextField {
        // inputAddress = new FlxInputText(0, 8, FlxG.width, existingAddress);
        // inputAddress.x = FlxG.width / 2 - inputAddress.width / 2;
        // add(inputAddress);
        var input = new TextField();
        input.type = openfl.text.TextFieldType.INPUT;
        input.text = content;
        input.needsSoftKeyboard = true;
        input.border = true;
        input.borderColor = 0xFF0000;
        input.background = true;
        input.backgroundColor = 0xFFFFFF;
        input.height = 32;
        input.scaleX = 2.0;
        input.scaleY = 2.0;
        input.x = xLoc + FlxG.width / 2 - input.width / 2;
        input.y = yLoc;

        // input.scaleX = 4.0;
        // input.scaleY = 4.0;
        return input;
    }


}