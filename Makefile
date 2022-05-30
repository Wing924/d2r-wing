gen: gen-mkdir gen-lang-diff

gen-mkdir:
	mkdir -p resources/generated

gen-lang-diff:
	go run github.com/Wing924/d2r-wing/tools/cmd/string-diff > resources/generated/zhTW-strings-diff.json
	jq -r '.[] | [.id, .old_zhTW, .new_zhTW] | @csv' resources/generated/zhTW-strings-diff.json > resources/generated/zhTW-strings-diff.csv

clean:
