var memoryCache;
var fonts;

enum{
	HR,
	STEPS,
	CALORIES,
	DISTANCE,
	FLOOR,
	ACTIVE_DAY,
	ACTIVE_WEEK,
	WEIGHT,
	O2,
	SUN_EVENT,
	SUNRISE_EVENT,
	SUNSET_EVENT,
	TIME1,
	PRESSURE,
	TEMPERATURE,
	ELEVATION,
	SOLAR_CHARGE,
	ALARMS_COUNT,
	WEATHER_TEMPERATURE,
	WEATHER_PRESSURE,
	WEATHER_WIND_SPEED,
	WEATHER_WIND_DEG,
	WEATHER_HUM,
	WEATHER_VISIBILITY,
	WEATHER_UVI,
	WEATHER_DEW_POINT,
	CONNECTED,
	NOTIFICATIONS,
	DND,
	ALARMS,
	AMPM,
	SECONDS,
	NOTIFICATIONS_COUNT,
	EMPTY,
	MOON,

	STORAGE_KEY_RESPONCE_CODE = 100,
	STORAGE_KEY_RECIEVE,
	STORAGE_KEY_TEMP,
	STORAGE_KEY_HUMIDITY,
	STORAGE_KEY_PRESSURE,
	STORAGE_KEY_ICON,
	STORAGE_KEY_WIND_SPEED,
	STORAGE_KEY_WIND_DEG,
	STORAGE_KEY_DT,
	STORAGE_KEY_WEATHER,
	STORAGE_KEY_SETTINGS,
	STORAGE_KEY_UVI,
	STORAGE_KEY_DEW_POINT,
	STORAGE_KEY_VISIBILITY,
	STORAGE_KEY_WEATHER_DESCRIPTION,

	PICTURE = 1000,
	NA = "n/a",
	
	DARK = 0,
	DARK_COLOR,
	DARK_MONOCHROME,
	DARK_RED_COLOR,
	DARK_GREEN_COLOR,
	DARK_BLUE_COLOR,
	LIGHT,
	LIGHT_COLOR,
	LIGHT_MONOCHROME,
	LIGHT_RED_COLOR,
	LIGHT_GREEN_COLOR,
	LIGHT_BLUE_COLOR,

	UNIT_PRESSURE_MM_HG = 0,
	UNIT_PRESSURE_PSI,
	UNIT_PRESSURE_INCH_HG,
	UNIT_PRESSURE_BAR,
	UNIT_PRESSURE_KPA,

	UNIT_SPEED_MS = 0,
	UNIT_SPEED_KMH,
	UNIT_SPEED_MLH,
	UNIT_SPEED_FTS,
	UNIT_SPEED_BOF,
	UNIT_SPEED_KNOTS,
	
	WIDGET_TYPE_WEATHER  = 0,
	WIDGET_TYPE_WEATHER_WIND,
	WIDGET_TYPE_WEATHER_FIELDS,
	WIDGET_TYPE_HR,
	WIDGET_TYPE_SATURATION,
	WIDGET_TYPE_TEMPERATURE,
	WIDGET_TYPE_PRESSURE,
	WIDGET_TYPE_ELEVATION,
	WIDGET_TYPE_MOON,
	WIDGET_TYPE_SOLAR,
	
	FIELDS_COUNT = 8,
	STATUS_FIELDS_COUNT = 6,	
}

