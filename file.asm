;genera reporte params: ruta, nombrefichero, #bytescontenido, contenido, handler
generarReporte macro ruta, nomarchivo, contenido, handreport
    LOCAL inicio_
    inicio_:
    ;creacion de directorio
        mov ah, 39h
        lea dx, ruta
        int 21h
        ;creacion de archivo en carpeta
        mov ah,3ch
        mov cx,0
        lea dx, nomarchivo
        int 21h
        ;si resulta error en creacion
        jc ERROR7
        mov handreport, ax

        ;*******escribir encabezado******;hasta <ciclo>Primer semestre 2021</ciclo>
        mov ah,40h
        mov bx, handreport
        mov cx,381
        mov dx, offset encabezadoRep
        int 21h

        ;salto de linea
        mov ah,40h
        mov bx, handreport
        mov cx,1
        mov dx, offset nsalto
        int 21h
        ;etiquetaFecha <Fecha>
        mov ah,40h
        mov bx, handreport
        mov cx,15
        mov dx, offset etFecha
        int 21h
        
        ;salto de linea
        mov ah,40h
        mov bx, handreport
        mov cx,1
        mov dx, offset nsalto
        int 21h
        ;etiquetaDia <Dia>
        mov ah,40h
        mov bx, handreport
        mov cx,16
        mov dx, offset etDia
        int 21h
        ;dia actual
        mov ah,40h
        mov bx, handreport
        mov cx,2
        mov dx, offset dia_act
        int 21h
        ;etiqueta cierre </dia>
        mov ah,40h
        mov bx, handreport
        mov cx,6
        mov dx, offset etcDia
        int 21h

        ;salto de linea
        mov ah,40h
        mov bx, handreport
        mov cx,1
        mov dx, offset nsalto
        int 21h
        ;etiquetaDia <Mes>
        mov ah,40h
        mov bx, handreport
        mov cx,16
        mov dx, offset etMes
        int 21h
        ;dia actual
        mov ah,40h
        mov bx, handreport
        mov cx,2
        mov dx, offset mes_act
        int 21h
        ;etiqueta cierre </Mes>
        mov ah,40h
        mov bx, handreport
        mov cx,6
        mov dx, offset etcMes
        int 21h

        ;salto de linea
        mov ah,40h
        mov bx, handreport
        mov cx,1
        mov dx, offset nsalto
        int 21h
        ;etiquetaDia <Año>
        mov ah,40h
        mov bx, handreport
        mov cx,17
        mov dx, offset etAno
        int 21h
        ;dia actual
        mov ah,40h
        mov bx, handreport
        mov cx,2
        mov dx, offset anho_act
        int 21h
        ;etiqueta cierre </Año>
        mov ah,40h
        mov bx, handreport
        mov cx,7
        mov dx, offset etcAno
        int 21h

        ;salto de linea
        mov ah,40h
        mov bx, handreport
        mov cx,1
        mov dx, offset nsalto
        int 21h
        ;etiquetaFecha </Fecha>
        mov ah,40h
        mov bx, handreport
        mov cx,16
        mov dx, offset etcFecha
        int 21h

        ;salto de linea
        mov ah,40h
        mov bx, handreport
        mov cx,1
        mov dx, offset nsalto
        int 21h
        ;etiquetaHoraP <Hora>
        mov ah,40h
        mov bx, handreport
        mov cx,13
        mov dx, offset etHora
        int 21h

        ;salto de linea
        mov ah,40h
        mov bx, handreport
        mov cx,1
        mov dx, offset nsalto
        int 21h
        ;etiquetaHora <Hora>
        mov ah,40h
        mov bx, handreport
        mov cx,17
        mov dx, offset etdHora
        int 21h
        ;horaactual 00
        mov ah,40h
        mov bx, handreport
        mov cx,2
        mov dx, offset hor_act
        int 21h
        ;etiquetaHora </Hora>
        mov ah,40h
        mov bx, handreport
        mov cx,18
        mov dx, offset etdcHora
        int 21h

        ;salto de linea
        mov ah,40h
        mov bx, handreport
        mov cx,1
        mov dx, offset nsalto
        int 21h
        ;etiquetaMinuto <Minuto>
        mov ah,40h
        mov bx, handreport
        mov cx,20
        mov dx, offset etdMinutos
        int 21h
        ;minactual 00
        mov ah,40h
        mov bx, handreport
        mov cx,2
        mov dx, offset min_act
        int 21h
        ;etiquetaHora </Minuto>
        mov ah,40h
        mov bx, handreport
        mov cx,21
        mov dx, offset etdcMinutos
        int 21h

        ;salto de linea
        mov ah,40h
        mov bx, handreport
        mov cx,1
        mov dx, offset nsalto
        int 21h
        ;etiquetaMinuto <Segundo>
        mov ah,40h
        mov bx, handreport
        mov cx,21
        mov dx, offset etdSegundos
        int 21h
        ;seg_actual 00
        mov ah,40h
        mov bx, handreport
        mov cx,2
        mov dx, offset seg_act
        int 21h
        ;etiquetaHora </Segundo>
        mov ah,40h
        mov bx, handreport
        mov cx,11
        mov dx, offset etdcSegundos
        int 21h

        ;salto de linea
        mov ah,40h
        mov bx, handreport
        mov cx,1
        mov dx, offset nsalto
        int 21h
        ;etiquetaHoraP </Hora>
        mov ah,40h
        mov bx, handreport
        mov cx,14
        mov dx, offset etcHora
        int 21h   

        ;datos alumno   
        mov ah,40h
        mov bx, handreport
        mov cx,131
        mov dx, offset datosAlumnos
        int 21h  

        ;etc encabezado </encabezado>
        mov ah,40h
        mov bx, handreport
        mov cx,16
        mov dx, offset etcEncabezado
        int 21h

        ;et Resultados <resultados>
        mov ah,40h
        mov bx, handreport
        mov cx,16
        mov dx, offset etResultados
        int 21h

        ;escribir contenido
        mov ah,40h
        mov bx, handreport
        mov cx,si
        mov dx, offset contenido
        int 21h

        ;et Resultados </resultados>
        mov ah,40h
        mov bx, handreport
        mov cx,15
        mov dx, offset etcResultados
        int 21h

        ;etc Arqui </Arqui>
        mov ah,40h
        mov bx, handreport
        mov cx,9
        mov dx, offset etcArqui
        int 21h

        ;si no se pudo escribir
        jc ERROR8

        ;cerrar archivo
        mov ah, 3eh
        mov bx, handreport
        int 21h
        ;mov numBytes,'0'
endm


;obtencion de caracteres validos para escribir
;params variable, contador
obtenerBytes macro variable
    LOCAL inicio, fin
    xor cx,cx
    xor si,si
    mov cx,30000
    inicio:
        cmp variable[si],'$'
        je fin
        inc si
        loop inicio
    fin:
        ;se sale
endm