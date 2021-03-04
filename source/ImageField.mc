using Toybox.System;

class ImageField extends WindDirectionField{

	function initialize(params){
		WindDirectionField.initialize(params);
	}

	function draw(dc, value){
		if (value instanceof Number || value instanceof Float){
			self.WindDirectionField.draw(dc, value);			
		}else{
			self.WindDirectionField.SimpleField.draw(dc, value);
		}
	}
}
