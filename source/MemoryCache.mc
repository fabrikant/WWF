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
		settings[:colors][:weatherAutoColors] = Application.Properties.getValue("WAutoColor");

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
		settings[:hrUpdate] = Application.Properties.getValue("HREverySec");
	}

	function readGeolocation(){
		//////////////////////////////////////////////////////////
		//DEBUG
//		Application.Storage.setValue("Lat", 55.03325);
//		Application.Storage.setValue("Lon", 73.449715);
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
		var defColor = settings[:colors][:weather];
		settings[:autoColors] = {
			:cloud => defColor,
			:temp => defColor,
			:wind => defColor
		};

		if (settings[:colors][:weatherAutoColors] && weather != null){
			var backgroundColor = settings[:colors][:background1];

			//temperature
			var tmpValue = weather[STORAGE_KEY_TEMP];
			if (tmpValue != null){
				if (tmpValue > 30){
					settings[:autoColors][:temp] = Graphics.COLOR_PURPLE;
				}else if (tmpValue > 25){
					settings[:autoColors][:temp] = Graphics.COLOR_DK_RED;
				}else if (tmpValue > 20){
					settings[:autoColors][:temp] = Graphics.COLOR_RED;
				}else if (tmpValue > 15){
					settings[:autoColors][:temp] = Graphics.COLOR_DK_GREEN;
				}else if (tmpValue > 10){
					settings[:autoColors][:temp] = Graphics.COLOR_GREEN;
				}else if (tmpValue > 5){
					settings[:autoColors][:temp] = Graphics.COLOR_YELLOW;
				}else if (tmpValue > 0){
					settings[:autoColors][:temp] = Graphics.COLOR_WHITE;
				}else if (tmpValue > -10){
					settings[:autoColors][:temp] = Graphics.COLOR_BLUE;
				}else{
					settings[:autoColors][:temp] = Graphics.COLOR_DK_BLUE;
				}
				settings[:autoColors][:temp] = altColor(settings[:autoColors][:temp], backgroundColor);
			}

			//wind speed
			tmpValue = weather[STORAGE_KEY_WIND_SPEED];
			if (tmpValue != null){
				tmpValue = Tools.getBeaufort(tmpValue);
				if (tmpValue > 9){
					settings[:autoColors][:wind] = Graphics.COLOR_PURPLE;
				}else if (tmpValue > 7){
					settings[:autoColors][:wind] = Graphics.COLOR_DK_RED;
				}else if (tmpValue > 6){
					settings[:autoColors][:wind] = Graphics.COLOR_RED;
				}else if (tmpValue > 5){
					settings[:autoColors][:wind] = Graphics.COLOR_DK_BLUE;
				}else if (tmpValue > 4){
					settings[:autoColors][:wind] = Graphics.COLOR_BLUE;
				}else if (tmpValue > 3){
					settings[:autoColors][:wind] = Graphics.COLOR_DK_GREEN;
				}else if (tmpValue > 2){
					settings[:autoColors][:wind] = Graphics.COLOR_GREEN;
				}else{
					settings[:autoColors][:wind] = Graphics.COLOR_LT_GRAY;
				}
				settings[:autoColors][:wind] = altColor(settings[:autoColors][:wind], backgroundColor);
			}

			//cloud
			tmpValue = weather[STORAGE_KEY_ICON];
			if (tmpValue != null){
				if (tmpValue.equals("01d") || tmpValue.equals("01n")){
					settings[:autoColors][:cloud] = Graphics.COLOR_ORANGE;
				} else if (tmpValue.equals("13d") || tmpValue.equals("13n")){
					settings[:autoColors][:cloud] = Graphics.COLOR_DK_BLUE;
				}
				settings[:autoColors][:cloud] = altColor(settings[:autoColors][:cloud], backgroundColor);
			}
		}
	}

	function altColor(color, backgroundColor){
		var res = color;
		if (color == backgroundColor){
			if (color == Graphics.COLOR_PURPLE){
				res = Graphics.COLOR_PINK;
			}else if (color == Graphics.COLOR_PINK){
				res = Graphics.COLOR_PURPLE;
			}else if (color == Graphics.COLOR_WHITE){
				res = Graphics.COLOR_LT_GRAY;
			}else if (color == Graphics.COLOR_LT_GRAY){
				res = Graphics.COLOR_DK_GRAY;
			}else if (color == Graphics.COLOR_DK_GRAY){
				res = Graphics.COLOR_LT_GRAY;
			}else if (color == Graphics.COLOR_GREEN){
				res = Graphics.COLOR_DK_GREEN;
			}else if (color == Graphics.COLOR_DK_GREEN){
				res = Graphics.COLOR_GREEN;
			}else if (color == Graphics.COLOR_RED){
				res = Graphics.COLOR_DK_RED;
			}else if (color == Graphics.COLOR_DK_RED){
				res = Graphics.COLOR_RED;
			}else if (color == Graphics.COLOR_YELLOW){
				res = Graphics.COLOR_ORANGE;
			}else if (color == Graphics.COLOR_ORANGE){
				res = Graphics.COLOR_YELLOW;
			}else if (color == Graphics.COLOR_BLACK){
				res = Graphics.COLOR_DK_GRAY;
			}else if (color == Graphics.COLOR_BLUE){
				res = Graphics.COLOR_DK_BLUE;
			}else if (color == Graphics.COLOR_DK_BLUE){
				res = Graphics.COLOR_BLUE;
			}
		}
		
		if (backgroundColor == Graphics.COLOR_BLACK){
			if (res == Graphics.COLOR_DK_BLUE){
				res = Graphics.COLOR_BLUE;
			}else if (res == Graphics.COLOR_DK_RED){
				res = Graphics.COLOR_RED;
			}
		}else if (backgroundColor == Graphics.COLOR_WHITE){
			if (res == Graphics.COLOR_YELLOW){
				res = Graphics.COLOR_ORANGE;			
			}else if (res == Graphics.COLOR_LT_GRAY){
				res = Graphics.COLOR_DK_GRAY;			
			}
		}
		return res;
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
	
	function getPropertiesKeys(){
		var res = [];
	    res.add("MilFt");
		res.add("HFt01");
		res.add("AmPm");
		res.add("Sec");
		res.add("HREverySec");
		res.add("DF");
	    res.add("BgndColor1");
	    res.add("BgndColor2");
	    res.add("BgndColor3");
	    res.add("TimeColor");
	    res.add("DateColor");
	    res.add("WColor");
	    res.add("WAutoColor");
	    res.add("WShowHumPr");
	    res.add("BatColor");
	    res.add("MoonColor");
		res.add("ConCol");
		res.add("MesCol");
		res.add("DNDCol");
		res.add("AlCol");
		res.add("WUpdInt");
		res.add("PrU");
		res.add("WU");
		res.add("T1TZ");
		res.add("F0");
		res.add("C0");
		res.add("F1");
		res.add("C1");
		res.add("F2");
		res.add("C2");
		res.add("F3");
		res.add("C3");
		res.add("F4");
		res.add("C4");
		res.add("F5");
		res.add("C5");
		return res;
	}
}