include <BOSL2/std.scad>
include <BOSL2/sliders.scad>

$fa = 0.5;
$fs = 0.5;

w = 2;
tube_h = 45;

rack_tube_d = 40;
rack_tube_od = rack_tube_d + w * 2;

vacuum_tube_d = 55;
vacuum_tube_od = vacuum_tube_d + w * 2;

cut_w = 1.2;

slop = 0.2;
rail_floor_h = 4;

// Tack tube

ydistribute(spacing=vacuum_tube_d) {

  diff() tube(h=tube_h, od=rack_tube_od, id=rack_tube_d) {
    // Rail to be held in slider
    attach(LEFT, BOTTOM, align=BOTTOM)
      rail(l=tube_h - rail_floor_h);
    // Additional cube to glue tube to the rail
    attach(LEFT, BOTTOM, align=BOTTOM, inside=true)
      tag("body") cube([10, tube_h - rail_floor_h, w]);

    // Cutout
     left(16) tag("remove") attach(LEFT, FRONT, inside=true)
        cube([cut_w, 30, tube_h + w]);
  }

  // Vacuum tube
  diff() tube(h=tube_h, od=vacuum_tube_od, id=vacuum_tube_d) {
      // Slider to hold everything in place
      attach(LEFT, BOTTOM, overlap=w + 3)
        slider(l=tube_h, base=4, wall=4, $slop=0.2, w=11.2) {
          tag("keep") down(2) attach(BACK, TOP, inside=true)
                cuboid([14, 14, rail_floor_h]);
        }
    }
}
