using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Graphics;
using Toybox.Activity;
using Toybox.ActivityMonitor;
using Toybox.SensorHistory;
using Toybox.Lang;

//*****************************************************************************
class GeneralMenu extends WatchUi.Menu2{
	
	function initialize() {
		Menu2.initialize({:title=> Application.loadResource(Rez.Strings.SettingsMenu)});
		
		addItem(new NewLevelItem("G", Rez.Strings.SettingsGlobal));
		
		addItem(new TogleItem("SwitchDayNight", Rez.Strings.SwitchDayNight));
		addItem(new TogleItem("DNDisNight", Rez.Strings.DNDisNight));
		addItem(new PickerItem("T1TZ", Rez.Strings.T1TZ));
		addItem(new TogleItem("MilFt", Rez.Strings.MilFt));
		addItem(new TogleItem("HFt01", Rez.Strings.HFt01));
		addItem(new Item("WU", Rez.Strings.WU, :subMenuPatternWindSpeeddUnit));
		addItem(new Item("PrU", Rez.Strings.PrU, :subMenuPatternPressureUnit));
		
//		addItem(new Item("Circle", Rez.Strings.Circle, :subMenuPatternCircleTypes));
//		addItem(new Item("Top", Rez.Strings.Top, :subMenuPatternTopBottomTypes));
//		addItem(new Item("Bot", Rez.Strings.Bot, :subMenuPatternTopBottomTypes));
//		addItem(new Item("Dt1", Rez.Strings.Dt1, :subMenuPatternDataFields));
//		
//
//		addItem(new Item("ThemeD", Rez.Strings.ThemeD, :subMenuPatternThemes));
//		addItem(new Item("ThemeN", Rez.Strings.ThemeN, :subMenuPatternThemes));
//		addItem(new TogleItem("DNDisN", Rez.Strings.DNDisN));
//		addItem(new TogleItem("InvertCircle", Rez.Strings.InvertCircle));
//		addItem(new TogleItem("SBat", Rez.Strings.SBat));
//		addItem(new Item("SBt", Rez.Strings.SBt, :subMenuPatternBluetooth));		
//		addItem(new TogleItem("SAl", Rez.Strings.SAl));		
//		addItem(new TogleItem("ShowDND", Rez.Strings.ShowDND));
//		
//		if (!System.getDeviceSettings().is24Hour){
//			addItem(new TogleItem("ShowAmPm", Rez.Strings.ShowAmPm));
//		}
//		
//		addItem(new PickerItem("T1TZ", Rez.Strings.T1TZ));
//		addItem(new Item("WndU", Rez.Strings.WndU, :subMenuPatternWindSpeeddUnit));
	}
	
	function onHide(){
		Application.getApp().onSettingsChanged();
	}
}


//*****************************************************************************
class NewLevelItem extends WatchUi.MenuItem{

	//var levelName;
	
	function initialize(levelName, resLabel) {
		//self.levelName = levelName;
		MenuItem.initialize(Application.loadResource(resLabel), "", levelName, {});
	}

	function onSelectItem(){
		System.println("onSelectItem");
		WatchUi.pushView(new NewLevelMenu(getLabel(), getId()), new SimpleMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
	}	

	function onSelectSubmenuItem(newValue){
//		Application.Properties.setValue(getId(),newValue);
//		setSubLabel(Patterns.getSublabel(patternMethodSymbol, newValue));
	}	
}

//*****************************************************************************
class Item extends WatchUi.MenuItem{

	var patternMethodSymbol;
	
	function initialize(propName, resLabel, patternMethodSymbol) {
		self.patternMethodSymbol = patternMethodSymbol;
		var label = Application.loadResource(resLabel);
		var value = Application.Properties.getValue(propName);
		//var sublabel = patternMethodSymbol[value]; 
		var sublabel = Patterns.getSublabel(patternMethodSymbol, value);
		MenuItem.initialize(label, sublabel, propName, {});
	}

	function onSelectItem(){
		var weak = self.weak();
		var submenu = new SelectMenu(getLabel(), patternMethodSymbol, getId(), weak);
		WatchUi.pushView(submenu, new SimpleMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
	}	

	function onSelectSubmenuItem(newValue){
		Application.Properties.setValue(getId(),newValue);
		setSubLabel(Patterns.getSublabel(patternMethodSymbol, newValue));
	}	
}

//*****************************************************************************
class TogleItem extends WatchUi.ToggleMenuItem{
	
	function initialize(propName, resLabel) {
		var label = Application.loadResource(resLabel);
		var enabled = Application.Properties.getValue(propName);
		ToggleMenuItem.initialize(label, null, propName, enabled, {});
	}

	function onSelectItem(){
		Application.Properties.setValue(getId(), isEnabled());
	}	
}

//*****************************************************************************
class PickerItem extends WatchUi.MenuItem{
	
