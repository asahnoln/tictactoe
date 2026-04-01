package game_test

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


	err := game.input_symbol(&g, {3, 0}, 'w')
	testing.expect_value(t, err, game.Out_Of_Bounds_Error{p = {3, 0}, f = {2, 2}})

	err = game.input_symbol(&g, {0, -1}, 'w')
	testing.expect_value(t, err, game.Out_Of_Bounds_Error{p = {0, -1}, f = {2, 2}})

	err = game.input_symbol(&g, {-1, 0}, 'w')
	testing.expect_value(t, err, game.Out_Of_Bounds_Error{p = {-1, 0}, f = {2, 2}})

	err = game.input_symbol(&g, {0, 4}, 'w')
	testing.expect_value(t, err, game.Out_Of_Bounds_Error{p = {0, 4}, f = {2, 2}})
}
