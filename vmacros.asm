;limpia la consola con 
;interrupcion 10h
LimpiarPantalla macro
;Para ingresar al modo 13h, solo use el interruptor de pantalla
    mov ax, 0013h
    int 10h
;Para salir del modo 13h, simplemente regrese la pantalla al modo texto
    mov ax, 0003h
    int 10h
endm