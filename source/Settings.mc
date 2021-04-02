using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;

(:background)
//*****************************************************************************
module StorageSettings {

	///////////////////////////////////////////////////////////////////////////
	function initStorageSettings(){
		StorageSettings.PropertiesToStorage(STORAGE_KEY_GLOBAL);
		StorageSettings.PropertiesToStorage(STORAGE_KEY_DAY);
		StorageSettings.PropertiesToStorage(STORAGE_KEY_NIGHT);
	}
	
	///////////////////////////////////////////////////////////////////////////
	function getStorageSettingsValue(typeSettingsKey, valueKey){
		var res = null;
		
		var dictKeys = Application.Storage.getValue(typeSettingsKey);
		if (dictKeys != null){
			res = dictKeys[valueKey]; 
		}
		return res; 
	}
	
	///////////////////////////////////////////////////////////////////////////
    function PropertiesToStorage(key){
    	
    	var propKeys = StorageSettings.getPropertiesKeys();
    	var settings = {};
    	for (var i = 0; i < propKeys.size(); i++){
			settings.put(propKeys[i], Application.Properties.getValue(propKeys[i]));    		
    	}
    	Application.Storage.setValue(key, settings);
    }

	///////////////////////////////////////////////////////////////////////////
	function StorageToProperties(key){
		
		var settings = Application.Storage.getValue(key);
		if (settings == null){
			return;
		}
		
		var propKeys = StorageSettings.getPropertiesKeys();
		for (var i = 0; i < propKeys.size(); i++){
			var value = settings[propKeys[i]];
			if (value != null){
				Application.Properties.setValue(propKeys[i], value);
			}			
		}
	}

	///////////////////////////////////////////////////////////////////////////
    function getStorageSettingsDictonary(key){
    	
    	var res = Application.Storage.getValue(key);
    	if (res == null){
    		res = {};
    	}
    	
    	var allProp = StorageSettings.getFullPropertiesKeys();
    	
     	for (var i=0; i<allProp.size(); i++){
    		if (res[allProp[i][:title].toString()] == null){
    			res[allProp[i][:title].toString()] = Application.Properties.getValue(allProp[i][:title].toString());
    		}
    	} 
    	return res;    	
    }
	
	///////////////////////////////////////////////////////////////////////////
	function getPropertiesKeys(){
		var res = [];
		var allProp = getFullPropertiesKeys();
		for (var i = 0; i < allProp.size(); i++){
			res.add(allProp[i][:title].toString());
		}
		return res;
	}
	
	///////////////////////////////////////////////////////////////////////////
	function getFullPropertiesKeys(){

		var res = [];
	    
	    res.add({:type => :bool, :title => :MilFt});
		res.add({:type => :bool, :title => :HFt01});
		res.add({:type => :dateFormat, :title => :DF});
	    res.add({:type => :color, :title => :BgndColor});
	    res.add({:type => :color, :title => :TimeColor});
	    res.add({:type => :color, :title => :DateColor});
	    res.add({:type => :widgetType, :title => :WType});
	    res.add({:type => :color, :title => :WColor});
	    res.add({:type => :bool, :title => :WAutoColor});
	    res.add({:type => :bool, :title => :WShowWindWidget});
	    res.add({:type => :bool, :title => :WindArrowContour});
	    res.add({:type => :bool, :title => :ShowTopFields});
	    
	    res.add({:type => :color, :title => :BatColor});
	    res.add({:type => :color, :title => :MoonColor});
		res.add({:type => :number, :title => :WUpdInt});
		res.add({:type => :pressureUnit, :title => :PrU});
		res.add({:type => :windSpeedUnit, :title => :WU});
		res.add({:type => :number, :title => :T1TZ});
		
		res.add({:type => :statusField, :title => :SF0});
		res.add({:type => :color, :title => :SFC0});
		res.add({:type => :statusField, :title => :SF1});
		res.add({:type => :color, :title => :SFC1});
		res.add({:type => :statusField, :title => :SF2});
		res.add({:type => :color, :title => :SFC2});
		res.add({:type => :statusField, :title => :SF3});
		res.add({:type => :color, :title => :SFC3});
		res.add({:type => :statusField, :title => :SF4});
		res.add({:type => :color, :title => :SFC4});
		res.add({:type => :statusField, :title => :SF5});
		res.add({:type => :color, :title => :SFC5});
		
		res.add({:type => :field, :title => :F0});
		res.add({:type => :color, :title => :C0});
		res.add({:type => :field, :title => :F1});
		res.add({:type => :color, :title => :C1});
		res.add({:type => :field, :title => :F2});
		res.add({:type => :color, :title => :C2});
		res.add({:type => :field, :title => :F3});
		res.add({:type => :color, :title => :C3});
		res.add({:type => :field, :title => :F4});
		res.add({:type => :color, :title => :C4});
		res.add({:type => :field, :title => :F5});
		res.add({:type => :color, :title => :C5});
		res.add({:type => :field, :title => :F6});
		res.add({:type => :color, :title => :C6});
		res.add({:type => :field, :title => :F7});
		res.add({:type => :color, :title => :C7});

		return res;
	
	}
	
