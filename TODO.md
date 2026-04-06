# TODO

- [ ] API
- [ ] Terminal
- [ ] UI

## API

Game has a field. Players can put their symbols on the field. Game is won by one of the players if one of them makes row, column or a diagonal of required length.

```odin
main :: proc() {
  g := game.game_make({3, 3}, 3)
  defer game.game_destroy(&g)

  err := game.input_symbol(&g, {0, 1}, '本')
  ...

  w, row := game.winner(g)
  defer delete(row)
  s == '本'
  row == {{0, 2}, {1, 2}, {2, 2}}
}
```

- [x] Input symbol
- [x] Input symbol check error already taken cell
- [x] Get winner
- [x] Check row
- [x] Check column
- [x] Check diagonal
- [ ] Refactor for simpler row/col check
- [ ] Optimize search (we don't need to look at row/col/diag, if shared cell is 0)
