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
	tests := []struct {
		f:    [][]rune,
		want: []game.Pos,
	} {
		{
			{ 	//
				{0, 0, 0},
				{'y', 'y', 'y'},
				{0, 'x', 'y'},
			},
			{{0, 1}, {1, 1}, {2, 1}},
		},
		{
			{ 	//
				{0, 'y', 0},
				{'x', 'y', 0},
				{'x', 'y', 'y'},
			},
			{{1, 0}, {1, 1}, {1, 2}},
		},
	}

	for tt in tests {
		w, r := game.winner(tt.f)
		defer delete(r)

		testing.expect_value(t, w, 'y')

		testing.expectf(t, slice.equal(r, tt.want), "got row %v; want %v", r, tt.want)
	}
}

@(test)
winner_row :: proc(t: ^testing.T) {
	row := []game.Pos{{}, {}}
	w := game.winner_row(
		[][]rune { 	// Field
			{0, 0},
			{'o', 'x'},
			{'y', 'y'},
			{0, 0},
		},
		&row,
	)

	testing.expect_value(t, w, 'y')

	want_row := []game.Pos{{0, 2}, {1, 2}}
	testing.expectf(t, slice.equal(row, want_row), "got row %v; want %v", row, want_row)
}
@(test)
winner_col :: proc(t: ^testing.T) {
	col := []game.Pos{{}, {}}
	w := game.winner_col(
		[][]rune { 	// Field
			{0, 'y', 'x', 0},
			{0, 'y', 'o', 0},
		},
		&col,
	)

	testing.expect_value(t, w, 'y')

	want_col := []game.Pos{{1, 0}, {1, 1}}
	testing.expectf(t, slice.equal(col, want_col), "got col %v; want %v", col, want_col)
}

@(test)
winner_diag :: proc(t: ^testing.T) {
	diag := []game.Pos{{}, {}}
	w := game.winner_diag(
		[][]rune { 	// Field
			{0, 'y'},
			{'y', 0},
		},
		&diag,
	)

	testing.expect_value(t, w, 'y')

	want_diag := []game.Pos{{1, 0}, {0, 1}}
	testing.expectf(t, slice.equal(diag, want_diag), "got diag %v; want %v", diag, want_diag)
}
