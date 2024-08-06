#!/usr/bin/env python
import pygtk
pygtk.require('2.0')
import gtk
import gobject
import imp

class ClassificationBanner:
    def __init__(self, message="SECRET", bgcolor="#C8102E", height=20, font_size="medium", positions=["top", "top"]):
        self.windows = []
        screen = gtk.gdk.screen_get_default()
        
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
            
            # Set window type to dock to make it visible on all workspaces
            window.set_type_hint(gtk.gdk.WINDOW_TYPE_HINT_DOCK)
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
            
            # Make the window appear on all workspaces
            window.stick()
            
            window.show_all()
            self.windows.append(window)
        
        # Connect to workspace-changed signal
        screen.connect("active-workspace-changed", self.on_workspace_changed)
    
    def on_workspace_changed(self, screen, previously_active_space):
        # Ensure windows are visible and on top when workspace changes
        for window in self.windows:
            window.present()

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
