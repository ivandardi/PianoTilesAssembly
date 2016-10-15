# PIANO TILES IN MIPS ASSEMBLY
#
# A tela e de 32 x 64
#



#
# CONSTANTS
#

    # Endereco de inicio da tela
    .eqv SCREEN_BEGIN 0x10040000

    # Endereco de fim da tela
    .eqv SCREEN_END 0x10044000

    # Largura do retangulo do piano
    .eqv RECT_WIDTH 8

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
        li $a0, %cor
        jal ClearScreen
    .end_macro

    # Macro pra facilitar chamar a funcao de desenhar retangulo
    .macro DRAW_RECT (%x, %y, %cor)
        li $a0, %x
        li $a1, %y
        li $a2, %cor
        jal DrawRect
    .end_macro

    # Macro que faz o programa esperar por %ms milissegundos
    .macro SLEEP(%ms)
        li $v0, 32
        li $a0, %ms
        syscall
    .end_macro

    # Macros que facilitam salvar na pilha. Os registradores sao salvos em ordem
    .macro STACK_SAVE(%a)
        addi $sp, $sp, -4
        sw %a, 0($sp)
    .end_macro

    .macro STACK_SAVE(%a, %b)
        addi $sp, $sp, -8
        sw %a, 0($sp)
        sw %b, 4($sp)
    .end_macro

    .macro STACK_SAVE(%a, %b, %c)
        addi $sp, $sp, -12
        sw %a, 0($sp)
        sw %b, 4($sp)
        sw %c, 8($sp)
    .end_macro

    .macro STACK_SAVE(%a, %b, %c, %d)
        addi $sp, $sp, -16
        sw %a, 0($sp)
        sw %b, 4($sp)
        sw %c, 8($sp)
        sw %d, 12($sp)
    .end_macro

    .macro STACK_LOAD(%a)
        lw %a, 0($sp)
        addi $sp, $sp, 4
    .end_macro

    .macro STACK_LOAD(%a, %b)
        lw %a, 0($sp)
        lw %b, 4($sp)
        addi $sp, $sp, 8
    .end_macro

    .macro STACK_LOAD(%a, %b, %c)
        lw %a, 0($sp)
        lw %b, 4($sp)
        lw %c, 8($sp)
        addi $sp, $sp, 12
    .end_macro

    .macro STACK_LOAD(%a, %b, %c, %d)
        lw %a, 0($sp)
        lw %b, 4($sp)
        lw %c, 8($sp)
        lw %d, 12($sp)
        addi $sp, $sp, 16
    .end_macro

#
# PROGRAM
#

.data

    tiles: .space 51
    ttls: .word 42, 60, 60, 67, 67, 69, 69, 67, 65, 65, 64, 64, 62, 62, 60, 67, 67, 65, 65, 64, 64, 62, 67, 67, 65, 65, 64, 64, 62, 60, 60, 67, 67, 69, 69, 67, 65, 65, 64, 64, 62, 62, 60
    hbty: .word 25, 60, 60, 62, 60, 65, 64, 60, 60, 62, 60, 67, 65, 69, 69, 72, 69, 65, 64, 62, 70, 70, 69, 65, 67, 65

.text

main:
    CLEAR_SCREEN(COR_SCREEN)
    
    la $a0, hbty
    jal Gameloop

    DONE



# Funcao do gameloop
#
# $a0: Endereco da musica, com a quantidade de notas no primeiro elemento
FUNCTION_BEGIN Gameloop

    STACK_SAVE($ra, $s0, $s1, $s2)

    # Load random tiles into $s1
    jal CreateRandomTiles
    la $s1, tiles

    # Load TTLS into $s2
    move $s2, $a0
    # Skip size
    addi $s2, $s2, 4

    # INPUT
    li $s0, USER_INPUT

    j Gameloop.display
Gameloop.input:
    # read user input
    lw $t1, 0($s0)
    beqz $t1, Gameloop.input

    # reset user input to zero
    sw $zero, 0($s0)

    # subtract '0' to obtain true number
    subi $t1, $t1, 48

    # Test if user entered 1, 2, 3, or 4
    lw $t0, 0($s1)
    bne $t1, $t0, Gameloop.failure

    # Play note
    li $v0, 31
    lw $a0, 0($s2)
    li $a1, 1500
    li $a2, 0
    li $a3, 0x7F
    syscall

    # Go to next note
    addi $s2, $s2, 4

    # Go to next tile
    addi $s1, $s1, 4

    # If tile is 0, then the song ended
    lw $t0, 0($s1)
    beqz $t0, Gameloop.endsong

    #
    # DISPLAY
    #
