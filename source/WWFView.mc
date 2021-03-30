using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Activity;

class WWFView extends WatchUi.WatchFace {

	var fields;
	
    function initialize() {

        WatchFace.initialize();
        memoryCache = new MemoryCache();
        Application.getApp().registerEvents();
        fonts = {};
        fields = {};
        fonts[:time] = Application.loadResource(Rez.Fonts.big);
        fonts[:small] = Application.loadResource(Rez.Fonts.small);
        fonts[:small_letters] = Graphics.FONT_SYSTEM_XTINY;
        fonts[:medium] = Application.loadResource(Rez.Fonts.med);
        fonts[:picture] = Application.loadResource(Rez.Fonts.images);
        fonts[:weather] = Application.loadResource(Rez.Fonts.weather);
    }

    // Load your resources here
    function onLayout(dc) {
    	//createFields(dc);
	}
	
	function createFields(dc){
		
		fields = {};
		var hDataField = 22;
		if (dc.getWidth() == 218){
			hDataField = 18;
		}
		
		///////////////////////////////////////////////////////////////////////
		//TIME
		var font = fonts[:time];
		var w = dc.getTextWidthInPixels("00:02", font);
		var h = Graphics.getFontHeight(font)-1.5*Graphics.getFontDescent(font);
		var x = (System.getDeviceSettings().screenWidth - w)/2-1;
		var y = (System.getDeviceSettings().screenHeight - h)/2+2;
        fields[:time] = new SimpleField(
    		{
    			:x => x,
    			:y => y,
    			:h => h,
    			:w => w,
    			:type => :time,
    			:id => :time,
    			:fontId => :time,
    			:justify => Graphics.TEXT_JUSTIFY_CENTER
    		}
    	);

		///////////////////////////////////////////////////////////////////////
		//DATE
    	font = fonts[:small];
    	h = ((fields[:time].h)/3).toNumber()+2;
    	y = y - h;
//    	memoryCache.setBackgroundY(0, y+1);

        fields[:date] = new SimpleField(
    		{
    			:x => x,
    			:y => y,
    			:h => h,
    			:w => w,
    			:type => :date,
    			:id => :date,
    			:fontId => :small_letters,
    			:justify => Graphics.TEXT_JUSTIFY_CENTER
    		}
    	);
		var currentTop = fields[:date][:y];
		
		///////////////////////////////////////////////////////////////////////
		//STATUS FIELDS
		h = ((fields[:time].h)/3).toNumber();
		
		w = dc.getTextWidthInPixels("00", fonts[:small]);
		
		y = (dc.getHeight() - STATUS_FIELDS_COUNT*h/2)/2;
		x = fields[:time].x - w;

		var coord = new [STATUS_FIELDS_COUNT];
		coord[0] = [x,y,Graphics.TEXT_JUSTIFY_RIGHT];
		coord[1] = [coord[0][0],y + h,Graphics.TEXT_JUSTIFY_RIGHT];
		coord[2] = [coord[0][0],y + 2*h,Graphics.TEXT_JUSTIFY_RIGHT];

		coord[3] = [fields[:time].x + fields[:time].w,y,Graphics.TEXT_JUSTIFY_LEFT];
		coord[4] = [coord[3][0],y + h,Graphics.TEXT_JUSTIFY_LEFT];
		coord[5] = [coord[3][0],y + 2*h,Graphics.TEXT_JUSTIFY_LEFT];

		for (var i = 0; i < STATUS_FIELDS_COUNT; i++){
			
			var id = "SF"+i;
			var type = memoryCache.getFieldType(id); 
	        fields[id] = new SimpleField(
	    		{
	    			:x => coord[i][0],
	    			:y => coord[i][1],
	    			:h => h,
	    			:w => w,
	    			:type =>type,
	    			:id => id,
					:fontId =>  memoryCache.getFontByFieldType(type),
	    			:justify => coord[i][2]
	    		}
	    	);
		}

		///////////////////////////////////////////////////////////////////////
		//WEATHER
		var wWeatherBar = 0;
		h = hDataField*2;
		w = h;
		var showWeather = false;
		var wType = Application.Properties.getValue("WType"); 
		if (wType == 0){
			showWeather = true;
		}
		
		currentTop -= h;
		if (showWeather){
			var fromPictureToTemp = 5;
			if (Application.Properties.getValue("ShowOWMIcons")){
		        fields[:weather_picture] = new BitmapField(
		    		{
		    			:x => 0,
		    			:y => currentTop,
		    			:h => h,
		    			:w => w-fromPictureToTemp,
		    			:type => :weather_picture,
		    			:id => :weather,
		    			:fontId => :weather,
		    			:justify => Graphics.TEXT_JUSTIFY_CENTER
		    		}
		    	);
			}else{
		        fields[:weather_picture] = new SimpleField(
		    		{
		    			:x => 0,
		    			:y => currentTop,
		    			:h => h,
		    			:w => w-fromPictureToTemp,
		    			:type => :weather_picture,
		    			:id => :weather,
		    			:fontId => :weather,
		    			:justify => Graphics.TEXT_JUSTIFY_CENTER
		    		}
		    	);
	    	}
			wWeatherBar += fields[:weather_picture][:w];
			
	        fields[:weather_temp] = new SimpleField(
	    		{
	    			:x => fields[:weather_picture].x + fields[:weather_picture].w,
	    			:y => currentTop,
	    			:h => h,
	    			:w => w+fromPictureToTemp,
	    			:type => :weather_temp,
	    			:id => :weather,
	    			:fontId => :medium,
	    			:justify => Graphics.TEXT_JUSTIFY_CENTER
	    		}
	    	);
			wWeatherBar += fields[:weather_temp][:w];
			
			if (Application.Properties.getValue("WShowWindWidget")){
		        fields[:weather_wind_widget] = new WindDWidget(
		    		{
		    			:x => fields[:weather_temp].x + fields[:weather_temp].w,
		    			:y => currentTop,
		    			:h => fields[:weather_temp].h,
		    			:w => fields[:weather_temp].w,
		    			:type => :weather_wind_widget,
		    			:id => :weather,
		    			:fontId => :small_letters,
		    			:justify => Graphics.TEXT_JUSTIFY_CENTER
		    		}
				);
				wWeatherBar += fields[:weather_wind_widget][:w];
			}
		}else{
		
			var wMulti = 3;
			if (Application.Properties.getValue("ShowTopFields")){wMulti = 2;}
			var graphType = :getHeartRateHistory;
			if (wType == 2){
				graphType = :getOxygenSaturationHistory;
			}else if (wType == 3){
				graphType = :getTemperatureHistory;
			}else if (wType == 4){
				graphType = :getPressureHistory;
			}else if (wType == 5){
				graphType = :getElevationHistory;
			}
			
	        fields[:graphic] = new GraphicsField(
	    		{
	    			:x => 0,
	    			:y => currentTop,
	    			:h => h,
	    			:w => wMulti*w,
	    			:type => graphType,
	    			:id => :weather,
	    			:fontId => :small_letters,
	    			:justify => Graphics.TEXT_JUSTIFY_CENTER
	    		}
	    	);
	    	wWeatherBar += fields[:graphic][:w];
		}
		
		///////////////////////////////////////////////////////////////////////
		//DATA FIELDS
		h = hDataField;
		var wPicture = hDataField;
		var wText = dc.getTextWidthInPixels("00:00", fonts[:small]);
		y = fields[:time].y+fields[:time].h;
		x = (dc.getWidth() - 3*(wPicture+wText))/2;
		
		coord = new [FIELDS_COUNT-2];
		coord[0] = [x,y];
		coord[1] = [x+(wPicture+wText),y];
		coord[2] = [x+2*(wPicture+wText),y];
		coord[3] = [x,y + h];
		coord[4] = [x+(wPicture+wText),y + h];
		coord[5] = [x+2*(wPicture+wText),y + h];
		
		if (Application.Properties.getValue("ShowTopFields")){
			coord.add([wWeatherBar, currentTop]);
			coord.add([wWeatherBar, currentTop + h]);
			wWeatherBar += wPicture+wText;
		}
		
		for (var i = 0; i < coord.size(); i++){

			var idPicture = "P"+i;
	        var id = "F"+i;

	        fields[idPicture] = new ImageField(
	    		{
	    			:x => coord[i][0],
	    			:y => coord[i][1],
	    			:h => h,
	    			:w => wPicture,
	    			:type => memoryCache.getPictureType(id),
	    			:id => id,
					:fontId => :picture,
	    			:justify => Graphics.TEXT_JUSTIFY_CENTER
	    		}
	    	);

	        fields[id] = new SimpleField(
	    		{
	    			:x => coord[i][0] + wPicture,
	    			:y => coord[i][1],
	    			:h => h,
	    			:w => wText,
	    			:type => memoryCache.getFieldType(id),
	    			:id => id,
					:fontId => :small,
	    			:justify => Graphics.TEXT_JUSTIFY_LEFT
	    		}
	    	);
		}
		

		///////////////////////////////////////////////////////////////////////
		//MOVE WEATHER BAR
		var shiftX = (dc.getWidth() - wWeatherBar)/2;
		if (showWeather){
			fields[:weather_picture][:x] += shiftX; 
			fields[:weather_temp][:x] += shiftX;
			if (Application.Properties.getValue("WShowWindWidget")){
				fields[:weather_wind_widget][:x] += shiftX;
			}
		}else{
			fields[:graphic][:x] += shiftX;
			currentTop = fields[:graphic][:y];
		}
		
		if (Application.Properties.getValue("ShowTopFields")){
			fields["P6"][:x] += shiftX;
			fields["F6"][:x] += shiftX;
			fields["P7"][:x] += shiftX;
			fields["F7"][:x] += shiftX;
		} 

		///////////////////////////////////////////////////////////////////////
		//BATTERY
		h = fields["F0"].h;
		w = fields["F0"].w;
        fields[:battery_picture] = new BatteryField(
    		{
    			:x => System.getDeviceSettings().screenWidth/2-w,
    			:y => currentTop - h,
    			:h => h,
    			:w => w,
    			:type => :battery_picture,
    			:id => :battery,
    			:fontId => :small,
    			:justify => Graphics.TEXT_JUSTIFY_LEFT
    		}
    	);

        fields[:battery] = new SimpleField(
    		{
    			:x => System.getDeviceSettings().screenWidth/2,
    			:y => fields[:battery_picture].y,
    			:h => h,
    			:w => w,
    			:type => :battery,
    			:id => :battery,
    			:fontId => :small,
    			:justify => Graphics.TEXT_JUSTIFY_LEFT
    		}
    	);

		///////////////////////////////////////////////////////////////////////
		//Moon phase

    	 fields[:moon] = new SimpleField(
    		{
    			:x => (System.getDeviceSettings().screenWidth - 2*hDataField)/2,
    			:y => fields["F5"].y + fields["F5"].h,
    			:h => 2*hDataField,
    			:w => 2*hDataField,
    			:type => :moon,
    			:id => :moon,
    			:fontId => :weather,
    			:justify => Graphics.TEXT_JUSTIFY_CENTER
    		}
    	);


    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
       	var location = Activity.getActivityInfo().currentLocation;
    	if (location != null) {
			location = location.toDegrees();
			Application.Storage.setValue("Lat", location[0].toFloat());
			Application.Storage.setValue("Lon", location[1].toFloat());
		} else {
			if (Application.Storage.getValue("Lat") == null || Application.Storage.getValue("Lon") == null){
				if ( Toybox has :Weather){
					location = Toybox.Weather.getCurrentConditions();
					if (location != null) {
						location = location.observationLocationPosition;
				    	if (location != null) {
							location = location.toDegrees();
							Application.Storage.setValue("Lat", location[0].toFloat());
							Application.Storage.setValue("Lon", location[1].toFloat());
						}
					}
				}
			}
		}
    	Application.getApp().registerEvents();
    	memoryCache = new MemoryCache();
    }

