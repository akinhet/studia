import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.locks.ReentrantLock;

public class Main {

    private static final int NUM_PHILOSOPHERS = 10;
    private static final int TARGET_EATEN = 10;


    static class Fork {
        final ReentrantLock lock = new ReentrantLock();
        final int id;

        Fork(int id) {
            this.id = id;
        }
    }


    static class Philosopher implements Runnable {
        private final int id;
        private final Fork leftFork;
        private final Fork rightFork;
        private final CountDownLatch latch;
        private int eaten = 0;
        private int failed = 0;

        Philosopher(int id, Fork leftFork, Fork rightFork, CountDownLatch latch) {
            this.id = id;
            this.leftFork = leftFork;
            this.rightFork = rightFork;
            this.latch = latch;
        }

        public int getFailed() {
            return failed;
        }

        @Override
        public void run() {
            try {
                while (eaten < TARGET_EATEN) {
                    System.out.printf("[Filozof %d] Myśli...\n", id);
                    Thread.sleep(ThreadLocalRandom.current().nextInt(150) + 50);

                    System.out.printf("[Filozof %d] Chce zjeść posiłek nr %d\n", id, eaten + 1);


                    leftFork.lock.lock();


                    if (rightFork.lock.tryLock()) {
                        try {
                            System.out.printf("--> [Filozof %d] JEST! Używa widelców %d i %d\n", id, leftFork.id, rightFork.id);

                            Thread.sleep(ThreadLocalRandom.current().nextInt(150) + 50);
                            eaten++;
                        } finally {

                            rightFork.lock.unlock();
                            leftFork.lock.unlock();
                        }
                    } else {

                        leftFork.lock.unlock();
                        failed++;
                        System.out.printf("X [Filozof %d] Nie udało się (widelec %d zajęty). Rezygnuje i spróbuje później.\n", id, rightFork.id);

                        Thread.sleep(ThreadLocalRandom.current().nextInt(30) + 10);
                    }
                }
                System.out.printf("[Filozof %d] Sfinalizował ucztę! Zjadł %d posiłków.\n", id, eaten);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            } finally {

                latch.countDown();
            }
        }
    }

    public static void main(String[] args) throws InterruptedException {
        CountDownLatch latch = new CountDownLatch(NUM_PHILOSOPHERS);

        Fork[] forks = new Fork[NUM_PHILOSOPHERS];
        for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
            forks[i] = new Fork(i);
        }

        Philosopher[] philosophers = new Philosopher[NUM_PHILOSOPHERS];
        Thread[] threads = new Thread[NUM_PHILOSOPHERS];

        for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
            philosophers[i] = new Philosopher(
                    i,
                    forks[i],
                    forks[(i + 1) % NUM_PHILOSOPHERS],
                    latch
            );
            threads[i] = new Thread(philosophers[i]);
        }

        System.out.printf("START (Filozofowie: %d, Posiłki: %d)\n", NUM_PHILOSOPHERS, TARGET_EATEN);


        for (Thread thread : threads) {
            thread.start();
        }


        latch.await();

        System.out.println("\nKONIEC");
        for (Philosopher f : philosophers) {
            System.out.printf("Filozof %d: %d nieudanych prób zjedzenia obiadu.\n", f.id, f.getFailed());
        }
    }
}
