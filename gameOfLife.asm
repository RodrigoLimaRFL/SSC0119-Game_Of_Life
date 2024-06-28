jmp main

; matriz com 1200 posicoes (40x30)
matrix: var #1200 ; matriz 30 x 40
matrix_ao_redor: var #1200 ; salva o num de celulas ao redor

;;; Game loop n funciona

main:
	loadn r0, #matrix ; r0 <- matriz [30][40]
   ;loadn r1, #'*' ; char vazio a ser printado
    loadn r2, #1200 ; tamanho da matriz
    ;loadn r5, #'O' ; celula viva
    loadn r7, #matrix_ao_redor
	call fillMem
	call gameCycle
	call printMat
	jmp fim
	
countCellsInc:
	inc r3 ; r3++
	rts
	
countCells:
	loadn r3, #0 ; r3 = num celulas ao redor
	loadi r4, r0 ; r4 recebe a celula atual da matriz
	
	; para acessar as celulas ao redor => ((posicao atual + offset) + 1200 ) % 1200
	; celula topo esq
	push r4 ; salva a celula atual na stack
	loadn r6, #1169
	add r4, r4, r6
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4 ; retorna o valor original
	
	; celula topo meio
	push r4
	loadn r6, #1170
	add r4, r4, r6
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4
	
	; celula topo dir
	push r4
	loadn r6, #1171
	add r4, r4, r6
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4
	
	; celula esq
	push r4
	loadn r6, #1199
	add r4, r4, r6
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4
	
	; celula dir
	push r4
	loadn r6, #1201
	add r4, r4, r6
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4
	
	; celula baixo esq
	push r4
	loadn r6, #1229
	add r4, r4, r6
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4
	
	; celula baixo meio
	push r4
	loadn r6, #1230
	add r4, r4, r6
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4
	
	; celula baixo dir
	push r4
	loadn r6, #1231
	add r4, r4, r6
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4
	
	loadi r7, r3 ; salva a qntd de celulas na matriz
	rts
	
	
killCell: ; salva o valor morto na matriz
	loadi r0, r2
	rts
	
	
reproduceCell: ; salva o valor vivo na matriz
	loadi r0, r5
	rts
	
	
liveCell:
	call underPop
	call overPop
	rts
	
	
underPop:
	loadn r6, #2 ; se a celula tem menos que 2 vizinhos morre
	cmp r7, r6
	cle killCell
	rts
	
	
overPop:
	loadn r6, #3 ; se a celula tem mais que 3 vizinhos morre
	cmp r7, r6
	cgr killCell
	rts
	
	
deadCell:
	loadn r6, #3 ; se a celula tem exatamente 3 vizinho ela nasce
	cmp r7, r6
	ceq reproduceCell
	rts
	

; simulates one tick of the game
gameCycle:
	gameCycleLoop:
		call countCells
		cmp r0, r1 ; se a celula esta morta
		ceq deadCell
		cmp r0, r5 ; se a celula esta viva
		ceq liveCell
		loadi r4, r0
		inc r0
		inc r7
		cmp r0, r2
		jle gameCycleLoop
		
	loadn r4, #1200 ; volta as matrizes para o inicio
	sub r0, r0, r4
	sub r7, r7, r4
	rts

fillMem:
	push r0
	push r2
	loadn r1, #'*' ; char vazio a ser printado
	loadn r5, #'O' ; celula viva
	loadn r4, #30
	sub r2, r2, r4
	
	fillMemLoop:
		;guarda o char r1 em r0
		storei r0, r1
		;aumenta a posicao na mem
		inc r0
		cmp r0, r2
		;if (r0 < r2) continue
		jle fillMemLoop
		
	pop r2
	fillMemLoopDois:
		;guarda o char r1 em r0
		storei r0, r5
		;aumenta a posicao na mem
		inc r0
		cmp r0, r2
		;if (r0 < r2) continue
		jle fillMemLoopDois
		
	;devolve a matriz
	pop r0
	push r0
	jmp printMat
	rts

printMat: 
	loadn r4, #0
	printMatLoop:
		loadi r3, r0 ; carrega a mem no r3
		outchar r3, r4
		inc r0
		inc r4
		cmp r0, r2
		jle printMatLoop

	pop r0
	rts

fim:
    halt
