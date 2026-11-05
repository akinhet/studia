#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/time.h>

#define DEF_PORT 8888
#define MAX_CLIENTS 30
#define BUFFER_SIZE 1024
#define LOGIN_SIZE 1024

typedef struct {
	int fd;
	char buffer[BUFFER_SIZE],
	     login[LOGIN_SIZE];
	int len;
} client_t;


int find_login(client_t *clients, char *login)
{
	for (int i = 0; i < MAX_CLIENTS; i++) {
		if (clients[i].fd > 0 && clients[i].login[0] != '\0') {
			if (!strcmp(login, clients[i].login))
				return clients[i].fd;
		}
	}

	return 0;
}


int parse(client_t *clients, int client) {
	if (clients[client].login[0] == '\0') {
		if (clients[client].buffer[0] == '\0') {
			char *str = "Enter a valid login.\n";
			send(clients[client].fd, str, strlen(str), 0);
			return 0;
		}
		if (find_login(clients, clients[client].buffer)) {
			send(clients[client].fd, "This login is already taken, try a different one.\n", 51, 0);
			return 0;
		}

		strcpy(clients[client].login, clients[client].buffer);
		send(clients[client].fd, "Successfully registered\nConnected users:\n", 42, 0);
		for (int i = 0; i < MAX_CLIENTS; i++) {
			if (clients[i].fd > 0 && clients[i].login[0] != '\0') {
				send(clients[client].fd, clients[i].login, strlen(clients[i].login), 0);
				char str[16];
				sprintf(str, "\t%d\n", clients[i].fd);
				send(clients[client].fd, str, strlen(str), 0);
			}
		}
		return 0;
	}

	char *saveptr = NULL;
	char *tok = strtok_r(clients[client].buffer, " \t", &saveptr);
	if (tok == NULL) {
		return 0;
	} else if (!strcmp(tok, "QUIT") || !strcmp(tok, "quit")) {
		return 1;
	} else if (!strcmp(tok, "SEND") || !strcmp(tok, "send")) {
		tok = strtok_r(NULL, " \t", &saveptr);
		int target = find_login(clients, tok);
		if (!target) {
			char *str = "ERROR: Unknown user\n";
			send(clients[client].fd, str, strlen(str), 0);
			return 0;
		}

		send(target, "FROM ", 6, 0);
		send(target, clients[client].login, strlen(clients[client].login), 0);
		send(target, " ", 2, 0);
		send(target, saveptr, strlen(saveptr), 0);
		send(target, "\n", 2, 0);
	} else {
		char *str = "ERROR: Unknown command\n";
		send(clients[client].fd, str, strlen(str), 0);
	}

	return 0;
}


int main(int argc, char *argv[])
{
	int master_socket,
	    port = DEF_PORT;
	struct sockaddr_in address;

	client_t clients[MAX_CLIENTS];

	fd_set readfds;

	const char *message = "Hello. Enter your desired login\n";

	if (argc == 2) {
		port = atoi(argv[1]);
	}

	for (int i = 0; i < MAX_CLIENTS; i++) {
		clients[i].fd = 0;
		clients[i].len = 0;
		memset(clients[i].buffer, 0, BUFFER_SIZE);
		memset(clients[i].login, 0, BUFFER_SIZE);
	}

	if((master_socket = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
		perror("socket failed");
		exit(EXIT_FAILURE);
	}

	int opt = 1;
	if(setsockopt(master_socket, SOL_SOCKET, SO_REUSEADDR, (char *)&opt, sizeof(opt)) < 0) {
		perror("setsockopt");
		exit(EXIT_FAILURE);
	}

	address.sin_family = AF_INET;
	address.sin_addr.s_addr = INADDR_ANY;
	address.sin_port = htons(port);

	if (bind(master_socket, (struct sockaddr *)&address, sizeof(address)) < 0) {
		perror("bind failed");
		exit(EXIT_FAILURE);
	}
	printf("Listening on port %d \n", port);

	if (listen(master_socket, 3) < 0) {
		perror("listen");
		exit(EXIT_FAILURE);
	}
	printf("Waiting for connections...\n");

	while(1) {
		
		FD_ZERO(&readfds);
		FD_SET(master_socket, &readfds);
		int max_sd = master_socket,
		    sd = 0;

		for (int i = 0; i < MAX_CLIENTS ; i++) {
			sd = clients[i].fd;

			if(sd > 0)
				FD_SET(sd, &readfds);

			if(sd > max_sd)
				max_sd = sd;
		}

		
		int activity = select(max_sd + 1, &readfds, NULL, NULL, NULL);
		if ((activity < 0) && (errno != EINTR)) {
			printf("error in select");
		}

		if (FD_ISSET(master_socket, &readfds)) {
			int addrlen = sizeof(address),
			    new_socket;
			if ((new_socket = accept(master_socket, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0) {
				perror("accept");
				exit(EXIT_FAILURE);
			}

			if (send(new_socket, message, strlen(message), 0) != strlen(message)) {
				perror("send");
			}

			
			for (int i = 0; i < MAX_CLIENTS; i++) {
				if (clients[i].fd == 0) {
					clients[i].fd = new_socket;
					clients[i].len = 0;
					memset(clients[i].buffer, 0, BUFFER_SIZE);
					memset(clients[i].login, 0, LOGIN_SIZE);
					printf("client connected on fd %d\n", i);
					break;
				}
			}
		}

		for (int i = 0; i < MAX_CLIENTS; i++) {
			int sd = clients[i].fd;

			if (FD_ISSET(sd, &readfds)) {
				int valread = 0;
				
				if ((valread = read(sd, &clients[i].buffer[clients[i].len], BUFFER_SIZE - clients[i].len - 1)) == 0) {
					close(sd);
					clients[i].fd = 0;
				} else {
					clients[i].len += valread;
					clients[i].buffer[clients[i].len] = '\0';

					char *line;
					while ((line = strchr(clients[i].buffer, '\n')) != NULL) {
						*line = '\0';

						printf("received a msg: %s\n", clients[i].buffer);

						if (parse(clients, i)) {
							char *str = "Goodbye.\n";
							send(clients[i].fd, str, strlen(str), 0);
							close(clients[i].fd);
							clients[i].fd = 0;
						}

						clients[i].len = clients[i].len - (line - clients[i].buffer) - 1;
						memmove(clients[i].buffer, line + 1, clients[i].len);
						clients[i].buffer[clients[i].len] = '\0';
					}
				}
			}
		}
	}

	return 0;
}
