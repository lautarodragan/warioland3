#!/usr/bin/env python3
"""Check that the book only names code identifiers that exist.

    python3 tools/check_book_names.py

Every `code span` in book/src/*.md is scanned for things that look like
labels, constants or RAM names (CamelCase, `wFoo`/`hFoo`/`rFOO`, `FOO_BAR`,
`.local`, `Routine.local`), and for paths into the repo. Each one must exist:
names somewhere in src/, tests/ or tools/, paths on disk. Names that a page
mentions on purpose although they're gone (history, old names next to new
ones) go in book/names-ignore.txt, one per line.

book/src/naming-survey.md is skipped: it's a record of old names.

Exits non-zero, listing page:line and the name, when something is missing.
"""

import bisect
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BOOK = ROOT / "book" / "src"
SKIP = {"naming-survey.md"}
IGNORE_FILE = ROOT / "book" / "names-ignore.txt"

IDENT = re.compile(r"[A-Za-z_.][A-Za-z0-9_.]*")
PATH = re.compile(r"^(?:src|tests|tools|book|\.github)/[\w./*-]*$|^[\w.-]+(?:/[\w.*-]+)+\.\w+$")
FILE = re.compile(r"^[\w.-]+\.(?:asm|inc|link|py|yml|md|png|tilemap|attrmap|txt|sha1)$")
# files the build makes, which a fresh checkout doesn't have
GENERATED = {"warioland3.gbc", "warioland3.sym", "warioland3.map", "base.gbc", "tests/output"}


def code_identifiers():
    """Every identifier that appears in the code, and every part of a
    dotted one (Routine.local gives Routine, .local and Routine.local)."""
    names = set()
    for pattern in ("src/**/*.asm", "src/**/*.inc", "src/**/*.link", "tests/**/*.py", "tools/**/*.py",
                    "Makefile", ".github/workflows/*.yml"):
        for f in ROOT.glob(pattern):
            for tok in re.findall(r"[A-Za-z_.][A-Za-z0-9_.]*", f.read_text(errors="replace")):
                names.add(tok)
                for i, part in enumerate(tok.split(".")):
                    if part:
                        names.add(part if i == 0 else "." + part)
    return names


def looks_like_name(tok):
    """Whether a token in a code span is meant as a code identifier."""
    bare = tok.lstrip(".")
    if not bare or bare[0].isdigit():
        return False
    if "." in bare:  # Routine.local
        return True
    if tok.startswith("."):  # .local
        return len(bare) > 1
    if re.fullmatch(r"[whrvs][A-Z0-9][A-Za-z0-9_]*", bare):  # wFoo, hFoo, rLCDC, v0Tiles0, sFoo
        return True
    if re.fullmatch(r"[A-Z][A-Z0-9]*(?:_[A-Z0-9]+)+", bare):  # FOO_BAR
        return True
    if re.fullmatch(r"[A-Z][a-z0-9]+(?:[A-Z_][A-Za-z0-9]*)+", bare):  # CamelCase, Foo_Bar
        return True
    return False


def tracked_files():
    out = subprocess.run(["git", "ls-files"], cwd=ROOT, capture_output=True, text=True).stdout.split()
    return out or [str(p.relative_to(ROOT)) for p in ROOT.rglob("*") if p.is_file()]


def known(tok, names, ordered):
    """Whether tok names something in the code: the name itself, every part of
    a dotted name, or the start of a family of names (`wPendingDMA` for
    `wPendingDMALength`..., `ObjInteraction_` for `ObjInteraction_Touch`...)."""
    if tok in names:
        return True
    if "." in tok.lstrip("."):
        head, *rest = tok.split(".")
        return (not head or known(head, names, ordered)) and all(
            known("." + r, names, ordered) for r in rest if r)
    i = bisect.bisect_left(ordered, tok)
    return i < len(ordered) and ordered[i].startswith(tok) and ordered[i] != tok


def main():
    names = code_identifiers()
    ordered = sorted(names)
    files = tracked_files()
    basenames = {f.rsplit("/", 1)[-1] for f in files}
    ignore = set()
    if IGNORE_FILE.exists():
        ignore = {l.strip() for l in IGNORE_FILE.read_text().splitlines() if l.strip() and not l.startswith("#")}
    problems = []
    for page in sorted(BOOK.glob("*.md")):
        if page.name in SKIP:
            continue
        in_block = False
        for n, line in enumerate(page.read_text().splitlines(), 1):
            if line.lstrip().startswith("```"):
                in_block = not in_block
                continue
            spans = [line] if in_block else re.findall(r"`([^`]+)`", line)
            for span in spans:
                for chunk in re.split(r"[\s,()\[\]{}|=+*<>:;\"']+", span):
                    if not chunk:
                        continue
                    chunk = chunk.split(":")[0] if re.search(r"\.\w+:\d", chunk) else chunk  # file.asm:123
                    if in_block:
                        pass
                    elif PATH.match(chunk):
                        p = chunk.rstrip("/")
                        if "*" not in p and p not in GENERATED and not (ROOT / p).exists() and not any(f.endswith("/" + p) for f in files):
                            problems.append((page.name, n, chunk, "path"))
                        continue
                    elif FILE.match(chunk):
                        if chunk not in basenames and chunk not in GENERATED and chunk not in ignore:
                            problems.append((page.name, n, chunk, "file"))
                        continue
                    for tok in IDENT.findall(chunk):
                        if tok.startswith("..."):  # an abbreviation: `...Left`
                            continue
                        tok = tok.rstrip(".")
                        if tok in ignore or not looks_like_name(tok):
                            continue
                        if not known(tok, names, ordered):
                            problems.append((page.name, n, tok, "name"))
    for page, n, tok, kind in problems:
        print(f"book/src/{page}:{n}: {kind} `{tok}` not found")
    if problems:
        print(f"{len(problems)} problem(s). Fix the page, or list intentional old names in book/names-ignore.txt.")
        return 1
    print("book names OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
