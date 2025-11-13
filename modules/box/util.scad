include <BOSL2/std.scad>

HINGE_BOX = 1;
HINGE_LID = -1;

// A cuboid with rounding
module rounded_box(
  l, // length along X axis
  w, // width along Y axis
  h, // height along Z axis
  br = 0, // border radii top down view
  top, // top chamfer
  bottom // bottom chamfer
) {
  shape =
    (br > 0) ? round_corners(rect([l, w]), radius=br)
    : rect([l, w]);

  offset_sweep(
    shape,
    height=h,
    check_valid=false, steps=4,
    top=top, bottom=bottom,
  );
}

// A cuboid minus smaller cuboid with offset
module hollow_box(
  l, // length along X axis
  w, // width along Y axis
  h, // height along Z axis
  wt, // wall thickness
  ft, // floor thickness
  br = 0, //  border radii top down view
  outer_top = undef, // outer top chamfer
  inner_top = undef, // inner top chamfer
  outer_bottom = undef, // outer bottom chamfer
  inner_bottom = undef, // inner bottom chamfer
) {
  epsilon = 0.01; // helps with visual artifacts before render

  _inner_bottom = (ft > 0 && !is_def(inner_bottom)) ? outer_bottom : inner_bottom;
  _ft = (ft == 0) ? -epsilon : ft;

  difference() {
    // Body of the box
    rounded_box(
      l=l, w=w, h=h, br=br,
      top=outer_top, bottom=outer_bottom
    );

    // Remove the insides
    up(_ft) // Bump it up for floor thickness
      rounded_box(
        l=l - wt * 2, w=w - wt * 2, h=h - ft + epsilon * 2, br=br - wt,
        top=inner_top,
        bottom=_inner_bottom
      );
  }
}

// A 3d teardrop with rounding and a cylindrical cutout
module hinge(
  l, // length of the hinge
  d = hinge_d, // outer diameter of the hinge
  hole_d = hinge_hole_d, // hole diameter
  ang = 45, // teardrop angle
  direction = 1, // 1 means teardrop is facing down, -1 is facing up
) {
  difference() {
    // Sweep a teardrop2d instead of using plain teardrop
    // in order to have better control over chamfer function
    down(l / 2) offset_sweep(
        teardrop2d(d=d, ang=ang / 2),
        height=l,
        top=os_chamfer(0.4, angle=45),
        bottom=os_chamfer(0.4, angle=45),
      );

    // Cutout a teardrop instead of a cylinder in order
    // to reduce the angle of overhangs
    zrot(180) xrot(90)
        yrot(direction * ang / 2)
          teardrop(d=hole_d, h=l + 2, cap_h=0.6);
  }
}

// Create a skirt around the box
module skirt(
  l, // length of the skirt
  w, // width of the skirt
  h, // height of the skirt
  t, // thickness of the skirt
  gl, // length of a recess
  br = 0, // border radius of the skirt
  bottom = undef, // outer bottom chamfer
) {
  r2 = t / 2.1;
  difference() {
    move([-l / 2, -w / 2]) offset_sweep(
        round_corners(
          [
            [0, 0],
            [0, w],
            [l, w],
            [l, 0],
            [(l + gl) / 2, 0], // recess
            [(l + gl) / 2, t], // recess
            [(l - gl) / 2, t], // recess
            [(l - gl) / 2, 0], // recess
          ],
          radius=[br, br, br, br, r2, r2, r2, r2]
        ),
        height=h,
        steps=8, // chamfer steps
        bottom=bottom,
      );

    down(1) rounded_box(l=l - t * 2, w=w - t * 2, h=h + 2, br=br - t);
  }
}
