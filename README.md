# bluetoothchess

A version of chess where you get coins for knight-related captures, and can spend coins to make knights appear.
In theory there's supposed to be bluetooth-based multiplayer, but I couldn't get that to work.
If you take a knight, you get 3 horsecoins.
If you take something with a knight, you get the value of that piece.
Values of pieces:
Pawn: 1 horsecoin
Bishop: 2 horsecoins
Knight: 3 horsecoins
Rook: 4 horsecoins
Queen: 7 horsecoins
King: 10 horsecoins
There's also an implementation of TicTacToe.
here's a demo video: https://drive.google.com/file/d/1Lbgr-tlRgaMPE_9WeT5irk-Nt4z7Ya-_/view?usp=sharing

## How I built it

This is written in Dart+Flutter, with custom RenderBoxes/LeafRenderObjectWidgets for each chess piece, Draggables/DragTarget for dragging, Positioneds/Stack for the board, and Paths for the rendering of the pieces.

## Why I built it

I originally wanted to be able to play chess multiplayer offline, but I couldn't get bluetooth to work so here we are.

## How to use this project

Click an option, then drag the pieces around / click on a square in TTT mode.
