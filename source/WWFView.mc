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
        fields = null;
    }

    // Load your resources here
    function onLayout(dc) {
	}
	
	function initFonts(){
        fonts = {};
        fonts[:time] = Application.loadResource(Rez.Fonts.big);
        fonts[:small] = Application.loadResource(Rez.Fonts.small);
        fonts[:small_letters] = Graphics.FONT_SYSTEM_XTINY;
        fonts[:medium] = Application.loadResource(Rez.Fonts.med);
        fonts[:picture] = Application.loadResource(Rez.Fonts.images);
	}
	
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

        fields[:date] = new SimpleField(
    		{
    			:x => 0,
    			:y => y,
    			:h => h,
    			:w => dc.getWidth(),
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
		
		if (wType == WIDGET_TYPE_WEATHER || wType == WIDGET_TYPE_WEATHER_WIND || wType == WIDGET_TYPE_WEATHER_FIELDS){
			
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
	    			:w => 4*w,
	    			:type => graphType,
	    			:fontId => :small,
	    			:justify => Graphics.TEXT_JUSTIFY_CENTER
	    		}
	    	);
	    	topBarWidth += fields[:graphic][:w];
		}
	
		///////////////////////////////////////////////////////////////////////
		//DATA FIELDS
		h = hDataField;
		var wPicture = hDataField;
		var wText = dc.getTextWidthInPixels("00:00", fonts[:small]);
		y = fields[:time].y+fields[:time].h;
		x = (dc.getWidth() - 3*(wPicture+wText))/2;
		
		coord = new [FIELDS_COUNT];
		if (wType == WIDGET_TYPE_WEATHER_FIELDS){
			coord[0] = [topBarWidth, currentTop];
			coord[1] = [topBarWidth, currentTop + h];
			topBarWidth += wPicture+wText;
		}
		coord[2] = [x,y];
		coord[3] = [x+(wPicture+wText),y];
		coord[4] = [x+2*(wPicture+wText),y];
		coord[5] = [x,y + h];
		coord[6] = [x+(wPicture+wText),y + h];
		coord[7] = [x+2*(wPicture+wText),y + h];
		
		
		for (var i = 0; i < coord.size(); i++){
			if (coord[i] == null){
				continue;
			}
			var idPicture = "P"+i;
	        var id = "F"+i;
	        
	        fields[idPicture] = new ImageField(
	    		{
	    			:x => coord[i][0],
	    			:y => coord[i][1],
	    			:h => h,
	    			:w => wPicture,
	    			:type => memoryCache.getPictureType(id),
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
	    			:type => Application.Properties.getValue(modeString+id),
					:fontId => :small,
	    			:justify => Graphics.TEXT_JUSTIFY_LEFT
	    		}
	    	);
		}
		

		///////////////////////////////////////////////////////////////////////
		//MOVE WEATHER BAR
		var shiftX = (dc.getWidth() - topBarWidth)/2;
		if (wType == WIDGET_TYPE_WEATHER || wType == WIDGET_TYPE_WEATHER_WIND || wType == WIDGET_TYPE_WEATHER_FIELDS){
			fields[:weather_picture][:x] += shiftX; 
			fields[:weather_temp][:x] += shiftX;
			if (wType == WIDGET_TYPE_WEATHER_WIND){
				fields[:weather_wind_widget][:x] += shiftX;
			}
		}else{
			fields[:graphic][:x] += shiftX;
			currentTop = fields[:graphic][:y];
		}
		
		if (wType == WIDGET_TYPE_WEATHER_FIELDS){
			fields["P0"][:x] += shiftX;
			fields["F0"][:x] += shiftX;
			fields["P1"][:x] += shiftX;
			fields["F1"][:x] += shiftX;
		} 

		///////////////////////////////////////////////////////////////////////
		//BATTERY
		h = fields["F2"].h;
		w = fields["F2"].w;
        fields[:battery_picture] = new BatteryField(
    		{
    			:x => System.getDeviceSettings().screenWidth/2-w,
    			:y => currentTop - h,
    			:h => h,
    			:w => w,
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
    			:w => w,
    			:type => :battery,
    			:fontId => :small,
    			:justify => Graphics.TEXT_JUSTIFY_LEFT
    		}
    	);

		///////////////////////////////////////////////////////////////////////
		//Bottom widget
		wType = Application.Properties.getValue(propNames[:WTypeBottom]);
		if (wType == WIDGET_TYPE_MOON){
	    	fields[:moon] = new MoonField(
				{
					:x => (System.getDeviceSettings().screenWidth - 2*hDataField)/2,
					:y => fields["F5"].y + fields["F5"].h,
					:h => 2*hDataField,
					:w => 2*hDataField,
					:type => :moon,
					:fontId => :small,
					:justify => Graphics.TEXT_JUSTIFY_CENTER
				}
	    	);
    	}else if (wType == WIDGET_TYPE_WEATHER){
    		var bottomBarWidth = createWeatherFields(
    			fields["F5"].y + fields["F5"].h, 
    			2*hDataField, 
    			2*hDataField, 
    			[:weather_picture_bottom, :weather_temp_bottom]);
    			
			shiftX = (dc.getWidth() - bottomBarWidth)/2;
			fields[:weather_picture_bottom][:x] += shiftX; 
			fields[:weather_temp_bottom][:x] += shiftX;
    	}else if (wType == WIDGET_TYPE_SOLAR){
    	
	    	fields[:solar_bottom] = new SolarField(
				{
					:x => (System.getDeviceSettings().screenWidth - 6*hDataField)/2,
					:y => fields["F5"].y + fields["F5"].h,
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
					:y => fields["F5"].y + fields["F5"].h,
					:h => h,
					:w => w,
	    			:type => graphType,
	    			:fontId => :small,
	    			:justify => Graphics.TEXT_JUSTIFY_CENTER,
	    			:showMinMax => false,
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
    	Application.getApp().registerEvents();
    	memoryCache = new MemoryCache();
    }

	function drawBackground(dc){
		var color = memoryCache.getBackgroundColor();
		dc.setColor(color, color);
		dc.setClip(0, 0, dc.getWidth(), dc.getHeight());
		dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
	}

    // Update the view
    function onUpdate(dc) {
		
		var reCreateFields = false;
		
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
