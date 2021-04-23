using Toybox.System;
using Toybox.Graphics;

class SimpleField {

	var type, fontId, justify;
	var x, y, w, h;
	var oldValue;

	function initialize(params){
		x = params[:x];
		y = params[:y];
		w = params[:w];
		h = params[:h];
		type = params[:type];
		fontId = params[:fontId];
		justify = params[:justify];
		oldValue = null;
	}

	function draw(dc, text){

		clear(dc);
		var color = getColor(); 
		if (color == getBackgroundColor()){
			return;
		}
		dc.setColor(color, Graphics.COLOR_TRANSPARENT);

		var _x = x;
		var _y = y + h/2;
		var font = fonts[fontId];
		var currentJustify = justify; 
		
		if (justify == Graphics.TEXT_JUSTIFY_CENTER){
			var textW = dc.getTextWidthInPixels(text, font);
			if (textW > w){
				currentJustify = Graphics.TEXT_JUSTIFY_LEFT; 
			}else{
				_x += w/2;
			}
		} else if (justify == Graphics.TEXT_JUSTIFY_RIGHT){
			_x += w;
		}

		
		dc.drawText(_x, _y, font, text, currentJustify | Graphics.TEXT_JUSTIFY_VCENTER);
		drawBorder(dc);
	}

	function clear(dc){
		dc.setClip(x, y, w, h);
		dc.setColor(getBackgroundColor(), Graphics.COLOR_TRANSPARENT);
		dc.fillRectangle(x, y, w, h);
	}

	function getBackgroundColor(){
		return memoryCache.settings[:backgroundColor];
	}

	function getColor(){
		if (type == :weather_temp){
			return memoryCache.settings[:autoColors][:temp];
		} else if (type == :weather_wind_dir || type == :weather_wind_speed || type == :weather_wind_speed_unit || type == :weather_wind_widget){
			return memoryCache.settings[:autoColors][:wind];
		}else{
			return memoryCache.getColorByFieldType(type);
		}			
	}

	function needUpdate(value){
	
		//Danger place.
		var res = false;
		if(value == null){
			res = (value != oldValue);
		}else if(value instanceof  Dictionary){
			res = false;
			if (oldValue instanceof  Dictionary){
				var keys = value.keys();
				for (var i = 0; i < keys.size(); i++){
					if(value[keys[i]] has :equals){
						if (!value[keys[i]].equals(oldValue[keys[i]])){
							res = true;
							break;
						}
					}else{
						if (!value[keys[i]] != oldValue[keys[i]]){
							res = true;
							break;
						}
					}
				}
			}else{
				res = true;
			}
		}else if(value has :equals){
			res = !value.equals(oldValue);
		}else{
			res = (value != oldValue);
		}
	
		oldValue = value;
		return res;
	}
	
	function drawBorder(dc){
		return;
		dc.setColor(getColor(), Graphics.COLOR_TRANSPARENT);
		dc.drawRectangle(x, y, w, h);
	}

}