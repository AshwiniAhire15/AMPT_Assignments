%define At    esp+20
%define A     esp+24
%define nrows esp+28
%define ncols esp+32

   bits 32
   global Transpose_Matrix          

   section .text

Transpose_Matrix: equ $
;                                  Prologue
   push ebp
   push ebx
   push esi
   push edi
   mov  ebp,dword[nrows]
   mov  ebx,dword[A]         ; A is the source matrix
   mov  edx,dword[At]        ; At is the destination matrix
   mov  eax,dword[nrows]
   lea  ebp,[8*ebp]
next_row: equ $
   dec  eax
   jnge  return
   mov  edi,edx              ; At column                           
   mov  esi,ebx              ; A row                               
   xor  ecx,ecx              ; [ecx] = 0
   sub  edi,ebp
next_col: equ $              ; s0   s1   s2   s3   s4   s5   s6   s7
   cmp  ecx,dword[ncols]
   jge  next_row_setup
   fld qword[esi]            ; esi  
   lea  edi,[edi+ebp]
   inc  ecx
   fstp qword[edi]           ; edi
   add  esi,8
   jmp  next_col
next_row_setup equ $
   add  edx,8
   lea  ebx,[ebx+8*ecx]
   jmp  next_row
return: equ $                ; Epilogue
   pop edi                   ; restore registers edi, esi, and ebx.
   pop esi
   pop ebx                                                         
   pop ebp                   ; restore ebp register
   ret                       ; return to calling routine
   section .data
   section .bss
