.PHONY: all
all: index.html sass coffee jade
	date


.PHONY: yasb
yasb:
	curl -o src/cards-common.coffee https://raw.githubusercontent.com/geordanr/xwing/master/coffeescripts/cards-common.coffee


# http://sass-lang.com/
SCSS:=$(wildcard src/sass/*.scss)
CSS:=$(patsubst src/sass/%.scss,build/css/%.css,$(SCSS))

build/css/%.css: src/sass/%.scss
	sass $< $@

.PHONY: sass
sass: $(CSS)


# http://coffeescript.org/
COFFEE:=$(wildcard src/coffee/*.coffee)
JS:=$(patsubst src/coffee/%.coffee,build/js/%.js,$(COFFEE))

build/js/%.js: src/coffee/%.coffee
	node_modules/.bin/coffee -co build/js $<

.PHONY: coffee
coffee: $(JS)


# http://jade-lang.com/
JADE:=$(wildcard src/jade/*.jade)
TMPL:=$(patsubst src/jade/%.jade,build/tmpl/%.js,$(JADE))

build/tmpl/%.js: src/jade/%.jade
	node_modules/.bin/jade --client --name $*_tmpl --no-debug --out build/tmpl $<

.PHONY: jade
jade: $(TMPL)

#.PHONY: includes
#includes:
#	@bash -c 'for css in `cat src/vendor_css.txt` $(CSS);        do echo "<link rel="stylesheet" href=\"$$css\">" | sed -e s/build//g; done'
#	@bash -c 'for js  in `cat src/vendor_js.txt`  $(TMPL) $(JS); do echo "<script src=\"$$js\"></script>"         | sed -e s/build//g; done'


#src/xws_data_%.coffee: src/cards-common.coffee src/xws_validate.coffee src/make_data_%.coffee
#	node_modules/.bin/coffee -p $^ | node > $@
#
#README_NAMES.md: src/xws_data_pilots.coffee src/xws_data_upgrades.coffee src/xws_validate.coffee src/make_readme_names.coffee
#	node_modules/.bin/coffee -p $^ | node > $@

#dist/xws.js: src/hotac%.coffee
#	#cat a.coffee b.coffee c.coffee | coffee --compile --stdio > bundle.js
#	cat $^ | node_modules/.bin/coffee -c --stdio > $@

dist/xws.min.js: dist/xws.js
	node_modules/.bin/uglifyjs $^ --screw-ie8 -o $@ -c

index.html: src/jade/index.jade src/jade/index.json $(TMPL)
	node_modules/.bin/jade --pretty --no-debug --out . -O src/jade/index.json src/jade/index.jade


