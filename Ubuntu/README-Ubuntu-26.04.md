# Installing eSim 2.5 on Ubuntu 26.04 LTS (resolute)

Task 4 (eSim Upgradation), eSim Semester Long Internship, Autumn 2026.
Author: Mohd Mujtaba Qureshi (GitHub: mohdmujtaba5200)

Result: eSim 2.5 installs and starts on Ubuntu 26.04.1 LTS. The full report with
screenshots is in this folder: `eSim_Ubuntu_26.04_Task4_Report.pdf`.

Tested on: AWS EC2 t3.medium, Ubuntu 26.04.1 LTS, kernel 7.0.0-aws, Python 3.14,
GCC 15, LLVM 21.1.8 (default), KiCad 9.0.8 (distribution package).
Note: the task names Ubuntu 25.04; I used 26.04 (newest LTS), which shows the
same class of problems plus a few more.

## Issues found (15)

| # | Issue | Stage | Status |
|---|-------|-------|--------|
| 1 | Windows (CRLF) line endings break the scripts | Startup | Fixed (`dos2unix`) |
| 2 | Version router has no 26.04 case | Startup | Workaround (wrapper) |
| 3 | Base build/Python packages missing on a server image | Dependencies | Fixed (apt command) |
| 4 | Malformed `apt xz-utils` call blocks volare | SKY130 | Fixed |
| 5 | KiCad 6.0 PPA has no `resolute` release (404) | KiCad | Fixed |
| 6 | `Ubuntu/` lacks library/src/images/Examples/scripts/nghdl.zip | KiCad library | Workaround |
| 7 | `unzip` not installed | NGHDL | Fixed |
| 8 | NGHDL installer rejects 26.04 | NGHDL | Fixed |
| 9 | `libcanberra-gtk-module` removed from Ubuntu | NGHDL | Fixed |
| 10 | GHDL 4.1.0 `configure`: "Unhandled version llvm 21.1.8" | NGHDL | Fixed (LLVM 18) |
| 11 | ngspice build fails on GCC 15 (C23 `bool`) | NGHDL | Fixed (`-std=gnu17`) |
| 12 | volare: `Permission denied: '/usr/share/local'` | SKY130 | Fixed |
| 13 | Installer cannot be re-run after a failure | NGHDL | Workaround |
| 14 | `~/Desktop` missing, final shortcut copy fails | Last step | Fixed |
| 15 | Splash screen hides the workspace dialog under VNC | First launch | Workaround |

Issues 1, 2, 4, 5, 7, 8, 9, 10, 11, 12 and 14 are in commit `49643ce`
(files: `Ubuntu/install-eSim.sh`, `Ubuntu/install-eSim-scripts/install-eSim-24.04.sh`).
Each issue's symptom, root cause, fix and evidence is in the PDF report.

## Reproduce on a fresh Ubuntu 26.04 machine

```bash
sudo apt update
sudo apt install -y git dos2unix unzip xz-utils python3-virtualenv \
  python3-dev python3-pip build-essential curl wget
git clone -b installers https://github.com/mohdmujtaba5200/eSim.git
cd eSim/Ubuntu
# until the Ubuntu folder ships its own app files (issue 6):
for d in library src images Examples scripts nghdl.zip; do cp -r ../MacOS/$d . ; done
mkdir -p ~/Desktop
./install-eSim.sh --install
```

Answer `n` to the proxy question and to the optional IHP PDK. On a t3.medium the
GHDL, ngspice and Verilator builds take roughly 30 to 40 minutes.

If you run eSim over VNC and it seems stuck on the splash screen, a workspace
dialog is hidden behind it (issue 15): hide the splash with
`xdotool windowunmap <splash-window-id>` and click OK.

## Known limitations

- Issue 2 is a workaround: the wrapper reuses the 24.04 script by setting the
  version variables. A proper fix adds a 26.04 case to the router.
- Issues 6, 13 and 15 are documented workarounds, not part of the commit.
- KiCad 9.0.8 comes from the distribution. The installer still copies its symbol
  table to `~/.config/kicad/6.0`, while KiCad 9 reads `~/.config/kicad/9.0`.
  Whether eSim's custom KiCad symbols load correctly on KiCad 9 is not verified.
- The optional IHP Open PDK was skipped.
