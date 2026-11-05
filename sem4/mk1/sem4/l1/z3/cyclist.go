package main

type cycNode struct {
	next, prev *cycNode
	val int
}

type CycList struct {
	first *cycNode
	len int
}

func (c *CycList) Insert(value int) {
	n := &cycNode{next: nil, prev: nil, val: value}

	if c.first == nil {
		c.first = n
		n.next = n
		n.prev = n
	} else {
		n.next = c.first.next
		n.next.prev = n
		c.first.next = n
		n.prev = c.first
	}

	c.len++
}

func (c1 *CycList) Merge(c2 *CycList) {
	if c2.first == nil {
		return
	}

	if c1.first == nil {
		c1.first = c2.first
	} else {
		c2.first.prev.next = c1.first.next
		c1.first.next.prev = c2.first.prev
		c1.first.next = c2.first
		c2.first.prev = c1.first
	}

	c1.len += c2.len
	c2 = &CycList{}
}
