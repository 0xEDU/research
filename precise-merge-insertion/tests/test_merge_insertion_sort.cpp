#include "../src/merge_insertion_sort.hpp"

#include <algorithm>
#include <cassert>
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <vector>

using precise_merge_insertion::merge_insertion_sort;

static void assert_sorted_equals_std_sort(const std::vector<int>& input) {
    std::vector<int> expected = input;
    std::vector<int> actual = input;

    std::sort(expected.begin(), expected.end());
    merge_insertion_sort(actual);

    assert(actual.size() == expected.size());
    assert(actual == expected);
}

static void test_basic_cases() {
    assert_sorted_equals_std_sort(std::vector<int>());

    std::vector<int> one(1, 42);
    assert_sorted_equals_std_sort(one);

    std::vector<int> sorted;
    sorted.push_back(1);
    sorted.push_back(2);
    sorted.push_back(3);
    sorted.push_back(4);
    sorted.push_back(5);
    assert_sorted_equals_std_sort(sorted);

    std::vector<int> reverse;
    reverse.push_back(5);
    reverse.push_back(4);
    reverse.push_back(3);
    reverse.push_back(2);
    reverse.push_back(1);
    assert_sorted_equals_std_sort(reverse);

    std::vector<int> with_duplicates;
    with_duplicates.push_back(4);
    with_duplicates.push_back(1);
    with_duplicates.push_back(1);
    with_duplicates.push_back(3);
    with_duplicates.push_back(2);
    with_duplicates.push_back(2);
    assert_sorted_equals_std_sort(with_duplicates);
}

static void test_exhaustive_small_permutations() {
    for (int n = 2; n <= 8; ++n) {
        std::vector<int> base;
        for (int i = 0; i < n; ++i) {
            base.push_back(i);
        }

        do {
            assert_sorted_equals_std_sort(base);
        } while (std::next_permutation(base.begin(), base.end()));
    }
}

static void test_random_inputs() {
    std::srand(1337);

    for (int n = 0; n <= 128; ++n) {
        for (int round = 0; round < 100; ++round) {
            std::vector<int> data;
            data.reserve(n);
            for (int i = 0; i < n; ++i) {
                data.push_back((std::rand() % 2001) - 1000);
            }
            assert_sorted_equals_std_sort(data);
        }
    }
}

int main() {
    test_basic_cases();
    test_exhaustive_small_permutations();
    test_random_inputs();

    std::cout << "All merge-insertion sort tests passed." << std::endl;
    return 0;
}
