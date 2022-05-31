ORIGINDIR 			= origin
BUILDDIR 			= build
TCDIR				= $(BUILDDIR)/tc
SCDIR				= $(BUILDDIR)/sc
SRC_STRINGS 		= $(wildcard $(ORIGINDIR)/data/local/lng/strings/*.json)
TC_TARGET_STRINGS 	= $(patsubst $(ORIGINDIR)/%, $(TCDIR)/%, $(SRC_STRINGS))
SC_TARGET_STRINGS 	= $(patsubst $(ORIGINDIR)/%, $(SCDIR)/%, $(SRC_STRINGS))

.PHONY: build
build: tool $(TC_TARGET_STRINGS) $(SC_TARGET_STRINGS)

tool:
	mkdir -p $(BUILDDIR)/bin
	go build -o $(BUILDDIR)/bin/gen-strings github.com/Wing924/d2r-wing/tools/cmd/gen-strings
	go build -o $(BUILDDIR)/bin/t2s github.com/Wing924/d2r-wing/tools/cmd/t2s

$(TCDIR)/data/local/lng/strings/%.json: $(ORIGINDIR)/data/local/lng/strings/%.json
	mkdir -p $(@D)
	$(BUILDDIR)/bin/gen-strings -in $< > $@

$(SCDIR)/data/local/lng/strings/%.json: $(TCDIR)/data/local/lng/strings/%.json
	mkdir -p $(@D)
	$(BUILDDIR)/bin/t2s -in $< > $@

clean:
	rm -rf build


gen: gen-mkdir gen-lang-diff

gen-mkdir:
	mkdir -p resources/generated

gen-lang-diff:
	go run github.com/Wing924/d2r-wing/tools/cmd/string-diff > resources/generated/zhTW-strings-diff.json
	jq -r '.[] | [.id, .old_zhTW, .new_zhTW] | @csv' resources/generated/zhTW-strings-diff.json > resources/generated/zhTW-strings-diff.csv

gen-levels:
	@go run github.com/Wing924/d2r-wing/tools/cmd/join-strings \
		-json origin/data/local/lng/strings/levels.json \
		-on-json enUS \
		-csv origin/data/global/excel/levels.txt \
		-on-csv '*StringName' \
		| jq -r '.[] | [.id, .zhTW, .MonLvl, ."MonLvlEx(N)", ."MonLvlEx(H)"] | @csv'

gen-sockets:
	@go run github.com/Wing924/d2r-wing/tools/cmd/join-strings \
		-json origin/data/local/lng/strings/item-names.json \
		-on-json Key \
		-csv origin/data/global/excel/armor.txt \
		-on-csv code \
		| jq -r '.[] | [.id, .zhTW, .gemsockets] | @csv'
	@go run github.com/Wing924/d2r-wing/tools/cmd/join-strings \
    	-json origin/data/local/lng/strings/item-names.json \
    	-on-json Key \
    	-csv origin/data/global/excel/weapons.txt \
    	-on-csv code \
    	| jq -r '.[] | [.id, .zhTW, .gemsockets] | @csv'