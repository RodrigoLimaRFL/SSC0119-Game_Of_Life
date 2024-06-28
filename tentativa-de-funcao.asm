funcCall:
    push r0
    dec SP
    push r1
    dec SP
    push r2
    dec SP
    push r3
    dec SP
    push r4
    dec SP
    push r5
    dec SP
    push r6
    dec SP
    
    jmp r7

gridInitPosition:
    loadi r7, PC
    jmp funcCall ;stacks r0 to r6, should revert before exiting funtion
    loadn r0, #0  ;position
    load r4, matrix ;*idk if this works*
    inchar r1       ;input
    
    cmp r1, #'w'
    jeq gridInitPosition_up
    
    cmp r1, #'a'
    jeq gridInitPosition_left
    
    cmp r1, #'s'
    jeq gridInitPosition_down
    
    cmp r1, #'d'
    jeq gridInitPosition_right
    
    cmp r1, #'f'
    jeq gridInitPosition_switch
    
    cmp r1, #'g'
    jmp funcExit
    jeq Start
    
gridInitPosition_up:
    loadn r2, #40
    sub r0, r0, r2  ;r0 = r0 - 40
    loadn r2, #1200
    add r0, r0, r2
    mod r0, r0, r2  ; (r0 + 1200) % 1200
    jmp gridInitPosition
    
gridInitPosition_left:
    loadn r2, #1
    sub r0, r0, r2 ;r0 = r0 - 1
    loadn r2, #1200
    add r0, r0, r2
    mod r0, r0, r2  ; (r0 + 1200) % 1200
    jmp gridInitPosition
    
gridInitPosition_down:
    loadn r2, #30
    add r0, r0, r2 ;r0 = r0 + 30
    loadn r2, #1200
    ;add r0, r0, r2 not nedded
    mod r0, r0, r2  ;(r0 % 1200)
    jmp gridInitPosition
    
gridInitPosition_right:
    loadn r2, #1
    add r0, r0, r2 ;r0 = r0 + 1
    loadn r2, #1200
    ;add r0, r0, r2 not nedded
    mod r0, r0, r2  ;(r0 % 1200)
    jmp gridInitPosition
    
    
gridInitPosition_switch:
    
    jmp gridInitPosition    ;r4 is matrix
    add r2, r4, r0          ;r2 is position in matrix
    loadi r3, r4            ;r3 is content of r2
    
    cmp r3, #'*'
    jeq gridInitPosition_switch_to1 ;if r3 == *
    jne gridInitPosition_switch_to0 ;if r3 == O
    
    gridInitPosition_switch_to1:    ;turns * into O
        loadn r3, #'O'  
        storei r3, r2
        jmp gridInitPosition
        
    gridInitPosition_switch_to0:    ;turns O into *
        loadn r3, #'*'
        storei r3, r2
        jmp gridInitPosition