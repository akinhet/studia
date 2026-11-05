package main

import "errors"


type queueNode[T any] struct {
	next *queueNode[T]
	val T
}

type Queue[T any] struct {
	first *queueNode[T]
	len int
}


func (q *Queue[T]) Push(e T) {
	n := &queueNode[T]{next: nil, val: e}

	if q.first == nil {
		q.first = n
	} else {
		node := q.first
		for node.next != nil {
			node = node.next
		}
		node.next = n
	}

	q.len++
}

func (q *Queue[T]) Pop() (T, error) {
	if q.first == nil {
		var empty T
		return empty, errors.New("Queue empty")
	}

	ret := q.first.val
	q.first = q.first.next
	q.len--
	return ret, nil
}
