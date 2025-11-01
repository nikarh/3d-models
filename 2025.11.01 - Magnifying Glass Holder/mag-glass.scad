include <BOSL2/std.scad>

$fa = 0.5;
$fs = 0.5;

// 74.4
glass_d = 74.8; // diameter of magnifying glass
glass_m_h = 2.5; // height of magnifying glass frame
glass_a = 15; // angle of magnifying glass frame

f_w = 2; // width of my frame
f_h = 13.6; //13.6; // height of my frame
f_id = glass_d; // inner diameter of my frame
f_od = f_id + f_w * 2; // outer diameter of my frame

// Rounding for beauty
ro = 2;

cutout = 0.2; // cutout for glass fitting
han_d = 12; // diameter of the handle
han_hol_h = 10; // height of the handle holder
han_joint_s = 4; // size of the handle joint square
han_joint_h = 8; // height of the handle joint
han_joint_s_loose = 3.6; // size of the handle joint square with some tolerance
han_joint_h_loose = 7.6; // height of the handle joint with some tolerance

han_plane_h = han_hol_h - 0.6;
han_plane_fill_w = 0.8; // width of the plane to fill the gap in the handle joint

m3_d = 2.8; // diameter of m3 screw
m3_d_loose = 3; // diameter of m3 screw hole with some tolerance
m3_head_d = 7.8; // diameter of m3 screw head
m3_head_depth = 2.7; // depth of m3 screw head
m3_nut_d = 6.4; // diameter of m3 nut
m3_nut_depth = 2.4; // depth of m3 nut

// Outermost frame for debug
*color("yellow") tube(
    od=f_od,
    id=glass_d,
    h=f_h,
    rounding=ro
  );

// Magnifying glass holder
diff() {
  // The ring
  // Top and bottom tubes to sandwich the glass
  zflip_copy((f_h - glass_m_h) / 4 + glass_m_h / 2) tube(
      od1=f_od,
      id1=glass_d - 3, // was -2
      od2=f_od,
      id2=glass_d,
      h=(f_h - glass_m_h) / 2,
      ichamfer1=0.9, // Hope this is enough for the angle
      rounding2=ro,
    );

  // Wider middle tube that will hold the glass
  tube(od=f_od, id=glass_d, h=glass_m_h) {
    // Locking mechanism
    back(/* merge handle in the disc a bit*/ 1.4) attach(FWD, TOP)
        cyl(d=han_d, h=han_hol_h) {
          // d10?
          // Cutout for m3 screw
          attach(LEFT, TOP, inside=true) cyl(d=m3_d, h=han_hol_h + 2);
          // Cutout for nut
          attach(LEFT, TOP, inside=true) regular_prism(6, d=m3_nut_d, h=m3_nut_depth);
          // Cutout for weird screw head
          attach(RIGHT, TOP, inside=true) cyl(d=m3_head_d, h=m3_head_depth);

          // Cutout handle
          attach(BOTTOM, TOP, inside=true)
            cuboid([han_joint_s, han_joint_s, 8]);
        }
  }

  // Cutout so that glass can actually be inserted
  tag("remove") fwd(glass_d / 2) cuboid([cutout, f_h + 50, f_h + 1]);
}

module handle_lock() {
  // Latch
  diff() cuboid([han_joint_s_loose, han_joint_s_loose, han_joint_h_loose]) {
      // A plane to fill the gap
      tag("body") attach([0, 0, 0], TOP) down(han_plane_h) up(han_joint_h_loose / 2)
            cuboid([han_plane_fill_w, han_d, han_plane_h]);
      // screw hole
      down(han_hol_h / 2) up(m3_d_loose / 2) left(1) attach(LEFT, TOP, align=TOP, inside=true) cyl(d=m3_d_loose, h=han_hol_h);
    }
}

// Handle
left(60) cyl(d=han_d, l=80) {
    // Fitting for cutout in holder
    attach(TOP, TOP) handle_lock();
  }

left(100) cyl(d=han_d, l=10) {
    attach(BOTTOM, TOP) cyl(d1=5, d=5, h=15);
    // Fitting for cutout in holder
    attach(TOP, TOP) handle_lock();
  }
