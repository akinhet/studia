#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

typedef struct {
	int *buffer;
	int size;
	int head;
	int tail;
	int count;
	int total_to_produce;
	int produced_so_far;
	int consumed_so_far;
	pthread_mutex_t mutex;
	sem_t empty;
	sem_t full;
} thread_data_t;


void put_item(thread_data_t *data, int item) {
	pthread_mutex_lock(&data->mutex);
	data->buffer[data->head] = item;
	data->head = (data->head + 1) % data->size;
	data->count++;
	printf("[Producent] Wstawiono: %d (Bufor: %d/%d)\n", item, data->count, data->size);
	pthread_mutex_unlock(&data->mutex);
}


int get_item(thread_data_t *data) {
	pthread_mutex_lock(&data->mutex);
	int item = data->buffer[data->tail];
	data->tail = (data->tail + 1) % data->size;
	data->count--;
	printf("[Konsument] Pobrano:   %d (Bufor: %d/%d)\n", item, data->count, data->size);
	pthread_mutex_unlock(&data->mutex);
	return item;
}


void* producer(void* arg) {
	thread_data_t *data = (thread_data_t*)arg;
	while (1) {
		int item;

		pthread_mutex_lock(&data->mutex);
		if (data->produced_so_far >= data->total_to_produce) {
			pthread_mutex_unlock(&data->mutex);
			break;
		}
		item = ++data->produced_so_far;
		pthread_mutex_unlock(&data->mutex);

		sem_wait(&data->empty);
		put_item(data, item);
		sem_post(&data->full);
		
		usleep(rand() % 100000);
	}
	return NULL;
}


void* consumer(void* arg) {
	thread_data_t *data = (thread_data_t*)arg;
	while (1) {

		pthread_mutex_lock(&data->mutex);
		if (data->consumed_so_far >= data->total_to_produce) {
			pthread_mutex_unlock(&data->mutex);
			break;
		}
		data->consumed_so_far++;
		pthread_mutex_unlock(&data->mutex);

		sem_wait(&data->full);
		get_item(data);
		sem_post(&data->empty);
		
		usleep(rand() % 150000);
	}
	return NULL;
}


int main(int argc, char *argv[]) {
	if (argc != 3) {
		fprintf(stderr, "Użycie: %s <Liczba_M> <Rozmiar_N>\n", argv[0]);
		return 1;
	}

	int M = atoi(argv[1]);
	int N = atoi(argv[2]);

	thread_data_t data;
	data.buffer = malloc(N * sizeof(int));
	data.size = N;
	data.head = 0;
	data.tail = 0;
	data.count = 0;
	data.total_to_produce = M;
	data.produced_so_far = 0;
	data.consumed_so_far = 0;


	pthread_mutex_init(&data.mutex, NULL);
	sem_init(&data.empty, 0, N);
	sem_init(&data.full, 0, 0);

	pthread_t prod[2], cons[2];


	pthread_create(&prod[0], NULL, producer, &data);
	pthread_create(&prod[1], NULL, producer, &data);
	pthread_create(&cons[0], NULL, consumer, &data);
	pthread_create(&cons[1], NULL, consumer, &data);


	pthread_join(prod[0], NULL);
	pthread_join(prod[1], NULL);
	pthread_join(cons[0], NULL);
	pthread_join(cons[1], NULL);

	printf("Przetwarzanie zakończone pomyślnie.\n");


	free(data.buffer);
	pthread_mutex_destroy(&data.mutex);
	sem_destroy(&data.empty);
	sem_destroy(&data.full);

	return 0;
}