	function drawBackground(dc){
		dc.setColor(memoryCache.settings[:colors][:backgroundColor], memoryCache.settings[:colors][:backgroundColor]);
		dc.setClip(0, 0, dc.getWidth(), dc.getHeight());
		dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
	}

    // Update the view
    function onUpdate(dc) {
		
		var isCharging = System.getSystemStats().charging;  
		if (memoryCache.oldValues[:isCharging] != null){
			if (memoryCache.oldValues[:isCharging] && !isCharging){
				memoryCache = new MemoryCache();
			}
		}
		memoryCache.oldValues[:isCharging] = isCharging;
				
		//Set day naght presets
		if (memoryCache.settings[:switchDayNight]){
			var sunrise = Tools.getSunEvent(SUNRISE, false);
			var sunset = Tools.getSunEvent(SUNSET, false);
			if (sunrise != null && sunset != null){
				var now = Time.now();
				var isNight = true;
				if(now.greaterThan(sunrise) && now.lessThan(sunset)){
					isNight = false;
				}
				
				if (memoryCache.oldValues[:isNight] != isNight){
					var idSettings = StorageSettings.getPeriodicSettingsId(isNight ? STORAGE_KEY_NIGHT : STORAGE_KEY_DAY);
					if (idSettings != null){
						StorageSettings.load(idSettings);
					}
					memoryCache.oldValues[:isNight] = isNight;
				}
			}
		}else{//dont switch day/night
			if (memoryCache.oldValues[:isStarted] != true ){
				var idSettings = StorageSettings.getPeriodicSettingsId(STORAGE_KEY_GLOBAL);
				if (idSettings != null){
					StorageSettings.load(idSettings);
				}			
			}
		}
		
		if (memoryCache.oldValues[:isStarted] != true){
			drawBackground(dc);
			createFields(dc);
			memoryCache.oldValues[:isStarted] = false;
		}

		memoryCache.checkWeatherActuality();
		var ids = fields.keys();
		for (var i = 0; i < ids.size(); i++){

			var fieldId = ids[i];
			var oldValue = memoryCache.oldValues[fieldId];
			var value = Data.getValueByFieldType(fields[fieldId].type, oldValue);

			//Danger place.
			var needUpdate = false;
			if(value == null){
				needUpdate = (value != oldValue);
			}else if(value instanceof  Dictionary){
				needUpdate = false;
				if (oldValue instanceof  Dictionary){
					var keys = value.keys();
					for (var i = 0; i < keys.size(); i++){
						if(value[keys[i]] has :equals){
							if (!value[keys[i]].equals(oldValue[keys[i]])){
								needUpdate = true;
								break;
							}
						}else{
							if (!value[keys[i]] != oldValue[keys[i]]){
								needUpdate = true;
								break;
							}
						}
					}
				}else{
					needUpdate = true;
				}
			}else if(value has :equals){
				needUpdate = !value.equals(oldValue);
			}else{
				needUpdate = (value != oldValue);
			}

			if (needUpdate){
				fields[fieldId].draw(dc, value);
				memoryCache.oldValues[fieldId] = value;
			}
		}

		memoryCache.oldValues[:isStarted] = true;
		dc.setClip(0, 0, 0, 0);//fix bug Vivoactive 4
    }

	function onPartialUpdate(dc){
		
		if (memoryCache.everySecondFields == null){
			return;
		}
		if (memoryCache.everySecondFields.size()>0){
			for (var i = 0; i < memoryCache.everySecondFields.size(); i++){
				var fieldId = memoryCache.everySecondFields[i];
				var oldValue = memoryCache.oldValues[fieldId];
				var value = Data.getValueByFieldType(fields[fieldId].type, oldValue);
				if (!value.equals(oldValue)){
					fields[fieldId].draw(dc, value);
					memoryCache.oldValues[fieldId] = value;
				}
			}
		}
	}

    function onHide() {
    	memoryCache = new MemoryCache();
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	memoryCache = new MemoryCache();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
}
