using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Graphics;

//*****************************************************************************
class GeneralMenu extends WatchUi.Menu2{

	function initialize() {
		
		Menu2.initialize({:title=>Application.loadResource(Rez.Strings.SettingsMenu)});
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
                Application.loadResource(Rez.Strings.keyOW),
                Application.Properties.getValue("keyOW"),
                :keyOW,
                {}
            )
        );

        addItem(
            new MenuItem(
                Application.loadResource(Rez.Strings.SettingsGlobal),
                null,
                STORAGE_KEY_GLOBAL,
                {}
            )
        );
        
        addItem(
            new MenuItem(
                Application.loadResource(Rez.Strings.SettingsDay),
                null,
                STORAGE_KEY_DAY,
                {}
            )
        );
        
        addItem(
            new MenuItem(
                Application.loadResource(Rez.Strings.SettingsNight),
                null,
                STORAGE_KEY_NIGHT,
                {}
            )
        );
	}
    
    function onSelect(item){
    	var id = item.getId();
    	if (id == :autoSwitch){
    		Application.Properties.setValue("SwitchDayNight", item.isEnabled());
    	}else if(id == :keyOW){
    		if ( WatchUi has :TextPicker){
    			WatchUi.pushView(new WatchUi.TextPicker(item.getSubLabel()), new TextPickerDelegateMenuSettings(item), WatchUi.SLIDE_IMMEDIATE);
    		}
    	}else if(id == STORAGE_KEY_GLOBAL){
    		var menu = new MenuEditSettings(id, Application.loadResource(Rez.Strings.SettingsGlobal));
    		WatchUi.pushView(menu, new MenuDelegate(menu), WatchUi.SLIDE_IMMEDIATE);
    	}else if(id == STORAGE_KEY_DAY){
    		var menu = new MenuEditSettings(id, Application.loadResource(Rez.Strings.SettingsDay));
    		WatchUi.pushView(menu, new MenuDelegate(menu), WatchUi.SLIDE_IMMEDIATE);
		}else if(id == STORAGE_KEY_NIGHT){
    		var menu = new MenuEditSettings(id, Application.loadResource(Rez.Strings.SettingsNight));
    		WatchUi.pushView(menu, new MenuDelegate(menu), WatchUi.SLIDE_IMMEDIATE);
    	}
    }
    
    function onShow(){
		memoryCache = null;
		fonts = null;
    }
}

//*****************************************************************************
class MenuEditSettings extends WatchUi.Menu2{
	
	var idKey;
	private var dictKeys;
	
