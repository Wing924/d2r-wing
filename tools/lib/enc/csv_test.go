package enc

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestReadCSVAsTable(t *testing.T) {
	data := ReadCSVAsTable("../../../origin/data/global/excel/armor.txt")
	assert.NotNil(t, data)
}
