#!/usr/bin/env python

import pygtk
pygtk.require('2.0')
import gtk
import gobject
import imp

class ClassificationBanner:
    def __init__(self, message="SECRET", bgcolor="#C8102E", height=20, font_size="medium", positions=["top", "top"]):
        self.windows = []
        screen = gtk.gdk.Screen()
        
        num_monitors = screen.get_n_monitors()
        if num_monitors == 1:
            print("Single monitor detected. Using only the first position setting.")
        
        for i in range(min(num_monitors, 2)):  # Support up to 2 monitors
            window = gtk.Window(gtk.WINDOW_TOPLEVEL)
            window.set_position(gtk.WIN_POS_NONE)
            window.set_decorated(False)
            window.set_keep_above(True)
            window.set_app_paintable(True)
            
            # Prevent taskbar entry
            window.set_skip_taskbar_hint(True)
            window.set_skip_pager_hint(True)
            
            # Use a normal window type, but set it to always be on top
            window.set_type_hint(gtk.gdk.WINDOW_TYPE_HINT_NORMAL)
            window.set_keep_above(True)
            
            window.modify_bg(gtk.STATE_NORMAL, gtk.gdk.color_parse(bgcolor))
            
            label = gtk.Label()
            label.set_markup("<span foreground='#FFFFFF' size='%s' weight='bold'>%s</span>" % (font_size, message))
            window.add(label)
            
            monitor_geometry = screen.get_monitor_geometry(i)
            window.set_default_size(monitor_geometry.width, height)
            
            if positions[i] == "bottom":
                window.move(monitor_geometry.x, monitor_geometry.y + monitor_geometry.height - height)
            else:
                window.move(monitor_geometry.x, monitor_geometry.y)
            
            window.show_all()
            self.windows.append(window)

def load_config(config_file):
    try:
        config = imp.load_source('config', config_file)
        return config.BANNER_CONFIG
    except Exception as e:
        print("Error loading config file: %s" % str(e))
        return {}

def main():
    config = load_config('/etc/classification-banner.conf')
    banner = ClassificationBanner(**config)
    gtk.main()

if __name__ == "__main__":
    main()


# Execution file is /usr/local/sbin/classification-banner.py
# Configuration file is /etc/classificaiton-banner.conf
# Initiation file is /etc/xdg/autostart/classification-banner.desktop