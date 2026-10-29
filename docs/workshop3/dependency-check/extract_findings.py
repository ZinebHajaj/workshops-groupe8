#!/usr/bin/env python3
import csv
import json
import sys

path = sys.argv[1]

with open(path, encoding="utf-8") as f:
    report = json.load(f)

writer = csv.writer(
    sys.stdout,
    delimiter="\t",
    lineterminator="\n"
)

writer.writerow([
    "dependency",
    "file",
    "vulnerability",
    "severity",
    "cvss",
    "source"
])

for dep in report.get("dependencies", []):
    dep_name = dep.get("fileName", "")
    dep_file = dep.get("filePath", "")

    for vuln in dep.get("vulnerabilities") or []:
        score = ""

        for key in ("cvssv4", "cvssv3", "cvssv2"):
            data = vuln.get(key) or {}
            value = data.get("baseScore", data.get("score"))

            if value is not None:
                score = str(value)
                break

        writer.writerow([
            dep_name,
            dep_file,
            vuln.get("name", ""),
            vuln.get("severity", ""),
            score,
            vuln.get("source", ""),
        ])
