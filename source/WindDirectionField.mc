using Toybox.System;

class WindDirectionField extends SimpleField{


	function initialize(params){
		SimpleField.initialize(params);
	}

	function draw(dc, direction){

		clear(dc);
		if (memoryCache.settings[:colors][id] == getBackgroundColor()){
			return;
		}
		if (direction != -1){
			dc.setColor(getColor(), Graphics.COLOR_TRANSPARENT);
			var windDirection = Tools.windDirection(h*0.9, direction.toNumber(), [x, y], [w, h]);
			dc.fillPolygon(windDirection);
		}
		drawBorder(dc);
	}



}

