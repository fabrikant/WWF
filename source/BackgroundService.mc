// {
//   "coord": {
//     "lon": 73,
//     "lat": 54
//   },
//   "weather": [
//     {
//       "id": 804,
//       "main": "Clouds",
//       "description": "overcast clouds",
//       "icon": "04d"
//     }
//   ],
//   "base": "stations",
//   "main": {
//     "temp": 292.78,
//     "feels_like": 292.16,
//     "temp_min": 292.78,
//     "temp_max": 292.78,
//     "pressure": 1002,
//     "humidity": 52,
//     "sea_level": 1002,
//     "grnd_level": 989
//   },
//   "visibility": 10000,
//   "wind": {
//     "speed": 5.59,
//     "deg": 128,
//     "gust": 9.22
//   },
//   "clouds": {
//     "all": 100
//   },
//   "dt": 1753419623,
//   "sys": {
//     "country": "RU",
//     "sunrise": 1753398576,
//     "sunset": 1753456747
//   },
//   "timezone": 18000,
//   "id": 1496380,
//   "name": "Odesskoye",
//   "cod": 200
// }

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
    var url = "https://api.openweathermap.org/data/2.5/weather";

    var lat = Application.Storage.getValue("Lat");
    var lon = Application.Storage.getValue("Lon");
    var appid = Application.Properties.getValue("keyOW");

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
        "lang" => getLang(),
      },
      {},
      method(:responseCallback)
    );
  }

  function responseCallback(responseCode, data) {
    var backgroundData;
    //////////////////////////////////////////////////////////
    //DEBUG
    //		System.println("responseCallback: "+Time.now().value());
    //		System.println("responseCode: "+responseCode);
    //		System.println("data: "+data);
    //////////////////////////////////////////////////////////

    if (responseCode == 200) {
      var weatherDesription = data["weather"][0]["description"];
      if (weatherDesription == null) {
        weatherDesription = "";
      }

      backgroundData = {
        STORAGE_KEY_RESPONCE_CODE => responseCode,
        STORAGE_KEY_RECIEVE => Time.now().value(),
        STORAGE_KEY_TEMP => data["main"]["temp"],
        STORAGE_KEY_HUMIDITY => data["main"]["humidity"],
        STORAGE_KEY_PRESSURE => data["main"]["pressure"],
        STORAGE_KEY_ICON => data["weather"][0]["icon"],
        STORAGE_KEY_WIND_SPEED => data["wind"]["speed"],
        STORAGE_KEY_WIND_DEG => data["wind"]["deg"],
        STORAGE_KEY_WEATHER_DESCRIPTION => weatherDesription,
      };
    } else {
      backgroundData = {
        STORAGE_KEY_RESPONCE_CODE => responseCode,
        STORAGE_KEY_RECIEVE => Time.now().value(),
      };
    }

    Background.exit(backgroundData);
  }

  function getLang() {
    var res = "en";
    var sysLang = System.getDeviceSettings().systemLanguage;

    if (sysLang == System.LANGUAGE_ARA) {
      res = "ar";
    } else if (sysLang == System.LANGUAGE_BUL) {
      res = "bg";
    } else if (sysLang == System.LANGUAGE_CES) {
      res = "cz";
    } else if (sysLang == System.LANGUAGE_CHS) {
      res = "zh_cn";
    } else if (sysLang == System.LANGUAGE_CHT) {
      res = "zh_tw";
    } else if (sysLang == System.LANGUAGE_DAN) {
      res = "da";
    } else if (sysLang == System.LANGUAGE_DEU) {
      res = "de";
    } else if (sysLang == System.LANGUAGE_DUT) {
      res = "de";
    } else if (sysLang == System.LANGUAGE_FIN) {
      res = "fi";
    } else if (sysLang == System.LANGUAGE_FRE) {
      res = "fr";
    } else if (sysLang == System.LANGUAGE_GRE) {
      res = "el";
    } else if (sysLang == System.LANGUAGE_HEB) {
      res = "he";
    } else if (sysLang == System.LANGUAGE_HRV) {
      res = "hr";
    } else if (sysLang == System.LANGUAGE_HUN) {
      res = "hu";
    } else if (sysLang == System.LANGUAGE_IND) {
      res = "hi";
    } else if (sysLang == System.LANGUAGE_ITA) {
      res = "it";
    } else if (sysLang == System.LANGUAGE_JPN) {
      res = "ja";
    } else if (sysLang == System.LANGUAGE_KOR) {
      res = "	kr";
    } else if (sysLang == System.LANGUAGE_LAV) {
      res = "la";
    } else if (sysLang == System.LANGUAGE_LIT) {
      res = "lt";
    } else if (sysLang == System.LANGUAGE_NOB) {
      res = "no";
    } else if (sysLang == System.LANGUAGE_POL) {
      res = "pl";
    } else if (sysLang == System.LANGUAGE_POR) {
      res = "pt";
    } else if (sysLang == System.LANGUAGE_RON) {
      res = "ro";
    } else if (sysLang == System.LANGUAGE_RUS) {
      res = "ru";
    } else if (sysLang == System.LANGUAGE_SLO) {
      res = "sk";
    } else if (sysLang == System.LANGUAGE_SLV) {
      res = "	sl";
    } else if (sysLang == System.LANGUAGE_SPA) {
      res = "sp";
    } else if (sysLang == System.LANGUAGE_SWE) {
      res = "sv";
    } else if (sysLang == System.LANGUAGE_THA) {
      res = "th";
    } else if (sysLang == System.LANGUAGE_TUR) {
      res = "tr";
    } else if (sysLang == System.LANGUAGE_UKR) {
      res = "ua";
    } else if (sysLang == System.LANGUAGE_VIE) {
      res = "vi";
    } else if (sysLang == System.LANGUAGE_ZSM) {
      res = "zu";
    }
    return res;
  }
}
