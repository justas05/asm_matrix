PUBLIC print_dl
PUBLIC print_space
PUBLIC print_endl
PUBLIC print_line
PUBLIC print_digit

CS_PRINT SEGMENT para public 'CODE'
	assume CS:CS_PRINT

print_dl:
	mov ah, 2
 	int 21h
	ret

print_space:
	mov dl, 020h
	call print_dl
	ret

print_endl:
	mov dl, 0Dh
	call print_dl
	mov dl, 0Ah
	call print_dl
	ret

print_line:
	mov ah, 09h
	int 21h
	ret

print_digit:
	add dl, 30h
	call print_dl
	ret

CS_PRINT ENDS
END