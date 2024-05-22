# README

Greetings, Playdate community! 

I’ve created this isometric character template which I’m releasing to the community under the CC0 public domain attribution (https://creativecommons.org/choose/zero/).

This means you can do whatever you want with it, but if you do use it for anything, please give me (intellikat) attribution. This helps me continue to network in finding collaborators or potential work as an artist, as well honoring the time and effort I’ve put into creating it.

If you do create any characters from this template, you might also consider releasing them under CC0 attribution so that others may use them freely in their projects.

I also enjoy to see my work in use, so feel free to drop me a line to share your awesome creations!

intellikat#7505 on discord
https://intellikat.itch.io

And special thanks to sgeos for support.


# Directory Structure

top level: Contains sprite sheets, readme, and license files.
all_frames: All unique frames in a single file.
cycles: Individual animation cycles, one per file.
demo: Demo of all cycles. Uses duplicate frames.
extras: Unused frames, variations, and experiments.

# Cycles

Aseprite was used to create these cycles. All .ase files have been exported
as .gif so they are easy to preview. The design philosophy was to keep the
total frame count low without sacrificing quality. Cycles are listed below
in roughly the same order as the demo.

stand: Neutral standing frame.
run: Run cycle.
pistol: Pistol firing cycle.
sit: Sitting frame.
hit: Hit frame. Use stand->hit->stand when taking damage.
hit-to-sleep-1: Knockdown animation cycle.
sleep-1: 1-tile sleep/down/dead frame.
sleep-2-upper: Upper half of 2-tile sleep/down/dead frame.
sleep-2-lower: Lower half of 2-tile sleep/down/dead frame.
sleep-to-stand-1: 1-tile sleep to neutral standing transition.
sleep-to-stand-2: 2-tile sleep to neutral standing transition.
jump: Jump cycle. sleep-to-stand shares some of the frames.
rifle: Rifle firing cycle.
 
