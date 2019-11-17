.data
args: .word 0
newln: .asciz "%d\n"
noln: .asciz "%d"
snewln: .asciz "%s\n"
true: .asciz "True"
false: .asciz "False"
trueln: .asciz "True\n"
falseln: .asciz "False\n"
a: .word 0
b: .word 0
c: .word 0
s: .word 0
d1: .word 0
dec: .word 0
n: .word 0
i: .word 0
.text
.global main

main:
	push	{fp, lr}
	ldr	r4, =args
	ldr	r1, [r1, #4]
	str	r1, [r4]
	mov	r0, #3
	ldr	r4, =a
	str	r0, [r4]
	mov	r0, #2
	ldr	r4, =b
	str	r0, [r4]
	mov	r0, #7
	bl	malloc
	mov	r2, r0
	mov	r1, #67
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #83
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #51
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #53
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #50
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #0
	str	r1, [r0]
	mov	r0, r2
	ldr	r4, =c
	str	r0, [r4]
	mov	r0, #7
	bl	malloc
	mov	r2, r0
	mov	r1, #72
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #101
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #108
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #108
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #111
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #0
	str	r1, [r0]
	mov	r0, r2
	ldr	r4, =s
	str	r0, [r4]
	mov	r0, #1
	ldr	r4, =d1
	str	r0, [r4]
	ldr	r4, =a
	ldr	r0, [r4]
	mov	r1, r0
	ldr	r0, =newln
	bl	printf
	ldr	r4, =a
	ldr	r0, [r4]
	push	{r0}
	ldr	r4, =b
	ldr	r0, [r4]
	mov	r1, r0
	pop	{r0}
	add	r0, r0, r1
	mov	r1, r0
	ldr	r0, =newln
	bl	printf
	mov	r0, #45
	push	{r0}
	ldr	r4, =b
	ldr	r0, [r4]
	push	{r0}
	mov	r0, #2
	mov	r1, r0
	pop	{r0}
	mul	r0, r0, r1
	push	{r0}
	mov	r0, #3
	mov	r1, r0
	pop	{r0}
	mul	r0, r0, r1
	mov	r1, r0
	mov	r1, r0
	pop	{r0}
	add	r0, r0, r1
	ldr	r4, =dec
	str	r0, [r4]
	ldr	r4, =dec
	ldr	r0, [r4]
	ldr	r4, =n
	str	r0, [r4]
	ldr	r4, =n
	ldr	r0, [r4]
	push	{r0}
	mov	r0, #2
	mov	r1, r0
	pop	{r0}
	add	r0, r0, r1
	ldr	r4, =n
	str	r0, [r4]
	ldr	r4, =n
	ldr	r0, [r4]
	push	{r0}
	mov	r0, #-1
	mov	r1, r0
	pop	{r0}
	mul	r0, r0, r1
	ldr	r4, =n
	str	r0, [r4]
	ldr	r4, =n
	ldr	r0, [r4]
	mov	r1, r0
	ldr	r0, =newln
	bl	printf
	ldr	r4, =c
	ldr	r0, [r4]
	push	{r0}
	mov	r0, #12
	bl	malloc
	mov	r2, r0
	mov	r1, #32
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #70
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #97
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #108
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #108
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #32
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #50
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #48
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #49
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #57
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #0
	str	r1, [r0]
	mov	r0, r2
	mov	r1, r0
	pop	{r0}
	mov	r2, r1
	mov	r1, r0
	mov	r0, #15
	push	{r1-r3}
	bl	malloc
	pop	{r1-r3}
	mov	r3, r1
	push	{r1-r2}
	mov	r1, r3
	bl	strcat
	pop	{r1-r2}
	mov	r3, r2
	push	{r1-r2}
	mov	r1, r3
	bl	strcat
	pop	{r1-r2}
	mov	r1, r2
	mov	r1, r0
	ldr	r0, =snewln
	bl	printf
	mov	r0, #45
	push	{r0}
	mov	r0, #2
	push	{r0}
	mov	r0, #3
	push	{r0}
	ldr	r4, =b
	ldr	r0, [r4]
	mov	r1, r0
	pop	{r0}
	mul	r0, r0, r1
	mov	r1, r0
	mov	r1, r0
	pop	{r0}
	mul	r0, r0, r1
	mov	r1, r0
	mov	r1, r0
	pop	{r0}
	add	r0, r0, r1
	ldr	r4, =dec
	str	r0, [r4]
	mov	r0, #1
	push	{r0}
	ldr	r4, =dec
	ldr	r0, [r4]
	push	{r0}
	mov	r0, #3
	mov	r1, r0
	pop	{r0}
	add	r0, r0, r1
	mov	r1, r0
	mov	r1, r0
	pop	{r0}
	mul	r0, r0, r1
	mov	r1, r0
	ldr	r0, =newln
	bl	printf
	mov	r0, #2
	push	{r0}
	mov	r0, #3
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #0
	movlt	r0, #1
	cmp	r0, #1
	beq	B0
	ldr	r0, =falseln
	bl	B1

B0:
	ldr	r0, =trueln

B1:
	bl	printf
	ldr	r4, =a
	ldr	r0, [r4]
	push	{r0}
	ldr	r4, =b
	ldr	r0, [r4]
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #0
	movgt	r0, #1
	push	{r0}
	mov	r0, #0
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #0
	moveq	r0, #1
	cmp	r0, #1
	beq	B2
	ldr	r0, =falseln
	bl	B3

B2:
	ldr	r0, =trueln

B3:
	bl	printf
	ldr	r4, =a
	ldr	r0, [r4]
	push	{r0}
	ldr	r4, =b
	ldr	r0, [r4]
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #0
	moveq	r0, #1
	cmp	r0, #1
	beq	B4
	ldr	r0, =falseln
	bl	B5

B4:
	ldr	r0, =trueln

B5:
	bl	printf
	ldr	r4, =a
	ldr	r0, [r4]
	push	{r0}
	ldr	r4, =b
	ldr	r0, [r4]
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #0
	movgt	r0, #1
	push	{r0}
	ldr	r4, =d1
	ldr	r0, [r4]
	push	{r0}
	mov	r0, #1
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #0
	moveq	r0, #1
	mov	r1, r0
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #0
	moveq	r0, #1
	cmp	r1, #0
	moveq	r0, #0
	cmp	r0, #1
	beq	B6
	ldr	r0, =falseln
	bl	B7

B6:
	ldr	r0, =trueln

B7:
	bl	printf
	ldr	r4, =a
	ldr	r0, [r4]
	push	{r0}
	ldr	r4, =b
	ldr	r0, [r4]
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #0
	movlt	r0, #1
	push	{r0}
	ldr	r4, =d1
	ldr	r0, [r4]
	push	{r0}
	mov	r0, #0
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #0
	moveq	r0, #1
	mov	r1, r0
	mov	r1, r0
	pop	{r0}
	cmp	r0, #1
	mov	r0, #0
	moveq	r0, #1
	cmp	r1, #1
	moveq	r0, #1
	cmp	r0, #1
	beq	B8
	ldr	r0, =falseln
	bl	B9

B8:
	ldr	r0, =trueln

B9:
	bl	printf
	ldr	r4, =a
	ldr	r0, [r4]
	push	{r0}
	ldr	r4, =b
	ldr	r0, [r4]
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #0
	movgt	r0, #1
	push	{r0}
	ldr	r4, =d1
	ldr	r0, [r4]
	push	{r0}
	mov	r0, #1
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #0
	moveq	r0, #1
	mov	r1, r0
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #0
	moveq	r0, #1
	cmp	r1, #0
	moveq	r0, #0
	cmp	r0, #0
	beq	B10
	ldr	r4, =d1
	ldr	r0, [r4]
	cmp	r0, #0
	beq	B12
	mov	r0, #0
	cmp	r0, #0
	beq	B14
	b	B15

B14:
	mov	r0, #9
	bl	malloc
	mov	r2, r0
	mov	r1, #67
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #111
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #114
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #114
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #101
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #99
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #116
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #0
	str	r1, [r0]
	mov	r0, r2
	mov	r1, r0
	ldr	r0, =snewln
	bl	printf

B15:
	b	B13

B12:
	mov	r0, #11
	bl	malloc
	mov	r2, r0
	mov	r1, #73
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #110
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #99
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #111
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #114
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #114
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #101
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #99
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #116
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #0
	str	r1, [r0]
	mov	r0, r2
	mov	r1, r0
	ldr	r0, =snewln
	bl	printf

B13:
	b	B11

B10:
	mov	r0, #11
	bl	malloc
	mov	r2, r0
	mov	r1, #73
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #110
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #99
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #111
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #114
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #114
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #101
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #99
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #116
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #0
	str	r1, [r0]
	mov	r0, r2
	mov	r1, r0
	ldr	r0, =snewln
	bl	printf

B11:
	mov	r0, #0
	ldr	r4, =i
	str	r0, [r4]

B16:
	ldr	r4, =i
	ldr	r0, [r4]
	push	{r0}
	mov	r0, #6
	mov	r1, r0
	pop	{r0}
	cmp	r0, r1
	mov	r0, #0
	movlt	r0, #1
	cmp	r0, #0
	beq	B17
	mov	r0, #9
	bl	malloc
	mov	r2, r0
	mov	r1, #76
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #111
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #111
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #112
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #105
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #110
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #103
	str	r1, [r0]
	add	r0, r0, #1
	mov	r1, #0
	str	r1, [r0]
	mov	r0, r2
	mov	r1, r0
	ldr	r0, =snewln
	bl	printf
	ldr	r4, =i
	ldr	r0, [r4]
	push	{r0}
	mov	r0, #2
	mov	r1, r0
	pop	{r0}
	add	r0, r0, r1
	ldr	r4, =i
	str	r0, [r4]
	b	B16

B17:
	pop	{fp, pc}
