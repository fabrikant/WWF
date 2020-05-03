using Toybox.System;
using Toybox.Application;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.SensorHistory;

module Data{

	function getValueByFieldType(filedType, oldValue){

		var res = "";
		///////////////////////////////////////////////////////////////////////
		//TIME
		if (filedType == :time){

			var clockTime = System.getClockTime();
			res = getTimeString(clockTime);

		///////////////////////////////////////////////////////////////////////
		//SECONDS
		}else if (filedType == :sec){
			res = getSeconds();

		///////////////////////////////////////////////////////////////////////
		//AM PM
		}else if (filedType == :am){
			res = getAmPm();

		///////////////////////////////////////////////////////////////////////
		//DATE
		}else if (filedType == :date){

			var now = Time.now();
			var today = Gregorian.info(now, Time.FORMAT_SHORT);

			if (oldValue == null || memoryCache.oldValues[:todayDay] == null || memoryCache.oldValues[:todayDay] != today.day){
				memoryCache.oldValues[:todayDay] = today.day;
				res = getDateString(now);
	 		}else{
	 			res = oldValue;
			}

		///////////////////////////////////////////////////////////////////////
		//STATUS FIELDS
		}else if (filedType == :connnection){
			res = System.getDeviceSettings().connectionAvailable ? "c" : "";
		}else if (filedType == :messages){
			res = System.getDeviceSettings().notificationCount > 0 ? "i" : "";
		}else if (filedType == :dnd){
			res = System.getDeviceSettings().doNotDisturb ? "k" : "";
		}else if (filedType == :alarms){
			res = System.getDeviceSettings().alarmCount > 0 ? "a" : "";

		///////////////////////////////////////////////////////////////////////
		//DATA FIELDS
		}else if (filedType == HR){
			res = getHeartRate();
		}else if (filedType == STEPS){
			res = getSteps();
		}else if (filedType == PRESSURE){
			res = getPressure();
		}else if (filedType == TEMPERATURE){
			res = getTemperature();
		}else if (filedType == CALORIES){
			res = getCalories();
		}else if (filedType == DISTANCE){
			res = getDistance();
		}else if (filedType == FLOOR){
			res = getFloor();
		}else if (filedType == ELEVATION){
			res = getElevation();
		}else if (filedType == SUN_EVENT){
			res = getNextSunEvent();
		}else if (filedType == SUNRISE_EVENT){
			res = getSunrise();
		}else if (filedType == SUNSET_EVENT){
			res = getSunset();
		}else if (filedType == TIME1){
			res = getSecondTime();
		}else if (filedType == EMPTY){
			res = "";

		///////////////////////////////////////////////////////////////////////
		//DATA FIELDS IMAGES
		}else if (filedType == PICTURE + HR){
			res = "g";
		}else if (filedType == PICTURE + STEPS){
			res = "l";
		}else if (filedType == PICTURE + PRESSURE){
			res = "b";
		}else if (filedType == PICTURE + TEMPERATURE){
			res = "p";
		}else if (filedType == PICTURE + CALORIES){
			res = "d";
		}else if (filedType == PICTURE + DISTANCE){
			res = "e";
		}else if (filedType == PICTURE + FLOOR){
			res = "f";
		}else if (filedType == PICTURE + ELEVATION){
			res = "j";
		}else if (filedType == PICTURE + SUN_EVENT){
			res = "m";
		}else if (filedType == PICTURE + SUNRISE_EVENT){
			res = "n";
		}else if (filedType == PICTURE + SUNSET_EVENT){
			res = "o";
		}else if (filedType == PICTURE + TIME1){
			res = "q";
		}else if (filedType == PICTURE + EMPTY){
			res = "";

		///////////////////////////////////////////////////////////////////////
		//WEATHER
		}else if (filedType == :weather_picture){
			res = getWeatherPicture();
		}else if (filedType == :weather_temp){
			res = getWeatherTemperature();
		}else if (filedType == :weather_wind_dir){
			res = getWeatherWindDirection();
		}

		return res;
	}

