package game

Pos :: [2]int
Size :: Pos

Game :: struct {
	field: [][]rune,
}

game_make :: proc(size: int, allocator := context.allocator) -> (g: Game) {
	g.field = make([][]rune, size, allocator)
	for i in 0 ..< size {
		g.field[i] = make([]rune, size, allocator)
	}
	return
}

game_destroy :: proc(g: ^Game, allocator := context.allocator) {
	for i in 0 ..< len(g.field) {
		delete(g.field[i], allocator)
	}
	delete(g.field, allocator)
}

field_size :: proc(g: Game) -> Size {
	return len(g.field)
}

input_symbol :: proc(g: ^Game, p: Pos, s: rune) -> (err: Input_Error) {
	if p.x < 0 || p.y < 0 || p.x >= len(g.field) || p.y >= len(g.field) {
		return Out_Of_Bounds_Error{p = p, f = field_size(g^)}
	}

	if got := g.field[p.y][p.x]; got != 0 {
		return Cell_Already_Taken_Error{p = p, got = got, want = s}
	}

	g.field[p.y][p.x] = s
	return
}

winner :: proc(f: [][]rune) -> (w: rune, row: []Pos) {
	row = make([]Pos, len(f))

	w = winner_row(f, &row)
	if w == 0 {
		w = winner_col(f, &row)
	}
	if w == 0 {
		w = winner_diag(f, &row)
	}

	return w, row
}

// TODO: Simpler check refactor
winner_row :: proc(f: [][]rune, row: ^[]Pos) -> (w: rune) {
	row_loop: for r, y in f {
		for c, x in r {
			if c == 0 || w != 0 && c != w {
				w = 0
				continue row_loop
			}

			w = c
			row[x] = {x, y}
		}

		break
	}

	return w
}

winner_col :: proc(f: [][]rune, col: ^[]Pos) -> (w: rune) {
	col_loop: for _, x in f[0] {
		for r, y in f {
			c := f[y][x]

			if c == 0 || w != 0 && c != w {
				w = 0
				continue col_loop
			}

			w = c
			col[y] = {x, y}
		}

		break
	}

	return w
}

winner_diag :: proc(f: [][]rune, col: ^[]Pos) -> (w: rune) {
	has_diag := true
	has_diag_rev := true
	max_x := len(f) - 1
	for _, y in f {
		has_diag = has_diag && f[0][0] != 0 && f[0][0] == f[y][y]
		has_diag_rev = has_diag_rev && f[0][max_x] != 0 && f[0][max_x] == f[y][max_x - y]

		if !has_diag && !has_diag_rev {
			return
		}
	}

	if has_diag {
		max_x = 0
	}

	for _, y in f {
		col[y] = {abs(max_x - y), y}
	}

	return f[0][max_x]
}
