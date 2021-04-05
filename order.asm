include vmacros.asm
include entrada.asm
include macsor.asm

.model small
.stack 200h ;segmento de pila
.data ;segmento de datos
    ;**********************PANTALLA PRINCIPAL*****************************
    encabezado db "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA",10,"FACULTAD DE INGENIERIA",10,"ESCUELA DE CIENCIAS Y SISTEMAS",10,"ARQUITECTURA DE COMPUTADORAS Y ENSAMBLADORES 1 A",10,"SECCION A",10,"PRIMER SEMESTRE 2021",10,"EDIN EMANUEL MONTENEGRO VASQUEZ",10,"201709311",10,"PRACTICA 4",10,'$'
    encabezado2 db "%%%%% MENU PRINCIPAL %%%%%%",10,13,'$'
    opciones   db 10,13,"1. Cargar Archivo",10,13,"2. Ordenar",10,13,"3. Generar Reporte",10,13,"4. Salir",10,13,10,13,"Ingrese una opcion: ",'$'

    ;**********************PANTALLA CARGA ARCHIVO**************************
    msgIngreseRuta db 10,  "%%%%%%%%%%%%% INGRESE LA RUTA DEL ARCHIVO: ",10,13,'$'
    msg_C_correcto   db 10,13,"%% INFORMACION CARGADA CORRECTAMENTE %%%%%%%%%",10,13,'$'

    ;************************PANTALLA DE ORDENES***************************
    msgPantallaOrder db  "%%%%%%%%%%%%%% MENU ORDENAR %%%%%%%%%%%%%%",10,13,'$'
    opsOrders        db 10,13,"1. Ordenamiento BubbleSort ",10,13,"2. Ordenamiento QuickSort",10,13,"3. Ordenamiento ShellSort",10,13,"4. Regresar a Menu principal",10,13,10,13,"Ingrese una opcion: ",'$'
    msgVelocidad     db 10,13,  "%%%%%%%%%%%%%% INGRESE UNA VELOCIDAD (0-9): ",'$'
    identacion       db  " %%%%%%%",10,13,'$'
    msgDes           db  "%%%%%%%%%%%%%% COMO DESEA ORDENAR %%%%%%%%",10,13,'$'
    msgBurbuja       db  "%%%%%%%%%%%%%% ORDENAMIENTO BUBBLESORT %%%%%%%%%%%%%%",10,13,'$'
    msgQuick         db  "%%%%%%%%%%%%%%% ORDENAMIENTO QUICKSORT %%%%%%%%%%%%%%",10,13,'$'
    msgShell         db  "%%%%%%%%%%%%%%% ORDENAMIENTO SHELLSORT %%%%%%%%%%%%%%",10,13,'$'
    opsForma         db 10,13,"1. Descendente",10,13,"2. Ascendente",10,13,10,13, "Ingrese una opcion: ",'$'
    ERROR_OR         db 10,13,"**ERROR, No se digito una opcion valida**",10,13,'$'

    ;********************VARIABLES DE ORDENES****************************
    velocidad dw 0,'$'
    burbujas db 0,'$'
    orBubble db "BubbleSort",'$'
    quicks db 0,'$'
    orQuick db "QuickSort",'$'
    shells db 0,'$'
    orShell db "ShellSort",'$'

    ;ordenarcopia
    p_ db 0
    j_ db 0
    aux db 0
    ;numeroMasgrande
    ThebigNum db 0,'$'
    ;mensajes pantalla video
    msg_order db "ORDENAMIENTO: ",'$'
    msg_time db "TIEMPO: ",'$'
    msg_vel db "VELOCIDAD: ",'$'

    ;barras
    AnchoBarra dw 10 ;se almacena el ancho de las barras dependiendo cuantos numeros hallan
    posInicial dw 10
    AnchoAux dw 0
    larg1 dw 174
    larg dw 174
    AlturaAux dw 0,'$'
    colorBarra db 0
    AlturaMax dw 148


    ;posicion texto barras
    PosFilText db 22
    posText db 1,'$'
    posTextAnt db 0,'$'
    primerPasada db 0
    numAnt db 0
    cifras db 0,'$'
    

    ;text barras
    NumPrint db 100 dup('$')

    ;*****************AUXILIAR USO DE PANTALLA GENERAL*********************
    nLinea db 10,'$' ;emula el \n

    ;*****************BUFFER PARA ALMACENAR ENTRADA************************
    ext_correcta db ".xml$"
    entrada db 50 dup('$')
    extension db 10 dup('$')
    saveLectura db 30000 dup('$')
    indice db '0', '$'
    handler_entrada dw ? ; esto es por que asm guarda en hex de tipo word cada archivo(? aun no se sabe que tendra)
    
    NumerosEntradaCopia db 25 dup ('$');copia del vector anterior
    TotalNumeros db 0;lleva el contador de numeros registrados 
    decena db 0ah,'$'
    subscadena db 30 dup('$')

    NumerosEntrada db 25 dup ('$');almacena cada numero de la entrada
    arrayBubble db 25 dup ('$')
    arrayQuick db 25 dup ('$')
    arrayShell db 25 dup ('$')
    
    copiaMayor db 25 dup ('$');aqui se hace copia y se ordenan solo sirve para identificar el mayor de los numeros

    ;*****************************ERRORES**********************************
    ;**lectura
    err_opcion       db 10,13,"**ERROR, No se digito una opcion valida**",10,13,'$'
    err1_fichero     db 10,13, "**ERROR, no se puede abrir el archivo, verifique ruta",10,13,'$'
    err2_fichero     db 10,13, "**ERROR, no se pudo cerrar el archivo",10,13,'$'
    err3_fichero     db 10,13, "**ERROR, extension de fichero invalida, debe de ser .XML",10,13,'$'    
    err4_fichero     db 10,13, "**ERROR, no se puede leer el archivo de entrada",10,13,'$'

