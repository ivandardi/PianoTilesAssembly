#
# PIANO TILES IN MIPS ASSEMBLY
#



#
# CONSTANTS
#

    # Endereco de inicio da tela
    .eqv SCREEN_BEGIN 0x10040000

    # Endereco de fim da tela
    .eqv SCREEN_END 0x10044000

    # Largura do retangulo do piano
    .eqv RECT_WIDTH_4T 8

    # Largura do retangulo do piano
    .eqv RECT_WIDTH_8T 4

    # Altura do retangulo do piano
    .eqv RECT_HEIGHT 16

    # Largura da tela
    .eqv SCREEN_WIDTH 32

    # Largura da tela
    .eqv SCREEN_HEIGHT 64

    # Endereco de memoria com a entrada do usuario
    .eqv USER_INPUT 0xffff0004

    #
    # CORES
    #

    .eqv COR_BLACK 0x00000000

    .eqv COR_WHITE 0x00FFFFFF

    .eqv COR_RED   0x00FF0000

    .eqv COR_GREEN 0x0000FF00

    .eqv COR_BLUE  0x000000FF

    .eqv COR_FAIL COR_RED

    .eqv COR_SUCCESS COR_GREEN

    .eqv COR_SCREEN COR_WHITE

    .eqv COR_TILE COR_BLACK

#
# MACROS
#

    # Macro que para a execucao do programa
    .macro DONE
        li $v0,10
        syscall
    .end_macro

    # Macro de inicio de funcao
    .macro FUNCTION_BEGIN (%name)
        %name :
    .end_macro

    # Macro de fim de funcao
    .macro FUNCTION_END
        jr $ra
    .end_macro

    # Macro pra facilitar chamar a funcao de limpar a tela
    .macro CLEAR_SCREEN (%cor)
        li  $a0, %cor
        jal ClearScreen
    .end_macro

    # Macro pra facilitar chamar a funcao de desenhar retangulo
    .macro DRAW_RECT (%x, %y, %cor)
        li  $a0, %x
        li  $a1, %y
        li  $a2, %cor
        jal DrawRect
    .end_macro

    # Macro que faz o programa esperar por %ms milissegundos
    .macro SLEEP(%ms)
        li $v0, 32
        li $a0, %ms
        syscall
    .end_macro

    # Macro pra desenhar na tela
    .macro SCREEN_IMAGE(%arq)
        la $a0, %arq
        jal ScreenImage
    .end_macro

    # Macros que facilitam salvar na pilha. Os registradores sao salvos em ordem
    .macro STACK_PUSH(%a)
        addi $sp, $sp, -4
        sw   %a, 0($sp)
    .end_macro

    .macro STACK_PUSH(%a, %b)
        addi $sp, $sp, -8
        sw   %a, 0($sp)
        sw   %b, 4($sp)
    .end_macro

    .macro STACK_PUSH(%a, %b, %c)
        addi $sp, $sp, -12
        sw   %a, 0($sp)
        sw   %b, 4($sp)
        sw   %c, 8($sp)
    .end_macro

    .macro STACK_PUSH(%a, %b, %c, %d)
        addi $sp, $sp, -16
        sw   %a, 0($sp)
        sw   %b, 4($sp)
        sw   %c, 8($sp)
        sw   %d, 12($sp)
    .end_macro

    .macro STACK_PUSH(%a, %b, %c, %d, %e)
        addi $sp, $sp, -20
        sw   %a, 0($sp)
        sw   %b, 4($sp)
        sw   %c, 8($sp)
        sw   %d, 12($sp)
        sw   %e, 16($sp)
    .end_macro

    .macro STACK_POP(%a)
        lw   %a, 0($sp)
        addi $sp, $sp, 4
    .end_macro

    .macro STACK_POP(%a, %b)
        lw   %a, 0($sp)
        lw   %b, 4($sp)
        addi $sp, $sp, 8
    .end_macro

    .macro STACK_POP(%a, %b, %c)
        lw   %a, 0($sp)
        lw   %b, 4($sp)
        lw   %c, 8($sp)
        addi $sp, $sp, 12
    .end_macro

    .macro STACK_POP(%a, %b, %c, %d)
        lw   %a, 0($sp)
        lw   %b, 4($sp)
        lw   %c, 8($sp)
        lw   %d, 12($sp)
        addi $sp, $sp, 16
    .end_macro

    .macro STACK_POP(%a, %b, %c, %d, %e)
        lw   %a, 0($sp)
        lw   %b, 4($sp)
        lw   %c, 8($sp)
        lw   %d, 12($sp)
        lw   %e, 16($sp)
        addi $sp, $sp, 20
    .end_macro



