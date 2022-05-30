package model

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
