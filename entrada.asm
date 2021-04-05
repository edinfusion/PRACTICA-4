


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

cerrarFichero macro handler
    xor ax,ax
    mov ah,3eh
    mov bx,handler
    int 21h
    jc  ERROR3    ;existe un problema al cerrar el archivo
endm

;analizador de entrada
;almacena los numeros que estan en el xml
;params: vectorEntrada
reconocerArchivo macro VectorIn
    LOCAL switcher,caso0,caso1,caso2,buscarPadre,get_Id,add_Numero,sal_tar,final_rec
    
    ;limpio contador de numeros
    mov TotalNumeros,0
    ;limpio vectores en donde almaceno numeros de entrada
    limpiarResuVec NumerosEntrada, SIZEOF NumerosEntrada, 24h
    limpiarResuVec NumerosEntradaCopia, SIZEOF NumerosEntradaCopia, 24h
    ;---
    xor si,si
    mov indice[0],'0'
    mov si,0

    switcher:
        cmp indice[0],'0';este reconoce el padre
        je caso0
        cmp indice[0],'1';este reconoce el ID de cada numero
        je caso1
        cmp indice[0],'2';aqui se reconocen numeros y se almacenan
        je caso2
        jmp final_rec

    ;este caso ayuda a saltar el padre
    caso0:
        cmp VectorIn[si],'<'
        je buscarPadre
        jmp sal_tar
    
    ;reconoce id de cada numero
    ;ayuda a ignorar esos caracteres hasta '>'
    ;luego viene el numero
    caso1:
        cmp VectorIn[si],'<'
        je get_Id
        jmp sal_tar

    ;aqui se reconocen los numeros que vienen dentro de
    ;>11< y se concatenan y se agregan a vector
    caso2:
        cmp VectorIn[si],'<'
        je sal_tar
        cmp VectorIn[si],48;si es <0
        jb sal_tar
        cmp VectorIn[si],57;si es >9
        ja sal_tar
        jmp add_Numero

    

    ;aqui se ingnoran todos los caracteres 
    ;hasta encontrar '>'
    buscarPadre:
        SaltarChars VectorIn
        ;imprimir bufferNombre
        ;getCaracter;;;;;;;;;;;;desde aqui esta bien hay que seguir validado
        mov indice[0],'1'; aca se manda para reconder el ID de operacion
        jmp sal_tar;PARA INC SI Y RETORNAR A SWITCH

    ;se ignoran caracter de id's
    get_Id:
        cmp VectorIn[si+1],'/';VERIFICAR SI EL SIG CHAR ES UN '/' ya que puede ser el cierre del id </numero>
        je sal_tar;SI LO ES SOLO SE RESTA Y NO SE AGREGA COMO ID

        SaltarChars VectorIn
        mov indice[0],'2';para pasar al caso 2
        jmp sal_tar;inc si y retorna switch
    
    ;aqui almaceno numero por numero de entrada
    add_Numero:
        inc TotalNumeros;contador de numeros
        copiarNumerosVal NumerosEntrada,VectorIn
        mov indice[0],'1'; aca se manda para reconder el ID de operacion
        jmp sal_tar

    sal_tar:
        ;si:
        cmp VectorIn[si],'$'
        je final_rec
        ;si no:
        inc si
        jmp switcher
    
    final_rec:

endm


;salta todos los caracteres
;params: vector
SaltarChars macro entradaa
    LOCAL whi, s_alir
    whi:
        cmp entradaa[si],62d;si llega a esto es que finaliza ">"
        je s_alir
        inc si
    jmp whi

    s_alir:
        ;inc di
endm

copiarNumerosVal macro copia,entrada
    LOCAL whil_ee, sall_ida

    ;push bx
    xor bx,bx
    xor ax,ax
    xor dx,dx
    mov bl,TotalNumeros
    mov cx,0000h
    dec bx

    whil_ee:
        cmp entrada[si],'<'
        je sall_ida
        mov al,entrada[si]
        sub al,30h
        push ax;guardo el valor anterior
        mov al,cl;muevo lo que tengo en cx para pasarlo a decenas
        mul decena;con esto se vuelve a decenas 
        mov cl,al;muevo el resultada a cx
        pop ax;restauro valor anterior
        mov ah,00h
        mov ch,00h
        mov dh,00h
        mov dx,cx
        add cx,ax;añado unidades
        inc si
    jmp whil_ee

    sall_ida:
        mov copia[bx],cl
        ;pop bx
endm
