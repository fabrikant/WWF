using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;

//*****************************************************************************
class GeneralMenuDelegate extends WatchUi.Menu2InputDelegate{

	var menu;
	
	hidden function getLabelByIdString(subMenu, idString){
		var i=0;
		var item = subMenu.getItem(i);
		
		while (item != null){
			if (item.getId().toString().equals("id"+idString)){
				return item.getLabel();
			}
			i++;
			item = subMenu.getItem(i);
		}		 
	}
	
	hidden function prepareItem(itemId, subMenu){
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
					item.setSubLabel(getLabelByIdString(subMenu, value.toString()));
				}
			}
		}
	}
	
	function getSubMenu(itemIdString){
		var res = null;
		if (itemIdString.equals("PrU")){
			res = new Rez.Menus.PrUressureUnitMenu();
		}else if (itemIdString.equals("WU")){
			res = new Rez.Menus.WUindSpeedUnitMenu();
		}
		return res;
	}

	function prepareMenu(){
		prepareItem(:SwitchDayNight, null);
		prepareItem(:keyOW, null);
		prepareItem(:DF, null);
		prepareItem(:T1TZ, null);
		prepareItem(:PrU, new Rez.Menus.PrUressureUnitMenu());
		prepareItem(:WU, new Rez.Menus.WUindSpeedUnitMenu());
		prepareItem(:MilFt, null);
		prepareItem(:HFt01, null);
	}
	
	function initialize(menu) {
		Menu2InputDelegate.initialize();
		self.menu = menu;
		//prepareMenu();
	}
	
	function onSelect(item){
		var itemIdString = item.getId().toString();
		if (item instanceof WatchUi.ToggleMenuItem){
			Application.Properties.setValue(itemIdString, item.isEnabled());
		}else{
			if (itemIdString.equals("keyOW")){
			}else if (itemIdString.equals("DF")){
			}else if (itemIdString.equals("T1TZ")){
			}else if (itemIdString.equals("DF")){
			}else if (itemIdString.equals("PrU") || itemIdString.equals("WU")){
				var subMenu = getSubMenu(itemIdString);
				subMenu.setTitle(item.getLabel());
				WatchUi.pushView(subMenu, new ListMenuDelegate(item, ""), WatchUi.SLIDE_IMMEDIATE);
			}else{
				var menu = new Rez.Menus.PropertiesMenu();
				menu.setTitle(item.getLabel());
				WatchUi.pushView(menu, new PropertiesMenuDelegate(menu, itemIdString), WatchUi.SLIDE_IMMEDIATE);				
			} 
		}
	}
}

//*****************************************************************************
class PropertiesMenuDelegate extends GeneralMenuDelegate{

	var mode;
	
	function getSubMenu(itemIdString){
		var res = null;
		if (itemIdString.equals("WType")){
			res = new Rez.Menus.WidgetTypeMenu();
		}else if (itemIdString.equals("Theme")){
			res = new Rez.Menus.ThemeMenu();
		}else if (itemIdString.substring(0, 2).equals("SF")){
			res = new Rez.Menus.StatusFieldMenu();
		}else if (itemIdString.substring(0, 1).equals("F")){
			res = new Rez.Menus.FieldMenu();
		}
		return res;
	}
	
	function prepareMenu(){
		var i=0;
		var item = menu.getItem(i);
		while (item != null){

			var value = Application.Properties.getValue(mode+item.getId().toString());
			if (item instanceof WatchUi.ToggleMenuItem){
				item.setEnabled(value);
			}else if (item instanceof WatchUi.MenuItem){
				var itemIdString = item.getId().toString();
				var subMenu = getSubMenu(itemIdString);
				if (subMenu != null){
					item.setSubLabel(getLabelByIdString(subMenu, value));
				}else{
					item.setSubLabel(value.toString());
				}
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
			var subMenu = getSubMenu(itemIdString);
			if (subMenu != null){
				subMenu.setTitle(item.getLabel());
				WatchUi.pushView(subMenu, new ListMenuDelegate(item, mode), WatchUi.SLIDE_IMMEDIATE);
			}
		}
	}
	
}

//*****************************************************************************
class ListMenuDelegate extends  WatchUi.Menu2InputDelegate{

	var parentItem;
	var mode;
	
	function initialize(parentItem, mode) {
		self.parentItem = parentItem;
		self.mode = mode;
		Menu2InputDelegate.initialize();
	}
	
	function onSelect(item){
		
		var key = mode+parentItem.getId().toString();
		if (item instanceof WatchUi.ToggleMenuItem){
			Application.Properties.setValue(key, item.isEnabled());
		}else{
			var value = item.getId().toString();
			value = value.substring(2, value.length()).toNumber();
			parentItem.setSubLabel(item.getLabel());
			Application.Properties.setValue(key, value.toNumber());
			WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
		}
	}
	
}

