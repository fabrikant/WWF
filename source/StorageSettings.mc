using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;
using Toybox.Lang;

//*****************************************************************************
module StorageSettings {

	///////////////////////////////////////////////////////////////////////////
	function getSettingValue(key){
		return Application.Properties.getValue(key); 
	}
	

	function propertyDescription(name, value){
	
		var dictNames = {
			"PrU" => :pressureUnit,
			"WU" => :windSpeedUnit,
			"Theme" => :theme,
			"WType" => :widgetType,
			"GSF0" => :statusField,
			"GSF1" => :statusField,
			"GSF2" => :statusField,
			"GSF3" => :statusField,
			"GSF4" => :statusField,
			"GSF5" => :statusField,
			"GSF6" => :statusField,
			"GF0" => :field,
			"GF1" => :field,
			"GF2" => :field,
			"GF3" => :field,
			"GF4" => :field,
			"GF5" => :field,
			"GF6" => :field,
			"GF7" => :field,
			"DSF0" => :statusField,
			"DSF1" => :statusField,
			"DSF2" => :statusField,
			"DSF3" => :statusField,
			"DSF4" => :statusField,
			"DSF5" => :statusField,
			"DSF6" => :statusField,
			"DF0" => :field,
			"DF1" => :field,
			"DF2" => :field,
			"DF3" => :field,
			"DF4" => :field,
			"DF5" => :field,
			"DF6" => :field,
			"DF7" => :field,
			"NSF0" => :statusField,
			"NSF1" => :statusField,
			"NSF2" => :statusField,
			"NSF3" => :statusField,
			"NSF4" => :statusField,
			"NSF5" => :statusField,
			"NSF6" => :statusField,
			"NF0" => :field,
			"NF1" => :field,
			"NF2" => :field,
			"NF3" => :field,
			"NF4" => :field,
			"NF5" => :field,
			"NF6" => :field,
			"NF7" => :field,
		};
	
		var methodSymbol = dictNames[name];
		if (methodSymbol == null){
			return value.toString();
		}else{
			var dictValues = null;
			if (methodSymbol == :field){
				dictValues = field();
			}else if(methodSymbol == :statusField){
				dictValues = statusField();
			}else if(methodSymbol == :pressureUnit){
				dictValues = pressureUnit();
			}else if(methodSymbol == :windSpeedUnit){
				dictValues = windSpeedUnit();
			}else if(methodSymbol == :theme){
				dictValues = theme();
			}else if(methodSymbol == :widgetType){
				dictValues = widgetType();
			}
			return Application.loadResource(Rez.Strings[dictValues[value]]);
		}
	} 
	
	function theme(){
		return {
			0 => :ThemeDark,
			1 => :ThemeLight
		};
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