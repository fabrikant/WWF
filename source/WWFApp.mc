using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;
using Toybox.Background;

(:background)
class WWFApp extends Application.AppBase {

	var view;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
    	view = new WWFView();
        return [ view ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() {
    	memoryCache = new MemoryCache();
    	WatchUi.requestUpdate();
    	registerEvents();
    	
        
    }

	function getSettingsView(){

		var menu = new MenuSettings();
		return [ menu, new MenuDelegate(menu)];

	}

	///////////////////////////////////////////////////////////////////////////
	// Background
	function onBackgroundData(data) {
		//////////////////////////////////////////////////////////
		//DEBUG
		//System.println("onBackgroundData "+Tools.momentToString(Time.now()));
		//System.println("data: "+data);
		//////////////////////////////////////////////////////////
		if (data != null){
	    	if (data[STORAGE_KEY_RESPONCE_CODE] != null){
	     		Application.Storage.setValue(STORAGE_KEY_RESPONCE_CODE, data[STORAGE_KEY_RESPONCE_CODE]);
		        if (data[STORAGE_KEY_RESPONCE_CODE].toNumber() == 200){
		        	if (memoryCache == null){
		        		memoryCache = new MemoryCache();
		        	}
	       			memoryCache.onWeatherUpdate(data);
		        }
	 		}
 		}
        registerEvents();
    }

 	function registerEvents(){

		//////////////////////////////////////////////////////////
		//DEBUG
		//System.println("registerEvents");
		//System.println("geoLocation "+memoryCache.settings[:geoLocation]);
		//System.println("apiKey "+memoryCache.settings[:apiKey]);
		//////////////////////////////////////////////////////////

		if (memoryCache == null){
			return;
		}
		var geoLatLong = memoryCache.settings[:geoLocation];
		if (geoLatLong[0] == null || geoLatLong[1] == null){
			return;
		}
		if (geoLatLong[0] == 0 && geoLatLong[1] == 0){
			return;
		}
		var kewOw = memoryCache.settings[:apiKey];
		if (kewOw.equals("")){
			return;
		}

		var registeredTime = Background.getTemporalEventRegisteredTime();
		if (registeredTime != null){
			//////////////////////////////////////////////////////////
			//DEBUG
			//System.println("now: "+Tools.momentToString(Time.now())+" Event already set: "+Tools.momentToString(registeredTime));
			//////////////////////////////////////////////////////////
			return;
		}
		var lastTime = Background.getLastTemporalEventTime();
		var duration = new Time.Duration(memoryCache.settings[:weatherUpdateInteval]*60);
		var now = Time.now();
		if (lastTime == null){
			//////////////////////////////////////////////////////////
			//DEBUG
			//System.println("reg ev now 1");
			//////////////////////////////////////////////////////////
			Background.registerForTemporalEvent(now);
		}else{
			if (now.greaterThan(lastTime.add(duration))){
				//////////////////////////////////////////////////////////
				//DEBUG
				//System.println("reg ev now 2");
				//////////////////////////////////////////////////////////
				Background.registerForTemporalEvent(now);
			}else{
			    var nextTime = lastTime.add(duration);
				//////////////////////////////////////////////////////////
				//DEBUG
			    //System.println("reg ev "+Tools.momentToString(nextTime));
				//////////////////////////////////////////////////////////
			    Background.registerForTemporalEvent(nextTime);
			}
		}
	}

	function getServiceDelegate(){
        return [new BackgroundService()];
    }

}