# 42

[Salpynx](https://esolangs.org/wiki/User:Salpynx) on esolangs.org has a language family called [42](https://esolangs.org/wiki/42), which is the set of languages
satisying two conditions:
* source code consists of a single number (whose representation is not relevant, ie. they use a gödel numbering of some kind)
* the number 42 is a self-interpreter

This language is a 42 which is not entirely trivial - rather than define 42 to mean 'interpret 42 code' as a single instruction, it represents a set of instructions
that implement a self-interpreter (though admittedly those instructions are 'read input to the current cell' followed by 'execute the contents of the current cell
as 42 code').

## Language

Source code is a number. That numbers base-9 digits are taken, in order from least to most significant, as instructions of a slightly modified brainfuck as follows:
| Base-9 Digit | Instruction |
|-------|-------------|
| 0 | `+` |
| 1 | `-` |
| 2 | `<` |
| 3 | `>` |
| 4 | `e` |
| 5 | `.` |
| 6 | `,` |
| 7 | `[` |
| 8 | `]` |
Where the brainfuck instructions behave as normal, and `e` is an eval instruction - it takes the value in the current cell and runs it as 42 code (in a fresh
context), setting the value of the current cell to the value in the current cell of the subprogram when and if it halts.

## Self-Interpreter

```
42
```
In base 9, 42 is written '46'. Those digits from least to most significant, '64', represent the program `,e`.

## Restrictions and Specifics

Because the number 1 is equal to the number 01, you can't use a `+` as the last instruction of a 42 program. This makes no difference to its power, since you
can use `++-` (represented by a number starting '100...' in base 9) instead.

This implementation allows cell values to be any integer. You can execute a negative number, the result is the same as for its absolute value.

When the program is run it expects a number to run to provided to stdin. If you instead use the provided `run` binding in your own program or repl,
you can provide an optional argument `#:debug? (or/c #t #f) = #f` that determines whether to print debugging output.
