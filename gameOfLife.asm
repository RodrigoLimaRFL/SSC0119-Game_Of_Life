;
; Karl Cruz Altenhofen - 14585976
; Maicon Chaves Marques - 14593530
; Rodrigo de Freitas Lima - 12547510
;

jmp main

; matriz com 1200 posicoes (40x30)
matrix: var #1200 ; matriz 30 x 40
matrix_ao_redor: var #1200 ; salva o num de celulas ao redor

matrix_pos_inicial: var #4 ; salva a primeira posicao
matrix_ao_redor_pos_inicial: var #4

celula_viva: var #1 ; char da celula viva (O)
celula_morta: var #1 ; char da celula morta (*)

celula_anterior: var #1 ; a celula selecionada no pause
posicao: var #4

max_tamanho: var #1 ; tamanho maximo da matriz

celula_atual: var #1 ; posicao da celula sendo verificada
contador_ao_redor: var #1 

main:

    loadn r0, #matrix ; r0 <- matriz [30][40]
    store matrix_pos_inicial, r0
    loadn r1, #'*' ; char vazio a ser printado
    loadn r2, #2048 ; cor cinza
    add r1, r1, r2
    store celula_morta, r1
    loadn r2, #1200 ; tamanho da matriz
    store max_tamanho, r2
    loadn r5, #'O' ; celula viva
    loadn r2, #2816 ; cor amarela
    add r5, r5, r2
    store celula_viva, r5
    loadn r7, #matrix_ao_redor
    store matrix_ao_redor_pos_inicial, r7
    call fillMem
    call printMat
    main_pauseAndPlay:
    call gridInitPosition
    main_loop:
        call gameCycle
        call printMat
        
        inchar r0
        loadn r1, #2
        hold r1
        
        loadn r1, #'p'
        cmp r0, r1
        jeq main_pauseAndPlay
        
        loadn r1, #'r'
        cmp r0, r1
        jeq main
        
        jmp main_loop
    jmp fim
    
countCellsInc:
    load r1, contador_ao_redor
    inc r1; contador++
    store contador_ao_redor, r1
    rts
    
countCells:
    loadn r1, #0
    store contador_ao_redor, r1
    load r2, max_tamanho
    load r5, celula_viva
    load r3, matrix_pos_inicial
    
    load r0, celula_atual
    loadn r6, #36
    cmp r0, r6
    jne pular_bpt
    
    pular_bpt:
    
    ; para acessar as celulas ao redor => ((posicao atual + offset) + 1200 ) % 1200
    ; celula topo esq
    load r0, celula_atual ; carrega a celula atual
    loadn r6, #1159
    add r0, r0, r6 ; r0 = posicao atual + offset + 1200
    mod r0, r0, r2 ; r0 = r0 % 1200
    add r0, r3, r0 ; pega a posicao desejada da matriz
    loadi r0, r0 ; carrega o caractere da matriz
    cmp r0, r5 ; se a celula esta viva, entra na funcao
    ceq countCellsInc
    
    ; celula topo meio
    load r0, celula_atual
    loadn r6, #1160
    add r0, r0, r6
    mod r0, r0, r2
    add r0, r3, r0
    loadi r0, r0
    cmp r0, r5
    ceq countCellsInc
    
    ; celula topo dir
    load r0, celula_atual
    loadn r6, #1161
    add r0, r0, r6
    mod r0, r0, r2
    add r0, r3, r0
    loadi r0, r0
    cmp r0, r5
    ceq countCellsInc
    
    ; celula esq
    load r0, celula_atual
    loadn r6, #1199
    add r0, r0, r6
    mod r0, r0, r2
    add r0, r3, r0
    loadi r0, r0
    cmp r0, r5
    ceq countCellsInc
    
    ; celula dir
    load r0, celula_atual
    loadn r6, #1201
    add r0, r0, r6
    mod r0, r0, r2
    add r0, r3, r0
    loadi r0, r0
    cmp r0, r5
    ceq countCellsInc
    
    ; celula baixo esq
    load r0, celula_atual
    loadn r6, #1239
    add r0, r0, r6
    mod r0, r0, r2
    add r0, r3, r0
    loadi r0, r0
    cmp r0, r5
    ceq countCellsInc
    
    ; celula baixo meio
    load r0, celula_atual
    loadn r6, #1240
    add r0, r0, r6
    mod r0, r0, r2
    add r0, r3, r0
    loadi r0, r0
    cmp r0, r5
    ceq countCellsInc
    
    ; celula baixo dir
    load r0, celula_atual
    loadn r6, #1241
    add r0, r0, r6
    mod r0, r0, r2
    add r0, r3, r0
    loadi r0, r0
    cmp r0, r5
    ceq countCellsInc
    
    load r0, celula_atual
    load r3, matrix_ao_redor_pos_inicial
    add r3, r3, r0 ; r0 = *matrix_ao_redor + posAtual
    storei r3, r1 ; salva a qntd de celulas na matriz
    rts
    

