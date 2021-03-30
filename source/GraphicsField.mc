using Toybox.System;
using Toybox.Application;
using Toybox.System;
using Toybox.SensorHistory;

class GraphicsField extends SimpleField{


	function initialize(params){
		SimpleField.initialize(params);
	}

	function draw(dc, value){
		clear(dc);
		
		var na = true;
		if (Toybox has :SensorHistory){
			if (SensorHistory has type){
				na = false;
			}
		}
		if(na){
			SimpleField.draw(dc, "n/a");
		}else{
			drawGraphic(dc);
			drawBorder(dc);
		}
	}

	function drawGraphic(dc){
		
    	var iterParam = {:period => w, :order => SensorHistory.ORDER_NEWEST_FIRST};
    	var iter = new Lang.Method(Toybox.SensorHistory, type).invoke(iterParam);

   		var min = iter.getMin();
		var max = iter.getMax();
		var sample = iter.next();
		var oldX = null;
		var oldY = null;
		var data;
		var lastData = null;
		dc.setPenWidth(2);
		var xPoint = x+w; 

		while (sample != null){

			data = sample.data;
			if (data != null){
				var yPoint = y + h;
				if (max-min > 0){
					yPoint -= (data - min)*h/(max-min);
				}
				if (oldX != null){
					dc.setColor(getColor(), Graphics.COLOR_TRANSPARENT);
					dc.drawLine(xPoint, yPoint, oldX, oldY);
				}
				oldX = xPoint;
				oldY = yPoint;
				if (lastData == null){
					lastData = data;
				}
			}

			xPoint -= 1;
			sample = iter.next();
		}

		
	}

}

