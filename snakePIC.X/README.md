# This is a simple game made in assembly with a PIC16F877A.

Move the snake by using the keyboard.

Press 2 to go up.
Press 8 to go down.
Press 6 to go right.
Press 4 to go left.

The little apple (is just a dot) can be picked up by just passing through the display.

###### There are some screenshots.

<img src="https://github.com/RiccardoCafa/assembly-codes/blob/master/snakePIC.X/Images/screen_01.jpg?raw=true" width="250"> . <img src="https://github.com/RiccardoCafa/assembly-codes/blob/master/snakePIC.X/Images/screen_02.jpg?raw=true" width="250">

<img src="https://github.com/RiccardoCafa/assembly-codes/blob/master/snakePIC.X/Images/screen_03.jpg?raw=true" width="250"> . <img src="https://github.com/RiccardoCafa/assembly-codes/blob/master/snakePIC.X/Images/screen_04.jpg?raw=true" width="250">

The random food position were created by shifting the food bit between 2-5 (representing the display bits) everytime that the Timer Interruption triggers.

The movement were created by checking all possible moves and conditions.

The tail we just get the last head position and make some adjustments.

### Created by Lucas Rezende and Riccardo Cafagna.
