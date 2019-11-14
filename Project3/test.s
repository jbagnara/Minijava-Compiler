.data
prompt1: .asciz "hi"

.text
.global main
main:
push {fp, lr}
ldr r0, =prompt1
bl printf
pop {fp, pc}