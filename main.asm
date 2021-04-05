EXTRN read_matrix: far
EXTRN print_matrix: far

EXTRN read_digit: far

EXTRN print_endl: far
EXTRN print_space: far
EXTRN print_dl: far
EXTRN print_line: far
EXTRN print_digit:far

PUBLIC matrix
PUBLIC cols

STK SEGMENT para STACK 'STACK'
 	db 100 dup(0)
STK ENDS

SD1 SEGMENT PARA PUBLIC 'DATA'
 	rows db 00h
 	cols db 00h
 	tmpsum db 00h
 	rowindex db 00h
 	maxsum db 00h
 	tmpcsum db 00h
 	maxcsum db 00h
 	colindex db 00h
 	db 8 dup (0)
 	matrix db 100 dup(0)
SD1 ENDS

SD2 SEGMENT PARA public 'DATA'
	MtxMessage DB 0Dh, 0Ah, 'Matrix', 0Dh, 0Ah, '$'
SD2 ENDS

CSEG SEGMENT para public 'CODE'
 	assume CS:CSEG, DS:SD1

; чтение цифры, как символа и преобразование к числовому значению
read_digit:
 	mov ah, 01h
 	int 21h
 	sub al, 30h
 	ret

; вывод на экран содержимого регистра dl
print_dl:
	mov ah, 2
 	int 21h
	ret

; вывод на экран символа пробела
print_space:
	mov dl, 020h
	call print_dl
	ret

; вывод на экран символа новой строки
print_endl:
	mov dl, 0Dh
	call print_dl
	mov dl, 0Ah
	call print_dl
	ret

; вывод на экран строки, указанной в dx
print_line:
	mov ah, 09h
	int 21h
	ret

; вывод на экран символа соответствующего цифре
print_digit:
	add dl, 30h
	call print_dl
	ret

; чтение матрицы новой строки
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
	print_for_rows:
		mov es:0010, cx
		mov cx, 0
		mov ax, 0

		mov ax, 10h
		mov es:0000, ax

		mov ax, 0
		mov al, [cols]
		mov cx, ax

		print_for_cols:
			mov dl, [ds:matrix + bx]
			add dl, 30h
			mov ah, 2
			inc bx
			int 21h
			call print_space
		
		loop print_for_cols
		
		call print_endl
		
		mov cx, es:0010
		add bx, es:0000
		mov ax, 0
		mov al, [cols]
		sub bx, ax
	loop print_for_rows
	ret

main:
	mov ax, SD1
	mov ds, ax

 	call read_digit
 	mov [rows], al

	call read_digit
 	mov [cols], al
 	
	call print_space

	xor ax, 0
 	mov al, [rows]
	mov cx, ax
	call read_matrix

;заголовок перед матрицей
 	assume DS:SD2
 	mov ax, SD2
	mov ds, ax
	mov dx, OFFSET MtxMessage
	call print_line

;вывод матрицы
	assume DS:SD1

	mov ax, SD1
	mov ds, ax
	mov bx, 0
	mov ax, 0

	mov al, [rows]
	mov cx, ax

	call print_matrix

;разворачиваем цикл обхода матрицы

	mov bx, 0
	mov ax, 0

	mov dx, 0
	mov al, [cols]
	mov cx, ax

label5_out:
	mov es:0010, cx
	mov cx, 0
	mov ax, 0
	mov [ds:tmpcsum], 0

	mov ax, 16h
	mov es:0000, ax

	mov ax, 0
	mov al, [rows]
	mov cx, ax

label5_in:
 	mov dl, [ds:tmpcsum]
 	add dl, [ds:matrix + bx]
 	mov [ds:tmpcsum], dl
 	inc bx
	
loop label5_in
	
	mov cx, es:0010
	add bx, es:0000
	mov ax, 0
	mov al, [rows]
	sub bx, ax

	mov ax, 0
	mov al, [ds:tmpcsum]
	cmp [ds:maxcsum], al
	jae cnotmaxsum

	mov [ds:maxcsum], al
	mov ax, 0
	mov ax, es:0010
	mov [ds:colindex], al
	
cnotmaxsum:
loop label5_out

;выводим значение счетчика на столбце с большей суммой
	mov ax, 0
	mov dx, 0
	add dl, [ds:colindex]
	call print_digit
	
	; exit
	mov ax, 4c00h
 	int 21h

CSEG ENDS
END main