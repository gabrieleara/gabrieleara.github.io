.PHONY: build serve drafts serve-drafts clean

CMD_JEKYLL		= bundle exec jekyll
CMD_BUILD		= $(CMD_JEKYLL) build
CMD_SERVE		= $(CMD_JEKYLL) serve --livereload
CMD_DRAFTS		= $(CMD_BUILD) --drafts
CMD_DRAFTS_SERVE	= $(CMD_SERVE) --drafts
CMD_CLEAN		= $(CMD_JEKYLL) clean

build:
	$(CMD_BUILD)

serve:
	$(CMD_SERVE)

drafts:
	$(CMD_DRAFTS)

serve-drafts:
	$(CMD_DRAFTS_SERVE)

clean:
	$(CMD_CLEAN)

install-dep:
	./install-dep.sh
