include <BOSL2/std.scad>
include <../modules/box/v1.scad>

$fa = 1;
$fs = $preview ? 3 : 0.25;

// h, recess_margin, floor, draw
// sizes = [12, 6, 0, HIDE_HINGES];
sizes = [28 + 0.8, 14, 0.8, LID];

// Hinges & Grip
hinge_count = 2;
hinge_margin = 10;
grip_l = 22; // length of a grip recess

// Box size
wall_tolerance = 0.2; // Add this to main wall thickness (and ultimately size) to account for expansion due to recess
l = 154;
w = 88 + wall_tolerance * 2;
h = sizes[0];
radius = 9;
wall_t = 1.6 + wall_tolerance; // Main wall thickness
floor_t = sizes[2]; // Main box floor thickness

// Lid
lid_oversize = 5;
lid_tolerance = 0; // Make lid larger than a box in both X and Y axis by that amount
lid_vertical_clearance = 0.4; // When closed, distance between boxes skirt and lids edges
lid_floor_t = 1.6; // Lid floor thickness
lid_wall_t = 0.8;

// Recess carved from the box
recess = [8, 1.2, 1.8]; // Recess dimensions
recess_margin = sizes[1]; // margin from the floor to recess
recess_margin_r = 25; // distance from corner to recess
recess_margin_c = 54; // margin between two recesses

// Insert props
insert_l = 114; // length of the insert with bits
sep_t = 1.0; // Thickness of the inner wall/separator

// Screwdriver box

difference() {
  box_v1(
    size=[l, w, h - lid_oversize],
    grip_l=grip_l,
    wall_t=wall_t,
    floor_t=floor_t,
    lid_wall_t=lid_wall_t,
    lid_floor_t=lid_floor_t,
    lid_tolerance=lid_tolerance,
    lid_oversize=lid_oversize,
    lid_vertical_clearance=lid_vertical_clearance,
    hinge_count=hinge_count,
    hinge_margin=hinge_margin,
    draw=sizes[3],
  ) {
    move([l / 2 - wall_t - sep_t / 2 - insert_l, 0, h / 2])
      cuboid(
        [sep_t, w - wall_t * 2, h], rounding=5, edges=[TOP + FWD, TOP + BACK]
      );
  }

  recess_dx = l / 2 - recess[0] / 2 - wall_t - recess_margin_r;
  recess_dx2 = recess_dx - recess_margin_c - recess[0];
  recess_dy = w / 2 - recess[1] / 2 - wall_t + recess[1];
  recess_dz = h - recess[2] / 2 - recess_margin;

  move([recess_dx, recess_dy, recess_dz]) cuboid(recess);
  move([recess_dx, -recess_dy, recess_dz]) cuboid(recess);
  move([recess_dx2, recess_dy, recess_dz]) cuboid(recess);
  move([recess_dx2, -recess_dy, recess_dz]) cuboid(recess);
}