;;;;;;;;;;; n ta matando e reproduzindo
killCell: ; salva o valor morto na matriz
    load r5, matrix_pos_inicial
    load r4, celula_atual
    add r5, r5, r4
    load r6, celula_morta
    ;loadi r6, r6
    storei r5, r6
    rts
    
    
reproduceCell: ; salva o valor vivo na matriz
    load r5, matrix_pos_inicial
    load r4, celula_atual
    add r5, r5, r4
    load r6, celula_viva
    ;loadi r6, r6
    storei r5, r6
    rts
    
    
liveCell:
    call underPop
    call overPop
    rts
    
    
underPop:
    loadn r6, #2 ; se a celula tem menos que 2 vizinhos morre
    load r3, matrix_ao_redor_pos_inicial
    load r4, celula_atual
    add r3, r3, r4
    loadi r3, r3
    cmp r3, r6
    cle killCell
    rts
    
    
overPop:
    loadn r6, #3 ; se a celula tem mais que 3 vizinhos morre
    load r3, matrix_ao_redor_pos_inicial
    load r4, celula_atual
    add r3, r3, r4
    loadi r3, r3
    cmp r3, r6
    cgr killCell
    rts
    
    
deadCell:
    loadn r6, #3 ; se a celula tem exatamente 3 vizinho ela nasce
    load r3, matrix_ao_redor_pos_inicial
    load r4, celula_atual
    add r3, r3, r4
    loadi r3, r3
    cmp r3, r6
    ceq reproduceCell
    rts
    

; simulates one tick of the game
gameCycle:
    loadn r7, #0
    gameCycleLoop:
        store celula_atual, r7
        call countCells
        inc r7
        load r2, max_tamanho
        cmp r7, r2
        jle gameCycleLoop
        
    loadn r7, #0
    
    ; for i = 0 to max_tamanho ( verifica se deve matar ou reviver )
    gameCycleTransformCells:
        store celula_atual, r7
        load r0, matrix_pos_inicial
        add r0, r0, r7
        loadi r0, r0
        load r2, celula_morta
        cmp r0, r2 ; se a celula esta morta
        ceq deadCell
        load r2, celula_viva
        cmp r0, r2 ; se a celula esta viva
        ceq liveCell
        inc r7
        load r2, max_tamanho
        cmp r7, r2
        jle gameCycleTransformCells

    rts

fillMem:
    load r0, matrix_pos_inicial
    load r2, max_tamanho
    load r1, celula_morta ; char vazio a ser printado
    load r5, celula_viva ; celula viva
    loadn r4, #5
    loadn r6, #0
    sub r2, r2, r4
        
    fillMemLoop:
        ;guarda o char r1 em r0
        storei r0, r1
        ;aumenta a posicao na mem
        inc r0
        inc r6
        cmp r6, r2
        ;if (r6 < r2) continue
        jle fillMemLoop
        
    add r2, r2, r4
        
    fillMemLoopDois:
        ;guarda o char r1 em r0
        storei r0, r5
        ;aumenta a posicao na mem
        inc r0
        inc r6
        cmp r6, r2
        ;if (r0 < r2) continue
        jle fillMemLoopDois
        
    jmp printMat
    rts

printMat: 
    load r0, matrix_pos_inicial
    load r2, max_tamanho
    loadn r4, #0
    printMatLoop:
        loadi r3, r0 ; carrega a mem no r3
        outchar r3, r4
        inc r0
        inc r4
        cmp r4, r2
        jle printMatLoop

    rts
    
printMatQntd:
    load r7, matrix_ao_redor_pos_inicial
    loadn r4, #0
    printMatLoopQntd:
        loadi r3, r7 ; carrega a mem no r3
        loadn r5, #48
        add r3, r3, r5
        outchar r3, r4
        inc r4
        inc r7
        cmp r4, r2
        jle printMatLoopQntd

    rts

fim:
    halt




