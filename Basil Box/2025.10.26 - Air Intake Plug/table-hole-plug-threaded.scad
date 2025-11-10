include <BOSL2/std.scad>
include <BOSL2/threading.scad>


$slop=0.1;
$fa=1;
$fs=1;

tube_d = 102;
tube_w = 0.8;
tube_h = 15;
margin_d = 120;
margin_h = 0.6;

fins_enable = false;
fin_w = 1;

// Threading
t_p = 5; // pitch
t_d = tube_d - tube_w*2; // diameter of threading
t_m = 0.1; // nut-rod margin of error
t_depth = 1; // threading depth
b_t_d=t_d - t_depth*2-tube_w*2; // bottom threaded rod diameter


// Top cap
union() {tube(h=tube_h, od=tube_d, id=tube_d - tube_w*2) {
    if (fins_enable) {
        arc_copies(d=tube_d, n=9, sa=0, ea=360)
        cube([fin_w, fin_w, tube_h], center=true);
    }
        
    // Attach top edge
    attach(TOP, TOP, inside=false)
        tube(h=margin_h, od=margin_d, id=t_d);
}

// Top cap threading
difference() {
    threaded_nut(
        //thread_depth=t_depth,
        nutwidth=tube_d+10, id=t_d, h=tube_h, pitch=t_p,
        blunt_start=false
    );
    tube(h=tube_h, id=tube_d, od=tube_d+50);
}
}

color("red") zrot(180) left(margin_d+2)


// Bottom cap, remove cyllinder from threaded rod

zflip() diff() threaded_rod(
        //thread_depth=t_depth-t_m,
        d=t_d-t_m, l=tube_h, pitch=t_p,
        blunt_start=false
) {
    // Attach bottom edge
    attach(BOT, TOP, ) tag("base")
        tube(h=margin_h, od=margin_d, id=b_t_d);
    tag("remove") cyl(h=tube_h, d=b_t_d);
}