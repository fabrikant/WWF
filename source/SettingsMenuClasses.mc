using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Graphics;

//*****************************************************************************
class GeneralMenu extends WatchUi.Menu2{
	function initialize() {
		Menu2.initialize({:title=> Application.loadResource(Rez.Strings.SettingsMenu)});
		addItem(new TogleItem(:SwitchDayNight, "SwitchDayNight", Rez.Strings.SwitchDayNight));
		addItem(new Item(:G, null, Rez.Strings.SettingsGlobal, null));
		addItem(new Item(:D, null, Rez.Strings.SettingsDay, null));
		addItem(new Item(:N, null, Rez.Strings.SettingsNight, null));
		addItem(new Item(:T1TZ, "T1TZ", Rez.Strings.T1TZ, null));
		addItem(new Item(:keyOW, "keyOW", Rez.Strings.keyOW, null));
		addItem(new Item(:PrU, "PrU", Rez.Strings.PrU, :pressureUnit));
		addItem(new Item(:WU, "WU", Rez.Strings.WU, :windSpeedUnit));
	}
}

//*****************************************************************************
class SubMenu extends WatchUi.Menu2{
	
	function initialize(mode) {
		
		Menu2.initialize({:title=> Application.loadResource(Rez.Strings.SettingsMenu)});

		var dictNames = SettingsReference.getAppPropertyNames(mode);

		addItem(new Item(:Theme, dictNames[:Theme], Rez.Strings.Theme, :theme));
		addItem(new Item(:WTypeTop, dictNames[:WTypeTop], Rez.Strings.WTypeTop, :widgetTypeTop));
		addItem(new Item(:WTypeBottom, dictNames[:WTypeBottom], Rez.Strings.WTypeBottom, :widgetTypeBottom));
		   
		addItem(new Item(:F0, dictNames[:F0], Rez.Strings.F0, :field));
		addItem(new Item(:F1, dictNames[:F1], Rez.Strings.F1, :field));
		addItem(new Item(:F2, dictNames[:F2], Rez.Strings.F2, :field));
		addItem(new Item(:F3, dictNames[:F3], Rez.Strings.F3, :field));
		addItem(new Item(:F4, dictNames[:F4], Rez.Strings.F4, :field));
		addItem(new Item(:F5, dictNames[:F5], Rez.Strings.F5, :field));		
		addItem(new Item(:F6, dictNames[:F6], Rez.Strings.F6, :field));
		addItem(new Item(:F7, dictNames[:F7], Rez.Strings.F7, :field));
		
		addItem(new Item(:SF0, dictNames[:SF0], Rez.Strings.SF0, :statusField));
		addItem(new Item(:SF1, dictNames[:SF1], Rez.Strings.SF1, :statusField));
		addItem(new Item(:SF2, dictNames[:SF2], Rez.Strings.SF2, :statusField));
		addItem(new Item(:SF3, dictNames[:SF3], Rez.Strings.SF3, :statusField));
		addItem(new Item(:SF4, dictNames[:SF4], Rez.Strings.SF4, :statusField));
		addItem(new Item(:SF5, dictNames[:SF5], Rez.Strings.SF5, :statusField));
		
		addItem(new Item(:DF, dictNames[:DF], Rez.Strings.DF, null));
	}
	
}

//*****************************************************************************
class SelectMenu extends WatchUi.Menu2{

	function initialize(title, itemsDictonary, propName, parentItemWeak){
		Menu2.initialize({:title=> title});
		var keys = itemsDictonary.keys();
		for (var i=0; i<keys.size(); i++){
			addItem(new SelectItem(itemsDictonary[keys[i]], propName, keys[i], parentItemWeak));
		}
	}
}


//*****************************************************************************
class Item extends WatchUi.MenuItem{

	var propName;
	var subMenuDictonarySymbol;
	
	function initialize(identifier, propName, labelRes, descriptionMethodSymbol) {
		
		self.propName = propName;
		self.subMenuDictonarySymbol = descriptionMethodSymbol;
		 		
		var label = Application.loadResource(labelRes);
		var subLabel; 
		if (propName != null){
			subLabel = Application.Properties.getValue(propName);
		}else{
			subLabel = "";
		}
				
		if (descriptionMethodSymbol == null){
			subLabel = subLabel.toString();
		}else{
			var descrSymbol = getDescriptionStringSymbol(subLabel);
			subLabel = Application.loadResource(Rez.Strings[descrSymbol]);			
		}
		MenuItem.initialize(label, subLabel, identifier, {});
	}

