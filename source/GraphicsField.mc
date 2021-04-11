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
			fontId = :small_letters;
			SimpleField.draw(dc, NA);
		}else{
			drawGraphic(dc);
			drawBorder(dc);
		}
	}

	function drawGraphic(dc){
		
		var textW = dc.getTextWidthInPixels("9999", fonts[fontId]);
    	var iterParam = {:period => w-textW, :order => SensorHistory.ORDER_NEWEST_FIRST};
    	var iter = new Lang.Method(Toybox.SensorHistory, type).invoke(iterParam);

   		var min = iter.getMin();
		var max = iter.getMax();
		var sample = iter.next();
		var oldX = null;
		var oldY = null;
		var data;
		var lastData = null;
		dc.setPenWidth(2);
		var xPoint = x+w-textW; 
	
		var yMax = y + h/4;
		var yMin = yMax + h/2;
		var xMinMax = xPoint+textW/2;
		
		dc.setColor(getColor(), Graphics.COLOR_TRANSPARENT);
		dc.drawText(xMinMax, yMax, fonts[fontId], getMinMaxString(max), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(xMinMax, yMin, fonts[fontId], getMinMaxString(min), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	
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
	
	function getMinMaxString(value){
		var res = "";
		if (value != null){
			res = value;
			if (type == :getHeartRateHistory){
				res = value.format("%d");
			}else if (type == :getOxygenSaturationHistory){
				res = value.format("%d")+"%";
			}else if (type == :getTemperatureHistory){
				res = Tools.temperatureToString(value)+"°";
			}else if (type == :getPressureHistory){
				res = Tools.pressureToString(value);
			}else if (type == :getElevationHistory){
				res = Tools.elevationToString(value);
			}
		}
		return res;
	}

}

