// Code generated by github.com/99designs/gqlgen, DO NOT EDIT.

package model

import (
	"fmt"
	"io"
	"strconv"
)

// Connection interface
type Connection interface {
	IsConnection()
	GetEdges() []Edge
	GetPageInfo() *PageInfo
}

// Edges interface
type Edge interface {
	IsEdge()
	GetNode() Node
	GetCursor() string
}

// Node interface
type Node interface {
	IsNode()
	GetID() string
}

type GeographicCoordinates struct {
	Lng float64 `json:"lng"`
	Lat float64 `json:"lat"`
}

type PageArguments struct {
	First  *int    `json:"first"`
	After  *string `json:"after"`
	Last   *int    `json:"last"`
	Before *string `json:"before"`
}

type PageInfo struct {
	TotalCount      int    `json:"totalCount"`
	StartCursor     string `json:"startCursor"`
	EndCursor       string `json:"endCursor"`
	HasNextPage     bool   `json:"hasNextPage"`
	HasPreviousPage bool   `json:"hasPreviousPage"`
}

type Direction string

const (
	DirectionForward  Direction = "FORWARD"
	DirectionBackward Direction = "BACKWARD"
)

var AllDirection = []Direction{
	DirectionForward,
	DirectionBackward,
}

func (e Direction) IsValid() bool {
	switch e {
	case DirectionForward, DirectionBackward:
		return true
	}
	return false
}

func (e Direction) String() string {
	return string(e)
}

func (e *Direction) UnmarshalGQL(v interface{}) error {
	str, ok := v.(string)
	if !ok {
		return fmt.Errorf("enums must be strings")
	}

	*e = Direction(str)
	if !e.IsValid() {
		return fmt.Errorf("%s is not a valid Direction", str)
	}
	return nil
}

func (e Direction) MarshalGQL(w io.Writer) {
	fmt.Fprint(w, strconv.Quote(e.String()))
}
