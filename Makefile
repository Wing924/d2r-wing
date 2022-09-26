SHELL=/bin/bash -o pipefail

LANG_TYPE					= sc
MODE						= std

ORIGINDIR 					= origin
BUILDDIR 					= build
RESDIR						= resources
PATCHDIR					= patches
TOOLDIR						= $(BUILDDIR)/bin
COMMONDIR					= $(BUILDDIR)/common
TCDIR						= $(BUILDDIR)/tc
SCDIR						= $(BUILDDIR)/sc
ORI_STRINGS_DIR				= $(ORIGINDIR)/data/local/lng/strings
ORI_STRINGS_LEGACY_DIR		= $(ORIGINDIR)/data/local/lng/strings-legacy
CONFIG_FILE					= $(BUILDDIR)/config-$(MODE).yml

LEGACY_STRINGS_FILES		= bnet.json item-gems.json item-modifiers.json item-nameaffixes.json item-names.json item-runes.json keybinds.json levels.json mercenaries.json monsters.json npcs.json objects.json quests.json shrines.json skills.json ui.json vo.json
STRINGS_FILES				= commands.json presence-states.json ui-controller.json $(LEGACY_STRINGS_FILES)
GENERATED_RES				= equip levels runes uniq-set staff-mods levelgroup-res
PATCHES						= $(wildcard $(PATCHDIR)/*)

# origin/data/local/lng/strings/XXX.json
ORI_STRINGS_FILES			= $(addprefix $(ORI_STRINGS_DIR)/, $(STRINGS_FILES))
# origin/data/local/lng/strings-legacy/XXX.json
ORI_STRINGS_LEGACY_FILES	= $(addprefix $(ORI_STRINGS_LEGACY_DIR)/, $(LEGACY_STRINGS_FILES))
# build/tc/data/local/lng/strings/XXX.json
TC_TARGET_STRINGS 			= $(patsubst $(ORIGINDIR)/%, $(TCDIR)/%, $(ORI_STRINGS_FILES))
# build/sc/data/local/lng/strings/XXX.json
SC_TARGET_STRINGS 			= $(patsubst $(ORIGINDIR)/%, $(SCDIR)/%, $(ORI_STRINGS_FILES))

GENERATED_RES_FILES			= $(patsubst %, $(RESDIR)/generated/%.tsv, $(GENERATED_RES))

# EXCEL_PATCH					= $(wildcard $(RESDIR)/patches/data/global/excel/*.txt.patch)
# EXCEL_OUT					= $(patsubst $(RESDIR)/patches/%.patch, $(COMMONDIR)/%, $(EXCEL_PATCH))
ZHTW_DIFF_FILES				= $(patsubst %.json, $(RESDIR)/generated/zhTW-diff/%.tsv, $(LEGACY_STRINGS_FILES))

# common

.PHONY: nop
nop:
	echo $(ORI_STRINGS_FILES)

dist-clean: clean clean-gen

# build mods

.PHONY: build
build: clean patches gen-strings t2s
gen-strings: $(TOOLDIR)/gen-strings $(TC_TARGET_STRINGS)
t2s: $(TOOLDIR)/t2s $(SC_TARGET_STRINGS)

# build tools
$(TOOLDIR)/%:
	mkdir -p $(@D)
	go build -o $(BUILDDIR)/bin/$* github.com/Wing924/d2r-wing/tools/cmd/$*

# build Traditional Chinese strings
$(TCDIR)/data/local/lng/strings/%.json: $(ORIGINDIR)/data/local/lng/strings/%.json
	mkdir -p $(@D)
	$(TOOLDIR)/gen-strings -config $(CONFIG_FILE) < <(scripts/read-origin.sh $<) > $@

# convert Traditional Chinese to Simplified Chinese
$(SCDIR)/data/local/lng/strings/%.json: $(TCDIR)/data/local/lng/strings/%.json
	mkdir -p $(@D)
	$(TOOLDIR)/t2s -in $< > $@

patches: $(TOOLDIR)/std-json $(TOOLDIR)/jsonpatch $(CONFIG_FILE)
	scripts/build-patch-all.sh $(CONFIG_FILE) $(ORIGINDIR) $(COMMONDIR)

$(CONFIG_FILE): config/pipelines.yml config/pipelines_$(MODE).yml
	spruce merge config/pipelines.yml config/pipelines_$(MODE).yml > $@

clean:
	rm -rf build

# publish mods

publish:
	rm -rf wing.mpq/data
	cp -r $(COMMONDIR)/data wing.mpq
	cp -r $(BUILDDIR)/$(LANG_TYPE)/data wing.mpq

# generate resources

gen: clean-gen gen-zhTW-diff $(GENERATED_RES_FILES)

gen-zhTW-diff: $(ZHTW_DIFF_FILES)

$(RESDIR)/generated/zhTW-diff/%.tsv: $(RESDIR)/generated/zhTW-diff $(ORI_STRINGS_LEGACY_DIR)/%.json $(ORI_STRINGS_DIR)/%.json
	./scripts/gen-zhTW-diff.sh $(ORI_STRINGS_LEGACY_DIR)/$*.json $(ORI_STRINGS_DIR)/$*.json | tee $@

$(RESDIR)/generated/zhTW-diff:
	mkdir -p $(RESDIR)/generated/zhTW-diff

$(RESDIR)/generated/%.tsv: resources/generated
	./scripts/gen-$*.sh | tee $@

resources/generated:
	mkdir -p resources/generated

clean-gen:
	rm -rf $(RESDIR)/generated
