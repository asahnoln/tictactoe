package game

Pos :: [2]int
Size :: Pos

Game :: struct {
	field: [][]rune,
}

Winner :: struct {
	s:   rune,
	row: []Pos,
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

winner :: proc(g: Game) -> (w: rune, row: []Pos) {
	row = make([]Pos, len(g.field))

	for r, y in g.field {
		for c, x in r {
			row[x] = {x, y}
			w = c
		}

		if row[len(row) - 1] != {0, 0} {
			break
		}
	}

	return w, row
}
