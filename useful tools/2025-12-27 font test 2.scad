include <BOSL2/std.scad>

e = 0.01;

module all_the_text(test_type) {

    up(e) right(1) fwd(1)
    {
        if (test_type == 1) {
            text = "1234567890 ABCDEFG abcdefg";
            size = 8;
            fonts = [
                "Helvetica", 
                "Arial", 
                "Bahnschrift",
                "Candara",
                "Franklin Gothic", 
                "Segoe UI",
                "Tahoma",
                "Trebuchet MS",
            ];

            for (sss = [4:7]) {
                fwd(sss-3 + 3*(sss*(sss+1)/2 - 10)) {
                    text3d(str_join(["size = ", str(sss)]), size=sss, anchor=TOP+LEFT+BACK);
                    for (i = [0:len(fonts)-1]) {
                        fwd((sss+1)*floor((i+1)/3)) right(60 * ((i+1) %3)) text3d(fonts[i], size=sss, thickness=0.6, font=fonts[i], anchor=TOP+LEFT+BACK);
                    }
                }
            }
            
            fwd(8-3 +3*(8*9/2 - 10)) {
                text3d(str_join(["size = ", str(size)]), size=size, anchor=TOP+LEFT+BACK);
                for (i = [0:len(fonts)-1]) {
                    fwd((size+2)*(i+1)) text3d(str_join([fonts[i], ": ",text]), size=size, thickness=0.6, font=fonts[i], anchor=TOP+LEFT+BACK);
                }
            }
        }
        
        if (test_type == 2) {
            text3d("font size/thickness test", size=6, thickness=0.8, anchor=TOP+LEFT+BACK);
            fwd(8) {
                for (ttt = [1:4]) {
                    right(-10+35*ttt) text3d(str_join([str(0.2*ttt)]), size=6, thickness=0.8, anchor=TOP+LEFT+BACK);
                }
                fwd(7) for (sss = [1:10]) {
                    fwd(sss + sss*(sss+1)/2) text3d(str_join([str(sss)]), size=sss, thickness=0.8, anchor=TOP+LEFT+BACK);
                }
                
                for (ttt = [1:4]) {
                    right(-10+35*ttt) fwd(7) {
                        intersection() {
                            for (sss = [1:10]) {
                                fwd(sss + sss*(sss+1)/2) text3d("012Abc", size=sss, thickness=0.2*ttt, anchor=TOP+LEFT+BACK);
                            }
                            cuboid([34, 100, 100], anchor=TOP+LEFT+BACK);
                        }
                    }
                }
            }
        }
    }
}

just_text = true;

// font test
/*
back(185)
if (just_text) {
    all_the_text(test_type=1);
} else {
    difference() {
        cuboid([180, 172, 1.2], anchor=TOP+LEFT+BACK);
        all_the_text(test_type=1);
    }
}
*/

// font size/thickness test
if (just_text) {
    all_the_text(test_type=2);
} else {
    difference() {
        cuboid([166, 92, 1.2], anchor=TOP+LEFT+BACK);
        all_the_text(test_type=2);
    }
}

