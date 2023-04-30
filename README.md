
# 02-MIPS-Snake-Game
This is a classic Snake game implemented in MIPS assembly language, designed to run on a MIPS architecture emulator (MARS) or on an actual MIPS-based system. The game is played on a grid of cells, where the player controls a snake that grows by eating food and dies if it collides with a wall or its own body.

# Getting started
To run the game, you'll need to have a MIPS emulator or hardware that can run MIPS assembly code. Once you have that, you can download the source code from this repository and open MARS, Bitmap section.

To play the game, simply run the executable and use the arrow keys on your keyboard to move the snake around the grid. The game will keep track of your score and display it on the screen.

# Features
Classic Snake gameplay with intuitive controls
Adjustable speed and grid size for added challenge
Simple graphics and sound effects using the MIPS console I/O
# How it works
The game is implemented using a combination of MIPS assembly language and the MIPS console I/O functions for displaying graphics and accepting user input. The main program loop updates the game state based on the player's input and the game rules, then redraws the screen to show the updated game board and score.

The snake and food objects are represented as arrays of coordinates on the grid, and the collision detection logic checks for collisions with the walls and the snake's own body.

# Emulator Installation
Follow this link to download: http://courses.missouristate.edu/kenvollmar/mars/

# Contributions
Contributions to this project are welcome! If you have any suggestions, bug reports, or improvements to the code, feel free to open an issue or a pull request.

# License
This project is licensed under the MIT License. See the LICENSE file for details.
