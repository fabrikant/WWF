using Toybox.Application;
using Toybox.System;

class MemoryCache {
  var settings;
  var weather;
  var everySecondFields;
  var sunEvents;
  var moonPhase;
  var mode; // :G, :D, :N

  function initialize() {
    reload();
  }

  function reload() {
    //Erase all feilds for clear RAM before saveSettings
    everySecondFields = null;
    settings = {};
    weather = null;
    //		var view = Application.getApp().view;
    //		if (view instanceof WWFView){
    //			view.fields = null;
    //		}

    mode = :G;
    readWeather();
    sunEvents = {};
    moonPhase = {};
  }

  function readWeather() {
    weather = Application.Storage.getValue(STORAGE_KEY_WEATHER);
    setWeatherAutoColors();
    //////////////////////////////////////////////////////////
    //DEBUG
    //System.println("onReadWeather: "+weather);
    //////////////////////////////////////////////////////////
  }

  function modeToString() {
    var res = "G";
    if (mode == :N) {
      res = "N";
    } else if (mode == :D) {
      res = "D";
    }
    return res;
  }

  function themeIsDark() {
    var res = false;
    var theme = Application.Properties.getValue(modeToString() + "Theme");
    if (
      theme == DARK ||
      theme == DARK_MONOCHROME ||
      theme == DARK_COLOR ||
      theme == DARK_RED_COLOR ||
      theme == DARK_GREEN_COLOR ||
      theme == DARK_BLUE_COLOR
    ) {
      res = true;
    }
    return res;
  }

  function themeIsMonochrome() {
    var res = false;
    var theme = Application.Properties.getValue(modeToString() + "Theme");
    if (
      theme == DARK_MONOCHROME ||
      theme == LIGHT_MONOCHROME ||
      theme == LIGHT_RED_COLOR ||
      theme == LIGHT_GREEN_COLOR ||
      theme == LIGHT_BLUE_COLOR ||
      theme == DARK_RED_COLOR ||
      theme == DARK_GREEN_COLOR ||
      theme == DARK_BLUE_COLOR
    ) {
      res = true;
    }
    return res;
  }

  function getBackgroundColor() {
    var color = Graphics.COLOR_BLACK;
    var theme = Application.Properties.getValue(modeToString() + "Theme");
    if (theme == DARK_RED_COLOR) {
      color = 0x550000;
    } else if (theme == DARK_GREEN_COLOR) {
      color = 0x005555;
    } else if (theme == DARK_BLUE_COLOR) {
      color = 0x000055;
    } else if (theme == LIGHT_RED_COLOR) {
      color = 0xff5555;
    } else if (theme == LIGHT_GREEN_COLOR) {
      color = 0x00ffaa;
    } else if (theme == LIGHT_BLUE_COLOR) {
      color = 0x55aaff;
    } else if (themeIsDark()) {
      color = Graphics.COLOR_BLACK;
    } else {
      color = Graphics.COLOR_WHITE;
    }
    return color;
  }

  function getColor() {
    var color = Graphics.COLOR_WHITE;
    if (themeIsDark()) {
      color = Graphics.COLOR_WHITE;
    } else {
      color = Graphics.COLOR_BLACK;
    }
    return color;
  }

