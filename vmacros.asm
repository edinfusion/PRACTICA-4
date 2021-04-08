
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

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Obtener Caracter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;devueleve codigo ASCII del
;caracter leido sin mostrarlo en pantalla
getCaracterSinMostrar macro
    mov ah,00h
    int 16h
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% get DIa %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getDia macro vecDia
    push ax
    push bx
    push dx
    xor ax,ax
    xor bx,bx
        ;******************** DIAS***********************************
        MOV AH,2AH; interrupcion para obtener fecha
        INT 21H       ; se obtienen dias a traves de dl
        MOV AL,DL     ;los muevo a al para poder hacer la conversion con ascii con aam
        AAM       ;LO QUE HACE ES QUE EN LA PARTE ALTA SE GUARDEN DEL 0 AL 9 AL IGUAL QUE EN LA PARTE BAJA..F POR NO SABERLO ANTES
        MOV BX,AX ;hago una copia a bx para poder utilizar la conversion 
        ;CONVER
        MOV DL,BH      ; SE TOMAN LOS VALORES DE BH
        ADD DL,30H     ; ASCII OBTENCION CARACTER
        MOV al,BL      ; BL TOMAN VALORES
        ADD al,30H     ; ASCII OBTENCION CARACTER
        ;YA QUE TENGO LOS DIAS COMO DEBEN DE SER LOS ALMACENO
        mov vecDia[0],dl
        mov vecDia[1],al
    pop dx
    pop bx
    pop ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% get mes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getMes macro vecMes
    push ax
    push bx
    push dx
    xor ax,ax
    xor bx,bx
    ;********************MES***********************************
        MOV AH,2AH    ; se obtienen MESES
        INT 21H
        MOV AL,DH     ; MES EN DH
        AAM       ;LO QUE HACE ES QUE EN LA PARTE ALTA SE GUARDEN DEL 0 AL 9 AL IGUAL QUE EN LA PARTE BAJA..F POR NO SABERLO ANTES
        MOV BX,AX ;hago una copia a bx para poder utilizar la conversion 
        ;CONVER
        MOV DL,BH      ; SE TOMAN LOS VALORES DE BH
        ADD DL,30H     ; ASCII OBTENCION CARACTER
        MOV al,BL      ; BL TOMAN VALORES
        ADD al,30H     ; ASCII OBTENCION CARACTER
        ;YA QUE TENGO LOS MESES COMO DEBEN DE SER LOS ALMACENO
        mov vecMes[0],dl
        mov vecMes[1],al
    pop dx
    pop bx
    pop ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% get Año %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getAnho macro vecAn
    push ax
    push bx
    push dx
    xor ax,ax
    xor bx,bx
;********************AÑO**********************************
        MOV AH,2AH    ; To get System Date
        INT 21H
        ADD CX,0F830H ; AÑO EN CX** PARA QUE NO AFECTE SE ENCONTRO ESTA NEGACION YA QUE SINO NO JALA AAM
        MOV AX,CX     ; 
        AAM
        MOV BX,AX
        ;DISP
        ;CONVER
        MOV DL,BH      ; SE TOMAN LOS VALORES DE BH
        ADD DL,30H     ; ASCII OBTENCION CARACTER
        MOV al,BL      ; BL TOMAN VALORES
        ADD al,30H     ; ASCII OBTENCION CARACTER
        ;YA QUE TENGO LOS AÑOS COMO DEBEN DE SER LOS ALMACENO
        mov vecAn[0],dl
        mov vecAn[1],al
    pop dx
    pop bx
    pop ax
endm

getHora macro vecHora
    push ax
    push bx
    push dx
    ;****************HORA******************************
    MOV AH,2CH    ; interrupcion para obtener hora 21h/2ch
    INT 21H
    MOV AL,CH     ; hora se devuelve en en ch, al igual que fecha se hace en aam para corregir el ascii
    AAM
    MOV BX,AX
    ;CONVER
    MOV DL,BH      ; SE TOMAN LOS VALORES DE BH
    ADD DL,30H     ; ASCII OBTENCION CARACTER
    MOV al,BL      ; BL TOMAN VALORES
    ADD al,30H     ; ASCII OBTENCION CARACTER
    ;YA QUE TENGO LAS HORAS COMO DEBEN DE SER LOS ALMACENO
    mov vecHora[0],dl
    mov vecHora[1],al
    pop dx
    pop bx
    pop ax
endm

getMin macro vecMin
    push ax
    push bx
    push dx
    ;************************MINUTOS****************************
    MOV AH,2CH    ; interrupcion para obtener hora 21h/2ch
    INT 21H
    MOV AL,CL     ; MINS se devuelve en en cL
    AAM
    MOV BX,AX
    ;CONVER
    MOV DL,BH      ; SE TOMAN LOS VALORES DE BH
    ADD DL,30H     ; ASCII OBTENCION CARACTER
    MOV al,BL      ; BL TOMAN VALORES
    ADD al,30H     ; ASCII OBTENCION CARACTER
    ;YA QUE TENGO LOS MINS COMO DEBEN DE SER LOS ALMACENO
    mov vecMin[0],dl
    mov vecMin[1],al
    pop dx
    pop bx
    pop ax
endm

getSeg macro vecSeg
    push ax
    push bx
    push dx
    ;************************SEGUNDOS***************************
    MOV AH,2CH    ; interrupcion para obtener hora 21h/2ch
    INT 21H
    MOV AL,DH     ; SEG se devuelve en en DH
    AAM
    MOV BX,AX
    ;CONVER
    MOV DL,BH      ; SE TOMAN LOS VALORES DE BH
    ADD DL,30H     ; ASCII OBTENCION CARACTER
    MOV al,BL      ; BL TOMAN VALORES
    ADD al,30H     ; ASCII OBTENCION CARACTER
    ;YA QUE TENGO LOS SEGS COMO DEBEN DE SER LOS ALMACENO
    mov vecSeg[0],dl
    mov vecSeg[1],al
    pop dx
    pop bx
    pop ax
endm