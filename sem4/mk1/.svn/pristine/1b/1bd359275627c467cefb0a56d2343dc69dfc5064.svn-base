#include <functional>
#include <iostream>
#include <vector>
#include <cmath>
#include <algorithm>
#include <random>
#include <fstream>
#include <iomanip>

using namespace std;

random_device rd;
mt19937 rng(rd());


double f1(int x)
{
	return pow(log2(x + 1), 3);
}


double f2(int x)
{
	return sqrt(x) + log2(x + 1);
}


int standardBinarySearch(const vector<double>& A, double q, int& comps)
{
	int low = 0,
		high = A.size() - 1;
	while (low <= high) {
		int mid = low + (high - low) / 2;
		comps++; 
		if (A[mid] == q)
			return mid;
		
		comps++;
		if (A[mid] < q)
			low = mid + 1;
		else
			high = mid - 1;
	}
	return -1;
}


int find_L(int n, double q, double delta, function<double(int)> f)
{
	int low = 0,
		high = n - 1,
		ans = n;

	while (low <= high) {
		int mid = low + (high - low) / 2;
		if (f(mid) + delta > q) {
			ans = mid;
			high = mid - 1;
		} else {
			low = mid + 1;
		}
	}
	return ans;
}


int find_R(int n, double q, function<double(int)> f)
{
	int low = 0,
		high = n - 1,
		ans = -1;
	while (low <= high) {
		int mid = low + (high - low) / 2;
		if (f(mid) <= q) {
			ans = mid;
			low = mid + 1;
		} else {
			high = mid - 1;
		}
	}
	return ans;
}


int customSearch(const vector<double>& A, double q, double delta, function<double(int)> f, int& comps, bool verbose = false)
{
	int n = A.size();
	
	int L = find_L(n, q, delta, f);
	int R = find_R(n, q, f);
	
	if (verbose) {
		cout << "Matematycznie zawezono przedzial do indeksow: [" << L << ", " << R << "]\n";
	}

	if (L > R)
		return -1;

	int low = L,
		high = R;
	while (low <= high) {
		int mid = low + (high - low) / 2;
		comps++;
		if (A[mid] == q) {
			if (verbose)
				cout << "Zakonczono na indeksie: " << mid << " -> TAK\n";
			return
				mid;
		}
		comps++;
		if (A[mid] < q)
			low = mid + 1;
		else
			high = mid - 1;
	}
	
	if (verbose)
		cout << "Zakonczono wyszukiwanie (pusty przedzial) -> NIE\n";
	return
		-1;
}


void runtest() {
	int n = 15;
	double delta1 = 10.0;
	vector<double> A(n);
	uniform_real_distribution<double> dist(0.0, 1.0);

	for (int i = 0; i < n; i++) {
		A[i] = f1(i) + dist(rng) * delta1;
	}
	sort(A.begin(), A.end());

	cout << "=== PREZENTACJA DLA MALYCH DANYCH (f1) ===\nTablica A:\n";
	for (int i = 0; i < n; i++)
		cout << i << ": " << fixed << setprecision(2) << A[i] << "\n";
	
	double q1 = A[7];
	cout << "\nSzukam q = " << q1 << " (istnieje)\n";
	int c1 = 0;
	customSearch(A, q1, delta1, f1, c1, true);
	
	double q2 = 100.0;
	cout << "\nSzukam q = " << q2 << " (nie istnieje)\n";
	int c2 = 0;
	customSearch(A, q2, delta1, f1, c2, true);
	cout << "==========================================\n\n";
}


int main() {
	runtest();

	ofstream file("wyniki_z4.csv");
	file << "n,func_type,algo,comparisons\n";

	uniform_real_distribution<double> dist(0.0, 1.0);
	
	int m = 30;

	cout << "Generowanie danych.\n";

	for (int n = 1000; n <= 300000; n += 5000) {
		if (n % 50000 == 0)
			cout << "Przetwarzam n = " << n << "\n";
		
		vector<double> A1(n), A2(n);
		double delta1 = 10.0, delta2 = 50.0;
		
		for (int i = 0; i < n; i++) {
			A1[i] = f1(i) + dist(rng) * delta1;
			A2[i] = f2(i) + dist(rng) * delta2;
		}
		sort(A1.begin(), A1.end());
		sort(A2.begin(), A2.end());

		long long c_std_1 = 0, c_cus_1 = 0;
		long long c_std_2 = 0, c_cus_2 = 0;

		uniform_int_distribution<int> idx_dist(0, n - 1);

		for (int rep = 0; rep < m; rep++) {
			double q1 = A1[idx_dist(rng)];
			double q2 = A2[idx_dist(rng)];

			int dummy;
			
			int c1 = 0;
			standardBinarySearch(A1, q1, c1);
			c_std_1 += c1;
			int c2 = 0;
			customSearch(A1, q1, delta1, f1, c2);
			c_cus_1 += c2;

			int c3 = 0;
			standardBinarySearch(A2, q2, c3);
			c_std_2 += c3;
			int c4 = 0;
			customSearch(A2, q2, delta2, f2, c4);
			c_cus_2 += c4;
		}

		file << n << ",f1,Standard," << (c_std_1 / m) << "\n";
		file << n << ",f1,Custom," << (c_cus_1 / m) << "\n";
		file << n << ",f2,Standard," << (c_std_2 / m) << "\n";
		file << n << ",f2,Custom," << (c_cus_2 / m) << "\n";
	}

	file.close();
	cout << "Zakonczono! Wyniki zapisane w 'wyniki_z4.csv'.\n";
	return 0;
}