#
# PROGRAM
#

.data

    tela0_1: .asciiz "/home-local/aluno/PianoTilesAssembly/img/tela_inicial_01.img"
    tela0_2: .asciiz "/home-local/aluno/PianoTilesAssembly/img/tela_inicial_02.img"
    tela0_3: .asciiz "/home-local/aluno/PianoTilesAssembly/img/tela_inicial_03.img"
    tela1_1:
    tela1_2:
    tela1_3:
    tela1_4:
    tela1_5:
    tela2_1:
    tela2_2:
    tela2_3:
    tela2_4:
    tela2_5:
    tela3:
    tela14:
    tela15:
    tela16:
    tela17:
    

    ttls:  .word 42, 60, 60, 67, 67, 69, 69, 67, 65, 65, 64, 64, 62, 62, 60, 67, 67, 65, 65, 64, 64, 62, 67, 67, 65, 65, 64, 64, 62, 60, 60, 67, 67, 69, 69, 67, 65, 65, 64, 64, 62, 62, 60
    hbty:  .word 25, 60, 60, 62, 60, 65, 64, 60, 60, 62, 60, 67, 65, 69, 69, 72, 69, 65, 64, 62, 70, 70, 69, 65, 67, 65
    swtim: .word 66, 69, 69, 69, 65, 72, 69, 65, 7, 69, 64, 64, 64, 65, 60, 68, 65, 60, 69, 69, 69, 69, 69, 68, 67, 66, 65, 66, 70, 63, 62, 61, 60, 71, 60, 65, 68, 66, 67, 60, 69, 60, 64, 69, 69, 69, 69, 68, 67, 66, 65, 66, 70, 63, 62, 61, 60, 71, 60, 65, 68, 66, 60, 69, 65, 60, 69
    tiles: .space 100

.text



main:

#    jal MainLoop


    la $a0, swtim
    jal Gameloop4


DONE



FUNCTION_BEGIN MainLoop #Control Setup and Game flow
    STACK_PUSH($ra)

    jal MainScreen

MainLoop.loop:

     # If $v0 is 1, then play with 4 columns of tiles
    beq $v0, -1, MainLoop.end # fail - 8 tiles
    beq $v0, 0, MainLoop.loop.0 # initial
    beq $v0, 1, MainLoop.loop.1 # select music 4 tiles
    beq $v0, 2, MainLoop.loop.2 # select music 8 tiles
    beq $v0, 3, MainLoop.loop.3 # information
    beq $v0, 4, MainLoop.loop.4 # music 1 - 4 tiles
    beq $v0, 5, MainLoop.loop.5 # music 2 - 4 tiles
    beq $v0, 6, MainLoop.loop.6 # music 3 - 4 tiles
    beq $v0, 7, MainLoop.loop.7 # music 4 - 4 tiles
    beq $v0, 8, MainLoop.loop.8 # music 5 - 4 tiles
    beq $v0, 9, MainLoop.loop.9 # music 1 - 8 tiles
    beq $v0, 10, MainLoop.loop.10 # music 2 - 8 tiles
    beq $v0, 11, MainLoop.loop.11 # music 3 - 8 tiles
    beq $v0, 12, MainLoop.loop.12 # music 4 - 8 tiles
    beq $v0, 13, MainLoop.loop.13 # music 5 - 8 tiles
    beq $v0, 14, MainLoop.loop.14 # success - 4 tiles
    beq $v0, 15, MainLoop.loop.15 # success - 8 tiles
    beq $v0, 16, MainLoop.loop.16 # fail - 4 tiles
    beq $v0, 17, MainLoop.loop.17 # fail - 8 tiles


