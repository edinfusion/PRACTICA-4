


;**************************************************************
;---------------------macro para entrada .xml------------------
;**************************************************************

;obtener la ruta ingresada param es entrada
getRuta macro stringbuff, exten
    LOCAL ObtenerCaracter, Centinela, Extension
    xor si,si ;limpio indice de origen para evitar errores
    mov di,0
    ObtenerCaracter:
        getCaracter ;ya esta en vmacros
        cmp al, 2eh ; si es un punto "."
        je Extension;brincar a extension
        ;if al == enter
        ;cmp al,0dh ;codigo ascii del salto de linea en hex
        ;then
        ;je Centinela ;si es igual al sato es el fin
        ;else
        mov stringbuff[si],al
        inc si ; si = si +1
        jmp ObtenerCaracter
    
    Extension:
        mov stringbuff[si],al
        mov exten[di],al;aca se va contatenando el .extension
        inc si ; si = si +1
        inc di ; si = si +1
        getCaracter
        cmp al,0dh
        je Centinela
        jmp Extension
    Centinela:
        mov al, 00h ;ingreso signo nulo en ascii
        mov stringbuff[si],al ;copio el fin en param
        mov exten[di],'$'
endm

;valida que la extension sea .xml
compararExtension macro ext_origin, ext_ingresada
    LOCAL INICIO,FIN
    xor si,si
    INICIO:
        mov bh, ext_origin[si]
        mov bl, ext_ingresada[si]
        cmp bh, bl
        jnz ERROR4
        cmp bh, '$'
        jz FIN
        inc si
        jmp INICIO  
    FIN:
endm

;obtengo la referencia del fichero 
abrirFichero macro entra, handler
    xor ax,ax
    mov ah,3dh
    mov al,010b
    lea dx, entra
    int 21h
    jc  ERROR2   ;aqui es por que se activo la bandera de CF, por lo tanto no existe o hay error en el archivo
    mov handler,ax  ;obtengo la referencia del archivo si todo va bien
endm

leerFichero macro numBy, vecLec, handler
    mov ah,3fh
    mov bx,handler
    mov cx,numBy
    lea dx,vecLec
    int 21h
    jc ERROR5
endm