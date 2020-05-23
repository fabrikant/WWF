using Toybox.Application;
using Toybox.System;

class MemoryCache {

	var settings;
	var oldValues;
	var weather;
	var backgroundY = [0,0];

	function initialize(){
		reload();
	}

	function reload(){
		readSettings();
		readGeolocation();
		readBackgroundY();
		readWeather();
		oldValues = {};
		oldValues[:sunCach] = {};
	}

	function readSettings(){

		settings = {};
		settings[:colors] = {};
		settings[:colors][:background1] = Application.Properties.getValue("BgndColor1");
		settings[:colors][:background2] = Application.Properties.getValue("BgndColor2");
		settings[:colors][:background3] = Application.Properties.getValue("BgndColor3");
		settings[:colors][:time] = Application.Properties.getValue("TimeColor");
		settings[:colors][:date] = Application.Properties.getValue("DateColor");

		settings[:colors][:connnection] = Application.Properties.getValue("ConCol");
		settings[:colors][:messages] = Application.Properties.getValue("MesCol");
		settings[:colors][:dnd] = Application.Properties.getValue("DNDCol");
		settings[:colors][:alarms] = Application.Properties.getValue("AlCol");

		settings[:colors][:weather] = Application.Properties.getValue("WColor");
		settings[:colors][:battery] = Application.Properties.getValue("BatColor");
		settings[:colors][:moon] = Application.Properties.getValue("MoonColor");


		for (var i = 0; i < FIELDS_COUNT; i++){
			settings[:colors]["F"+i] = Application.Properties.getValue("C"+i);
		}

		settings[:time] = {};
		settings[:time][:military] = Application.Properties.getValue("MilFt");
		settings[:time][:hours01] = Application.Properties.getValue("HFt01");
		settings[:time][:am] = Application.Properties.getValue("AmPm");
		settings[:time][:sec] = Application.Properties.getValue("Sec");

		settings[:pressureUnit] = Application.Properties.getValue("PrU");
		settings[:windUnit] = Application.Properties.getValue("WU");
		settings[:time1] = Application.Properties.getValue("T1TZ");

		settings[:apiKey] = Application.Properties.getValue("keyOW");
		settings[:weatherUpdateInteval] = Application.Properties.getValue("WUpdInt");
	}

	function readGeolocation(){
		//////////////////////////////////////////////////////////
		//DEBUG
//		Application.Storage.setValue("Lat", 54);
//		Application.Storage.setValue("Lon", 73);
		//////////////////////////////////////////////////////////
		settings[:geoLocation] = [Application.Storage.getValue("Lat"), Application.Storage.getValue("Lon")];
	}

	function readWeather(){

		weather = null;
		weather = Application.Storage.getValue(STORAGE_KEY_WEATHER);
		//////////////////////////////////////////////////////////
		//DEBUG
		//System.println("onReadWeather: "+weather);
		//////////////////////////////////////////////////////////
	}

	function getSpeedUnitString(){

		if (memoryCache.weather != null){
			if (settings[:spped_unti_string] == null){
				settings[:spped_unti_string] = Application.loadResource(Rez.Strings.SpeedUnitMSec);//meters/sec
				var unit =  settings[:windUnit];
				if (unit == 1){ /*km/h*/
					settings[:spped_unti_string] = Application.loadResource(Rez.Strings.SpeedUnitKmH);
				}else if (unit == 2){ /*mile/h*/
					settings[:spped_unti_string] = Application.loadResource(Rez.Strings.SpeedUnitMileH);
				}else if (unit == 3){ /*ft/s*/
					settings[:spped_unti_string] = Application.loadResource(Rez.Strings.SpeedUnitFtSec);
				}else if (unit == 4){ /*ft/s*/
					settings[:spped_unti_string] = Application.loadResource(Rez.Strings.SpeedUnitBof);
				}
			}
			return settings[:spped_unti_string];
		}else{
			return "";
		}
	}

	function getFieldType(id){
		return Application.Properties.getValue(id);
	}

	function getPictureType(id){
		return PICTURE+Application.Properties.getValue(id);
	}

	function onWeatherUpdate(data){
		Application.Storage.setValue(STORAGE_KEY_WEATHER, data);
		readWeather();
	}

	function eraseWeather(){
		onWeatherUpdate(null);
	}

	function checkWeatherActuality(){
		if (weather != null){
			if (Time.now().value() - weather[STORAGE_KEY_RECIEVE].toNumber() > 10800){
				eraseWeather();
			}
		}
	}

	function setBackgroundY(idx, value){
		backgroundY[idx] = value;
		var key = getBackgroundYKeyStorageId(idx);
		if (Application.Storage.getValue(key) != value){
			Application.Storage.setValue(key, value);
		}
	}

	function readBackgroundY(){
		backgroundY[0] = getStorageValue(getBackgroundYKeyStorageId(0),0);
		backgroundY[1] = getStorageValue(getBackgroundYKeyStorageId(1),0);
	}

	private function getBackgroundYKeyStorageId(idx){
		if (idx == 0){
			return STORAGE_KEY_BACKGROUND_Y1;
		}else{
			return STORAGE_KEY_BACKGROUND_Y2;
		}
	}

	private function getStorageValue(key, defaultValue){
		var value = Application.Storage.getValue(key);
		if (value == null){
			return defaultValue;
		}else{
			return value;
		}
	}
}