#ifndef __ADA_GCD_LIB_H
#define __ADA_GCD_LIB_H

#include <stdint.h>

typedef struct {
    uint32_t x, y;
} diophantes_result;

extern uint32_t gcd(uint32_t a, uint32_t b);
extern uint32_t smallest_prime_factor(uint32_t n);
extern uint32_t euler_totient(uint32_t n);
extern diophantes_result diophantes(uint32_t a, uint32_t b, uint32_t c);

#endif //__ADA_GCD_LIB_H
