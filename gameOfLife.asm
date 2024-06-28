jmp main

; matriz com 1200 posicoes (40x30)
matrix: var #1200 ; matriz 30 x 40
matrix_ao_redor: var #1200 ; salva o num de celulas ao redor

main:
	loadn r0, #matrix ; r0 <- matriz [30][40]
    loadn r1, #'*' ; char vazio a ser printado
    loadn r2, #1200 ; tamanho da matriz
    loadn r5, #'O' ; celula viva
	push r0
	jmp fillMem
	
countCellsInc:
	inc r3 ; r3++
	rts
	
countCells:
	loadn r3, 0 ; r3 = num celulas ao redor
	loadn r4, r0 ; r4 recebe a celula atual da matriz
	loadn r6, 0 ; variavel para possibilitar adicao imediata
	
	; para acessar as celulas ao redor => ((posicao atual + offset) + 1200 ) % 1200
	; celula topo esq
	push r4 ; salva a celula atual na stack
	addc r4, r4, r6, 1169
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4 ; retorna o valor original
	
	; celula topo meio
	push r4
	addc r4, r4, r6, 1170
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4
	
	; celula topo dir
	push r4
	addc r4, r4, r6, 1171
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4
	
	; celula esq
	push r4
	addc r4, r4, r6, 1199
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4
	
	; celula dir
	push r4
	addc r4, r4, r6, 1201
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4
	
	; celula baixo esq
	push r4
	addc r4, r4, r6, 1229
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4
	
	; celula baixo meio
	push r4
	addc r4, r4, r6, 1230
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4
	
	; celula baixo dir
	push r4
	addc r4, r4, r6, 1231
	mod r4, r4, r2
	cmp r4, r5
	ceq countCellsInc
	pop r4
	
	loadn r7, r3 ; salva a qntd de celulas na matriz
	rts
	
killCell: ; salva o valor morto na matriz
	loadn r0, r2
	rts
	
reproduceCell: ; salva o valor vivo na matriz
	loadn r0, r5
	rts
	
liveCell:
	call underPop
	call overPop
	
underPop:
	loadn r6 #2 ; se a celula tem menos que 2 vizinhos morre
	cmp r7, r6
	

overPop:
	

fillMem:
	;guarda o char r1 em r0
	storei r0, r1
	;aumenta a posicao na mem
	inc r0
	cmp r0, r2
	;if (r0 < r2) continue
	jle fillMem
	;devolve a matriz
	pop r0
	push r0
	loadn r4, #0
	jmp printMat

printMat: 
	loadi r3, r0 ; carrega a mem no r3
	outchar r3, r4
	inc r0
	inc r4
	cmp r0, r2
	jle printMat

	pop r0
	jmp fim

fim:
    halt
