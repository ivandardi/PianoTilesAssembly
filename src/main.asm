.include "constants.asm"
.include "macros.asm"

.data

.text

# Equivalente a função main()
__start:
        li $a0, 0x00FF0000
        jal ClearScreen
        done


# Função de limpar a tela
# Parametro $a: Valor 32 bit, cor que a tela ficará
FUNCTION_BEGIN ClearScreen
    li    $t0, SCREEN_BEGIN # iterator
    li    $t1, SCREEN_END   #end value of the for loop
.forloop:
    sub   $t2, $t0, $t1     # $t1 is bit flag
    beqz  $t2, .end
    sw    $a0, 0($t0)       # Set $t0 to the color stored in $a0
    addiu $t0, $t0, 4       # Increment %t0 by 4
    j     .forloop
.end:
FUNCTION_END


