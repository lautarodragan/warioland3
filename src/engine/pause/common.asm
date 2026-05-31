PauseMenuStateTable:
	push_wram BANK("GFX RAM")
	farcall _PauseMenuStateTable
	pop_wram
	ret

DebugMenuStateTable:
	push_wram BANK("GFX RAM")
	farcall _DebugMenuStateTable
	pop_wram
	ret
