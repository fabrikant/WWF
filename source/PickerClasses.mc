//using Toybox.WatchUi;
//using Toybox.Graphics;
//using Toybox.System;
//
////*****************************************************************************
//class TextPickerDelegate extends WatchUi.TextPickerDelegate {
//
//	hidden var item;
//	
//    function initialize(item) {
//    	self.item = item;
//        TextPickerDelegate.initialize();
//    }
//
//    function onTextEntered(text, changed) {
//		if (changed){
//			item.setSubLabel(text);
//			item.parent.setNewValue(item.getId(), text);
//		}
//    }
//}
//
////*****************************************************************************
//class TextPickerDelegateMenuSettings extends WatchUi.TextPickerDelegate {
//
//	hidden var item;
//	
//    function initialize(item) {
//    	self.item = item;
//        TextPickerDelegate.initialize();
//    }
//
//    function onTextEntered(text, changed) {
//		if (changed){
//			item.setSubLabel(text);
//			Application.Properties.setValue(item.getId().toString(), text);
//		}
//    }
//}
//
////*****************************************************************************
//class NumberPicker extends WatchUi.Picker{
//
//	function initialize(title, pattern, defaults){
//	
//		Picker.initialize({
//			:title => getTextDrawable(title),
//			:pattern => pattern,
//			:defaults => defaults,
////			:nextArrow => getTextDrawable("next"),
////			:previousArrow => getTextDrawable("prev"),
////			:confirm => getTextDrawable("OK"),
//		});
//	}
//	
//	function getTextDrawable(text){
//		return new WatchUi.Text({
//            :text=> text,
//            :color=>Graphics.COLOR_WHITE,
//            :backgroundColor =>Graphics.COLOR_BLACK,
//            :font=>Graphics.FONT_SYSTEM_MEDIUM,
//       	});
//	}
//	
//	
//	function onUpdate(dc){
//        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
//        dc.clear();
//		Picker.onUpdate(dc);
//	}
//}
//
//class NumberFactory extends WatchUi.PickerFactory{
//
//    hidden var start;
//    hidden var stop;
//    hidden var increment;
//
//    function initialize(start, stop, increment) {
//        self.start = start;
//        self.stop = stop;
//        self.increment = increment;
//        PickerFactory.initialize();
//    }
//
//
//	function getDrawable(item, isSelected){
//		return new WatchUi.Text({
//            :text=> getValue(item).toString(),
//            :color=>Graphics.COLOR_WHITE,
//            :backgroundColor =>Graphics.COLOR_BLACK,
//            :font=>Graphics.FONT_SYSTEM_MEDIUM,
//       	});
//	}
//	
//	function getSize(){
//		return stop-start+1;
//	}
//	
//	function getValue(item){
//		return start + item*increment;
//	}	
//
//}
//
//class PickDelegate extends WatchUi.PickerDelegate{
//	
//	hidden var item;
//	
//	function initialize(item){
//		self.item= item;
//		PickerDelegate.initialize();
//	}
//	
//	function onAccept(value){
//		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
//		item.setSubLabel(value[0].toString());
//		item.parent.setNewValue(item.getId(), value[0]);
//	}
//	
//	function onCancel(){
//		WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
//	}
//}
//
