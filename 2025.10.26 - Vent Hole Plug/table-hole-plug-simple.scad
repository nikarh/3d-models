include <BOSL2/std.scad>


$slop=0.1;
$fa=1;
$fs=1;

tube_d = 102;
tube_w = 0.8;
tube_h = 16;
profile_h = 0.6;

fan_side = 120;
fan_chamfer = 3.3;
fan_chamfer_r = 3; // roundover over chamfer

fins_enable = true;
fin_w = 0.4;

screw_h_dist = 105/2; // x/y displacement of screw hole from [0,0];

screw_h_d = 4; // diameter
screw_h_c = 1; // chamfer


// Main tube
tube(h=tube_h, od=tube_d, id=tube_d - tube_w*2) {
    if (fins_enable) {
        arc_copies(d=tube_d, n=9, sa=0, ea=360)
        cube([fin_w, fin_w, tube_h], center=true);
    }
        
    // Attach fan profile
    attach(TOP, CENTER, inside=false) linear_extrude(h = profile_h) {
        difference() {
            polygon(
                // Rounder chamfer
                round_corners(
                    // Add chamfer
                    round_corners(
                        square(fan_side, center=true),
                        method="chamfer", cut=fan_chamfer
                    ),
                    r=fan_chamfer_r
                )
            );
            circle(d=tube_d-tube_w*2);
            
            for (i = [[1,1,0], [1,-1,0], [-1,-1,0], [-1,1,0]]) {
                move(i*screw_h_dist)circle(d=screw_h_d);
            }
        }
    }
}
