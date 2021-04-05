;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%% ESTABLECE VELOCIDAD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setvelocidad macro
    LOCAL vel0,vel1,vel2,vel3,vel4,vel5,vel6,vel7,vel8,vel9,errorr,Fiiiin
    getCaracter
    cmp al, '0'
    je vel0
    cmp al, '1'
    je vel1
    cmp al, '2'
    je vel2
    cmp al, '3'
    je vel3
    cmp al, '4'
    je vel4
    cmp al, '5'
    je vel5
    cmp al, '6'
    je vel6
    cmp al, '7'
    je vel7
    cmp al, '8'
    je vel8
    cmp al, '9'
    je vel9
    jmp errorr

    vel0:
        mov velocidad,1600
    jmp Fiiiin
    vel1:
        mov velocidad,1500
    jmp Fiiiin
    vel2:
        mov velocidad,1400
    jmp Fiiiin
    vel3:
        mov velocidad,1300
    jmp Fiiiin
    vel4:
        mov velocidad,1000
    jmp Fiiiin
    vel5:
        mov velocidad,800
    jmp Fiiiin
    vel6:
        mov velocidad,600
    jmp Fiiiin
    vel7:
        mov velocidad,400
    jmp Fiiiin
    vel8:
        mov velocidad,200
    jmp Fiiiin
    vel9:
        mov velocidad,100
    jmp Fiiiin

    errorr:
        imprimir ERROR_OR
        getCaracter
        cmp burbujas,1
        je burbuja
        cmp quicks,1
        je quick
        cmp shells,1
        je shell
        jmp Orders 

    Fiiiin:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ESTABLECE ORDEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;establece si es orden ascendente o descendente
setOrden macro
    LOCAL or_des,or_asc,ascBurbuja,ascQuick,ascShell,desBurbuja,desQuick,desShell,errorsillo,finnnnnn
    getCaracter
    cmp al, '1'
    je or_des
    cmp al, '2'
    je or_asc
    jmp errorsillo

    or_des:
        cmp burbujas,1
        je desBurbuja
        cmp quicks,1
        je desQuick
        cmp shells,1
        je desShell
    jmp errorsillo
    or_asc:
        cmp burbujas,1
        je ascBurbuja
        cmp quicks,1
        je ascQuick
        cmp shells,1
        je ascShell
    jmp errorsillo

    desBurbuja:
        CopiarArreglo NumerosEntrada,arrayBubble,0,TotalNumeros
        getNumeroMasGrande NumerosEntradaCopia
        modoVideo;DE AQUI YA SE TIENE QUE EMPEZAR A MOVER PUNTEROS !!!!!
        imprimirEnVideo 0d,1d,msg_order
        imprimirEnVideo 0d,25d,msg_time
        imprimirEnVideo 2d,1d,msg_vel
        dibujarMargen 6d,310d,26d,199d,15d;aqui de una hay que definir el margen en la macro
        SetAnchoBarra
        dibujarArreglo arrayBubble
        ;***********************AQUI SIGUE LLAMAR A METODO DESCENDENTE, ETC, AQUI ME QUEDE ***************************
        getCaracter
        jmp finnnnnn
    desQuick:

        jmp finnnnnn
    desShell:

        jmp finnnnnn
    
    ascBurbuja:

        jmp finnnnnn
    ascQuick:

        jmp finnnnnn
    ascShell:

        jmp finnnnnn

    

    errorsillo:
        imprimir ERROR_OR
        getCaracter
        cmp burbujas,1
        je burbuja
        cmp quicks,1
        je quick
        cmp shells,1
        je shell
        jmp Orders 
    finnnnnn:


endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NUMERO MAS ALTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;devuelve el numero mas grande del arreglo;
;params: vector
getNumeroMasGrande macro vector
    xor ax,ax
    xor bx,bx
    mov bl,TotalNumeros
    dec bx
    mov al,vector[bx]
    mov ThebigNum,al    
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Modo Video %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;-----------pantalla modo video 320*200
;       fil   col      fil    col
;ancho (0  ,   0  ) a ( 0  , 319 )
;largo (0  ,   0  ) a (199 ,  0  ) 
;ecuacion: 320*120+160

;modo_video
modoVideo macro
    mov ax,0013h
    int 10h
    mov ax,0A000h
    mov ds,ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%% PUNTERO A DS DATOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;Cambia DS a donde tenemos las variables 
punteroDSaDatos macro 
		push ax
		mov ax,@data
		mov ds,ax
		pop ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%% PUNTERO A DS VIDEO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;Cambia DS a donde tenemos las variables 
punteroDSaVideo macro 
		push ax
		mov ax,0A000h
		mov ds,ax
		pop ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%% IMPRIMIR EN VIDEO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;imprimeTextoEnVideo
