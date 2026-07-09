CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -g -Iinclude
LDFLAGS =

SRC_DIR = src
OBJ_DIR = build
BIN_DIR = bin
TARGET = $(BIN_DIR)/riscv-decoder

SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRCS))
DEPS = $(OBJS:.o=.d)

.PHONY: all clean test debug valgrind help dirs

all: dirs $(TARGET)

dirs:
	@mkdir -p $(OBJ_DIR) $(BIN_DIR)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

-include $(DEPS)

debug: CFLAGS += -DDEBUG -O0
debug: all

release: CFLAGS += -O2 -DNDEBUG
release: all

test: all
	@echo "Running decoder on test programs..."
	./$(TARGET) test/programs/r_type.hex
	./$(TARGET) test/programs/i_type.hex
	./$(TARGET) test/programs/branch.hex
	./$(TARGET) test/programs/mixed.hex
	@echo "Compiling and running unit tests..."
	$(CC) $(CFLAGS) test/test_decoder.c src/decoder.c -o $(BIN_DIR)/test_decoder
	./$(BIN_DIR)/test_decoder

valgrind: all
	valgrind --leak-check=full ./$(TARGET) test/programs/mixed.hex

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

help:
	@echo "Targets: all, debug, release, test, valgrind, clean, help"
