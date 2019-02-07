# Tic Tac Clap
By Matt Young

This project is for me to tinker around with AI, and learn the D programming language. As well as clap you at tic tac toe.

Some of the features are pretty overkill (looking at you, bitboards), but are here as stated above due to this project being mainly for learning.

### Why D?
Usually, I write Kotlin, but D caught my eye as being a less daunting and more modern version of C++. So I thought I'd try it out.

Also, the next AI project I plan to do, a chess engine, is probably best implemented in a compiled language so the system can take advantage of bitboards without extra overhead.

## Features
    - GUI (using either ncurses or tk)
    - Minimax based solver
    - Bitboards
    - OOP design

## TODO
    - Implement meta tic tac toe
        - Needs new AI techniques, maybe MCTS
    - Try a DFS solver (slow as hell, but would explore the entire state space which isn't tooo large)