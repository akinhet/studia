// gcc -lpthread -lrt -o prod zad2prod.c
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
	int shm_fd = shm_open(SHM_NAME, O_CREAT | O_RDWR, 0666);
	ftruncate(shm_fd, sizeof(int));
	int *ptr = mmap(0, sizeof(int), PROT_WRITE, MAP_SHARED, shm_fd, 0);

	sem_t *empty = sem_open(SEM_EMPTY, O_CREAT, 0666, 1);
	sem_t *full = sem_open(SEM_FULL, O_CREAT, 0666, 0);

	for (int i = 1; i <= 10; i++) {
		sem_wait(empty);
		*ptr = i;
		printf("Producent: Zapisałem %d\n", i);
		sem_post(full);
		// sleep(1);
	}

	munmap(ptr, sizeof(int));
	close(shm_fd);
	sem_close(empty);
	sem_close(full);

	return 0;
}