	function onSelect(){
		if (subMenuDictonarySymbol != null){
			var subMenu = new SelectMenu(getLabel(), new Toybox.Lang.Method(SettingsReference, subMenuDictonarySymbol).invoke(), propName, self.weak());
			WatchUi.pushView(subMenu, new GeneralMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
		}else if (propName == null){
			var subMenu = new SubMenu(getId());
			WatchUi.pushView(subMenu, new GeneralMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
		}else if (getId() == :T1TZ || getId() == :keyOW || getId() == :DF){
			if (WatchUi has :Picker){
				var picker = new StringPicker(self, SettingsReference.getCharsString(getId()));
				WatchUi.pushView(picker, new StringPickerDelegate(picker), WatchUi.SLIDE_IMMEDIATE);
			}
		}
	}	
	
	function getDescriptionStringSymbol(value){
		var dict = new Toybox.Lang.Method(SettingsReference, subMenuDictonarySymbol).invoke();
		return dict[value];
	}
}

//*****************************************************************************
class TogleItem extends WatchUi.ToggleMenuItem{
	
	var propName;
	
	function initialize(identifier, propName, labelRes) {
		self.propName = propName;
		var label = Application.loadResource(labelRes);
		var enabled = Application.Properties.getValue(propName);
		ToggleMenuItem.initialize(label, null, identifier, enabled, {});
	}

	function onSelect(){
		Application.Properties.setValue(propName, isEnabled());
	}	
}

//*****************************************************************************
class SelectItem extends WatchUi.MenuItem{
	
	var value;
	var propName;
	var parentItemWeak;
	
	function initialize(identifier, propName, value, parentItemWeak) {
		self.value = value;
		self.propName = propName;
		self.parentItemWeak = parentItemWeak;
		MenuItem.initialize(Application.loadResource(Rez.Strings[identifier]), null, identifier, {});
	}

	function onSelect(){
		Application.Properties.setValue(propName, value);
		if (parentItemWeak.stillAlive()){
			var parent = parentItemWeak.get();
			parent.setSubLabel(getLabel()); 
		}
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	}
}

//*****************************************************************************
class GeneralMenuDelegate extends WatchUi.Menu2InputDelegate{
	
	 function initialize() {
        Menu2InputDelegate.initialize();
    }
    
	function onSelect(item){
		item.onSelect();
	}
}


module SettingsReference{

	//concat Strings is not work in real device
	function getAppPropertyNames(mode){
		var dict;
		if (mode == :G){
			dict = {
				:Theme => "GTheme",
				:WTypeTop => "GWTypeTop",
				:WTypeBottom => "GWTypeBottom",
				:DF => "GDF",
				:SF0 => "GSF0",
				:SF1 => "GSF1",
				:SF2 => "GSF2",
				:SF3 => "GSF3",
				:SF4 => "GSF4",
				:SF5 => "GSF5",
				:F6 => "GF6",
				:F7 => "GF7",
				:F0 => "GF0",
				:F1 => "GF1",
				:F2 => "GF2",
				:F3 => "GF3",
				:F4 => "GF4",
				:F5 => "GF5"};
		}else if (mode == :D ){
			dict = {
				:Theme => "DTheme",
				:WTypeTop => "DWTypeTop",
				:WTypeBottom => "DWTypeBottom",
				:DF => "DDF",
				:SF0 => "DSF0",
				:SF1 => "DSF1",
				:SF2 => "DSF2",
				:SF3 => "DSF3",
				:SF4 => "DSF4",
				:SF5 => "DSF5",
				:F6 => "DF6",
				:F7 => "DF7",
				:F0 => "DF0",
				:F1 => "DF1",
				:F2 => "DF2",
				:F3 => "DF3",
				:F4 => "DF4",
				:F5 => "DF5"};
		}else{
			dict = {
				:Theme => "NTheme",
				:WTypeTop => "NWTypeTop",
				:WTypeBottom => "NWTypeBottom",
				:DF => "NDF",
				:SF0 => "NSF0",
				:SF1 => "NSF1",
				:SF2 => "NSF2",
				:SF3 => "NSF3",
				:SF4 => "NSF4",
				:SF5 => "NSF5",
				:F6 => "NF6",
				:F7 => "NF7",
				:F0 => "NF0",
				:F1 => "NF1",
				:F2 => "NF2",
				:F3 => "NF3",
				:F4 => "NF4",
				:F5 => "NF5"};
		}
		
		return dict;
	}

	function theme(){
		return {
			DARK  			 => :ThemeDark,
			DARK_MONOCHROME	 => :ThemeDarkMonochrome,
			LIGHT  			 => :ThemeLight,
			LIGHT_MONOCHROME => :ThemeLightMonochrome,
		};
	}
	
	function pressureUnit(){
		return {
			UNIT_PRESSURE_MM_HG => :PrUMmHg,
			UNIT_PRESSURE_PSI => :PrUPsi,
			UNIT_PRESSURE_INCH_HG => :PrUInchHg,
			UNIT_PRESSURE_BAR => :PrUBar,
			UNIT_PRESSURE_KPA => :PrUKPa};
	}
	
	function windSpeedUnit(){
		return {
			UNIT_SPEED_MS => :SpeedUnitMSec,
			UNIT_SPEED_KMH => :SpeedUnitKmH,
			UNIT_SPEED_MLH => :SpeedUnitMileH,
			UNIT_SPEED_FTS => :SpeedUnitFtSec,
			UNIT_SPEED_BOF => :SpeedUnitBof,
			UNIT_SPEED_KNOTS => :SpeedUnitKnots};
	}
	
	function statusField(){
		return {
			CONNECTED 			=> :FIELD_TYPE_CONNECTED,
			NOTIFICATIONS 		=> :FIELD_TYPE_NOTIFICATIONS,
			NOTIFICATIONS_COUNT => :FIELD_TYPE_NOTIFICATIONS_COUNT,
			DND 				=> :FIELD_TYPE_DND,
			ALARMS 				=> :FIELD_TYPE_ALARMS,
			ALARMS_COUNT 		=> :FIELD_TYPE_ALARMS_COUNT,
			AMPM 				=> :FIELD_TYPE_AMPM,
			SECONDS 			=> :FIELD_TYPE_SECONDS,
			EMPTY 				=> :FIELD_TYPE_EMPTY};
	}
	
	function field(){
		return {
			HR 					=> :FIELD_TYPE_HR,
			STEPS 				=> :FIELD_TYPE_STEPS,
			PRESSURE 			=> :FIELD_TYPE_PRESSURE,
			TEMPERATURE 		=> :FIELD_TYPE_TEMPERATURE,
			CALORIES 			=> :FIELD_TYPE_CALORIES,
			DISTANCE 			=> :FIELD_TYPE_DISTANCE,
			FLOOR 				=> :FIELD_TYPE_FLOOR,
			ELEVATION 			=> :FIELD_TYPE_ELEVATION,
			SUN_EVENT 			=> :FIELD_TYPE_SUN_EVENT,
			SUNRISE_EVENT 		=> :FIELD_TYPE_SUNRISE,
			SUNSET_EVENT 		=> :FIELD_TYPE_SUNSET,
			TIME1 				=> :FIELD_TYPE_TIME1,
			ACTIVE_DAY 			=> :FIELD_TYPE_ACTIVE_DAY,
			ACTIVE_WEEK 		=> :FIELD_TYPE_ACTIVE_WEEK,
			O2 					=> :FIELD_TYPE_O2,
			SOLAR_CHARGE 		=> :FIELD_TYPE_SOLAR_CHARGE,
			WEIGHT 				=> :FIELD_TYPE_WEIGHT,
			WEATHER_TEMPERATURE => :FIELD_TYPE_WEATHER_TEMPERATURE,
			WEATHER_PRESSURE 	=> :FIELD_TYPE_WEATHER_PRESSURE,
			WEATHER_HUM 		=> :FIELD_TYPE_WEATHER_HUM,
			WEATHER_VISIBILITY 	=> :FIELD_TYPE_WEATHER_VISIBILITY,
			WEATHER_WIND_SPEED 	=> :FIELD_TYPE_WEATHER_WIND_SPEED,
			WEATHER_WIND_DEG 	=> :FIELD_TYPE_WEATHER_WIND_DEG,
			WEATHER_UVI 		=> :FIELD_TYPE_WEATHER_UVI,
			WEATHER_DEW_POINT 	=> :FIELD_TYPE_WEATHER_DEW_POINT,
			EMPTY 				=> :FIELD_TYPE_EMPTY};
	}
	
	function widgetTypeTop(){
		return{
			WIDGET_TYPE_WEATHER 		=> :WTypeWeather,
			WIDGET_TYPE_WEATHER_WIND 	=> :WTypeWeatherWind,
			WIDGET_TYPE_WEATHER_FIELDS 	=> :WTypeWeatherFields,
			WIDGET_TYPE_HR 				=> :WTypeHeartRateHistory,
			WIDGET_TYPE_SATURATION 		=> :WTypeSaturationHistory,
			WIDGET_TYPE_TEMPERATURE 	=> :WTypeTemperatureHistory,
			WIDGET_TYPE_PRESSURE 		=> :WTypePressureHistory,
			WIDGET_TYPE_ELEVATION 		=> :WTypeElevationHistory};
	}	
	
	function widgetTypeBottom(){
		return {
			WIDGET_TYPE_WEATHER => :WTypeWeather,
			WIDGET_TYPE_MOON 	=> :WTypeMoon};
	}	
	
	function getCharsString(idSymbol){
		if (idSymbol == :T1TZ){
			return "-1234567890";
		}else if(idSymbol == :DF){
			return "%dDmMNyYwW#./- ";
		}else if(idSymbol == :keyOW){
			return "0123456789abcdef";	
		}else{
			return "";	
		}
	}
}