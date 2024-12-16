Pulseaudio simple recorder.

Features and use:
- Based in Zenity, available in most linux distributions, just type chmod +x pulseaudiosimplerecorder.sh and ./pulseaudiosimplerecorder.sh

Requirements:
- Must have pulseaudio and pulseaudio-utils (pactl and parec commands availability)

Todo:
- Improvement of GUI, width of window must be greater than the longest name of the pulseaudio sources
- Any other improvement you, the user, would have in mind.

Development:
ChatGpt-4o-mini, mainly; I just started typing ideas for the pulseaudio source selection, widget to use, calling to "parec", adding a checkbox for mixed recording, create sink and loopbacks, destroying sink and loopbacks when recording is done and a lot of fixing of errors that the AI incurred when performing my prompts; it served me to learn some Zenity GUI Development much faster than reading online literature.

Warning:
This development was for my own personal purposes, as an "audio notepad" to record my own musical ideas "on the fly"; I don't offer warranty of any type, this will stay archived in Github "AS IS" and I don't offer support of any kind of further development unless I need new functionalities for my own musical purposes.

Contents:
gpl-3.0.txt  license  pulseaudiorecorder.sh  README.md

"License" is a simbolic link to "gpl-3.0.txt"

License:
https://www.gnu.org/licenses/gpl-3.0.txt

