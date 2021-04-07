convertirHexADec macro vector,vectorORden
    LOCAL WHILLE,CICLOVALS,SALLLIDA
    punteroDSaDatos
    xor di,di
    mov di,0
	limpiarResuVec vectorORden, SIZEOF vectorORden, 24h
    WHILLE:
        xor cx,cx
        mov cx,di
        cmp cl,TotalNumeros;compara si bx ya es igual a el total de numeros, si lo es se sale
    je SALLLIDA
        xor cx,cx
        mov cl,vector[di]
        convertirHexADecReport cx;mando la pos actual a convertir
        agregarNumeroVectorReporte vectorORden,valorDec
        inc di;incremento bx para la siguiente posicion
    jmp WHILLE
    SALLLIDA:
        ;ADIOS
endm

agregarNumeroVectorReporte macro vectorCopia,VectorOriginal
    LOCAL buscar,agregar,prefinalles,finalles
    push ax
    push si
    push di
    xor si,si
    xor di,di
    
    xor ax,ax
    buscar:
        cmp vectorCopia[si],'$'
        je agregar
        inc si
    jmp buscar
    agregar:
        cmp VectorOriginal[di],'$'
    je prefinalles
        mov al,VectorOriginal[di]
        mov vectorCopia[si],al
        inc di
        inc si
    jmp agregar
        
    prefinalles:
        pop di
        xor cx,cx
        mov cx,di
        inc cx
        cmp cl,TotalNumeros;compara si bx ya es igual a el total de numeros, si lo es se sale
    je finalles
        mov vectorCopia[si],','

    finalles:
        pop si
        pop ax

        ;aqui ya se copio
endm

convertirHexADecReport macro Numerito
    push ax
    mov ax,Numerito
    ConvertirPrintReport
    pop ax
endm

ConvertirPrintReport macro
    LOCAL bucle, aNumero,saltar,sFIn
    push bp                   
    mov  bp,sp                
    sub  sp,2                 
    mov word ptr[bp-2],0      
    pusha
    limpiarResuVec valorDec, SIZEOF valorDec, 24h
    xor si,si                        
    cmp ax,0                        
    je saltar         
    mov  bx,0                       
    push bx                          
            bucle:  
                mov dx,0
                cmp ax,0                   
                je aNumero                                
                mov bx,10               
                div bx                    
                add dx,48d                
                push dx                    
                jmp bucle
            aNumero:
                pop bx                   
                mov word ptr[bp-2],bx    
                mov al, byte ptr[bp-2]
                cmp al,0                   
                je sFIn                  
                mov valorDec[si],al          
                inc si                            
                jmp aNumero                 
            saltar:
                add al,48d                     
                mov valorDec[si],al                
                jmp sFIn
            sFIn:
                popa
                mov sp,bp           
                pop bp                
endm   

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUICKSORT  ASCENDENTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ReporteAscendente macro vector
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
;%%%%%%%%%%%%%%%%%%%%%%%%%%% QUICKSORT DESCENDENTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ReporteDescendente macro vector
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

;entrada 45=2d
;guardo en ax = 2d
;div 10
;4.5 = 4 = 

buscarPosicionVacia macro vector
	LOCAL BuscarPos,SeEncontro
	xor si,si
	BuscarPos:
		cmp vector[si],'$'
	je SeEncontro
		inc si
	jmp BuscarPos
	SeEncontro:

endm

agregarTipoAscendente macro 
    ;aqui la bandera debe de estar en 0
    ;y para la de cierre debe de estar en 1
    LOCAL estadoBandera, agregarr,Finalizars
    estadoBandera:
        cmp banderaAscendente,1
    je Finalizars
    agregarr:
        buscarPosicionVacia Historial
		agregarEtiquetaXml sangria
		agregarEtiquetaXml tipo;<tipo>
		agregarEtiquetaXml palabraasc;<ascendete>
		agregarEtiquetaXml ctipo;</tipo>
		agregarEtiquetaXml saltoX
		agregarEtiquetaXml sangria
		agregarEtiquetaXml lEntrada;<lista_entrada>
		convertirHexADec NumerosEntrada,vectorReporteEntrada;revisar si no se afecta el vector original de entrada
		agregarEtiquetaXml vectorReporteEntrada
		;convertirHexADec vecAsc,vectorReporteAsc
		;agregarEtiquetaXml vectorReporteAsc
		agregarEtiquetaXml clEntrada;</lista_entrada>
		agregarEtiquetaXml saltoX
		
		agregarEtiquetaXml sangria
		agregarEtiquetaXml lOrdenanda;<lista_ordenada>
		convertirHexADec vecAsc,vectorReporteAsc
		agregarEtiquetaXml vectorReporteAsc
		agregarEtiquetaXml clOrdenanda;</lista_ordenada>
		agregarEtiquetaXml saltoX
    Finalizars:
