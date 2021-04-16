using Toybox.System;
using Toybox.Application;
using Toybox.Math;


class SolarField extends SimpleField{

	private var currentColor;
	
	function initialize(params){
		SimpleField.initialize(params);
	}

	function draw(dc, value){
		clear(dc);
		currentColor = getColor();
		drawSun(dc);
		dc.setColor(currentColor, Graphics.COLOR_TRANSPARENT);
		var textY = y+h*0.33;
		dc.drawText(x, textY, fonts[fontId], Data.getSunrise(), Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(x+w-1, textY, fonts[fontId], Data.getSunset(), Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
		
		drawBorder(dc);
	}

	function drawSun(dc){
	
		var color = currentColor;
		var backgroundColor = getBackgroundColor();
		
		if (!memoryCache.themeIsMonochrome()){
			color = Graphics.COLOR_ORANGE;
		}
		dc.setColor(color, Graphics.COLOR_TRANSPARENT);
		
		var xCenter = x+w/2;
		var yCenter = y+h*0.85;
		var radius = h*0.24;
		var ray = 1.7*radius;
		var diagonal = Math.sqrt(ray*ray/2);
		var breakRaduis = 1.35*radius; 
		
		if (dc has :setAntiAlias){
			dc.setAntiAlias(true);
		}
		
		dc.setPenWidth(3);
		dc.drawLine(xCenter-ray, yCenter-2, xCenter+ray, yCenter-2);
		dc.drawLine(xCenter, yCenter, xCenter, yCenter-ray);
		dc.drawLine(xCenter, yCenter, xCenter+diagonal, yCenter-diagonal);
		dc.drawLine(xCenter, yCenter, xCenter-diagonal, yCenter-diagonal);
		
		dc.setPenWidth(1);
		dc.setColor(backgroundColor, backgroundColor);
		dc.fillCircle(xCenter, yCenter, breakRaduis);
		
		dc.setColor(color, Graphics.COLOR_TRANSPARENT);
		dc.fillCircle(xCenter, yCenter, radius);
		
		dc.setColor(backgroundColor, backgroundColor);
		dc.fillRectangle(xCenter-ray-1, yCenter, 2*ray+2, y+h-yCenter+1);
		
		if (dc has :setAntiAlias){
			dc.setAntiAlias(false);
		}
	}

}

