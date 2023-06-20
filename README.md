# Flappy Bird

Ported from [MiSTer core](https://github.com/MiSTer-devel/FlappyBird_MiSTer) which was ported from original [project](https://github.com/themaxaboy/Flappy-Bird-Verilog/).

This core is written entirely in discrete logic, apparently. Not recommended as a reference example.

## History

Flappy Bird is an arcade-style game launched in May 2013 and gained popularity in early 2014. The user controls the bird constantly moving to the right and the objective is to navigate the bird through pair of pipes that have gaps placed at random heights. The bird will ascend for a short distance if the player touches the screen (a button configured on FPGA) and ends if the bird falls to the ground or hits a pipe. Points are rewarded each time the player crosses a pipe.

## Instructions

- Press Flap
- When you die, press reset.



**MiST**

* F12 opens OSD

**DeMiSTify**

* F12 opens OSD

* F12 long press changes resolution (640x480, 1280x1024)

  

## **Controls**

* Keyboard controls: Control = Flap, Alt Gr = Reset
* Joystick controls:  Fire B = Flap, Fire C = Reset     (depends on joy mapping)  (if joystick does now work swap it in OSD)
* FPGA buttons controls: KEY0 = Flap, KEY1 = Reset  (depends on board available buttons)



## Other Ports

* MiSTex port https://github.com/somhi/FlappyBird_MiSTeX
* Flappy Bird on FPGA using VHDL https://github.com/gaikwadabhishek/flappy-bird-fpga-vhdl (from which I took the History paragraph)





![flappy](flappy.jpg)
