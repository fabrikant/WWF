using Toybox.System;

class SimpleField {

	var id, type, fontId, justify;
	var x, y, w, h;

	function initialize(params){
		id = params[:id];
		x = params[:x];
		y = params[:y];
		w = params[:w];
		h = params[:h];
		type = params[:type];
		fontId = params[:fontId];
		justify = params[:justify];
	}

	function draw(dc, text){

		clear(dc);
		dc.setColor(memoryCache.settings[:colors][id], Graphics.COLOR_TRANSPARENT);

		var _x = x;
		var _y = y + h/2;

		if (justify == Graphics.TEXT_JUSTIFY_CENTER){
			_x += w/2;
		} else if (justify == Graphics.TEXT_JUSTIFY_RIGHT){
			_x += w;
		}

		var font = fonts[fontId];
		dc.drawText(_x, _y, font, text, justify | Graphics.TEXT_JUSTIFY_VCENTER);
		drawBorder(dc);
	}

	function clear(dc){
		dc.setClip(x, y, w, h);
		dc.setColor(memoryCache.settings[:colors][:background], Graphics.COLOR_TRANSPARENT);
		dc.fillRectangle(x, y, w, h);
	}
	function drawBorder(dc){
		//return;
		dc.setColor(memoryCache.settings[:colors][id], Graphics.COLOR_TRANSPARENT);
		dc.drawRectangle(x, y, w, h);
	}

}