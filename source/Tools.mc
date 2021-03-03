using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Math;
using Toybox.System;
using Toybox.Position;
using Toybox.Lang;

module Tools {

	///////////////////////////////////////////////////////////////////////////
	function windDirection(size, angle, leftTop, fieldSize){
		
		var angleRad = Math.toRadians(angle);
		var centerPoint = [leftTop[0]+fieldSize[0]/2, leftTop[1]+fieldSize[1]/2];
		var coords = [
			[-size*3/8,-size/2], 
			[0,size/2], 
			[size*3/8,-size/2], 
			[0, -size/4]
		];
	    var result = new [4];
        var cos = Math.cos(angleRad);
        var sin = Math.sin(angleRad);
        // Transform the coordinates
        for (var i = 0; i < 4; i += 1) {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin) + 0.5;
            var y = (coords[i][0] * sin) + (coords[i][1] * cos) + 0.5;
            result[i] = [x + centerPoint[0], y + centerPoint[1]];
            
        }
        return result;
	}
	
	///////////////////////////////////////////////////////////////////////////
	function min(v1, v2){
		if(v1 < v2){
			return v1;
		}else{
			return v2;
		}
	}	

	///////////////////////////////////////////////////////////////////////////
	function max(v1, v2){
		if(v1 > v2){
			return v1;
		}else{
			return v2;
		}
	}	

	///////////////////////////////////////////////////////////////////////////
	function minutesToString(rawData){
		var hour = (rawData / 60).toNumber();
		return Toybox.Lang.format("$1$:$2$", [hour.format("%02d"), (rawData-hour*60).format("%02d")]);
	}

	///////////////////////////////////////////////////////////////////////////
	function weightToString(rawData){
		var value = 0.0;
		if (System.getDeviceSettings().weightUnits ==  System.UNIT_STATUTE){ /*foot*/
			value = rawData/454.0;
		}else{
			value = rawData/1000.0;
		}
		return value.format("%.1f");
	}

	///////////////////////////////////////////////////////////////////////////
	function speedToString(rawData){
		var value = rawData;//meters/sec
		var unit =  memoryCache.settings[:windUnit];
		if (unit == 1){ /*km/h*/
			value = rawData*3.6;
		}else if (unit == 2){ /*mile/h*/
			value = rawData*2.237;
		}else if (unit == 3){ /*ft/s*/
			value = rawData*3.281;
		}else if (unit == 4){ /*Beaufort*/
			value = getBeaufort(rawData);
		}else if (unit == 5){ /*knots*/
			value = rawData*1.94384;
		}
		return value.format("%d");
	}

	///////////////////////////////////////////////////////////////////////////
	function getBeaufort(rawData){
		if(rawData >= 33){
			return 12;
		}else if(rawData >= 28.5){
			return 11;
		}else if(rawData >= 24.5){
			return 10;
		}else if(rawData >= 20.8){
			return 9;
		}else if(rawData >= 17.2){
			return 8;
		}else if(rawData >= 13.9){
			return 7;
		}else if(rawData >= 10.8){
			return 6;
		}else if(rawData >= 8){
			return 5;
		}else if(rawData >= 5.5){
			return 4;
		}else if(rawData >= 3.4){
			return 3;
		}else if(rawData >= 1.6){
			return 2;
		}else if(rawData >= 0.3){
			return 1;
		}else {
			return 0;
		}
	}

	///////////////////////////////////////////////////////////////////////////
	function momentToString(moment){
		var info = Gregorian.info(moment,Time.FORMAT_SHORT);
		var hours = info.hour;
		if (!System.getDeviceSettings().is24Hour) {
			if (hours > 12) {
				hours = hours - 12;
			}
		}
		var f = "%d";
		if (memoryCache.settings[:time][:hours01]){
			f = "%02d";
		}
		return hours.format(f)+":"+info.min.format("%02d");
	}

	///////////////////////////////////////////////////////////////////////////
	function momentToDateTimeString(moment){
		var info = Time.Gregorian.info(moment, Time.FORMAT_MEDIUM);
		return Lang.format(
		    "$1$ $2$ $3$ $4$:$5$:$6$",
		    [info.month, info.day, info.year, info.hour.format("%02d"), info.min.format("%02d"), info.sec.format("%02d")]
		);
	}

	///////////////////////////////////////////////////////////////////////////
	function getSunEvent(event, allowTomorrow){
		var geoLatLong = memoryCache.settings[:geoLocation];
		if (geoLatLong[0] == null || geoLatLong[1] == null){
			return null;
		}
		if (geoLatLong[0] == 0 && geoLatLong[1] == 0){
			return null;
		}
		var myLocation = new Position.Location(
		    {
		        :latitude => geoLatLong[0],
		        :longitude => geoLatLong[1],
		        :format => :degrees
		    }
		).toRadians();

		var now = Time.now();
		var d = now.value().toDouble() / Time.Gregorian.SECONDS_PER_DAY - 0.5 + 2440588 - 2451545;
		if (memoryCache.oldValues[:sunCach][:day] == null){
			var sunEventCalculator = new SunCalc();
			sunEventCalculator.fillCache(now, myLocation[0],myLocation[1]);
		}else if ( !(Math.round(memoryCache.oldValues[:sunCach][:day]).equals(Math.round(d)) && memoryCache.oldValues[:sunCach][:lat].equals(myLocation[0]) && memoryCache.oldValues[:sunCach][:lon].equals(myLocation[1]) )){
			var sunEventCalculator = new SunCalc();
			sunEventCalculator.fillCache(now, myLocation[0],myLocation[1]);
		}
		var eventMoment = memoryCache.oldValues[:sunCach][event][0];
		if (eventMoment.value() < now.value() && allowTomorrow){
			eventMoment = memoryCache.oldValues[:sunCach][event][1];
		}
		return eventMoment;
	}

	///////////////////////////////////////////////////////////////////////////
	function elevationToString(rawData){
		var value = rawData;//meters
		if (System.getDeviceSettings().elevationUnits ==  System.UNIT_STATUTE){ /*foot*/
			value = rawData*3.281;
		}
		if (value > 9999){
			value = (value/1000).format("%.1f")+"k";
		}else{
			value = value.format("%d");
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function distanceToString(rawData){
		var value = rawData;//santimeters
		if (System.getDeviceSettings().distanceUnits == System.UNIT_METRIC){ /*km*/
			value = rawData/100000.0;
		}else{ /*mile*/
			value = rawData/160934.4;
		}
		return value.format("%.2f");
	}

	///////////////////////////////////////////////////////////////////////////
	function pressureToString(rawData){
		var value = rawData; /*Pa */
		var unit  = memoryCache.settings[:pressureUnit];
		if (unit == 0){ /*MmHg*/
			value = Math.round(rawData/133.322).format("%d");
		}else if (unit == 1){ /*Psi*/
			value = (rawData.toFloat()/6894.757).format("%.2f");
		}else if (unit == 2){ /*InchHg*/
			value = (rawData.toFloat()/3386.389).format("%.2f");
		}else if (unit == 3){ /*miliBar*/
			value = (rawData/100).format("%d");
		}else if (unit == 4){ /*kPa*/
			value = (rawData/1000).format("%d");
		}
		return value;
	}

	///////////////////////////////////////////////////////////////////////////
	function temperatureToString(rawData){
		var value = rawData;/*C*/
		if (System.getDeviceSettings().temperatureUnits == System.UNIT_STATUTE){ /*F*/
			value = ((rawData*9/5) + 32);
		}
		return value.format("%d");
	}

	///////////////////////////////////////////////////////////////////////////
	function stringReplace(str, find, replace){
		var res = "";
		var ind = str.find(find);
		var len = find.length();
		var first;
		while (ind != null){
			if (ind == 0) {
				first = "";
			} else {
				first = str.substring(0, ind);
			}
			res = res + first + replace;
			str = str.substring(ind + len, str.length());
			ind = str.find(find);
		}
		res = res + str;
		return res;
	}

	///////////////////////////////////////////////////////////////////////////
	function weekOfYear(moment){

		var momentInfo = Gregorian.info(moment, Gregorian.FORMAT_SHORT);
		var jan1 = 	Gregorian.moment(
			{
				:year => momentInfo.year,
				:month => 1,
				:day =>1,
			}
		);

		var jan1DayOfWeek = Gregorian.info(jan1, Gregorian.FORMAT_SHORT).day_of_week;
		jan1DayOfWeek = jan1DayOfWeek == 1 ? 7 : jan1DayOfWeek - 1;

		if (jan1DayOfWeek < 5){

			var beginMoment = jan1;
			if (jan1DayOfWeek > 1){
				beginMoment = Gregorian.moment(
					{
						:year => momentInfo.year-1,
						:month => 12,
						:day =>33-jan1DayOfWeek,
					}
				);
			}
			return 1 + beginMoment.subtract(moment).value()/(Gregorian.SECONDS_PER_DAY*7);
		} else{
			if (momentInfo.month == 1 && momentInfo.day <= 3 && (momentInfo.day_of_week==1 || momentInfo.day_of_week > 5)){
				return weekOfYear(
					Gregorian.moment(
						{
							:year => momentInfo.year-1,
							:month => 12,
							:day =>31,
						}
					)
				);
			}else{
				var beginMoment = jan1.add(new Time.Duration((8-jan1DayOfWeek)*Gregorian.SECONDS_PER_DAY));
				return 1 + beginMoment.subtract(moment).value()/(Gregorian.SECONDS_PER_DAY*7);

			}
		}
	}

	///////////////////////////////////////////////////////////////////////////
    function moonPhase(now){
    	//var now = Time.now();
        var date = Time.Gregorian.info(now, Time.FORMAT_SHORT);
        // date.month, date.day date.year

		var n0 = 0;
		var f0 = 0.0;
		var AG = f0;

		//current date
	    var Y1 = date.year;
	    var M1 = date.month;
	    var D1 = date.day;

	    var YY1 = n0;
	    var MM1 = n0;
	    var K11 = n0;
	    var K21 = n0;
	    var K31 = n0;
	    var JD1 = n0;
	    var IP1 = f0;
	    var DP1 = f0;

	    // calculate the Julian date at 12h UT
	    YY1 = Y1 - ( ( 12 - M1 ) / 10 ).toNumber();
	    MM1 = M1 + 9;
	    if( MM1 >= 12 ) {
	    	MM1 = MM1 - 12;
	    }
	    K11 = ( 365.25 * ( YY1 + 4712 ) ).toNumber();
	    K21 = ( 30.6 * MM1 + 0.5 ).toNumber();
	    K31 = ( ( ( YY1 / 100 ) + 49 ).toNumber() * 0.75 ).toNumber() - 38;

	    JD1 = K11 + K21 + D1 + 59;                  // for dates in Julian calendar
	    if( JD1 > 2299160 ) {
	    	JD1 = JD1 - K31;        				// for Gregorian calendar
		}

	    // calculate moon's age in days
	    IP1 = normalize( ( JD1 - 2451550.1 ) / 29.530588853 );
	    var AG1 = IP1*29.53;

		return AG1.toNumber();

    }

	///////////////////////////////////////////////////////////////////////////
    function normalize( v ){
	    v = v - v.toNumber();
	    if( v < 0 ) {
	        v = v + 1;
		}
	    return v;
	}

}