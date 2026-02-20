/* [Rendering options] */
// Show placeholder PCB in OpenSCAD preview
show_pcb = false;
// Lid mounting method
lid_model = "cap"; // [cap, inner-fit]
// Conditional rendering
render = "case"; // [all, case, lid]


/* [Dimensions] */
// Height of the PCB mounting stand-offs between the bottom of the case and the PCB
standoff_height = 5;
// PCB thickness
pcb_thickness = 1.6;
// Bottom layer thickness
floor_height = 1.2;
// Case wall thickness
wall_thickness = 1.2;
// Space between the top of the PCB and the top of the case
headroom = 0;

/* [M2.5 screws] */
// Outer diameter for the insert
insert_M2_5_diameter = 3.27;
// Depth of the insert
insert_M2_5_depth = 3.75;

/* [Hidden] */
$fa=$preview ? 10 : 4;
$fs=0.2;
inner_height = floor_height + standoff_height + pcb_thickness + headroom;

module wall (thickness, height) {
    linear_extrude(height, convexity=10) {
        difference() {
            offset(r=thickness)
                children();
            children();
        }
    }
}

module bottom(thickness, height) {
    linear_extrude(height, convexity=3) {
        offset(r=thickness)
            children();
    }
}

module lid(thickness, height, edge) {
    linear_extrude(height, convexity=10) {
        offset(r=thickness)
            children();
    }
    translate([0,0,-edge])
    difference() {
        linear_extrude(edge, convexity=10) {
                offset(r=-0.2)
                children();
        }
        translate([0,0, -0.5])
         linear_extrude(edge+1, convexity=10) {
                offset(r=-1.2)
                children();
        }
    }
}


module box(wall_thick, bottom_layers, height) {
    if (render == "all" || render == "case") {
        translate([0,0, bottom_layers])
            wall(wall_thick, height) children();
        bottom(wall_thick, bottom_layers) children();
    }
    
    if (render == "all" || render == "lid") {
        translate([0, 0, height+bottom_layers+0.1])
        lid(wall_thick, bottom_layers, lid_model == "inner-fit" ? headroom-2.5: bottom_layers) 
            children();
    }
}

module mount(drill, space, height) {
    translate([0,0,height/2])
        difference() {
            cylinder(h=height, r=(space/2), center=true);
            cylinder(h=(height*2), r=(drill/2), center=true);
            
            translate([0, 0, height/2+0.01])
                children();
        }
        
}

module connector(min_x, min_y, max_x, max_y, height) {
    size_x = max_x - min_x;
    size_y = max_y - min_y;
    translate([(min_x + max_x)/2, (min_y + max_y)/2, height/2])
        cube([size_x, size_y, height], center=true);
}

module pcb() {
    thickness = 1.6;

    color("#009900")
    difference() {
        linear_extrude(thickness) {
            polygon(points = [[63.0225,48.170625], [63.1725,105.320625], [63.172476,106.51125], [63.22675685720001,107.131506962], [63.38792008280001,107.73290439760001], [63.651024763600006,108.29719], [64.00817704480001,108.8072187452], [64.4484112548,109.2474529552], [64.95844000000001,109.6045695176], [65.5227256024,109.8677099172], [66.12412303800001,110.02887314280001], [66.74438,110.08313000000001], [66.744375,110.083124], [168.50628490719998,110.0391601572], [169.0512823576,109.9083221928], [169.5690978012,109.69379508], [170.04701534519998,109.4009366388], [170.4732120668,109.03692634800001], [170.83722235759998,108.6107296264], [171.13008079879998,108.13281208240001], [171.3445721928,107.61499663880001], [171.4754101572,107.0699634696], [171.51937999999998,106.5112142812], [171.519375,106.5112], [170.639574202,75.226507458], [170.543749144,74.91064341600001], [170.38814918600002,74.61953123400001], [170.17875181800002,74.364368182], [170.17875,74.364375], [141.93597346439998,44.486886443500005], [141.1894149225,44.2608740065], [140.41312,44.18454], [66.594375,44.59875], [65.974123038,44.653006857200005], [65.3727256024,44.814170082800004], [64.80844,45.0772747636], [64.2984112548,45.4344270448], [63.8581770448,45.8746612548], [63.5010247636,46.384690000000006], [63.2379200828,46.948975602400004], [63.0767568572,47.550373038000004], [63.0225,48.17063]]);
        }
    translate([167.9475, 106.51125, -1])
        cylinder(thickness+2, 1.0499999999999972, 1.0499999999999972);
    translate([66.744375, 106.51125, -1])
        cylinder(thickness+2, 1.0499999999999972, 1.0499999999999972);
    translate([140.413125, 48.170625, -1])
        cylinder(thickness+2, 1.0499999999999972, 1.0499999999999972);
    translate([66.594375, 48.170625, -1])
        cylinder(thickness+2, 1.0499999999999972, 1.0499999999999972);
    }
}

