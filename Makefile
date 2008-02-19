# Reset this to 'cpp' so it gets traditional syntax; cc -E will not work
# properly.
CPP=cpp

# The pam.d file to create
PAMD=system-auth system-login

# Get this by default, even if I'd like avoid it...
ifeq "$(IMPLEMENTATION)" ""
IMPLEMENTATION=linux-pam
endif

PAMFLAGS = -include $(IMPLEMENTATION)-conf -include basic-conf

ifeq "$(CRACKLIB)" "yes"
PAMFLAGS += -DHAVE_CRACKLIB=1
endif

all: $(PAMD)

$(PAMD): %: %.in
	$(CPP) -traditional-cpp -P $(PAMFLAGS) $< -o $@
	sed -i -e '/^$$/d' -e '/^\/\//d' $@

clean:
	rm -f $(PAMD) *~
