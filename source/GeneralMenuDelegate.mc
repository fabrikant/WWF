using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;

class GeneralMenuDelegate extends WatchUi.Menu2InputDelegate{

	var menu;
	
	hidden function getLabelByIdString(subMenu, idString){
		var i=0;
		var item = subMenu.getItem(i);
		
		while (item != null){
			System.println(item.getId().toString());
			if (item.getId().toString().equals(idString)){
				return item.getLabel();
			}
			i++;
			item = subMenu.getItem(i);
		}		 
	}
	
	private function prepareItem(itemId, subMenu){
		var itemIdx = menu.findItemById(itemId);
		if (itemIdx > -1){
			var item = menu.getItem(itemIdx);
			var value = Application.Properties.getValue(itemId.toString());
			if (item instanceof WatchUi.ToggleMenuItem){
				item.setEnabled(value);
			}else if (item instanceof WatchUi.MenuItem){
				
				if (subMenu == null){
					item.setSubLabel(value.toString());
				}else{
					//System.println(" "+itemId.toString()+" "+subMenu+" "+(subMenu==null));
					item.setSubLabel(getLabelByIdString(subMenu, item.getId().toString()+value.toString()));
				}
			}
		}
	}
	
	function prepareMenu(){
		prepareItem(:SwitchDayNight, null);
		prepareItem(:keyOW, null);
		prepareItem(:DF, null);
		prepareItem(:T1TZ, null);
		prepareItem(:PrU, new Rez.Menus.PrUressureUnitMenu());
		prepareItem(:WU, new Rez.Menus.WUindSpeedUnitMenu());
	}
	
	function initialize(menu) {
		fonts = null;
		memoryCache = null;
		self.menu = menu;
		prepareMenu();
		Menu2InputDelegate.initialize();
	}
	
	function onSelect(item){
		var itemIdString = item.getId().toString();
		if (item instanceof WatchUi.ToggleMenuItem){
			Application.Properties.setValue(itemIdString, item.isEnabled());
		}else{
			if (itemIdString.equals("keyOW")){
			}else if (itemIdString.equals("DF")){
			}else if (itemIdString.equals("keyOW")){
			}else if (itemIdString.equals("PrU")){
				var subMenu = new Rez.Menus.PrUressureUnitMenu();
				subMenu.setTitle(item.getLabel());
				WatchUi.pushView(subMenu, new ListMenuDelegate(item), WatchUi.SLIDE_IMMEDIATE);
			}else if (itemIdString.equals("WU")){
				var subMenu = new Rez.Menus.WUindSpeedUnitMenu();
				subMenu.setTitle(item.getLabel());
				WatchUi.pushView(subMenu, new ListMenuDelegate(item), WatchUi.SLIDE_IMMEDIATE);
			}else{
				var menu = new Rez.Menus.PropertiesMenu();
				menu.setTitle(item.getLabel());
				WatchUi.pushView(menu, new PropertiesMenuDelegate(menu, itemIdString), WatchUi.SLIDE_IMMEDIATE);				
			} 
		}
	}
	
//	function onBack(){
//		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
//		WatchUi.requestUpdate();
//		if (menu instanceof MenuEditSettings){
//			menu.saveValues();
//		}else if(menu instanceof GeneralMenu){
//			globalStringsDictonary = null;
//			//System.exit();
//		}
//		
//		menu = null;
//		self = null;
//	}
}

class PropertiesMenuDelegate extends GeneralMenuDelegate{

	var mode;
	
	function prepareMenu(){
		var i=0;
		var item = menu.getItem(i);
		while (item != null){
			var value = Application.Properties.getValue(mode+item.getId().toString());
			if (item instanceof WatchUi.ToggleMenuItem){
				item.setEnabled(value);
			}else if (item instanceof WatchUi.MenuItem){
				item.setSubLabel(value.toString());
			}
			i++;
			item = menu.getItem(i);
		}		 
	}
	
	function initialize(menu, mode) {
		self.mode = mode;
		GeneralMenuDelegate.initialize(menu);
	}
	
	function onSelect(item){
		var itemIdString = item.getId().toString();
		if (item instanceof WatchUi.ToggleMenuItem){
			Application.Properties.setValue(mode+itemIdString, item.isEnabled());
		}else{
			if (itemIdString.equals("WType")){
				var subMenu = new Rez.Menus.WidgetTypeMenu();
				subMenu.setTitle(item.getLabel());
				WatchUi.pushView(subMenu, new ListMenuDelegate(item), WatchUi.SLIDE_IMMEDIATE);
			}else if (itemIdString.equals("")){
			}else if (itemIdString.equals("")){
			}else if (itemIdString.equals("")){
			}else{
//				var menu = new Rez.Menus.PropertiesMenu();
//				WatchUi.pushView(menu, new PropertiesMenuDelegate(menu, itemIdString), WatchUi.SLIDE_IMMEDIATE);				
			} 
		}
	}
	
}

class ListMenuDelegate extends  WatchUi.Menu2InputDelegate{

	var parentItem;
	
	function initialize(parentItem) {
		self.parentItem = parentItem;
		Menu2InputDelegate.initialize();
	}
	
	function onSelect(item){
		
		var key = parentItem.getId().toString();
		var value = item.getId().toString();
		value = value.substring(key.length(), value.length()).toNumber();
		
		parentItem.setSubLabel(item.getLabel());
		Application.Properties.setValue(key, value.toNumber());
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);

		System.println(parentItem.getId().toString());
		System.println(item.getId().toString());
		System.println(value);
	}
	
}

