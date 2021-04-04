using Toybox.Application;
using Toybox.System;

class MemoryCache {

	var settings;
	var weather;
	var everySecondFields;
	var flags;
	var sunEvents;
	var mode;// STORAGE_KEY_GLOBAL, STORAGE_KEY_DAY, STORAGE_KEY_NIGHT
	
	function initialize(){
		reload();
	}

	function reload(){
		//Erase all feilds for clear RAM before saveSettings
		everySecondFields = null;
		settings = null;
		weather = null;
		var view = Application.getApp().view;
		if (view != null){
			view.fields = null;
		}
		
		mode = STORAGE_KEY_GLOBAL;
		readSettings();
		readGeolocation();
		readWeather();
		flags = {};
		sunEvents = {};
	}

	function readSettings(){

		settings = {};
		settings[:switchDayNight] = Application.Properties.getValue("SwitchDayNight");
		
		var currentMode;
		if (mode == null){
			currentMode = STORAGE_KEY_GLOBAL;
		}else{
			currentMode = mode;
		}
		settings[:backgroundColor] = StorageSettings.getSettingValue(currentMode.toString()+"BgndColor");
		settings[:weatherAutoColors] = StorageSettings.getSettingValue(currentMode.toString()+"WAutoColor");
		settings[:time] = {};
		settings[:time][:military] = StorageSettings.getSettingValue(currentMode.toString()+"MilFt");
		settings[:time][:hours01] = StorageSettings.getSettingValue(currentMode.toString()+"HFt01");

		settings[:pressureUnit] = StorageSettings.getSettingValue(currentMode.toString()+"PrU");
		settings[:windUnit] = StorageSettings.getSettingValue(currentMode.toString()+"WU");
		settings[:time1] = StorageSettings.getSettingValue(currentMode.toString()+"T1TZ");

		settings[:keyOW] = Application.Properties.getValue("keyOW");
		settings[:weatherUpdateInteval] = StorageSettings.getSettingValue(currentMode.toString()+"WUpdInt");
		readGeolocation();
	}

	function readGeolocation(){
		//////////////////////////////////////////////////////////
		//DEBUG
		Application.Storage.setValue("Lat", 55.03325);
		Application.Storage.setValue("Lon", 73.449715);
		Application.Properties.setValue("keyOW", "69bcb8de48220cd2b2fb7a8400c68d1e");
		//////////////////////////////////////////////////////////
		settings[:geoLocation] = [Application.Storage.getValue("Lat"), Application.Storage.getValue("Lon")];
	}

	function readWeather(){

		weather = null;
		weather = Application.Storage.getValue(STORAGE_KEY_WEATHER);
		setWeatherAutoColors();
		//////////////////////////////////////////////////////////
		//DEBUG
		//System.println("onReadWeather: "+weather);
		//////////////////////////////////////////////////////////
	}

