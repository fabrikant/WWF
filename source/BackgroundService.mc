//{
//   "lat":55.75,
//   "lon":37.61,
//   "timezone":"Europe/Moscow",
//   "timezone_offset":10800,
//   "current":{
//      "dt":1614746546,
//      "sunrise":1614744953,
//      "sunset":1614784047,
//      "temp":-2.94,
//      "feels_like":-9.34,
//      "pressure":1014,
//      "humidity":68,
//      "dew_point":-7.44,
//      "uvi":0.13,
//      "clouds":0,
//      "visibility":10000,
//      "wind_speed":5,
//      "wind_deg":290,
//      "weather":[
//         {
//            "id":800,
//            "main":"Clear",
//            "description":"clear sky",
//            "icon":"01d"
//         }
//      ]
//   },
//   "alerts":[
//      {
//         "sender_name":"",
//         "event":"Wind",
//         "start":1614675600,
//         "end":1614848400,
//         "description":""
//      },
//      {
//         "sender_name":"",
//         "event":"Ветер",
//         "start":1614675600,
//         "end":1614848400,
//         "description":"местами порывы 15-17"
//      },
//      {
//         "sender_name":"",
//         "event":"Other dangers",
//         "start":1614744000,
//         "end":1614848400,
//         "description":""
//      },
//      {
//         "sender_name":"",
//         "event":"Прочие опасности",
//         "start":1614744000,
//         "end":1614848400,
//         "description":"Гололедица"
//      }
//   ]
//}

using Toybox.Background;
using Toybox.Communications;
using Toybox.System;
using Toybox.Position;
using Toybox.Time;


(:background)
class BackgroundService extends System.ServiceDelegate {

	function initialize() {
        ServiceDelegate.initialize();
    }

	function onTemporalEvent() {

		var url = "https://api.openweathermap.org/data/2.5/onecall";

		var lat = Application.Storage.getValue("Lat");
		var lon = Application.Storage.getValue("Lon");
		var appid = Application.Properties.getValue("keyOW");

//		var lat = memoryCache.settings[:geoLocation][0];
//		var lon = memoryCache.settings[:geoLocation][1];
//		var appid = memoryCache.settings[:apiKey];

		//////////////////////////////////////////////////////////
		//DEBUG
		//System.println("onTemporalEvent: "+Time.now().value());
		//////////////////////////////////////////////////////////
		Communications.makeWebRequest(
			url,
			{
				"lat" => lat,
				"lon" => lon,
				"appid" => appid,
				"units" => "metric",
				"exclude" => "minutely,hourly,daily",
				"lang" => getLang()				
			},
			{},
			method(:responseCallback)
		);
	}

	function responseCallback(responseCode, data) {
		var backgroundData;
		var app = Application.getApp();
		//////////////////////////////////////////////////////////
		//DEBUG
//		System.println("responseCallback: "+Time.now().value());
//		System.println("responseCode: "+responseCode);
//		System.println("data: "+data);
		//////////////////////////////////////////////////////////
		if (responseCode == 200) {
			backgroundData = {
				STORAGE_KEY_RESPONCE_CODE => responseCode,
				STORAGE_KEY_RECIEVE => Time.now().value(),
				STORAGE_KEY_TEMP => data["current"]["temp"],
				STORAGE_KEY_HUMIDITY => data["current"]["humidity"],
				STORAGE_KEY_PRESSURE => data["current"]["pressure"],
				STORAGE_KEY_ICON => data["current"]["weather"][0]["icon"],
				STORAGE_KEY_WIND_SPEED => data["current"]["wind_speed"],
				STORAGE_KEY_WIND_DEG => data["current"]["wind_deg"],
				STORAGE_KEY_DT => data["current"]["dt"],
				STORAGE_KEY_UVI => data["current"]["uvi"],
				STORAGE_KEY_DEW_POINT => data["current"]["dew_point"],
				STORAGE_KEY_VISIBILITY => data["current"]["visibility"],
				STORAGE_KEY_WEATHER_DESCRIPTION => data["current"]["weather"][0]["main"],
			};
		} else {
			backgroundData = {
				STORAGE_KEY_RESPONCE_CODE => responseCode,
				STORAGE_KEY_RECIEVE => Time.now().value(),
			};
		}

		Background.exit(backgroundData);
	}
	
	function getLang(){
		
		var res = "en";
		var sysLang = System.getDeviceSettings().systemLanguage;
		
		if (sysLang == System.LANGUAGE_ARA){
			res = "ar";
		}else if (sysLang  == System.LANGUAGE_BUL){
			res = "bg";		
		}else if (sysLang == System.LANGUAGE_CES){
			res = "cz";		
		}else if (sysLang == System.LANGUAGE_CHS){
			res = "zh_cn";		
		}else if (sysLang == System.LANGUAGE_CHT){
			res = "zh_tw";		
		}else if (sysLang == System.LANGUAGE_DAN){
			res = "da";		
		}else if (sysLang == System.LANGUAGE_DEU){
			res = "de";		
		}else if (sysLang == System.LANGUAGE_DUT){
			res = "de";		
		}else if (sysLang == System.LANGUAGE_FIN){
			res = "fi";		
		}else if (sysLang == System.LANGUAGE_FRE){
			res = "fr";		
		}else if (sysLang == System.LANGUAGE_GRE){
			res = "el";		
		}else if (sysLang == System.LANGUAGE_HEB){
			res = "he";		
		}else if (sysLang == System.LANGUAGE_HRV){
			res = "hr";		
		}else if (sysLang == System.LANGUAGE_HUN){
			res = "hu";		
		}else if (sysLang == System.LANGUAGE_IND){
			res = "hi";		
		}else if (sysLang == System.LANGUAGE_ITA){
			res = "it";		
		}else if (sysLang == System.LANGUAGE_JPN){
			res = "ja";		
		}else if (sysLang == System.LANGUAGE_KOR){
			res = "	kr";		
		}else if (sysLang == System.LANGUAGE_LAV){
			res = "la";		
		}else if (sysLang == System.LANGUAGE_LIT){
			res = "lt";		
		}else if (sysLang == System.LANGUAGE_NOB){
			res = "no";		
		}else if (sysLang == System.LANGUAGE_POL){
			res = "pl";		
		}else if (sysLang == System.LANGUAGE_POR){
			res = "pt";		
		}else if (sysLang == System.LANGUAGE_RON){
			res = "ro";		
		}else if (sysLang == System.LANGUAGE_RUS){
			res = "ru";		
		}else if (sysLang == System.LANGUAGE_SLO){
			res = "sk";		
		}else if (sysLang == System.LANGUAGE_SLV){
			res = "	sl";		
		}else if (sysLang == System.LANGUAGE_SPA){
			res = "sp";		
		}else if (sysLang == System.LANGUAGE_SWE){
			res = "sv";		
		}else if (sysLang == System.LANGUAGE_THA){
			res = "th";		
		}else if (sysLang == System.LANGUAGE_TUR){
			res = "tr";		
		}else if (sysLang == System.LANGUAGE_UKR){
			res = "ua";		
		}else if (sysLang == System.LANGUAGE_VIE){
			res = "vi";		
		}else if (sysLang == System.LANGUAGE_ZSM){
			res = "zu";		
		}
		return res;
	}	
}