MainLoop.loop.0:
    jal MainScreen
    j MainLoop.loop
MainLoop.loop.1:
    jal SelectionScreen4
    j MainLoop.loop
MainLoop.loop.2:
    jal SelectionScreen8
    j MainLoop.loop
MainLoop.loop.3:
    jal InfoScreen
    j MainLoop.loop
MainLoop.loop.4:
    j MainLoop.loop
MainLoop.loop.5:
    j MainLoop.loop
MainLoop.loop.6:
    j MainLoop.loop
MainLoop.loop.7:
    j MainLoop.loop
MainLoop.loop.8:
    j MainLoop.loop
MainLoop.loop.9:
    j MainLoop.loop
MainLoop.loop.10:
    j MainLoop.loop
MainLoop.loop.11:
    j MainLoop.loop
MainLoop.loop.12:
    j MainLoop.loop
MainLoop.loop.13:
    j MainLoop.loop
MainLoop.loop.14:
    j MainLoop.loop
MainLoop.loop.15:

    j MainLoop.loop
MainLoop.loop.16:
    j MainLoop.loop
MainLoop.loop.17:


    j MainLoop.loop

MainLoop.end:

    STACK_POP($ra)
FUNCTION_END



FUNCTION_BEGIN MainScreen #Position Code: 0
    STACK_PUSH($ra, $s0, $s1, $s2)

    SCREEN_IMAGE(tela0_1)

    # INPUT
    li $s0, USER_INPUT

    li $s1, 1  # Set $s1 to 1. $s1 is the position

MainScreen.input:
    # read user input
    lw   $s2, 0($s0)
    beqz $s2, MainScreen.input

    # reset user input to zero
    sw   $zero, 0($s0)

    # $s2 has the user input

    # Check to see if the user pressed w or W
    beq $s2, 119, MainScreen.w
    beq $s2, 87, MainScreen.w

    # Check to see if the user pressed s or S
    beq $s2, 115, MainScreen.s
    beq $s2, 83, MainScreen.s

    # Check to see if the user pressed enter
    beq $s2, 10, MainScreen.enter
    
    # Check to see if the user pressed ESC
    beq $s2, 27, MainScreen.end

    # Check to see if the user pressed BackSpace
    beq $s2, 8, MainScreen.end

    j MainScreen.input

MainScreen.w:

    beq  $s1, 1, MainScreen.input
    addi $s1, $s1, -1

    j MainScreen.screen

MainScreen.s:

    beq  $s1, 3, MainScreen.input
    addi $s1, $s1, 1

    j MainScreen.screen

MainScreen.screen:

    beq $s1, 1, MainScreen.tela1
    beq $s1, 2, MainScreen.tela2
    beq $s1, 3, MainScreen.tela3

MainScreen.tela1:

    SCREEN_IMAGE(tela0_1)
    j MainScreen.input

MainScreen.tela2:

    SCREEN_IMAGE(tela0_2)
    j MainScreen.input

MainScreen.tela3:

    SCREEN_IMAGE(tela0_3)
    j MainScreen.input

MainScreen.end:
    li $s1, -1
MainScreen.enter:

    move $v0, $s1

    STACK_POP($ra, $s0, $s1, $s2)
FUNCTION_END



FUNCTION_BEGIN InfoScreen #Position Code: 3
    STACK_PUSH($ra, $s0, $s2)

    SCREEN_IMAGE(tela3)

    # INPUT
    li $s0, USER_INPUT

InfoScreen.input:
    # read user input
    lw   $s2, 0($s0)
    beqz $s2, InfoScreen.input

    # reset user input to zero
    sw   $zero, 0($s0)

    # $s2 has the user input

    # Check to see if the user pressed ESC
    beq $s2, 27, InfoScreen.back

    # Check to see if the user pressed BackSpace
    beq $s2, 8, InfoScreen.back


    j InfoScreen.input

