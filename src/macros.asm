
# Macro que para a execução do programa
.macro done
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
