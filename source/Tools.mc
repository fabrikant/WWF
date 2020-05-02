using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Math;
using Toybox.System;
using Toybox.Position;

module Tools {

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
		if (memoryCach.settings[:time][:hours01]){
			f = "%02d";
		}
		return hours.format(f)+":"+info.min.format("%02d");
	}

	///////////////////////////////////////////////////////////////////////////
	function getSunEvent(event, allowTomorrow){
		var geoLatLong = memoryCach.settings[:geoLocation];
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
		if (memoryCach.oldValues[:sunCach][:day] == null){
			var sunEventCalculator = new SunCalc();
			sunEventCalculator.fillCache(now, myLocation[0],myLocation[1]);
		}else if ( !(Math.round(memoryCach.oldValues[:sunCach][:day]).equals(Math.round(d)) && memoryCach.oldValues[:sunCach][:lat].equals(myLocation[0]) && memoryCach.oldValues[:sunCach][:lon].equals(myLocation[1]) )){
			var sunEventCalculator = new SunCalc();
			sunEventCalculator.fillCache(now, myLocation[0],myLocation[1]);
		}
		var eventMoment = memoryCach.oldValues[:sunCach][event][0];
		if (eventMoment.value() < now.value() && allowTomorrow){
			eventMoment = memoryCach.oldValues[:sunCach][event][1];
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
		var unit  = memoryCach.settings[:pressureUnit];
		if (unit == 0){ /*MmHg*/
			value = Math.round(rawData/133.322).format("%d");
		}else if (unit == 1){ /*Psi*/
			value = Math.round(rawData/6894.757).format("%d");
		}else if (unit == 2){ /*InchHg*/
			value = Math.round(rawData/3386.389).format("%d");
		}else if (unit == 3){ /*bar*/
			value = (rawData/100000).format("%.3f");
		}else if (unit == 4){ /*kPa*/
			value = (rawData/1000).format("%d");
		}else if (unit == 5){ /*hPa*/
			value = (rawData/100).format("%d");
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

			return weekOfYear(
				Gregorian.moment(
					{
						:year => momentInfo.year-1,
						:month => 12,
						:day =>31,
					}
				)
			);
		}
	}

}