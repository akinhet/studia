#include <iostream>
#include <vector>
#include <algorithm>
#include <fstream>
#include <random>
#include <chrono>

using namespace std;

struct Stats {
	long long comparisons = 0;
	long long swaps = 0;
};

random_device rd;
mt19937 rng(rd());


int insertionSortAndMedian(vector<int>& A, int p, int r, Stats& stats)
{
	for (int i = p + 1; i <= r; i++) {
		int key = A[i];
		int j = i - 1;
		while (j >= p) {
			stats.comparisons++;
			if (A[j] > key) {
				A[j + 1] = A[j];
				stats.swaps++;
				j--;
			} else
				break;
		}
		A[j + 1] = key;
		stats.swaps++;
	}
	return p + (r - p) / 2; 
}


int partitionDet(vector<int>& A, int p, int r, int pivotVal, Stats& stats)
{
	int pivotIdx = p;
	for(int i = p; i <= r; i++) {
		if(A[i] == pivotVal) {
			pivotIdx = i;
			break;
		}
	}
	swap(A[pivotIdx], A[r]);
	stats.swaps++;

	int x = A[r];
	int i_idx = p - 1;
	for (int j = p; j < r; j++) {
		stats.comparisons++;
		if (A[j] <= x) {
			i_idx++;
			swap(A[i_idx], A[j]);
			stats.swaps++;
		}
	}
	swap(A[i_idx + 1], A[r]);
	stats.swaps++;
	return i_idx + 1;
}


int selectAlgoGen(vector<int>& A, int p, int r, int i, int groupSize, Stats& stats)
{
	if (p == r)
		return A[p];
	
	int n = r - p + 1;
	vector<int> medians;

	for (int j = 0; j < n / groupSize; j++) {
		int medIdx = insertionSortAndMedian(A, p + j * groupSize, p + j * groupSize + groupSize - 1, stats);
		medians.push_back(A[medIdx]);
	}
	if (n % groupSize != 0) {
		int medIdx = insertionSortAndMedian(A, p + (n / groupSize) * groupSize, r, stats);
		medians.push_back(A[medIdx]);
	}

	int medianOfMedians;
	if (medians.size() == 1)
		medianOfMedians = medians[0];
	else
		medianOfMedians = selectAlgoGen(medians, 0, medians.size() - 1, (medians.size() + 1) / 2, groupSize, stats);

	int q = partitionDet(A, p, r, medianOfMedians, stats);
	int k = q - p + 1;

	if (i == k)
		return A[q];
	else if (i < k)
		return selectAlgoGen(A, p, q - 1, i, groupSize, stats);
	else
		return selectAlgoGen(A, q + 1, r, i - k, groupSize, stats);
}


int main()
{
	ofstream file("wyniki_z3.csv");
	file << "n,group_size,comparisons,swaps,time_us\n";

	int m = 50;
	int max_n = 50000;
	int step = 1000;
	vector<int> group_sizes = {3, 5, 7, 9, 19, 21};

	cout << "Rozpoczynam testy dla roznych wielkosci grup...\n";

	for (int n = 1000; n <= max_n; n += step) {
		if (n % 5000 == 0)
			cout << "Przetwarzam n = " << n << "...\n";

		for (int g : group_sizes) {
			long long total_comps = 0;
			long long total_swaps = 0;
			long long total_time = 0;

			for (int rep = 0; rep < m; rep++) {
				vector<int> A(n);
				uniform_int_distribution<int> dist(0, 2 * n - 1);
				for (int i = 0; i < n; i++)
					A[i] = dist(rng);

				Stats st;
				int k_stat = n / 2;

				auto start = chrono::high_resolution_clock::now();
				selectAlgoGen(A, 0, n - 1, k_stat, g, st);
				auto end = chrono::high_resolution_clock::now();

				total_time += chrono::duration_cast<chrono::microseconds>(end - start).count();
				total_comps += st.comparisons;
				total_swaps += st.swaps;
			}

			file << n << "," << g << "," 
				 << (total_comps / m) << "," 
				 << (total_swaps / m) << "," 
				 << (total_time / m) << "\n";
		}
	}

	file.close();
	cout << "Zakonczono! Wyniki w pliku 'wyniki_z3.csv'.\n";
	return 0;
}