Gameloop.display:
    CLEAR_SCREEN(COR_SCREEN)

    # The logic to display the tiles in the correct column is:
    # (number of column - 1) * 8
    li $a2, COR_TILE

    # Bottom row
    lw   $a0, 0($s1)
    beqz $a0, Gameloop.input
    addi $a0, $a0, -1
    rol  $a0, $a0, 3
    li   $a1, 48
    jal DrawRect

    # Middle-Bottom row
    lw   $a0, 4($s1)
    beqz $a0, Gameloop.input
    addi $a0, $a0, -1
    rol  $a0, $a0, 3
    li   $a1, 32
    jal DrawRect

    # Middle-Top row
    lw   $a0, 8($s1)
    beqz $a0, Gameloop.input
    addi $a0, $a0, -1
    rol  $a0, $a0, 3
    li   $a1, 16
    jal DrawRect

    # Top row
    lw   $a0, 12($s1)
    beqz $a0, Gameloop.input
    addi $a0, $a0, -1
    rol  $a0, $a0, 3
    move $a1, $zero
    jal DrawRect

    j Gameloop.input

Gameloop.failure:

    CLEAR_SCREEN(COR_FAIL)
    j Gameloop.end

Gameloop.endsong:

    CLEAR_SCREEN(COR_SUCCESS)

Gameloop.end:

    STACK_LOAD($ra, $s0, $s1, $s2)

FUNCTION_END


# Funcao de criar tiles aleatorias
# $a0: Endereco da musica
FUNCTION_BEGIN CreateRandomTiles
    STACK_SAVE($s0, $s1, $s2, $a0)
    
    # Get length of song
    lw    $s2, 0($a0)
    
    # Get the current time
    li    $v0, 30
    syscall
    
    # Set the rgn seed with the current time
    li    $v0, 40
    move  $a1, $a0
    xor   $a0, $a0, $a0
    syscall

    # Load upper range of the rgn
    li    $v0, 42
    li    $a1, 4
            
    la    $s0, tiles        # iterator
    
    # Calculate end value for the loop
    rol   $s2, $s2, 2
    add   $s1, $s0, $s2
CreateRandomTiles.forloop:
    beq   $s0, $s1, CreateRandomTiles.endforloop
    
    # Get random number in interval [0, 3]
    xor   $a0, $a0, $a0
    syscall
    
    # Add 1 to get [1, 4]
    addi  $a0, $a0, 1
    
    # Write to the vector
    sw    $a0, 0($s0)
    
    addi  $s0, $s0, 4       # Increment %s0 by 4
    j     CreateRandomTiles.forloop
CreateRandomTiles.endforloop:

    # Add the 0 terminator to the stream of tiles
    sw    $zero, 0($s0)   
    
    STACK_LOAD($s0, $s1, $s2, $a0)
FUNCTION_END



# Funcao de limpar a tela
# $a0: cor
FUNCTION_BEGIN ClearScreen
    STACK_SAVE($s0, $s1)
    li    $s0, SCREEN_BEGIN # iterator
    li    $s1, SCREEN_END   # end value of the for loop
ClearScreen.forloop:
    beq   $s0, $s1, ClearScreen.endforloop
    sw    $a0, 0($s0)       # Set $s0 to the color stored in $a0
    addi  $s0, $s0, 4       # Increment %s0 by 4
    j     ClearScreen.forloop
ClearScreen.endforloop:
    STACK_LOAD($s0, $s1)
FUNCTION_END



# Funcao que desenha um retangulo na posicao (x, y), com a largura 8 e altura 16
# $a0: x
# $a1: y
# $a2: cor
FUNCTION_BEGIN DrawRect
    STACK_SAVE($s0, $s1)
    add  $s0, $a0, RECT_WIDTH  # Stop condition variable
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
    STACK_LOAD($s0, $s1)
FUNCTION_END
