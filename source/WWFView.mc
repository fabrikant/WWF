using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;

var memoryCach;
var fonts;

enum{
	HR,
	STEPS,
	PRESSURE,
	TEMPERATURE,
	CALORIES,
	DISTANCE,
	FLOOR,
	ELEVATION,
	SUN_EVENT,
	SUNRISE_EVENT,
	SUNSET_EVENT,
	TIME1,
	EMPTY,
	PICTURE = 1000
}

const FIELDS_COUNT = 6;

class WWFView extends WatchUi.WatchFace {

	var fields = {};

    function initialize() {

        WatchFace.initialize();
        memoryCach = new MemoryCach();
        fonts = {};
        fonts[:time] = Application.loadResource(Rez.Fonts.big);
        fonts[:small] = Application.loadResource(Rez.Fonts.small);
        fonts[:picture] = Application.loadResource(Rez.Fonts.images);
    }

    // Load your resources here
    function onLayout(dc) {

		///////////////////////////////////////////////////////////////////////
		//TIME
		var font = fonts[:time];
		var w = dc.getTextWidthInPixels("00:00", font);
		var h = Graphics.getFontHeight(font)-Graphics.getFontDescent(font);
		var x = (System.getDeviceSettings().screenWidth - w)/2;
		var y = (System.getDeviceSettings().screenHeight - h)/2;

        fields[:time] = new SimpleField(
    		{
    			:x => x,
    			:y => y,
    			:h => h,
    			:w => w,
    			:type => :time,
    			:id => :time,
    			:fontId => :time,
    			:justify => Graphics.TEXT_JUSTIFY_CENTER
    		}
    	);

		///////////////////////////////////////////////////////////////////////
		//DATE
    	font = fonts[:small];
    	h = Graphics.getFontHeight(font)-Graphics.getFontDescent(font);
    	y = y - h;
        fields[:date] = new SimpleField(
    		{
    			:x => x,
    			:y => y,
    			:h => h,
    			:w => w,
    			:type => :date,
    			:id => :date,
    			:fontId => :small,
    			:justify => Graphics.TEXT_JUSTIFY_CENTER
    		}
    	);

		///////////////////////////////////////////////////////////////////////
		//DATA FIELDS
		h = 22;
		y = fields[:time].y+fields[:time].h;
		x = x - h;

		var wPicture = h;
		var wText = (System.getDeviceSettings().screenWidth - 2*x - 3*wPicture)/3;

		var coord = new [6];
		coord[0] = [x,y];
		coord[1] = [x+(wPicture+wText),y];
		coord[2] = [x+2*(wPicture+wText),y];
		coord[3] = [x,y + h];
		coord[4] = [x+(wPicture+wText),y + h];
		coord[5] = [x+2*(wPicture+wText),y + h];

		for (var i = 0; i < FIELDS_COUNT; i++){

			var idPicture = "P"+i;
	        var id = "F"+i;

	        fields[idPicture] = new SimpleField(
	    		{
	    			:x => coord[i][0],
	    			:y => coord[i][1],
	    			:h => h,
	    			:w => wPicture,
	    			:type => memoryCach.getPictureType(id),
	    			:id => id,
					:fontId => :picture,
	    			:justify => Graphics.TEXT_JUSTIFY_CENTER
	    		}
	    	);

	        fields[id] = new SimpleField(
	    		{
	    			:x => coord[i][0] + wPicture,
	    			:y => coord[i][1],
	    			:h => h,
	    			:w => wText,
	    			:type => memoryCach.getFieldType(id),
	    			:id => id,
					:fontId => :small,
	    			:justify => Graphics.TEXT_JUSTIFY_LEFT
	    		}
	    	);
		}
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {

		if (memoryCach.oldValues[:isStarted] != true){
			var color = memoryCach.settings[:colors][:background];
			var w = System.getDeviceSettings().screenWidth;
			var h = System.getDeviceSettings().screenHeight;
			dc.setColor(color, color);
			dc.setClip(0, 0, w, h);
			dc.fillRectangle(0, 0, w, h);
			memoryCach.oldValues[:isStarted] = false;
		}

		var ids = fields.keys();
		for (var i = 0; i < ids.size(); i++){

			var fieldId = ids[i];
			var oldValue = memoryCach.oldValues[fieldId];
			var value = Data.getValueByFieldType(fields[fieldId].type, oldValue);
			if (!value.equals(oldValue)){
				fields[fieldId].draw(dc, value);
				memoryCach.oldValues[fieldId] = value;
			}
		}

		memoryCach.oldValues[:isStarted] = true;

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

	function reloadFieldsTypes(){
		for (var i=0; i<FIELDS_COUNT; i++){
	        var id = "F"+i;
	        fields["P"+i].type = memoryCach.getPictureType(id);
	        fields[id].type = memoryCach.getFieldType(id);
		}
	}
}
