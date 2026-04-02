#ifndef PRECISE_MERGE_INSERTION_SORT_HPP
#define PRECISE_MERGE_INSERTION_SORT_HPP

#include <algorithm>
#include <cstddef>
#include <vector>

namespace precise_merge_insertion {

namespace detail {

struct PairParts {
    int loser;
    int winner;
};

inline std::size_t jacobsthal_bound(std::size_t k) {
    // t_k = (2^(k+1) + (-1)^k) / 3, for k >= 2 gives 3,5,11,21,...
    std::size_t two_pow = static_cast<std::size_t>(1) << (k + 1);
    int sign = (k % 2 == 0) ? 1 : -1;
    return (two_pow + static_cast<std::size_t>(sign)) / 3;
}

inline std::vector<std::size_t> insertion_order(std::size_t count) {
    std::vector<std::size_t> order;
    if (count <= 1) {
        return order;
    }

    std::size_t inserted = 1;
    std::size_t k = 2;
    while (inserted < count) {
        std::size_t bound = jacobsthal_bound(k);
        if (bound <= inserted) {
            ++k;
            continue;
        }

        if (bound > count) {
            bound = count;
        }

        std::size_t i = bound;
        while (i > inserted) {
            order.push_back(i);
            --i;
        }

        inserted = bound;
        ++k;
    }

    return order;
}

inline void merge_insertion_sort_impl(std::vector<int>& values) {
    const std::size_t n = values.size();
    if (n <= 1) {
        return;
    }

    const std::size_t pair_count = n / 2;
    std::vector<PairParts> pairs;
    pairs.reserve(pair_count);

    std::size_t i = 0;
    while (i + 1 < n) {
        int first = values[i];
        int second = values[i + 1];
        PairParts parts;
        if (first <= second) {
            parts.loser = first;
            parts.winner = second;
        } else {
            parts.loser = second;
            parts.winner = first;
        }
        pairs.push_back(parts);
        i += 2;
    }

    const bool has_straggler = (n % 2 != 0);
    const int straggler = has_straggler ? values[n - 1] : 0;

    std::vector<int> winners;
    winners.reserve(pair_count);
    for (i = 0; i < pair_count; ++i) {
        winners.push_back(pairs[i].winner);
    }

    merge_insertion_sort_impl(winners);

    std::vector<bool> used(pair_count, false);
    std::vector<int> sorted_a;
    std::vector<int> sorted_b;
    sorted_a.reserve(pair_count);
    sorted_b.reserve(pair_count);

    for (i = 0; i < winners.size(); ++i) {
        std::size_t j = 0;
        while (j < pair_count) {
            if (!used[j] && pairs[j].winner == winners[i]) {
                used[j] = true;
                sorted_a.push_back(pairs[j].winner);
                sorted_b.push_back(pairs[j].loser);
                break;
            }
            ++j;
        }
    }

    std::vector<int> chain;
    chain.reserve(n);
    chain.push_back(sorted_b[0]);
    for (i = 0; i < sorted_a.size(); ++i) {
        chain.push_back(sorted_a[i]);
    }

    const std::size_t b_count = pair_count + (has_straggler ? 1 : 0);
    const std::vector<std::size_t> order = insertion_order(b_count);

    for (i = 0; i < order.size(); ++i) {
        const std::size_t index = order[i]; // 1-based b-index

        int value_to_insert;
        std::size_t upper_bound_index;

        if (index <= pair_count) {
            value_to_insert = sorted_b[index - 1];
            upper_bound_index = static_cast<std::size_t>(
                std::upper_bound(chain.begin(), chain.end(), sorted_a[index - 1]) - chain.begin());
        } else {
            value_to_insert = straggler;
            upper_bound_index = chain.size();
        }

        std::vector<int>::iterator insert_pos = std::lower_bound(
            chain.begin(), chain.begin() + static_cast<std::ptrdiff_t>(upper_bound_index), value_to_insert);
        chain.insert(insert_pos, value_to_insert);
    }

    values.swap(chain);
}

} // namespace detail

inline void merge_insertion_sort(std::vector<int>& values) {
    if (values.size() <= 1) {
        return;
    }
    detail::merge_insertion_sort_impl(values);
}

} // namespace precise_merge_insertion

#endif // PRECISE_MERGE_INSERTION_SORT_HPP
