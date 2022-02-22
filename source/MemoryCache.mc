using Toybox.Application;
using Toybox.System;

class MemoryCache {

	var settings;
	var weather;
	var everySecondFields;
	var flags;
	var sunEvents;
	var moonPhase;
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
		moonPhase = {};
	}

	function readSettings(){

		settings = {};
		settings[:switchDayNight] = Application.Properties.getValue("SwitchDayNight");
		settings[:DNDisNight] = Application.Properties.getValue("DNDisNight");
		settings[:AgrRend] = Application.Properties.getValue("AgrRend");
		
		var propName = "GTheme";
		if (mode == :D){
			propName = "DTheme";
		}else if(mode == :N){
			propName = "NTheme";
		}
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
//		Application.Storage.setValue("Lat", 55.03325);
//		Application.Storage.setValue("Lon", 73.449715);
//		Application.Properties.setValue("keyOW", "69bcb8de48220cd2b2fb7a8400c68d1e");
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

	function themeIsDark(){
		var res = false;
		if (settings[:theme] == DARK 
			|| settings[:theme] == DARK_MONOCHROME
			|| settings[:theme] == DARK_COLOR
			|| settings[:theme] == DARK_RED_COLOR
			|| settings[:theme] == DARK_GREEN_COLOR
			|| settings[:theme] == DARK_BLUE_COLOR){
			res = true;
		}
		return res;
	}
	
	function themeIsMonochrome(){
		var res = false;
		if (settings[:theme] == DARK_MONOCHROME 
			|| settings[:theme] == LIGHT_MONOCHROME 
			|| settings[:theme] == LIGHT_RED_COLOR
			|| settings[:theme] == LIGHT_GREEN_COLOR
			|| settings[:theme] == LIGHT_BLUE_COLOR
			|| settings[:theme] == DARK_RED_COLOR
			|| settings[:theme] == DARK_GREEN_COLOR
			|| settings[:theme] == DARK_BLUE_COLOR)
		{
			res = true;
		}
		return res;
	}
	
	function getBackgroundColor(){
	
		var color = Graphics.COLOR_BLACK;
		if (settings[:theme] == DARK_RED_COLOR){
			color = 0x550000;
		} else if (settings[:theme] == DARK_GREEN_COLOR){
			color = 0x005555;			
		} else if (settings[:theme] == DARK_BLUE_COLOR){
			color = 0x000055;			
		}else if (settings[:theme] == LIGHT_RED_COLOR){
			color = 0xff5555;
		} else if (settings[:theme] == LIGHT_GREEN_COLOR){
			color = 0x00ffaa;			
		} else if (settings[:theme] == LIGHT_BLUE_COLOR){
			color = 0x55aaff;			
		} else if (themeIsDark()){
			color = Graphics.COLOR_BLACK;
		}else{
			color = Graphics.COLOR_WHITE;
		}
		return color;
	}
	
	
	function getColor(){
		var color = Graphics.COLOR_WHITE;
		if (themeIsDark()){
			color = Graphics.COLOR_WHITE;
		}else{
			color = Graphics.COLOR_BLACK;
		}
		return color;
	}
	
	function getColorByFieldType(type){
		
		var color = getColor();
		
		var dictColors = {
			CONNECTED => {DARK => Graphics.COLOR_BLUE, 
						LIGHT => Graphics.COLOR_DK_BLUE},
			:moon	  => {DARK => Graphics.COLOR_ORANGE, 
						LIGHT => Graphics.COLOR_ORANGE}};		
		
		if (settings[:theme] == DARK_COLOR || settings[:theme] == LIGHT_COLOR){
			dictColors = {
				CONNECTED => {DARK_COLOR => Graphics.COLOR_BLUE,
							  LIGHT_COLOR => Graphics.COLOR_DK_BLUE},
				:moon	  => {DARK_COLOR => Graphics.COLOR_ORANGE,
							  LIGHT_COLOR => Graphics.COLOR_ORANGE},
				MOON	  => {DARK_COLOR => Graphics.COLOR_ORANGE,
							  LIGHT_COLOR => Graphics.COLOR_ORANGE},
				HR	=> {DARK_COLOR => 0xFF55FF,
						LIGHT_COLOR => 0xFF0000},
				:getHeartRateHistory	=> {DARK_COLOR => 0xFF55FF,
						LIGHT_COLOR => 0xFF0000},
				STEPS => {DARK_COLOR => Graphics.COLOR_ORANGE,
						LIGHT_COLOR =>Graphics.COLOR_ORANGE},
				CALORIES => {DARK_COLOR => 0xFFFFAA,
						LIGHT_COLOR => 0xAA5500},
				DISTANCE => {DARK_COLOR => 0xAAFFFF,
						LIGHT_COLOR => 0x5500AA},		
				FLOOR => {DARK_COLOR => 0xFFFF55,
						LIGHT_COLOR => 0xAA5500},		
				ACTIVE_DAY => {DARK_COLOR => 0xAAFFAA,
						LIGHT_COLOR => 0x555500},		
				ACTIVE_WEEK => {DARK_COLOR => 0xAAFFAA,
						LIGHT_COLOR => 0x555500},		
				WEIGHT => {DARK_COLOR => 0xAAFFFF,
						LIGHT_COLOR => 0x0000FF},		
				O2 => {DARK_COLOR => 0xAAFFFF,
						LIGHT_COLOR => 0x0000AA},		
				:getOxygenSaturationHistory => {DARK_COLOR => 0xAAFFFF,
						LIGHT_COLOR => 0x0000AA},		
				SUN_EVENT => {DARK_COLOR => 0xFFAAFF,
						LIGHT_COLOR => 0xAA0000},		
				SUNRISE_EVENT => {DARK_COLOR => 0xFFAAFF,
						LIGHT_COLOR => 0xAA0000},		
				SUNSET_EVENT => {DARK_COLOR => 0xFFAAFF,
						LIGHT_COLOR => 0xAA0000},		
				:solar => {DARK_COLOR => 0xFFAAFF,
						LIGHT_COLOR => 0xAA0000},		
				PRESSURE => {DARK_COLOR => 0xFFFFAA,
						LIGHT_COLOR => 0xAA5500},		
				:getPressureHistory => {DARK_COLOR => 0xFFFFAA,
						LIGHT_COLOR => 0xAA5500},		
				TEMPERATURE => {DARK_COLOR => 0xFFFFAA,
						LIGHT_COLOR => 0xAA5500},		
				:getTemperatureHistory => {DARK_COLOR => 0xFFFFAA,
						LIGHT_COLOR => 0xAA5500},		
				ELEVATION => {DARK_COLOR => 0xAAFFFF,
						LIGHT_COLOR => 0x0000AA},		
				:getElevationHistory => {DARK_COLOR => 0xAAFFFF,
						LIGHT_COLOR => 0x0000AA},		
				SOLAR_CHARGE => {DARK_COLOR => 0xFFAAFF,
						LIGHT_COLOR => 0x5500AA},		
				WEATHER_TEMPERATURE => {DARK_COLOR => settings[:autoColors][:temp],
						LIGHT_COLOR => settings[:autoColors][:temp]},		
				WEATHER_PRESSURE => {DARK_COLOR => 0xFFFFAA,
						LIGHT_COLOR => 0xAA5500},		
				WEATHER_WIND_SPEED => {DARK_COLOR => settings[:autoColors][:wind],
						LIGHT_COLOR => settings[:autoColors][:wind]},		
				WEATHER_WIND_DEG => {DARK_COLOR => settings[:autoColors][:wind],
						LIGHT_COLOR => settings[:autoColors][:wind]},		
				WEATHER_HUM => {DARK_COLOR => 0x00FFFF,
						LIGHT_COLOR => 0x0000AA},		
				WEATHER_VISIBILITY => {DARK_COLOR => 0xAAFFFF,
						LIGHT_COLOR => 0x550055},		
				WEATHER_UVI => {DARK_COLOR => 0xFFAAFF,
						LIGHT_COLOR => 0x5500AA},		
				WEATHER_DEW_POINT => {DARK_COLOR => 0x00FFFF,
						LIGHT_COLOR => 0x0000AA},		
			};
		}
		var fType = type;
		if (fType instanceof Toybox.Lang.Number){
			if (fType >= PICTURE){
				fType -= PICTURE;
			}
		}
		
		if (dictColors[fType] != null){
			var _color = dictColors[fType][settings[:theme]]; 
			if (_color != null){
				color = _color;
			}
		}
		return color;
	}

	function setWeatherAutoColors(){
	
		var defColor = getColor();
		
		settings[:autoColors] = {
			:temp => defColor,
			:wind => defColor
		};
		
		if (themeIsMonochrome()){
			return;
		}
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