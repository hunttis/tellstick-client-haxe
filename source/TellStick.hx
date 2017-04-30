package;

import restclient.RestClient;
import haxe.Json;

class TellStick {

    private var serverAddress: String;
    private var devices: TellstickDeviceList;

    public function new(address: String, port: String):Void {
        serverAddress = "http://" + address + ":" + port;
    }

    private function getBaseCommand(): String{
        return serverAddress + "/devices";
    }

    public function refreshDevices(): Void{
        RestClient.getAsync(
            getBaseCommand(),
            function (result) {
                trace("Refreshed devices!");
                devices = Json.parse(result);
            }
        );
    }

    public function toggleDevice(deviceId: String){
        trace("Device toggled: " + deviceId);

        var command = getToggleCommandForDevice(deviceId);
        
        RestClient.getAsync(
            command,
            function (result) {
                trace("Ran command, got: " + result);
                refreshDevices();
            }
        );
    }

    public function toggleAllOn(){
        for(device in devices.devices){
            sendRestCommand(getOnCommandForDevice(device.id), true);
        }
    }

    public function toggleAllOff(){
        for(device in devices.devices){
            sendRestCommand(getOffCommandForDevice(device.id), true);
        }
    }

    private function getToggleCommandForDevice(deviceId: String){
        var deviceOn: Bool = false;

        for(device in devices.devices){
            if (device.id == deviceId){
                trace("Device state found, it's: " + device.lastcmd);
                if (device.lastcmd == "ON"){
                    deviceOn = true;
                }
            }
        }

        var command = getBaseCommand() + "/" + deviceId + "/";

        if (deviceOn){
            command += "off";
        } else {
            command += "on";
        }
        return command;
    }

    private function getOnCommandForDevice(deviceId: String): String{
        return getBaseCommand() + "/" + deviceId + "/on";
    }

    private function getOffCommandForDevice(deviceId: String): String{
        return getBaseCommand() + "/" + deviceId + "/off";
    }

    public function getDevices(): Array<TellstickDevice> {
        return devices.devices;
    }

    private function sendRestCommand(command: String, refreshDevicesToo: Bool){
        RestClient.getAsync(
            command,
            function (result) {
                trace("Ran command, got: " + result);
            }
        );
        if (refreshDevicesToo){
            refreshDevices();
        }
    }
}

typedef TellstickDeviceList = {
    var devices: Array<TellstickDevice>;
}

typedef TellstickDevice = {
    var id: String;
    var lastcmd: String;
    var lastvalue: String;
    var model: String;
    var name: String;
    var protocol: String;
    var supportedMethods: Array<TellstickMethod>;
}

typedef TellstickMethod = {
    var id: String;
    var name: String;
}
