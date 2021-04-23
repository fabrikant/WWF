using Toybox.System;
using Toybox.Application;

class WindDWidget extends SimpleField{

	function initialize(params){
		SimpleField.initialize(params);
	}

	function draw(dc, values){

		clear(dc);
		var color = getColor();
		if (color == getBackgroundColor()){
			return;
		}
		var ratio = 0.5;
		//direction		
		var direction = values[:weather_wind_dir];
		if (direction != -1){
			var windDirection = Tools.windDirection(h*ratio*0.9, direction.toNumber(), [x, y], [w*ratio, h*ratio]);
			dc.setColor(color, Graphics.COLOR_TRANSPARENT);
//			if (dc has :setAntiAlias){
//				dc.setAntiAlias(true);
//			}
			
			dc.fillPolygon(windDirection);
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