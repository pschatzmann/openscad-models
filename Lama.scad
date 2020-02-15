/**
  Cork Pal - Customizable Lama

  by Phil Schatzmann 
  
**/

 
corkDiameterFront=21;
corkDiameterBack=21;
legHeight=19;
neck=25;
cylinderHeight=6;



module body(corkDiameter) {
     cylinder(h=cylinderHeight, d=corkDiameter+2, center=false,$fn=80);
}

module bodyHole(corkDiameter) {
    cylinder(h=cylinderHeight+5, d=corkDiameter,$fn=50);
}
 
module legs(corkRadius) {
    translate([corkRadius/2-4,4,3]) rotate([0,90,0]) 
        cylinder(legHeight+11,2,1,$fn=8);
    translate([corkRadius/2-4,-4,3]) rotate([0,90,0]) 
        cylinder(legHeight+11,2,1,$fn=8); 
}
 
module back() {
    difference() {
        union() {
            body(corkDiameterBack);
            legs(corkDiameterBack);
            translate([-(corkDiameterBack/2+2),0,3]) 
                sphere(r=2);
        }
        translate([0,0,-5]) bodyHole(corkDiameterBack);
    }
}
 

module frontSolid() {
    union() {
        hull() {
            body(corkDiameterFront);
            translate([-7,0,8]) 
                sphere(2);
        }
        hull() {
            translate([-7,0,8]) 
                sphere(2);
        
            translate([-neck,0,14]) 
                sphere(1);                 
        }  
        hull() {
            translate([-neck,0,14]) 
                sphere(4);  
            translate([-neck+3,0,24]) 
                sphere(2);    
        }
        translate([-neck-4,-1.5,15]) rotate([0,90,0]) 
             cylinder(h=4, d1=2, d2=2, center=true);
        translate([-neck-4,1.5,15]) rotate([0,90,0]) 
             cylinder(h=4, d1=2, d2=2, center=true);

        
        translate([0,0,cylinderHeight-6]) 
            legs(corkDiameterFront);
        }
}

module front() {
     difference() {
        frontSolid();
        translate([0,0,-5])  
           bodyHole(corkDiameterFront);

    }
}

module printAll() {
    difference() {
        union() {
            if (corkDiameterBack>0){
                translate([-cylinderHeight-0.5, 0,legHeight+11]) rotate([0,90,0])  
                    back();
            }
            if (corkDiameterFront>0){
                translate([0,0,legHeight+11]) rotate([0,90,0]) 
                    front();
            }
        }
        // make feet levelled
        translate([-500,-500,-100]) cube(size=[1000,1000,100]);
    }
}



printAll();