	///////////////////////////////////////////////////////////////////////////
	function getTimeString(clockTime){

        // Get the current time and format it correctly
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        }
        var timeFormat = "$1$:$2$";
        if (memoryCache.settings[:time][:military]) {
            timeFormat = "$1$$2$";
        }
        if (memoryCache.settings[:time][:hours01] || memoryCache.settings[:time][:military]){
    		hours = hours.format("%02d");
    	}
       return Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

	}

	///////////////////////////////////////////////////////////////////////////
	function getDateString(now){
		var today = Gregorian.info(now, Time.FORMAT_MEDIUM);
		var todayShort = Gregorian.info(now, Time.FORMAT_SHORT);
		var firstDayOfYear = Gregorian.moment(
			{
				:year => today.year,
				:month => 1,
				:day =>1,
			}
		);
		var dur = firstDayOfYear.subtract(now);
		var dayOfYear = 1+dur.value()/Gregorian.SECONDS_PER_DAY;
		var weekFromFirstDay = dur.value()/(Gregorian.SECONDS_PER_DAY*7);
		var firstDayOfWeekSettings = System.getDeviceSettings().firstDayOfWeek;
		var dayOfWeek = todayShort.day_of_week;
		if (firstDayOfWeekSettings == 2){
			dayOfWeek = dayOfWeek == 1 ? 7 : dayOfWeek-1;
		} else if(firstDayOfWeekSettings == 7){
			dayOfWeek = dayOfWeek == 7 ? 1 : dayOfWeek+1;
		}

		var dateString = Application.Properties.getValue("DF");
		dateString = Tools.stringReplace(dateString,"%WN",Tools.weekOfYear(now));
		dateString = Tools.stringReplace(dateString,"%DN",dayOfYear);
		dateString = Tools.stringReplace(dateString,"%w",dayOfWeek);
		dateString = Tools.stringReplace(dateString,"%W",today.day_of_week);
		dateString = Tools.stringReplace(dateString,"%d",today.day);
		dateString = Tools.stringReplace(dateString,"%D",today.day.format("%02d"));
		dateString = Tools.stringReplace(dateString,"%m",todayShort.month.format("%02d"));
		dateString = Tools.stringReplace(dateString,"%M",today.month);
		dateString = Tools.stringReplace(dateString,"%y",today.year.toString().substring(2, 4));
		dateString = Tools.stringReplace(dateString,"%Y",today.year);

		return dateString;
	}

	///////////////////////////////////////////////////////////////////////////
	function getHeartRate(){
		var value = null;
		var info = Activity.getActivityInfo();
		if (info != null){
			if (info has :currentHeartRate){
				value = info.currentHeartRate;
			}
		}
		if (value == null){
			if (Toybox has :SensorHistory){
				if (Toybox.SensorHistory has :getHeartRateHistory){
					var iter = SensorHistory.getHeartRateHistory({:period =>1, :order => SensorHistory.ORDER_NEWEST_FIRST});
					if (iter != null){
						var sample = iter.next();
						if (sample != null){
							if (sample.data != null){
								value = sample.data.toString();
							}
						}
					}
				}
			}
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function getSteps(){
		var value = "";
		var info = ActivityMonitor.getInfo();
		if (info has :steps){
			value = info.steps;
			if (value > 9999){
				value = (value/1000).format("%.1f")+"k";
			}
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function getPressure(){

		var value = null;
		var info = Activity.getActivityInfo();
		if (info != null){
			if (info has :ambientPressure){
				if (info.ambientPressure != null){
					value = Tools.pressureToString(info.ambientPressure);
				}
			}
		}
		if (value == null){
			if (Toybox has :SensorHistory){
				if (Toybox.SensorHistory has :getPressureHistory){
					var iter = SensorHistory.getPressureHistory({:period =>1, :order => SensorHistory.ORDER_NEWEST_FIRST});
					if (iter != null){
						var sample = iter.next();
						if (sample != null){
							if (sample.data != null){
								value = Tools.pressureToString(sample.data);
							}
						}
					}
				}
			}
		}
		if (value == null){
			value = "";
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function getTemperature(){

		var value = "";
		if (Toybox has :SensorHistory){
			if (Toybox.SensorHistory has :getTemperatureHistory){
				var iter = SensorHistory.getTemperatureHistory({:period =>1, :order => SensorHistory.ORDER_NEWEST_FIRST});
				if (iter != null){
					var sample = iter.next();
					if (sample != null){
						if (sample.data != null){
							value = Tools.temperatureToString(sample.data);
						}
					}
				}
			}
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function getCalories(){
		var value = "";
		var info = ActivityMonitor.getInfo();
		if (info has :calories){
			value = info.calories;
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function getDistance(){
		var value = "";
		var info = ActivityMonitor.getInfo();
		if (info has :distance){
			value = Tools.distanceToString(info.distance);
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function getFloor(){
		var value = "";
		var info = ActivityMonitor.getInfo();
		if (info has :floorsClimbed){
			value = info.floorsClimbed.toString()
				+"/"+info.floorsDescended.toString();
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function getElevation(){

		var value = null;

		var info = Activity.getActivityInfo();
		if (info != null){
			if (info has :altitude){
				if (info.altitude != null){
					value = Tools.elevationToString(info.altitude);
				}
			}
		}
		if (value == null){
			if (Toybox has :SensorHistory){
				if (Toybox.SensorHistory has :getElevationHistory){
					var iter = SensorHistory.getElevationHistory({:period =>1, :order => SensorHistory.ORDER_NEWEST_FIRST});
					if (iter != null){
						var sample = iter.next();
						if (sample != null){
							if (sample.data != null){
								value = Tools.elevationToString(sample.data);
							}
						}
					}
				}
			}
		}
		if (value == null){
			value = 0;
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function getSunrise(){
		var value = "";
		var moment = Tools.getSunEvent(SUNRISE, true);
		if (moment == null) {
			value = noLocationString();
		} else {
			value = Tools.momentToString(moment);
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function getSunset(){
		var value = "";
		var moment = Tools.getSunEvent(SUNSET, true);
		if (moment == null) {
			value = noLocationString();
		} else {
			value = Tools.momentToString(moment);
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function getNextSunEvent(){
		var value = "";
		var sunset =  Tools.getSunEvent(SUNSET, false);
		var now = Time.now().value();
		if(sunset == null){
			value = noLocationString();
		}else{
			if (sunset.value() < now){
				value = Tools.momentToString(Tools.getSunEvent(SUNRISE, true));
			} else {
				var sunrise = Tools.getSunEvent(SUNRISE, false);
				if (now < sunrise.value()){
					value = Tools.momentToString(sunrise);
				}else{
					value = Tools.momentToString(sunset);
				}
			}
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function noLocationString(){
		return "gps";
	}

	///////////////////////////////////////////////////////////////////////////
	function getSecondTime(){
		var offset = memoryCache.settings[:time1]*60 - System.getClockTime().timeZoneOffset;
		var dur = new Time.Duration(offset);
		var secondTime = Time.now().add(dur);
		return Tools.momentToString(secondTime);
	}

	///////////////////////////////////////////////////////////////////////////
	function getAmPm(){
		var value = "";
		if (!System.getDeviceSettings().is24Hour && memoryCache.settings[:time][:am]) {
            if (System.getClockTime().hour < 12) {
				value = "A";
			}else{
				value = "P";
			}
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function getSeconds(){
		var value = "";
		if (memoryCache.settings[:time][:sec]) {
			value = System.getClockTime().sec.format("%02d");
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function getWeatherPicture(){
		var value = "";
		if ( memoryCache.weather != null){
			var dict = Refernce.weatherFontDictonary();
			value = dict[memoryCache.weather[STORAGE_KEY_ICON]];
			if (value == null){
				value = "";
			}else{
				value = value.toChar();
			}
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function getWeatherTemperature(){
		var value = "";
		if ( memoryCache.weather != null){
			value = memoryCache.weather[STORAGE_KEY_TEMP];
			if (value == null){
				value = "";
			}else{
				value = Tools.temperatureToString(value)+"°";
			}
		}
		return value;
	}
	///////////////////////////////////////////////////////////////////////////
	function getWeatherWindDirection(){
		var value = -1;
		if ( memoryCache.weather != null){
			value = memoryCache.weather[STORAGE_KEY_WIND_DEG];
			if (value == null){
				value = -1;
			}
		}
		return value;
	}
	///////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////

}