InfoScreen.back:

    li $v0, 0

    STACK_POP($ra, $s0, $s2)
FUNCTION_END



FUNCTION_BEGIN SelectionScreen4 #Position Code: 1 or 2, paratemer
    STACK_PUSH($ra, $s0, $s1, $s2)

    SCREEN_IMAGE(tela2)

    # INPUT
    li $s0, USER_INPUT

    li $s1, 4  # Set $s1 to 4. $s1 is the position

SelectionScreen4.input:
    # read user input
    lw   $s2, 0($s0)
    beqz $s2, SelectionScreen4.input

    # reset user input to zero
    sw   $zero, 0($s0)

    # $s2 has the user input

    # Check to see if the user pressed ESC
    beq $s2, 27, SelectionScreen4.back

    # Check to see if the user pressed BackSpace
    beq $s2, 8, SelectionScreen4.back

    # Check to see if the user pressed w or W
    beq $s2, 119, SelectionScreen4.w
    beq $s2, 87, SelectionScreen4.w

    # Check to see if the user pressed s or S
    beq $s2, 115, SelectionScreen4.s
    beq $s2, 83, SelectionScreen4.s

    # Check to see if the user pressed enter
    beq $s2, 10, SelectionScreen4.end

    j SelectionScreen4.input

SelectionScreen4.w:

    beq  $s1, 4, SelectionScreen4.input
    addi $s1, $s1, -1

    j SelectionScreen4.screen

SelectionScreen4.s:

    beq  $s1, 8, SelectionScreen4.input
    addi $s1, $s1, 1

    j SelectionScreen4.screen

SelectionScreen4.screen:

    beq $s1, 4, SelectionScreen4.tela4
    beq $s1, 5, SelectionScreen4.tela5
    beq $s1, 6, SelectionScreen4.tela6
    beq $s1, 7, SelectionScreen4.tela7
    beq $s1, 8, SelectionScreen4.tela8

SelectionScreen4.tela4:

    SCREEN_IMAGE(tela1_1)
    j SelectionScreen4.input

SelectionScreen4.tela5:

    SCREEN_IMAGE(tela1_2)
    j SelectionScreen4.input

SelectionScreen4.tela6:

    SCREEN_IMAGE(tela1_3)
    j SelectionScreen4.input

SelectionScreen4.tela7:

    SCREEN_IMAGE(tela1_4)
    j SelectionScreen4.input

SelectionScreen4.tela8:

    SCREEN_IMAGE(tela1_5)
    j SelectionScreen4.input


SelectionScreen4.back:

    li $s1, 0

SelectionScreen4.end:
    move $v0, $s1

    STACK_POP($ra, $s0, $s1, $s2)
FUNCTION_END


    # Selection for 8bits
FUNCTION_BEGIN SelectionScreen8
    STACK_PUSH($ra, $s0, $s1, $s2)

    SCREEN_IMAGE(tela2)

    # INPUT
    li $s0, USER_INPUT

    li $s1, 9  # Set $s1 to 4. $s1 is the position

SelectionScreen8.input:
    # read user input
    lw   $s2, 0($s0)
    beqz $s2, SelectionScreen8.input

    # reset user input to zero
    sw   $zero, 0($s0)

    # $s2 has the user input

    # Check to see if the user pressed ESC
    beq $s2, 27, SelectionScreen8.back

    # Check to see if the user pressed BackSpace
    beq $s2, 8, SelectionScreen8.back

    # Check to see if the user pressed w or W
    beq $s2, 119, SelectionScreen8.w
    beq $s2, 87, SelectionScreen8.w

    # Check to see if the user pressed s or S
    beq $s2, 115, SelectionScreen8.s
    beq $s2, 83, SelectionScreen8.s

    # Check to see if the user pressed enter
    beq $s2, 10, SelectionScreen8.end

    j SelectionScreen8.input

SelectionScreen8.w:

    beq  $s1, 9, SelectionScreen8.input
    addi $s1, $s1, -1

    j SelectionScreen8.screen

