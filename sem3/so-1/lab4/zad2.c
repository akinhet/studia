#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

volatile int count = 0;

void handler(int signum) {
	count++;
}

int main() {
	pid_t pid = fork();

	if (pid == 0) {
		struct sigaction sa;
		sa.sa_handler = handler;
		sa.sa_flags = 0;
		sigemptyset(&sa.sa_mask);
		sigaction(SIGUSR1, &sa, NULL);

		sigset_t mask, oldmask;
		sigemptyset(&mask);
		sigaddset(&mask, SIGUSR1);
		
		printf("[Child] Blokuję SIGUSR1...\n");
		sigprocmask(SIG_BLOCK, &mask, &oldmask);

		sleep(2);

		printf("[Child] Odblokowuję SIGUSR1...\n");
		sigprocmask(SIG_SETMASK, &oldmask, NULL);

		sleep(1);
		printf("[Child] Otrzymano sygnałów: %d (oczekiwano > 1, gdyby były kolejkowane)\n", count);
		exit(0);

	} else {
		sleep(1);
		printf("[Parent] Wysyłam 1000 razy SIGUSR1 do dziecka...\n");
		for (int i = 0; i < 1000; i++) {
			kill(pid, SIGUSR1);
		}
		printf("[Parent] Wysłano.\n");
		wait(NULL);
	}

	return 0;
}
