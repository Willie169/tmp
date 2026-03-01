#pragma once
#include <algorithm>
#include <concepts>
#include <iterator>

template<std::random_access_iterator RandomIt>
requires std::sortable<RandomIt>
constexpr void qsort(RandomIt first, RandomIt last) {
    if (first >= last || std::distance(first, last) <= 1) return;
    RandomIt i = first;
    for (RandomIt j=first; j<last-1; j++) {
        if (*j < *(last - 1)) {
          std::swap(*i, *j);
          ++i;
        }
    }
    std::swap(*i, *(last - 1));
    qsort(first, i);
    qsort(i+1, last);
}

template<std::random_access_iterator RandomIt, class Compare>
requires std::sortable<RandomIt, Compare>
constexpr void qsort(RandomIt first, RandomIt last, Compare comp) {
    if (first >= last || std::distance(first, last) <= 1) return;
    RandomIt i = first;
    for (RandomIt j=first; j<last-1; j++) {
        if (comp(*j, *(last - 1))) {
          std::swap(*i, *j);
          ++i;
        }
    }
    std::swap(*i, *(last - 1));
    qsort(first, i, comp);
    qsort(i+1, last, comp);
}
