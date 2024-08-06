#!/usr/bin/env python

# Execution file is /usr/local/sbin/classification-banner.py
# Configuration file is /etc/classificaiton-banner.conf
# Service file is /etc/systemd/system/classification-banner.service

import pygtk
pygtk.require('2.0')
import gtk
import gobject
import imp

class ClassificationBanner:
    def __init__(self, message="SECRET", bgcolor="#C8102E", height=20, font_size="medium", positions=["top", "top", "top", "top"]):
        # Store configuration parameters
        self.banner_message = message
        self.banner_color = bgcolor
        self.banner_height = height
        self.banner_font_size = font_size
        self.banner_positions = positions
        
        # Ensure we have 4 position settings (use 'top' as default if not specified)
        self.banner_positions = (self.banner_positions + ['top'] * 4)[:4]
        
        # List to store banner windows
        self.banner_windows = []
        
        # Create banner windows
        self.create_banner_windows()
        
        # Set up a timer to periodically check and update windows
        gobject.timeout_add(1000, self.ensure_banner_visibility)
    
    def create_banner_windows(self):
        """Create classification banner windows for each monitor (up to 4)"""
        screen = gtk.gdk.screen_get_default()
        num_monitors = min(screen.get_n_monitors(), 4)  # Limit to 4 monitors
        
        for monitor_index in range(num_monitors):
            # Create a new window for each monitor
            banner_window = self.create_single_banner_window(screen, monitor_index)
            self.banner_windows.append(banner_window)
    
    def create_single_banner_window(self, screen, monitor_index):
        """Create a single banner window for a specific monitor"""
        window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        window.set_decorated(False)
        window.set_keep_above(True)
        window.set_skip_taskbar_hint(True)
        window.set_skip_pager_hint(True)
        
        # Set the background color
        window.modify_bg(gtk.STATE_NORMAL, gtk.gdk.color_parse(self.banner_color))
        
        # Create and add the label
        label = gtk.Label()
        label.set_markup("<span foreground='#FFFFFF' size='%s' weight='bold'>%s</span>" % 
                         (self.banner_font_size, self.banner_message))
        window.add(label)
        
        # Position the window on the correct monitor
        self.position_window(window, screen, monitor_index)
        
        # Attempt to make the window stick to all workspaces
        window.stick()
        
        window.show_all()
        return window
    
    def position_window(self, window, screen, monitor_index):
        """Position the banner window on the specified monitor"""
        monitor_geometry = screen.get_monitor_geometry(monitor_index)
        window.set_default_size(monitor_geometry.width, self.banner_height)
        
        if self.banner_positions[monitor_index] == "bottom":
            y_position = monitor_geometry.y + monitor_geometry.height - self.banner_height
        else:
            y_position = monitor_geometry.y
        
        window.move(monitor_geometry.x, y_position)
    
    def ensure_banner_visibility(self):
        """Ensure all banner windows are visible and on top"""
        for window in self.banner_windows:
            window.present()
        return True  # Keep the timer running

def load_banner_config(config_file_path):
    """Load banner configuration from a file"""
    try:
        config_module = imp.load_source('config', config_file_path)
        return config_module.BANNER_CONFIG
    except Exception as e:
        print("Error loading config file: %s" % str(e))
        return {}

def main():
    # Load configuration
    config = load_banner_config('/etc/classification-banner.conf')
    
    # Create and run the classification banner
    banner = ClassificationBanner(**config)
    gtk.main()

if __name__ == "__main__":
    main()
