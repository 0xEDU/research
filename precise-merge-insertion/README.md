# precise-merge-insertion

A small C++93 project implementing Ford-Johnson (merge-insertion) sort for `std::vector<int>`.

## Build and test

From this directory:

```bash
make clean && make test
```

If successful, the test binary prints:

`All merge-insertion sort tests passed.`

## Project layout

- `src/merge_insertion_sort.hpp`: merge-insertion sort implementation
- `tests/test_merge_insertion_sort.cpp`: unit tests (edge cases, exhaustive small permutations, randomized checks)
- `Makefile`: build and test entry points
