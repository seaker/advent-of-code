CFLAGS  := -Wall
LDFLAGS := -lgtest -lpthread

TARGETS := s

latest: $(firstword $(TARGETS))

%: %.cc
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS)

.PHONY: all clean

all: $(TARGETS)

clean:
	@rm -f $(TARGETS)