endm

agregarTipoDescendente macro 
    ;aqui la bandera debe de estar en 0
    ;y para la de cierre debe de estar en 1
    LOCAL estadoBandera, agregarr,Finalizars
    estadoBandera:
        cmp banderaDescendente,1
    je Finalizars
    agregarr:
        buscarPosicionVacia Historial
		agregarEtiquetaXml sangria
		agregarEtiquetaXml tipo;<tipo>
		agregarEtiquetaXml palabradsc;<descendete>
		agregarEtiquetaXml ctipo;</tipo>
		agregarEtiquetaXml saltoX
		agregarEtiquetaXml sangria
		agregarEtiquetaXml lEntrada;<lista_entrada>
		convertirHexADec NumerosEntrada,vectorReporteEntrada;revisar si no se afecta el vector original de entrada
		agregarEtiquetaXml vectorReporteEntrada
		agregarEtiquetaXml clEntrada;</lista_entrada>
		agregarEtiquetaXml saltoX
		
		agregarEtiquetaXml sangria
		agregarEtiquetaXml lOrdenanda;<lista_ordenada>
		convertirHexADec vecDes,vectorReporteDes
		agregarEtiquetaXml vectorReporteDes
		agregarEtiquetaXml clOrdenanda;</lista_ordenada>
		agregarEtiquetaXml saltoX
    Finalizars:
endm

agregarEtiquetaXml macro etiqueta
	local pushing, popshing
	push ax
	push di
	xor ax,ax
	xor di,di
	pushing:
		cmp etiqueta[di],'$'
	je popshing
		mov al,etiqueta[di]
		mov Historial[si],al
		inc si
		inc di
	jmp pushing
		
	popshing:
		pop di
		pop ax
endm

agregarReporteVelTime macro cadena,fincadena,velor
	punteroDSaDatos
	push cx
	xor cx,cx
	mov cx,MinutosAux
	convertirHexADecReport cx
	pop cx
	buscarPosicionVacia Historial
	agregarEtiquetaXml sangria
	agregarEtiquetaXml cadena;<Ordenamiento_BubbleSort>
	agregarEtiquetaXml saltoX
	agregarEtiquetaXml sangria
	agregarEtiquetaXml sangria
	agregarEtiquetaXml etVelocidad;"<Velocidad>"
	agregarEtiquetaXml velor
	agregarEtiquetaXml etcVelocidad;</Velocidad>
	agregarEtiquetaXml saltoX
	agregarEtiquetaXml sangria
	agregarEtiquetaXml sangria
	agregarEtiquetaXml etTiempo;<Tiempo>
	agregarEtiquetaXml saltoX
	agregarEtiquetaXml sangria
	agregarEtiquetaXml sangria
	agregarEtiquetaXml sangria
	agregarEtiquetaXml etMinutos;<Minutos>
	agregarEtiquetaXml valorDec
	agregarEtiquetaXml etcMinutos;</Minutos>
	push cx
	xor cx,cx
	mov cx,SegundosAux
	convertirHexADecReport cx
	pop cx
	agregarEtiquetaXml saltoX
	agregarEtiquetaXml sangria
	agregarEtiquetaXml sangria
	agregarEtiquetaXml sangria
	agregarEtiquetaXml etSegundos;<Segundos>
	agregarEtiquetaXml valorDec
	agregarEtiquetaXml etcSegundos;</Segundos>
	agregarEtiquetaXml saltoX
	agregarEtiquetaXml sangria
	agregarEtiquetaXml sangria
	agregarEtiquetaXml etcTiempo;</tiempo>
	agregarEtiquetaXml saltoX
	agregarEtiquetaXml sangria
	agregarEtiquetaXml fincadena;</Ordenamiento_BubbleSort>
	agregarEtiquetaXml saltoX
endm







;MinsRep
;SegsRep
;valorDec