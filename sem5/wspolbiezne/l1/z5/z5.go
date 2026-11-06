package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
	"unicode"
)

const (
	NrOfTravelers = 15

	MinSteps = 10
	MaxSteps = 100

	MinDelay = 10 * time.Millisecond
	MaxDelay = 50 * time.Millisecond

	BoardWidth  = 15
	BoardHeight = 15

	Timeout = MaxDelay * 2
)

var startTime = time.Now()

type Position struct {
	X, Y int
}

var Board [BoardWidth][BoardHeight]chan struct{}

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

func makeStep(t *Traveler, choice int) bool {
	x, y := t.Position.X, t.Position.Y
	switch choice {
	case 0: // up
		y = (t.Position.Y + 1) % BoardHeight
	case 1: // down
		y = (t.Position.Y + BoardHeight - 1) % BoardHeight
	case 2: // left
		x = (t.Position.X + 1) % BoardWidth
	case 3: // right
		x = (t.Position.X + BoardWidth - 1) % BoardWidth
	}

	select {
	case Board[x][y] <- struct{}{}:
		<- Board[t.Position.X][t.Position.Y]
		t.Position.X = x
		t.Position.Y = y
	case <- time.After(Timeout):
		return false
	}

	return true
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
			X: id,
			Y: id,
		},
	}
	Board[id][id] <- struct{}{}

	choice := rng.Intn(2)
	if id % 2 != 0 {
		choice += 2
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

		if !makeStep(&traveler, choice) {
			traveler.Symbol = unicode.ToLower(traveler.Symbol)
			storeTrace()
			reports <- traces
			return
		}
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

	for i := range(BoardWidth) {
		for j := range(BoardHeight) {
			Board[i][j] = make(chan struct{}, 1)
		}
	}

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
