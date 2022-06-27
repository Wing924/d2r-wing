package opencc_test

import (
	"github.com/Wing924/d2r-wing/tools/lib/opencc"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"testing"
)

func TestOpenCC_Convert(t *testing.T) {
	t2s, err := opencc.New("t2s")
	require.NoError(t, err)

	cases := map[string]string{
		"":      "",
		"榮耀之鍊":  "荣耀之链",
		"項鍊":    "项链",
		"我是鍊金師": "我是炼金师",
	}
	for k, v := range cases {
		t.Run(v, func(t *testing.T) {
			result, err := t2s.Convert(k)
			require.NoError(t, err)
			assert.Equal(t, v, result)
		})
	}
}
