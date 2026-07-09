.PHONY: all test report clean help setup

all:
	./scripts/analyze.sh test_data/sample_pass.log
	./scripts/analyze.sh test_data/sample_fail.log
	./scripts/analyze.sh test_data/sample_sim.log

test:
	./scripts/analyze.sh test_data/sample_pass.log
	./scripts/analyze.sh test_data/sample_fail.log 

report:
	./scripts/generate_report.sh

clean:
	rm -rf output/*

setup:
	./scripts/setup_env.sh

help:
	@echo "Available targets:"
	@echo "  make all     - Analyze all logs"
	@echo "  make test    - Run tests"
	@echo "  make report  - Generate report"
	@echo "  make clean   - Remove outputs"
	@echo "  make setup   - Verify tools"
	@echo "  make help    - Show help"