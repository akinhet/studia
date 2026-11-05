#include <iostream>
#include <string>
#include <stdexcept>

class ArabRzymException : public std::exception {
public:
    explicit ArabRzymException(const std::string& message) : msg(message) {}
    
    const char* what() const noexcept override {
        return msg.c_str();
    }
    
private:
    std::string msg;
};

class ArabRzym {
private:
    static const std::string liczby;
    static const int wartosci[7];

public:
    static int rzym2arab(const std::string& r) {
        int ret = 0, previdx = 0, maxidx = 0;

        if (r.find("IIII") != std::string::npos || r.find("VV") != std::string::npos || 
            r.find("XXXX") != std::string::npos || r.find("LL") != std::string::npos ||
            r.find("CCCC") != std::string::npos || r.find("DD") != std::string::npos || 
            r.find("MMMM") != std::string::npos) {
            throw ArabRzymException("Invalid repetition in roman numeral: " + r);
        }

        for (int i = r.length() - 1; i >= 0; --i) {
            int idx = liczby.find(r[i]);
            if (idx == std::string::npos) {
                throw ArabRzymException("Invalid char in roman numeral: " + std::string(1, r[i]));
            }
            int val = wartosci[idx];

            if (previdx < maxidx && idx < maxidx) {
                throw ArabRzymException("Invalid roman numeral: " + r);
            }

            if (previdx > idx) {
                if (previdx - idx <= 2 && (idx == 0 || idx == 2 || idx == 4)) {
                    ret -= val;
                } else {
                    throw ArabRzymException("Invalid roman numeral: " + r);
                }
            } else {
                ret += val;
            }

            previdx = idx;
            maxidx = std::max(maxidx, idx);
        }

        return ret;
    }

    static std::string arab2rzym(int n) {
        if (n < 1 || n >= 4000) {
            throw ArabRzymException("liczba spoza zakresu");
        }

        int num = n;
        std::string ret = "";
        while (num > 0) {
            if (num >= 1000) {
                num -= 1000;
                ret += "M";
                continue;
            }
            if (num >= 900) {
                num -= 900;
                ret += "CM";
                continue;
            }
            if (num >= 500) {
                num -= 500;
                ret += "D";
                continue;
            }
            if (num >= 400) {
                num -= 400;
                ret += "CD";
                continue;
            }
            if (num >= 100) {
                num -= 100;
                ret += "C";
                continue;
            }
            if (num >= 90) {
                num -= 90;
                ret += "XC";
                continue;
            }
            if (num >= 50) {
                num -= 50;
                ret += "L";
                continue;
            }
            if (num >= 40) {
                num -= 40;
                ret += "XL";
                continue;
            }
            if (num >= 10) {
                num -= 10;
                ret += "X";
                continue;
            }
            if (num >= 9) {
                num -= 9;
                ret += "IX";
                continue;
            }
            if (num >= 5) {
                num -= 5;
                ret += "V";
                continue;
            }
            if (num >= 4) {
                num -= 4;
                ret += "IV";
                continue;
            }
            if (num >= 1) {
                num -= 1;
                ret += "I";
                continue;
            }
        }

        return ret;
    }
};

const std::string ArabRzym::liczby = "IVXLCDM";
const int ArabRzym::wartosci[7] = {1, 5, 10, 50, 100, 500, 1000};

int main(int argc, char* argv[]) {
    if (argc < 2) {
        return 0;
    }

    if (std::string(argv[1]) == "r2a") {
        for (int i = 2; i < argc; ++i) {
            try {
                std::cout << ArabRzym::rzym2arab(argv[i]) << std::endl;
            } catch (const ArabRzymException& ex) {
                std::cout << ex.what() << std::endl;
            }
        }
    } else if (std::string(argv[1]) == "a2r") {
        for (int i = 2; i < argc; ++i) {
            try {
                std::cout << ArabRzym::arab2rzym(std::stoi(argv[i])) << std::endl;
            } catch (const ArabRzymException& ex) {
                std::cout << ex.what() << std::endl;
            }
        }
    } else {
        std::cout << "Invalid argument: " << argv[1] << std::endl;
        return 0;
    }

    return 0;
}