SelectionScreen8.s:

    beq  $s1, 13, SelectionScreen8.input
    addi $s1, $s1, 1

    j SelectionScreen8.screen

SelectionScreen8.screen:

    beq $s1, 9, SelectionScreen9.tela9
    beq $s1, 10, SelectionScreen10.tela10
    beq $s1, 11, SelectionScreen11.tela11
    beq $s1, 12, SelectionScreen12.tela12
    beq $s1, 13, SelectionScreen13.tela13

SelectionScreen8.tela9:

    SCREEN_IMAGE(tela2_1)
    j SelectionScreen8.input

SelectionScreen8.tela10:

    SCREEN_IMAGE(tela2_2)
    j SelectionScreen8.input

SelectionScreen8.tela11:

    SCREEN_IMAGE(tela2_3)
    j SelectionScreen8.input

SelectionScreen8.tela12:

    SCREEN_IMAGE(tela2_4)
    j SelectionScreen8.input

SelectionScreen8.tela13:

    SCREEN_IMAGE(tela2_4)
    j SelectionScreen8.input

SelectionScreen8.back:
    
    li $s1, 0

SelectionScreen8.end:
    move $v0, $s1

    STACK_POP($ra, $s0, $s1, $s2)
FUNCTION_END



# Funcao do gameloop para 4 colunas de tiles
#
# $a0: Endereco da musica, com a quantidade de notas no primeiro elemento
FUNCTION_BEGIN Gameloop4 #Posiition code 4 or 5
    STACK_PUSH($ra, $s0, $s1, $s2)

    # Load song into $s2
    move $s2, $a0
    # Skip size
    addi $s2, $s2, 4

    # Load random tiles into $s1
    li   $a1, 4
    jal  CreateRandomTiles
    la   $s1, tiles

    # INPUT
    li   $s0, USER_INPUT

    j    Gameloop4.display
Gameloop4.input:
    # read user input
    lw   $t0, 0($s0)
    beqz $t0, Gameloop4.input

    # reset user input to zero
    sw   $zero, 0($s0)

    # subtract '0' to obtain true number
    addi $t0, $t0, -48

    # Test if user entered 1, 2, 3, or 4
    lw   $t1, 0($s1)
    bne  $t0, $t1, Gameloop4.failure

    # Play note
    li   $v0, 31
    lw   $a0, 0($s2)
    li   $a1, 1500
    li   $a2, 0
    li   $a3, 0x7F
    syscall

    # Go to next note
    addi $s2, $s2, 4

    # Go to next tile
    addi $s1, $s1, 4

    # If tile is 0, then the song ended
    lw   $t0, 0($s1)
    beqz $t0, Gameloop4.success

    #
    # DISPLAY
    #
Gameloop4.display:
    CLEAR_SCREEN(COR_SCREEN)

    # The logic to display the tiles in the correct column is:
    # (number of column - 1) * 8
    li   $a2, COR_TILE

    # Load the width of the rectangle
    li   $a3, RECT_WIDTH_4T

    # Bottom row
    lw   $a0, 0($s1)
    beqz $a0, Gameloop4.input
    addi $a0, $a0, -1
    rol  $a0, $a0, 3
    li   $a1, 48
    jal  DrawRect

    # Middle-Bottom row
    lw   $a0, 4($s1)
    beqz $a0, Gameloop4.input
    addi $a0, $a0, -1
    rol  $a0, $a0, 3
    li   $a1, 32
    jal  DrawRect

    # Middle-Top row
    lw   $a0, 8($s1)
    beqz $a0, Gameloop4.input
    addi $a0, $a0, -1
    rol  $a0, $a0, 3
    li   $a1, 16
    jal  DrawRect

    # Top row
    lw   $a0, 12($s1)
    beqz $a0, Gameloop4.input
    addi $a0, $a0, -1
    rol  $a0, $a0, 3
    move $a1, $zero
    jal  DrawRect

    j    Gameloop4.input

