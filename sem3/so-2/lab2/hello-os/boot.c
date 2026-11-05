// boot.c

void main() {
	char *video_memory = (char*) 0xB8000;
	const char *message = "Hello, World!";

	for (unsigned int color = 0x0; color <= 0x7F; color++)
		for (int i = 0; message[i] != '\0'; i++) {
			video_memory[i * 2 + color * 26 + (color / 6) * 4] = message[i];
			video_memory[i * 2 + color * 26 + (color / 6) * 4 + 1] = color;
		}

	while(1);
}
