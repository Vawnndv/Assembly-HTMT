.model small
.stack 100h
.data  
  goodmorning		db "Good morning$"
  goodafternoon 	db "Good afternoon$"
  goodevening		db "Good evening$"
  error             db "Math ERROR (denominator must not be zero)$"
.code 
print_time proc		; su dung 2 vong lap de in ra ma tran 
  mov bh, ch
  mov bl, 1
IN_DOC:
  mov dh, cl
    IN_NGANG:   
      mov ah, 2
      mov dl, 2Ah
      int 21h
      cmp dh, 1
      je OUT_NGANG
      sub dh, bl
      jmp IN_NGANG
    OUT_NGANG:
      mov ah, 2
      mov dl, 0Ah
      int 21h  
      mov dl, 0Dh
      int 21h
  cmp bh, 1
  je OUT_DOC
  sub bh, bl
  jmp IN_DOC
OUT_DOC:    
  ret     
print_time endp 

DISP proc		; lenh in ra man hinh 2 chu so
  aam
  mov bx,ax
  mov dl,bh      ; Since the values are in BX, BH Part
  add dl,30h     ; ASCII Adjustment
  mov ah,02h     ; To Print in DOS
  int 21h
  mov dl,bl      ; BL Part 
  add dl,30h     ; ASCII Adjustment
  mov ah,02h     ; To Print in DOS
  int 21h          
  mov dl, 0Ah
  int 21h  
  mov dl, 0Dh
  int 21h
  ret
DISP endp      ; End Disp Procedure

TINH proc		
  mov al, ch
  mov bl, cl
  add al,bl 
  call DISP  
  
  xor ax, ax    
  mov al, ch 
  mov bl, cl   
  cmp ch, cl
  jl  NEGATIVE        
POSITIVE:
  sub al, bl
  jmp IN_SO
NEGATIVE:		; neu la so am thi in dau '-' 
  mov ah, 2 
  mov dl, '-'
  int 21h 
  mov al, cl 
  mov bl, ch 
  sub al, bl 
IN_SO:
  call DISP
  
  cmp cl, 0
  je _ERROR
  xor ax, ax
  mov al, ch
  mov bl, cl
  div bl
  mov al, ah
  call DISP
  ret
_ERROR:
  mov 	DX, offset  error
  call	Print
  ret
TINH endp

Print Proc	; DX = offset message
	mov AH, 9
	int 21h
	mov ah, 2
    mov dl, 0Ah
    int 21h  
    mov dl, 0Dh
    int 21h
	ret
Print EndP
InitData Proc
	mov AX, @data
	mov DS, AX
	ret
InitData EndP
GetShift Proc ; AL = Shift Byte
	push	ES
	mov 	AX, 0
	mov	ES, AX
	mov 	AL, byte ptr ES:[417h]
	pop 	ES
	ret
GetShift EndP
	
CAPSLOCK proc
	
	mov dl,bl      ; BL Part 
	add dl,30h     ; ASCII Adjustment
	mov ah,02h     ; To Print in DOS

	call 	InitData	
	call 	GetShift
	cmp		al, 0
	jne		CheckCapslock
	jmp 	Out_
CheckCapslock:
	and 	AL, 40h	; den Capslock ung voi bit 6 (xCxxxxxx)	
	jnz 	CapsLockOn
	jmp 	Out_
CapsLockOn:
	cmp		ch, 12
	jl		MORNING
	cmp		ch, 17
	jl		AFTERNOON
	mov 	DX, offset goodevening
	call	Print
	jmp		Out_
MORNING:
	mov 	DX, offset goodmorning
	call	Print
	jmp		Out_
AFTERNOON:
	mov 	DX, offset goodafternoon
	call	Print
	jmp		Out_
Out_:		
	ret
CAPSLOCK endp

main proc
   mov ah,2ch
   int 21h			; lay gio va phut
   call CAPSLOCK	; hien thi loi chao neu bat CAPSLOCK
   xor ax, ax		; xoa bo nho AX
   mov al, ch
   mov bl, 2
   div bl
   
   cmp ah, 0		; so sanh du cua gio chia cho 2
   jne _ODD			; neu khong bang 0 thi chuyen qua ham _ODD

   cmp ch, 0
   je EXIT
   cmp cl, 0
   je EXIT
_EVEN:
     call print_time
     jmp EXIT
_ODD:
   call TINH
   jmp EXIT
EXIT:				; thoat chuong trinh
  mov ah, 4ch
  int 21h 
    
main endp     
end main