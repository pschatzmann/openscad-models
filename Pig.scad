/**
  Cork Pal - Parametrized Pig

  by Phil Schatzmann 
  
**/
 
corkRadiusFront=11.5;
corkRadiusBack=10;
mouthLen = 16;
mountR1 = 4;
mouthR2 = 9;
legHeight=15;
cylinderHeight=8;



module body(corkRadius) {
     cylinder(h=cylinderHeight, r=corkRadius+1, center=false,$fn=80);
}

module bodyHole(corkRadius) {
    translate([0,0,2]) 
        cylinder(h=200, r=corkRadius,$fn=50);
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
                sphere(r=3);
        }
        bodyHole(corkRadiusBack);
     }
 }
 
module face(corkRadius) {
    difference() {
        union() {
            eye(corkRadius, 4);
            eye(corkRadius, -4);
            translate([3,0,0])
                cylinder(h=mouthLen, r1=mountR1, r2=mouthR2, center=true);
        }
        nose();
    } 
}

module eye(corkRadius, pos) {
    translate([-(corkRadius-3),pos,0]) 
        sphere(r=1,$fn = 20); 
}

module nose() {
    union() {
        translate([3,mountR1/2,1]) 
            cylinder(h=400,r=1,$fn = 20,center=true);
        translate([3,-mountR1/2,1]) 
            cylinder(h=400, r=1,$fn = 20,center=true); 
    }
}

module ear() {
    difference() {
        sphere(r = 3);
        translate([0,0,-3])  
            sphere(r = 3);
    }
}

module ears() {
    translate([-corkRadiusFront,-8,2])
        ear();
    translate([-corkRadiusFront,8,2])
        ear();
}
  
module head() {
     translate([0,0,cylinderHeight]) rotate([180,0,0]) {
         difference() {
            union() {
                body(corkRadiusFront);
                translate([0,0,cylinderHeight-6]) legs(corkRadiusFront);
                face(corkRadiusFront);
                ears();
            }
            bodyHole(corkRadiusFront);
         }
     }
}
 
module printAll() {
    max = max(corkRadiusFront,corkRadiusBack)+5;
    if (corkRadiusBack>0){
        translate([0,-max,0]) back();
    }
    if (corkRadiusFront>0){
        translate([0,max,0]) head();
    }
}


printAll();
