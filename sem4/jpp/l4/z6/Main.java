import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.SynchronousQueue;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;

public class Main {
    public static final int TO_SEND = 10;
    public static final int NUM_CLIENTS = 10;

    static class Client implements Runnable {
        int id;
        BlockingQueue<Integer> in = new SynchronousQueue<>();
        BlockingQueue<Integer> out;
        AtomicBoolean close;
        AtomicInteger activeSenders;
        AtomicInteger failed = new AtomicInteger(0);
        int sent = 0;

        @Override
        public void run() {
            Random rand = new Random();

            while (!close.get()) {
                if (sent < TO_SEND) {
                    int receiver = rand.nextInt(NUM_CLIENTS);
                    long sendTimeout = rand.nextInt(10) + 10;

                    try {
                        if (out.offer(receiver, sendTimeout, TimeUnit.MILLISECONDS)) {
                            System.out.printf("[%d]: sending message to %d\n", id, receiver);
                            sent++;
                            if (sent == TO_SEND) {
                                activeSenders.decrementAndGet();
                            }
                        } else {
                            failed.incrementAndGet();
                        }
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                        return;
                    }
                }

                long recvTimeout = rand.nextInt(50) + 50;
                try {
                    Integer msg = in.poll(recvTimeout, TimeUnit.MILLISECONDS);
                    if (msg != null) {
                        System.out.printf("[%d]: received message: %d\n", id, msg);
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    return;
                }
            }
        }
    }

    static class Server {
        List<Client> clients = new CopyOnWriteArrayList<>();
        BlockingQueue<Integer> in = new SynchronousQueue<>();
        AtomicBoolean close = new AtomicBoolean(false);
        AtomicInteger activeSenders = new AtomicInteger(0);

        public Client register() {
            Client newc = new Client();
            if (TO_SEND > 0) {
                activeSenders.incrementAndGet();
            }

            newc.id = clients.size();
            newc.out = this.in;
            newc.close = this.close;
            newc.activeSenders = this.activeSenders;
            clients.add(newc);

            return newc;
        }

        public void start() {
            List<Thread> threads = new ArrayList<>();
            for (Client client : clients) {
                Thread t = new Thread(client);
                threads.add(t);
                t.start();
            }

            while (true) {
                try {
                    Integer receiverId = in.poll(5, TimeUnit.MILLISECONDS);

                    if (receiverId != null) {
                        if (receiverId >= 0 && receiverId < clients.size()) {
                            clients.get(receiverId).in.put(123);
                        }
                    } else {
                        if (activeSenders.get() == 0) {
                            close.set(true);
                            break;
                        }
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break;
                }
            }

            for (Thread t : threads) {
                try {
                    t.join();
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            }
        }
    }

    public static void main(String[] args) {
        Server s = new Server();

        for (int i = 0; i < NUM_CLIENTS; i++) {
            s.register();
        }

        s.start();

        for (Client c : s.clients) {
            System.out.printf("[%d] failed %d times\n", c.id, c.failed.get());
        }
    }
}
