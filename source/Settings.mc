using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;

//*****************************************************************************
class MenuSettings extends WatchUi.Menu2{

	function initialize() {
		Menu2.initialize({:title=>Application.loadResource(Rez.Strings.SettingsMenu)});
        addItem(
            new MenuItem(
                Application.loadResource(Rez.Strings.SettingsSave),
                null,
                :save,
                {}
            )
        );
        
        addItem(
            new MenuItem(
                Application.loadResource(Rez.Strings.SettingsLoad)+"...",
                null,
                :load,
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
		var momentValue = StorageSettings.getPeriodicSettingsId(STORAGE_KEY_DAY);
		if (momentValue != null){
			sublabel = Tools.momentToDateTimeString(new Time.Moment(momentValue));
		}
        addItem(
            new MenuItem(
                Application.loadResource(Rez.Strings.SettingsDay)+"...",
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
                Application.loadResource(Rez.Strings.SettingsNight)+"...",
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
    	}else{
    		var listMenu = null;
	    	if(id == :load){
	    		listMenu = new MenuSettingsList(item, Application.loadResource(Rez.Strings.SettingsDay));
	    	}else if(id == :remove){
	    		listMenu = new MenuSettingsList(item, Application.loadResource(Rez.Strings.SettingsRemove));
	    	}else if(id == :day){
	    		listMenu = new MenuSettingsList(item, Application.loadResource(Rez.Strings.SettingsRemove));
	    	}else if(id == :night){
	    		listMenu = new MenuSettingsList(item, Application.loadResource(Rez.Strings.SettingsNight));
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
			if(id == :load){
				StorageSettings.load(itemId);
	    	}else if(id == :remove){
	    		StorageSettings.remove(itemId);
	    	}else if(id == :day){
	    		StorageSettings.setPeriodicSettings(STORAGE_KEY_DAY, itemId);
	    		parentItem.setSubLabel(Tools.momentToDateTimeString(new Time.Moment(itemId)));
	    	}else if(id == :night){
	    		StorageSettings.setPeriodicSettings(STORAGE_KEY_NIGHT, itemId);
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
	}
	
	///////////////////////////////////////////////////////////////////////////
	function setPeriodicSettings(keyDayNight, settingsId){
		
		if (settingsId == null){
			Application.Storage.deleteValue(keyDayNight);
			return;
		}
		
		var settings = Application.Storage.getValue(settingsId);
		if (settings == null){
			Application.Storage.deleteValue(keyDayNight);
			return;
		}
		Application.Storage.setValue(keyDayNight, settingsId);
	}
	
	///////////////////////////////////////////////////////////////////////////
	function getPeriodicSettingsId(keyDayNight){
		var res = null;
		res = Application.Storage.getValue(keyDayNight);
		return res;
	}
	
	///////////////////////////////////////////////////////////////////////////
	function getPropertiesKeys(){
		var res = [];
	    res.add("MilFt");
		res.add("HFt01");
		res.add("AmPm");
		res.add("Sec");
		res.add("HREverySec");
		res.add("DF");
	    res.add("BgndColor1");
	    res.add("BgndColor2");
	    res.add("BgndColor3");
	    res.add("TimeColor");
	    res.add("DateColor");
	    res.add("WColor");
	    res.add("WAutoColor");
	    res.add("WShowHumPr");
	    res.add("BatColor");
	    res.add("MoonColor");
		res.add("ConCol");
		res.add("MesCol");
		res.add("DNDCol");
		res.add("AlCol");
		res.add("WUpdInt");
		res.add("PrU");
		res.add("WU");
		res.add("T1TZ");
		res.add("F0");
		res.add("C0");
		res.add("F1");
		res.add("C1");
		res.add("F2");
		res.add("C2");
		res.add("F3");
		res.add("C3");
		res.add("F4");
		res.add("C4");
		res.add("F5");
		res.add("C5");
		return res;
	}
	
}