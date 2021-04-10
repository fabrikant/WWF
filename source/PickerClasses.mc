using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class StringPicker extends WatchUi.Picker {

    hidden var mCharacterSet;
    hidden var mTitleText;
    hidden var mFactory;
    var parentItem;

	
    function initialize(parentItem, mCharacterSet) {
    	
    	self.parentItem = parentItem;
    	self.mCharacterSet = mCharacterSet;
        mFactory = new CharacterFactory(mCharacterSet, {:addOk=>true});
        mTitleText = parentItem.getLabel();
		
        var string = Application.Properties.getValue(parentItem.propName).toString();
        var defaults = null;
 
        if(string != null) {
            mTitleText = string;
            defaults = [mFactory.getIndex(string.substring(string.length()-1, string.length()))];
        }

        mTitle = new WatchUi.Text({:text=>mTitleText, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, :color=>Graphics.COLOR_WHITE});
		var confirm = new WatchUi.Text({:text=>"",  :color=>Graphics.COLOR_WHITE});
		 
        Picker.initialize({:title=>mTitle, :pattern=>[mFactory], :defaults=>defaults, :confirm => confirm});
    }

    function onUpdate(dc) {
    	dc.setClip(0, 0, dc.getWidth(), dc.getHeight());
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }

    function addCharacter(character) {
        mTitleText += character;
        mTitle.setText(mTitleText);
    }

    function removeCharacter() {
        mTitleText = mTitleText.substring(0, mTitleText.length() - 1);

        if(0 == mTitleText.length()) {
            mTitle.setText(parentItem.getLabel());
        }
        else {
            mTitle.setText(mTitleText);
        }
    }

    function getTitle() {
        return mTitleText.toString();
    }

    function getTitleLength() {
        return mTitleText.length();
    }

    function isDone(value) {
        return mFactory.isDone(value);
    }
}

class StringPickerDelegate extends WatchUi.PickerDelegate {
    
    hidden var mPicker;

    function initialize(picker) {
        PickerDelegate.initialize();
        mPicker = picker;
    }

    function onCancel() {
        if(0 == mPicker.getTitleLength()) {
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
        else {
            mPicker.removeCharacter();
        }
    }

    function onAccept(values) {
        if(!mPicker.isDone(values[0])) {
            mPicker.addCharacter(values[0]);
        }else{
         	var value = mPicker.getTitle();
        	var propName = mPicker.parentItem.propName;
        	var oldValue = Application.Properties.getValue(propName);
        	if (oldValue instanceof Lang.Number){
        		Application.Properties.setValue(propName, value.toNumber());
        	}else{
        		Application.Properties.setValue(propName, value);
        	}
        	mPicker.parentItem.setSubLabel(value);
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
    }

}

class CharacterFactory extends WatchUi.PickerFactory {
    hidden var mCharacterSet;
    hidden var mAddOk;
    const DONE = -1;

    function initialize(characterSet, options) {
        PickerFactory.initialize();
        mCharacterSet = characterSet;
        mAddOk = (null != options) and (options.get(:addOk) == true);
    }

    function getIndex(value) {
        var index = mCharacterSet.find(value);
        return index;
    }

    function getSize() {
        return mCharacterSet.length() + ( mAddOk ? 1 : 0 );
    }

    function getValue(index) {
        if(index == mCharacterSet.length()) {
            return DONE;
        }

        return mCharacterSet.substring(index, index+1);
    }

    function getDrawable(index, selected) {
        if(index == mCharacterSet.length()) {
            return new WatchUi.Text( {:text=>"OK", :color=>Graphics.COLOR_WHITE, :font=>Graphics.FONT_LARGE, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER } );
        }

        return new WatchUi.Text( { :text=>getValue(index), :color=>Graphics.COLOR_WHITE, :font=> Graphics.FONT_LARGE, :locX =>WatchUi.LAYOUT_HALIGN_CENTER, :locY=>WatchUi.LAYOUT_VALIGN_CENTER } );
    }

    function isDone(value) {
        return mAddOk and (value == DONE);
    }
}
