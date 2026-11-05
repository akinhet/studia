use std::os::raw::c_uint;

#[repr(C)]
pub struct DiophantesResult {
    pub x: u32,
    pub y: u32,
}

#[repr(C)]
struct EgcdResult {
    x: i64,
    y: i64,
    c: i64,
}

fn egcd(a: i64, b: i64) -> EgcdResult {
    let (mut prevx, mut x) = (1, 0);
    let (mut prevy, mut y) = (0, 1);
    let (mut a1, mut b1) = (a, b);

    while b1 > 0 {
        let q = a1 / b1;

        let tmp_x = x;
        x = prevx - q * x;
        prevx = tmp_x;

        let tmp_y = y;
        y = prevy - q * y;
        prevy = tmp_y;

        let tmp_b1 = b1;
        b1 = a1 % b1;
        a1 = tmp_b1;
    }

    EgcdResult { x: prevx, y: prevy, c: a1 }
}

#[no_mangle]
pub extern "C" fn gcd(a: u32, b: u32) -> u32 {
    egcd(a as i64, b as i64).c as u32
}

#[no_mangle]
pub extern "C" fn smallest_prime_factor(n: u32) -> u32 {
    if n % 2 == 0 {
        return 2;
    }

    let mut i = 3;
    while i * i <= n {
        if n % i == 0 {
            return i;
        }
        i += 2;
    }

    n
}

#[no_mangle]
pub extern "C" fn euler_totient(mut n: u32) -> u32 {
    let mut res = n;
    let mut i = 2;
    
    while i * i <= n {
        if n % i == 0 {
            while n % i == 0 {
                n /= i;
            }
            res -= res / i;
        }
        i += 1;
    }

    if n > 1 {
        res -= res / n;
    }
    res
}

#[no_mangle]
pub extern "C" fn diophantes(a: u32, b: u32, c: u32) -> DiophantesResult {
    let res_egcd = egcd(a as i64, b as i64);

    if (c as i64) % res_egcd.c != 0 {
        return DiophantesResult { x: 0, y: 0 };
    }

    let mul = (c as i64) / res_egcd.c;
    let mut x = res_egcd.x * mul;

    let stepx = (b as i64) / res_egcd.c;
    let stepy = (a as i64) / res_egcd.c;

    x %= stepx;

    let mut y = (a as i64 * x - c as i64) / b as i64;

    if y < 0 {
        y += stepy;
        x = (b as i64 * y + c as i64) / a as i64;
    }

    DiophantesResult {
        x: x as u32,
        y: y as u32,
    }
}
