mod lib; 

fn main() {
    let a = 48;
    let b = 18;

    unsafe {
        let nwd = lib::gcd(a, b);
        println!("NWD({}, {}) wyliczone w Adzie: {}", a, b, nwd);

        let res = lib::diophantes(3, 5, 19);
        println!("Równanie diofantyczne: x={}, y={}", res.x, res.y);
    }
}
