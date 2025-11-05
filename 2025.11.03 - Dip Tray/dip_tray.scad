include <BOSL2/std.scad>

// A tiny tray to fit my smd components in a plastic box compartment

h = 4.6;
l = 32;
w = 30;

wall = 0.3;

diff() cuboid([l, w, h])
    attach(TOP, TOP, align=FWD, inside=true)
      cuboid([l -wall*2, w-wall, h-wall]);
