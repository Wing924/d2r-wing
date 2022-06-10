package main

import (
	"database/sql"
	_ "embed"
	"fmt"
	"log"
	"os"
	"path"
	"regexp"
	"strings"

	"github.com/Wing924/d2r-wing/tools/lib/enc"
	_ "github.com/mattn/go-sqlite3"
)

const (
	armorTxt       = "origin/data/global/excel/armor.txt"
	uniqueItemsTxt = "origin/data/global/excel/uniqueitems.txt"
	setItemsTxt    = "origin/data/global/excel/setitems.txt"
	runesTxt       = "origin/data/global/excel/runes.txt"
	skillsTxt      = "origin/data/global/excel/skills.txt"
	propertiesTxt  = "origin/data/global/excel/properties.txt"
	itemNamesJSON  = "origin/data/local/lng/strings/item-names.json"
	itemRunesJSON  = "origin/data/local/lng/strings/item-runes.json"
)

var (
	//go:embed sql/normalize.sql
	sqlNormalize string
	//go:embed sql/collect-var.sql
	sqlCollectVar string
)

func main() {
	_ = os.Remove("max.db")
	db, err := sql.Open("sqlite3", "file:max.db?cache=shared")
	if err != nil {
		panic(err)
	}

	loadData(db, armorTxt, "")
	loadData(db, uniqueItemsTxt, "")
	loadData(db, setItemsTxt, "")
	loadData(db, runesTxt, "")
	loadData(db, skillsTxt, "")
	loadData(db, propertiesTxt, "")
	loadData(db, itemNamesJSON, "")
	loadData(db, itemRunesJSON, "")

	// for debug
	loadData(db, "resources/item_max.tsv", "")

	execStmts(db, sqlNormalize)
	execStmts(db, sqlCollectVar)

	//rows, err := db.Query(sqlCollectVar)
	//if err != nil {
	//	panic(err)
	//}
	//dumpRows(rows, -1)

	//fmt.Println("id\tname\tbase")
	//equips := collectMax(db)
	//for _, e := range equips {
	//	fmt.Printf("%d\t%s\t%s\n", e.ID, e.Name, e.BaseName)
	//}
}

type Equip struct {
	ID           int
	Key          string
	Name         string
	BaseName     string
	MinAC, MaxAC int
	Properties   []Property
}

type Property struct {
	Index    int
	Name     string
	Code     string
	Param    string
	Min, Max int
}

var reSQLComment = regexp.MustCompile(`(?m)^\s*--.*$`)

func execStmts(db *sql.DB, stmts string) {
	stmts = reSQLComment.ReplaceAllString(stmts, "")
	for _, stmt := range strings.Split(stmts, ";") {
		stmt = strings.TrimSpace(stmt)
		if stmt != "" {
			if _, err := db.Exec(stmt); err != nil {
				log.Println("exec:", stmt)
				panic(err)
			}
		}
	}
}

func collectMax(db *sql.DB) []Equip {
	rows, err := db.Query(sqlCollectVar)
	if err != nil {
		panic(err)
	}

	var row struct {
		id       int
		category string
		idx      int
		Key      string
		itemName string
		baseName string
		minAC    int
		maxAC    int
		propName string
		prop     string
		param    string
		minValue int
		maxValue int
	}
	var equips []Equip
	var equip Equip
	for rows.Next() {
		if err := rows.Scan(
			&row.id,
			&row.category,
			&row.idx,
			&row.Key,
			&row.itemName,
			&row.baseName,
			&row.minAC,
			&row.maxAC,
			&row.propName,
			&row.prop,
			&row.param,
			&row.minValue,
			&row.maxValue,
		); err != nil {
			panic(err)
		}
		if equip.ID != row.id {
			if equip.ID > 0 && (equip.MinAC != equip.MaxAC || len(equip.Properties) > 0) {
				equips = append(equips, equip)
			}
			equip = Equip{
				ID:       row.id,
				Key:      row.Key,
				Name:     row.itemName,
				BaseName: row.baseName,
				MinAC:    row.minAC,
				MaxAC:    row.maxAC,
			}
		}
		if row.minValue != row.maxValue {
			equip.Properties = append(equip.Properties, Property{
				Index: row.idx,
				Name:  row.propName,
				Code:  row.prop,
				Param: row.param,
				Min:   row.minValue,
				Max:   row.maxValue,
			})
		}
	}
	if equip.ID > 0 && (equip.MinAC != equip.MaxAC || len(equip.Properties) > 0) {
		equips = append(equips, equip)
	}
	return equips
}

