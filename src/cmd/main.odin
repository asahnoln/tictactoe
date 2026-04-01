package main

import "core:fmt"
main :: proc() {
	k := '本'
	fmt.printfln("%[0]v %[0]T", k)
}
