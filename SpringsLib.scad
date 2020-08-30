/**
* An edge (or line) between 2 nodes
*/
module line(start, end, d, fn=4) {
  hull() {
    node(start,d, fn);
    node(end,d, fn);
  }      
}

/**
* A single node which is connected by edges
*/

module node(pos, d, fn=4) {
  if (pos[0]!=undef && pos[1] != undef && pos[2] != undef){ 
    translate(pos) sphere(d=d, $fn = fn);    
  }
}
/**
* Basic logic for generating a 3d spring
*/ 

module spring(d, dBottom=6, dTop=6, windings=2, height=10, steps=10, wireDiameter=1,fn=10) {
    // we use either d or dBottom&dTop
    r0 = d != undef ? d/2 : dBottom/2;
    r1 = d != undef ?d/2 : dTop/2;
    
    rx = (r0-r1) / (360.0*windings);    
    heightPerDegree = height/windings/360;
    
    for ( angle = [steps : steps : 360*windings] ){
        r = r0 - (angle * rx); 
        x0=r*cos(angle-steps);
        y0=r*sin(angle-steps);
        z0=(angle-steps)*heightPerDegree;
        x=r*cos(angle);
        y=r*sin(angle);
        z=angle*heightPerDegree;

        line([x0,y0,z0],[x,y,z],d=wireDiameter,fn=fn);        
    }
}/**
* 3D Spring with identical diameter at top and bottom. The top and boton might
* start with a flat circle
*/
module spring3D(d=5,windings=3,height=10,flatStart=true,flatEnd=true, wireDiameter=1,  fn=4) {  
    spring(d=d, windings=windings,height=height, fn=fn);
    
    if (flatStart)
        spring(dBottom=d,dTop=d,windings=1,height=0, fn=fn);
    if (flatEnd)
        translate([0,0,height]) spring(dBottom=d,dTop=d, windings=1,height=0, fn=fn);

}/**
* Generate Support for the 3D Spring
*/
module spring3DSupport(d=5,height=10,supportDiameter=0.6, fn=4){
    // generate support
    dist=(d/2)*cos(0);
    translate([0,-dist,0])  cylinder(h=height,d=supportDiameter, $fn=fn);
    translate([0,dist,0])  cylinder(h=height,d=supportDiameter, $fn=fn);
}/**
* Flat "clock" Spring
*/
module springSpiralTorsion(d=15,innerD=6, windings=5,wireDiameter=0.7,fn=4) {
    // outer ring
    spring(dBottom=d,dTop=d,windings=1,height=0,wireDiameter=wireDiameter,fn=fn);
    // windings
    spring(dBottom=d,dTop=innerD,windings=windings,height=0,wireDiameter=wireDiameter,fn=fn);
    // inner ring
    spring(dBottom=innerD,dTop=innerD,windings=1,height=0,wireDiameter=wireDiameter,fn=fn);
}/**
* Flat 2d Spring with a sinusoidal shape
*/ 
module springSine(length=20, width=10, windings=4, steps=10, wireDiameter=0.7, fn=4){
    dx = length / (360 * windings);
    for(i = [steps : steps : 360 * windings]){
        x0 = (i-steps) * dx;
        y0 = sin(i-steps) * width/2;
        x = i * dx;
        y = sin(i) * width/2;        
        line([x0,y0,0],[x,y,0],d=wireDiameter,fn=fn);        
    }
}
/**
* Flat 2d Spring with a triangular shape
*/
module springTriangle(length=20, width=10, windings=4, wireDiameter=0.7, fn=4){
    // generate poins only every 90 degrees
    springSine(length=length,width=width, windings=windings, steps=90, wireDiameter=wireDiameter,fn=fn);
}
/**
* An edge (or line) between 2 cylinders
*/
module line3D(start, end,d=1,h=10, fn=4) {
  hull() {
    translate(start) cylinder(h=h, d=d, $fn = fn);    
    translate(end) cylinder(h=h, d=d, $fn = fn);    
  }      
}

/**
* 3d Spring with a sinusoidal shape
*/ 
module springSine3D(length=20, heigth=10, width=10, windings=4, steps=10, wireDiameter=0.7, fn=4){
    dx = length / (360 * windings);
    for(i = [steps : steps : 360 * windings]){
        x0 = (i-steps) * dx;
        y0 = sin(i-steps) * width/2;
        x = i * dx;
        y = sin(i) * width/2;        
        line3D([x0,y0,0],[x,y,0],d=wireDiameter,h=heigth, fn=fn);  
    }
}

/**
* 3d Spring - we generate an hollow Ellipse
*/ 
module springLeaf(width=3,len=10,height=5,thickness=1){
 scale([len/10,height/10,1]) difference() {
     cylinder(h=width, r=10, center=true);
     cylinder(h=width+2, r=10-thickness, center=true);
  }
}

