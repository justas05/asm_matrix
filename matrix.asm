EXTRN print_endl: far
EXTRN print_space: far
EXTRN read_digit: far
EXTRN matrix: byte
EXTRN cols: byte

PUBLIC read_matrix
PUBLIC print_matrix

CS_MATRIX SEGMENT para public 'CODE'
 	assume CS:CS_MATRIX

read_matrix:
 	xor bx, 0
	for_rows:
		mov es:0010, cx
		mov cx, 0

	;счетчик для строк в DS
		mov ax, 10h
		mov es:0000, ax

		mov ax, 0
		mov al, [cols]
		mov cx, ax

	for_cols:
		call read_digit
		mov [ds:matrix + bx], al
		inc bx
		
	loop for_cols

	;возвращаю значения и передаю новое значение начала строки в bx
		mov cx, es:0010
		add bx, es:0000
		mov ax, 0
		mov al, [cols]
		sub bx, ax
	loop for_rows
	ret

print_matrix:
	label2_out:
		mov es:0010, cx
		mov cx, 0
		mov ax, 0

		mov ax, 10h
		mov es:0000, ax

		mov ax, 0
		mov al, [cols]
		mov cx, ax

		label2_in:
			mov dl, [ds:matrix + bx]
			add dl, 30h
			mov ah, 2
			inc bx
			int 21h
			call print_space
		
		loop label2_in
		
		call print_endl
		
		mov cx, es:0010
		add bx, es:0000
		mov ax, 0
		mov al, [cols]
		sub bx, ax
	loop label2_out
	ret

CS_MATRIX ENDS
END