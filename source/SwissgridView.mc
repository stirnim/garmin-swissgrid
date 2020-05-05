using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Lang;

class SwissgridView extends WatchUi.DataField {

    hidden var mValueN;
    hidden var mValueE;
    hidden var N;
    hidden var E;
    
    function initialize() {
        DataField.initialize();
        mValueN = "000000";
        mValueE = "000000";
        N = 0;
        E = 0;
    }

    function onLayout(dc) {
        View.setLayout(Rez.Layouts.DefaultLayout(dc));
        var label = View.findDrawableById("label");
        label.setText(Rez.Strings.label);
        var valueN = View.findDrawableById("valueN");
        valueN.setText(mValueN);
        var valueE = View.findDrawableById("valueE");
        valueE.setText(mValueE);
        return true;
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
        // See Activity.Info in the documentation for available information.
        if(info has :currentLocation){
            if(info.currentLocation != null){
                // convert decimal degree into sexagesimal seconds (base 60)
                // and use axiliary values from Bern */
                var LATAUX = (info.currentLocation.toDegrees()[0] * 3600 - 169028.66) / 10000;
                var LNGAUX = (info.currentLocation.toDegrees()[1] * 3600 - 26782.5) / 10000;
                
                // calculate N
                N = 200147.07
                    + 308807.95 * LATAUX
                    +   3745.25 * LNGAUX * LNGAUX
                    +     76.63 * LATAUX * LATAUX
                    -    194.56 * LNGAUX * LNGAUX * LATAUX
                    +    119.79 * LATAUX * LATAUX * LATAUX;
                    
                // calculate E
                E = 600072.37
                    + 211455.93 * LNGAUX
                    -  10938.51 * LNGAUX * LATAUX
                    -      0.36 * LNGAUX * LATAUX * LATAUX
                    -     44.54 * LNGAUX * LNGAUX * LNGAUX;
            }
        }
        if ( (N >= 1000000 and N < 0) or (E >= 1000000 and E < 0) ) {
            mValueN = "000000";
            mValueE = "000000";
        } else {
            mValueN = N.format("%06d");
            mValueE = E.format("%06d");
        }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) {
        // Set the background color
        View.findDrawableById("Background").setColor(getBackgroundColor());

        // Set the foreground color and value
        var valueN = View.findDrawableById("valueN");
        var valueE = View.findDrawableById("valueE");
        var label = View.findDrawableById("label");
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            valueN.setColor(Graphics.COLOR_WHITE);
            valueE.setColor(Graphics.COLOR_WHITE);
            label.setColor(Graphics.COLOR_WHITE);
        } else {
            valueN.setColor(Graphics.COLOR_BLACK);
            valueE.setColor(Graphics.COLOR_BLACK);
            label.setColor(Graphics.COLOR_BLACK);
        }
        valueN.setText(mValueN);
        valueE.setText(mValueE);

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

}
