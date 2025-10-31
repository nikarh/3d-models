// A hole plug in IKEA table for legs
// of a mini drawing board

include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/screw_drive.scad>


$slop=0.1;
$fa=1;
$fs=1;

tube_d = 18.8; // Tube external diameter
tube_id = 16.2; // Tube internal diameter
tube_w = (tube_d-tube_id) / 2; // Wall width
tube_h = 22;
margin_d = tube_d+6;
margin_h = 0.6;

fins_enable = false;
fin_w = 0.7;
slop = 0.2;

t_pitch=1;

bolt_d = tube_id - 3;   // make bolt narrower
bolt_h = tube_h - 16.8; // 16.5 is insert

up_s_p=1.2;
up_s_d=7.8;
up_s_h=8;

test=false;

if (!test) {

// Top cap
diff() tube(h=tube_h, od=tube_d, id=tube_d - tube_w*2) {
    
    // Decrease inner d
    tag("remove") attach(BOTTOM, TOP, inside=true)
        tube(h=3.4, id=tube_id+1, od=tube_d+1);
        
    // Attach top edge
    attach(TOP, TOP, inside=false)
        tube(h=margin_h, od=margin_d, id=tube_id);
    
    
    if (fins_enable) {
        arc_copies(d=tube_d, n=9, sa=0, ea=360)
        cube([fin_w, 0.4, tube_h], center=true);
    }
};

// Threadin in tube
intersection() {
    down((tube_h-bolt_h)/2) threaded_nut(
        shape="square",
        nutwidth=tube_id+8,
        id=bolt_d,
        ibevel1=1,
        ibevel2=1,
        h=bolt_h,
        pitch=t_pitch,
        $slop=slop, $fa=0.1, $fs=0.4
    );
    cyl(h=tube_h, d=tube_id+1);
}


left(40) diff() threaded_rod(
    bevel2=1,
    bevel1=0,
    d=bolt_d + 0.2,
    l=bolt_h,
    pitch=t_pitch,
    $fa=0.1, $fs=0.4
) {
    attach(TOP, TOP)
        threaded_rod(
            bevel2=0,
            bevel1=1,
            d=up_s_d,
            l=up_s_h,
            pitch=up_s_p,
            $slop=0.6,
            $fa=0.1, $fs=0.4
        );

    align(BOTTOM)
        zcyl(h=2, d=tube_d+10, $fn=64, chamfer2=-1)
    attach(BOTTOM, TOP, inside=true) down(0.1)
        phillips_mask(size="#3");
}
}

if (test) {
intersection() {
    threaded_nut(
        shape="square",
        nutwidth=tube_id+8,
        id=bolt_d,
        h=bolt_h,
        ibevel1=1, ibevel2=1,
        pitch=t_pitch,
        $slop=slop,
        $fa=0.1, $fs=0.4
    );

    cyl(h=tube_h, d=tube_id+1);
}

left(20) diff() threaded_rod(
    bevel2=1,
    bevel1=0,
    d=bolt_d,
    l=bolt_h,
    pitch=t_pitch,
    $fa=0.1, $fs=0.4
)
    attach(BOTTOM, TOP, inside=true) down(0.1)
        phillips_mask(size="#2");

}