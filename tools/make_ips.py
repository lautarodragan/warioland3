#!/usr/bin/env python3
"""Create an IPS patch from the byte differences between two files.

Usage: make_ips.py <original> <modified> <out.ips>

IPS only stores the bytes that differ, so the resulting patch carries none of
the original ROM's data on its own -- it is useless without a copy of the
original game. That is what makes a patch safe to distribute where shipping the
full (copyrighted) ROM would not be.
"""

import sys

IPS_HEADER = b"PATCH"
IPS_FOOTER = b"EOF"
MAX_RECORD = 0xFFFF  # record size field is 2 bytes
EOF_OFFSET = 0x454F46  # an offset literally equal to b"EOF"; not addressable


def diff_records(original, modified):
    """Yield (offset, data) records covering every run of differing bytes."""
    if len(modified) < len(original):
        raise SystemExit("modified file is smaller than original; unsupported")

    i = 0
    n = len(modified)
    while i < n:
        orig_byte = original[i] if i < len(original) else None
        if i < len(original) and modified[i] == orig_byte:
            i += 1
            continue

        start = i
        while i < n and (i >= len(original) or modified[i] != original[i]):
            i += 1
        run = modified[start:i]

        # IPS offsets cannot equal the bytes "EOF"; nudge the record back one
        # byte (re-emitting one matching byte) if we land exactly on it.
        if start == EOF_OFFSET and start > 0:
            start -= 1
            run = modified[start:i]

        for off in range(0, len(run), MAX_RECORD):
            yield start + off, run[off:off + MAX_RECORD]


def build_patch(original, modified):
    out = bytearray(IPS_HEADER)
    for offset, data in diff_records(original, modified):
        if offset > 0xFFFFFF:
            raise SystemExit("offset exceeds 16 MiB; IPS cannot address it")
        out += offset.to_bytes(3, "big")
        out += len(data).to_bytes(2, "big")
        out += data
    out += IPS_FOOTER
    return bytes(out)


def main(argv):
    if len(argv) != 4:
        raise SystemExit(__doc__)
    with open(argv[1], "rb") as f:
        original = f.read()
    with open(argv[2], "rb") as f:
        modified = f.read()
    patch = build_patch(original, modified)
    with open(argv[3], "wb") as f:
        f.write(patch)
    print(f"wrote {argv[3]} ({len(patch)} bytes)")


if __name__ == "__main__":
    main(sys.argv)
