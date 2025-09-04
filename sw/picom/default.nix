{
    services.picom = {
        enable = true;
        activeOpacity = 1.00;
        backend = "glx";
        fade = true;
        fadeDelta = 2;
        inactiveOpacity = 0.50;
        settings = {
            blur = {
                method = "gaussian";
                size = 10;
                deviation = 5.0;
            };
            blur-background-exclude = [
                "_GTK_FRAME_EXTENTS@:c"
                "class_g = 'Rofi'"
                "window_type = 'desktop'"
                "window_type = 'menu'"
                "window_type = 'tooltip'"
                "window_type = 'utility'"
            ];
            corner-radius = 12;
            detect-rounded-corners = true;
            experimental-backends = false;
            frame-pacing = false;
            opacity-rule = [
                "100:class_g = 'firefox'"
                "100:class_g = 'Rofi'"
                "100:window_type = 'menu'"
                "100:window_type = 'popup_menu'"
                "100:window_type = 'tooltip'"
            ];
            round-borders = 1;
            shadow-exclude = [
                "_GTK_FRAME_EXTENTS@:c"
                "class_g = 'Rofi'"
                "window_type = 'desktop'"
                "window_type = 'menu'"
                "window_type = 'tooltip'"
                "window_type = 'utility'"
            ];
        };
        vSync = true;
    };
}