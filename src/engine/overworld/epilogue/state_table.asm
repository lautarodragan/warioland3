EpilogueStateTable:
	ld a, [wSubState]
	jumptable

	dw .FadeToWhite
	dw .ReturnToOverworld

.FadeToWhite:
	ld a, [wGlobalCounter]
	and %11
	ret nz
	call FastFadeToWhite
	ret

.ReturnToOverworld:
	farcall ReturnToOverworld
	ret
