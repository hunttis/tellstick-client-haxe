package;

import flixel.util.FlxSave;
import haxe.Serializer;
import haxe.Unserializer;
import TellStick;

class TsDao {

    private var dataStorage: FlxSave;
    private var deviceStorage: FlxSave;
    private var confStateStorage: FlxSave;

    private var currentServerAddress: String = null;
    private var currentServerPort: String = null;

    private var deviceList: Array<TellstickDevice>;

    private var confState: Bool;

    private var tellStick: TellStick;

    public function new ()  {
        dataStorage = new FlxSave();
        dataStorage.bind("serverData");

        deviceStorage = new FlxSave();
        deviceStorage.bind("devices");

        confStateStorage = new FlxSave();
        confStateStorage.bind("confState");

        // clearSaveData();

        loadServer();
        loadDevices();
        loadConfState();

        trace("Creating a new tellstick object with: " + currentServerAddress + ":" + currentServerPort);
        tellStick = new TellStick(currentServerAddress, currentServerPort);
        if (deviceList != null && deviceList.length > 0){
            tellStick.setCachedDevices(deviceList);
        }

    }

    private function clearSaveData() {
        dataStorage.erase();
        deviceStorage.erase();
        confStateStorage.erase();
    }

    private function loadServer() {
        if (dataStorage.data.serverAddress == null || dataStorage.data.serverAddress == "") {
            trace("No server data in store!");
            saveServer("", "");
        } else {
            trace("Server data in store, loading... " + dataStorage.data.serverAddress + ":" + dataStorage.data.serverPort);
            currentServerAddress = dataStorage.data.serverAddress;
            currentServerPort = dataStorage.data.serverPort;
        }
    }

    private function loadDevices() {
        if (deviceStorage.data.devices == null) {
            trace("No device data in store!");
        } else {
            trace("Device data in store, loading... " + deviceStorage.data.devices);
            
            var loadedDevices = deviceStorage.data.devices;
            var deserializer = new Unserializer(loadedDevices);

            deviceList = deserializer.unserialize();
        }
    }

    private function loadConfState() {
        if (confStateStorage.data.confState == null){
            trace("First time here!");
            saveConfState(true);
        } else {
            trace("Conf state loaded, it's: " + confStateStorage.data.confState);
            confState = confStateStorage.data.confState;
        }
    }

    public function saveServer(address: String, port: String) {
        trace("Saving server address as: " + address + " - Port: " + port);
        dataStorage.data.serverAddress = address;
        dataStorage.data.serverPort = port;
        dataStorage.flush();
        currentServerAddress = address;
        currentServerPort = port;
    }

    public function saveDevices(newDevices: Array<TellstickDevice>) {
        var serializer = new Serializer();
        serializer.serialize(newDevices);
        var devicesInSaveFormat = serializer.toString();
        trace("Saving received devices: " + devicesInSaveFormat);

        deviceStorage.data.devices = devicesInSaveFormat;
        deviceStorage.flush();
        deviceList = newDevices;
    }

    public function saveConfState(newState: Bool) {
        confStateStorage.data.confState = newState;
        confStateStorage.flush();
        confState = newState;
    }

    public function getServerAddress() {
        return currentServerAddress;
    }

    public function getServerPort() {
        return currentServerPort;
    }

    public function getConfState() {
        return confState;
    }

    public function refreshDevices() {
        tellStick.refreshDevices();
    }

    public function getDevices() {
        if (deviceList == null || deviceList.length == 0) {
            var refreshedDeviceList = tellStick.getDevices();
            if (refreshedDeviceList.length > 0){
                saveDevices(refreshedDeviceList);
                return refreshedDeviceList;
            }
        }
        return deviceList;
    }

    public function toggleDevice(deviceId: String) {
        tellStick.toggleDevice(deviceId);
    }

}
