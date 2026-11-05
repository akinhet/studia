package main

type cycNode struct {
	next *cycNode
	val int
}

type CycList struct {
	first *cycNode
	len int
}

func (c *CycList) Insert(value int) {
	n := &cycNode{next: nil, val: value}

	if c.first == nil {
		c.first = n
		n.next = n
	} else {
		n.next = c.first.next
		c.first.next = n
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
		tmp := c2.first.next
		c2.first.next = c1.first.next
		c1.first.next = tmp
	}

	c1.len += c2.len
	c2 = &CycList{}
}
