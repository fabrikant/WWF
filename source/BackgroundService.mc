//{
//   "coord":{
//      "lon":73.37,
//      "lat":54.99
//   },
//   "weather":[
//      {
//         "id":803,on temp
//         "main":"Clouds",
//         "description":"пасмурно",
//         "icon":"04d"
//      }
//   ],
//   "base":"stations",
//   "main":{on temp
//      "temp":11,
//      "pressure":996,
//      "humidity":57,
//      "temp_min":11,
//      "temp_max":11
//   },
//   "visibility":10000,
//   "wind":{
//      "speed":9,
//      "deg":280
//   },
//   "clouds":{
//      "all":75
//   },
//   "dt":1572253458,
//   "sys":{nfv gjkexfnm lfyyst
//      "type":1,
//      "id":8960,
//      "country":"RU",
//      "sunrise":1572228039,
//      "sunset":1572262790
//   },
//   "timezone":21600,
//   "id":1496153,
//   "name":"Omsk",
//   "cod":200
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

		var connStat = System.getDeviceSettings().connectionInfo;
		if (connStat != System.CONNECTION_STATE_CONNECTED){
			Background.exit(null);
		}

		var url = "https://api.openweathermap.org/data/2.5/weather";

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
				"units" => "metric"
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
				STORAGE_KEY_TEMP => data["main"]["temp"],
				STORAGE_KEY_HUMIDITY => data["main"]["humidity"],
				STORAGE_KEY_PRESSURE => data["main"]["pressure"],
				STORAGE_KEY_ICON => data["weather"][0]["icon"],
				STORAGE_KEY_WIND_SPEED => data["wind"]["speed"],
				STORAGE_KEY_WIND_DEG => data["wind"]["deg"],
				STORAGE_KEY_DT => data["dt"],
			};
		} else {
			backgroundData = {
				STORAGE_KEY_RESPONCE_CODE => responseCode,
				STORAGE_KEY_RECIEVE => Time.now().value(),
			};
		}

		Background.exit(backgroundData);
	}
}