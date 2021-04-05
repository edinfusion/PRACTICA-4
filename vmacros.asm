
;**************************************************************
;-----------------------macros funciones basicas---------------
;**************************************************************


;macro para impresion 
;con interrupcion 21H 
;recibe un "string"
imprimir macro cadena
    mov ah, 09h
    lea dx, cadena
    int 21h
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Esperar Caracter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;devueleve codigo ASCII del
;caracter leido
getCaracter macro
    mov ah,01h
    int 21h
endm

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


;me sirve para limpiar var, vec, etc
;params vector,numBytes, caracter
limpiarResuVec macro vector, numBy, char
    LOCAL ciclito
    push si
    push cx
    xor si,si
    xor cx,cx
    mov cx,numBy
    ciclito:
        mov vector[si],char
        inc si
        loop ciclito
    pop cx
    pop si
endm

;convierte letras Mayus a minus
;params Vector, numBys
aMinuscula macro Vector, numBYs
    LOCAL cicloconverMinus, salto
        mov cx,numBYs
        xor si,si
        cicloconverMinus:
            cmp Vector[si],64;pongo limites inf de < para que salte todos esos
            jb salto;  < aqui incrementa el si en dado caso no sea letra
            cmp Vector[si],91; pongo limites superiores para saltar y no tome carcter diferente de letra
            ja salto; >

            mov al, Vector[si];hago una copia para poder trabjar en la suma
            add al,32;se suma 32 para obtener la minuscula de esa letra
            mov Vector[si],al;obtengo la letra ya en minuscula

            salto:;incremento si
                inc si;si+=si
            loop cicloconverMinus
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COPIAR ARREGLO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;copia arreglos
;params: VecOriginal, VecCopia,PosI,Posf
CopiarArreglo macro arrayOr,ArrayCo,NoPosI,NoPosF
    LOCAL Ciclo1,fin
    push cx
    push si
    push bx
   limpiarResuVec ArrayCo, SIZEOF ArrayCo, 24h
    xor cx,cx
    mov cl,NoPosF
    xor si,si
    mov si,NoPosI
    Ciclo1:
        mov al, arrayOr[si]
        mov ArrayCo[si], al
        inc si
        cmp si,cx
        jb Ciclo1

    fin:
        pop bx
        pop si
        pop cx
endm
