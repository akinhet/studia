#include "pico/stdlib.h"
#include "hardware/pio.h"
#include "ws2812.pio.h" // Ten plik wygeneruje się sam podczas kompilacji

#define IS_RGBW false
#define NUM_PIXELS 3
#define PIN_TX 4 // Tu podłącz pin DATA diody (np. GP0)

static inline void put_pixel(uint32_t pixel_grb) {
    pio_sm_put_blocking(pio0, 0, pixel_grb << 8u);
}

int main() {
    // Inicjalizacja PIO
    PIO pio = pio0;
    uint offset = pio_add_program(pio, &ws2812_program);
    ws2812_program_init(pio, 0, offset, PIN_TX, 800000, IS_RGBW);

	unsigned int color = 0;
    while (true) {
        // Kolor Czerwony w formacie GRB: 0x00FF00
        // (G=00, R=FF, B=00)
		for(int i=0;i<120;i++){
			// put_pixel(0xFF0000 | color << 8);
			put_pixel(0xFFFFFF);
		}

		color++;
		color = color % 0xFF;
        sleep_ms(10);
    }
}
