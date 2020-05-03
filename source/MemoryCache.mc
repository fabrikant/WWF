using Toybox.Application;
using Toybox.System;

class MemoryCache {

	var settings;
	var oldValues;
	var weather;

	function initialize(){
		reload();
	}

	function reload(){
		readSettings();
		readGeolocation();
		readWeather();
		oldValues = {};
		oldValues[:sunCach] = {};
	}

	function readSettings(){

		settings = {};
		settings[:colors] = {};
		settings[:colors][:background] = Application.Properties.getValue("BgndColor");
		settings[:colors][:time] = Application.Properties.getValue("TimeColor");
		settings[:colors][:date] = Application.Properties.getValue("DateColor");
		//settings[:colors][:am] = settings[:colors][:time];
		//settings[:colors][:sec] = settings[:colors][:time];

		settings[:colors][:connnection] = Application.Properties.getValue("ConCol");
		settings[:colors][:messages] = Application.Properties.getValue("MesCol");
		settings[:colors][:dnd] = Application.Properties.getValue("DNDCol");
		settings[:colors][:alarms] = Application.Properties.getValue("AlCol");

		settings[:colors][:weather] = Application.Properties.getValue("WColor");


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
	}

	function readGeolocation(){
		//////////////////////////////////////////////////////////
		//DEBUG
		//Application.Storage.setValue("Lat", 54);
		//Application.Storage.setValue("Lon", 73);
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
}