	function pressureUnit(){
		return {
			0 => :PrUMmHg,
			1 => :PrUPsi,
			2 => :PrUInchHg,
			3 => :PrUBar,
			4 => :PrUKPa};
	}
	
	function windSpeedUnit(){
		return {
			0 => :SpeedUnitMSec,
			1 => :SpeedUnitKmH,
			2 => :SpeedUnitMileH,
			3 => :SpeedUnitFtSec,
			4 => :SpeedUnitBof,
			5 => :SpeedUnitKnots};
	}
	
	function color(){
		return {
			0xFFFFFF => :COLOR_WHITE,
			0x000000 => :COLOR_BLACK,
			0xAAAAAA => :COLOR_LT_GRAY,
			0x555555 => :COLOR_DK_GRAY,
			0xFF0000 => :COLOR_RED,
			0xAA0000 => :COLOR_DK_RED,
			0xFF5500 => :COLOR_ORANGE,
			0xFFAA00 => :COLOR_YELLOW,
			0x00FF00 => :COLOR_GREEN,
			0x00AA00 => :COLOR_DK_GREEN,
			0x00AAFF => :COLOR_BLUE,
			0x0000FF => :COLOR_DK_BLUE,
			0xAA00FF => :COLOR_PURPLE,
			0xFF00FF => :COLOR_PINK};
	}
	
	function statusField(){
		return {
			18 => :FIELD_TYPE_CONNECTED,
			19 => :FIELD_TYPE_NOTIFICATIONS,
			24 => :FIELD_TYPE_NOTIFICATIONS_COUNT,
			20 => :FIELD_TYPE_DND,
			21 => :FIELD_TYPE_ALARMS,
			25 => :FIELD_TYPE_ALARMS_COUNT,
			22 => :FIELD_TYPE_AMPM,
			23 => :FIELD_TYPE_SECONDS,
			12 => :FIELD_TYPE_EMPTY};
	}
	
	function field(){
		return {
			0 => :FIELD_TYPE_HR,
			1 => :FIELD_TYPE_STEPS,
			2 => :FIELD_TYPE_PRESSURE,
			3 => :FIELD_TYPE_TEMPERATURE,
			4 => :FIELD_TYPE_CALORIES,
			5 => :FIELD_TYPE_DISTANCE,
			6 => :FIELD_TYPE_FLOOR,
			7 => :FIELD_TYPE_ELEVATION,
			8 => :FIELD_TYPE_SUN_EVENT,
			9 => :FIELD_TYPE_SUNRISE,
			10 => :FIELD_TYPE_SUNSET,
			11 => :FIELD_TYPE_TIME1,
			13 => :FIELD_TYPE_ACTIVE_DAY,
			14 => :FIELD_TYPE_ACTIVE_WEEK,
			15 => :FIELD_TYPE_O2,
			16 => :FIELD_TYPE_SOLAR_CHARGE,
			17 => :FIELD_TYPE_WEIGHT,
			26 => :FIELD_TYPE_WEATHER_PRESSURE,
			27 => :FIELD_TYPE_WEATHER_HUM,
			28 => :FIELD_TYPE_WEATHER_VISIBILITY,
			29 => :FIELD_TYPE_WEATHER_WIND_SPEED,
			30 => :FIELD_TYPE_WEATHER_WIND_DEG,
			31 => :FIELD_TYPE_WEATHER_UVI,
			32 => :FIELD_TYPE_WEATHER_DEW_POINT,
			12 => :FIELD_TYPE_EMPTY};
	}
	
	function widgetType(){
		return{
			0 => :WTypeWeather,
			1 => :WTypeHeartRateHistory,
			2 => :WTypeSaturationHistory,
			3 => :WTypeTemperatureHistory,
			4 => :WTypePressureHistory,
			5 => :WTypeElevationHistory};
	}
}