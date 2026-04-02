CXX := g++
CXXFLAGS := -Wall -Wextra -Werror -pedantic -std=c++98 -O2

TEST_BIN := bin/test_merge_insertion_sort
TEST_SRC := tests/test_merge_insertion_sort.cpp

.PHONY: all test clean

all: test

test: $(TEST_BIN)
./$(TEST_BIN)

$(TEST_BIN): $(TEST_SRC) src/merge_insertion_sort.hpp
mkdir -p bin
$(CXX) $(CXXFLAGS) -I./src $(TEST_SRC) -o $(TEST_BIN)

clean:
rm -rf bin
