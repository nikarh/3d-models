// A stand to hold 120 mm CPU fan on a table.
// I use it to exhaust fumes when soldering.

include <BOSL2/std.scad>


fan_s = 120;  // side of the fan
fan_d = 118;  // fan diameter
fan_h = 25.4; // height of the fan

add_len = 40;

base_l = add_len*2 + fan_h;
base_w = fan_s + 10;
base_h = 2;
base_r = 4; // rounding

wall_h = 25;
wall_w = 1.6;
wall_r = 4;
cutout_r = 8;

up(base_h/2) linear_extrude(base_h, center=true)
    diff() rect([base_l, base_w], rounding=base_r, $fn=48) {
        tag("remove")
            ycopies(2, base_w/2 -5)
            rect([base_l-10, 1], rounding=0.5);
    }

left(fan_h/2+wall_w/2) up(wall_h/2 + base_h) yrot(90)
    linear_extrude(wall_w, center=true)
        top_bar();

right(fan_h/2+wall_w/2) up(wall_h/2 + base_h) yrot(90)
    linear_extrude(wall_w, center=true)
        top_bar();

        
module top_bar() {
    intersection() {
        round2d(cutout_r, $fn=36) difference() {
            rh = fan_s-wall_r*2;
            left(wall_h/2) fwd(fan_s*2) square(fan_s*4);
            left(fan_s/2 - wall_h/2) circle(d=fan_d, $fn=48);
        }
        right(base_h/2) rect([wall_h + base_h, fan_s], rounding=[0,1,1,0] * base_r, $fn=48);
    }

}