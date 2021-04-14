using Toybox.System;
using Toybox.Application;
using Toybox.System;
using Toybox.SensorHistory;
using Toybox.Time.Gregorian;


class GraphicsField extends SimpleField{

	var showMinMax;

	function initialize(params){
		if (params[:showMinMax] == null){
			showMinMax = true;
		}else{
			showMinMax = params[:showMinMax]; 
		}
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
		
		var textW = 0;
		if (showMinMax){		
			textW = dc.getTextWidthInPixels("99999", fonts[fontId]);
		}
    	var iterParam = {:period => w-textW, :order => SensorHistory.ORDER_NEWEST_FIRST};
    	var iter = new Lang.Method(Toybox.SensorHistory, type).invoke(iterParam);

   		var min = iter.getMin();
		var max = iter.getMax();
		var sample = iter.next();
		var oldX = null;
		var oldY = null;
		var data;
		dc.setPenWidth(2);
		var xPoint = x+w-textW; 
	
		var yMax = y + h/4;
		var yMin = yMax + h/2;
		var xMinMax = xPoint+textW/2;
		
		var when = null;
		var hourDur = new Time.Duration(Gregorian.SECONDS_PER_HOUR);
		
		dc.setColor(getColor(), Graphics.COLOR_TRANSPARENT);
		dc.drawLine(x, y, x, y+h);
		if (showMinMax){
			dc.drawText(xMinMax, yMax, fonts[fontId], getMinMaxString(max), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
			dc.drawText(xMinMax, yMin, fonts[fontId], getMinMaxString(min), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
			dc.drawLine(x, y+h, x+w-textW, y+h);
		}else{
			dc.drawLine(x, y, x+w-textW, y);
		}
		
		
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
			}else{
				oldX = null;
				oldY = null;
			}	
			
			if (sample.when != null){
				if (when == null){
					when = sample.when;
				}
				if(!sample.when.add(hourDur).greaterThan(when)){
					when = sample.when;
					if (showMinMax){
						dc.drawLine(xPoint, y+h-8, xPoint, y+h);
					}else{
						dc.drawLine(xPoint, y+8, xPoint, y);
					}
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

