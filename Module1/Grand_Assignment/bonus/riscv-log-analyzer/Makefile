.PHONY: all test report html clean setup help

all:
	./scripts/analyze.sh test_data/sample_pass.log
	./scripts/analyze.sh test_data/sample_fail.log
	./scripts/analyze.sh test_data/sample_sim.log

test:
	./scripts/analyze.sh test_data/sample_pass.log
	./scripts/analyze.sh test_data/sample_fail.log || true

report:
	./scripts/generate_report.sh

html:
	./scripts/generate_html_report.sh test_data/sample_sim.log

clean:
	rm -rf output/*

setup:
	./scripts/setup_env.sh

help:
	@echo "make all     - analyze all logs"
	@echo "make test    - run tests"
	@echo "make report  - generate reports"
	@echo "make html    - generate HTML report"
	@echo "make clean   - cleanup outputs"
	@echo "make setup   - check tools"