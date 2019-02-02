# Excaball-NES
Excaball for the NES.  Written in 6502 Assembly Language.

This is a port of a game my friend Nick and I created way back when. [Click here](https://peterho8888.github.io/games/excaball.html) to play.

You may notice some horrendous design choices and illogical/dumb code.
This is because this was my first introduction to assembly language and I had no clue what I was doing.

For example, I wrote a loop to divide a value by 64 to find the offset the high pointer of the background instead of
just right-shifting by 6.

This is still a work in progress, but if you want to contribute, you can clone this repository and compile with NESASM (v3.01).
