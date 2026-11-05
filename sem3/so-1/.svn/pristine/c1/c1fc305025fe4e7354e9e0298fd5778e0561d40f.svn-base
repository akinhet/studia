// gcc -lpthread -lrt -o cons zad2cons.c
#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <semaphore.h>

#define SHM_NAME "/my_shm"
#define SEM_EMPTY "/sem_empty"
#define SEM_FULL "/sem_full"


int main()
{
	int shm_fd = shm_open(SHM_NAME, O_RDWR, 0666);
	int *ptr = mmap(0, sizeof(int), PROT_READ, MAP_SHARED, shm_fd, 0);

	sem_t *empty = sem_open(SEM_EMPTY, 0);
	sem_t *full = sem_open(SEM_FULL, 0);

	for (int i = 1; i <= 10; i++) {
		sem_wait(full);
		printf("Konsument: Odczytałem %d\n", *ptr);
		sem_post(empty);
	}

	munmap(ptr, sizeof(int));
	close(shm_fd);
	shm_unlink(SHM_NAME);
	sem_close(empty);
	sem_close(full);
	sem_unlink(SEM_EMPTY);
	sem_unlink(SEM_FULL);

	return 0;
}
