using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;

//*****************************************************************************
class MenuSettings extends WatchUi.Menu2{

	function initialize() {
		Menu2.initialize({:title=>Application.loadResource(Rez.Strings.SettingsMenu)});
		var set = Application.loadResource(Rez.Strings.SettingsSet);
        addItem(
            new ToggleMenuItem(
                Application.loadResource(Rez.Strings.SwitchDayNight),
                null,
                :autoSwitch,
                Application.Properties.getValue("SwitchDayNight"),
                {}
            )
        );

        addItem(
            new MenuItem(
                Application.loadResource(Rez.Strings.SettingsSave),
                Application.loadResource(Rez.Strings.SettingsSaveDescription),
                :save,
                {}
            )
        );
        
        addItem(
            new MenuItem(
                Application.loadResource(Rez.Strings.SettingsRemove)+"...",
                null,
                :remove,
                {}
            )
        );

		var sublabel = null;
		var momentValue = StorageSettings.getPeriodicSettingsId(STORAGE_KEY_GLOBAL);
		if (momentValue != null){
			sublabel = Tools.momentToDateTimeString(new Time.Moment(momentValue));
		}
        addItem(
            new MenuItem(
                set+Application.loadResource(Rez.Strings.SettingsGlobal),
                sublabel,
                :global,
                {}
            )
        );

		sublabel = null;
		momentValue = StorageSettings.getPeriodicSettingsId(STORAGE_KEY_DAY);
		if (momentValue != null){
			sublabel = Tools.momentToDateTimeString(new Time.Moment(momentValue));
		}
        addItem(
            new MenuItem(
                set+Application.loadResource(Rez.Strings.SettingsDay),
                sublabel,
                :day,
                {}
            )
        );
 
		sublabel = null;
		momentValue = StorageSettings.getPeriodicSettingsId(STORAGE_KEY_NIGHT);
		if (momentValue != null){
			sublabel = Tools.momentToDateTimeString(new Time.Moment(momentValue));
		}
        addItem(
            new MenuItem(
                set+Application.loadResource(Rez.Strings.SettingsNight),
                sublabel,
                :night,
                {}
            )
        );

	}
	
    function saveCurrentSettings(item){
    	var moment = Time.now();
    	StorageSettings.save(moment);
    	item.setSubLabel(Tools.momentToDateTimeString(moment));
    }
    
    function onSelect(item){
    	var id = item.getId();
    	if (id == :save){
    		saveCurrentSettings(item);
    	}else if (id == :autoSwitch){
    		Application.Properties.setValue("SwitchDayNight", item.isEnabled());
    		memoryCache.reload();
    	}else{
    		var listMenu = null;
    		var set = Application.loadResource(Rez.Strings.SettingsSet);
	    	if(id == :remove){
	    		listMenu = new MenuSettingsList(item, Application.loadResource(Rez.Strings.SettingsRemove));
	    	}else if(id == :day){
	    		listMenu = new MenuSettingsList(item, set+Application.loadResource(Rez.Strings.SettingsDay));
	    	}else if(id == :night){
	    		listMenu = new MenuSettingsList(item, set+Application.loadResource(Rez.Strings.SettingsNight));
	    	}else if(id == :global){
	    		listMenu = new MenuSettingsList(item, set+Application.loadResource(Rez.Strings.SettingsGlobal));
    		}
    		if (listMenu != null){
 		    	WatchUi.pushView(listMenu, new MenuDelegate(listMenu), WatchUi.SLIDE_IMMEDIATE);
 		    }

    	}
    }
}

//*****************************************************************************
class MenuSettingsList extends WatchUi.Menu2{
	
	protected var id, parentItem; 
	
	function initialize(item, title) {
		self.parentItem = item;
		self.id = item.getId();
		Menu2.initialize({:title=>title});
	   	
	   	var idsSettings = Application.Storage.getValue(STORAGE_KEY_SETTINGS);
    	if (idsSettings == null){
    		idsSettings = [:empty];
    	} else if (idsSettings.size() == 0){
    		idsSettings = [:empty];
    	}
    	
		for (var i = 0; i < idsSettings.size(); i++){
			var label = "";
			if (idsSettings[i] != :empty){
				label = Tools.momentToDateTimeString(new Time.Moment(idsSettings[i]));
			}
			
	        addItem(
	            new MenuItem(
	                label,
	                null,
	                idsSettings[i],
	                {}
	            )
	        );
		}
	}
			
