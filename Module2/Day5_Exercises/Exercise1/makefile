CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -g -I.
TARGET = decoder
SRCS = main.c decoder.c
OBJS = $(SRCS:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $^ -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

debug: CFLAGS += -DDEBUG -O0
debug: clean all

rv64: CFLAGS += -DRV64
rv64: clean all

debug-rv64: CFLAGS += -DDEBUG -O0 -DRV64
debug-rv64: clean all

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all clean debug rv64 debug-rv64