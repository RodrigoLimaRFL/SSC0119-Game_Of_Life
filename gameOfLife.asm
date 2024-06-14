jmp main

printGridLoop:
    outchar r0, r2
    addc r0, r0, r3
    jmp printGrid


printGrid:
    cmp r0, r1
    jne printGridLoop
    jmp fim

main:
    loadn r0, #0
    loadn r1, #1200
    loadn r2, #"*"
	loadn r3, #1
    jmp printGrid

fim:
    halt
