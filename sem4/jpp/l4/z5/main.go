package main

import (
	"fmt"
	"math/rand"
	"sync"
	"sync/atomic"
	"time"
)

const (
	ToSend     int = 10
	NumClients int = 10
)

type Client struct {
	ID      int
	In, out chan int
	close   *atomic.Bool
	sending chan bool
	failed  int
}

type Server struct {
	clients []*Client
	cMutex  sync.Mutex
	sending chan bool
	in      chan int
	close   atomic.Bool
}

func (c *Client) Run() {
	var sent int

	for !c.close.Load() {
		if sent < ToSend {
			send_timeout := make(chan bool, 1)
			receiver := rand.Intn(NumClients)

			go func() { time.Sleep(time.Duration(rand.Intn(10)+10) * time.Millisecond); send_timeout <- true }()
			select {
			case c.out <- receiver:
				fmt.Printf("[%d]: sending message to %d\n", c.ID, receiver)
				sent++
				if sent == ToSend {
					<- c.sending
				}
			case <-send_timeout:
				c.failed++
			}
		}

		recv_timeout := make(chan bool, 1)

		go func() { time.Sleep(time.Duration(rand.Intn(50)+50) * time.Millisecond); recv_timeout <- true }()
		select {
		case msg := <-c.In:
			fmt.Printf("[%d]: received message: %d\n", c.ID, msg)
		case <-recv_timeout:
		}
	}
}

func (s *Server) Register() *Client {
	newc := Client{In: make(chan int), out: s.in, close: &s.close, sending: s.sending}

	if ToSend > 0 {
		s.sending <- true
	}

	s.cMutex.Lock()
	defer s.cMutex.Unlock()

	newc.ID = len(s.clients)
	s.clients = append(s.clients, &newc)

	return &newc
}

func (s *Server) Init() {
	s.sending = make(chan bool, 255)
	s.in = make(chan int)
}

func (s *Server) Start() {
	for _, client := range s.clients {
		go client.Run()
	}

	for {
		select {
		case receiverID := <-s.in:
			if receiverID >= 0 && receiverID < len(s.clients) {
				s.clients[receiverID].In <- 123
			}

		default:
			if len(s.sending) == 0 {
				s.close.Store(true)
				return
			}
			time.Sleep(5 * time.Millisecond)
		}
	}
}


func main() {
	var s Server
	s.Init()
	for range(NumClients) {
		s.Register()
	}

	s.Start()

	for _, c := range(s.clients) {
		fmt.Printf("[%d] failed %d times\n", c.ID, c.failed)
	}
}
