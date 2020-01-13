package main

import (
	"testing"

	"github.com/linkpoolio/bridges/bridge"
	"github.com/stretchr/testify/assert"
)

// Should throw an error when no parameters passed in
func TestBitcoin_Run_emptyParameters(t *testing.T) {
	btc := Bitcoin{}

	h := bridge.NewHelper(&bridge.JSON{})

	_, err := btc.Run(h)
	assert.NotNil(t, err)
}

func TestBitcoin_Opts(t *testing.T) {
	btc := Bitcoin{}
	opts := btc.Opts()
	assert.Equal(t, opts.Name, "Bitcoin")
	assert.True(t, opts.Lambda)
}
