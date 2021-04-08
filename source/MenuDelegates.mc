using Toybox.WatchUi;
using Toybox.System;
using Toybox.Application;

//*****************************************************************************
class GeneralMenuDelegate extends WatchUi.Menu2InputDelegate{

	var menu;

	function initialize(menu) {
		self.menu = menu;
		prepareMenu();
		Menu2InputDelegate.initialize();
	}
	
	private function prepareMenu(){
		prepareItem(:SwitchDayNight, null);
		prepareItem(:keyOW, null);
		prepareItem(:DF, null);
		prepareItem(:T1TZ, null);
		prepareItem(:PrU, getSubMenu(:PrU));
		prepareItem(:WU, getSubMenu(:WU));
		prepareItem(:MilFt, null);
		prepareItem(:HFt01, null);
	}

	function getLabelByIdString(subMenu, searchString){
		var i=0;
		var item = subMenu.getItem(i);
		
		while (item != null){
			if (item.getId().toString().equals(searchString)){
				return item.getLabel();
			}
			i++;
			item = subMenu.getItem(i);
		}		 
	}
	
	function prepareItem(itemId, subMenu){
		var itemIdx = menu.findItemById(itemId);
		if (itemIdx > -1){
			var item = menu.getItem(itemIdx);
			var value = Application.Properties.getValue(itemId.toString());
			if (itemIsTogle(itemId)){
				item.setEnabled(value);
			}else{
				if (subMenu == null){
					item.setSubLabel(value.toString());
				}else{
//					System.println(itemId.toString());
//					System.println("id"+value.toString());
					item.setSubLabel(getLabelByIdString(subMenu, "id"+value.toString()));
				}
			}
		}
	}
	
	hidden function itemIsTogle(itemId){
		return itemId == :SwitchDayNight || itemId == :MilFt || itemId == :HFt01 || itemId == :WShowWindWidget || itemId == :ShowTopFields;
	}

	function getSubMenu(itemId){
		var res = null;
		if (itemId == :PrU){
			res = new Rez.Menus.PrUressureUnitMenu();
		}else if (itemId == :WU){
			res = new Rez.Menus.WUindSpeedUnitMenu();
		}else if (itemId == :WType){
			res = new Rez.Menus.WidgetTypeMenu();
		}else if (itemId == :Theme){
			res = new Rez.Menus.ThemeMenu();
		}else if (itemId == :SF0 || itemId == :SF1 || itemId == :SF2 || itemId == :SF3 || itemId == :SF4 || itemId == :SF5){
			res = new Rez.Menus.StatusFieldMenu();
		}else if ((itemId == :F0 || itemId == :F1 || itemId == :F2 || itemId == :F3 || itemId == :F4 || itemId == :F5 || itemId == :F6 || itemId == :F7)){
			res = new Rez.Menus.FieldMenu();
		}
		return res;
	}
	
	function onSelect(item){
		var itemId = item.getId();
		if (itemIsTogle(itemId)){
			Application.Properties.setValue(itemId.toString(), item.isEnabled());
		}else if (itemId == :keyOW){
		}else if (itemId == :DF){
		}else if (itemId == :T1TZ){
		}else if (itemId == :DF){
		}else if (itemId == :PrU || itemId == :WU){
			var subMenu = getSubMenu(itemId);
			subMenu.setTitle(item.getLabel());
			WatchUi.pushView(subMenu, new ListMenuDelegate(item, ""), WatchUi.SLIDE_IMMEDIATE);
		}else{
			var menu = new Rez.Menus.PropertiesMenu();
			menu.setTitle(item.getLabel());
			WatchUi.pushView(menu, new PropertiesMenuDelegate(menu, itemId.toString()), WatchUi.SLIDE_IMMEDIATE);				
		} 
	}
}

//*****************************************************************************
class PropertiesMenuDelegate extends GeneralMenuDelegate{

	var mode;

	function initialize(menu, mode) {
		self.mode = mode;
		self.menu = menu;
		prepareMenu();
		Menu2InputDelegate.initialize();
	}
	
	private function prepareMenu(){
		var i=0;
		var item = menu.getItem(i);
		while (item != null){
			var itemId = item.getId(); 
			var itemIdString = itemId.toString();
			var value = Application.Properties.getValue(mode+itemIdString);
			if (itemIsTogle(itemId)){
				item.setEnabled(value);
			}else {
				var subMenu = getSubMenu(itemId);
				if (subMenu != null){
//					System.println(mode+itemIdString);
//					System.println(value);
					item.setSubLabel(getLabelByIdString(subMenu, "id"+value.toString()));
				}else{
					item.setSubLabel(value.toString());
				}
			}
			i++;
			item = menu.getItem(i);
		}		 
	}
	
	function onSelect(item){
		var itemId = item.getId();
		var itemIdString = itemId.toString();
		if (itemIsTogle(itemId)){
			Application.Properties.setValue(mode+itemIdString, item.isEnabled());
		}else{
			var subMenu = getSubMenu(itemId);
			if (subMenu != null){
				subMenu.setTitle(item.getLabel());
				WatchUi.pushView(subMenu, new ListMenuDelegate(item, mode), WatchUi.SLIDE_IMMEDIATE);
			}
		}
	}
	
}

//*****************************************************************************
class ListMenuDelegate extends  GeneralMenuDelegate{

	var parentItem;
	var mode;
	
	function initialize(parentItem, mode) {
		self.parentItem = parentItem;
		self.mode = mode;
		Menu2InputDelegate.initialize();
	}
	
	function onSelect(item){
		var value = item.getId().toString();
		var key = mode+parentItem.getId().toString();
		value = value.substring(2, value.length()).toNumber();
//		System.println("Set "+key+" "+value);
		Application.Properties.setValue(key, value);
		parentItem.setSubLabel(item.getLabel());
		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
	}
	
}

