#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void) {
  int pipefd[2];
  pipe(pipefd);

  pid_t pid = fork();

  if (pid == 0) {
    close(pipefd[0]);
    dup2(pipefd[1], STDOUT_FILENO);
    close(pipefd[1]);

    char *args[] = {"tput", "colors", NULL};
    execvp(args[0], args);

    perror("execvp failed");
    exit(1);
  } else {
    close(pipefd[1]);

    char buffer[1024];
    ssize_t n;
	FILE *exec_out = fdopen(pipefd[0], "r");
	fgets(buffer, 1024, exec_out);
    // while ((n = read(pipefd[0], buffer, sizeof(buffer) - 1)) > 0) {
    //   buffer[n] = '\0';
    // }
	fclose(exec_out);
    close(pipefd[0]);

    int num = atoi(buffer);

    for (int i = 0; i < num; i++) {
      /*printf("\e[38;5;%dmHello World\e[0m\n", i);*/
      printf("\e[38;5;%dmHello World\n", i);
    }
  }

  return 0;
}