Gameloop4.failure:

    CLEAR_SCREEN(COR_FAIL)

    # Play failure note
    li   $v0, 31
    li   $a0, 15
    li   $a1, 5000
    li   $a2, 0
    li   $a3, 0x7F
    syscall

    j    Gameloop4.end

Gameloop4.success:

    CLEAR_SCREEN(COR_SUCCESS)

Gameloop4.end:
    STACK_POP($ra, $s0, $s1, $s2)
FUNCTION_END



# Funcao do gameloop para 4 colunas de tiles
#
# $a0: Endereco da musica, com a quantidade de notas no primeiro elemento
FUNCTION_BEGIN Gameloop8 #Posiition code 4 or 5
    STACK_PUSH($ra, $s0, $s1, $s2)

    # Load song into $s2
    move $s2, $a0
    # Skip size
    addi $s2, $s2, 4

    # Load random tiles into $s1
    li   $a1, 8
    jal  CreateRandomTiles
    la   $s1, tiles

    # INPUT
    li   $s0, USER_INPUT

    j    Gameloop8.display
Gameloop8.input:
    # read user input
    lw   $t0, 0($s0)
    beqz $t0, Gameloop8.input

    # reset user input to zero
    sw   $zero, 0($s0)

    # subtract '0' to obtain true number
    addi $t0, $t0, -48

    # Test if user entered 1, 2, 3, or 4
    lw   $t1, 0($s1)
    bne  $t0, $t1, Gameloop8.failure

    # Play note
    li   $v0, 31
    lw   $a0, 0($s2)
    li   $a1, 1500
    li   $a2, 0
    li   $a3, 0x7F
    syscall

    # Go to next note
    addi $s2, $s2, 4

    # Go to next tile
    addi $s1, $s1, 4

    # If tile is 0, then the song ended
    lw   $t0, 0($s1)
    beqz $t0, Gameloop8.success

    #
    # DISPLAY
    #
Gameloop8.display:
    CLEAR_SCREEN(COR_SCREEN)

    # The logic to display the tiles in the correct column is:
    # (number of column - 1) * 8
    li   $a2, COR_TILE

    # Load the width of the rectangle
    li   $a3, RECT_WIDTH_8T

    # Bottom row
    lw   $a0, 0($s1)
    beqz $a0, Gameloop8.input
    addi $a0, $a0, -1
    rol  $a0, $a0, 2
    li   $a1, 48
    jal  DrawRect

    # Middle-Bottom row
    lw   $a0, 4($s1)
    beqz $a0, Gameloop8.input
    addi $a0, $a0, -1
    rol  $a0, $a0, 2
    li   $a1, 32
    jal  DrawRect

    # Middle-Top row
    lw   $a0, 8($s1)
    beqz $a0, Gameloop8.input
    addi $a0, $a0, -1
    rol  $a0, $a0, 2
    li   $a1, 16
    jal  DrawRect

    # Top row
    lw   $a0, 12($s1)
    beqz $a0, Gameloop8.input
    addi $a0, $a0, -1
    rol  $a0, $a0, 2
    move $a1, $zero
    jal  DrawRect

    j    Gameloop8.input

Gameloop8.failure:

    CLEAR_SCREEN(COR_FAIL)

    # Play failure note
    li   $v0, 31
    li   $a0, 15
    li   $a1, 5000
    li   $a2, 0
    li   $a3, 0x7F
    syscall

    j    Gameloop8.end

Gameloop8.success:

    CLEAR_SCREEN(COR_SUCCESS)

Gameloop8.end:
    STACK_POP($ra, $s0, $s1, $s2)
FUNCTION_END


# Funcao de criar tiles aleatorias
# $a0: Endereco da musica
# $a1: Quantidade de tiles para gerar (4 ou 8)
FUNCTION_BEGIN CreateRandomTiles
    STACK_PUSH($s0, $s1, $s2, $s3, $a0)

    # Save $a1
    move $s3, $a1




    # Get length of song
    lw   $s2, 0($a0)

    # Get the current time
    li   $v0, 30
    syscall

    # Set the rgn seed with the current time
    li   $v0, 40
    xor  $a0, $a0, $a0
    move $a1, $a0
    syscall

    # Load upper range of the rgn
    li   $v0, 42
    move $a1, $s3

    la   $s0, tiles  # iterator

    # Calculate end value for the loop
    rol  $s2, $s2, 2
    add  $s1, $s0, $s2
