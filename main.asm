# PIANO TILES IN MIPS ASSEMBLY
#
# A tela é de 32 x 64
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
    
    # Preto
    .eqv COR_BLACK 0x00000000
    
    # Branco
    .eqv COR_WHITE 0x00FFFFFF

    # Vermelho
    .eqv COR_RED 0x00FF0000

    # Verde
    .eqv COR_GREEN 0x0000FF00

    # Azul
    .eqv COR_BLUE 0x000000FF

#
# MACROS
#

    # Macro que para a execução do programa
    .macro DONE
        li $v0,10
        syscall
    .end_macro

    # Macro de início de função
    .macro FUNCTION_BEGIN (%name)
        %name :
    .end_macro

    # Macro de fim de função
    .macro FUNCTION_END
        jr $ra
    .end_macro

    # Macro que toca nota de piano. pitch = 60 significa C
    .macro PLAY_NOTE (%pitch)
        li $v0, 33
        li $a0, %pitch
        li $a1, 1200
        li $a2, 0
        li $a3, 0x7F
        syscall
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

#
# PROGRAM
#

.data

.text

main:
    
    jal Gameloop
    
    DONE



# Funcao do gameloop
#
#
FUNCTION_BEGIN Gameloop

    # INPUT

    li $t0, USER_INPUT
Gameloop.input:
    SLEEP(250)
    # read user input
    lw $t1, 0($t0)
    beqz $t1, Gameloop.input
    
    # reset user input to zero
    sw $zero, 0($t0)
    
    # subtract '0' to obtain true number
    subi $t1, $t1, 48
    
    # Test if user entered 1, 2, 3, or 4
    beq $t1, 1, Gameloop.ifEquals1
    beq $t1, 2, Gameloop.ifEquals2
    beq $t1, 3, Gameloop.ifEquals3
    beq $t1, 4, Gameloop.ifEquals4
    # Invalid input, try again
    j Gameloop.input
    
Gameloop.ifEquals1:
    PLAY_NOTE(60)
    j Gameloop.input
Gameloop.ifEquals2:
    PLAY_NOTE(62)
    j Gameloop.input
Gameloop.ifEquals3:
    PLAY_NOTE(64)
    j Gameloop.input
Gameloop.ifEquals4:
    PLAY_NOTE(65)
    j Gameloop.input
    
FUNCTION_END



# Função de limpar a tela
# $a0: cor
FUNCTION_BEGIN ClearScreen
    li    $t0, SCREEN_BEGIN # iterator
    li    $t1, SCREEN_END   # end value of the for loop
.forloop:
    sub   $t2, $t0, $t1     # $t1 is bit flag
    beqz  $t2, .endforloop
    sw    $a0, 0($t0)       # Set $t0 to the color stored in $a0
    addiu $t0, $t0, 4       # Increment %t0 by 4
    j     .forloop
.endforloop:
FUNCTION_END



# Funcao que desenha um retangulo na posicao (x, y), com a largura 8 e altura 16
# $a0: x
# $a1: y
# $a2: cor
FUNCTION_BEGIN DrawRect
    add $t0, $a0, RECT_WIDTH
    add $t1, $a1, RECT_HEIGHT
DrawRect.forloop1:
    sub  $v0, $t1, $a1
    beqz $v0, DrawRect.endforloop1

    move $t9, $a0
DrawRect.forloop2:
    sub  $v0, $t0, $t9
    beqz $v0, DrawRect.endforloop2

    move $t8, $a1                # $t8 = y
    rol  $t8, $t8, 5             # $t8 = y  * SCREEN_WIDTH
    add  $t8, $t8, $t9           # $t8 = y  * SCREEN_WIDTH + x
    rol  $t8, $t8, 2             # $t8 = (y * SCREEN_WIDTH + x) * 4
    addi $t8, $t8, SCREEN_BEGIN  # $t8 = (y * SCREEN_WIDTH + x) * 4 + SCREEN_BEGIN
    sw   $a2, ($t8)              # tela[y*w + x] = $a2

    addi $t9, $t9, 1
    j DrawRect.forloop2
DrawRect.endforloop2:

    addi $a1, $a1, 1
    j DrawRect.forloop1
DrawRect.endforloop1:
FUNCTION_END

