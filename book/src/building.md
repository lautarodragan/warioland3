# Building and patching

## Building

You need [RGBDS](https://github.com/gbdev/rgbds/releases) 1.0.0 and Python 3.

```nu
make            # warioland3.gbc, with its .sym and .map
make DEBUG=1    # the same, assembled with -E (every label exported)
```

The tests look symbols up by name in `warioland3.sym`. CI builds with
`make DEBUG=1`.

This fork changes the game, so its ROM no longer matches the original's SHA1,
and the repo no longer has the `compare` target or `rom.sha1` (only the
commit `make ips` rebuilds the original from does). To check that a change didn't alter the ROM,
compare against a ROM you built before the change (see
[Changing the code safely](working-with-the-code.md)).

After editing a macro or an `INCLUDE`d file, stale objects can survive. If the
build behaves strangely, `rm src/*.o` and build again.

## The IPS patch

```nu
make ips
```

This builds the modified ROM, rebuilds the *original* ROM from the commit
before the debug menu (`base_ref` in the Makefile; that commit's own
`make compare` checks it against its `rom.sha1`), diffs the two and
writes `warioland3-debug-menu.ips` with `tools/make_ips.py`. The patch applies
to a Wario Land 3 ROM with SHA1 `bb7877309834441fd03adb7fa65738e5d5b2d7ba`.

## CI

| Workflow | When | What |
|---|---|---|
| `build-and-test.yml` | push to master, pull requests (not when only `book/` changed) | builds with `DEBUG=1`, fails if the build changed tracked files, runs `make test`, uploads `tests/output/` on failure |
| `release.yml` | a `v*` tag, or by hand | builds the IPS patch and publishes a GitHub Release with only the patch (never the ROM) |
| `book.yml` | push to master touching `book/` | builds this book and publishes it to GitHub Pages |
