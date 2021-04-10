using Toybox.Application;
using Toybox.System;

class MemoryCache {

	var settings;
	var weather;
	var everySecondFields;
	var flags;
	var sunEvents;
	var mode;// :G, :D, :N
	
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
		
		mode = :G;
		readSettings();
		readGeolocation();
		readWeather();
		flags = {};
		sunEvents = {};
	}

	function readSettings(){

		settings = {};
		settings[:switchDayNight] = Application.Properties.getValue("SwitchDayNight");
		
		settings[:theme] = Application.Properties.getValue(modeAsString()+"Theme");
		settings[:backgroundColor] = getBackgroundColor();
		settings[:time] = {};
		settings[:time][:military] = Application.Properties.getValue("MilFt");
		settings[:time][:hours01] = Application.Properties.getValue("HFt01");

		settings[:pressureUnit] = Application.Properties.getValue("PrU");
		settings[:windUnit] = Application.Properties.getValue("WU");
		settings[:time1] = Application.Properties.getValue("T1TZ");
		settings[:keyOW] = Application.Properties.getValue("keyOW");
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

	function getBackgroundColor(){
	
		var color = Graphics.COLOR_BLACK;
		if (settings[:theme] == DARK){
			color = Graphics.COLOR_BLACK;
		}if (settings[:theme] == LIGHT){
			color = Graphics.COLOR_WHITE;
		}
		return color;
	}
	
	function getColorByFieldType(type){
		var color = getColor();
		if (type == CONNECTED){
			if (settings[:theme] == DARK){
				color = Graphics.COLOR_BLUE;
			}if (settings[:theme] == LIGHT){
				color = Graphics.COLOR_DK_BLUE;
			}
		}
		return color;
	}
	
	function getColor(){
		var color = Graphics.COLOR_WHITE;
		if (settings[:theme] == DARK){
			color = Graphics.COLOR_WHITE;
		}if (settings[:theme] == LIGHT){
			color = Graphics.COLOR_BLACK;
		}
		return color;
	}
	
	function setWeatherAutoColors(){
	
		var defColor = getColor();
		
		settings[:autoColors] = {
			:temp => defColor,
			:wind => defColor
		};

		if (weather != null){
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
			var dict = SettingsReference.windSpeedUnit();
			return Application.loadResource(Rez.Strings[dict[settings[:windUnit]]]);
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
		return PICTURE+Application.Properties.getValue(modeAsString()+id);
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
	
	function modeAsString(){
		var res = "G";
		if (mode == :D){
			res = "D";
		}else if (mode == :N){
			res = "N";	
		}
		return res;
	}
}