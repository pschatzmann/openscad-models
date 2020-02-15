

 
corkRadiusFront=10;
corkRadiusBack=10;
mouthLen = 16;
legHeight=40;
cylinderHeight=10;



module body(corkRadius) {
     cylinder(h=cylinderHeight, r=corkRadius+1, center=false,$fn=80);
}

module bodyHole(corkRadius) {
    cylinder(h=cylinderHeight, r=corkRadius,$fn=50);
}
 
module legs(corkRadius) {
    translate([corkRadius-4,5,3]) rotate([0,90,0]) 
        cylinder(legHeight,3,1.5,$fn=8);
    translate([corkRadius-4,-5,3]) rotate([0,90,0]) 
        cylinder(legHeight,3,1.5,$fn=8); 
}
 
module back() {
     difference() {
        union() {
            body(corkRadiusBack);
            legs(corkRadiusBack);
            translate([-(corkRadiusBack+2),0,3]) 
                sphere(r=4);
        }
        translate([0,0,2]) bodyHole(corkRadiusBack);
     }
 }
 

module frontSolid() {
    union() {
            hull() {
                body(corkRadiusFront);
                translate([-10,0,13]) 
                    sphere(2);
            }
            hull() {
                translate([-10,0,13]) 
                    sphere(2);
            
                translate([-60,0,24]) 
                    sphere(2);            
            }  
    }
    translate([0,0,cylinderHeight-6]) 
        legs(corkRadiusFront);
}

module front() {
     difference() {
        frontSolid();
        translate([0,0,0])  
           bodyHole(corkRadiusFront);

    }

}

  
 
module printAll() {
    if (corkRadiusBack>0){
        translate([0,-20,0]) back();
    }
    if (corkRadiusFront>0){
        translate([0,20,0]) front();
    }
}



printAll();
