CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -g

# Files
TARGET = program
SRCS = main.c utils.c
OBJS = $(SRCS:.c=.o)

# Phony targets
.PHONY: all clean test

# Default target
all: $(TARGET)

# Link object files into final executable
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Build .o files from .c files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean: remove compiled files
clean:
	rm -f $(OBJS) $(TARGET)

# Test: run the program 
test: $(TARGET)
	./$(TARGET)