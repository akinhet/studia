package main

import (
	"fmt"
	"math/rand"
)

func main() {
	var c1, c2 CycList
	
	for i := range 10 {
		c1.Insert(i)
		c2.Insert(i + 10)
	}

	node := c2.first
	for range c2.len {
		fmt.Printf("%d, ", node.val)
		node = node.next
	}
	fmt.Println()

	c1.Merge(&c2)

	node = c1.first
	for range c1.len {
		fmt.Printf("%d, ", node.val)
		node = node.next
	}
	fmt.Println()

	var T [10000]int
	var c CycList

	for i := range len(T) {
		T[i] = rand.Intn(100001)
		c.Insert(T[i])
	}

	comp := 0
	for i := range len(T) {
		curr := c.first
		dir := rand.Intn(2)
		for j := 0; j < c.len; j++ {
			comp++
			if curr.val == T[i] {
				break
			}
			if dir == 0 {
				curr = curr.prev
			} else {
				curr = curr.next
			}
		}
	}

	fmt.Println("# porównań z T: ", comp/len(T))

	comp = 0
	for range len(T) {
		val := rand.Intn(100001)
		curr := c.first
		dir := rand.Intn(2)
		for j := 0; j < c.len; j++ {
			comp++
			if curr.val == val {
				break
			}
			if dir == 0 {
				curr = curr.prev
			} else {
				curr = curr.next
			}
		}
	}

	fmt.Println("# porównań z rand: ", comp/len(T))
}
