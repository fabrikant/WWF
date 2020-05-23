using Toybox.System;
using Toybox.Math;

class BatteryField extends SimpleField{


	function initialize(params){
		SimpleField.initialize(params);
	}

	function draw(dc, value){
		clear(dc);
		if (memoryCache.settings[:colors][id] == getBackgroundColor()){
			return;
		}
		drawBattery(dc, value);
		drawBorder(dc);
	}

	private function drawBattery(dc, value){

		dc.setColor(memoryCache.settings[:colors][id], Graphics.COLOR_TRANSPARENT);

		var k = 0.70;
		var xOffset = 3;
		var yOffset = 2;
		var hBattery = h*k;
		var wBattery = w*k-xOffset;

		//Внешний контур
		//[x,y,w,h]
		var external = [x + (w - wBattery)/2 + xOffset, y + (h - hBattery)/2 + yOffset, wBattery, hBattery];
		dc.drawRectangle(external[0], external[1], external[2], external[3]);
		var hContact = external[3]*0.6;
		var wContact = external[2];
		dc.fillRoundedRectangle(external[0]+3, external[1] + (external[3]-hContact)/2-1, wContact, hContact, 3);
		dc.setColor(getBackgroundColor(), Graphics.COLOR_TRANSPARENT);
		dc.fillRectangle(external[0]+1, external[1]+1, external[2]-2, external[3]-2);

		//Заполнение
		if (value > 20){
			//dc.setColor(memoryCache.settings[:colors][id], Graphics.COLOR_TRANSPARENT);
			dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
		}else{
			dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
		}
		var inner = [external[0]+2,external[1]+2,external[2]-4,external[3]-4];
		dc.fillRectangle(inner[0], inner[1], inner[2]*value/100, inner[3]);
	}
}

