.data
newln: .asciz "%d\n"
noln: .asciz "%d"
snewln: .asciz "%s\n"
n: .word 0
out: .byte 0
multiplier: .word 0
prod: .word 0
.text
.global main

B0:
	push	{r1-r4, lr}
	mov	r0, #4
	bl	malloc
	mov	r2, r0
	mov	r1, #104
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #105
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #0
	str	r1, [r0]
	mov	r0, r2
	mov	r1, r0
	ldr	r0, =snewln
	bl	printf
	mov	r0, #1
	pop	{r1-r4, pc}

main:
	push	{fp, lr}
	mov	r0, #100
	ldr	r4, =n
	str	r0, [r4]
	ldr	r4, =n
	ldr	r0, [r4]
	push	{r0}
	mov	r0, #1
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #0
	movlt	r0, #1
	cmp	r0, #0
	beq	B1
	mov	r0, #28
	bl	malloc
	mov	r2, r0
	mov	r1, #69
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #110
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #116
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #101
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #114
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #32
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #97
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #32
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #112
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #111
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #115
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #105
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #116
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #105
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #118
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #101
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #32
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #105
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #110
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #116
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #101
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #103
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #101
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #114
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #59
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #10
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #0
	str	r1, [r0]
	mov	r0, r2
	mov	r1, r0
	ldr	r0, =snewln
	bl	printf
	b	B2

B1:
	mov	r0, #11
	bl	malloc
	mov	r2, r0
	mov	r1, #70
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #97
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #99
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #116
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #111
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #114
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #105
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #97
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #108
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #0
	str	r1, [r0]
	mov	r0, r2
	push	{r0}
	mov	r0, #6
	bl	malloc
	mov	r2, r0
	mov	r1, #32
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #111
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #102
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #32
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #0
	str	r1, [r0]
	mov	r0, r2
	mov	r1, r0
	pop	{r0}
	mov	r2, r1
	mov	r1, r0
	mov	r0, #13
	push	{r1-r3}
	bl	malloc
	pop	{r1-r3}
	mov	r3, r1
	push	{r1-r2}
	mov	r1, r3
	bl	strcat
	pop	{r1-r2}
	mov	r3, r0
	mov	r0, r1
	push	{r1-r3}
	bl	free
	pop	{r1-r3}
	mov	r0, r3
	mov	r3, r2
	push	{r1-r2}
	mov	r1, r3
	bl	strcat
	pop	{r1-r2}
	mov	r1, r2
	mov	r3, r0
	mov	r0, r1
	push	{r1-r3}
	bl	free
	pop	{r1-r3}
	mov	r0, r3
	ldr	r4, =out
	str	r0, [r4]
	ldr	r4, =out
	ldr	r0, [r4]
	bl	printf
	ldr	r4, =n
	ldr	r0, [r4]
	mov	r1, r0
	ldr	r0, =noln
	bl	printf
	mov	r0, #6
	bl	malloc
	mov	r2, r0
	mov	r1, #32
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #105
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #115
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #32
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #0
	str	r1, [r0]
	mov	r0, r2
	bl	printf

B2:
	mov	r0, #1
	ldr	r4, =multiplier
	str	r0, [r4]
	mov	r0, #1
	ldr	r4, =prod
	str	r0, [r4]

B3:
	ldr	r4, =multiplier
	ldr	r0, [r4]
	push	{r0}
	mov	r0, #10
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #1
	movgt	r0, #0
	cmp	r0, #0
	beq	B4
	ldr	r4, =prod
	ldr	r0, [r4]
	push	{r0}
	ldr	r4, =multiplier
	ldr	r0, [r4]
	mov	r1, r0
	pop	{r0}
	mul	r0, r0, r1
	ldr	r4, =prod
	str	r0, [r4]
	ldr	r4, =multiplier
	ldr	r0, [r4]
	push	{r0}
	mov	r0, #1
	mov	r1, r0
	pop	{r0}
	add	r0, r0, r1
	ldr	r4, =multiplier
	str	r0, [r4]
	b	B3

B4:
	ldr	r4, =prod
	ldr	r0, [r4]
	mov	r1, r0
	ldr	r0, =noln
	bl	printf
	mov	r0, #3
	bl	malloc
	mov	r2, r0
	mov	r1, #10
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #0
	str	r1, [r0]
	mov	r0, r2
	mov	r1, r0
	ldr	r0, =snewln
	bl	printf
	bl	B0
	mov	r1, r0
	ldr	r0, =newln
	bl	printf
	pop	{fp, pc}
