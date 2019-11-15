.data
a: .word 0
newln: .asciz "%d\n"
xb: .asciz 
c: .asciz 
d: .asciz 
e: .asciz 
number: .word 0
.text
.global main
main:
	push	{fp, lr}
	pop	{fp, pc}
