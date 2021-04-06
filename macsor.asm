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
        mov msgVelocidadRelativa,30h
    jmp Fiiiin
    vel1:
        mov velocidad,1500
        mov msgVelocidadRelativa,31h
    jmp Fiiiin
    vel2:
        mov velocidad,1400
        mov msgVelocidadRelativa,32h
    jmp Fiiiin
    vel3:
        mov velocidad,1300
        mov msgVelocidadRelativa,33h
    jmp Fiiiin
    vel4:
        mov velocidad,1000
        mov msgVelocidadRelativa,34h
    jmp Fiiiin
    vel5:
        mov velocidad,800
        mov msgVelocidadRelativa,35h
    jmp Fiiiin
    vel6:
        mov velocidad,600
        mov msgVelocidadRelativa,36h
    jmp Fiiiin
    vel7:
        mov velocidad,400
        mov msgVelocidadRelativa,37h
    jmp Fiiiin
    vel8:
        mov velocidad,200
        mov msgVelocidadRelativa,38h
    jmp Fiiiin
    vel9:
        mov velocidad,100
        mov msgVelocidadRelativa,39h
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



esperarBarra macro
    LOCAL ciclo,fiins
    punteroDSaDatos
    ciclo:
        getCaracterSinMostrar
        cmp ah,57;se debe de presionar tecla space de lo contrario sigue en ciclo
        je fiins
    jmp ciclo

    fiins:
endm

esperarEsc macro
    LOCAL ciclouuu,finsn
    ciclouuu:
        getCaracterSinMostrar
        cmp ah,01;se debe de presionar tecla Esc de lo contrario sigue en ciclo
        je finsn
    jmp ciclouuu
    finsn:
endm

InstruccionesRepetidas macro arrayorder,mensaje
    CopiarArreglo NumerosEntrada,arrayorder,0,TotalNumeros
    getNumeroMasGrande NumerosEntradaCopia
    modoVideo;DE AQUI YA SE TIENE QUE EMPEZAR A MOVER PUNTEROS !!!!!
    imprimirEnVideo 0d,1d,msg_order;imprime orden:
    imprimirEnVideo 0d,14,mensaje;imprime bubblesort
    imprimirEnVideo 0d,25d,msg_time;imprime tiempo:
    imprimirEnVideo 0d,32d, tiempoCeros
    imprimirEnVideo 2d,1d,msg_vel;imprime velocidad:
    imprimirEnVideo 2d,11d,msgVelocidadRelativa;imprime 0-9
    dibujarMargen 6d,310d,26d,199d,15d;aqui de una hay que definir el margen en la macro
    SetAnchoBarra
    dibujarArreglo arrayorder
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
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Modo Texto %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

modoTexto macro
    mov ax,0003h
    int 10h
    mov ax, @data
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

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%% REINICIA VARIABLES VIDEO %%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;REINICIA VARIABLES DE TIEMPO
reiniciarContadorTiempo macro
    mov ValorSegundos,0
    mov SegundosAux,0
    mov MinutosAux,0   
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%% ANIMACION ISNTRUCCIONES %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;conjunto de instrucciones para animar posicion de barras
;params: velocidad_delay
animarMacro macro vec,vel,ords
    ;limpiarPantalla

    modoVideo
    dibujarMargen 6d,310d,26d,199d,15d;aqui de una hay que definir el margen en la macro
    imprimirEnVideo 0d,1d,msg_order;imprime orden:
    imprimirEnVideo 0d,14,ords;imprime bubblesort
    imprimirEnVideo 0d,25d,msg_time
    imprimirEnVideo 2d,1d,msg_vel
    imprimirEnVideo 2d,11d,msgVelocidadRelativa;imprime 0-9
    ordenarImpresionTiempo
    dibujarArreglo vec
    delay vel
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DELAY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delay macro param
    LOCAL ret2,ret1,finRet
    push ax
    push bx
    xor ax,ax
    xor bx,bx
    mov ax,param
    ret2:
        dec ax;200
        jz finRet;==0
        mov bx, param;bx=199
        ret1:
            dec bx;bx=198,197,196
        jnz ret1;!=0
    jmp ret2
    finRet:
        pop bx
        pop ax
endm
prueba2 macro vec
    punteroDSaDatos
    push cx
    xor cx,cx
    mov cx,vec
    convertAsciiSeg cx
    pop cx
    punteroDSaVideo
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%% CONVERTIR A ASCII PARA VIDEO SEGUNDOS %%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

