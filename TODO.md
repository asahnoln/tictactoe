# TODO

- [ ] API
- [ ] Terminal
- [ ] UI

## API

Game has a field. Players can put their symbols on the field. Game is won by one of the players if one of them makes row, column or a diagonal of required length.

```odin
main :: proc() {
  g := game.game_make({3, 3}, 3)

  err := game.input_symbol(&g, {0, 1}, '本')
  ...

  w, r := game.winner(g)

  w == '本'
  r == {{0, 1}, {1, 1}, {2, 1}}
}
```

- [x] Input symbol
- [ ] Input symbol check error already taken cell
- [ ] Check winner
