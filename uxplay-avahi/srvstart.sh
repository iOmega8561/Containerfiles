#!/bin/sh
sudo dbus-daemon --system
sudo avahi-daemon &
uxplay