	function setWeatherAutoColors(){
	
		var defColor;
		if (mode == null){
			defColor = StorageSettings.getSettingValue(STORAGE_KEY_GLOBAL.toString()+"WColor");
		}else{
			defColor = StorageSettings.getSettingValue(mode.toString()+"WColor");
		}
		
		settings[:autoColors] = {
			:temp => defColor,
			:wind => defColor
		};

		if (settings[:weatherAutoColors] && weather != null){
			var backgroundColor = settings[:backgroundColor];
			
			var backIsLight = false;
			if (backgroundColor == Graphics.COLOR_WHITE 
				|| backgroundColor == Graphics.COLOR_LT_GRAY 
				|| backgroundColor == Graphics.COLOR_YELLOW){
				backIsLight = true;
			}
			
			//temperature
			var tmpValue = weather[STORAGE_KEY_TEMP];
			if (tmpValue != null){
				if (backIsLight){
					if (tmpValue > 30){
						settings[:autoColors][:temp] = 0xaa0000;
					}else if (tmpValue > 25){
						settings[:autoColors][:temp] = 0xff0055;
					}else if (tmpValue > 20){
						settings[:autoColors][:temp] = 0xff5500;
					}else if (tmpValue > 15){
						settings[:autoColors][:temp] = 0x005500;
					}else if (tmpValue > 10){
						settings[:autoColors][:temp] = 0x555500;
					}else if (tmpValue > 5){
						settings[:autoColors][:temp] = 0xaa5500;
					}else if (tmpValue > 0){
						settings[:autoColors][:temp] = 0xff5500;
					}else if (tmpValue > -10){
						settings[:autoColors][:temp] = 0x0000ff;
					}else if (tmpValue > -20){
						settings[:autoColors][:temp] = 0x0000aa;
					}else{
						settings[:autoColors][:temp] = 0x000055;
					}
				}else{
					if (tmpValue > 30){
						settings[:autoColors][:temp] = 0xff0000;
					}else if (tmpValue > 25){
						settings[:autoColors][:temp] = 0xff0055;
					}else if (tmpValue > 20){
						settings[:autoColors][:temp] = 0x00ff00;
					}else if (tmpValue > 15){
						settings[:autoColors][:temp] = 0x00ff55;
					}else if (tmpValue > 10){
						settings[:autoColors][:temp] = 0x55ff00;
					}else if (tmpValue > 5){
						settings[:autoColors][:temp] = 0xffff00;
					}else if (tmpValue > 0){
						settings[:autoColors][:temp] = 0xffffaa;
					}else if (tmpValue > -10){
						settings[:autoColors][:temp] = 0xaaffff;
					}else if (tmpValue > -20){
						settings[:autoColors][:temp] = 0x55ffff;
					}else{
						settings[:autoColors][:temp] = 0x00ffff;
					}
				}
			}

			//wind speed
			tmpValue = weather[STORAGE_KEY_WIND_SPEED];
			if (tmpValue != null){
				tmpValue = Tools.getBeaufort(tmpValue);
				if (backIsLight){
					if (tmpValue > 9){
						settings[:autoColors][:wind] = 0xaa0000;
					}else if (tmpValue > 8){
						settings[:autoColors][:wind] = 0xaa0055;
					}else if (tmpValue > 7){
						settings[:autoColors][:wind] = 0xaa00aa;
					}else if (tmpValue > 6){
						settings[:autoColors][:wind] = 0x5500ff;
					}else if (tmpValue > 5){
						settings[:autoColors][:wind] = 0x5555ff;
					}else if (tmpValue > 4){
						settings[:autoColors][:wind] = Graphics.COLOR_ORANGE;
					}else if (tmpValue > 3){
						settings[:autoColors][:wind] = 0x005500;
					}else if (tmpValue > 2){
						settings[:autoColors][:wind] = 0x00aa00;
					}else{
						settings[:autoColors][:wind] = Graphics.COLOR_DK_GRAY;
					}
				}else{
					if (tmpValue > 9){
						settings[:autoColors][:wind] = 0xff0000;
					}else if (tmpValue > 8){
						settings[:autoColors][:wind] = 0xff00aa;
					}else if (tmpValue > 7){
						settings[:autoColors][:wind] = 0xffaaff;
					}else if (tmpValue > 6){
						settings[:autoColors][:wind] = 0x00ffff;
					}else if (tmpValue > 5){
						settings[:autoColors][:wind] = 0xaaffff;
					}else if (tmpValue > 4){
						settings[:autoColors][:wind] = Graphics.COLOR_YELLOW;
					}else if (tmpValue > 3){
						settings[:autoColors][:wind] = 0x00ff00;
					}else if (tmpValue > 2){
						settings[:autoColors][:wind] = 0x55ff55;
					}else{
						settings[:autoColors][:wind] = Graphics.COLOR_WHITE;
					}
				}
			}
		}
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
				}else if (unit == 5){ /*knots*/
					settings[:spped_unti_string] = Application.loadResource(Rez.Strings.SpeedUnitKnots);
				}
			}
			return settings[:spped_unti_string];
		}else{
			return "";
		}
	}

	function getFontByFieldType(type){
		var res = :small;
		if (type == CONNECTED || type == NOTIFICATIONS || type == DND ||type == ALARMS){
			res = :picture;
		}
		return res;
	}

	function addEverySecondField(id){
		if (everySecondFields == null){
			everySecondFields = [id];
		}else{
			everySecondFields.add(id);
		}
	}

	function getPictureType(id){
		return PICTURE+StorageSettings.getSettingValue(mode+id);
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
}