.data
a: .word 0
newln: .asciz "%d\n"
x: .word 0
y: .word 0
.text
.global main
main:
	push	{fp, lr}
	mov	r0, #2
	mov	r0, #2
	mov	r0, #2
	mov	r0, #2
	mov	r0, #5
	mov	r0, #6
	mov	r0, #5
	push	{r0}
	mov	r0, #1
	mov	r1, r0
	pop	{r0}
	add	r0, r0, r1
	mov	r4, r0
	mov	r0, r4
	push	{r0}
	mov	r0, #5
	mov	r1, r0
	pop	{r0}
	push	{r0}
	mov	r0, #2
	mov	r1, r0
	pop	{r0}
	LDR	r4, =y
	STR	r0, [r4]
	LDR	r4, =y
	LDR	r0, [r4]
	mov	r1, r0
	ldr	r0, =newln
	bl printf
	LDR	r4, =x
	LDR	r0, [r4]
	mov	r1, r0
	ldr	r0, =newln
	bl printf
	pop	{fp, pc}
