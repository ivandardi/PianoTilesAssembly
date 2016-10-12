# PIANO TILES IN MIPS ASSEMBLY
#
# A tela � de 32 x 64
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

    # Macro que para a execu��o do programa
    .macro DONE
        li $v0,10
        syscall
    .end_macro

    # Macro de in�cio de fun��o
    .macro FUNCTION_BEGIN (%name)
        %name :
    .end_macro

    # Macro de fim de fun��o
    .macro FUNCTION_END
        jr $ra
    .end_macro

    # Macro que toca nota de piano. pitch = 60 significa C
    .macro PLAY_NOTE (%pitch)
        li $v0, 31
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
    
    # Macros que facilitam salvar na pilha. Os registradores sao salvos em ordem
    .macro STACK_SAVE(%a)
        subi $sp, $sp, 4
        sw %a, 0($sp)
    .end_macro
    
    .macro STACK_SAVE(%a, %b)
        subi $sp, $sp, 8
        sw %a, 0($sp)
        sw %b, 4($sp)
    .end_macro

    .macro STACK_SAVE(%a, %b, %c)
        subi $sp, $sp, 12
        sw %a, 0($sp)
        sw %b, 4($sp)
        sw %c, 8($sp)
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

#
# PROGRAM
#

.data

    notesdebug: .word 1, 2, 3, 4, 3, 2, 1, 4, 3, 2, 1, 2, 3, 4, 0

.text

main:
    
    jal Gameloop
    
    DONE



# Funcao do gameloop
#
#
FUNCTION_BEGIN Gameloop

    STACK_SAVE($ra, $s0, $s1)
    
    # Load first note into $s1
    la $s1, notesdebug
    
    # INPUT

    li $s0, USER_INPUT
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
    beq $t1, $t0, Gameloop.correctInput
    
    # Invalid input, user lost
    j Gameloop.failure
      
Gameloop.correctInput:

    # Check to see which note should be played
    beq $t1, 1, Gameloop.ifEquals1
    beq $t1, 2, Gameloop.ifEquals2
    beq $t1, 3, Gameloop.ifEquals3
    beq $t1, 4, Gameloop.ifEquals4
    
Gameloop.ifEquals1:
    PLAY_NOTE(60)
    j Gameloop.success
Gameloop.ifEquals2:
    PLAY_NOTE(62)
    j Gameloop.success
Gameloop.ifEquals3:
    PLAY_NOTE(64)
    j Gameloop.success
Gameloop.ifEquals4:
    PLAY_NOTE(65)
    j Gameloop.success

Gameloop.success:

    # Go to next note
    addi $s1, $s1, 4
    
    # If note is 0, then the song ended
    lw $t0, 0($s1)
    beqz $t0, Gameloop.failure
    j Gameloop.input

Gameloop.failure:

    STACK_LOAD($ra, $s0, $s1)

FUNCTION_END



# Fun��o de limpar a tela
# $a0: cor
FUNCTION_BEGIN ClearScreen
    STACK_SAVE($s0, $s1)
    li    $s0, SCREEN_BEGIN # iterator
    li    $s1, SCREEN_END   # end value of the for loop
.forloop:
    beq   $s0, $s1, .endforloop
    sw    $a0, 0($s0)       # Set $s0 to the color stored in $a0
    addiu $s0, $s0, 4       # Increment %s0 by 4
    j     .forloop
.endforloop:
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
    beq  $t0, $s0, DrawRect.endforloop2 # j < x + 8

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

