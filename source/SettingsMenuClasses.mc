using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;


//*****************************************************************************
class MenuEditSettings extends WatchUi.Menu2{
	
	var idKey;
	private var dictKeys;
	
	function initialize(idKey, title) {
		self.idKey = idKey;
		dictKeys = Application.Storage.getValue(idKey);
		
		Menu2.initialize({:title=>title});
		
		var allProp = StorageSettings.getFullPropertiesKeys();
		
		var dictOfListsTypes = {};//StorageSettings.color();
		
		for (var i = 0; i < allProp.size(); i++){
			var value = null;
			if (dictKeys != null){
				value = dictKeys[allProp[i][:title].toString()];
			}
			if (value == null){
				value = Application.Properties.getValue(allProp[i][:title].toString());
			}
			
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
			}else if (allProp[i][:type] == :color || allProp[i][:type] == :widgetType || allProp[i][:type] == :statusField || allProp[i][:type] == :field){
			
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
		
		if (dictKeys == null){
			dictKeys = {};
		}
	}
    
    function onSelect(item){
    	var id = item.getId();
    	//System.println("onSelect "+id);
    	if (item instanceof WatchUi.ToggleMenuItem){
    		//System.println(item.isEnabled());
    		dictKeys[id] = 	item.isEnabled();
    	}else if(item instanceof MenuItemSettings){
    		var menu = new MenuSelectValue(item);
    		WatchUi.pushView(menu, new MenuDelegate(menu), WatchUi.SLIDE_IMMEDIATE);
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
	private var parent; 
	
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
		}
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	}
}
