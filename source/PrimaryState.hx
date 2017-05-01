package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxUIButton;

class PrimaryState extends FlxState {

    private var dao: TsDao;

    private var configureButton: FlxUIButton;

    override public function create(): Void {
        super.create();
        dao = new TsDao();

        configureButton = new FlxUIButton(0, 0, "Conf", function() {
            dao.saveConfState(true);
            FlxG.switchState(new InitServerState());
        });
        configureButton.resize(32, 24);
        configureButton.x = 0;
        configureButton.y = FlxG.height - configureButton.height;
        add(configureButton);

        var xLoc = FlxG.width / 2;
		var yLoc = 0;

		for(device in dao.getDevices()){
			trace("Device: " + device.name);
			var button: FlxUIButton = new FlxUIButton(xLoc, yLoc, device.name, function(){
                if (visible){
                    trace("Clicked " + device.name + " - " + device.id);
                    dao.toggleDevice(device.id);
                }
			});

			button.x = xLoc - button.width / 2;

			yLoc += Std.int(button.height);
			add(button);
		}
    }

}