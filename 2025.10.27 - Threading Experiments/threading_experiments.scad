include <BOSL2/std.scad>
include <BOSL2/threading.scad>


module set(d, h, slop) {
    diff()
    threaded_nut(
        nutwidth=d+8, id=d, h=h, pitch=1.25, $slop=slop, $fa=1, $fs=1
    ) tag("remove") tube(h=h+2, id=d+3, od=d+20);
        

    left(d + 4) zrot(168)
    diff()
    threaded_rod(
        d=d, l=h, pitch=1.25, left_handed=false, $fa=1, $fs=1
    ) {
        tag("base") align(TOP) zcyl(h=1, d=d+2, $fn=60) {
            tag("remove") up(0.001)align(TOP, inside=true)
                cube([6,1.3,0.6]);
            tag("remove") up(0.001)align(TOP, inside=true)
                zrot(90) cube([6,1.3,0.6]);
        }
        tag("remove") zcyl(h=h, d=d-2.4, $fn=60);
    }
}

for (s = [
    [3,3, -35], 
    [4,4, -25], 
    [6,6, -14], 
    [8,8, 0], 
    [10, 8, 13],
    [15, 8, 30],
    [25, 8, 55]
]) {
    fwd(s[2]) set(s[0], s[1], 0.26);
}

