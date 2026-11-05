package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

const (
	NumPhilosphers = 10
	TargetEaten    = 10
)

type Fork struct {
	sync.Mutex
	ID int
}

type Philosopher struct {
	ID        int
	LeftFork  *Fork
	RightFork *Fork
	Eaten     int
	Failed    int
}

func (f *Philosopher) Run(wg *sync.WaitGroup) {
	defer wg.Done()

	for f.Eaten < TargetEaten {
		fmt.Printf("[Filozof %d] Myśli...\n", f.ID)
		time.Sleep(time.Duration(rand.Intn(150)+50) * time.Millisecond)

		fmt.Printf("[Filozof %d] Chce zjeść posiłek nr %d\n", f.ID, f.Eaten+1)

		f.LeftFork.Lock()

		if f.RightFork.TryLock() {
			fmt.Printf("--> [Filozof %d] JEST! Używa widelców %d i %d\n", f.ID, f.LeftFork.ID, f.RightFork.ID)

			time.Sleep(time.Duration(rand.Intn(150)+50) * time.Millisecond)
			f.Eaten++

			f.RightFork.Unlock()
			f.LeftFork.Unlock()
		} else {
			f.LeftFork.Unlock()
			f.Failed++
			fmt.Printf("X [Filozof %d] Nie udało się (widelec %d zajęty). Rezygnuje i spróbuje później.\n", f.ID, f.RightFork.ID)

			time.Sleep(time.Duration(rand.Intn(30)+10) * time.Millisecond)
		}
	}
	fmt.Printf("[Filozof %d] Sfinalizował ucztę! Zjadł %d posiłków.\n", f.ID, f.Eaten)
}

func main() {
	var wg sync.WaitGroup

	forks := make([]*Fork, NumPhilosphers)
	for i := range NumPhilosphers {
		forks[i] = &Fork{ID: i}
	}

	philosophers := make([]*Philosopher, NumPhilosphers)
	for i := range NumPhilosphers {
		philosophers[i] = &Philosopher{
			ID:        i,
			LeftFork:  forks[i],
			RightFork: forks[(i+1)%NumPhilosphers],
		}
	}

	fmt.Printf("START (Filozofowie: %d, Posiłki: %d)\n", NumPhilosphers, TargetEaten)

	for i := range NumPhilosphers {
		wg.Add(1)
		go philosophers[i].Run(&wg)
	}

	wg.Wait()

	fmt.Println("\nKONIEC")
	for _, f := range philosophers {
		fmt.Printf("Filozof %d: %d nieudanych prób zjedzenia obiadu.\n", f.ID, f.Failed)
	}
}
