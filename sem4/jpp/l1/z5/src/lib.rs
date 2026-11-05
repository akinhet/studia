use std::os::raw::c_uint;

#[repr(C)]
#[derive(Debug, Clone, Copy)]
pub struct DiophantesResult {
    pub x: u32,
    pub y: u32,
}

#[link(name = "gcdlib", kind = "static")]
#[link(name = "gnat", kind = "dylib")]
extern "C" {
    pub fn gcd(a: u32, b: u32) -> u32;
    pub fn smallest_prime_factor(n: u32) -> u32;
    pub fn euler_totient(n: u32) -> u32;
    pub fn diophantes(a: u32, b: u32, c: u32) -> DiophantesResult;
}
