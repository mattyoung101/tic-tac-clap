# Tic Tac Clap
### By Matt Young

_Available under the MIT license._

## About
This is a learning project to build an unbeatable tic tac toe AI using a depth-first search in the D programming language.

It was mainly created to help me learn D and get some practice building/debugging AIs. And also, you know, fun and profit!

### Why D?
Usually, I write Kotlin, but I've been meaning to try the D programming language for ages and I thought this project fit it well.

Also, the next AI project I plan to do, either a Checkers or Reversi engine, is probably best implemented in a compiled language for a slight performance improvement over using the JVM, which is important when you're searching for moves.

## Features
- Bitboards for win/loss/draw detection
- Depth-first search agent
    - Finds total number of wins, total number of losses, probability of win, shortest depth to win, shortest depth to loss and score for cells
    - A variety of ranking/scoring algorithms to try out (keep in mind some work better than others)
    - Reasonably fast (~400,000 moves per second on i5-7600k x86_64, DMD, no optimisation)
    - With some modifications, it could be used as a kibitzer of sorts for tic tac toe
- OOP design
- Commented and readable code

## TODO
- Add a UI
- Make agents play against each other
- Implement the ability to play in N by N grids (not just 3x3)
- Notify the user when winning is impossible
- Fix remaining blunders in the DFS (it can still sometimes lose)
    - When two nodes are ranked exactly the same, what to do?