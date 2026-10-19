# Bash Battle Arena ⚔️

## Overview

This folder contains my solutions to 15 Bash scripting challenges completed as part of my DevOps learning journey.

Bash Battle Arena is a series of progressively challenging exercises designed to develop practical Bash scripting skills, from basic file management to automation and system administration.

Every five levels includes a **Boss Battle**, combining concepts covered in previous challenges.

## Challenges

### Level 1 — Directory Creation
**Objective:** Create an `Arena` directory containing three text files (`warrior.txt`, `mage.txt`, and `archer.txt`) and display its contents.

**Skills practised:** `mkdir`, `cd`, `touch`, `ls`

**Solution:** [Level 1](level-01-directory-creation.sh)

---

### Level 2 — Variables and Loops
**Objective:** Write a script that prints the numbers 1 to 10, each on a separate line.

**Skills practised:** Variables, `for` loops, `echo`

**Solution:** [Level 2](level-02-variables-and-loops.sh)

---

### Level 3 — File Existence Check
**Objective:** Check whether `hero.txt` exists inside the `Arena` directory and display an appropriate message.

**Skills practised:** `if/else`, file testing, `echo`

**Solution:** [Level 3](level-03-file-existence-check.sh)

---

### Level 4 — File Backup
**Objective:** Create a `Backup` directory and copy all `.txt` files from `Arena` into it.

**Skills practised:** `mkdir`, `cp`, wildcards

**Solution:** [Level 4](level-04-file-backup.sh)

---

### Level 5 — Boss Battle: Combining Basics
**Objective:** Create a `Battlefield` directory containing three character files, check for `knight.txt`, move it to an `Archive` directory if present, and list the contents of both directories.

**Skills practised:** Directory creation, file manipulation, conditional statements, `mv`, `ls`

**Solution:** [Level 5](level-05-boss-battle-basics.sh)

---

### Level 6 — Argument Parsing
**Objective:** Accept a filename as a command-line argument and display its line count. If no filename is provided, display an error message.

**Skills practised:** Positional parameters (`$1`), `if/else`, `wc -l`

**Solution:** [Level 6](level-06-argument-parsing.sh)

---

### Level 7 — File Size Sorting
**Objective:** List all `.txt` files in a directory, sorted by file size from smallest to largest.

**Skills practised:** File listing, sorting, command options

**Solution:** [Level 7](level-07-file-size-sorting.sh)

---

### Level 8 — Log File Searcher
**Objective:** Search multiple `.log` files for a specified word or phrase and display the filenames containing a match.

**Skills practised:** `grep`, pattern matching, file searching

**Solution:** [Level 8](level-08-log-file-searcher.sh)

---

### Level 9 — Directory Monitoring
**Objective:** Monitor a directory for file creation, modification and deletion, recording detected changes with timestamps.

**Skills practised:** Loops, file monitoring, timestamps, logging

**Solution:** [Level 9](level-09-directory-monitoring.sh)

---

### Level 10 — Boss Battle: Intermediate Scripting
**Objective:** Create five text files containing randomly generated numbers of lines, sort them by size, and move any files containing `Victory` into a separate archive.

**Skills practised:** Loops, random numbers, file manipulation, sorting, conditional statements, text searching

**Solution:** [Level 10](level-10-boss-battle-intermediate.sh)

---

### Level 11 — Disk Space Monitor
**Objective:** Check the disk space usage of a specified directory and generate an alert when usage exceeds a defined threshold.

**Skills practised:** Disk usage commands, variables, numeric comparisons, conditional statements

**Solution:** [Level 11](level-11-disk-space-monitor.sh)

---

### Level 12 — Configuration File Parser
**Objective:** Read a configuration file containing `KEY=VALUE` pairs and display each key alongside its corresponding value.

**Skills practised:** File reading, `while` loops, `read`, string manipulation

**Solution:** [Level 12](level-12-config-file-parser.sh)

---

### Level 13 — Backup Rotation
**Objective:** Automate directory backups while retaining only the five most recent backups and removing older ones.

**Skills practised:** Backup automation, timestamps, loops, conditional statements, file management

**Solution:** [Level 13](level-13-backup-rotation.sh)

---

### Level 14 — Interactive System Menu
**Objective:** Develop an interactive menu that allows users to perform common system administration tasks, including checking disk space, viewing uptime and listing users.

**Skills practised:** User input, `case` statements, loops, system commands

**Solution:** [Level 14](level-14-interactive-system-menu.sh)

---

### Level 15 — Boss Battle: Advanced Scripting
**Objective:** Combine multiple system administration tasks into a single interactive Bash script, allowing users to:

- Check disk space usage.
- Display system uptime.
- Back up the `Arena` directory while retaining the three most recent backups.
- Parse and display values from `settings.conf`.

**Skills practised:** Functions, menus, conditional statements, loops, backup rotation, configuration parsing, automation

**Solution:** [Level 15](level-15-boss-battle-advanced.sh)

---

## Key Takeaways

Through these challenges, I developed and reinforced my understanding of:

- **Bash fundamentals:** Variables, loops, conditionals and functions.
- **File management:** Creating, moving, copying, searching and organising files.
- **Automation:** Writing scripts to handle repetitive tasks.
- **System administration:** Monitoring disk usage, managing backups and working with configuration files.
- **Problem-solving:** Breaking down technical requirements into smaller, manageable steps.
- **Debugging:** Identifying errors and improving scripts through testing.