module case_outline() {
    polygon(points = [[170.124467,112.464375], [65.50375,112.673033], [64.7378553904,112.61110822879999], [63.99188633919999,112.42691598559999], [63.285196379199995,112.12526781919999], [62.636137998399995,111.71402908159999], [62.061585951999994,111.2038299152], [61.576460574399995,110.6079699152], [61.1933940976,109.94184610399999], [60.92234930079999,109.22290526239999], [60.7702858288,108.4696905536], [60.74125,107.701875], [60.74125,45.933822]]);
}

module Insert_M2_5() {
    translate([0, 0, -insert_M2_5_depth])
        cylinder(insert_M2_5_depth, insert_M2_5_diameter/2, insert_M2_5_diameter/2);
    translate([0, 0, -0.3])
        cylinder(0.3, insert_M2_5_diameter/2, insert_M2_5_diameter/2+0.3);
}

rotate([render == "lid" ? 180 : 0, 0, 0])
scale([1, -1, 1])
translate([-115.43285850000001, -79.3034275, 0]) {
    pcb_top = floor_height + standoff_height + pcb_thickness;

    difference() {
        box(wall_thickness, floor_height, inner_height) {
            case_outline();
        }

    translate([0, 0, -1])
    #linear_extrude(floor_height+2, convexity=10) 
        polygon(points = [[173.875533,108.8925], [173.153173,74.364375], [173.120807364,74.03588745799999], [173.024999144,73.720023416], [172.869399186,73.428911234], [172.660001818,73.173748182], [172.66,73.17375], [142.3539118716,42.5350724928], [141.4501099044,42.2799620064], [140.5131110988,42.2174924124], [140.513135,42.2175]]);

    translate([0, 0, -1])
    #linear_extrude(floor_height+2, convexity=10) 
        polygon(points = [[173.850625,108.8925], [173.7724643222,109.5199403156], [173.58911072019998,110.125081585], [173.3059354006,110.6904280564], [172.93108328,111.1996155138], [172.47537705579998,111.6379533542], [171.9519824836,111.9927593102], [171.376110846,112.2537685554], [170.7642751246,112.413468427], [170.134285,112.467216]]);

    translate([0, 0, -1])
    #linear_extrude(floor_height+2, convexity=10) 
        polygon(points = [[60.738444,45.933822], [60.7921814285,45.303799377999994], [60.9518808707,44.6920396843], [61.212889414100005,44.116132403799995], [61.567694416100004,43.592739238899995], [62.006031077900005,43.1370714313], [62.5152171662,42.7621831273], [63.0805621175,42.479008569099996], [63.6856645685,42.295655460099994], [64.313125,42.2175]]);

    }

    if (show_pcb && $preview) {
        translate([0, 0, floor_height + standoff_height])
            pcb();
    }

    if (render == "all" || render == "case") {
        // REF** [('M2.5', 2.5)]
        translate([167.9475, 106.51125, floor_height])
        mount(2.1, 4.7, standoff_height)
            Insert_M2_5();
        // REF** [('M2.5', 2.5)]
        translate([66.744375, 106.51125, floor_height])
        mount(2.1, 4.7, standoff_height)
            Insert_M2_5();
        // REF** [('M2.5', 2.5)]
        translate([140.413125, 48.170625, floor_height])
        mount(2.1, 4.7, standoff_height)
            Insert_M2_5();
        // REF** [('M2.5', 2.5)]
        translate([66.594375, 48.170625, floor_height])
        mount(2.1, 4.7, standoff_height)
            Insert_M2_5();
    }
}