;params: fil,col,text
imprimirEnVideo macro fil, col,cadena
    push ax
    punteroDSaDatos
    xor ax,ax
    mov ah,02h
    mov bh,00h
    mov dh,fil;guardo fila donde quiero imprimir
    mov dl,col;guardo columna donde quiero imprimir
    int 10h

    imprimir cadena
    punteroDSaVideo
    pop ax
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DIBUJAR UN PIXEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;dibujar un pixel(un punto)
;params: fil,col,color
pintar_pixel macro x_,y_,color
    push ax
    push bx
    push dx
    push di
    xor ax,ax
    xor bx,bx
    xor dx,dx
    xor di,di
    mov ax,320d ;320
    mov bx,x_
    mul bx ;320*x
    add ax,y_;320*x+y
    mov di,ax;se guarda la posicion que se obtiene atraves de la ecuacion para posicionar en la memoria
    punteroDSaDatos
    mov dl,color
    punteroDSaVideo
    mov [di],dl;en esa poscion de memoria colocar el color deseado
    pop di
    pop dx
    pop bx
    pop ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MARGEN VIDEO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;dibuja el marco de contorno
;params: limite izq, lder,larriba,labajo,color
dibujarMargen macro llef,lrig,lup,ldown,color
    LOCAL ciclito1,ciclito2
    push si
    xor si,si
    mov si,llef

    ;pinta los lados arriba y abajo ___
    ;                               ___
    ciclito1: 
        pintar_pixel lup, si, color
        pintar_pixel ldown, si, color
        inc si
        cmp si,lrig;si ya se llego al limite derecho pasar al siguiente ciclo
    jne ciclito1

    xor si,si
    mov si, lup
    ;pinta los margenes izq y derecho |  |
    ciclito2:
        pintar_pixel si, lrig, color
        pintar_pixel si, llef, color
        inc si
        cmp si, ldown;si ya se llego al limite de abajo finalizar
    jne ciclito2
    pop si 
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ANCHO DE BARRA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetAnchoBarra macro
    
    punteroDSaDatos
    push ax
    push bx
    push dx
    xor ax,ax
    xor bx,bx
    mov ah,0000h
    mov bh,0000h
    mov ax,100010011b ;300
    sub ax,bx
    xor dx,dx
    mov dh,0000h
    mov bl,TotalNumeros
    ;inc bx
    ;inc bx
    div bx
    mov AnchoBarra,ax
    pop dx
    pop bx
    pop ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ALTURA BARRA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;params: thebignum
SetAltura macro Puntaje
    punteroDSaDatos
    push ax
    push bx
    push dx
    xor ax,ax
    xor bx,bx
    xor dx,dx
    mov al,Puntaje
    mov bx,AlturaMax 
    mul bx
    xor dx,dx
    mov bl,ThebigNum
    div bx
    mov AlturaAux,ax
    setColor Puntaje
    pop dx
    pop bx
    pop ax
    punteroDSaVideo
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COLOR BARRA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;color de barra
;params valor
setColor macro valor 
    LOCAL ROJO,AZUL,AMARILLO,VERDE,BLANCO,fin
    punteroDSaDatos
    cmp valor,20
    JLE ROJO 
    cmp valor,40
    JLE AZUL
    cmp valor,60
    JLE AMARILLO
    cmp valor,80
    JLE VERDE  
    cmp valor,99
    JLE BLANCO
    jmp fin
    ROJO:
        mov colorBarra,4
        jmp fin
    AZUL:
        mov colorBarra,9
        jmp fin
    AMARILLO:
        mov colorBarra,14
        jmp fin
    VERDE:
        mov colorBarra,2
        jmp fin
    BLANCO:
        mov colorBarra,15
    
    fin:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DIBUJAR BARRA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;params:  largo
dibujarBarra macro largo
    LOCAL cicloAncho,Fin
    LOCAL cicloLargo
    ;push cx
    punteroDSaDatos;cambio puntero a datos para poder obtener datos del datasegment
    push bx
    push si
    push cx
    xor cx,cx;limpio cx
    xor bx,bx;limpio bx

    ;------ESTABLECER ANCHO CORRECTO-------
    mov bx,posInicial
    mov AnchoAux,bx
    xor bx,bx
    mov bx,AnchoBarra
    add AnchoAux,bx; le sumo la posicion inicial de la barra para obtener el tamaño del ancho correcto
    xor bx,bx

    ;------ESTABLECER LARGO CORRECTO------
    mov bx,larg1
    mov larg,bx
    xor bx,bx
    mov bx,AlturaAux
    sub larg,bx; le resto el largo que se mando 
    xor bx,bx

    ;limpio si y lo establezco en la posicion inicial donde se dibujara la barra
    xor si,si
    mov si,posInicial
    
    cicloAncho:
        punteroDSaDatos;cambio puntero a datos para poder obtener datos del datasegment
        xor cx,cx
        ;xor bx,bx
        mov cx,larg1;altura total de la parte superior hacia la inferior
        ;mov bl,colorBarra
        cicloLargo:
            punteroDSaVideo;cambio puntero a video para poder graficar
            pintar_pixel cx, si, colorBarra;
            punteroDSaDatos
            dec cx
        cmp cx,larg
        jnz cicloLargo
    inc si
    cmp si,AnchoAux
    jne cicloAncho
    
    ;pop cx
    Fin:
    mov bx,AnchoAux
    mov posInicial,bx
    inc posInicial
    pop si
    pop cx
    pop bx
    ;pop dx
    ;pop ax
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%% CONVERTIR A ASCII PARA VIDEO %%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

