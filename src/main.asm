.include "constants.asm"
.include "macros.asm"

.data

.text

# Equivalente a função main()
__start:
        li $a0, 1
        li $a1, 3
        li $a2, 0x000000FF
        jal DrawRect
        
#        li $a0, 0x00FFFFFF
#        jal ClearScreen
        done


# Função de limpar a tela
# Parametro $a0: Valor 32 bit, cor que a tela ficará
FUNCTION_BEGIN ClearScreen
    li    $t0, SCREEN_BEGIN # iterator
    li    $t1, SCREEN_END   #end value of the for loop
.forloop:
    sub   $t2, $t0, $t1     # $t1 is bit flag
    beqz  $t2, .endforloop
    sw    $a0, 0($t0)       # Set $t0 to the color stored in $a0
    addiu $t0, $t0, 4       # Increment %t0 by 4
    j     .forloop
.endforloop:
FUNCTION_END


# Funcao que desenha um retangulo na posicao (x, y), com a largura 8 e altura 16
# Parametro $a0: x
# Parametro $a1: y
# Parametro $a2: Valor 32 bit, cor de preenchimento do retangulo
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