convertAsciiSeg macro Segundos
    push ax
    mov ax,Segundos
    ConvertirPrintSeg
    pop ax
endm
ConvertirPrintSeg macro
    LOCAL Bucle2, toNum2,casoMinimo2,FIN2
    push bp                   
    mov  bp,sp                
    sub  sp,2                 
    mov word ptr[bp-2],0      
    pusha
    limpiarResuVec Secsprint, SIZEOF Secsprint, 24h
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
                mov Secsprint[si],al          
                inc si                            
                jmp toNum2                 
            casoMinimo2:
                add al,48d                     
                mov Secsprint[si],al                
                jmp FIN2
            FIN2:
                popa
                mov sp,bp           
                pop bp                
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%% ImpresionTiempo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;imprime tiempo en video
ordenarImpresionTiempo macro
    LOCAL ImprimirMinsCeros,ImprimirSecs,ImprimirSecsCero,finss
    punteroDSaDatos
    ValidarSegundo
    push cx
    mov cx, MinutosAux
    cmp cx,9
    jle ImprimirMinsCeros
    pop cx
    prueba2 MinutosAux
    imprimirEnVideo 0d,33d,Secsprint
    jmp ImprimirSecs
    ImprimirMinsCeros:
        pop cx
        punteroDSaVideo
        imprimirEnVideo 0d,33d, Cero
        punteroDSaDatos
	    prueba2 MinutosAux
        punteroDSaVideo
	    imprimirEnVideo 0d,34d,Secsprint	
    ImprimirSecs:
        imprimirEnVideo 0d,35d,DosPun
        punteroDSaDatos
        push cx
        mov cx,SegundosAux
	    cmp cx,9
	    jle ImprimirSecsCero
        pop cx
        prueba2 SegundosAux
        punteroDSaVideo
        imprimirEnVideo 0d,36d,Secsprint
        jmp finss
    ImprimirSecsCero:
        pop cx
        imprimirEnVideo 0d,36d,Cero
	    prueba2 SegundosAux
        punteroDSaVideo
        imprimirEnVideo 0d,37d,Secsprint
    finss:
    
        
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%% VALIDAR SEGUNDO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ValidarSegundo macro
    LOCAL SalirVS
    push ax
    push dx
    mov  ah, 2ch
    int  21h
    cmp dh,ValorSegundos
    je SalirVS
    mov ValorSegundos,dh
    AumentarSegundos
    SalirVS:
    pop dx
    pop ax
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%% AUMENTAR UN SEGUNDO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AumentarSegundos macro
    LOCAL IncrementarMinutos, SalirAS
    push cx
    inc SegundosAux
    mov cx,SegundosAux
    cmp cx,60
    je IncrementarMinutos
    jmp SalirAS
    IncrementarMinutos:
	    inc MinutosAux
	    mov SegundosAux,0
    SalirAS:
        pop cx
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ALGORITMOS DE ORDENAMIENTO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%% BUBBLE SORT DESCENDENTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;orden burbuja ascendente
;params: vector, tamaño
bubbleSortDes macro vec, tam
    LOCAL whilee, salida_whilee,forsito,salida_forsito,entrar_if
    punteroDSaDatos
    mov iteracion,0;int iteración = 0;
    mov permutacion,1;1=true bool permutation = true;
    xor dx,dx
    xor bx,bx
    xor ax,ax
    mov bh,0000h
    mov ah,0000h

    whilee:
        punteroDSaDatos
        cmp permutacion,0; while ( permutation) {
        je salida_whilee; while ( permutation)
        mov permutacion,0;permutation = false;
        inc iteracion; iteración ++;

        ;estos pertenecen al for()
        mov actual,0;actual=0;
        forsito:
            punteroDSaDatos
            mov al, tam
            sub al,iteracion
            cmp actual,al;actual<20-iteración;
            je salida_forsito

            xor bx,bx
            mov bl, actual
            mov al,vec[bx];vector[actual]
            inc bx
            mov dl,vec[bx];vector[actual+1]
            cmp al,dl;if (vector[actual]<vector[actual+1]){
            jl entrar_if
            inc actual;actual++
            jmp forsito 
                entrar_if:
                    mov permutacion,1; permutation = true;
                    xor bx,bx
                    mov bl,actual
                    mov al,vec[bx];vector[actual];
                    mov tempp,al;int temp = vector[actual];

                    xor bx,bx
                    mov bl,actual
                    inc bx
                    mov al,vec[bx];vector[actual+1];

                    xor bx,bx
                    mov bl,actual
                    mov vec[bx],al;vector[actual] = vector[actual+1];
                   
                    xor bx,bx
                    mov bl,actual
                    inc bx
                    mov al,tempp
                    mov vec[bx],al; vector[actual+1] = temp;

                    animarMacro vec,velocidad,orBubble2

                    inc actual;actual++
                    jmp forsito
        salida_forsito:

            jmp whilee
    salida_whilee:
endm
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%% BUBBLE SORT ASCENDENTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;orden burbuja ascendente
;params: vector, tamaño
bubbleSortAsc macro vec, tam
    LOCAL whilee, salida_whilee,forsito,salida_forsito,entrar_if
    punteroDSaDatos
    mov iteracion,0;int iteración = 0;
    mov permutacion,1;1=true bool permutation = true;
    xor dx,dx
    xor bx,bx
    xor ax,ax
    mov bh,0000h
    mov ah,0000h

    whilee:
        punteroDSaDatos
        cmp permutacion,0; while ( permutation) {
        je salida_whilee; while ( permutation)
        mov permutacion,0;permutation = false;
        inc iteracion; iteración ++;

        ;estos pertenecen al for()
        mov actual,0;actual=0;
        forsito:
            punteroDSaDatos
            mov al, tam
            sub al,iteracion
            cmp actual,al;actual<20-iteración;
            je salida_forsito

            xor bx,bx
            mov bl, actual
            mov al,vec[bx];vector[actual]
            inc bx
            mov dl,vec[bx];vector[actual+1]
            cmp al,dl;if (vector[actual]>vector[actual+1]){
            jg entrar_if
            inc actual;actual++
            jmp forsito 
                entrar_if:
                    mov permutacion,1; permutation = true;
                    xor bx,bx
                    mov bl,actual
                    mov al,vec[bx];vector[actual];
                    mov tempp,al;int temp = vector[actual];

                    xor bx,bx
                    mov bl,actual
                    inc bx
                    mov al,vec[bx];vector[actual+1];

                    xor bx,bx
                    mov bl,actual
                    mov vec[bx],al;vector[actual] = vector[actual+1];
                   
                    xor bx,bx
                    mov bl,actual
                    inc bx
                    mov al,tempp
                    mov vec[bx],al; vector[actual+1] = temp;

                    animarMacro vec,velocidad,orBubble

                    inc actual;actual++
                    jmp forsito
        salida_forsito:

            jmp whilee
    salida_whilee:
endm

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%% QUICKSORT DESCENDENTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
QuickSortDes macro vector
    LOCAL Do_Ini, Do_Sec, Do_Ter, Verificar1, Verificar2, Incrementar, Decrementar, IF_q, FinSegundoIF, VDo2, VDo3, Pushear, Igualar, Cambio
    punteroDSaDatos
    mov subVector,0
    mov dx,0
    mov cl,TotalNumeros;esto obtiene el total de posiciones utilizadas en array
    dec cx;como empieza en cero el indice se decrementa
    push dx ;izquierda
    push cx ;derecha
    Do_Ini:
	    pop cx
	    pop dx
	    mov der,cx
	    mov izq,dx
	    dec subVector
	Do_Sec:
		mov dx,izq
		mov i_zq,dx
		mov dx,der
		mov d_er,dx
		mov ax,izq
		mov cx,der
		add ax,cx
		mov bx,2
		xor dx,dx
		div bx
		mov si,ax
		mov al,vector[si]
		mov pivote,al
		Do_Ter:
			jmp Verificar1
			Decrementar:
				dec d_er
			Verificar1:
				mov al,pivote
				mov si,d_er
				mov dl,vector[si]
				cmp al,dl
				jg Decrementar
				jmp Verificar2
			Incrementar:
				inc i_zq
			Verificar2:
				mov al,pivote
				mov si,i_zq
				mov dl,vector[si]
				cmp al,dl
				jl Incrementar

				mov ax,i_zq
				mov dx,d_er
				cmp ax,dx
				jle IF_q
				jmp VDo3
			IF_q:
				cmp ax,dx
				jne Cambio
				jmp FinSegundoIF
				Cambio:
				mov si,i_zq
				mov di,d_er
				mov al,vector[si]
				mov dl,vector[di]
				mov vector[si],dl
				mov vector[di],al
                
                animarMacro vector,velocidad,orQuick2
                punteroDSaDatos
				FinSegundoIF:
				dec d_er
				inc i_zq
			VDo3:
				mov ax,d_er
				mov dx,i_zq
				cmp ax,dx
				jge Do_Ter
	
	;TercerIF:
	mov ax,i_zq
	mov dx,der
	cmp ax,dx
	jl Pushear
	jmp Igualar
	Pushear:
	    inc subVector
	    mov dx,	i_zq
	    mov cx, der
	    push dx
	    push cx
	Igualar:
	    mov ax,d_er
	    mov der,ax
	VDo2:
		mov ax,izq
		mov dx,der
		cmp ax,dx
		jl Do_Sec

    mov ax,subVector
    mov dx,1111111111111111b
    cmp ax,dx
    jg Do_Ini
endm
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUICKSORT  ASCENDENTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

QuickSortAsc macro vector
    LOCAL Do_Ini, Do_Sec, Do_Ter, Verificar1, Verificar2, Incrementar, Decrementar, IF_q, FinSegundoIF, VDo2, VDo3, Pushear, Igualar, Cambio
    punteroDSaDatos
    mov subVector,0
    mov dx,0
    mov cl,TotalNumeros;esto obtiene el total de posiciones utilizadas en array
    dec cx;como empieza en cero el indice se decrementa
    push dx ;izquierda
    push cx ;derecha
    Do_Ini:
	    pop cx
	    pop dx
	    mov der,cx
	    mov izq,dx
	    dec subVector
	Do_Sec:
		mov dx,izq
		mov i_zq,dx
		mov dx,der
		mov d_er,dx
		mov ax,izq
		mov cx,der
		add ax,cx
		mov bx,2
		xor dx,dx
		div bx
		mov si,ax
		mov al,vector[si]
		mov pivote,al
		Do_Ter:
			jmp Verificar1
			Decrementar:
				dec d_er
			Verificar1:
				mov al,pivote
				mov si,d_er
				mov dl,vector[si]
				cmp al,dl
				jl Decrementar
				jmp Verificar2
			Incrementar:
				inc i_zq
			Verificar2:
				mov al,pivote
				mov si,i_zq
				mov dl,vector[si]
				cmp al,dl
				jg Incrementar

				mov ax,i_zq
				mov dx,d_er
				cmp ax,dx
				jle IF_q
				jmp VDo3
			IF_q:
				cmp ax,dx
				jne Cambio
				jmp FinSegundoIF
				Cambio:
				mov si,i_zq
				mov di,d_er
				mov al,vector[si]
				mov dl,vector[di]
				mov vector[si],dl
				mov vector[di],al
                animarMacro vector,velocidad,orQuick
                punteroDSaDatos
				FinSegundoIF:
				dec d_er
				inc i_zq
			VDo3:
				mov ax,d_er
				mov dx,i_zq
				cmp ax,dx
				jge Do_Ter
	
	;TercerIF:
	mov ax,i_zq
	mov dx,der
	cmp ax,dx
	jl Pushear
	jmp Igualar
	Pushear:
	    inc subVector
	    mov dx,	i_zq
	    mov cx, der
	    push dx
	    push cx
	Igualar:
	    mov ax,d_er
	    mov der,ax
	VDo2:
		mov ax,izq
		mov dx,der
		cmp ax,dx
		jl Do_Sec

    mov ax,subVector
    mov dx,1111111111111111b
    cmp ax,dx
    jg Do_Ini
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%% SHELL SORT ASCENDENTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;orden Shell ascendente
;params: vector, tamaño
ShellSortAsc macro vector, tamanio
    LOCAL wwhile1,salida_wwhile1,ffor1,salida_ffor1,wwhile2,salida_wwhile2,ifff_entraaa
    punteroDSaDatos
    xor dx,dx
    xor bx,bx
    xor ax,ax
    mov bh,0000h
    mov ah,0000h

    mov bx,2 ;/ 2;
    mov al,tamanio;array.length
    mov dx,0
    div bx
    mov gap,al;int gap = array.length / 2;
    wwhile1:; while 
        punteroDSaDatos
        cmp gap,0
        je salida_wwhile1; while (gap > 0) {

        mov i__,0;int i = 0
        ffor1:
            punteroDSaDatos
            ;condicion for
            mov al,tamanio;array.length
            sub al,gap;array.length - gap
            cmp i__,al; i < array.length - gap;
            je salida_ffor1

            ;cuerpo for
            mov al,i__;i
            add al,gap;i + gap;
            mov j__,al;int j = i + gap;

            xor bx,bx
            mov bl,j__;[j];
            mov al,vector[bx];array[j];
            mov tmp,al; int tmp = array[j];

            wwhile2:
                punteroDSaDatos
                ;condicion1 while
                mov al,gap;gap 
                cmp j__,al;j >= gap
                jl salida_wwhile2
                ;&&
                ;condicion2 while
                xor bx,bx
                mov al,gap
                mov bl,j__
                sub bl,al;j - gap
                mov al,vector[bx];array[j - gap]
                cmp tmp,al
                jge salida_wwhile2;tmp > array[j - gap]
                ;cuerpo while
                xor bx,bx
                mov al,gap
                mov bl,j__
                sub bl,al;j - gap
                mov al,vector[bx];array[j - gap]
                xor bx,bx
                mov bl,j__
                mov vector[bx],al;array[j] = array[j - gap];
                mov al,gap
                sub j__,al;j -= gap;
                animarMacro vector,velocidad,orShell
            jmp wwhile2
            salida_wwhile2:
                xor bx,bx
                mov bl,j__
                mov al,tmp
                mov vector[bx],al;array[j] = tmp;
        inc i__; i++
        jmp ffor1
        salida_ffor1:
            cmp gap,2; if (gap == 2) { //change the gap size
            je ifff_entraaa
            xor bx,bx;else
            mov bx,2
            mov al,gap
            mov dx,0
            div bx
            mov gap,al;gap /= 2.2;
            jmp wwhile1
            ifff_entraaa:
                mov gap,1;gap = 1;
                jmp wwhile1
    salida_wwhile1:
        animarMacro vector,velocidad,orShell
        ;se acabo
endm


;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%% SHELL SORT DESCENDENTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;orden Shell ascendente
;params: vector, tamaño
ShellSortDes macro vector, tamanio
    LOCAL while1,salida_while1,for1,salida_for1,while2,salida_while2,if_entra
    punteroDSaDatos
    xor dx,dx
    xor bx,bx
    xor ax,ax
    mov bh,0000h
    mov ah,0000h

    mov bx,2 ;/ 2;
    mov al,tamanio;array.length
    mov dx,0
    div bx
    mov gap,al;int gap = array.length / 2;
    while1:; while 
        punteroDSaDatos
        cmp gap,0
        je salida_while1; while (gap > 0) {

        mov i__,0;int i = 0
        for1:
            punteroDSaDatos
            ;condicion for
            mov al,tamanio;array.length
            sub al,gap;array.length - gap
            cmp i__,al; i < array.length - gap;
            je salida_for1

            ;cuerpo for
            mov al,i__;i
            add al,gap;i + gap;
            mov j__,al;int j = i + gap;

            xor bx,bx
            mov bl,j__;[j];
            mov al,vector[bx];array[j];
            mov tmp,al; int tmp = array[j];

            while2:
                punteroDSaDatos
                ;condicion1 while
                mov al,gap;gap 
                cmp j__,al;j >= gap
                jl salida_while2
                ;&&
                ;condicion2 while
                xor bx,bx
                mov bl,j__
                sub bl,al;j - gap
                mov al,vector[bx];array[j - gap]
                cmp tmp,al
                jle salida_while2;tmp > array[j - gap]
                ;cuerpo while
                xor bx,bx
                mov bl,j__
                mov vector[bx],al;array[j] = array[j - gap];
                mov al,gap
                sub j__,al;j -= gap;
                animarMacro vector,velocidad,orShell2
            jmp while2
            salida_while2:
                xor bx,bx
                mov bl,j__
                mov al,tmp
                mov vector[bx],al;array[j] = tmp;
        inc i__; i++
        jmp for1
        salida_for1:
            cmp gap,2; if (gap == 2) { //change the gap size
            je if_entra
            xor bx,bx;else
            mov bx,2
            mov al,gap
            mov dx,0
            div bx
            mov gap,al;gap /= 2.2;
            jmp while1
            if_entra:
                mov gap,1;gap = 1;
                jmp while1
    salida_while1:
        animarMacro vector,velocidad,orShell2
        ;se acabo
endm