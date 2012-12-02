export RELEASE_TESTING=1

include ./Makefile

CCFLAGS := -DDEVEL $(CCFLAGS)

.PHONY: multitest
multitest:
	f=''; \
	for i in ~/perl5/perlbrew/perls/perl-5.1[2468]*/bin/perl perl; do \
	    echo "Trying $$i ..."; \
	    $$i Makefile.PL && make && make test; \
	    [ $$? = 0 ] || f="$$f $$i"; \
	    echo "... done (trying $$i)"; \
	done; \
	if [ -n "$$f" ]; then \
	    printf '\033[31;1mFailed:\033[m\n'; \
	    for p in $$f; do \
	        printf '\033[31m%s\033[m\n' "$$p"; \
	    done; \
	    exit 1; \
	fi >&2
