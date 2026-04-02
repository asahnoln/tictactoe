package game

Input_Error :: union {
	Out_Of_Bounds_Error,
	Cell_Already_Taken_Error,
}

Out_Of_Bounds_Error :: struct {
	p: Pos,
	f: Size,
}

Cell_Already_Taken_Error :: struct {
	p:         Pos,
	got, want: rune,
}
