#!/usr/bin/env python3
from pathlib import Path
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]

required = [
    "docker/Dockerfile",
    "docker/scripts/course-entrypoint",
    "docker/scripts/hadoop-healthcheck",
    "docker/scripts/lab-status",
    "docker/scripts/lab-submit",
    "docker/scripts/verify-datasets",
    "docker/hadoop-conf/core-site.xml",
    "docker/hadoop-conf/hdfs-site.xml",
    "docker/hadoop-conf/mapred-site.xml",
    "docker/hadoop-conf/yarn-site.xml",
    ".github/workflows/image.yml",
]

for relative in required:
    assert (ROOT / relative).is_file(), f"missing {relative}"

for relative in required[6:10]:
    ET.parse(ROOT / relative)

dockerfile = (ROOT / "docker/Dockerfile").read_text(encoding="utf-8")
assert "FROM ghcr.io/apache/hadoop:3.5.0@sha256:" in dockerfile
assert 'ENTRYPOINT ["/usr/local/bin/course-entrypoint"]' in dockerfile
assert "ln -sfn" in dockerfile, "examples JAR alias must be idempotent"

print("Image repository contracts are valid.")
