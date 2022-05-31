package model

import "strconv"

type (
	StringFile struct {
		Name    string
		Entries []Entry
	}
	Entry struct {
		ID   int    `json:"id"`
		Key  string `json:"Key"`
		EnUS string `json:"enUS"`
		ZhTW string `json:"zhTW"`
		DeDE string `json:"deDE"`
		EsES string `json:"esES"`
		FrFR string `json:"frFR"`
		ItIT string `json:"itIT"`
		KoKR string `json:"koKR"`
		PlPL string `json:"plPL"`
		EsMX string `json:"esMX"`
		JaJP string `json:"jaJP"`
		PtBR string `json:"ptBR"`
		RuRU string `json:"ruRU"`
		ZhCN string `json:"zhCN"`
	}
)

func (e Entry) AsMap() map[string]any {
	return map[string]any{
		"id":   e.ID,
		"Key":  e.Key,
		"enUS": e.EnUS,
		"zhTW": e.ZhTW,
		"deDE": e.DeDE,
		"esES": e.EsES,
		"frFR": e.FrFR,
		"itIT": e.ItIT,
		"koKR": e.KoKR,
		"plPL": e.PlPL,
		"esMX": e.EsMX,
		"jaJP": e.JaJP,
		"ptBR": e.PtBR,
		"ruRU": e.RuRU,
		"zhCN": e.ZhCN,
	}
}

func (e Entry) Get(field string) string {
	switch field {
	case "id":
		return strconv.Itoa(e.ID)
	case "Key":
		return e.Key
	case "enUS":
		return e.EnUS
	case "zhTW":
		return e.ZhTW
	case "deDE":
		return e.DeDE
	case "esES":
		return e.EsES
	case "frFR":
		return e.FrFR
	case "itIT":
		return e.ItIT
	case "koKR":
		return e.KoKR
	case "plPL":
		return e.PlPL
	case "esMX":
		return e.EsMX
	case "jaJP":
		return e.JaJP
	case "ptBR":
		return e.PtBR
	case "ruRU":
		return e.RuRU
	case "zhCN":
		return e.ZhCN
	default:
		panic("unknown field: " + field)
	}
}
