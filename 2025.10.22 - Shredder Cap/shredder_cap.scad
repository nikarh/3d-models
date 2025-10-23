include <BOSL2/std.scad>

t_w = 12.2;
t_l = 46.5;
t_h = 3.7;
t_wall = 1.7;
t_wall2 = 1.4;

t_br = t_w / 2;

sq_w = 8.4; // 6? 5.6?
sq_l = 10; //7.5
sq_wall = 1.35;
sq_hh = 5.7 + (t_h - t_wall); // 9.8 = t_h + sq_h - t_wall
sq_h = 5.7 + 2;

han_l = 6;
han_h = 4;
han_r = han_h/2;

// Top lid
difference() {
    // Solid block
    offset_sweep(
        rect([t_w, t_l], rounding=t_br, $fn=32),
        h=t_h,
        top=os_circle(r=1),
        steps=3
    );
    // Smaller pill
    down(1) linear_extrude(height=t_h-t_wall + 1)
        rect([t_w - t_wall2*2, t_l -t_wall2*2], rounding=t_br-t_wall2, $fn=32);
}

// Tube chamber
down(sq_hh/2 + t_wall)
    rect_tube(
        size=[sq_w, sq_l], 
        wall=sq_wall, h=sq_hh, 
        rounding=1, irounding=0, $fn=10);
        

// Handle tip
up(han_h/2 + t_h) top_half() cuboid([t_w, han_l, han_h], rounding=1, $fn=32);

// Handle lower part
han_body_h = han_h/2 + t_wall2;
up(han_h/2) up(han_h/2) difference() {
    cuboid([t_w, han_l + han_h, han_body_h]);
    for (i = [-1, 1]) {
        move([0, i* (han_l + han_h)/2, han_body_h/2])
            yrot(90) cyl(t_w, han_r, rounding=-1, $fn=32);
    }
}
 

