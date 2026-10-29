long sum_to(long n) { return n == 0 ? 0 : n + sum_to(n - 1); }
