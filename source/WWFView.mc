using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;
using Toybox.Activity;
using Toybox.Math;

class WWFView extends WatchUi.WatchFace {

	var fields;
	var itsOnShow; 
	
	///////////////////////////////////////////////////////////////////////////
    function initialize() {

        WatchFace.initialize();
        fields = null;
        itsOnShow = false;
    }

	///////////////////////////////////////////////////////////////////////////
    // Load your resources here
    function onLayout(dc) {
	}
	
	///////////////////////////////////////////////////////////////////////////
	function initFonts(){
        fonts = {};
        fonts[:time] = Application.loadResource(Rez.Fonts.big);
        fonts[:small] = Application.loadResource(Rez.Fonts.small);
        fonts[:small_letters] = Graphics.FONT_SYSTEM_XTINY;
        fonts[:medium] = Application.loadResource(Rez.Fonts.med);
        fonts[:picture] = Application.loadResource(Rez.Fonts.images);
	}
	
	///////////////////////////////////////////////////////////////////////////
	function createWeatherFields(top, h, w, fieldsIds){
	
		var fromPictureToTemp = 5;
		fields[fieldsIds[0]] = new BitmapField(
			{
				:x => 0,
				:y => top,
				:h => h,
				:w => w-fromPictureToTemp,
				:type => :weather_picture,
				:fontId => :weather,
				:justify => Graphics.TEXT_JUSTIFY_CENTER
			}
		);
		
		fields[fieldsIds[1]] = new SimpleField(
			{
				:x => fields[fieldsIds[0]].x + fields[fieldsIds[0]].w,
				:y => top,
				:h => h,
				:w => w+fromPictureToTemp,
				:type => :weather_temp,
				:fontId => :medium,
				:justify => Graphics.TEXT_JUSTIFY_CENTER
			}
		);
		return fields[fieldsIds[0]][:w] + fields[fieldsIds[1]][:w];
		
	}
	
	///////////////////////////////////////////////////////////////////////////
	function createDataField(pId, fId, x, y, h, wPicture, wText){
		
		var res = 0;
		var propName = SettingsReference.getAppPropertyNames(memoryCache.mode)[fId];
		var type = Application.Properties.getValue(propName);
		if (type != EMPTY){
		
			var pictureOptions = {
	    			:x => x,
	    			:y => y,
	    			:h => h,
	    			:w => wPicture,
	    			:type => PICTURE+type,
					:fontId => :picture,
	    			:justify => Graphics.TEXT_JUSTIFY_CENTER};
	    			
	    	if (type == WEATHER_WIND_SPEED || type == WEATHER_WIND_DEG){
	    		fields[pId] = new WindDirectionField(pictureOptions);
	    	}else if (type == MOON){
	    		fields[pId] = new MoonField(pictureOptions);
	    	}else{
	    		fields[pId] = new SimpleField(pictureOptions);
	    	}
	        
	
	        fields[fId] = new SimpleField(
	    		{
	    			:x => x + wPicture,
	    			:y => y,
	    			:h => h,
	    			:w => wText,
	    			:type => type,
					:fontId => :small,
	    			:justify => Graphics.TEXT_JUSTIFY_LEFT
	    		}
	    	);
	    	
	    	res = wPicture+wText;
    	}
		return res;
	}
	
	///////////////////////////////////////////////////////////////////////////
	function shiftFields(idsArray, shiftX){
		for (var i = 0; i < idsArray.size(); i++){
			if (fields[idsArray[i]] != null){
				fields[idsArray[i]][:x] += shiftX;
			}
		}
	}
	
	function getWidthForY(y, dc){
		var r = dc.getWidth()/2;
		var absY = Tools.abs(r-y);
		return 2*Math.sqrt(r*r-absY*absY).toNumber();
	}
	