CreateRandomTiles.forloop:
    beq  $s0, $s1, CreateRandomTiles.endforloop

CreateRandomTiles.retryunique:
    # Get random number in interval [0, $a1 - 1]
    xor  $a0, $a0, $a0
    syscall

    # Add 1 to get [1, $a1]
    addi $a0, $a0, 1

    # Ensure that the new tile isn't the same as the previous one
    lw   $t0, -4($s0)
    beq  $t0, $a0, CreateRandomTiles.retryunique

    # Write to the vector
    sw   $a0, 0($s0)

    addi $s0, $s0, 4       # Increment %s0 by 4
    j    CreateRandomTiles.forloop
CreateRandomTiles.endforloop:

    # Add the 0 terminator to the stream of tiles
    sw   $zero, 0($s0)

    STACK_POP($s0, $s1, $s2, $s3, $a0)
FUNCTION_END



# Funcao de limpar a tela
# $a0: cor
FUNCTION_BEGIN ClearScreen
    STACK_PUSH($s0, $s1)
    li    $s0, SCREEN_BEGIN # iterator
    li    $s1, SCREEN_END   # end value of the for loop
ClearScreen.forloop:
    beq   $s0, $s1, ClearScreen.endforloop
    sw    $a0, 0($s0)       # Set $s0 to the color stored in $a0
    addi  $s0, $s0, 4       # Increment %s0 by 4
    j     ClearScreen.forloop
ClearScreen.endforloop:
    STACK_POP($s0, $s1)
FUNCTION_END



# Funcao que desenha um retangulo na posicao (x, y), com a largura 8 e altura 16
# $a0: x
# $a1: y
# $a2: cor
# $a3: largura do retangulo
FUNCTION_BEGIN DrawRect
    STACK_PUSH($s0, $s1)
    add  $s0, $a0, $a3         # Stop condition variable
    add  $s1, $a1, RECT_HEIGHT # Stop condition variable
DrawRect.forloop1:

    beq  $a1, $s1, DrawRect.endforloop1 # i < y + 16

    move $t0, $a0                       # j = x
DrawRect.forloop2:
    beq $t0, $s0, DrawRect.endforloop2 # j < x + 8

    move $t1, $a1                       # $t1 = y
    rol  $t1, $t1, 5                    # $t1 = y  * SCREEN_WIDTH
    add  $t1, $t1, $t0                  # $t1 = y  * SCREEN_WIDTH + x
    rol  $t1, $t1, 2                    # $t1 = (y * SCREEN_WIDTH + x) * 4
    addi $t1, $t1, SCREEN_BEGIN         # $t1 = (y * SCREEN_WIDTH + x) * 4 + SCREEN_BEGIN
    sw   $a2, ($t1)                     # tela[y*w + x] = $a2

    addi $t0, $t0, 1                    # j++
    j DrawRect.forloop2
DrawRect.endforloop2:

    addi $a1, $a1, 1                    # i++
    j DrawRect.forloop1
DrawRect.endforloop1:
    STACK_POP($s0, $s1)
FUNCTION_END



# Funcao que imprime uma tela
# $a0: endereco de memoria com o vetor de tela
FUNCTION_BEGIN ScreenImage
    STACK_PUSH($s0, $s1)
    li    $s0, SCREEN_BEGIN # iterator
    li    $s1, SCREEN_END   # end value of the for loop
ScreenImage.forloop:
    beq   $s0, $s1, ScreenImage.endforloop
    lw    $t0, 0($a0)
    sw    $t0, 0($s0)       # Set $s0 to the color stored in $a0
    addi  $s0, $s0, 4       # Increment %s0 by 4
    addi  $a0, $a0, 4
    j     ScreenImage.forloop
ScreenImage.endforloop:
    STACK_POP($s0, $s1)
FUNCTION_END
