default: run

# Set default warning mode if not specified
# permitted values debug|info|warn|error
# e.g. usage from make cli:
#  		make build log=debug
#  		make build-site log=debug
log ?= warn

build:		## hugo build & compile css (one-time)
	@make site css

run: ##            run Hugo server & watch Tailwind CSS compiler
	@make -j2 run-css run-site
	# --jobs=2 parallelizes the commands

site:		## hugo compile build
	@hugo \
		build \
		--cleanDestinationDir --gc --minify --printI18nWarnings --buildDrafts \
		--logLevel $(log)

css:		## compile Tailwind CSS
	@npx @tailwindcss/cli \
		-i ./assets/css/input.css \
		-o ./assets/css/custom.css

run-css:	## run & watch Tailwind CSS compiler
		@npx @tailwindcss/cli -i ./assets/css/input.css -o ./assets/css/custom.css --watch
# 	@npx @tailwindcss/cli \
# 		-i ./assets/css/input.css \
# 		-o ./assets/css/custom.css --watch

run-site:	## run Hugo server
		@hugo server --buildDrafts --disableFastRender --cleanDestinationDir --gc --minify --logLevel $(log)
# 	@hugo \
# 		server \
# 		--port=1313 --disableFastRender \
# 		--cleanDestinationDir --gc --minify --printI18nWarnings --buildDrafts \
# 		--logLevel $(log)

clean:		## remove all the generated files
	rm -rf public
	rm  -f assets/css/custom.css

# post:		## create a new post ## make post slug=test-post
# 	@hugo new content -k post content/blog/$$(date +%Y-%m-%d)-$(slug).md

# short:		## create a new short ## make short slug=test-short
# 	@hugo new content -k short content/blog/$$(date +%Y-%m-%d)-$(slug).md

subpage:		## make subpage parents=grand-parend/parent-page slug=test-short
	@hugo new content/$(parents)/$(slug)/_index.md

page:		## make page parents=grand-parend/parent-page slug=test-short
	@hugo new content/$(parents)/$(slug).md
