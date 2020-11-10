using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;

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
                Application.loadResource(Rez.Strings.SettingsLoad),
                null,
                :load,
                {}
            )
        );
        
        addItem(
            new MenuItem(
                Application.loadResource(Rez.Strings.SettingsRemove),
                null,
                :remove,
                {}
            )
        );
	}
	
    function saveCurrentSettings(item){
    	
    	var moment = Time.now();
    	var idsSettings = Application.Storage.getValue(STORAGE_KEY_SETTINGS);
    	if (idsSettings == null){
    		idsSettings = [];
    	}
    	
    	var propKeys = memoryCache.getPropertiesKeys();
    	var settings = {};
    	for (var i = 0; i < propKeys.size(); i++){
			settings.put(propKeys[i], Application.Properties.getValue(propKeys[i]));    		
    	}
    	
    	var currentSettingsId = moment.value();
    	Application.Storage.setValue(currentSettingsId, settings);
    	idsSettings.add(currentSettingsId); 
    	Application.Storage.setValue(STORAGE_KEY_SETTINGS, idsSettings);
    	item.setSubLabel(Tools.momentToDateTimeString(moment));
    }
    
    function onSelect(item){
    	var id = item.getId();
    	if (id == :save){
    		saveCurrentSettings(item);
    	}else if(id == :load){
    		var listMenu = new MenuSettingsList(id, Application.loadResource(Rez.Strings.SettingsLoadMenu));
    		WatchUi.pushView(listMenu, new MenuDelegate(listMenu), WatchUi.SLIDE_IMMEDIATE);
    	}else if(id == :remove){
    		var listMenu = new MenuSettingsList(id, Application.loadResource(Rez.Strings.SettingsRemoveMenu));
    		WatchUi.pushView(listMenu, new MenuDelegate(listMenu), WatchUi.SLIDE_IMMEDIATE);
    	}
    }
}

class MenuSettingsList extends WatchUi.Menu2{
	
	protected var id; 
	
	function initialize(id, title) {
		self.id = id;
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

	function loadSettings(currentSettingsId){
		
		var settings = Application.Storage.getValue(currentSettingsId);
		if (settings == null){
			return;
		}
		
		var propKeys = memoryCache.getPropertiesKeys();
		for (var i = 0; i < propKeys.size(); i++){
			var value = settings[propKeys[i]];
			if (value != null){
				Application.Properties.setValue(propKeys[i], value);
			}			
		}
		memoryCache.reload();			
	}

	function removeSettings(currentSettingsId){
		Application.Storage.deleteValue(currentSettingsId);
		var idsSettings = Application.Storage.getValue(STORAGE_KEY_SETTINGS);
		if (idsSettings != null){
			if(idsSettings.remove(currentSettingsId)){
				Application.Storage.setValue(STORAGE_KEY_SETTINGS, idsSettings);				
			}
		}
	}
			
	function onSelect(item){
		var itemId = item.getId();
		if (itemId != :empty){
			if(id == :load){
				loadSettings(itemId);
	    	}else if(id == :remove){
	    		removeSettings(itemId);
	    	}
    	}	
    	WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
   
} 

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