convertAscii macro Numerito
    push ax
    mov ax,Numerito
    ConvertirPrint
    pop ax
endm


ConvertirPrint macro
    LOCAL Bucle2, toNum2,casoMinimo2,FIN2
    push bp                   
    mov  bp,sp                
    sub  sp,2                 
    mov word ptr[bp-2],0      
    pusha
    limpiarResuVec NumPrint, SIZEOF NumPrint, 24h
    xor si,si                        
    cmp ax,0                        
    je casoMinimo2         
    mov  bx,0                       
    push bx                          
            Bucle2:  
                mov dx,0
                cmp ax,0                   
                je toNum2                                
                mov bx,10               
                div bx                    
                add dx,48d                
                push dx                    
                jmp Bucle2
            toNum2:
                pop bx                   
                mov word ptr[bp-2],bx    
                mov al, byte ptr[bp-2]
                cmp al,0                   
                je FIN2                  
                mov NumPrint[si],al          
                inc si                            
                jmp toNum2                 
            casoMinimo2:
                add al,48d                     
                mov NumPrint[si],al                
                jmp FIN2
            FIN2:
                popa
                mov sp,bp           
                pop bp                
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%% Posicion Texto Num %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;modifica la posicion del numero de cada barra
possText macro 
    LOCAL compareto,num10,num10aux,num11,num11aux,num12,num12aux,primeraPasada,cambioBanderaCifras,unacifra,cambiarFila,f_i_n
    punteroDSaDatos

    compareTo:
        cmp posText,34
        jge cambiarFila
        cmp primerPasada,0
        je primeraPasada
        cmp TotalNumeros,10
        je num10
        cmp TotalNumeros,11
        je num11
        cmp TotalNumeros,12
        jge num12
    
    num10:
        cmp numAnt,1
    je num10aux
        inc posText
        inc posText
        inc posText
        inc posText
    jmp cambioBanderaCifras

    num10aux:
        inc posText
        inc posText
        inc posText
        ;inc posText
    jmp cambioBanderaCifras

    num11:
        cmp numAnt,1
    je num11aux
        inc posText
        inc posText
        inc posText
        inc posText

    jmp cambioBanderaCifras
    
    num11aux:
        inc posText
        inc posText

    jmp cambioBanderaCifras

    num12:
        cmp numAnt,1
    je num12aux
        inc posText
        inc posText
        inc posText
    jmp cambioBanderaCifras

    num12aux:
        inc posText
        inc posText
    jmp cambioBanderaCifras



    primeraPasada:
        mov primerPasada,1
        jmp cambioBanderaCifras
    cambiarFila:
       mov PosFilText, 23
       mov posText, 1
    
    cambioBanderaCifras:
        contarCifras
        cmp cifras,1
    je unacifra
        mov numAnt,2
        jmp f_i_n
    
    unacifra:
        mov numAnt,1
    f_i_n:
        mov cifras,0

endm

contarCifras macro 
    LOCAL CICLO,FIIN
    mov cifras,0
    xor si,si
    CICLO:
        cmp NumPrint[si],'$'
        je FIIN
        inc si
        add cifras,1
    jmp ciclo
    FIIN:

endm

prueba macro vector
    punteroDSaDatos
    push cx
    xor cx,cx
    mov cl,vector
    convertAscii cx
    ;imprimir NumPrint
    pop cx
    punteroDSaVideo
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DIBUJAR ARREGLO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%-%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;se encarga de graficar barra con numero correspondiente
dibujarArreglo macro arreglo
    LOCAL CICLOU,fins
    push ax
    push di
    punteroDSaDatos
    xor ax,ax
    mov al,TotalNumeros
    xor di,di
    
    CICLOU:
        punteroDSaDatos

        SetAltura arreglo[di]
        prueba arreglo[di]
        possText
        imprimirEnVideo PosFilText,posText, NumPrint
        dibujarBarra AlturaAux
        inc di
        cmp di,ax
        je fins
        jmp CICLOU
    fins:
        punteroDSaDatos
        reiniciarVariables
        ;punteroDSaVideo
        pop di
        pop ax

endm



;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%% REINICIA VARIABLES VIDEO %%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;REINICIA VARIABLES DE VIDEO
reiniciarVariables macro
  mov posInicial,10
  mov posText,1
  mov posTextAnt,0
  mov cifras,0
  mov PosFilText,22
  mov primerPasada,0
  mov numAnt,0
endm