using Toybox.System;
using Toybox.Application;

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
			if (dc has :setAntiAlias){
				dc.setAntiAlias(true);
			}
			
			var windDirection = Tools.windDirection(h*0.9, direction.toNumber(), [x, y], [w, h]);
			if (Application.Properties.getValue("WindArrowContour")){
				var arSize = windDirection.size();
				for (var i = 1; i <= arSize; i++){
					dc.drawLine(
						windDirection[i%arSize][0], 
						windDirection[i%arSize][1], 
						windDirection[(i+1)%arSize][0], 
						windDirection[(i+1)%arSize][1]
					);
				}
			}else{
				dc.fillPolygon(windDirection);
			}
		}
		drawBorder(dc);
	}



}

