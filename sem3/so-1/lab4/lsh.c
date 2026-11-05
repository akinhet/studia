#include <ctype.h>
#include <signal.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>

#include <readline/readline.h>
#include <readline/history.h>

#define PROMPT "> "

typedef struct {
	char **comms;

	size_t *comm_idxs,
		   comm_num;

	char *in,
		 *out,
		 *err;

	bool bg;
} pipe_t;


void signal_handler(int sig)
{
	switch (sig) {
		case SIGINT:
			printf("\n");
			break;
		case SIGCHLD:
			while (waitpid(-1, NULL, WNOHANG) > 0);
			break;
		default:
			break;
	}
}


int cd(char **args)
{
	if (args[1] == NULL) {
		char *home = getenv("HOME");
		
		if (home == NULL)
			return 1;

		if (chdir(home)) {
			perror("cd");
			return 1;
		}

		return 0;
	}

	if (args[2] != NULL) {
		fprintf(stderr, "cd: too many arguments\n");
		return 1;
	}

	if (chdir(args[1])) {
		perror("cd");
		return 1;
	}

	return 0;
}


int history(char **args) {
	HIST_ENTRY **the_list = history_list();

	if (the_list) {
		for (int i = 0; the_list[i]; i++) {
			printf("%5d  %s\n", i + history_base, the_list[i]->line);
		}
	}
	return 0;
}


void trim(char *s)
{
	size_t begin = 0,
		   end = strlen(s) - 1;

	if (end == -1)
		return;

	while (begin < end && isspace((unsigned char) s[begin]))
		begin++;

	while (end > begin && isspace((unsigned char) s[end]))
		end--;

	memmove(s, s + begin, end - begin + 1);
	s[end - begin + 1] = 0;
}


pipe_t parse(char *input) {
	pipe_t p = {0};

	size_t ci = 0,
		   pi = 0,
		   bufsize = 16;

	p.comms = calloc(bufsize, sizeof(char *));
	p.comm_idxs = calloc(bufsize, sizeof(size_t));

	p.comm_idxs[0] = 0;

	char *tok = strtok(input, " \t\n");
	while (tok) {
		if (!strcmp(tok, "&")) {
			p.bg = true;
		} else if (!strcmp(tok, "<")) {
			tok = strtok(NULL, " \t\n");
			if (tok)
				p.in = strdup(tok);
		} else if (!strcmp(tok, ">")) {
			tok = strtok(NULL, " \t\n");
			if (tok)
				p.out = strdup(tok);
		} else if (!strcmp(tok, "2>")) {
			tok = strtok(NULL, " \t\n");
			if (tok)
				p.err = strdup(tok);
		} else if (!strcmp(tok, "|")) {
			p.comms[ci++] = NULL;
			p.comm_idxs[++pi] = ci;
		} else {
			p.comms[ci++] = strdup(tok);
		}

		if (ci >= bufsize) {
			bufsize += 16;
			p.comms = realloc(p.comms, sizeof(char *) * bufsize);
			p.comm_idxs = realloc(p.comm_idxs, sizeof(size_t) * bufsize);
			if (p.comms == NULL || p.comm_idxs == NULL) {
				fprintf(stderr, "ERROR: cannot allocate memory\n");
				exit(EXIT_FAILURE);
			}
		}

		tok = strtok(NULL, " \t\n");
	}

	p.comms[ci] = NULL;
	p.comm_num = pi + 1;

	return p;
}


void free_pipe(pipe_t *p)
{
	if (p->comms)
		for (int i = 0; p->comms[i]; i++)
			free(p->comms[i]);
	else
		return;

	free(p->comms);
	free(p->comm_idxs);
	free(p->in);
	free(p->out);
	free(p->err);
}


int run(pipe_t *p)
{
	int (*pipes)[2] = NULL;
	if (p->comm_num > 1)
		pipes = calloc(p->comm_num - 1, sizeof(int[2]));

	for (size_t i = 0; i < p->comm_num - 1; i++)
		pipe(pipes[i]);

	pid_t *pids = calloc(p->comm_num, sizeof(pid_t));

	if (!strcmp(p->comms[p->comm_idxs[0]], "cd"))
		return cd(&p->comms[p->comm_idxs[0]]);

	if (!strcmp(p->comms[p->comm_idxs[0]], "history"))
		return history(&p->comms[p->comm_idxs[0]]);

	for (int i = 0; i < p->comm_num; i++) {
		pid_t pid;

		pid = fork();
		if (pid == 0) {
			signal(SIGCHLD, SIG_DFL);
			signal(SIGINT, SIG_DFL);

			if (i == 0 && p->in != NULL) {
				int fd = open(p->in, O_RDONLY);
				dup2(fd, 0);
				close(fd);
			} else if (i > 0) {
				dup2(pipes[i-1][0], 0);
			}

			if (i == p->comm_num - 1 && p->out != NULL) {
				int fd = open(p->out, O_WRONLY | O_CREAT | O_TRUNC, 0666);
				dup2(fd, 1);
				close(fd);
			} else if (i < p->comm_num - 1) {
				dup2(pipes[i][1], 1);
			}

			if (i == p->comm_num - 1 && p->err != NULL) {
				int fd = open(p->err, O_WRONLY | O_CREAT | O_TRUNC, 0666);
				dup2(fd, 2);
				close(fd);
			}

			for (size_t j = 0; j < p->comm_num - 1; j++) {
				close(pipes[j][0]);
				close(pipes[j][1]);
			}

			if (execvp(p->comms[p->comm_idxs[i]], &p->comms[p->comm_idxs[i]]) == -1)
				perror(p->comms[p->comm_idxs[i]]);
			exit(EXIT_FAILURE);
		} else if (pid < 0) {
			perror("shell");
		} else {
			pids[i] = pid;
		}
	}

	if (p->comm_num > 1) {
		for (size_t j = 0; j < p->comm_num - 1; j++) {
			close(pipes[j][0]);
			close(pipes[j][1]);
		}
		free(pipes);
	}


	if (!p->bg)
		for (int i = 0; i < p->comm_num; i++) {
			int status;
			do {
				pid_t wpid = waitpid(pids[i], &status, WUNTRACED);
			} while (!WIFEXITED(status) && !WIFSIGNALED(status));
		}

	return 1;
}


int main(int argc, const char *argv[])
{
	char *line = NULL;

	using_history();

	signal(SIGINT, signal_handler);
	signal(SIGCHLD, signal_handler);

	while(1) {
		line = readline(PROMPT);
		if (line == NULL) {
			free(line);
			return 0;
		}
		trim(line);
		add_history(line);

		if (!strlen(line)) {
			free(line);
			continue;
		}
		if (!strcmp(line, "exit")) {
			free(line);
			return 0;
		}
		
		pipe_t pipe = parse(line);
		run(&pipe);

		free_pipe(&pipe);

		free(line);
	}

	return 0;
}
