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

  w := game.winner(g)
  defer delete(w.row)
  w.s == '本'
  w.row == {{0, 2}, {1, 2}, {2, 2}}
}
```

- [x] Input symbol
- [x] Input symbol check error already taken cell
- [ ] Get winner
- [ ] Check row
- [ ] Check column
- [ ] Check diagonal