.code ;segmento de codigo
main proc
    mov ax, @data
    mov ds, ax
    mov di,0
    LimpiarPantalla
;**************************************************************
;-------------------------Menú principal-----------------------
;**************************************************************
    menuP:
        imprimir encabezado
        imprimir nLinea
        imprimir encabezado2
        imprimir opciones
        getCaracter ;activa la interrupcion y espera un caracter
        cmp al, '1'
        je abrirArchivo
        cmp al, '2'
        je Orders
        cmp al, '3'
        je Report
        cmp al, '4'
        je salir
        jmp default

;**************************************************************
;----------------------------ARCHIVO---------------------------
;**************************************************************

    ;---ABRIR FICHERO
    abrirArchivo:
        limpiarResuVec saveLectura, SIZEOF savelectura, 24h
        limpiarResuVec subscadena, SIZEOF subscadena,24h

        LimpiarPantalla;limpio pantalla y cursos se va hasta 0,0
        imprimir nLinea;salto en pantalla
        imprimir msgIngreseRuta ;imprimir mensaje para ingresar ruta
        imprimir nLinea ; nuevo salto
        limpiarResuVec entrada, SIZEOF entrada, 24h ; limpio vectores de basura
        limpiarResuVec extension, SIZEOF extension, 24h
        getRuta entrada, extension ; se obtiene la ruta del fichero
        compararExtension  ext_correcta, extension ;valido la extension .xml
        abrirFichero entrada, handler_entrada ;abrir path
        leerFichero SIZEOF saveLectura, saveLectura, handler_entrada;se lee el fichero

        aMinuscula saveLectura,SIZEOF saveLectura
        imprimir saveLectura
        getCaracter
        reconocerArchivo saveLectura
        cerrarFichero handler_entrada
        mov handler_entrada, 00h

        imprimir NumerosEntrada
        imprimir nLinea
        
        OrdenarCopia NumerosEntradaCopia,TotalNumeros
        getCaracter
        
        LimpiarPantalla
        
        ;*****AREA DE ANALISIS DE INFO ALMACENADA
        jmp menuP

;**************************************************************
;----------------------------ORDENES---------------------------
;**************************************************************
    Orders:
        LimpiarPantalla
        imprimir msgPantallaOrder
        imprimir opsOrders 
        getCaracter ;activa la interrupcion y espera un caracter
        cmp al, '1'
        je burbuja
        cmp al, '2'
        je quick
        cmp al, '3'
        je shell
        cmp al, '4'
        je returns
        jmp dft
            burbuja:
                mov burbujas,1
                LimpiarPantalla
                imprimir msgBurbuja
                imprimir msgVelocidad
                setvelocidad
                imprimir identacion
                imprimir opsForma
                setOrden
                mov burbujas,0
                jmp Orders
            

            quick:
                mov quicks,1
                LimpiarPantalla
                imprimir msgQuick
                imprimir msgVelocidad
                setvelocidad
                imprimir identacion
                imprimir opsForma
                mov quicks,0
                jmp Orders
                
            shell:
                mov shells,1
                LimpiarPantalla
                imprimir msgShell
                imprimir msgVelocidad
                setvelocidad
                imprimir identacion
                imprimir opsForma
                mov shells,0
                jmp Orders
            
            returns:
                LimpiarPantalla;limpio pantalla y cursos se va hasta 0,0
            jmp menuP
                
            dft:
                imprimir ERROR_OR
                getCaracter
            jmp Orders
            


;**************************************************************
;----------------------------REPORTE---------------------------
;**************************************************************
    Report:
        jmp menuP


;**************************************************************
;-----------------------------SALIDA---------------------------
;**************************************************************
    salir:
        mov ah, 4ch ;Terminación de Programa con Código de Retorno
        int 21h



;**************************************************************
;-----------------------------DEFAULT--------------------------
;**************************************************************
    default:
        jmp ERROR1

;**************************************************************
;-----------------------------ERRORES----------------------------
;**************************************************************

    ;ERROR EN ESCOGER OPCION
    ERROR1:
        imprimir err_opcion 
        imprimir nLinea
        getCaracter
        LimpiarPantalla;limpio pantalla y cursos se va hasta 0,0
        jmp menuP
    
    ;ERROR AL ABRIR FICHERO
    ERROR2:
        imprimir err1_fichero
        imprimir nLinea
        getCaracter
        LimpiarPantalla;limpio pantalla y cursos se va hasta 0,0
        jmp menuP
    
    ;ERROR AL CERRAR FICHERO
    ERROR3:
        imprimir err2_fichero
        imprimir nLinea
        getCaracter
        LimpiarPantalla;limpio pantalla y cursos se va hasta 0,0
        jmp menuP
    
    ;ERROR DE EXTENSION FICHERO
    ERROR4:
        imprimir err3_fichero
        imprimir nLinea
        getCaracter
        LimpiarPantalla;limpio pantalla y cursos se va hasta 0,0
        jmp menuP
    
    ;ERROR AL LEER ARCHIVO
    ERROR5:
        imprimir err4_fichero
        imprimir nLinea
        getCaracter
        LimpiarPantalla;limpio pantalla y cursos se va hasta 0,0
        jmp menuP

.exit
main endp

end main