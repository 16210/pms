LATEXFILES := $(wildcard *.tex) pms.cls
SOURCES = $(LATEXFILES) Makefile
COMMITINFO = gitHeadLocal.gin

TWOSIDE =

# latex chokes on aux files produced by tex4ht, so remove them
aux-clean = if grep -q rEfLiNK pms.aux 2>/dev/null; then rm -f *.aux; fi

all: pms.pdf

pms.pdf: $(LATEXFILES) $(COMMITINFO)
	$(aux-clean)
	set -e; \
	while true; do \
	  if test -z '$(TWOSIDE)'; then \
	    xelatex pms; \
	  else \
	    xelatex '\PassOptionsToClass{twoside}{pms}\input{pms}'; \
	  fi; \
	  grep -q 'Warning.*Rerun' pms.log || break; \
	done

$(COMMITINFO): $(SOURCES)
	@# see gitinfo2 documentation
	reltag=$$(git describe --tags --long --always --dirty='-*' \
	  --match='eapi-*-approved*' 2>/dev/null); \
	if test -n "$${reltag}"; then \
	  TZ=UTC git log -1 --date=short-local --decorate=short \
	    --pretty="format:\usepackage[%%%n  shash={%h},%n\
	  lhash={%H},%n  authname={%an},%n  authemail={%ae},%n\
	  authsdate={%ad},%n  authidate={%ai},%n  authudate={%at},%n\
	  commname={%cn},%n  commemail={%ce},%n  commsdate={%cd},%n\
	  commidate={%ci},%n  commudate={%ct},%n  refnames={%d},%n\
	  reltag={$${reltag}}%n]{gitexinfo}%n" > $@; \
	fi

clean:
	rm -f *~ *.pdf *.dvi *.log *.aux *.bbl *.blg *.toc *.lol *.loa *.lox \
	  *.lot *.out *.html *.css *.png *.4ct *.4tc *.idv *.lg *.tmp *.xref

maintainer-clean: clean
	rm -f $(COMMITINFO)

.PHONY: all clean maintainer-clean

.DELETE_ON_ERROR:
.NOTPARALLEL:
