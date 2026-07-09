#!/bin/bash
set -euo pipefail

mkdir -p output

./scripts/analyze.sh test_data/sample_pass.log --output output/pass_report.txt
./scripts/analyze.sh test_data/sample_fail.log --output output/fail_report.txt
./scripts/analyze.sh test_data/sample_sim.log --output output/sim_report.txt

echo "Reports saved to output/ directory !!!"