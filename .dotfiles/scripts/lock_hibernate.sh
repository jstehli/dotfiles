#!/bin/bash
# inspired by https://faq.i3wm.org/question/83/how-to-run-i3lock-after-computer-inactivity.1.html

# Take a screenshot
scrot /tmp/screen_locked.png

# Pixellate it 10x
mogrify -scale 10% -scale 1000% /tmp/screen_locked.png

# Lock screen displaying this image.
i3lock -i /tmp/screen_locked.png
systemctl hibernate
