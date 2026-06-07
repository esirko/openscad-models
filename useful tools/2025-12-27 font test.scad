include <BOSL2/std.scad>

e = 0.01;

// This is a test of a few fonts. I guess OpenSCAD/BOSL2 doesn't support emojis, but it can render system fonts. 
// For example Segoe Fluent Icons is a font that has many different types of useful icons, but you have to use unicode characters. Go into Character Map to browse.

module font_block(f, s) {
    diff()cuboid([180,25+e,2], anchor=TOP+BACK)
    position(LEFT+TOP+BACK) color("red")
    up(e) right(4) tag("remove") 
        {
            fwd(1) text3d(f, size=s, h=0.6, anchor=LEFT+TOP+BACK);
            text1 = f == "Segoe Fluent Icons" ? "" : "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789";
            text2 = f == "Segoe Fluent Icons" ? "" : "abcdefghijklmnopqrstuvwxyz!@#$%^&*(";
            fwd(2+s) text3d(text1, size=s, font=f, h=0.6, anchor=LEFT+TOP+BACK);
            fwd(3+2*s) text3d(text2, size=s, font=f, h=0.6, anchor=LEFT+TOP+BACK);
        }
}

fonts = ["Helvetica", 
    "Arial", 
    "Bahnschrift",
    "Candara",
    //"Comic Sans MS", 
    "Franklin Gothic", 
    //"Marlett",
    //"MS Outlook",
    //"MS Reference Specialty",
    "Segoe Fluent Icons",
    "Segoe UI",
    //"Symbol",
    "Tahoma",
    "Trebuchet MS",
    //"Webdings",
    //"Wingdings",
    //"Wingdings 2",
    "Wingdings 3",
];

for (i = [0:len(fonts)-1]) {
    fwd(25*i) font_block(fonts[i], 6);
}
