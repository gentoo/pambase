# Reset this to 'cpp' so it gets traditional syntax; cc -E will not work
# properly.
CPP=cpp

# The pam.d file to create
PAMD=system-auth system-login system-local-login system-remote-login other

# command for git (the DVCS); set this to "true" to ignore GIT support
# (i.e.: in the ebuild)
GIT=git

# Get this by default, even if I'd like avoid it...
ifeq "$(IMPLEMENTATION)" ""
IMPLEMENTATION=linux-pam
endif

PAMFLAGS = -include $(IMPLEMENTATION)-conf -include basic-conf

ifeq "$(CRACKLIB)" "yes"
PAMFLAGS += -DHAVE_CRACKLIB=1
endif

ifeq "$(CONSOLEKIT)" "yes"
PAMFLAGS += -DHAVE_CONSOLEKIT
endif

ifeq "$(GNOME_KEYRING)" "yes"
PAMFLAGS += -DHAVE_GNOME_KEYRING
endif

ifeq "$(SELINUX)" "yes"
PAMFLAGS += -DHAVE_SELINUX=1
endif

ifeq "$(DEBUG)" "yes"
PAMFLAGS += -DDEBUG=debug
endif

all: $(PAMD)

install: $(PAMD)
	install -d "$(DESTDIR)/etc/pam.d"
	install -m0644 $(PAMD) "$(DESTDIR)/etc/pam.d"

PACKAGE=pambase
ifeq "$(VERSION)" ""
VERSION = $(shell date +"%Y%m%d")
endif

dist: $(PACKAGE)-$(VERSION).tar.bz2

$(PACKAGE)-$(VERSION).tar.bz2: $(shell $(GIT) ls-files)
	$(GIT) archive --format=tar --prefix=$(PACKAGE)-$(VERSION)/ HEAD | bzip2 > $@

$(PAMD): %: %.in
	$(CPP) -traditional-cpp -P $(PAMFLAGS) $< -o $@
	sed -i -e '/^$$/d' -e '/^\/\//d' $@

clean:
	rm -f $(PAMD) *~
