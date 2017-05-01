package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxInputText;
import flixel.util.FlxSave;
import flixel.FlxSprite;
import TellStick;

class LoadDevicesState extends FlxState {

    private var dao: TsDao;
    private var loadingSprite: FlxSprite;

    private var requestedDevices: Bool = false;
    private var receivedDevices: Bool = false;

    private var configureButton: FlxUIButton;

    override public function create(): Void {
        super.create();
        dao = new TsDao();

        loadingSprite = new FlxSprite(0, 0);
        loadingSprite.loadGraphic("assets/loading.png", true, 128, 128);
        loadingSprite.animation.add("animate", [for (i in 0...20) i]);
        loadingSprite.animation.play("animate");
        loadingSprite.x = FlxG.width / 2 - loadingSprite.width / 2;
        loadingSprite.y = FlxG.height / 2 - loadingSprite.height / 2;

        configureButton = new FlxUIButton(0, 0, "Conf", function() {
            dao.saveConfState(true);
            FlxG.switchState(new InitServerState());
        });
        configureButton.resize(32, 24);
        configureButton.x = 0;
        configureButton.y = FlxG.height - configureButton.height;
        // configureButton.x = FlxG.width / 2 - configureButton.width / 2;
        // configureButton.y = FlxG.height / 2 - configureButton.height / 2;

        add(configureButton);
        add(loadingSprite);
    }

    public override function update(elapsed: Float) {
        super.update(elapsed);

        if (!requestedDevices) {
            trace("Requesting device refresh");
            dao.refreshDevices();
            requestedDevices = true;
        } else if (!receivedDevices) { 
            var devices = dao.getDevices();
            trace("Waiting for devices to load.. ");
            if (devices != null && devices.length > 0) {
                receivedDevices = true;
            }
        } else if (receivedDevices) {
            trace("--> " + dao.getDevices().length + " Devices loaded, heading to primary state");
            FlxG.switchState(new PrimaryState());
        }
    }

}