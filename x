 		for (cp = dc.col; cp < &dc.col[dc.collen]; ++cp)
 			XftColorFree(xw.dpy, xw.vis, xw.cmap, cp);
 	} else {
-		dc.collen = MAX(LEN(colorname), 256);
+		dc.collen = 258;
 		dc.col = xmalloc(dc.collen * sizeof(Color));
 	}

@@ -2008,6 +2011,47 @@ usage(void)
 	    " [stty_args ...]\n", argv0, argv0);
 }

+void
+nextscheme(const Arg *arg)
+{
+	colorscheme += arg->i;
+	if (colorscheme >= (int)LEN(schemes))
+		colorscheme = 0;
+	else if (colorscheme < 0)
+		colorscheme = LEN(schemes) - 1;
+	updatescheme();
+}
+
+void
+selectscheme(const Arg *arg)
+{
+	if (BETWEEN(arg->i, 0, LEN(schemes)-1)) {
+		colorscheme = arg->i;
+		updatescheme();
+	}
+}
+
+void
+updatescheme(void)
+{
+	int oldbg, oldfg;
+
+	oldbg = defaultbg;
+	oldfg = defaultfg;
+	colorname = schemes[colorscheme].colors;
+	defaultbg = schemes[colorscheme].bg;
+	defaultfg = schemes[colorscheme].fg;
+	defaultcs = schemes[colorscheme].cs;
+	defaultrcs = schemes[colorscheme].rcs;
+	xloadcols();
+	if (defaultbg != oldbg)
+		tupdatebgcolor(oldbg, defaultbg);
+	if (defaultfg != oldfg)
+		tupdatefgcolor(oldfg, defaultfg);
+	cresize(win.w, win.h);
+	redraw();
+}
+
 int
 main(int argc, char *argv[])
 {
@@ -2060,6 +2104,12 @@ main(int argc, char *argv[])
 	} ARGEND;

 run:
+	colorname = schemes[colorscheme].colors;
+	defaultbg = schemes[colorscheme].bg;
+	defaultfg = schemes[colorscheme].fg;
+	defaultcs = schemes[colorscheme].cs;
+	defaultrcs = schemes[colorscheme].rcs;
+
 	if (argc > 0) /* eat all remaining arguments */
 		opt_cmd = argv;

--
2.36.1