	///////////////////////////////////////////////////////////////////////////
	function createFields(dc){
		
		var propNames = SettingsReference.getAppPropertyNames(memoryCache.mode);
		var modeString = memoryCache.modeAsString();
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
    			:fontId => :time,
    			:justify => Graphics.TEXT_JUSTIFY_CENTER
    		}
    	);

		///////////////////////////////////////////////////////////////////////
		//DATE
    	font = fonts[:small];
    	h = ((fields[:time].h)/3).toNumber()+2;
    	y = y - h;
		w = getWidthForY(y, dc);
        fields[:date] = new SimpleField(
    		{
    			:x => (dc.getWidth()-w)/2,
    			:y => y,
    			:h => h,
    			:w => w,
    			:type => :date,
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
			var type = Application.Properties.getValue(modeString+id); 
	        fields[id] = new SimpleField(
	    		{
	    			:x => coord[i][0],
	    			:y => coord[i][1],
	    			:h => h,
	    			:w => w,
	    			:type =>type,
					:fontId =>  memoryCache.getFontByFieldType(type),
	    			:justify => coord[i][2]
	    		}
	    	);
		}

		///////////////////////////////////////////////////////////////////////
		//TOP WIDGET
		var topBarWidth = 0;
		h = hDataField*2;
		w = h;
		var wType = Application.Properties.getValue(propNames[:WTypeTop]); 
		currentTop -= h;
		if (wType == EMPTY){
			//do nothing
		}else if (wType == WIDGET_TYPE_WEATHER || wType == WIDGET_TYPE_WEATHER_WIND || wType == WIDGET_TYPE_WEATHER_FIELDS){
			
			topBarWidth += createWeatherFields(currentTop, h, w, [:weather_picture, :weather_temp]);
			
			if (wType == WIDGET_TYPE_WEATHER_WIND){
		        fields[:weather_wind_widget] = new WindDWidget(
		    		{
		    			:x => fields[:weather_temp].x + fields[:weather_temp].w,
		    			:y => currentTop,
		    			:h => fields[:weather_temp].h,
		    			:w => fields[:weather_temp].w,
		    			:type => :weather_wind_widget,
		    			:fontId => :small_letters,
		    			:justify => Graphics.TEXT_JUSTIFY_CENTER
		    		}
				);
				topBarWidth += fields[:weather_wind_widget][:w];
			}
		}else{
			var graphType = :getHeartRateHistory;
			if (wType == WIDGET_TYPE_SATURATION){
				graphType = :getOxygenSaturationHistory;
			}else if (wType == WIDGET_TYPE_TEMPERATURE){
				graphType = :getTemperatureHistory;
			}else if (wType == WIDGET_TYPE_PRESSURE){
				graphType = :getPressureHistory;
			}else if (wType == WIDGET_TYPE_ELEVATION){
				graphType = :getElevationHistory;
			}
			
	        fields[:graphic] = new GraphicsField(
	    		{
	    			:x => 0,
	    			:y => currentTop,
	    			:h => h,
	    			:w => getWidthForY(currentTop+hDataField/2, dc),
	    			:type => graphType,
	    			:fontId => :small,
	    			:justify => Graphics.TEXT_JUSTIFY_CENTER,
	    			:showMinMax => true,
	    			:graphOffset => true
	    		}
	    	);
	    	topBarWidth += fields[:graphic][:w];
		}
	
		///////////////////////////////////////////////////////////////////////
		//DATA FIELDS
		h = hDataField;
		var wPicture = hDataField;
		var wText = dc.getTextWidthInPixels("00:00", fonts[:small]);
		if ( wType == WIDGET_TYPE_WEATHER_FIELDS){
			topBarWidth += Tools.max(
				createDataField(:P0, :F0, topBarWidth, currentTop, h, wPicture, wText), 
				createDataField(:P1, :F1, topBarWidth, currentTop + h, h, wPicture, wText)
			);
		}

		y = fields[:time].y+fields[:time].h;
		x = (dc.getWidth() - 3*(wPicture+wText))/2;
		
		var fieldsBarWidth = 0;
		fieldsBarWidth += createDataField(:P2, :F2, fieldsBarWidth, y, h, wPicture, wText);
		fieldsBarWidth += createDataField(:P3, :F3, fieldsBarWidth, y, h, wPicture, wText);
		fieldsBarWidth += createDataField(:P4, :F4, fieldsBarWidth, y, h, wPicture, wText);
		shiftFields([:P2, :F2, :P3, :F3, :P4, :F4], (dc.getWidth() - fieldsBarWidth)/2);
		
		fieldsBarWidth = 0;
		y += h;
		fieldsBarWidth += createDataField(:P5, :F5, fieldsBarWidth, y, h, wPicture, wText);
		fieldsBarWidth += createDataField(:P6, :F6, fieldsBarWidth, y, h, wPicture, wText);
		fieldsBarWidth += createDataField(:P7, :F7, fieldsBarWidth, y, h, wPicture, wText);
		shiftFields([:P5, :F5, :P6, :F6, :P7, :F7], (dc.getWidth() - fieldsBarWidth)/2);
		y += h;
		
		///////////////////////////////////////////////////////////////////////
		//MOVE WEATHER BAR
		shiftFields(
			[:weather_picture, :weather_temp, :weather_wind_widget, :graphic, :P0, :F0, :P1, :F1], 
			(dc.getWidth() - topBarWidth)/2);
		
		///////////////////////////////////////////////////////////////////////
		//BATTERY
        fields[:battery_picture] = new BatteryField(
    		{
    			:x => System.getDeviceSettings().screenWidth/2-wText,
    			:y => currentTop - h,
    			:h => h,
    			:w => wText,
    			:type => :battery_picture,
    			:fontId => :small,
    			:justify => Graphics.TEXT_JUSTIFY_LEFT
    		}
    	);

        fields[:battery] = new SimpleField(
    		{
    			:x => System.getDeviceSettings().screenWidth/2,
    			:y => fields[:battery_picture].y,
    			:h => h,
    			:w => wText,
    			:type => :battery,
    			:fontId => :small,
    			:justify => Graphics.TEXT_JUSTIFY_LEFT
    		}
    	);

		///////////////////////////////////////////////////////////////////////
		//Bottom widget
		wType = Application.Properties.getValue(propNames[:WTypeBottom]);
		if (wType == EMPTY){
			//do nothing
		}else if (wType == WIDGET_TYPE_MOON){
	    	fields[:moon] = new MoonField(
				{
					:x => (System.getDeviceSettings().screenWidth - 2*hDataField)/2,
					:y => y,
					:h => 2*hDataField,
					:w => 2*hDataField,
					:type => :moon,
					:fontId => :small,
					:justify => Graphics.TEXT_JUSTIFY_CENTER
				}
	    	);
    	}else if (wType == WIDGET_TYPE_WEATHER){
    		var bottomBarWidth = createWeatherFields(
    			y, 
    			2*hDataField, 
    			2*hDataField, 
    			[:weather_picture_bottom, :weather_temp_bottom]);
			shiftFields([:weather_picture_bottom, :weather_temp_bottom], (dc.getWidth() - bottomBarWidth)/2);    			
    	}else if (wType == WIDGET_TYPE_SOLAR){
    	
	    	fields[:solar_bottom] = new SolarField(
				{
					:x => (System.getDeviceSettings().screenWidth - 6*hDataField)/2,
					:y => y,
					:h => 2*hDataField,
					:w => 6*hDataField,
					:type => :solar,
					:fontId => :small,
					:justify => Graphics.TEXT_JUSTIFY_CENTER
				}
	    	);
		}else{
		
			var graphType = :getHeartRateHistory;
			if (wType == WIDGET_TYPE_SATURATION){
				graphType = :getOxygenSaturationHistory;
			}else if (wType == WIDGET_TYPE_TEMPERATURE){
				graphType = :getTemperatureHistory;
			}else if (wType == WIDGET_TYPE_PRESSURE){
				graphType = :getPressureHistory;
			}else if (wType == WIDGET_TYPE_ELEVATION){
				graphType = :getElevationHistory;
			}
			
			w = 5*hDataField;
			h = 1.8*hDataField;
	        fields[:graphic_bottom] = new GraphicsField(
	    		{
					:x => (System.getDeviceSettings().screenWidth - w)/2,
					:y => y,
					:h => h,
					:w => w,
	    			:type => graphType,
	    			:fontId => :small,
	    			:justify => Graphics.TEXT_JUSTIFY_CENTER,
	    			:showMinMax => false,
	    			:graphOffset => false
	    		}
	    	);
    	}
		
		///////////////////////////////////////////////////////////////////////
		//Add every seconds fields
		memoryCache.everySecondFields = null;
		var keys = fields.keys();
		for (var i = 0; i < keys.size(); i++){
			var type = fields[keys[i]].type;
			if (type == SECONDS || type == HR){
				memoryCache.addEverySecondField(fields[keys[i]]);
			}
		}

    }

	///////////////////////////////////////////////////////////////////////////
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    
    	if (fonts == null){
    		initFonts();
    	}
       	var location = Activity.getActivityInfo().currentLocation;
    	if (location != null) {
			location = location.toDegrees();
			Application.Storage.setValue("Lat", location[0].toFloat());
			Application.Storage.setValue("Lon", location[1].toFloat());
			if (memoryCache != null){
				memoryCache.sunEvents = {};
			}
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
							if (memoryCache != null){
								memoryCache.sunEvents = {};
							}
						}
					}
				}
			}
		}
    	itsOnShow = true;
    	if (memoryCache == null){
    		memoryCache = new MemoryCache();
    	}
    	Application.getApp().registerEvents();
    }

	///////////////////////////////////////////////////////////////////////////
	function drawBackground(dc){
		var color = memoryCache.getBackgroundColor();
		dc.setColor(color, color);
		dc.setClip(0, 0, dc.getWidth(), dc.getHeight());
		dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
	}

	///////////////////////////////////////////////////////////////////////////
    // Update the view
    function onUpdate(dc) {
		
		var reCreateFields = false;
		
		if (itsOnShow){
			reCreateFields = true;
			itsOnShow = false;
		}
		
		var isCharging = System.getSystemStats().charging;  
		if (memoryCache.flags[:isCharging] != null){
			if (memoryCache.flags[:isCharging] && !isCharging){
				reCreateFields = true;
			}
		}
		memoryCache.flags[:isCharging] = isCharging;
		
		//Set day naght presets
		if (memoryCache.settings[:switchDayNight]){
			
			var newMode = :N;
			var itsDNDNight = false;
			if (memoryCache.settings[:DNDisNight]){
				if (System.getDeviceSettings().doNotDisturb){
					itsDNDNight = true;
				}
			}

			if (!itsDNDNight){						
				var sunrise = Tools.getSunEvent(SUNRISE, false);
				var sunset = Tools.getSunEvent(SUNSET, false);
				if (sunrise != null && sunset != null){
					var now = Time.now();
					if(now.greaterThan(sunrise) && now.lessThan(sunset)){
						newMode = :D;
					}
				}
			}
			if (memoryCache.mode != newMode){
				reCreateFields = true;
				memoryCache.mode = newMode;
			}
			
		}else{//dont switch day/night
			if (memoryCache.mode != :G){
				memoryCache.mode = :G;
				reCreateFields = true;
			}
		}

		
		if (reCreateFields){
			memoryCache.readSettings();
			memoryCache.setWeatherAutoColors();
			drawBackground(dc);
			createFields(dc);
		}else if(fields == null){
			drawBackground(dc);
			createFields(dc);
		}
		
		memoryCache.checkWeatherActuality();

		var ids = fields.keys();
		for (var idsIndex = 0; idsIndex < ids.size(); idsIndex++){

			var fieldId = ids[idsIndex];
			var value = Data.getFieldValue(fields[fieldId]);


			if (fields[fieldId].needUpdate(value)){
				fields[fieldId].draw(dc, value);
			}
		}

		dc.setClip(0, 0, 0, 0);//fix bug Vivoactive 4
    }

	///////////////////////////////////////////////////////////////////////////
	function onPartialUpdate(dc){
		
		if (memoryCache.everySecondFields == null){
			return;
		}
		if (memoryCache.everySecondFields.size()>0){
			for (var i = 0; i < memoryCache.everySecondFields.size(); i++){
				if (memoryCache.everySecondFields[i] instanceof SimpleField){
					var value = Data.getFieldValue(memoryCache.everySecondFields[i]);
					memoryCache.everySecondFields[i].draw(dc, value);
				}
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////
    function onHide() {
    	memoryCache = new MemoryCache();
    }

	///////////////////////////////////////////////////////////////////////////
    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	memoryCache = new MemoryCache();
    }

 	///////////////////////////////////////////////////////////////////////////
    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
}
