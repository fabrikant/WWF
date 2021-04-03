using Toybox.WatchUi;
using Toybox.System;

class GeneralMenuDelegate extends WatchUi.Menu2InputDelegate{

	var menu;
	
	function initialize(menu) {
		self.menu = menu;
		Menu2InputDelegate.initialize();
		System.println( menu.getItem(2));
	}
	
	function onSelect(item){
		//menu.onSelect(item);
		System.println(item);
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