	function initialize(propName, resLabel) {
		var label = Application.loadResource(resLabel);
		var sublabel = Application.Properties.getValue(propName);
		MenuItem.initialize(label, sublabel.toString(), propName, {});
	}

	function onSelectItem(){
		var picker = new StringPicker(self.weak(), "0123456789-");
		WatchUi.pushView(picker, new StringPickerDelegate(picker), WatchUi.SLIDE_IMMEDIATE);
	}	
	
	function onSetText(value){
		setSubLabel(value);
		Application.Properties.setValue(getId(), value.toNumber());
	}
}


//*****************************************************************************
//NEW LEVEL MENU
class NewLevelMenu extends WatchUi.Menu2{
	
	function initialize(title, levelName) {
		Menu2.initialize({:title=> title});
		
//	<property id="GDF" type="string">%W %D %M %Y</property>
//	<property id="GTheme" type="number">0</property>
//
//    <property id="GWTypeTop" type="number">1</property>
//    <property id="GWTypeBottom" type="number">8</property>
//
//	<!--STATUS FIELDS -->
//	<property id="GSF0" type="number">26</property>
//	<property id="GSF1" type="number">28</property>
//	<property id="GSF2" type="number">29</property>
//	<property id="GSF3" type="number">27</property>
//	<property id="GSF4" type="number">32</property>
//	<property id="GSF5" type="number">31</property>
//
//	<!--FIELSDS TYPES -->
//	<property id="GF0" type="number">33</property>
//	<property id="GF1" type="number">33</property>
//	<property id="GF2" type="number">2</property>
//	<property id="GF3" type="number">0</property>
//	<property id="GF4" type="number">3</property>
//	<property id="GF5" type="number">10</property>
//	<property id="GF6" type="number">11</property>
//	<property id="GF7" type="number">33</property>


		//addItem(new PickerItem("GDF", Rez.Strings.GDF));
		//addItem(new TogleItem("HFt01", Rez.Strings.HFt01));
		//addItem(new Item("WU", Rez.Strings.WU, :subMenuPatternWindSpeeddUnit));

		addItem(new PickerItem("GDF", Rez.Strings.DF));
		addItem(new Item("GTheme", Rez.Strings.Theme, :subMenuPatternThemes));

	}
	
}

//*****************************************************************************
//SUBMENU
class SelectMenu extends WatchUi.Menu2{

	
	function initialize(title, patternMethodSymbol, propName, callbackWeak){
		
		Menu2.initialize({:title=> title});
		var propValue = Application.Properties.getValue(propName);
		var method = new Lang.Method(Patterns, patternMethodSymbol);
		var pattern = method.invoke();
		var keys = pattern.keys();
		for (var i=0; i<keys.size(); i++){
			addItem(new SelectItem(keys[i], pattern[keys[i]], callbackWeak));
			if (propValue == keys[i]){
				setFocus(i);
			}
		}
	}
}

//*****************************************************************************
class SelectItem extends WatchUi.MenuItem{
	
	var callbackWeak;
	
	function initialize(identifier, resLabel, callbackWeak) {
		self.callbackWeak = callbackWeak; 
		MenuItem.initialize(Application.loadResource(resLabel), null, identifier, {});
	}

	function onSelectItem(){
		if (callbackWeak.stillAlive()){
			var obj = callbackWeak.get();
			if (obj != null){
				obj.onSelectSubmenuItem(getId());
			}
		}
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);	
		
	}
}

//*****************************************************************************
//DELEGATE
class SimpleMenuDelegate extends WatchUi.Menu2InputDelegate{
	
	function initialize() {
        Menu2InputDelegate.initialize();
    }
    
	function onSelect(item){
		item.onSelectItem();
	}
}

module Patterns{
 	
 	function subMenuPatternWindSpeeddUnit(){
		return {
			UNIT_SPEED_MS => Rez.Strings.SpeedUnitMSec,
			UNIT_SPEED_KMH => Rez.Strings.SpeedUnitKmH,
			UNIT_SPEED_MLH => Rez.Strings.SpeedUnitMileH,
			UNIT_SPEED_FTS => Rez.Strings.SpeedUnitFtSec,
			UNIT_SPEED_BOF => Rez.Strings.SpeedUnitBof,
			UNIT_SPEED_KNOTS => Rez.Strings.SpeedUnitKnots,
		};
	}

	function subMenuPatternPressureUnit(){
		return {
			UNIT_PRESSURE_MM_HG => Rez.Strings.PrUMmHg,
			UNIT_PRESSURE_PSI => Rez.Strings.PrUPsi,
			UNIT_PRESSURE_INCH_HG => Rez.Strings.PrUInchHg,
			UNIT_PRESSURE_BAR => Rez.Strings.PrUBar,
			UNIT_PRESSURE_KPA => Rez.Strings.PrUKPa};
	}
	