  function getColorByFieldType(type) {
    var color = getColor();
    var theme = Application.Properties.getValue(modeToString() + "Theme");
    var dictColors = {
      CONNECTED => {
        DARK => Graphics.COLOR_BLUE,
        LIGHT => Graphics.COLOR_DK_BLUE,
      },
      :moon => {
        DARK => Graphics.COLOR_ORANGE,
        LIGHT => Graphics.COLOR_ORANGE,
      },
    };

    if (theme == DARK_COLOR || theme == LIGHT_COLOR) {
      dictColors = {
        CONNECTED => {
          DARK_COLOR => Graphics.COLOR_BLUE,
          LIGHT_COLOR => Graphics.COLOR_DK_BLUE,
        },
        :moon => {
          DARK_COLOR => Graphics.COLOR_ORANGE,
          LIGHT_COLOR => Graphics.COLOR_ORANGE,
        },
        MOON => {
          DARK_COLOR => Graphics.COLOR_ORANGE,
          LIGHT_COLOR => Graphics.COLOR_ORANGE,
        },
        HR => { DARK_COLOR => 0xff55ff, LIGHT_COLOR => 0xff0000 },
        :getHeartRateHistory => {
          DARK_COLOR => 0xff55ff,
          LIGHT_COLOR => 0xff0000,
        },
        STEPS => {
          DARK_COLOR => Graphics.COLOR_ORANGE,
          LIGHT_COLOR => Graphics.COLOR_ORANGE,
        },
        CALORIES => { DARK_COLOR => 0xffffaa, LIGHT_COLOR => 0xaa5500 },
        DISTANCE => { DARK_COLOR => 0xaaffff, LIGHT_COLOR => 0x5500aa },
        FLOOR => { DARK_COLOR => 0xffff55, LIGHT_COLOR => 0xaa5500 },
        ACTIVE_DAY => { DARK_COLOR => 0xaaffaa, LIGHT_COLOR => 0x555500 },
        ACTIVE_WEEK => { DARK_COLOR => 0xaaffaa, LIGHT_COLOR => 0x555500 },
        WEIGHT => { DARK_COLOR => 0xaaffff, LIGHT_COLOR => 0x0000ff },
        O2 => { DARK_COLOR => 0xaaffff, LIGHT_COLOR => 0x0000aa },
        :getOxygenSaturationHistory => {
          DARK_COLOR => 0xaaffff,
          LIGHT_COLOR => 0x0000aa,
        },
        SUN_EVENT => { DARK_COLOR => 0xffaaff, LIGHT_COLOR => 0xaa0000 },
        SUNRISE_EVENT => { DARK_COLOR => 0xffaaff, LIGHT_COLOR => 0xaa0000 },
        SUNSET_EVENT => { DARK_COLOR => 0xffaaff, LIGHT_COLOR => 0xaa0000 },
        :solar => { DARK_COLOR => 0xffaaff, LIGHT_COLOR => 0xaa0000 },
        PRESSURE => { DARK_COLOR => 0xffffaa, LIGHT_COLOR => 0xaa5500 },
        :getPressureHistory => {
          DARK_COLOR => 0xffffaa,
          LIGHT_COLOR => 0xaa5500,
        },
        TEMPERATURE => { DARK_COLOR => 0xffffaa, LIGHT_COLOR => 0xaa5500 },
        :getTemperatureHistory => {
          DARK_COLOR => 0xffffaa,
          LIGHT_COLOR => 0xaa5500,
        },
        ELEVATION => { DARK_COLOR => 0xaaffff, LIGHT_COLOR => 0x0000aa },
        :getElevationHistory => {
          DARK_COLOR => 0xaaffff,
          LIGHT_COLOR => 0x0000aa,
        },
        SOLAR_CHARGE => { DARK_COLOR => 0xffaaff, LIGHT_COLOR => 0x5500aa },
        WEATHER_TEMPERATURE => {
          DARK_COLOR => settings[:autoColors][:temp],
          LIGHT_COLOR => settings[:autoColors][:temp],
        },
        WEATHER_PRESSURE => { DARK_COLOR => 0xffffaa, LIGHT_COLOR => 0xaa5500 },
        WEATHER_WIND_SPEED => {
          DARK_COLOR => settings[:autoColors][:wind],
          LIGHT_COLOR => settings[:autoColors][:wind],
        },
        WEATHER_WIND_DEG => {
          DARK_COLOR => settings[:autoColors][:wind],
          LIGHT_COLOR => settings[:autoColors][:wind],
        },
        WEATHER_HUM => { DARK_COLOR => 0x00ffff, LIGHT_COLOR => 0x0000aa },
      };
    }
    var fType = type;
    if (fType instanceof Toybox.Lang.Number) {
      if (fType >= PICTURE) {
        fType -= PICTURE;
      }
    }

    if (dictColors[fType] != null) {
      var _color = dictColors[fType][theme];
      if (_color != null) {
        color = _color;
      }
    }
    return color;
  }

