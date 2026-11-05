#include "figury.h"
#include <iostream>
#include <vector>
#include <memory>
#include <string>
#include <stdexcept>

using namespace std;

int main(int argc, char* argv[]) {
    vector<unique_ptr<Figura>> figury;
    int i = 1;

    while (i < argc) {
        string arg = argv[i];
        try {
            if (arg == "o") {
                int r = stoi(argv[++i]);
                figury.push_back(make_unique<Kolo>(r));
            } else if (arg == "p") {
                int a = stoi(argv[++i]);
                figury.push_back(make_unique<Pieciokat>(a));
            } else if (arg == "s") {
                int a = stoi(argv[++i]);
                figury.push_back(make_unique<Szesciokat>(a));
            } else if (arg == "c") {
                vector<int> cargs;
                string tokens = "cops";
                while (++i < argc && tokens.find(argv[i]) == string::npos) {
                    cargs.push_back(stoi(argv[i]));
                }
                i--;

                if (cargs.size() == 2) {
                    if (cargs[1] == 90)
                        figury.push_back(make_unique<Kwadrat>(cargs[0]));
                    else
                        figury.push_back(make_unique<Romb>(cargs[0], cargs[1]));
                } else if (cargs.size() == 5) {
                    if (cargs[4] != 90) {
                        cerr << "ERROR: unsupported shape" << endl;
                        return 1;
                    }
                    figury.push_back(make_unique<Prostokat>(cargs[0], cargs[1], cargs[2], cargs[3]));
                } else {
                    cerr << "ERROR: illegal amount of arguments for Czworokat class: " << cargs.size() << endl;
                    return 1;
                }
            } else {
                cerr << "ERROR: illegal instruction: " << arg << endl;
                return 1;
            }
        } catch (invalid_argument&) {
            cerr << "ERROR: illegal argument to a shape: " << argv[i] << endl;
            return 1;
        } catch (exception& e) {
            cerr << "ERROR: " << e.what() << endl;
            return 1;
        }
        ++i;
    }

    for (const auto& f : figury) {
        cout << f->name() << " - Pole: " << f->pole() << " Obwód: " << f->obwod() << endl;
    }

    return 0;
}
