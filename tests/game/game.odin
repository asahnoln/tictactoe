package game_test

import "core:slice"
import "core:testing"
import "src:game"

@(test)
input_symbol :: proc(t: ^testing.T) {
	g := game.game_make(3)
	defer game.game_destroy(&g)

	err := game.input_symbol(&g, {0, 1}, 'w')

	testing.expect_value(t, err, nil)
	testing.expect_value(t, g.field[1][0], 'w')
}

@(test)
input_symbol_error_out_of_bound :: proc(t: ^testing.T) {
	g := game.game_make(2)
	defer game.game_destroy(&g)

	tests := []struct {
		p: game.Pos,
	}{{{3, 0}}, {{0, -1}}, {{-1, 0}}, {{0, 4}}}

	for tt in tests {
		err := game.input_symbol(&g, tt.p, 'w')
		want := game.Out_Of_Bounds_Error {
			p = tt.p,
			f = {2, 2},
		}
		testing.expectf(t, err == want, "for pos %v got err %v; want %v", tt.p, err, want)
	}
}

@(test)
input_symbol_error_already_taken_cell :: proc(t: ^testing.T) {
	g := game.game_make(4)
	defer game.game_destroy(&g)


	_ = game.input_symbol(&g, {2, 3}, 'o')
	err := game.input_symbol(&g, {2, 3}, 'x')
	testing.expect_value(t, err, game.Cell_Already_Taken_Error{p = {2, 3}, got = 'o', want = 'x'})
}

@(test)
winner :: proc(t: ^testing.T) {
	g := game.game_make(3)
	defer game.game_destroy(&g)


	// Winning row
	g.field[1][0] = 'y'
	g.field[1][1] = 'y'
	g.field[1][2] = 'y'

	g.field[2][0] = 'x'
	g.field[2][1] = 'y'

	w, r := game.winner(g)
	defer delete(r)

	testing.expect_value(t, w, 'y')

	want_row := []game.Pos{{0, 1}, {1, 1}, {2, 1}}
	testing.expectf(t, slice.equal(r, want_row), "got row %v; want %v", r, want_row)
}
