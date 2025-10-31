include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/screw_drive.scad>

d=4;
h=3;
slop=0.2;



ycopies(spacing=d+8-0.4, 2) xcopies(spacing=d+8-0.4, 2) threaded_nut(
    shape="square",
    nutwidth=d+8, id=d, h=h, pitch=1.25,
    ibevel2=0,
    bevel=0,
    $slop=slop, $fa=0.1, $fs=0.4
);

left(17)
diff() threaded_rod(
    bevel2=0,
    bevel1=-1,
    d=d, l=h, pitch=1.25, left_handed=false, $fn=32
) align(BOTTOM) zcyl(h=14, d=d+0.64, $fn=32, chamfer1=-1)
   attach(BOTTOM, TOP, inside=true) down(0.1) phillips_mask(size="#1");