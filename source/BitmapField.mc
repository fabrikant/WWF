using Toybox.System;
using Toybox.Application;
using Toybox.System;

class BitmapField extends SimpleField{


	function initialize(params){
		SimpleField.initialize(params);
	}

	function draw(dc, value){
		clear(dc);
		if (value != null){
			var backgroundColor = memoryCache.settings[:colors][:backgroundColor];
			
			var pref = "d";
			if (backgroundColor == Graphics.COLOR_WHITE 
				|| backgroundColor == Graphics.COLOR_LT_GRAY 
				|| backgroundColor == Graphics.COLOR_YELLOW){
				pref = "l";
			}
			var iRez = bitmapID(pref+value);
			if (iRez != null){
				var image = Application.loadResource(iRez);
				var yOffset = -3;
				var xOffset = -6;
				if (dc.getWidth() == 218){
					yOffset = -5;
					xOffset -= 3;
				}
				if (dc has :setAntiAlias){
					dc.setAntiAlias(true);
				}
				dc.drawBitmap(x+xOffset, y+yOffset, image);
			}
		}		
		drawBorder(dc);
	}

	function bitmapID(iId){
		var res = {
			"l01d" => Rez.Drawables.l01d,
			"l02d" => Rez.Drawables.l02d,
			"l03d" => Rez.Drawables.l03d,
			"l04d" => Rez.Drawables.l04d,
			"l09d" => Rez.Drawables.l09d,
			"l10d" => Rez.Drawables.l10d,
			"l11d" => Rez.Drawables.l11d,
			"l13d" => Rez.Drawables.l13d,
			"l50d" => Rez.Drawables.l50d,

			"l01n" => Rez.Drawables.l01n,
			"l02n" => Rez.Drawables.l02n,
			"l03n" => Rez.Drawables.l03d,
			"l04n" => Rez.Drawables.l04d,
			"l09n" => Rez.Drawables.l09d,
			"l10n" => Rez.Drawables.l10n,
			"l11n" => Rez.Drawables.l11d,
			"l13n" => Rez.Drawables.l13d,
			"l50n" => Rez.Drawables.l50d,
			
			"d01d" => Rez.Drawables.l01d,
			"d02d" => Rez.Drawables.d02d,
			"d03d" => Rez.Drawables.d03d,
			"d04d" => Rez.Drawables.d04d,
			"d09d" => Rez.Drawables.d09d,
			"d10d" => Rez.Drawables.d10d,
			"d11d" => Rez.Drawables.d11d,
			"d13d" => Rez.Drawables.d13d,
			"d50d" => Rez.Drawables.d50d,

			"d01n" => Rez.Drawables.d01n,
			"d02n" => Rez.Drawables.d02n,
			"d03n" => Rez.Drawables.d03d,
			"d04n" => Rez.Drawables.d04d,
			"d09n" => Rez.Drawables.d09d,
			"d10n" => Rez.Drawables.d10n,
			"d11n" => Rez.Drawables.d11d,
			"d13n" => Rez.Drawables.d13d,
			"d50n" => Rez.Drawables.d50d,
		};
		return res[iId];
	}


}

