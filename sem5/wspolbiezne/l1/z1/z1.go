package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

const (
	NrOfTravelers = 15

	MinSteps = 10
	MaxSteps = 100

	MinDelay = 10 * time.Millisecond
	MaxDelay = 50 * time.Millisecond

	BoardWidth  = 15
	BoardHeight = 15
)

var startTime = time.Now()

type Position struct {
	X, Y int
}

// func moveDown(p *Position) {
// 	p.Y = (p.Y + 1) % BoardHeight
// }
//
// func moveUp(p *Position) {
// 	p.Y = (p.Y + BoardHeight - 1) % BoardHeight
// }
//
// func moveRight(p *Position) {
// 	p.X = (p.X + 1) % BoardWidth
// }
//
// func moveLeft(p *Position) {
// 	p.X = (p.X + BoardWidth - 1) % BoardWidth
// }

type Trace struct {
	TimeStamp time.Duration
	ID        int
	Position  Position
	Symbol    rune
}

type TracesSequence struct {
	Traces []Trace
}

func printTrace(t Trace) {
	fmt.Printf(
		"%.9f %d %d %d %c\n",
		t.TimeStamp.Seconds(),
		t.ID,
		t.Position.X,
		t.Position.Y,
		t.Symbol,
	)
}

func printTraces(ts TracesSequence) {
	for _, trace := range ts.Traces {
		printTrace(trace)
	}
}

// Printer receives traces from travelers and prints them.
func printer(reports <-chan TracesSequence, done *sync.WaitGroup) {
	defer done.Done()

	for traces := range reports {
		printTraces(traces)
	}
}

type Traveler struct {
	ID       int
	Symbol   rune
	Position Position
}

func makeStep(t *Traveler, rng *rand.Rand) {
	switch rng.Intn(4) {
	case 0:
		// moveUp(&t.Position)
		t.Position.Y = (t.Position.Y + 1) % BoardHeight
	case 1:
		// moveDown(&t.Position)
		t.Position.Y = (t.Position.Y + BoardHeight - 1) % BoardHeight
	case 2:
		// moveLeft(&t.Position)
		t.Position.X = (t.Position.X + 1) % BoardWidth
	case 3:
		// moveRight(&t.Position)
		t.Position.X = (t.Position.X + BoardWidth - 1) % BoardWidth
	}
}

func travelerTask(
	id int,
	seed int64,
	symbol rune,
	start <-chan struct{},
	reports chan<- TracesSequence,
	wg *sync.WaitGroup,
) {
	defer wg.Done()

	rng := rand.New(rand.NewSource(seed))

	traveler := Traveler{
		ID:     id,
		Symbol: symbol,
		Position: Position{
			X: rng.Intn(BoardWidth),
			Y: rng.Intn(BoardHeight),
		},
	}

	traces := TracesSequence{
		Traces: make([]Trace, 0, MaxSteps+2),
	}

	timeStamp := time.Duration(0)

	storeTrace := func() {
		traces.Traces = append(traces.Traces, Trace{
			TimeStamp: timeStamp,
			ID:        traveler.ID,
			Position:  traveler.Position,
			Symbol:    traveler.Symbol,
		})
	}

	// Store initial position.
	storeTrace()

	nrOfSteps := MinSteps + rng.Intn(MaxSteps-MinSteps)
	timeStamp = time.Since(startTime)

	// Wait until all travelers are initialized.
	<-start

	for step := 0; step <= nrOfSteps; step++ {
		delay := MinDelay + time.Duration(
			rng.Float64()*float64(MaxDelay-MinDelay),
		)

		time.Sleep(delay)

		makeStep(&traveler, rng)
		storeTrace()

		timeStamp = time.Since(startTime)
	}

	reports <- traces
}

func main() {
	fmt.Printf(
		"-1 %d %d %d\n",
		NrOfTravelers,
		BoardWidth,
		BoardHeight,
	)

	reports := make(chan TracesSequence)
	start := make(chan struct{})

	var travelersWG sync.WaitGroup
	var printerWG sync.WaitGroup

	printerWG.Add(1)
	go printer(reports, &printerWG)

	for i := 0; i < NrOfTravelers; i++ {
		travelersWG.Add(1)

		go travelerTask(
			i,
			time.Now().UnixNano()+int64(i),
			rune('A'+i),
			start,
			reports,
			&travelersWG,
		)
	}

	// Start all travelers.
	close(start)

	travelersWG.Wait()
	close(reports)

	printerWG.Wait()
}
