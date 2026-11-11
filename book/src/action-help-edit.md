# Action Help's edit mode

On Action Help (from the pause menu), SELECT turns an edit mode on and off,
like the treasure collection's ([its edit mode](collection-edit.md)). In it:

- the power-up bar shows every power-up's icon: the ones Wario has in their
  colours, the others in grey, instead of "?";
- A sets the power-up level to the selected one: Wario has every power-up up
  to it, as with the debug menu's POWER page. Action Help stays open;
- the D-pad picks a power-up as usual, and the demo shows it;
- B and START still close Action Help.

SELECT again goes back to the game's bar: the power-ups Wario has in brown,
the selected one in its colour, the others "?". Action Help always opens
without the mode, and it isn't there on the title screen's demo or after a
level, nor for Owl Wario's, the rail's and Vampire Wario's Action Help, which
have no bar.

## How it works

The code is in `src/engine/action_help/edit_mode.asm`, in Action Help's bank,
with hooks in `UpdateActionHelp` (`ActionHelpEdit_HandleInput`, which also
says which buttons close Action Help), `HandleActionHelpPowerUpSelection` (in
the mode, a new selection redraws the whole bar) and `LoadActionHelpBGPals`.
The flag is `wActionHelpEditMode`, in WRAM0, cleared by `InitActionHelp`.

The bar is BG map 1's rows 16-17: each slot a 16x16 icon, Action Help's HUD
tiles `$40` + 2 × the slot (`$60` on for the last two), or the "?" box (`$64`)
in palette 7. Owned icons are in BG palette 3, a brown silhouette, and the
selected one in its colour (palettes 4-7, which `PowerUpOBPals` picks).
`ActionHelpEdit_DrawBar` draws all ten slots, the game's way or the mode's,
in a V-Blank.

All 8 BG palettes are taken, so the grey is palette 3 (`ActionHelpEditPal`):
in the mode the owned icons are in their colours anyway, so only the others
use it. The demo's floor shares palette 3 (its colours there are the two
blacks, which stay). `LoadActionHelpBGPals`, which loads the demo's palettes
again each time a demo starts, keeps palette 3 grey in the mode.

`tests/test_action_help.py` checks the bar in and out of the mode, setting a
power-up with A, and that the level gets it.
