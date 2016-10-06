MIPS-PIANO TILES
==========

Clone do jogo "Piano Tiles" em MIPS Assembly para o projeto final de Arquitetura e Organização de Computadores.


## How To Run

1. Open the Mars .jar file from our repo.
2. Load the main.asm file into Mars with File -> Open.
3. Go to Run -> Assemble (or press F3)
4. Go to tools -> Bitmap Display
5. The Bitmap Display settings should be as follows:
  - Unit Width: 8
  - Unit Height: 8
  - Display Width: 256
  - Display Height: 512
  - Base Address: heap
6. Go to tools -> Keyboard and Display MMIO Simulator
7. Press `Connect to MIPS` on both of the displays
8. Go to Run -> Go (or press F5)
9. All controls should take place in the lower portion of the Keyboard and Display Simulator

## Controls

The piano tiles can be played by pressing the keys respective to the column that has a black tile currently at the bottom.

```
Column | 1 | 2 | 3 | 4 |
       -----------------
Key    | f | g | h | j |
```
