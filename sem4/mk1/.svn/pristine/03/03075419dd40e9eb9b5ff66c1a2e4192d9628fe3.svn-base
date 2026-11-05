#include <iostream>
#include <vector>
#include <algorithm>
#include <fstream>
#include <random>

using namespace std;

struct Stats {
	long long comparisons = 0;
	long long swaps = 0;
};

random_device rd;
mt19937 rng(rd());


int randomizedPartition(vector<int>& A, int p, int r, Stats& stats)
{
	uniform_int_distribution<int> dist(p, r);
	int i = dist(rng);
	
	swap(A[i], A[r]);
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


int randomizedSelect(vector<int>& A, int p, int r, int i, Stats& stats)
{
	if (p == r)
		return A[p];
	int q = randomizedPartition(A, p, r, stats);
	int k = q - p + 1;
	if (i == k)
		return A[q];
	else if (i < k)
		return randomizedSelect(A, p, q - 1, i, stats);
	else
		return randomizedSelect(A, q + 1, r, i - k, stats);
}


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


int selectAlgo(vector<int>& A, int p, int r, int i, Stats& stats)
{
	if (p == r)
		return A[p];
	int n = r - p + 1;
	vector<int> medians;

	for (int j = 0; j < n / 5; j++) {
		int medIdx = insertionSortAndMedian(A, p + j*5, p + j*5 + 4, stats);
		medians.push_back(A[medIdx]);
	}
	if (n % 5 != 0) {
		int medIdx = insertionSortAndMedian(A, p + (n/5)*5, r, stats);
		medians.push_back(A[medIdx]);
	}

	int medianOfMedians;
	if (medians.size() == 1)
		medianOfMedians = medians[0];
	else
		medianOfMedians = selectAlgo(medians, 0, medians.size() - 1, (medians.size() + 1) / 2, stats);

	int q = partitionDet(A, p, r, medianOfMedians, stats);
	int k = q - p + 1;

	if (i == k)
		return A[q];
	else if (i < k)
		return selectAlgo(A, p, q - 1, i, stats);
	else
		return selectAlgo(A, q + 1, r, i - k, stats);
}


void printArray(const vector<int>& A, const string& msg = "")
{
	if (!msg.empty())
		cout << msg << ": ";

	cout << "[";
	for (size_t i = 0; i < A.size(); ++i) {
		cout << A[i];
		if (i < A.size() - 1)
			cout << ", ";
	}
	cout << "]\n";
}


void runtest() {
	int n, k;
	cout << "Podaj n: ";
	cin >> n;
	
	if (n <= 0) {
		cout << "n musi byc wieksze od 0\n";
		return;
	}

	cout << "Podaj k [1 <= k <= " << n << "]: ";
	cin >> k;

	if (k < 1 || k > n) {
		cout << "k musi byc z przedzialu [1, n]\n";
		return;
	}

	vector<int> A(n);
	uniform_int_distribution<int> dist(0, 2 * n - 1);
	for (int i = 0; i < n; i++) {
		A[i] = dist(rng);
	}

	vector<int> A_rs = A;
	vector<int> A_select = A;
	vector<int> A_sorted = A;
	sort(A_sorted.begin(), A_sorted.end());

	Stats stats_rs, stats_select;

	int result_rs = randomizedSelect(A_rs, 0, n - 1, k, stats_rs);
	int result_select = selectAlgo(A_select, 0, n - 1, k, stats_select);

	if (n <= 30) {
		cout << "\n======= TEST DLA n = " << n << ", k = " << k << " =======\n\n";
		
		cout << "--- RANDOMIZED SELECT ---\n";
		printArray(A, "Poczatkowy stan tablicy");
		printArray(A_rs, "Koncowy stan tablicy");
		cout << "Znaleziona statystyka pozycyjna: " << result_rs << "\n";
		cout << "Porownania: " << stats_rs.comparisons << " | Przestawienia: " << stats_rs.swaps << "\n\n";

		cout << "--- SELECT ---\n";
		printArray(A, "Poczatkowy stan tablicy");
		printArray(A_select, "Koncowy stan tablicy");
		cout << "Znaleziona statystyka pozycyjna: " << result_select << "\n";
		cout << "Porownania: " << stats_select.comparisons << " | Przestawienia: " << stats_select.swaps << "\n\n";

		cout << "--- WERYFIKACJA WYNIKOW ---\n";
		printArray(A_sorted, "Posortowany ciag kluczy");
		cout << "Oczekiwana wartosc na pozycji k=" << k << " (indeks " << k - 1 << "): " << A_sorted[k - 1] << "\n";
		
		if (result_rs == A_sorted[k - 1] && result_select == A_sorted[k - 1]) {
			cout << "OK\n";
		} else {
			cout << "BŁAD\n";
		}
	} else {
		cout << "Randomized Select: " << result_rs 
			 << " (Porownania: " << stats_rs.comparisons << ", Przestawienia: " << stats_rs.swaps << ")\n";
		cout << "Select: " << result_select 
			 << " (Porownania: " << stats_select.comparisons << ", Przestawienia: " << stats_select.swaps << ")\n";
	}
}


int main(int argc, char **argv)
{
	if (argc > 0) {
		runtest();
		return 0;
	}

	ofstream file("wyniki.csv");
	file << "n,k_type,algo,comparisons,swaps\n";

	int m = 50;
	int step = 100;
	int max_n = 50000;

	cout << "Rozpoczynam testy.\n";

	for (int n = 100; n <= max_n; n += step) {
		if (n % 5000 == 0)
			cout << "n = " << n << "...\n";

		long long rs_comps[5] = {0},
			 rs_swaps[5] = {0};
		long long s_comps[5] = {0},
			 s_swaps[5] = {0};
		
		string k_names[5] = {"min", "fourth", "third", "mediana", "max"};
		int k_vals[5] = {1, n / 4,  n / 3, n / 2, n};

		for (int rep = 0; rep < m; rep++) {
			vector<int> A(n);
			uniform_int_distribution<int> dist(0, 2 * n - 1);
			for (int i = 0; i < n; i++)
				A[i] = dist(rng);

			for (int idx = 0; idx < 5; idx++) {
				int k = k_vals[idx];

				vector<int> A_rs = A;
				Stats st_rs;
				randomizedSelect(A_rs, 0, n - 1, k, st_rs);
				rs_comps[idx] += st_rs.comparisons;
				rs_swaps[idx] += st_rs.swaps;

				vector<int> A_s = A;
				Stats st_s;
				selectAlgo(A_s, 0, n - 1, k, st_s);
				s_comps[idx] += st_s.comparisons;
				s_swaps[idx] += st_s.swaps;
			}
		}

		for (int idx = 0; idx < 5; idx++) {
			file << n << "," << k_names[idx] << ",RS," << (rs_comps[idx] / m) << "," << (rs_swaps[idx] / m) << "\n";
			file << n << "," << k_names[idx] << ",SELECT," << (s_comps[idx] / m) << "," << (s_swaps[idx] / m) << "\n";
		}
	}

	file.close();
	cout << "Zakonczono! Wyniki zapisane do pliku 'wyniki.csv'.\n";
	return 0;
}
