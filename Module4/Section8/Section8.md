# Section8
## TASK 8: F = Σm(1,2,3,6,7) Using a 4x1 MUX

### Step 1: Full Truth Table

| Minterm | a | b | c | F |
|---------|---|---|---|:---:|
| 0 | 0 | 0 | 0 | 0 |
| 1 | 0 | 0 | 1 | 1 |
| 2 | 0 | 1 | 0 | 1 |
| 3 | 0 | 1 | 1 | 1 |
| 4 | 1 | 0 | 0 | 0 |
| 5 | 1 | 0 | 1 | 0 |
| 6 | 1 | 1 | 0 | 1 |
| 7 | 1 | 1 | 1 | 1 |

---

### Step 2: MUX Implementation Derivation

**Select lines**: `a` (MSB) and `b` (LSB of select)

Group truth table rows by `a, b`:

| a | b | Rows | F as function of c | Data Input |
|---|---|------|-------------------|:---:|
| 0 | 0 | m0=0, m1=1 | F = c | **d0 = c** |
| 0 | 1 | m2=1, m3=1 | F = 1 | **d1 = 1** |
| 1 | 0 | m4=0, m5=0 | F = 0 | **d2 = 0** |
| 1 | 1 | m6=1, m7=1 | F = 1 | **d3 = 1** |

So,**Data inputs**: `{d3, d2, d1, d0} = {1, 0, 1, c}`

---

## TASK 8 Extension: 3-Bit Majority Function Using Cascaded 2:1 MUXes

### Truth Table (Majority: output = 1 when 2 or more inputs are 1)

| a | b | c | Majority |
|---|---|---|:---:|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | 0 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 1 |
| 1 | 1 | 1 | 1 |

---