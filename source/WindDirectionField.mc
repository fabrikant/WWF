using Toybox.System;
using Toybox.Application;

class WindDirectionField extends SimpleField{


	function initialize(params){
		SimpleField.initialize(params);
	}

	function draw(dc, direction){

		clear(dc);
		var currentColor = getColor();
		if (currentColor == getBackgroundColor()){
			return;
		}
		if (direction != -1){
			dc.setColor(currentColor, Graphics.COLOR_TRANSPARENT);
			if (dc has :setAntiAlias){
				dc.setAntiAlias(true);
			}
			
			var windDirection = Tools.windDirection(h*0.9, direction.toNumber(), [x, y], [w, h]);
			dc.fillPolygon(windDirection);
			if (dc has :setAntiAlias){
				dc.setAntiAlias(false);
			}
		}
		drawBorder(dc);
	}



}

