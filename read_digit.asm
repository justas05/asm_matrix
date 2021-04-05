PUBLIC read_digit

CS_READ SEGMENT para public 'CODE'
	assume CS:CS_READ

read_digit:
 	mov ah, 01h
 	int 21h
 	sub al, 30h
 	ret

CS_READ ENDS
END