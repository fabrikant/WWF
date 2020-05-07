using Toybox.System;

class WindDirectionField extends SimpleField{


	function initialize(params){
		SimpleField.initialize(params);
	}

	function draw(dc, direction){

		clear(dc);
		if (memoryCache.settings[:colors][id] == memoryCache.settings[:colors][:background]){
			return;
		}
		if (direction != -1){
			dc.setColor(memoryCache.settings[:colors][id], Graphics.COLOR_TRANSPARENT);
			var windDirection = windDirection(h*0.9, direction.toNumber(), [x, y]);
			dc.fillPolygon(windDirection);
		}
		drawBorder(dc);
	}

	private function windDirection(size, angle, leftTop){

		var angleRad = Math.toRadians(angle);
		var centerPoint = [size/2,size/2];
		var coords = [[0+size/8,0],[size/2,size],[size-size/8,0],[size/2, size/4]];
	    var result = new [4];
        var cos = Math.cos(angleRad);
        var sin = Math.sin(angleRad);
		var min = [99999, 99999];
        // Transform the coordinates
        for (var i = 0; i < 4; i += 1) {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin) + 0.5;
            var y = (coords[i][0] * sin) + (coords[i][1] * cos) + 0.5;
            result[i] = [centerPoint[0] + x, centerPoint[1] + y];
            if (min[0]>result[i][0]){
            	min[0]=result[i][0];
            }
            if (min[1]>result[i][1]){
            	min[1]=result[i][1];
            }
        }
        //To LEFT TOP Corner
		var offset = [leftTop[0]-min[0],leftTop[1]-min[1]];
		var maxY = -1;
        for (var i = 0; i < 4; i += 1) {
        	result[i][0] = result[i][0] + offset[0];
        	result[i][1] = result[i][1] + offset[1];
        	if (maxY < result[i][1]){
        		maxY = result[i][1];
        	}
		}
		//To VERTICAL CENTER
		offset = (y+h-maxY)/2;
        for (var i = 0; i < 4; i += 1) {
        	result[i][1] = result[i][1] + offset;
		}


        return result;
	}

}