	function initialize(idKey, title) {
		self.idKey = idKey;
		dictKeys = StorageSettings.getStorageSettingsDictonary(idKey);
		
		Menu2.initialize({:title=>title});
		
		var allProp = StorageSettings.getFullPropertiesKeys();
		
		var dictOfListsTypes = {};
		
		for (var i = 0; i < allProp.size(); i++){
			var value = dictKeys[allProp[i][:title].toString()];
			if (allProp[i][:type] == :bool){
		        addItem(
		            new ToggleMenuItem(
		                Application.loadResource(Rez.Strings[allProp[i][:title]]),
		                null,
		                allProp[i][:title].toString(),
		                value,
		                {}
		            )
		        );
			}else if (allProp[i][:type] == :dateFormat){
		        addItem(
		            new MenuItemSettings(
		                Application.loadResource(Rez.Strings[allProp[i][:title]]),
		                value.toString(),
		                allProp[i][:title].toString(),
		                {},
		                allProp[i][:type],
		                self
		            )
		        );
			}else if (allProp[i][:type] == :number){
		        addItem(
		            new MenuItemSettings(
		                Application.loadResource(Rez.Strings[allProp[i][:title]]),
		                value.toString(),
		                allProp[i][:title].toString(),
		                {},
		                allProp[i][:type],
		                self
		            )
		        );
			}else{
				if (dictOfListsTypes[allProp[i][:type]] == null){
					dictOfListsTypes[allProp[i][:type]] = new Lang.Method(StorageSettings,allProp[i][:type]).invoke();
				}
		        addItem(
		            new MenuItemSettings(
		                Application.loadResource(Rez.Strings[allProp[i][:title]]),
		                Application.loadResource(Rez.Strings[dictOfListsTypes[allProp[i][:type]][value]]),
		                allProp[i][:title].toString(),
		                {},
		                allProp[i][:type],
		                self
		            )
		        );
	        }
		}
	}
    
    
    function onSelect(item){
    	var id = item.getId();
    	if (item instanceof WatchUi.ToggleMenuItem){
    		dictKeys[id] = 	item.isEnabled();
    	}else if(item instanceof MenuItemSettings){
    		if (id.equals("WUpdInt")){
    			if ( WatchUi has :Picker){
	    			var pattern = [
	    				new NumberFactory(10,120,5),    				
	    			];
	    			var delegate = new PickDelegate(item);
	    			WatchUi.pushView(new NumberPicker(item.getLabel(), pattern, [0]), delegate, WatchUi.SLIDE_IMMEDIATE);
    			}
    		}else if (id.equals("T1TZ")){
    			if ( WatchUi has :Picker){
	    			var pattern = [
	    				new NumberFactory(-720,840,5),    				
	    			];
	    			var delegate = new PickDelegate(item);
	    			WatchUi.pushView(new NumberPicker(item.getLabel(), pattern, [144]), delegate, WatchUi.SLIDE_IMMEDIATE);
    			}
    		}else if (id.equals("DF")){
    			if ( WatchUi has :TextPicker){
	    			var picker = new WatchUi.TextPicker(item.getSubLabel());
	    			WatchUi.pushView(picker, new TextPickerDelegate(item), WatchUi.SLIDE_IMMEDIATE);
    			}
    		}else{
    			var menu = new MenuSelectValue(item);
    			WatchUi.pushView(menu, new MenuDelegate(menu), WatchUi.SLIDE_IMMEDIATE);
    		}
    	}
    }
    
    function setNewValue(id, value){
    	//System.println("setNewValue "+dictKeys[id]+" = "+value);
    	dictKeys[id] = value;
    }
    
    function saveValues(){
    	Application.Storage.setValue(idKey, dictKeys);
    }
}

//*****************************************************************************
class MenuItemSettings extends WatchUi.MenuItem{
	
	var type;
	var parent; 
	
	function initialize(label, subLabel, identifier, options, type, parent){
		self.type = type;
		self.parent = parent;
		MenuItem.initialize(label, subLabel, identifier, options);
	}
	
	function setNewValue(value, subLabelSymbol){
		setSubLabel(Rez.Strings[subLabelSymbol]);
		parent.setNewValue(getId(), value);
	}
}

//*****************************************************************************
class MenuSelectValue extends WatchUi.Menu2{
	
	private var parentItem;
	private var  dictKeys; 
	
	function initialize(parentItem) {
		self.parentItem = parentItem;
		Menu2.initialize({:title=>parentItem.getLabel()});
		
		dictKeys = new Lang.Method(StorageSettings, parentItem.type).invoke();
		var arrKeys = dictKeys.keys();
		for (var i = 0; i < arrKeys.size(); i++){
	        addItem(
	            new MenuItem(
	                Application.loadResource(Rez.Strings[dictKeys[arrKeys[i]]]),
	                null,
	                arrKeys[i],
	                {}
	            )
	        );
		}
	}

    function onSelect(item){
    	var id = item.getId();
    	parentItem.setNewValue(id, dictKeys[id]);
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
	
	function onBack(){
		if (menu instanceof MenuEditSettings){
			menu.saveValues();
		}else if(menu instanceof GeneralMenu){
			System.exit();
		}
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
		menu = null;
		self = null;
	}
}

