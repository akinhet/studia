package main

import "errors"


type Stack[T any] struct {
	data []T
}

func MakeStack[T any](init_size int) *Stack[T] {
	return &Stack[T]{data: make([]T, 0, init_size)}
}

func (s *Stack[T]) Push(e T) {
	s.data = append(s.data, e)
}

func (s *Stack[T]) Pop() (T, error) {
	l := len(s.data)
	
	if l == 0 {
		var empty T
		return empty, errors.New("Stack empty")
	}

	ret := s.data[l-1]
	s.data = s.data[:l-1]

	return ret, nil
}