gridInitPosition:
    load r0, posicao

    gridInitPosition_loop:
        
        load r4, matrix_pos_inicial ;primeira posicao
        add r4, r4, r0              ;r4 = posicao real
        loadi r1, r4                ;r1 = char
        store celula_anterior, r1   ;char e guardado na memoria
        
        load r2, celula_viva        ;r2 = celula_viva
        cmp r1, r2
        jeq gridInitPosition_removeColorYellow
        jne gridInitPosition_removeColorGray
        
            gridInitPosition_removeColorYellow:
                loadn r1, #'O'
                jmp gridInitPosition_addColorRed
                
            gridInitPosition_removeColorGray:
                loadn r1, #'*'
                jmp gridInitPosition_addColorRed
                
        gridInitPosition_addColorRed:
            loadn r5, #2304     ;r5 recebe cor vermelha
            add r1, r1, r5      ;coloca cor vermelha no char da posicao
        
        outchar r1, r0      ;imprime char vermelho
        
        ;loadn r1, #255
        ;gridInitPosition_inLoop:
        ;    loadn r2, #255
            inchar r1           ;input
        ;    cmp r1, r2
        ;    jeq gridInitPosition_inLoop
        loadn r2, #1
        hold r2
        
        loadn r2, #'r'
        cmp r1, r2
        jeq main
        
        loadn r2, #'w'
        cmp r1, r2
        jeq gridInitPosition_up
        
        loadn r2, #'a'
        cmp r1, r2
        jeq gridInitPosition_left
        
        loadn r2, #'s'
        cmp r1, r2
        jeq gridInitPosition_down
        
        loadn r2, #'d'
        cmp r1, r2
        jeq gridInitPosition_right
        
        loadn r2, #' '
        cmp r1, r2
        jeq gridInitPosition_switch
        
        loadn r2, #'p'
        cmp r1, r2
        jne gridInitPosition_loop
        load r1, celula_anterior   ;r1 recebe char anterior
        outchar r1, r0              ;imprime char cinza
        store posicao, r0
        rts
        
gridInitPosition_up:
    load r1, celula_anterior    ;r1 recebe char anterior
    outchar r1, r0              ;imprime char anterior
    
    loadn r2, #1200
    add r0, r0, r2  ;r0 + 1200
    loadn r2, #40
    sub r0, r0, r2  ;r0 - 40
    loadn r2, #1200
    mod r0, r0, r2  ;r0 % 1200
    jmp gridInitPosition_loop
    
gridInitPosition_left:
    load r1, celula_anterior   ;r1 recebe char anterior
    outchar r1, r0              ;imprime char cinza

    loadn r2, #1200
    add r0, r0, r2  ;r0 + 1200
    loadn r2, #1
    sub r0, r0, r2  ;r0 - 1
    loadn r2, #1200
    mod r0, r0, r2  ;r0 % 1200
    
    loadn r2, #40
    mod r1, r0, r2
    loadn r2, #39
    cmp r1, r2
    jne gridInitPosition_loop
    loadn r2, #40
    add r0, r0, r2 ;r0 = r0 + 40
    loadn r2, #1200
    ;add r0, r0, r2 not nedded
    mod r0, r0, r2  ;(r0 % 1200)
    
    jmp gridInitPosition_loop
    
gridInitPosition_down:
    load r1, celula_anterior   ;r1 recebe char anterior
    outchar r1, r0              ;imprime char cinza

    loadn r2, #40
    add r0, r0, r2 ;r0 = r0 + 40
    loadn r2, #1200
    ;add r0, r0, r2 not nedded
    mod r0, r0, r2  ;(r0 % 1200)
    jmp gridInitPosition_loop
    
gridInitPosition_right:
    load r1, celula_anterior   ;r1 recebe char anterior
    outchar r1, r0              ;imprime char cinza

    loadn r2, #1
    add r0, r0, r2 ;r0 = r0 + 1
    loadn r2, #1200
    ;add r0, r0, r2 not nedded
    mod r0, r0, r2  ;(r0 % 1200)
    
    loadn r2, #40
    mod r1, r0, r2
    loadn r2, #0
    cmp r1, r2
    jne gridInitPosition_loop
    loadn r2, #1200
    add r0, r0, r2  ;r0 + 1200
    loadn r2, #40
    sub r0, r0, r2  ;r0 - 40
    loadn r2, #1200
    mod r0, r0, r2  ;r0 % 1200
    
    jmp gridInitPosition_loop
    
    
gridInitPosition_switch:

    load r4, matrix_pos_inicial
    add r4, r4, r0
    loadi r3, r4            ;r3 e o conteudo
    
    load r2, celula_morta
    cmp r3, r2
    jeq gridInitPosition_switch_to_alive ;if r3 == *
    jne gridInitPosition_switch_to_dead ;if r3 == O
    
    gridInitPosition_switch_to_alive:    ;tranforma * em O
        load r3, celula_viva  
        storei r4, r3
        jmp gridInitPosition_loop
        
    gridInitPosition_switch_to_dead:    ;transforma O em *
        load r3, celula_morta
        storei r4, r3
        jmp gridInitPosition_loop
