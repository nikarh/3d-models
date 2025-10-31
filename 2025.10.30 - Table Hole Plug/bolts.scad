include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/screw_drive.scad>

l=10;

for (x=[
    [8,1.20, 0.4,1],
    [8,1.10, 0.4,2],
    [8,1.00, 0.4,3],
]) {

    d=x[0];
    p=x[1];
    slop=x[2];
    i=x[3];
    left=i*16;

    left(left) diff() threaded_rod(
        bevel2=1,
        bevel1=0,
        d=d, l=l, pitch=p,
        $slop=slop,
        $fa=0.1, $fs=0.4,
    ) {

        align(BOTTOM)
            zcyl(h=3, d=d+5, $fn=64, chamfer2=1)
        attach(BOTTOM, TOP, inside=true) down(0.1)
            phillips_mask(size="#1");
            
        rot_copies(n=i, v=DOWN, delta=[(d+5)/2,0,0])
            down(l/2 + 3) cube(1);
    }
}