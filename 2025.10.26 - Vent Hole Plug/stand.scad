include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/walls.scad>

e = 0.01; // epsilon
e2 = e*2;

fan_h = 25.5; // fan height
stand_h = 0.6; // fan is raised by that amount
clearance = 10; // additional clearance for fan

leg_h = fan_h+stand_h+clearance;

fan_s = 120; // size of the fan
leg_r = 3.5; // radius of the leg
leg_c = -3; // leg chamfer
leg_off = leg_r/2-leg_c*sqrt(2) + 5; // leg offset

pf_l = 190; // length of the floor
pf_w = 210; // width of the floor
pf_h = 3.6; // height of the floor

strt = 3.4; // hex strut
spcng = strt*6;  // hex spacing

fan_shift = [-(pf_l-fan_s)/2, -(pf_w-fan_s)/2,0];

// Main hex
diff() hex_panel([pf_l, pf_w, pf_h], strt, spcng) {
    tag("remove") move(fan_shift)
        cube([fan_s-strt*2, fan_s-strt*2, pf_h+e2], center=true);
}

// Hex above fan, make it more loose
strt2 = 1.2; // hex strut
spcng2 = strt2*6;  // hex spacing
move(fan_shift) hex_panel([fan_s, fan_s, pf_h], strt2, spcng2, frame=strt/2);

// Legs
legs = [
    [pf_l/2 - leg_off, -pf_w/2 + leg_off, 0], // bottom right
    [pf_l/2 - leg_off, 0, 0], // center right
    [pf_l/2 - leg_off, pf_w/2 - leg_off, 0], // top right
    [-pf_l/2 + leg_off, pf_w/2 - leg_off, 0], // top left
    [0, pf_w/2 - leg_off, 0], // top center
    //[0, (pf_w/2 + leg_off) - (pf_w-fan_s), 0], // center
    //[-pf_l/2 + leg_off, (pf_w/2 + leg_off) - (pf_w-fan_s), 0], // center left
    //[pf_l/2 + leg_off - (pf_l-fan_s), -pf_w/2 + leg_off, 0], // cente right
];
for (p = legs) {
    move(p) down(leg_h/2 + pf_h/2) zrot(45) 
        regular_prism(
            4,r=leg_r,h=leg_h,
            chamfer1=leg_c,chamfer2=leg_c,chamfang=60
        ) align(TOP) zrot(45) regular_prism(
            //cube([leg_off*2, leg_off*2, strt])
            6, r=leg_off*1., h=strt
        );
}

// Short legs

short_legs = [
    [-pf_l/2 + leg_off/2, -pf_w/2 + leg_off/2, 0], // left bottom
    [-pf_l/2 + leg_off/2, -pf_w/2 - leg_off/2 + fan_s, 0], // left top
    [-pf_l/2 - leg_off/2 + fan_s, -pf_w/2 + leg_off/2, 0], // right bottom top
    [-pf_l/2 - leg_off/2 + fan_s, -pf_w/2 - leg_off/2 + fan_s, 0], // right bottom top
    [-pf_l/2 + (fan_s/2), -pf_w/2 + (fan_s/2), 0], // center
];

for (p = short_legs) {
    move(p) down(clearance/2 + pf_h/2) zrot(45) 
        regular_prism(
            4,r=leg_r,h=clearance,
            chamfer1=leg_c,chamfang=60
        ) align(TOP) zrot(45) cube([leg_off, leg_off, strt]);
}