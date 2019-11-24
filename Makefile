# Reset this to 'cpp' so it gets traditional syntax; cc -E will not work
# properly.
CPP=cpp

# The pam.d file to create
PAMD=login passwd su system-auth system-login system-local-login system-remote-login system-services other

# command for git (the DVCS); set this to "true" to ignore GIT support
# (i.e.: in the ebuild)
GIT=git

PAMFLAGS = -include linux-pam-conf -include basic-conf -DLINUX_PAM_VERSION=$(LINUX_PAM_VERSION)

ifeq "$(CRACKLIB)" "yes"
PAMFLAGS += -DHAVE_CRACKLIB=1
endif

ifeq "$(PASSWDQC)" "yes"
PAMFLAGS += -DHAVE_PASSWDQC=1
endif

ifeq "$(CONSOLEKIT)" "yes"
PAMFLAGS += -DHAVE_CONSOLEKIT=1
endif

ifeq "$(SYSTEMD)" "yes"
PAMFLAGS += -DHAVE_SYSTEMD=1
endif

ifeq "$(ELOGIND)" "yes"
PAMFLAGS += -DHAVE_ELOGIND=1
endif

ifeq "$(GNOME_KEYRING)" "yes"
PAMFLAGS += -DHAVE_GNOME_KEYRING=1
endif

ifeq "$(SECURETTY)" "yes"
PAMFLAGS += -DHAVE_SECURETTY=1
endif

ifeq "$(SELINUX)" "yes"
PAMFLAGS += -DHAVE_SELINUX=1
endif

ifeq "$(MKTEMP)" "yes"
PAMFLAGS += -DHAVE_MKTEMP=1
endif

ifeq "$(PAM_SSH)" "yes"
PAMFLAGS += -DHAVE_PAM_SSH=1
endif

ifeq "$(KRB5)" "yes"
PAMFLAGS += -DHAVE_KRB5=1
endif

ifeq "$(NULLOK)" "yes"
PAMFLAGS += -DWANT_NULLOK=1
endif

ifeq "$(SHA512)" "yes"
PAMFLAGS += -DWANT_SHA512=1
endif

ifeq "$(DEBUG)" "yes"
PAMFLAGS += -DDEBUG=debug
endif

ifeq "$(MINIMAL)" "yes"
PAMFLAGS += -DMINIMAL
endif

ifeq "$(LIBCAP)" "yes"
PAMFLAGS += -DLIBCAP
endif

all: $(PAMD)

install: $(PAMD)
	install -d "$(DESTDIR)/etc/pam.d"
	install -m0644 $(PAMD) "$(DESTDIR)/etc/pam.d"

PACKAGE=pambase
ifeq "$(VERSION)" ""
VERSION = $(shell date +"%Y%m%d")
endif

dist: $(PACKAGE)-$(VERSION).tar.xz

$(PACKAGE)-$(VERSION).tar.xz: $(shell $(GIT) ls-files)
	$(GIT) tag $(PACKAGE)-$(VERSION)
	$(GIT) archive --format=tar --prefix=$(PACKAGE)-$(VERSION)/ HEAD | xz > $@

$(PAMD): %: %.in
	$(CPP) -traditional-cpp -P $(PAMFLAGS) $< -o $@
	sed -i -e '/^$$/d' -e '/^\/\//d' $@

clean:
	rm -f $(PAMD) *~
