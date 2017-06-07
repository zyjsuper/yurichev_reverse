	.intel_syntax noprefix
	.globl	try_row

try_row:
	cmp	edi, r8d		# row==queens?
	je	.L7			# exit

	push	r14
	push	r12
	push	r13
	push	rbp
	push	rbx

	# "queens" is always in R8 and will be used in subsequent calls
	# precomputed "1<<(queens-1)" is always in R9

	# registers we use as local variables:
	mov	r12d, edx		# r12=edx=attack_RL
	mov	r13d, ecx		# r13=ecx=attack_LR
	mov	r14d, esi		# r14=esi=attack_vertical
	mov	ebx, r9d		# ebx=r9=1<<(queens-1) (precomputed)
	xor	ebp, ebp		# ebp=total=0

.L3:
# we check all 3 variables subsequently
# we could OR all them and check once,
# but then we would have to use additional register, which is also would be saved in stack
	test	ebx, r12d		# new_queen & attack_RL
	jnz	.L4			# not zero? skip it: this queen can be attacked from previous/upper row(s)
	test	ebx, r13d		# new_queen & attack_LR
	jnz	.L4			# not zero? skip it: this queen can be attacked from previous/upper row(s)
	test	ebx, r14d		# new_queen & attack_vertical
	jnz	.L4			# not zero? skip it: this queen can be attacked from previous/upper row(s)

# preparing arguments for subsequent call:

	inc	edi			# (1st arg) row++ for subsequent call
	
	mov	esi, ebx		# new_queen
	or	esi, r14d		# (2nd arg) esi=attack_vertical | new_queen
	
	mov	edx, ebx		# new_queen
	or	edx, r12d		# edx=attack_RL | new_queen
	shl	edx, 1			# (3rd arg) edx=(attack_RL | new_queen)<<1

	mov	ecx, ebx		# new_queen
	or	ecx, r13d		# ecx=attack_LR | new_queen
	shr	ecx, 1			# (4th arg) ecx=(attack_LR | new_queen)>>1

	call	try_row
	dec	edi			# row-- (restore it to the previous value, we will use it)
	add	ebp, eax		# total+=try_row(...)
.L4:
	shr	ebx, 1			# shift new_queen
	jnz	.L3			# bit is still present in new_queen, continue
	# if the shifting queen has disappeared, exit:
	mov	eax, ebp		# ebp=total

	pop	rbx
	pop	rbp
	pop	r13
	pop	r12
	pop	r14
	ret
.L7:
	mov	eax, 1
	ret

