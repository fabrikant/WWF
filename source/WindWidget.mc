using Toybox.System;
using Toybox.Application;

class WindDWidget extends SimpleField{

	function initialize(params){
		SimpleField.initialize(params);
	}

	function draw(dc, values){

		clear(dc);
		if (memoryCache.settings[:colors][id] == getBackgroundColor()){
			return;
		}
		var ratio = 0.5;
		//direction		
		var direction = values[:weather_wind_dir];
		if (direction != -1){
			var windDirection = Tools.windDirection(h*ratio*0.9, direction.toNumber(), [x, y], [w*ratio, h*ratio]);
			dc.setColor(getColor(), Graphics.COLOR_TRANSPARENT);
			if (dc has :setAntiAlias){
				dc.setAntiAlias(true);
			}
			
			if (Application.Properties.getValue("WindArrowContour")){
				dc.setPenWidth(2);
				var arSize = windDirection.size();
				for (var i = 1; i <= arSize; i++){
					dc.drawLine(
						windDirection[i%arSize][0], 
						windDirection[i%arSize][1], 
						windDirection[(i+1)%arSize][0], 
						windDirection[(i+1)%arSize][1]
					);
				}
				dc.setPenWidth(1);
			}else{
				dc.fillPolygon(windDirection);
			}
		}
		
		//text
		var font = fonts[:small];
		var _y = y + h/4;
		var text = values[:weather_wind_speed];
		var textW = dc.getTextWidthInPixels(text, font);
		if (textW > w*(1-ratio)){
			dc.drawText(x+w, _y, font, text, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
		}else{
			dc.drawText(x+w*ratio, _y, font, text, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
		}
		font = fonts[:small_letters];
		_y += h/2;
		dc.drawText(getTextX(Graphics.TEXT_JUSTIFY_CENTER), _y, font, values[:weather_wind_speed_unit], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

		drawBorder(dc);
	}


	private function getTextX(_just){
		var _x = x;
		if (_just == Graphics.TEXT_JUSTIFY_CENTER){
			_x += w/2;
		} else if (_just == Graphics.TEXT_JUSTIFY_RIGHT){
			_x += w;
		}
		return _x;
	}
}