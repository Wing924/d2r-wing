LANG_TYPE			= sc
ORIGINDIR 			= origin
BUILDDIR 			= build
RESDIR				= resources
COMMONDIR			= $(BUILDDIR)/common
TCDIR				= $(BUILDDIR)/tc
SCDIR				= $(BUILDDIR)/sc
SRC_STRINGS 		= $(filter-out */chinese-overlay.json, $(wildcard $(ORIGINDIR)/data/local/lng/strings/*.json))
TC_TARGET_STRINGS 	= $(patsubst $(ORIGINDIR)/%, $(TCDIR)/%, $(SRC_STRINGS))
SC_TARGET_STRINGS 	= $(patsubst $(ORIGINDIR)/%, $(SCDIR)/%, $(SRC_STRINGS))

EXCEL_PATCH			= $(wildcard $(RESDIR)/patches/data/global/excel/*.txt.patch)
EXCEL_OUT			= $(patsubst $(RESDIR)/patches/%.patch, $(COMMONDIR)/%, $(EXCEL_PATCH))

.PHONY: nop
nop:
	@echo $(EXCEL_PATCH)

.PHONY: build
build: clean tool cp-static excel $(TC_TARGET_STRINGS) $(SC_TARGET_STRINGS)

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

cp-static:
	mkdir -p $(BUILDDIR)
	cp -r $(RESDIR)/static $(COMMONDIR)

excel: $(EXCEL_OUT)

$(COMMONDIR)/%.txt: $(RESDIR)/patches/%.txt.patch $(ORIGINDIR)/%.txt
	mkdir -p $(@D)
	patch -u -o $@ $(ORIGINDIR)/$*.txt < $<

clean:
	rm -rf build

publish:
	rm -rf d2r-wing.mpq/data
	cp -r $(COMMONDIR)/data d2r-wing.mpq
	cp -r $(BUILDDIR)/$(LANG_TYPE)/data d2r-wing.mpq

gen: gen-levels gen-armor gen-weapons

gen-patch: $(EXCEL_PATCH)

$(RESDIR)/%.txt.patch: $(RESDIR)/%.txt
	diff -u $(ORIGINDIR)/$*.txt $(RESDIR)/$*.txt | tee $(RESDIR)/$*.txt.patch

gen-lang-diff:
	mkdir -p resources/generated
	go run github.com/Wing924/d2r-wing/tools/cmd/string-diff > resources/generated/zhTW-strings-diff.json
	jq -r '.[] | [.id, .old_zhTW, .new_zhTW] | @csv' resources/generated/zhTW-strings-diff.json > resources/generated/zhTW-strings-diff.csv

gen-levels:
	@echo "id,zhTW,normal,nightmare,hell" | tee resources/levels.csv
	@go run github.com/Wing924/d2r-wing/tools/cmd/join-strings \
		-json origin/data/local/lng/strings/levels.json \
		-on-json Key \
		-csv origin/data/global/excel/levels.txt \
		-on-csv '*StringName' \
		| jq -r '.[] | select(."MonLvlEx(N)" != "") | [.id, .zhTW, .MonLvl, ."MonLvlEx(N)", ."MonLvlEx(H)"] | @csv' | tee -a resources/levels.csv

gen-armor:
	@echo "id,zhTW,grade,weight,socket" | tee resources/item-armor.csv
	@go run github.com/Wing924/d2r-wing/tools/cmd/join-strings \
		-json origin/data/local/lng/strings/item-names.json \
		-on-json Key \
		-csv origin/data/global/excel/armor.txt \
		-on-csv namestr \
		| jq -r '.[] | [.id, .zhTW, if .code == .normcode then "普" elif .code == .ubercode then "擴" else "精" end, if .speed == "0" then "輕" elif .speed == "5" then "中" else "重" end, .gemsockets] | @csv' \
		| tee -a resources/item-armor.csv

gen-weapons:
	@echo "id,zhTW,grade,socket" | tee resources/item-weapons.csv
	@go run github.com/Wing924/d2r-wing/tools/cmd/join-strings \
		-json origin/data/local/lng/strings/item-names.json \
		-on-json Key \
		-csv origin/data/global/excel/weapons.txt \
		-on-csv namestr \
		| jq -r '.[] | [.id, .zhTW, if .code == .normcode then "普" elif .code == .ubercode then "擴" else "精" end, .gemsockets] | @csv' \
		| tee -a resources/item-weapons.csv
