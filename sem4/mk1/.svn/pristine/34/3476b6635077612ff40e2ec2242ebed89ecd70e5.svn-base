package main

import "fmt"

func main() {
	s := MakeStack[int](50)

	fmt.Printf("Stack\nPushing: ")
	for i := range 50 {
		fmt.Printf("%d, ", i)
		s.Push(i)
	}

	fmt.Printf("\nPoping: ")
	for range 50 {
		i, err := s.Pop()
		if err != nil {
			fmt.Println(err.Error())
		}
		fmt.Printf("%d, ", i)
	}
	fmt.Print("\n\n")

	var q Queue[int]

	fmt.Printf("Queue\nPushing: ")
	for i := range 50 {
		fmt.Printf("%d, ", i)
		q.Push(i)
	}

	fmt.Printf("\nPoping: ")
	for range 50 {
		i, err := q.Pop()
		if err != nil {
			fmt.Println(err.Error())
			break
		}
		fmt.Printf("%d, ", i)
	}
	fmt.Println()
}
