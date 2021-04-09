using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Graphics;

//*****************************************************************************
class GeneralMenu extends WatchUi.Menu2{
	function initialize() {
		Menu2.initialize({:title=> Application.loadResource(Rez.Strings.SettingsMenu)});
		addItem(new TogleItem(:SwitchDayNight, "SwitchDayNight", Rez.Strings.SwitchDayNight));
		addItem(new Item(:keyOW, "keyOW", Rez.Strings.keyOW, null));
		addItem(new Item(:DF, "DF", Rez.Strings.DF, null));
		addItem(new Item(:T1TZ, "T1TZ", Rez.Strings.T1TZ, null));
		addItem(new Item(:PrU, "PrU", Rez.Strings.PrU, :pressureUnit));
		addItem(new Item(:WU, "WU", Rez.Strings.WU, :windSpeedUnit));
		addItem(new Item(:G, null, Rez.Strings.SettingsGlobal, null));
		addItem(new Item(:D, null, Rez.Strings.SettingsDay, null));
		addItem(new Item(:N, null, Rez.Strings.SettingsNight, null));
	}
}

//*****************************************************************************
class SubMenu extends WatchUi.Menu2{
	
	function initialize(mode) {
		
		Menu2.initialize({:title=> Application.loadResource(Rez.Strings.SettingsMenu)});

		var dictNames = getAppNames(mode);

		addItem(new Item(:Theme, dictNames[:Theme], Rez.Strings.Theme, :theme));
		addItem(new Item(:WType, dictNames[:WType], Rez.Strings.WType, :widgetType));
		addItem(new TogleItem(:WShowWindWidget, dictNames[:WShowWindWidget], Rez.Strings.WShowWindWidget));
		addItem(new TogleItem(:ShowTopFields, dictNames[:ShowTopFields], Rez.Strings.ShowTopFields));
		   
		addItem(new Item(:SF0, dictNames[:SF0], Rez.Strings.SF0, :statusField));
		addItem(new Item(:SF1, dictNames[:SF1], Rez.Strings.SF1, :statusField));
		addItem(new Item(:SF2, dictNames[:SF2], Rez.Strings.SF2, :statusField));
		addItem(new Item(:SF3, dictNames[:SF3], Rez.Strings.SF3, :statusField));
		addItem(new Item(:SF4, dictNames[:SF4], Rez.Strings.SF4, :statusField));
		addItem(new Item(:SF5, dictNames[:SF5], Rez.Strings.SF5, :statusField));

		addItem(new Item(:F0, dictNames[:F0], Rez.Strings.F2, :field));
		addItem(new Item(:F1, dictNames[:F1], Rez.Strings.F3, :field));
		addItem(new Item(:F2, dictNames[:F2], Rez.Strings.F4, :field));
		addItem(new Item(:F3, dictNames[:F3], Rez.Strings.F5, :field));
		addItem(new Item(:F4, dictNames[:F4], Rez.Strings.F6, :field));
		addItem(new Item(:F5, dictNames[:F5], Rez.Strings.F7, :field));		
		addItem(new Item(:F6, dictNames[:F6], Rez.Strings.F0, :field));
		addItem(new Item(:F7, dictNames[:F7], Rez.Strings.F1, :field));
		
	}
	
	//concat Strings is not work in real device
	function getAppNames(mode){
		var dict;
		if (mode == :G){
			dict = {
				:Theme => "GTheme",
				:WType => "GWType",
				:WShowWindWidget => "GWShowWindWidget",
				:ShowTopFields => "GShowTopFields",
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
				:WType => "DWType",
				:WShowWindWidget => "DWShowWindWidget",
				:ShowTopFields => "DShowTopFields",
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
				:WType => "NWType",
				:WShowWindWidget => "NWShowWindWidget",
				:ShowTopFields => "NShowTopFields",
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
			var subMenu = new SelectMenu(getLabel(), method(subMenuDictonarySymbol).invoke(), propName, self.weak());
			WatchUi.pushView(subMenu, new GeneralMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
		}else if (propName == null){
			var subMenu = new SubMenu(getId());
			WatchUi.pushView(subMenu, new GeneralMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
		}
	}	
	
	function getDescriptionStringSymbol(value){
		var dict = method(subMenuDictonarySymbol).invoke();
		return dict[value];
	}
	
	function theme(){
		return {
			0 => :ThemeDark,
			1 => :ThemeLight
		};
	}
	
	function pressureUnit(){
		return {
			0 => :PrUMmHg,
			1 => :PrUPsi,
			2 => :PrUInchHg,
			3 => :PrUBar,
			4 => :PrUKPa};
	}
	
	function windSpeedUnit(){
		return {
			0 => :SpeedUnitMSec,
			1 => :SpeedUnitKmH,
			2 => :SpeedUnitMileH,
			3 => :SpeedUnitFtSec,
			4 => :SpeedUnitBof,
			5 => :SpeedUnitKnots};
	}
	
	function statusField(){
		return {
			18 => :FIELD_TYPE_CONNECTED,
			19 => :FIELD_TYPE_NOTIFICATIONS,
			24 => :FIELD_TYPE_NOTIFICATIONS_COUNT,
			20 => :FIELD_TYPE_DND,
			21 => :FIELD_TYPE_ALARMS,
			25 => :FIELD_TYPE_ALARMS_COUNT,
			22 => :FIELD_TYPE_AMPM,
			23 => :FIELD_TYPE_SECONDS,
			12 => :FIELD_TYPE_EMPTY};
	}
	
	function field(){
		return {
			0 => :FIELD_TYPE_HR,
			1 => :FIELD_TYPE_STEPS,
			2 => :FIELD_TYPE_PRESSURE,
			3 => :FIELD_TYPE_TEMPERATURE,
			4 => :FIELD_TYPE_CALORIES,
			5 => :FIELD_TYPE_DISTANCE,
			6 => :FIELD_TYPE_FLOOR,
			7 => :FIELD_TYPE_ELEVATION,
			8 => :FIELD_TYPE_SUN_EVENT,
			9 => :FIELD_TYPE_SUNRISE,
			10 => :FIELD_TYPE_SUNSET,
			11 => :FIELD_TYPE_TIME1,
			13 => :FIELD_TYPE_ACTIVE_DAY,
			14 => :FIELD_TYPE_ACTIVE_WEEK,
			15 => :FIELD_TYPE_O2,
			16 => :FIELD_TYPE_SOLAR_CHARGE,
			17 => :FIELD_TYPE_WEIGHT,
			26 => :FIELD_TYPE_WEATHER_PRESSURE,
			27 => :FIELD_TYPE_WEATHER_HUM,
			28 => :FIELD_TYPE_WEATHER_VISIBILITY,
			29 => :FIELD_TYPE_WEATHER_WIND_SPEED,
			30 => :FIELD_TYPE_WEATHER_WIND_DEG,
			31 => :FIELD_TYPE_WEATHER_UVI,
			32 => :FIELD_TYPE_WEATHER_DEW_POINT,
			12 => :FIELD_TYPE_EMPTY};
	}
	
	function widgetType(){
		return{
			0 => :WTypeWeather,
			1 => :WTypeHeartRateHistory,
			2 => :WTypeSaturationHistory,
			3 => :WTypeTemperatureHistory,
			4 => :WTypePressureHistory,
			5 => :WTypeElevationHistory};
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