func checkIfContainsVariable(equip Equip) bool {
	if equip.ID == 0 {
		return false
	}
	if equip.MinAC == equip.MaxAC && len(equip.Properties) == 0 {
		return false
	}
	hasVaryDef := equip.MinAC != equip.MaxAC
	for _, prop := range equip.Properties {
		switch prop.Code {
		case "ac%":
			hasVaryDef = false
		}
	}
	return hasVaryDef
}

func loadData(db *sql.DB, filename string, tableName string) string {
	log.Println("load data:", filename)
	if tableName == "" {
		tableName = strings.TrimSuffix(path.Base(filename), path.Ext(filename))
	}
	tableName = strings.ReplaceAll(tableName, "-", "_")
	if strings.HasSuffix(filename, ".json") {
		loadJSONData(db, filename, tableName)
	} else {
		loadCSVData(db, filename, tableName)
	}

	return tableName
}

func loadJSONData(db *sql.DB, filename string, tableName string) {
	entries := enc.ReadStringsJSON(filename)
	header := []string{"id", "Key", "enUS", "zhTW"}
	fieldList := toSQLList(header)
	_, err := db.Exec(fmt.Sprintf("CREATE TABLE `%s` (%s)", tableName, fieldList))
	if err != nil {
		panic(err)
	}
	stmt, err := db.Prepare(fmt.Sprintf("INSERT INTO `%s` (%s) VALUES (%s)",
		tableName,
		fieldList,
		strings.Join(newSlice("?", len(header)), ", "),
	))
	if err != nil {
		panic(err)
	}
	for _, item := range entries {
		data := []any{item.ID, item.Key, item.EnUS, item.ZhTW}
		if _, err := stmt.Exec(data...); err != nil {
			panic(err)
		}
	}
}

func loadCSVData(db *sql.DB, filename string, tableName string) {
	header, tbl := enc.ReadCSV(filename)
	fieldList := toSQLList(header)
	_, err := db.Exec(fmt.Sprintf("CREATE TABLE `%s` (%s)", tableName, fieldList))
	if err != nil {
		panic(err)
	}
	stmt, err := db.Prepare(fmt.Sprintf("INSERT INTO `%s` (%s) VALUES (%s)",
		tableName,
		fieldList,
		strings.Join(newSlice("?", len(header)), ", "),
	))
	if err != nil {
		panic(err)
	}
	for _, item := range tbl {
		data := make([]any, len(header))
		for i := range header {
			data[i] = item[i]
		}
		if _, err := stmt.Exec(data...); err != nil {
			panic(err)
		}
	}
}

func newSlice[T any](initValue T, length int) []T {
	slice := make([]T, length)
	for i := 0; i < length; i++ {
		slice[i] = initValue
	}
	return slice
}

func toSQLList(list []string) string {
	m := make([]string, len(list))
	for i, value := range list {
		m[i] = "`" + value + "`"
	}
	return strings.Join(m, ", ")
}

func dumpRows(rows *sql.Rows, maxRow int) {
	defer func() { _ = rows.Close() }()
	cols, _ := rows.Columns()
	ptrs := make([]any, len(cols))
	containers := make([]string, len(cols))
	for i := range cols {
		ptrs[i] = &containers[i]
	}
	fmt.Println(strings.Join(cols, "\t"))
	for rows.Next() {
		if maxRow == 0 {
			break
		}
		maxRow--
		if err := rows.Scan(ptrs...); err != nil {
			panic(err)
		}
		fmt.Println(strings.Join(containers, "\t"))
	}
}
