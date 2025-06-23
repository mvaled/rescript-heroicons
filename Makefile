PATH := ./node_modules/.bin/:$(PATH)

install node_modules yarn.lock: package.json
	yarn install
	touch node_modules
.PHONY: install

compile: $(RESCRIPT_FILES) yarn.lock node_modules
	@if [ -n "$(INSIDE_EMACS)" ]; then \
	    NINJA_ANSI_FORCED=0 rescript build -with-deps; \
	else \
		rescript build -with-deps; \
	fi

upgrade:
	yarn upgrade --interactive
.PHONY: upgrade

clean:
	rescript clean || true
	rm -rf dist/ lib/ node_modules/
.PHONY: clean

run: compile
	vite
.PHONY: run


META_VITE_BUILD_MODE ?= production
build: compile
	vite build --mode $(META_VITE_BUILD_MODE)
.PHONY: build


META_VITE_BUILD_PREVIEW_MODE ?= develop
preview:
	vite build --mode $(META_VITE_BUILD_PREVIEW_MODE)
	vite preview --port $(FRONTEND_PORT) --mode $(META_VITE_BUILD_PREVIEW_MODE)
.PHONY: preview

format:
	rescript format -all
.PHONY: format
