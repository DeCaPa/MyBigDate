using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian;
using Toybox.Application as App;
using Toybox.ActivityMonitor;

/**
 * Simple Garmin Watchface with a focus on larger fonts for date, calories, steps and battery life.  
 * 
 * initial release for the Garmin 735xt.  Other sizes may come.
 *
 * Pixel Size of each screen this watch face is used for (or provided in a subsequent release: 
 * 735xt: 215x180 | 935: 240x240 | fenix 5x 240x240 | fenix 5 240x240
 *
**/
class MyBigDateView extends Ui.WatchFace {

	var displayHeight = null;
	var displayWidth = null;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
	    
	    displayHeight = dc.getHeight();
        displayWidth = dc.getWidth();
		
		bigDate();
		currentTime();
		
		//calories
		var myCalories = ActivityMonitor.getInfo().calories;
		var caloriesViewString = Lang.format("$1$", [myCalories.format("%02d")]);
		var caloriesView = View.findDrawableById("CaloriesLabel");
		caloriesView.setText(caloriesViewString);		
		
		//Steps and step goal
		var mySteps = ActivityMonitor.getInfo().steps;
		var stepGoal = ActivityMonitor.getInfo().stepGoal;
		var stepViewString = Lang.format("$1$", [mySteps.format("%02d")]);
		var stepView = View.findDrawableById("StepLabel");

		stepView.setText(stepViewString);	
	    
	    //when goal is reached change color to green
	    if (mySteps >= stepGoal) {
			stepView.setColor(App.getApp().getProperty("GoalAchievedColor"));
		} else {
			stepView.setColor(App.getApp().getProperty("GoalInProgressColor"));
		}
				
		//battery %
		var myBattery = Sys.getSystemStats().battery;
		var batteryViewString = Lang.format("$1$", [myBattery.format("%02d")]);
		var batteryView = View.findDrawableById("BatteryLabel");
		
		//unit test various settings, comment out 
     	//myBattery = 100;
    	//batteryViewString = "100";
		batteryView.setText(batteryViewString + "%");

 		//Sys.println("steps: " + mySteps + " battery: " + myBattery + " step Goal: " + stepGoal + " calories: " + myCalories);
    			
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
         
        //draw circles  
        //TODO: put color into layout.xml
        dc.setColor(0xffff00, Graphics.COLOR_GREEN);
        dc.setPenWidth(2);
    	dc.drawCircle(displayWidth/4, 30, 40);
    	dc.drawCircle(displayWidth - (displayWidth/4), 30, 40);
    	
    	drawAndDisplayBattery(dc, myBattery, batteryViewString);	 
    			
		// load images from drawables
	    var pic_steps = Ui.loadResource(Rez.Drawables.id_steps);    
	    var pic_kcal = Ui.loadResource(Rez.Drawables.id_kcal);
	    dc.drawBitmap((displayWidth*.25) - 6, 50, pic_steps);
	    dc.drawBitmap((displayWidth*.75) - 6, 50, pic_kcal);

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    
    /** Get the current date and format it correctly */
    function bigDate() {
   
	    var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
	    var dateString = Lang.format(
	    "$1$, $2$ $3$",
	    [
	        today.day_of_week,
	        today.month,
	        today.day
	    ] );
		//Sys.println(dateString);

        var dateView = View.findDrawableById("DateLabel");
        dateView.setText(dateString);       
	}
 
 	/** Get the current time and format it correctly */
 	function currentTime() {
         
        var timeFormat = "$1$:$2$";
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (App.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the view
        var timeView = View.findDrawableById("TimeLabel");
        
 		//use this to read from properties.xml to set color
        //timeView.setColor(App.getApp().getProperty("ForegroundColor")); 
        timeView.setText(timeString);	
 	}   
 	
 	/** Deals with the battery meter display, based on remaining battery life */
 	function drawAndDisplayBattery(dc, myBattery, batteryViewString) {
     	
    	//logic to display battery meter
    	if (myBattery >= 80) {
    		//Sys.println("batt > 80: " + batteryViewString);
    		dc.drawRectangle((displayWidth/2)-65,(displayHeight*.82),10,3);
	    	dc.drawRectangle((displayWidth/2)-50,(displayHeight*.82),10,3);
	    	dc.drawRectangle((displayWidth/2)-35,(displayHeight*.82),20,3);
	    	dc.drawRectangle((displayWidth/2)-10,(displayHeight*.82),20,3);
	    	dc.drawRectangle((displayWidth/2)+15,(displayHeight*.82),20,3);
	    	dc.drawRectangle((displayWidth/2)+40,(displayHeight*.82),20,3);
    	} else if (myBattery >= 60 && myBattery <80) {
    		//Sys.println("batt between 60-80: " + batteryViewString);
    		dc.drawRectangle((displayWidth/2)-65,(displayHeight*.82),10,3);
	    	dc.drawRectangle((displayWidth/2)-50,(displayHeight*.82),10,3);
	    	dc.drawRectangle((displayWidth/2)-35,(displayHeight*.82),20,3);
	    	dc.drawRectangle((displayWidth/2)-10,(displayHeight*.82),20,3);
	    	dc.drawRectangle((displayWidth/2)+15,(displayHeight*.82),20,3);
    	} else if (myBattery >= 40 && myBattery <60) {
    		//Sys.println("batt between 40-60: " + batteryViewString);
    		dc.drawRectangle((displayWidth/2)-65,(displayHeight*.82),10,3);
	    	dc.drawRectangle((displayWidth/2)-50,(displayHeight*.82),10,3);
	    	dc.drawRectangle((displayWidth/2)-35,(displayHeight*.82),20,3);
	    	dc.drawRectangle((displayWidth/2)-10,(displayHeight*.82),20,3);
    	} else if (myBattery >= 20 && myBattery < 40) {
    		//Sys.println("batt between 20-40: " + batteryViewString);
    		dc.drawRectangle((displayWidth/2)-65,(displayHeight*.82),10,3);
	    	dc.drawRectangle((displayWidth/2)-50,(displayHeight*.82),10,3);
	    	dc.drawRectangle((displayWidth/2)-35,(displayHeight*.82),20,3);
    	} else if (myBattery >= 10 && myBattery < 20) {
    		//Sys.println("batt between 10-20: " + batteryViewString);
	    	dc.drawRectangle((displayWidth/2)-65,(displayHeight*.82),10,3);
	    	dc.drawRectangle((displayWidth/2)-50,(displayHeight*.82),10,3);
    	} else {
    		//Sys.println("batt less than 10: " + batteryViewString);
	    	dc.drawRectangle((displayWidth/2)-65,(displayHeight*.82),10,3);
	    }
    	
 	}    
}
