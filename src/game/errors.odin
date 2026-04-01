package game

Input_Error :: union {
	Out_Of_Bounds_Error,
}

Out_Of_Bounds_Error :: struct {
	p: Pos,
	f: Size,
}