	function subMenuPatternThemes(){

		return {
			DARK => Rez.Strings.ThemeDark,
			DARK_MONOCHROME => Rez.Strings.ThemeDarkMonochrome,
			LIGHT => Rez.Strings.ThemeLight,
			LIGHT_MONOCHROME => Rez.Strings.ThemeLightMonochrome,
			DARK_COLOR => Rez.Strings.ThemeDarkColor,
			LIGHT_COLOR => Rez.Strings.ThemeLightColor,
			LIGHT_RED_COLOR => Rez.Strings.ThemeLightRedColor,
			LIGHT_GREEN_COLOR => Rez.Strings.ThemeLightGreenColor,
			LIGHT_BLUE_COLOR => Rez.Strings.ThemeLightBlueColor,
			DARK_RED_COLOR => Rez.Strings.ThemeDarkRedColor,
			DARK_GREEN_COLOR => Rez.Strings.ThemeDarkGreenColor,
			DARK_BLUE_COLOR => Rez.Strings.ThemeDarkBlueColor,
		};
	
	}
	
	
	
	
//	function subMenuPatternDataFields(){
//		 var pattern = {
//			EMPTY => Rez.Strings.FIELD_TYPE_EMPTY,
//			CALORIES => Rez.Strings.FIELD_TYPE_CALORIES,
//			DISTANCE => Rez.Strings.FIELD_TYPE_DISTANCE,
//			STEPS => Rez.Strings.FIELD_TYPE_STEPS,
//			TIME_ZONE => Rez.Strings.FIELD_TYPE_TIME1,
//			MOON => Rez.Strings.FIELD_TYPE_MOON,
//		};
//		
//		if (Activity.Info has :currentOxygenSaturation){
//			pattern[O2] = Rez.Strings.FIELD_TYPE_O2;
//		}
//		if (Activity.Info has :altitude){
//			pattern[ELEVATION] = Rez.Strings.FIELD_TYPE_ELEVATION;
//		}
//		if (ActivityMonitor.Info has :floorsClimbed){
//			pattern[FLOOR] = Rez.Strings.FIELD_TYPE_FLOOR;
//		}
//		if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory)){
//			pattern[STRESS] = Rez.Strings.FIELD_TYPE_STRESS;
//		}
//		if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory)){
//			pattern[BODY_BATTERY] = Rez.Strings.FIELD_TYPE_BODY_BATTERY;
//		}
//		
//		return pattern;
//	}
//
//	function subMenuPatternTopBottomTypes(){
//		var dict =  {
//			EMPTY => Rez.Strings.FIELD_TYPE_EMPTY,
//			TOP_BOTTOM_TYPE_BATTERY => Rez.Strings.FIELD_TYPE_BATTERY,
//			TOP_BOTTOM_TYPE_DATE => Rez.Strings.FIELD_TYPE_DATE,
//			TOP_BOTTOM_TYPE_WEATHER_CONDITION => Rez.Strings.FIELD_TYPE_WEATHER_CONDITION,
//			TOP_BOTTOM_TYPE_CITY => Rez.Strings.FIELD_TYPE_CITY,
//		};
//		//add data fields types
//		var dictDataFields = subMenuPatternDataFields();
//		var keys = dictDataFields.keys();
//		for (var i = 0; i < keys.size(); i++){
//			dict.put(keys[i], dictDataFields[keys[i]]);
//		} 
//		return dict;
//	}
//	
//	function subMenuPatternThemes(){
//		return {
//			THEME_DARK => Rez.Strings.ThemeDark,
//			THEME_LIGHT => Rez.Strings.ThemeLight,
//			THEME_INSTINCT_LIKE_1 => Rez.Strings.ThemeInstinctLike1,
//			THEME_INSTINCT_LIKE_2 => Rez.Strings.ThemeInstinctLike2,
//		};
//	}
//
//	function subMenuPatternBluetooth(){
//		return {
//			BLUETOOTH_SHOW_IF_CONNECT => Rez.Strings.ShowBluetoothIfConnect,
//			BLUETOOTH_SHOW_IF_DISCONNECT => Rez.Strings.ShowBluetoothIfDisconnect,
//			BLUETOOTH_HIDE => Rez.Strings.ShowBluetoothHide,
//		};
//	}
//	
//	function subMenuPatternCircleTypes(){
//		return {
//			CIRCLE_TYPE_HR => Rez.Strings.FIELD_TYPE_HR,
//			CIRCLE_TYPE_SECONDS => Rez.Strings.FIELD_TYPE_SECONDS,
//		};
//	}
	
	function getSublabel(methodSymbol, value){
		var method = new Lang.Method(Patterns, methodSymbol);
		var pattern = method.invoke();
		return pattern[value];
	}

}
