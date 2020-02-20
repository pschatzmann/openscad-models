/**
 A simple stackable Rasperry PI Zero case. In the parameter you can indicate the number of levels. 
 
*/

numberOfPis=2;           // number of PIs to be stacked
widthOfPi=63.5;                // x width of a rawspberry pi
depthOfPi=28.7;                // y depth of a rawspberry pi
roundedCornersDiam=0;    // minkowski on cover
coverHeight=1.5;         // height of cover
holePos=3;               // x,y position of right hole
pinDiameter=2.4;         // diameter of pin & hole
holeDiameterOffset=0.7; // make hole bigger then pin
connectorHeight=9;       // height of the connector pin
spacerBottomHeight=5;    // height of the bottom spacer
spacerTopHeight=7;      // height of the top spacer
partOffset=30;           // we draw the parts by 3cm separated
holeWidthPos=width-holePos;// x position of left hole

// the base of the top and bottom
module base() {
    minkowski() {
        cube([widthOfPi,depthOfPi,coverHeight]);
        sphere(roundedCornersDiam,$fn=20);
    }
}

// print a single connector pin
module connector(height) {
    cylinder(height, d=pinDiameter, $fn=100);
}

// print a connector pin
module connectors(connectorHeight) {
    translate([holePos,holePos,0]) 
        connector(connectorHeight);
    translate([holePos,depthOfPi-holePos,0]) 
        connector(connectorHeight);
    translate([holeWidthPos,depthOfPi-holePos,0]) 
        connector(connectorHeight);
    translate([holeWidthPos,holePos,0]) 
        connector(connectorHeight);
}

// prints a single spacer (with a hole)
module spacer(height) {
    difference() {
        size = holePos*2;
        cube([size, size, height]);
        
        translate([holePos,holePos,0]) 
        cylinder(height, d=pinDiameter+holeDiameterOffset,$fn=100);
    }
}

// prints all spacers
module spacers(height, offset) {
    size = holePos*2;
    translate([0,0,offset]) 
        spacer(height);
    translate([0,depthOfPi-size,offset]) 
        spacer(height);
    translate([holeWidthPos-holePos,depthOfPi-size,offset]) 
        spacer(height);
    translate([holeWidthPos-holePos,0,offset]) 
        spacer(height);
}

// bommtom of a case
module piCaseBottom() {
    union() {
        base(); 
        spacers(spacerBottomHeight,0);
        connectors(connectorHeight);
    }
}

// top of a pi case with an optional ornament pattern
module piCaseTop() {
    union() {
        base();
        spacers(spacerTopHeight,-spacerTopHeight);
    }
}


// center of a stackable pi with top and buttom spacers
module piCaseCenter() {
    union() {
        piCaseBottom();
        piCaseTop();
    }
}

// print of a final case with n (parts) pi's
module piStackedCase(parts=1){
    piCaseBottom();
    if (parts>1) {
        for (i = [2 : parts]) {
            translate([0, 0,partOffset*(i-1)]) 
                piCaseCenter();            
        }
     }
    translate([0, 0, partOffset*parts]) 
        piCaseTop();
}


// print of a  final single case
module piCase() {
    piStackedCase(1);
}


// test print to make sure that the spacer and connector fit
module testSpacerAndPin() {
    spacer(5,5);

     translate([10,0,0]) {
         union() {
            spacer(5,5);
            translate([holePos,holePos,0]) 
                connector(connectorHeight);
         }
     }
 }
 
 // test print to check the location of the holes in the pi
 module testDimensions() {
    spacers(1,0);
    connectors(4);
 }


//piCaseBottom(); 
// piCaseTop();
// testDimensions();
// testSpacerAndPin();
piStackedCase(numberOfPis);
