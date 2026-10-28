EpilogueStateTable:
	ld a, [wSubState]
	jumptable

	dw .FadeToWhite
	dw .Func_473c

.FadeToWhite:
	ld a, [wGlobalCounter]
	and %11
	ret nz
	call SlowFadeToWhite
	ret

.Func_473c:
	farcall ReturnToOverworld
	ret