	function onSelect(item){
		var itemId = item.getId();
		if (itemId != :empty){
			if(id == :remove){
	    		StorageSettings.remove(itemId);
	    	}else if(id == :day){
	    		StorageSettings.setPeriodicSettings(STORAGE_KEY_DAY, itemId);
	    		parentItem.setSubLabel(Tools.momentToDateTimeString(new Time.Moment(itemId)));
	    	}else if(id == :night){
	    		StorageSettings.setPeriodicSettings(STORAGE_KEY_NIGHT, itemId);
	    		parentItem.setSubLabel(Tools.momentToDateTimeString(new Time.Moment(itemId)));
	    	}else if(id == :global){
	    		StorageSettings.setPeriodicSettings(STORAGE_KEY_GLOBAL, itemId);
	    		parentItem.setSubLabel(Tools.momentToDateTimeString(new Time.Moment(itemId)));
	    	}
    	}	
    	WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
} 

//*****************************************************************************
class MenuDelegate extends WatchUi.Menu2InputDelegate{

	var menu;
	
	function initialize(menu) {
		self.menu = menu;
		Menu2InputDelegate.initialize();
	}
	
	function onSelect(item){
		menu.onSelect(item);
	}
}

//*****************************************************************************
module StorageSettings {
	
	///////////////////////////////////////////////////////////////////////////
    function save(moment){
    	
    	var idsSettings = Application.Storage.getValue(STORAGE_KEY_SETTINGS);
    	if (idsSettings == null){
    		idsSettings = [];
    	}
    	
    	var propKeys = StorageSettings.getPropertiesKeys();
    	var settings = {};
    	for (var i = 0; i < propKeys.size(); i++){
			settings.put(propKeys[i], Application.Properties.getValue(propKeys[i]));    		
    	}
    	
    	var currentSettingsId = moment.value();
    	Application.Storage.setValue(currentSettingsId, settings);
    	idsSettings.add(currentSettingsId); 
    	Application.Storage.setValue(STORAGE_KEY_SETTINGS, idsSettings);
    }

	///////////////////////////////////////////////////////////////////////////
	function load(currentSettingsId){
		
		var settings = Application.Storage.getValue(currentSettingsId);
		if (settings == null){
			return;
		}
		
		var propKeys = StorageSettings.getPropertiesKeys();
		for (var i = 0; i < propKeys.size(); i++){
			var value = settings[propKeys[i]];
			if (value != null){
				Application.Properties.setValue(propKeys[i], value);
			}			
		}
		memoryCache.reload();			
	}
		
	///////////////////////////////////////////////////////////////////////////
	function remove(currentSettingsId){
		if (currentSettingsId == null){
			return;
		}
		Application.Storage.deleteValue(currentSettingsId);
		var idsSettings = Application.Storage.getValue(STORAGE_KEY_SETTINGS);
		if (idsSettings != null){
			if(idsSettings.remove(currentSettingsId)){
				Application.Storage.setValue(STORAGE_KEY_SETTINGS, idsSettings);				
			}
		}
		if (StorageSettings.getPeriodicSettingsId(STORAGE_KEY_DAY) == currentSettingsId){
			setPeriodicSettings(STORAGE_KEY_DAY, null);
		}
		if (StorageSettings.getPeriodicSettingsId(STORAGE_KEY_NIGHT) == currentSettingsId){
			setPeriodicSettings(STORAGE_KEY_NIGHT, null);
		}
		if (StorageSettings.getPeriodicSettingsId(STORAGE_KEY_GLOBAL) == currentSettingsId){
			setPeriodicSettings(STORAGE_KEY_GLOBAL, null);
		}
	}
	
	///////////////////////////////////////////////////////////////////////////
	function setPeriodicSettings(keyStorage, settingsId){
		
		if (settingsId == null){
			Application.Storage.deleteValue(keyStorage);
			return;
		}
		
		var settings = Application.Storage.getValue(settingsId);
		if (settings == null){
			Application.Storage.deleteValue(keyStorage);
			return;
		}
		Application.Storage.setValue(keyStorage, settingsId);
	}
	
	///////////////////////////////////////////////////////////////////////////
	function getPeriodicSettingsId(keyStorage){
		var res = null;
		res = Application.Storage.getValue(keyStorage);
		return res;
	}
	
	///////////////////////////////////////////////////////////////////////////
	function getPropertiesKeys(){
		var res = [];
	    res.add("MilFt");
		res.add("HFt01");
		res.add("DF");
	    res.add("BgndColor");
	    res.add("TimeColor");
	    res.add("DateColor");
	    res.add("WType");
	    res.add("WColor");
	    res.add("WAutoColor");
	    res.add("WShowWindWidget");
	    res.add("ShowOWMIcons");
	    res.add("WindArrowContour");
	    res.add("ShowTopFields");
	    
	    res.add("BatColor");
	    res.add("MoonColor");
		res.add("WUpdInt");
		res.add("PrU");
		res.add("WU");
		res.add("T1TZ");
		for (var i = 0; i < FIELDS_COUNT; i++){
			res.add("F"+i);
			res.add("C"+i);
		}
		for (var i = 0; i < STATUS_FIELDS_COUNT; i++){
			res.add("SF"+i);
			res.add("SFC"+i);
		}
		return res;
	}
	
}