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
	
	function getSubMenu(itemId){
		var res = null;
		if (itemId == :PrU){
			res = new Rez.Menus.PrUressureUnitMenu();
		}else if (itemId == :WU){
			res = new Rez.Menus.WUindSpeedUnitMenu();
		}
		return res;
	}

	function prepareMenu(){
		prepareItem(:SwitchDayNight, null);
		prepareItem(:keyOW, null);
		prepareItem(:DF, null);
		prepareItem(:T1TZ, null);
		prepareItem(:PrU, getSubMenu(:PrU));
		prepareItem(:WU, getSubMenu(:WU));
		prepareItem(:MilFt, null);
		prepareItem(:HFt01, null);
	}
	
	function initialize(menu) {
		Menu2InputDelegate.initialize();
		self.menu = menu;
		//prepareMenu();
	}
	
	function onSelect(item){
		var itemId = item.getId();
		var itemIdString = itemId.toString();
		if (item instanceof WatchUi.ToggleMenuItem){
			Application.Properties.setValue(itemIdString, item.isEnabled());
		}else{
			if (itemId == :keyOW){
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
				WatchUi.pushView(menu, new PropertiesMenuDelegate(menu, itemIdString), WatchUi.SLIDE_IMMEDIATE);				
			} 
		}
	}
}

//*****************************************************************************
class PropertiesMenuDelegate extends GeneralMenuDelegate{

	var mode;
	
	function getSubMenu(itemId){
		var res = null;
		if (itemId == :WType){
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
	
	function prepareMenu(){
		var i=0;
		var item = menu.getItem(i);
		while (item != null){

			var value = Application.Properties.getValue(mode+item.getId().toString());
			if (item instanceof WatchUi.ToggleMenuItem){
				item.setEnabled(value);
			}else if (item instanceof WatchUi.MenuItem){
				var itemId = item.getId();
				var itemIdString = itemId.toString();
				var subMenu = getSubMenu(itemId);
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
		var itemId = item.getId();
		var itemIdString = itemId.toString();
		if (item instanceof WatchUi.ToggleMenuItem){
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

