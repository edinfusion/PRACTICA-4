include vmacros.asm
include entrada.asm

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
    imprimir encabezado
    imprimir nLinea
;**************************************************************
;-------------------------Menú principal-----------------------
;**************************************************************
    menuP:
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
        

        getCaracter
        
        LimpiarPantalla
        
        ;*****AREA DE ANALISIS DE INFO ALMACENADA
        jmp menuP

;**************************************************************
;----------------------------ORDENES---------------------------
;**************************************************************
    Orders:
        jmp menuP


;**************************************************************
;----------------------------ORDENES---------------------------
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