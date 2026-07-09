#!/bin/bash
set -euo pipefail

INPUT="$1"
OUTPUT="output/report.html"

mkdir -p output

PASS=$(grep -c "TEST PASS" "$INPUT" || true)
FAIL=$(grep -c "TEST FAIL" "$INPUT" || true)
TOTAL=$(grep -c "TEST START" "$INPUT" || true)

cat > "$OUTPUT" <<EOF
<html>
<head><title>RISC-V Report</title></head>
<body>
<h1>Log Analysis Report</h1>

<ul>
<li>Total: $TOTAL</li>
<li>Pass: $PASS</li>
<li>Fail: $FAIL</li>
</ul>

</body>
</html>
EOF

echo "HTML report generated: $OUTPUT"