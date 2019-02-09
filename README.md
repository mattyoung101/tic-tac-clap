# Tic Tac Clap

A D program for playing and analysing Tic Tac Toe games.

#### By Matt Young

_Available under the MIT license._

## Features
- Bitboards for win/loss/draw detection
- Depth-first search agent
    - Finds total number of wins, total number of losses, probability of win, shortest depth to win, shortest depth to loss and score for cells
    - A variety of ranking/scoring algorithms to try out (keep in mind some work better than others)
    - Reasonably fast (~400,000 moves per second on i5-7600k x86_64, DMD, no optimisation)
    - With some modifications, it could be used as a kibitzer of sorts for tic tac toe
- OOP design
- Commented and readable code

## About/FAQ
This is a learning project to build an unbeatable tic tac toe AI using a depth-first search in the D programming language.

It was mainly created to help me learn D and get some practice building/debugging AIs. And also, you know, fun and profit!

### Why depth-first search rather than minimax?
Good question! This is my first AI project, and it seemed to me like DFS was an easier to implement algorithm than minimax. Normally, the state space of a game is too big to explore with a brute force search like DFS, however, Tic Tac Toe has a pretty small state space and with bitboards giving ~400k moves/sec I figured it was feasible to implement.
Finally, the idea of analysing the entire state space of Tic Tac Toe seemed pretty interesting to me. With this approach, for example, you can calculate the total number of wins from starting at the centre square (20256 or 78.29% chance of win). Thus meaning Tic Tac Clap could be used as a kibitzer for human vs human Tic Tac Toe games.

It is worth noting that DFS seems to be a weaker player than minimax, it's not perfect. I am still working to find a way to fix some blunders in the agent, but it plays strongly most of the time. It seems to only lose against perfect players.

### Why D?
Usually, I write Kotlin, but I've been meaning to try the D programming language for ages and I thought this project fit it well.

Also, the next AI project I plan to do, either a Checkers or Reversi engine, is probably best implemented in a compiled language for a slight performance improvement over using the JVM, which is important when you're searching for moves.

### "Tic Tac Clap"? Really?
Yep. What are you gonna do?

## TODO
- Add a UI
- Make agents play against each other as a test of sorts to evaluate strength
- Implement the ability to play in N by N grids (not just 3x3)
- Fix remaining blunders in the DFS (it can still sometimes lose)
    - When two nodes are ranked exactly the same, what to do?
- Pre-calcualte lookup table for all possible states in the game and then use that, see [here](https://medium.com/@mtiller/what-i-dont-get-is-if-you-are-already-searching-the-whole-tree-the-potentially-9-9b6b68365e40)
- Implement kibitzer for human games (basically allow entering custom state and then run DFS on it)
- Post-game analysis: go back through tree, figure out how we could have won