using Toybox.System;
using Toybox.Application;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.SensorHistory;
using Toybox.Math;
using Toybox.UserProfile;

module Data {
  function getFieldValue(field) {
    var res = "";
    if (field.type == EMPTY) {
      res = "";

      ///////////////////////////////////////////////////////////////////////
      //TIME
    } else if (field.type == :time) {
      var clockTime = System.getClockTime();
      res = getTimeString(clockTime);

      ///////////////////////////////////////////////////////////////////////
      //SECONDS
    } else if (field.type == SECONDS) {
      res = getSeconds();

      ///////////////////////////////////////////////////////////////////////
      //AM PM
    } else if (field.type == AMPM) {
      res = getAmPm();

      ///////////////////////////////////////////////////////////////////////
      //DATE
    } else if (field.type == :date) {
      var now = Time.now();
      res = getDateString(now);

      ///////////////////////////////////////////////////////////////////////
      //STATUS FIELDS
    } else if (field.type == CONNECTED) {
      res = System.getDeviceSettings().connectionAvailable ? "c" : "";
    } else if (field.type == NOTIFICATIONS) {
      res = System.getDeviceSettings().notificationCount > 0 ? "i" : "";
    } else if (field.type == NOTIFICATIONS_COUNT) {
      res = System.getDeviceSettings().notificationCount;
      res = res > 0 ? res : "";
    } else if (field.type == DND) {
      res = System.getDeviceSettings().doNotDisturb ? "k" : "";
    } else if (field.type == ALARMS) {
      res = System.getDeviceSettings().alarmCount > 0 ? "a" : "";
    } else if (field.type == ALARMS_COUNT) {
      res = System.getDeviceSettings().alarmCount;
      res = res > 0 ? res : "";

      ///////////////////////////////////////////////////////////////////////
      //DATA FIELDS
    } else if (field.type == HR) {
      res = getHeartRate();
    } else if (field.type == STEPS) {
      res = getSteps();
    } else if (field.type == PRESSURE) {
      res = getPressure();
    } else if (field.type == TEMPERATURE) {
      res = getTemperature();
    } else if (field.type == CALORIES) {
      res = getCalories();
    } else if (field.type == DISTANCE) {
      res = getDistance();
    } else if (field.type == FLOOR) {
      res = getFloor();
    } else if (field.type == ELEVATION) {
      res = getElevation();
    } else if (field.type == SUN_EVENT) {
      res = getNextSunEvent();
    } else if (field.type == SUNRISE_EVENT) {
      res = getSunrise();
    } else if (field.type == SUNSET_EVENT) {
      res = getSunset();
    } else if (field.type == TIME1) {
      res = getSecondTime();
    } else if (field.type == ACTIVE_DAY) {
      res = getActive(:activeMinutesDay);
    } else if (field.type == ACTIVE_WEEK) {
      res = getActive(:activeMinutesWeek);
    } else if (field.type == O2) {
      res = getOxygenSaturation();
    } else if (field.type == SOLAR_CHARGE) {
      res = getSolarCharge();
    } else if (field.type == WEIGHT) {
      res = getWeight();
    } else if (field.type == MOON) {
      res = getMoon()[:AG1];
    } else if (field.type == WEATHER_PRESSURE) {
      res = getWeatherPressureString();
    } else if (field.type == WEATHER_TEMPERATURE) {
      res = getWeatherTemperature();
    } else if (field.type == WEATHER_HUM) {
      res = getWeatherHumidityString();
    } else if (field.type == WEATHER_WIND_SPEED) {
      res = getWeatherWindSpeed();
    } else if (field.type == WEATHER_WIND_DEG) {
      res = getWeatherWindDirectionString();

      ///////////////////////////////////////////////////////////////////////
      //DATA FIELDS IMAGES
    } else if (field.type == PICTURE + HR) {
      res = "g";
    } else if (field.type == PICTURE + STEPS) {
      res = "l";
    } else if (field.type == PICTURE + PRESSURE) {
      res = "b";
    } else if (field.type == PICTURE + TEMPERATURE) {
      res = "p";
    } else if (field.type == PICTURE + WEATHER_TEMPERATURE) {
      res = "p";
    } else if (field.type == PICTURE + CALORIES) {
      res = "d";
    } else if (field.type == PICTURE + DISTANCE) {
      res = "e";
    } else if (field.type == PICTURE + FLOOR) {
      res = "f";
    } else if (field.type == PICTURE + ELEVATION) {
      res = "j";
    } else if (field.type == PICTURE + SUN_EVENT) {
      res = "m";
    } else if (field.type == PICTURE + SUNRISE_EVENT) {
      res = "n";
    } else if (field.type == PICTURE + SUNSET_EVENT) {
      res = "o";
    } else if (field.type == PICTURE + TIME1) {
      res = "q";
    } else if (field.type == PICTURE + EMPTY) {
      res = "";
    } else if (field.type == PICTURE + ACTIVE_DAY) {
      res = "r";
    } else if (field.type == PICTURE + ACTIVE_WEEK) {
      res = "r";
    } else if (field.type == PICTURE + O2) {
      res = "z";
    } else if (field.type == PICTURE + SOLAR_CHARGE) {
      res = "v";
    } else if (field.type == PICTURE + WEIGHT) {
      res = "w";
    } else if (field.type == PICTURE + WEATHER_PRESSURE) {
      res = "b";
    } else if (field.type == PICTURE + WEATHER_HUM) {
      res = "h";
    } else if (field.type == PICTURE + WEATHER_WIND_SPEED) {
      //res = "t";
      res = getWeatherWindDirection();
    } else if (field.type == PICTURE + WEATHER_WIND_DEG) {
      //res = "t";
      res = getWeatherWindDirection();
    } else if (field.type == PICTURE + MOON) {
      res = getMoon()[:IP1];

      ///////////////////////////////////////////////////////////////////////
      //WEATHER
    } else if (field.type == :weather_picture) {
      res = getWeatherPicture();
    } else if (field.type == :weather_temp) {
      res = getWeatherTemperature();
    } else if (field.type == :weather_wind_dir) {
      res = getWeatherWindDirection();
    } else if (field.type == :weather_wind_speed) {
      res = getWeatherWindSpeed();
    } else if (field.type == :weather_wind_speed_unit) {
      res = memoryCache.getSpeedUnitString();
    } else if (field.type == :weather_wind_widget) {
      res = {
        :weather_wind_dir => getWeatherWindDirection(),
        :weather_wind_speed => getWeatherWindSpeed(),
        :weather_wind_speed_unit => memoryCache.getSpeedUnitString(),
      };
      ///////////////////////////////////////////////////////////////////////
      //BATTERY
    } else if (field.type == :battery) {
      res = System.getSystemStats().battery.format("%d") + "%";
    } else if (field.type == :battery_picture) {
      res = Math.round(System.getSystemStats().battery);

      ///////////////////////////////////////////////////////////////////////
      //MOON
    } else if (field.type == :moon) {
      res = getMoon()[:IP1];

      ///////////////////////////////////////////////////////////////////////
      //Solar
    } else if (field.type == :solar) {
      res = getSunrise();

      ///////////////////////////////////////////////////////////////////////
      //GRAPHICS
    } else if (
      field.type == :getHeartRateHistory ||
      field.type == :getOxygenSaturationHistory ||
      field.type == :getTemperatureHistory ||
      field.type == :getPressureHistory ||
      field.type == :getElevationHistory
    ) {
      res = getLastHistoryMoment(field.type);
    }

    return res;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getMoon() {
    var now = Time.now();
    var needUpdate = false;
    if (memoryCache.moonPhase[:day] == null) {
      needUpdate = true;
    } else if (
      memoryCache.moonPhase[:day]
        .add(new Time.Duration(Time.Gregorian.SECONDS_PER_HOUR))
        .lessThan(now)
    ) {
      needUpdate = true;
    }
    if (needUpdate) {
      memoryCache.moonPhase = Tools.moonPhase(now);
      memoryCache.moonPhase[:day] = now;
    }
    return memoryCache.moonPhase;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getLastHistoryMoment(method) {
    var value = NA;
    if (Toybox has :SensorHistory) {
      if (Toybox.SensorHistory has method) {
        var iter = (new Lang.Method(Toybox.SensorHistory, method)).invoke({
          :period => 1,
          :order => SensorHistory.ORDER_NEWEST_FIRST,
        });
        if (iter != null) {
          var sample = iter.next();
          if (sample != null) {
            if (sample.data != null) {
              value = sample.when;
            }
          }
        }
      }
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getTimeString(clockTime) {
    // Get the current time and format it correctly
    var hours = clockTime.hour;
    var formatHours = "%d";
    if (!System.getDeviceSettings().is24Hour) {
      if (hours > 12) {
        hours = hours - 12;
      }
    }
    var timeFormat = "$1$:$2$";
    var military = Application.Properties.getValue("MilFt");
    var hFormat01 = Application.Properties.getValue("HFt01");

    if (military) {
      timeFormat = "$1$$2$";
    }
    if (hFormat01) {
      formatHours = "%02d";
    }
    return Lang.format(timeFormat, [
      hours.format(formatHours),
      clockTime.min.format("%02d"),
    ]);
  }

  ///////////////////////////////////////////////////////////////////////////
  function getDateString(now) {
    var today = Gregorian.info(now, Time.FORMAT_MEDIUM);
    var todayShort = Gregorian.info(now, Time.FORMAT_SHORT);
    var firstDayOfYear = Gregorian.moment({
      :year => today.year,
      :month => 1,
      :day => 1,
    });
    var dur = firstDayOfYear.subtract(now);
    var dayOfYear = 1 + dur.value() / Gregorian.SECONDS_PER_DAY;
    var firstDayOfWeekSettings = System.getDeviceSettings().firstDayOfWeek;
    var dayOfWeek = todayShort.day_of_week;
    if (firstDayOfWeekSettings == 2) {
      dayOfWeek = dayOfWeek == 1 ? 7 : dayOfWeek - 1;
    } else if (firstDayOfWeekSettings == 7) {
      dayOfWeek = dayOfWeek == 7 ? 1 : dayOfWeek + 1;
    }

    var weatherDecription = "";

    if (memoryCache instanceof MemoryCache) {
      if (memoryCache.weather instanceof Toybox.Lang.Dictionary) {
        weatherDecription =
          memoryCache.weather[STORAGE_KEY_WEATHER_DESCRIPTION];
        if (weatherDecription == null) {
          weatherDecription = "";
        }
      }
    }

    var propNames = SettingsReference.getAppPropertyNames(memoryCache.mode);
    var dateString = Application.Properties.getValue(propNames[:DF]);
    dateString = Tools.stringReplace(dateString, "%WN", Tools.weekOfYear(now));
    dateString = Tools.stringReplace(dateString, "%DN", dayOfYear);
    dateString = Tools.stringReplace(dateString, "%WD", weatherDecription);
    dateString = Tools.stringReplace(dateString, "%w", dayOfWeek);
    dateString = Tools.stringReplace(dateString, "%W", today.day_of_week);
    dateString = Tools.stringReplace(dateString, "%d", today.day);
    dateString = Tools.stringReplace(
      dateString,
      "%D",
      today.day.format("%02d")
    );
    dateString = Tools.stringReplace(
      dateString,
      "%m",
      todayShort.month.format("%02d")
    );
    dateString = Tools.stringReplace(dateString, "%M", today.month);
    dateString = Tools.stringReplace(
      dateString,
      "%y",
      today.year.toString().substring(2, 4)
    );
    dateString = Tools.stringReplace(dateString, "%Y", today.year);

    return dateString;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getHeartRate() {
    var value = null;
    var info = Activity.getActivityInfo();
    if (info != null) {
      if (info has :currentHeartRate) {
        value = info.currentHeartRate;
      }
    }
    if (value == null) {
      var iter = ActivityMonitor.getHeartRateHistory(1, true);
      var sample = iter.next();
      if (sample != null) {
        value = sample.heartRate;
      }
    }
    if (value == null) {
      if (Toybox has :SensorHistory) {
        if (Toybox.SensorHistory has :getHeartRateHistory) {
          var iter = SensorHistory.getHeartRateHistory({
            :period => 1,
            :order => SensorHistory.ORDER_NEWEST_FIRST,
          });
          if (iter != null) {
            var sample = iter.next();
            if (sample != null) {
              if (sample.data != null) {
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
  function getSteps() {
    var value = "";
    var info = ActivityMonitor.getInfo();
    if (info has :steps) {
      value = info.steps;
      if (value > 99999) {
        value = (value / 1000).format("%d") + "k";
      } else if (value > 9999) {
        value = (value.toFloat() / 1000).format("%.1f") + "k";
      }
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getPressure() {
    var value = null;
    var info = Activity.getActivityInfo();
    if (info != null) {
      if (info has :meanSeaLevelPressure) {
        if (info.meanSeaLevelPressure != null) {
          value = Tools.pressureToString(info.meanSeaLevelPressure);
        }
      }
    }
    if (value == null) {
      if (Toybox has :SensorHistory) {
        if (Toybox.SensorHistory has :getPressureHistory) {
          var iter = SensorHistory.getPressureHistory({
            :period => 1,
            :order => SensorHistory.ORDER_NEWEST_FIRST,
          });
          if (iter != null) {
            var sample = iter.next();
            if (sample != null) {
              if (sample.data != null) {
                value = Tools.pressureToString(sample.data);
              }
            }
          }
        }
      }
    }
    if (value == null) {
      value = "";
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getTemperature() {
    var value = "";
    if (Toybox has :SensorHistory) {
      if (Toybox.SensorHistory has :getTemperatureHistory) {
        var iter = SensorHistory.getTemperatureHistory({
          :period => 1,
          :order => SensorHistory.ORDER_NEWEST_FIRST,
        });
        if (iter != null) {
          var sample = iter.next();
          if (sample != null) {
            if (sample.data != null) {
              value = Tools.temperatureToString(sample.data);
            }
          }
        }
      }
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getCalories() {
    var value = "";
    var info = ActivityMonitor.getInfo();
    if (info has :calories) {
      value = info.calories;
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getDistance() {
    var value = "";
    var info = ActivityMonitor.getInfo();
    if (info has :distance) {
      value = Tools.distanceToString(info.distance);
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getFloor() {
    var value = "";
    var info = ActivityMonitor.getInfo();
    if (info has :floorsClimbed) {
      value =
        info.floorsClimbed.toString() + "/" + info.floorsDescended.toString();
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getElevation() {
    var value = null;

    var info = Activity.getActivityInfo();
    if (info != null) {
      if (info has :altitude) {
        if (info.altitude != null) {
          value = Tools.elevationToString(info.altitude);
        }
      }
    }
    if (value == null) {
      if (Toybox has :SensorHistory) {
        if (Toybox.SensorHistory has :getElevationHistory) {
          var iter = SensorHistory.getElevationHistory({
            :period => 1,
            :order => SensorHistory.ORDER_NEWEST_FIRST,
          });
          if (iter != null) {
            var sample = iter.next();
            if (sample != null) {
              if (sample.data != null) {
                value = Tools.elevationToString(sample.data);
              }
            }
          }
        }
      }
    }
    if (value == null) {
      value = 0;
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getSunrise() {
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
  function getSunset() {
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
  function getNextSunEvent() {
    var value = "";
    var sunset = Tools.getSunEvent(SUNSET, false);
    var now = Time.now().value();
    if (sunset == null) {
      value = noLocationString();
    } else {
      if (sunset.value() < now) {
        value = Tools.momentToString(Tools.getSunEvent(SUNRISE, true));
      } else {
        var sunrise = Tools.getSunEvent(SUNRISE, false);
        if (now < sunrise.value()) {
          value = Tools.momentToString(sunrise);
        } else {
          value = Tools.momentToString(sunset);
        }
      }
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function noLocationString() {
    return "gps";
  }

  ///////////////////////////////////////////////////////////////////////////
  function getSecondTime() {
    var offset =
      Application.Properties.getValue("T1TZ") * 60 -
      System.getClockTime().timeZoneOffset;
    var dur = new Time.Duration(offset);
    var secondTime = Time.now().add(dur);
    return Tools.momentToString(secondTime);
  }

  ///////////////////////////////////////////////////////////////////////////
  function getAmPm() {
    var value = "";
    if (System.getClockTime().hour < 12) {
      value = "A";
    } else {
      value = "P";
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getSeconds() {
    var value = "";
    value = System.getClockTime().sec.format("%02d");
    return value;
  }

  //	///////////////////////////////////////////////////////////////////////////
  function getWeatherPicture() {
    var value = "";
    if (memoryCache.weather != null) {
      value = memoryCache.weather[STORAGE_KEY_ICON];
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getWeatherTemperature() {
    var value = "";
    if (memoryCache.weather != null) {
      value = memoryCache.weather[STORAGE_KEY_TEMP];
      if (value == null) {
        value = "";
      } else {
        value = Tools.temperatureToString(value) + "°";
      }
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getWeatherWindDirection() {
    var value = -1;
    if (memoryCache.weather != null) {
      value = memoryCache.weather[STORAGE_KEY_WIND_DEG];
      if (value == null) {
        value = -1;
      }
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getWeatherWindSpeed() {
    var value = "";
    if (memoryCache.weather != null) {
      value = memoryCache.weather[STORAGE_KEY_WIND_SPEED];
      if (value == null) {
        value = "";
      } else {
        value = Tools.speedToString(value);
      }
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getWeatherHumidityString() {
    var value = "";
    if (memoryCache.weather != null) {
      value = memoryCache.weather[STORAGE_KEY_HUMIDITY];
      if (value == null) {
        value = "";
      } else {
        value = value.format("%d") + "%";
      }
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getWeatherWindDirectionString() {
    var value = getWeatherWindDirection();
    if (value == -1) {
      value = "";
    } else {
      value = value.format("%d") + "°";
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getWeatherPressureString() {
    var value = "";
    if (memoryCache.weather != null) {
      value = memoryCache.weather[STORAGE_KEY_PRESSURE];
      if (value == null) {
        value = "";
      } else {
        value = Tools.pressureToString(value.toNumber() * 100);
      }
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getGentlyWeaterPictureString(str) {
    var value = "";
    if (memoryCache.weather != null) {
      value = str;
    }
    return value;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getWeight() {
    var g = UserProfile.getProfile().weight;
    return Tools.weightToString(g);
  }

  ///////////////////////////////////////////////////////////////////////////
  function getActive(type) {
    var res = 0;
    var min = ActivityMonitor.getInfo()[type];
    if (min != null) {
      res = min.total;
    }
    return res; //Tools.minutesToString(res);
  }

  ///////////////////////////////////////////////////////////////////////////
  function getSolarCharge() {
    var res = NA;
    if (System.Stats has :solarIntensity) {
      var stats = System.getSystemStats().solarIntensity;
      if (stats != null) {
        res = stats.format("%d") + "%";
      }
    }
    return res;
  }

  ///////////////////////////////////////////////////////////////////////////
  function getOxygenSaturation() {
    var value = null;
    var info = Activity.getActivityInfo();
    if (info != null) {
      if (info has :currentOxygenSaturation) {
        if (info.currentOxygenSaturation != null) {
          value = info.currentOxygenSaturation.format("%d") + "%";
        }
      }
    }

    if (value == null) {
      if (Toybox has :SensorHistory) {
        if (Toybox.SensorHistory has :getOxygenSaturationHistory) {
          var iter = SensorHistory.getOxygenSaturationHistory({
            :period => 1,
            :order => SensorHistory.ORDER_NEWEST_FIRST,
          });
          if (iter != null) {
            var sample = iter.next();
            if (sample != null) {
              if (sample.data != null) {
                value = sample.data.format("%d") + "%";
              }
            }
          }
        }
      }
    }

    if (value == null) {
      value = NA;
    }
    return value;
  }
}
