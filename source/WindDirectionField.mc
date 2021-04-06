using Toybox.System;
using Toybox.Application;

class WindDirectionField extends SimpleField{


	function initialize(params){
		SimpleField.initialize(params);
	}

	function draw(dc, direction){

		clear(dc);
		if (getColor() == getBackgroundColor()){
			return;
		}
		if (direction != -1){
			dc.setColor(getColor(), Graphics.COLOR_TRANSPARENT);
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