  function setWeatherAutoColors() {
    var defColor = getColor();

    settings[:autoColors] = {
      :temp => defColor,
      :wind => defColor,
    };
    if (themeIsMonochrome()) {
      return;
    }
    if (weather != null) {
      var backgroundColor = getBackgroundColor();

      var backIsLight = false;
      if (
        backgroundColor == Graphics.COLOR_WHITE ||
        backgroundColor == Graphics.COLOR_LT_GRAY ||
        backgroundColor == Graphics.COLOR_YELLOW
      ) {
        backIsLight = true;
      }

      //temperature
      var tmpValue = weather[STORAGE_KEY_TEMP];
      if (tmpValue != null) {
        if (backIsLight) {
          if (tmpValue > 30) {
            settings[:autoColors][:temp] = 0xaa0000;
          } else if (tmpValue > 25) {
            settings[:autoColors][:temp] = 0xff0055;
          } else if (tmpValue > 20) {
            settings[:autoColors][:temp] = 0xff5500;
          } else if (tmpValue > 15) {
            settings[:autoColors][:temp] = 0x005500;
          } else if (tmpValue > 10) {
            settings[:autoColors][:temp] = 0x555500;
          } else if (tmpValue > 5) {
            settings[:autoColors][:temp] = 0xaa5500;
          } else if (tmpValue > 0) {
            settings[:autoColors][:temp] = 0xff5500;
          } else if (tmpValue > -10) {
            settings[:autoColors][:temp] = 0x0000ff;
          } else if (tmpValue > -20) {
            settings[:autoColors][:temp] = 0x0000aa;
          } else {
            settings[:autoColors][:temp] = 0x000055;
          }
        } else {
          if (tmpValue > 30) {
            settings[:autoColors][:temp] = 0xff0000;
          } else if (tmpValue > 25) {
            settings[:autoColors][:temp] = 0xff0055;
          } else if (tmpValue > 20) {
            settings[:autoColors][:temp] = 0x00ff00;
          } else if (tmpValue > 15) {
            settings[:autoColors][:temp] = 0x00ff55;
          } else if (tmpValue > 10) {
            settings[:autoColors][:temp] = 0x55ff00;
          } else if (tmpValue > 5) {
            settings[:autoColors][:temp] = 0xffff00;
          } else if (tmpValue > 0) {
            settings[:autoColors][:temp] = 0xffffaa;
          } else if (tmpValue > -10) {
            settings[:autoColors][:temp] = 0xaaffff;
          } else if (tmpValue > -20) {
            settings[:autoColors][:temp] = 0x55ffff;
          } else {
            settings[:autoColors][:temp] = 0x00ffff;
          }
        }
      }

      //wind speed
      tmpValue = weather[STORAGE_KEY_WIND_SPEED];
      if (tmpValue != null) {
        tmpValue = Tools.getBeaufort(tmpValue);
        if (backIsLight) {
          if (tmpValue > 9) {
            settings[:autoColors][:wind] = 0xaa0000;
          } else if (tmpValue > 8) {
            settings[:autoColors][:wind] = 0xaa0055;
          } else if (tmpValue > 7) {
            settings[:autoColors][:wind] = 0xaa00aa;
          } else if (tmpValue > 6) {
            settings[:autoColors][:wind] = 0x5500ff;
          } else if (tmpValue > 5) {
            settings[:autoColors][:wind] = 0x5555ff;
          } else if (tmpValue > 4) {
            settings[:autoColors][:wind] = Graphics.COLOR_ORANGE;
          } else if (tmpValue > 3) {
            settings[:autoColors][:wind] = 0x005500;
          } else if (tmpValue > 2) {
            settings[:autoColors][:wind] = 0x00aa00;
          } else {
            settings[:autoColors][:wind] = Graphics.COLOR_DK_GRAY;
          }
        } else {
          if (tmpValue > 9) {
            settings[:autoColors][:wind] = 0xff0000;
          } else if (tmpValue > 8) {
            settings[:autoColors][:wind] = 0xff00aa;
          } else if (tmpValue > 7) {
            settings[:autoColors][:wind] = 0xffaaff;
          } else if (tmpValue > 6) {
            settings[:autoColors][:wind] = 0x00ffff;
          } else if (tmpValue > 5) {
            settings[:autoColors][:wind] = 0xaaffff;
          } else if (tmpValue > 4) {
            settings[:autoColors][:wind] = Graphics.COLOR_YELLOW;
          } else if (tmpValue > 3) {
            settings[:autoColors][:wind] = 0x00ff00;
          } else if (tmpValue > 2) {
            settings[:autoColors][:wind] = 0x55ff55;
          } else {
            settings[:autoColors][:wind] = Graphics.COLOR_WHITE;
          }
        }
      }
    }
  }

  function getSpeedUnitString() {
    if (memoryCache.weather != null) {
      var dict = SettingsReference.windSpeedUnit();
      return Application.loadResource(
        Rez.Strings[dict[Application.Properties.getValue("WU")]]
      );
    } else {
      return "";
    }
  }

  function getFontByFieldType(type) {
    var res = :small;
    if (
      type == CONNECTED ||
      type == NOTIFICATIONS ||
      type == DND ||
      type == ALARMS
    ) {
      res = :picture;
    }
    return res;
  }

  function addEverySecondField(id) {
    if (everySecondFields == null) {
      everySecondFields = [id];
    } else {
      everySecondFields.add(id);
    }
  }

  function onWeatherUpdate(data) {
    Application.Storage.setValue(STORAGE_KEY_WEATHER, data);
    readWeather();
  }

  function eraseWeather() {
    onWeatherUpdate(null);
  }

  function checkWeatherActuality() {
    if (weather != null) {
      if (
        Time.now().value() - weather[STORAGE_KEY_RECIEVE].toNumber() >
        10800
      ) {
        eraseWeather();
      }
    }
  }
}
