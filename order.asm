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



.exit
main endp

end main