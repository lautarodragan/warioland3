#!/usr/bin/env python3
"""Draw the treasure graph: what each of the 100 treasures needs, the main
line to the Gold Music Box, and the branches that open off it.

    python3 tools/treasure_graph.py            # rewrite book/src/treasure-graph.html and -review.md
    python3 tools/treasure_graph.py --check    # exit 1 if it's out of date
    python3 tools/treasure_graph.py --dump     # print the graph as text

A treasure needs two things:

- its level open on the map. That's game data, read by tools/treasure_map.py
  (EventTreasures, OWSceneParams, UnlockableConnections): the treasures of
  the event that opens the level.
- whatever its key and chest need inside the level: a power-up, or another
  treasure's change of the level. That's level layout, which the game data
  doesn't say directly; tools/treasure_requirements.json has it, with the
  source of each (a guide, or the game data: which variant changes and
  power-up flashes of the level come before the chest).

A power-up need means that power-up level or higher: wPowerUpLevel is one
number. The script checks that the needs leave the power-ups in order
(SetTreasureTransitionParam sets the level to the new power-up's, so one
taken out of order would lower it), that every treasure can be reached,
and that the hint order (EventTreasures) never asks for a treasure before
what it needs.

The main line is the Gold Music Box and everything it needs, in the hint
order. Every other treasure is a branch, drawn at the latest main-line
treasure it needs, directly or through other branches: the earliest point
of the main line where it can be taken.
"""

import argparse
import json
import sys
from html import escape
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import treasure_map as tm  # noqa: E402

ROOT = tm.ROOT
REQS = ROOT / "tools" / "treasure_requirements.json"
PAGE = ROOT / "book" / "src" / "treasure-graph.html"
REVIEW = ROOT / "book" / "src" / "treasure-graph-review.md"
GOAL = "GOLD_MUSIC_BOX"

# what the map buttons do: the event tables say "opens nothing"
EXTRA_EFFECTS = {
    "EVENT_MAGNIFYING_GLASS": "map button: B shows which chests of the selected level Wario has (wHasMagnifyingGlass)",
    "EVENT_DAY_OR_NIGHT_SPELL": "map button: switch day and night (SetDayNightSpellSelectable)",
}


def build(d, steps, reqs):
    pos = tm.numbering(steps)
    event_of = {t: s for s in steps for t in s["treasures"]}
    opened_by = {l: s for s in steps for l in s["new_levels"]}
    problems = []

    deps, open_deps, need = {}, {}, {}
    for t in d.order:
        level = d.where[t][0]
        r = reqs[t]
        if r["level"] != d.code(level):
            problems.append(f"{t}: requirements say {r['level']}, the game puts it in {d.code(level)}")
        for n in r["needs"]:
            if n not in d.where:
                problems.append(f"{t}: unknown treasure {n}")
        open_deps[t] = list(opened_by[level]["treasures"])
        need[t] = {n: need_kind(v) for n, v in r["needs"].items()}
        for n, kind in need[t].items():
            if kind not in KINDS:
                problems.append(f"{t}: need {n} has an unknown source {kind!r} (one of {', '.join(KINDS)})")
        deps[t] = list(dict.fromkeys(open_deps[t] + list(need[t])))

    # the hint order never asks for something before what it needs
    for t in d.order:
        for n in deps[t]:
            if pos[n] > pos[t]:
                problems.append(f"{t} (#{pos[t]}) needs {n} (#{pos[n]}), which the hint gives later")

    # ancestors, with a cycle check
    anc = {}

    def ancestors(t, stack=()):
        if t in anc:
            return anc[t]
        if t in stack:
            problems.append("cycle: " + " -> ".join(stack + (t,)))
            return set()
        out = set()
        for n in deps[t]:
            out |= {n} | ancestors(n, stack + (t,))
        anc[t] = out
        return out

    for t in d.order:
        ancestors(t)

    # the same without the heuristic's edges: how early it may be
    firm_anc = {}

    def firm(t):
        if t not in firm_anc:
            firm_anc[t] = set()
            for n in open_deps[t] + [n for n, k in need[t].items() if k != HEURISTIC]:
                firm_anc[t] |= {n} | firm(n)
        return firm_anc[t]

    for t in d.order:
        firm(t)

    # power-ups: each needs the one before it, so the level only goes up
    powers = sorted(d.power, key=d.power.get)
    for a, b in zip(powers, powers[1:]):
        if a not in anc[b]:
            problems.append(f"{d.treasure_name(b)} can be taken before {d.treasure_name(a)}: the power-up level would go down")

    # greedy play: take everything that can be taken, round by round, with
    # the map opened by real reachability (not only the opening event)
    held, rounds = set(), {}
    for rnd in range(1, 101):
        edges = []
        for ev in d.events:
            ts = d.event_treasures[ev]
            if ev == "EVENT_PROLOGUE" or (ts and set(ts) <= held):
                for act in d.scenes.get(ev, []):
                    if act[0] == "unlock":
                        edges.extend(tm.connection_edges(d, act[1], act[2], act[3]))
        open_levels = tm.reachable(d, edges)
        best = max([d.power[t] for t in held if t in d.power] or [0])
        take = [t for t in d.order if t not in held and d.where[t][0] in open_levels
                and all((n in held) if n not in d.power else best >= d.power[n] for n in need[t])]
        if not take:
            break
        for t in take:
            rounds[t] = rnd
        held |= set(take)
    for t in d.order:
        if t not in rounds:
            problems.append(f"{t} can never be taken")
        elif any(rounds.get(n, 999) >= rounds[t] for n in deps[t]):
            problems.append(f"{t} is taken before something it needs (round {rounds[t]})")

    main = [t for t in d.order if t == GOAL or t in anc[GOAL]]
    main_set = set(main)
    nodes = []
    for t in d.order:
        level, colour = d.where[t]
        s = event_of[t]
        main_anc = [a for a in anc[t] if a in main_set]
        anchor = max(main_anc, key=lambda a: pos[a]) if main_anc else None
        firm_main = [a for a in firm_anc[t] if a in main_set]
        firm_anchor = max(firm_main, key=lambda a: pos[a]) if firm_main else None
        effect = tm.effect_text(d, s, long=True)
        if s["event"] in EXTRA_EFFECTS:
            effect = EXTRA_EFFECTS[s["event"]]
        with_ = [x for x in s["treasures"] if x != t]
        r = reqs[t]
        nodes.append(dict(
            id=t, n=pos[t], name=d.treasure_name(t), code=d.code(level), level=d.level_name(level),
            colour=colour, power=d.power.get(t, 0), music=t.endswith("_MUSIC_BOX"),
            main=t in main_set, anchor=pos[anchor] if anchor else 0, firm=pos[firm_anchor] if firm_anchor else 0,
            open=open_deps[t], need=need[t], deps=deps[t], verified=r.get("verified"),
            status=r["status"], note=r.get("note", ""), sources=r["sources"], check=r.get("check", ""),
            effect=effect, with_=with_, round=rounds.get(t, 0),
            side=next((sd for sd, e in d.side_events if e == s["event"]), None),
        ))
    return nodes, main, problems


def need_kind(v):
    """A need's source: a string, or {"by": ..., "note": ...}."""
    return v["by"] if isinstance(v, dict) else v


def heuristic_check(d, steps, reqs):
    """The heuristic: a power-up that flashes a level on the map opens the
    lowest-colour chest there that can't be taken yet. "Can be taken" means
    hinted before the power-up, or every need of the chest inside the level
    (from the requirements file, leaving out this power-up) already met by
    the treasures hinted before it. One row per flash: (power-up, level,
    the chest it predicts, the chests the requirements give the power-up to
    with the source of that edge)."""
    pos = tm.numbering(steps)
    rows = []
    for s in steps:
        ts = s["treasures"]
        if len(ts) != 1 or ts[0] not in d.power:
            continue
        p = ts[0]
        held = {t for t in d.order if pos[t] < pos[p]}
        best = max([d.power[t] for t in held if t in d.power] or [0])

        def takeable(c):
            if c in held:
                return True
            needs = reqs[c]["needs"]
            return p not in needs and all(
                (n in held) if n not in d.power else best >= d.power[n] for n in needs)

        for level in s["highlights"]:
            if level == "THE_TEMPLE":
                continue
            chests = d.level_treasures[level]
            pred = next((c for c in chests if not takeable(c)), None)
            given = [(c, need_kind(reqs[c]["needs"][p])) for c in chests if p in reqs[c]["needs"]]
            rows.append((p, level, pred, given))
    return rows


def edge_counts(nodes):
    counts = {"game data (level open)": 0}
    for nd in nodes:
        counts["game data (level open)"] += len(nd["open"])
        for kind in nd["need"].values():
            counts[kind] = counts.get(kind, 0) + 1
    return counts


def review(d, nodes, hrows):
    """The treasures to check in the game: uncertain ones, ones with a
    heuristic edge, and ones where the heuristic and a guide disagree."""
    by_id = {nd["id"]: nd for nd in nodes}
    why = {}
    for p, level, pred, given in hrows:
        ids = [c for c, _ in given]
        if pred not in ids:
            pn = d.treasure_name(p)
            for c, kind in given:
                why.setdefault(c, []).append(
                    f"the heuristic gives the {pn} flash of {d.code(level)} to the "
                    f"{d.where[pred][1] if pred else '-'} chest ({d.treasure_name(pred) if pred else 'none'}), the {kind} to this one")
            if pred:
                why.setdefault(pred, []).append(
                    f"the heuristic says the {pn} flash of {d.code(level)} opens this chest; "
                    + (f"the requirements give it to {', '.join(d.treasure_name(c) for c, _ in given)}" if given else "nothing else claims it"))
    out = []
    for nd in nodes:
        if nd["verified"]:
            continue
        reasons = list(why.get(nd["id"], []))
        if nd["status"] == "uncertain":
            reasons.insert(0, "sources missing or not conclusive")
        if any(k == HEURISTIC for k in nd["need"].values()):
            reasons.append("an edge comes only from the heuristic")
        if not reasons:
            continue
        chest = f"the {nd['colour']} chest of {nd['code']}"
        checks = [f"Can {chest} ({nd['name']}) be reached without the {by_id[n]['name']}?" for n in nd["need"]]
        if not nd["need"]:
            checks = [f"Can {chest} ({nd['name']}) be reached as soon as {nd['code']} opens, with no power-up, by day and by night?"]
        if nd["check"]:
            checks.append(nd["check"])
        out.append(dict(id=nd["id"], reasons=reasons, checks=checks))
    return out


# ---------------------------------------------------------------- page

def stage_titles(d, nodes):
    """Headings for the main line: a new one where a map side opens."""
    titles, reached, k = {}, "north", 1
    first = True
    for nd in nodes:
        if not nd["main"]:
            continue
        if first:
            titles[nd["n"]] = f"Stage {k}: the north side"
            first = False
        if nd["side"] and not nd["with_"] or nd["side"] and all(
                x["n"] < nd["n"] for x in nodes if x["id"] in nd["with_"]):
            k += 1
            reached = nd["side"].lower()
            titles[f"after{nd['n']}"] = f"Stage {k}: the {reached} side opens"
    return titles


def recommendations(nodes):
    """Branches that change something (map buttons, new routes) and come much
    earlier than the hint gives them."""
    by_n = {nd["n"]: nd for nd in nodes}
    out = []
    for nd in nodes:
        if nd["main"] or nd["effect"] == "opens nothing":
            continue
        gap = nd["n"] - nd["anchor"]
        if gap >= 10:
            out.append((nd["anchor"], nd, by_n.get(nd["anchor"])))
    return out


def review_entries(d, nodes, rv):
    """Review rows with what each source says, for the page and the list."""
    by_id = {nd["id"]: nd for nd in nodes}
    out = []
    for r in rv:
        nd = by_id[r["id"]]
        needs = ", ".join(f"{by_id[n]['name']} ({k})" for n, k in nd["need"].items()) or "nothing besides the level"
        out.append(dict(nd=nd, needs=needs, reasons=r["reasons"], sources=nd["sources"], checks=r["checks"]))
    return out


def review_html(entries):
    items = []
    for e in entries:
        nd = e["nd"]
        srcs = "".join(
            "<li>" + (f'<a href="{escape(s["url"])}" rel="noopener">{escape(s["by"])}</a>' if s.get("url") else f"<b>{escape(s['by'])}</b>")
            + f": {escape(s['says'])}</li>" for s in e["sources"])
        items.append(
            f'<li class="rv"><button class="link" data-id="{nd["id"]}">{escape(nd["name"])}</button> '
            f'<span class="code">{nd["code"]}</span> {nd["colour"]} chest, hint #{nd["n"]}. '
            f'<span class="dim">Now: needs {escape(e["needs"])}. Why: {escape("; ".join(e["reasons"]))}.</span>'
            f'<ul class="src">{srcs}</ul>'
            f'<p class="chk">Check: {escape(" ".join(e["checks"]))}</p></li>')
    return "\n".join(items) or "<li>Nothing to check.</li>"


def md_cell(text):
    return text.replace("|", "/").replace("\n", " ")


def review_md(entries, counts):
    out = [
        "# Treasure graph: what to check in the game",
        "",
        "The treasures of the [treasure graph](treasure-graph.html) whose needs are",
        "uncertain, rest on the heuristic alone, or where sources disagree. Each row",
        "says what each source says and what to try in the game. Record the answer in",
        "tools/treasure_requirements.json (as the \"about\" lines at its top say:",
        "\"verified in game by Taro\", with a note) and run",
        "python3 tools/treasure_graph.py, which rewrites the graph and this list.",
        "",
        "Where the graph's edges come from: " + ", ".join(f"{k}: {v}" for k, v in counts.items()) + ".",
        "",
        "| Treasure | Level, chest | Now needs | Why it's here | What the sources say | Check in the game |",
        "|---|---|---|---|---|---|",
    ]
    for e in entries:
        nd = e["nd"]
        srcs = "<br>".join(
            (f"[{s['by']}]({s['url']})" if s.get("url") else s["by"]) + ": " + s["says"] for s in e["sources"])
        out.append(f"| {nd['name']} (#{nd['n']}) | {nd['code']} {nd['level']}, {nd['colour']} | {md_cell(e['needs'])} | "
                   f"{md_cell('; '.join(e['reasons']))} | {md_cell(srcs)} | {md_cell(' '.join(e['checks']))} |")
    if not entries:
        out.append("| - | - | - | nothing left to check | - | - |")
    return "\n".join(out) + "\n"


def html_page(d, nodes, main, problems, hrows, rv):
    data = json.dumps(nodes, ensure_ascii=False, separators=(",", ":"))
    titles = stage_titles(d, nodes)
    recs = recommendations(nodes)
    rec_items = []
    for anchor, nd, an in recs:
        where = f"after #{anchor} {escape(an['name'])}" if an else "from the start"
        flag = " (uncertain)" if nd["status"] == "uncertain" else ""
        rec_items.append(
            f'<li><button class="link" data-id="{nd["id"]}">{escape(nd["name"])}</button> '
            f'<span class="code">{nd["code"]}</span>: {where}{flag}, hinted #{nd["n"]}. '
            f'<span class="dim">{escape(nd["effect"])}</span></li>')
    n_main = len(main)
    entries = review_entries(d, nodes, rv)
    ecounts = edge_counts(nodes)
    agree = sum(1 for p, level, pred, given in hrows if pred in [c for c, _ in given])
    counts = {s: sum(1 for x in nodes if x["status"] == s) for s in ("guide", "data", "uncertain")}
    return (TEMPLATE
            .replace("%DATA%", data)
            .replace("%TITLES%", json.dumps(titles))
            .replace("%RECS%", "\n".join(rec_items))
            .replace("%NMAIN%", str(n_main))
            .replace("%NSIDE%", str(len(nodes) - n_main))
            .replace("%NGUIDE%", str(counts["guide"]))
            .replace("%NDATA%", str(counts["data"]))
            .replace("%NUNCERTAIN%", str(counts["uncertain"]))
            .replace("%REVIEW%", review_html(entries))
            .replace("%NREVIEW%", str(len(entries)))
            .replace("%EDGES%", escape(", ".join(f"{k}: {v}" for k, v in ecounts.items())))
            .replace("%HEUR%", f"{agree} of {len(hrows)}"))


HEURISTIC = "heuristic (power-up map flash + lowest chest)"
VERIFIED = "verified in game by Taro"
KINDS = ("guide", "game data", HEURISTIC, VERIFIED)

TEMPLATE = r"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Treasure graph</title>
<!-- generated by tools/treasure_graph.py from the game data and tools/treasure_requirements.json; don't edit by hand -->
<style>
:root {
  --bg: #fbfaf7; --panel: #ffffff; --ink: #1d2126; --dim: #5d6670; --line: #c9ced4; --spine: #8a6d00;
  --chip: #ffffff; --chip-border: #d5d9de; --gold: #8a6d00; --sel: #1f6feb; --anc: #b35900; --desc: #1a7f37;
  --grey: #8e98a3; --red: #e5534b; --green: #3fa452; --blue: #4b86e0; --shadow: 0 1px 2px rgba(0,0,0,.08);
}
@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    --bg: #15181c; --panel: #1d2127; --ink: #e6e9ed; --dim: #9aa4ae; --line: #3a414a; --spine: #e0b93b;
    --chip: #22272e; --chip-border: #39414b; --gold: #ffd34d; --sel: #58a6ff; --anc: #ffa657; --desc: #56d364;
    --grey: #a3acb6; --red: #f0645c; --green: #4cc55f; --blue: #5b9cf2; --shadow: none;
  }
}
:root[data-theme="dark"] {
  --bg: #15181c; --panel: #1d2127; --ink: #e6e9ed; --dim: #9aa4ae; --line: #3a414a; --spine: #e0b93b;
  --chip: #22272e; --chip-border: #39414b; --gold: #ffd34d; --sel: #58a6ff; --anc: #ffa657; --desc: #56d364;
  --grey: #a3acb6; --red: #f0645c; --green: #4cc55f; --blue: #5b9cf2; --shadow: none;
}
* { box-sizing: border-box; }
html { -webkit-text-size-adjust: 100%; }
body { margin: 0; background: var(--bg); color: var(--ink); font: 15px/1.45 system-ui, -apple-system, "Segoe UI", Roboto, sans-serif; }
a { color: var(--sel); }
header, .wrap { max-width: 1180px; margin: 0 auto; padding: 0 16px; }
header h1 { font-size: 1.6rem; margin: 20px 0 6px; }
header p { margin: 6px 0; max-width: 62rem; }
.dim { color: var(--dim); }
.code { font: 600 .78rem/1 ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }
details.box, .legend { background: var(--panel); border: 1px solid var(--chip-border); border-radius: 8px; padding: 8px 12px; margin: 10px 0; }
details.box summary { cursor: pointer; font-weight: 600; }
details.box ul { margin: 6px 0; padding-left: 1.2rem; }
details.box ul.recs { columns: 2 34rem; column-gap: 2rem; font-size: .88rem; }
details.box ul.recs li { break-inside: avoid; }
details.box li { margin: 3px 0; }
.legend { display: flex; flex-wrap: wrap; gap: 6px 16px; align-items: center; font-size: .85rem; }
.legend .sw { display: inline-block; width: 12px; height: 12px; border-radius: 3px; vertical-align: -1px; margin-right: 4px; }
button.link { background: none; border: 0; padding: 0; color: var(--sel); font: inherit; cursor: pointer; text-decoration: underline; }
.layout { display: grid; grid-template-columns: minmax(0, 1fr) 330px; gap: 16px; align-items: start; }
#graph { position: relative; padding-bottom: 24px; }
#edges { position: absolute; inset: 0; pointer-events: none; overflow: visible; }
.stage { font-weight: 700; font-size: .95rem; margin: 18px 0 6px 0; padding-left: 2.6rem; color: var(--dim); }
.row { display: grid; grid-template-columns: 2.6rem minmax(0, 15rem) minmax(0, 1fr); gap: 0 10px; position: relative; }
.row .num { text-align: right; padding-top: 7px; font: 600 .78rem/1.2 ui-monospace, Menlo, Consolas, monospace; color: var(--dim); }
.row .spine { position: relative; padding: 3px 0 3px 14px; }
.row .spine::before { content: ""; position: absolute; left: 4px; top: 0; bottom: 0; width: 3px; background: var(--spine); border-radius: 2px; opacity: .55; }
.row .spine::after { content: ""; position: absolute; left: 0; top: 13px; width: 11px; height: 11px; border-radius: 50%; background: var(--bg); border: 3px solid var(--spine); }
.row .eff { font-size: .74rem; color: var(--dim); margin: 1px 0 4px 2px; }
.row .branches { display: flex; flex-wrap: wrap; gap: 4px 6px; padding: 3px 0; align-content: flex-start; border-left: 2px dashed transparent; }
.row .branches:not(:empty) { border-left-color: var(--line); padding-left: 8px; }
.chip { display: inline-flex; align-items: center; gap: 6px; max-width: 100%; text-align: left; background: var(--chip); color: var(--ink);
  border: 1px solid var(--chip-border); border-left: 6px solid var(--c); border-radius: 6px; padding: 3px 8px 3px 6px; cursor: pointer;
  font: inherit; font-size: .84rem; line-height: 1.25; box-shadow: var(--shadow); transition: opacity .15s; }
.chip .code { color: var(--dim); }
.chip .nm { overflow: hidden; text-overflow: ellipsis; }
.chip .tag { color: var(--gold); font-weight: 700; white-space: nowrap; }
.chip .hn { color: var(--dim); font-size: .72rem; white-space: nowrap; }
.chip.uncertain { border-style: dashed; border-left-style: solid; }
.chip.uncertain .nm::after { content: " ?"; color: var(--dim); }
.chip.big { font-weight: 600; }
.chip .via { color: var(--dim); font-size: .72rem; }
.chip:focus-visible { outline: 2px solid var(--sel); outline-offset: 2px; }
#graph.focus .chip { opacity: .28; }
#graph.focus .chip.sel, #graph.focus .chip.anc, #graph.focus .chip.desc { opacity: 1; }
.chip.sel { box-shadow: 0 0 0 2px var(--sel); }
.chip.anc { box-shadow: 0 0 0 2px var(--anc); }
.chip.desc { box-shadow: 0 0 0 2px var(--desc); }
#edges path { fill: none; stroke-width: 2; }
#edges path.need { stroke: var(--anc); }
#edges path.unlock { stroke: var(--desc); stroke-dasharray: 4 3; }
#edges path.need.heur { stroke-dasharray: 2 5; opacity: .6; }
.kind { font-size: .72rem; color: var(--dim); }
.kind.heur { color: var(--anc); font-style: italic; }
.kind.ver { color: var(--desc); font-weight: 700; }
li.rv { margin: 10px 0; }
li.rv .src { font-size: .82rem; margin: 2px 0; }
li.rv .chk { margin: 2px 0; font-size: .86rem; }
aside#panel { position: sticky; top: 12px; background: var(--panel); border: 1px solid var(--chip-border); border-radius: 8px; padding: 12px 14px;
  max-height: calc(100vh - 24px); overflow: auto; font-size: .88rem; }
aside#panel h2 { font-size: 1.1rem; margin: 0 0 4px; }
aside#panel h3 { font-size: .82rem; text-transform: uppercase; letter-spacing: .04em; color: var(--dim); margin: 12px 0 4px; }
aside#panel ul { margin: 0; padding-left: 1.1rem; }
aside#panel li { margin: 2px 0; }
aside#panel .src { font-size: .8rem; }
aside#panel .badge { display: inline-block; font-size: .72rem; font-weight: 700; padding: 1px 6px; border-radius: 10px; border: 1px solid var(--chip-border); }
aside#panel .badge.guide { color: var(--desc); } aside#panel .badge.data { color: var(--sel); } aside#panel .badge.uncertain { color: var(--anc); }
#close { display: none; float: right; background: none; border: 1px solid var(--chip-border); color: var(--ink); border-radius: 6px; font: inherit; padding: 0 8px; cursor: pointer; }
footer { max-width: 1180px; margin: 24px auto; padding: 0 16px; font-size: .8rem; color: var(--dim); }
@media (max-width: 900px) {
  .layout { grid-template-columns: minmax(0, 1fr); }
  aside#panel { position: fixed; left: 8px; right: 8px; bottom: 8px; top: auto; max-height: 48vh; z-index: 5; box-shadow: 0 4px 24px rgba(0,0,0,.35); display: none; }
  aside#panel.open { display: block; }
  #close { display: inline-block; }
  body.panel-open { padding-bottom: 50vh; }
}
@media (max-width: 600px) {
  .row { grid-template-columns: 1.9rem minmax(0, 1fr); }
  .row .branches { grid-column: 2; margin: 0 0 4px 14px; }
  .row .branches:empty { display: none; }
  .stage { padding-left: 1.9rem; }
  .chip { font-size: .8rem; }
}
</style>
</head>
<body>
<header>
<h1>Treasure graph</h1>
<p>What each of Wario Land 3's 100 treasures needs, and the earliest point it can be taken. The
<b>main line</b> (%NMAIN% treasures, down the left) is the Gold Music Box and everything it needs, in the order the
Temple hint gives them. The other %NSIDE% are <b>branches</b>: each one is drawn at the last main-line treasure it
needs, so that's where it becomes available, often long before the hint asks for it (the hint's number is on each chip).</p>
<p class="dim">Tap a treasure: what it needs lights up in orange, what it opens in green, and the panel says why, with sources.
Back to the <a href="treasure-map.html">treasure map</a> page.</p>
<details class="box" open><summary>Worth getting early</summary>
<p class="dim" style="font-size:.84rem;margin:4px 0">Branches that change something on the map and can be taken at least ten places before the hint asks for them.</p>
<ul class="recs">
%RECS%
</ul>
</details>
<details class="box"><summary>To check in the game (%NREVIEW%)</summary>
<p class="dim" style="font-size:.84rem">Uncertain needs, needs that rest on the heuristic alone, and places where sources disagree.
The same list is on the <a href="treasure-graph-review.html">review page</a>; answers go in <code>tools/treasure_requirements.json</code>.</p>
<ul>
%REVIEW%
</ul>
</details>
<div class="legend" aria-label="Legend">
<span><span class="sw" style="background:var(--grey)"></span>grey</span>
<span><span class="sw" style="background:var(--red)"></span>red</span>
<span><span class="sw" style="background:var(--green)"></span>green</span>
<span><span class="sw" style="background:var(--blue)"></span>blue chest</span>
<span><b style="color:var(--gold)">★3</b> power-up 3</span>
<span><b style="color:var(--gold)">♪</b> music box</span>
<span class="code">N1-N6 W1-W6 S1-S6 E1-E7</span> level
<span class="dim">#58</span> hint order
<span>dashed, ? : uncertain or heuristic</span>
<span class="dim">← X: needs branch X</span>
</div>
<p class="dim" style="font-size:.82rem">Where the needs come from: %NGUIDE% treasures have a guide that says it and game data that agrees,
%NDATA% come from the game data alone, %NUNCERTAIN% are uncertain. Level openings are always game data.
Edges by source: %EDGES%. The heuristic (a power-up flashes a level on the map: it opens the lowest-colour chest there that
can't be taken yet) agrees with the requirements for %HEUR% power-up flashes.</p>
</header>
<div class="wrap layout">
<div id="graph"><svg id="edges" aria-hidden="true"></svg></div>
<aside id="panel" aria-live="polite"><button id="close" aria-label="Close">×</button><div id="detail"><p class="dim">Tap a treasure to see what it needs and what it opens.</p></div></aside>
</div>
<footer>Generated by <code>tools/treasure_graph.py</code> from the disassembly's tables (see the treasure map page) and
<code>tools/treasure_requirements.json</code>. The guides were read through web search results, not opened directly; nothing here was checked in an emulator.</footer>
<script>
const NODES = %DATA%;
const HEUR = "heuristic (power-up map flash + lowest chest)", VER = "verified in game by Taro";
const TITLES = %TITLES%;
const byId = Object.fromEntries(NODES.map(n => [n.id, n]));
const kids = Object.fromEntries(NODES.map(n => [n.id, []]));
for (const n of NODES) for (const p of n.deps) kids[p].push(n.id);
const closure = (id, edges) => { const seen = new Set(), todo = [id]; while (todo.length) { for (const x of edges(todo.pop())) if (!seen.has(x)) { seen.add(x); todo.push(x); } } return seen; };
const ancestors = id => closure(id, x => byId[x].deps);
const descendants = id => closure(id, x => kids[x]);
const el = (tag, cls, text) => { const e = document.createElement(tag); if (cls) e.className = cls; if (text != null) e.textContent = text; return e; };

function chip(n, big) {
  const b = el("button", "chip" + (big ? " big" : "") + (n.status === "uncertain" || Object.values(n.need).includes(HEUR) ? " uncertain" : ""));
  b.dataset.id = n.id; b.style.setProperty("--c", `var(--${n.colour})`);
  b.append(el("span", "code", n.code), el("span", "nm", n.name));
  if (n.power) b.append(el("span", "tag", "★" + n.power));
  if (n.music) b.append(el("span", "tag", "♪"));
  const via = n.deps.filter(x => !byId[x].main);
  if (!n.main && via.length) b.append(el("span", "via", "← " + via.map(x => byId[x].name).join(", ")));
  b.append(el("span", "hn", "#" + n.n));
  b.title = `${n.name}: ${n.level}, ${n.colour} chest, hint #${n.n}`;
  return b;
}

const graph = document.getElementById("graph");
const branchesAt = {};
for (const n of NODES) if (!n.main) (branchesAt[n.anchor] = branchesAt[n.anchor] || []).push(n);
// a branch that needs another branch goes after it
const depth = id => { const n = byId[id]; const v = n.deps.filter(x => !byId[x].main && byId[x].anchor === n.anchor); return v.length ? 1 + Math.max(...v.map(depth)) : 0; };
for (const k in branchesAt) branchesAt[k].sort((a, b) => depth(a.id) - depth(b.id) || a.n - b.n);
function row(numText, spineNode, branches) {
  const r = el("div", "row");
  r.append(el("div", "num", numText));
  const s = el("div", "spine");
  if (spineNode) { s.append(chip(spineNode, true)); s.append(el("div", "eff", spineNode.effect + (spineNode.with_.length ? ` (with ${spineNode.with_.map(x => byId[x].name).join(" + ")})` : ""))); }
  else s.append(el("div", "eff", "start: N1 Out of the Woods is open"));
  r.append(s);
  const br = el("div", "branches");
  for (const n of branches || []) br.append(chip(n));
  r.append(br);
  return r;
}
if (branchesAt[0]) graph.append(row("", null, branchesAt[0]));
for (const n of NODES) {
  if (!n.main) continue;
  if (TITLES[n.n]) graph.append(el("div", "stage", TITLES[n.n]));
  graph.append(row("#" + n.n, n, branchesAt[n.n]));
  if (TITLES["after" + n.n]) graph.append(el("div", "stage", TITLES["after" + n.n]));
}

const detail = document.getElementById("detail"), panel = document.getElementById("panel"), svg = document.getElementById("edges");
let selected = null;
const nameLink = id => { const b = el("button", "link", byId[id].name); b.dataset.id = id; return b; };
function list(ids) { const ul = el("ul"); for (const id of ids) { const li = el("li"); li.append(nameLink(id), document.createTextNode(` (${byId[id].code} ${byId[id].colour}, #${byId[id].n})`)); ul.append(li); } return ul; }
function show(id) {
  const n = byId[id];
  detail.replaceChildren();
  detail.append(el("h2", null, n.name));
  const meta = el("p");
  meta.append(el("span", "code", n.code), document.createTextNode(` ${n.level}, ${n.colour} chest. Hint #${n.n}. `));
  if (n.power) meta.append(document.createTextNode(`Power-up ${n.power}. `));
  if (n.music) meta.append(document.createTextNode("Music box. "));
  detail.append(meta);
  const when = el("p");
  if (n.main) when.append(document.createTextNode("On the main line: needed for the Gold Music Box."));
  else if (n.anchor) { when.append(document.createTextNode("Branch: available after main-line #" + n.anchor + " ")); when.append(nameLink(NODES.find(x => x.n === n.anchor).id)); when.append(document.createTextNode(n.n - n.anchor > 1 ? `, ${n.n - n.anchor} places before the hint gives it.` : ".")); }
  else when.append(document.createTextNode("Branch: available from the start."));
  if (!n.main && n.firm !== n.anchor) when.append(document.createTextNode(" Without the heuristic's edge: " + (n.firm ? "after #" + n.firm + " " + NODES.find(x => x.n === n.firm).name : "from the start") + "."));
  detail.append(when);
  detail.append(el("h3", null, "Opens"), el("p", null, n.effect));
  detail.append(el("h3", null, "Level open"));
  if (n.open.length) { const p = el("p", null, "The map path to " + n.code + " opens with: "); detail.append(p, list(n.open)); }
  else detail.append(el("p", null, "Open from the start."));
  detail.append(el("h3", null, "Inside the level"));
  const st = el("p"); const bd = el("span", "badge " + n.status, n.status); st.append(bd);
  const needIds = Object.keys(n.need);
  st.append(document.createTextNode(needIds.length ? " needs:" : " nothing more"));
  if (n.verified) st.append(el("span", "kind ver", " verified in game" + (n.verified.note ? ": " + n.verified.note : "")));
  detail.append(st);
  if (needIds.length) {
    const ul = list(needIds);
    [...ul.children].forEach((li, i) => { const k = n.need[needIds[i]]; li.append(el("span", "kind" + (k === HEUR ? " heur" : k === VER ? " ver" : ""), " · " + k)); });
    detail.append(ul);
  }
  if (n.check) detail.append(el("p", "dim", "To check in the game: " + n.check));
  if (n.note) detail.append(el("p", "dim", n.note));
  detail.append(el("h3", null, "Sources"));
  const ul = el("ul", "src");
  for (const s of n.sources) {
    const li = el("li");
    if (s.url) { const a = el("a", null, s.by); a.href = s.url; a.rel = "noopener"; li.append(a); } else li.append(el("b", null, s.by));
    li.append(document.createTextNode(": " + s.says)); ul.append(li);
  }
  detail.append(ul);
  const all = [...ancestors(id)].sort((a, b) => byId[a].n - byId[b].n);
  detail.append(el("h3", null, `Needs in all (${all.length})`));
  const p = el("p", "dim"); p.textContent = all.length ? all.map(x => byId[x].name).join(", ") : "nothing"; detail.append(p);
  const opens = [...descendants(id)].sort((a, b) => byId[a].n - byId[b].n);
  detail.append(el("h3", null, `Needed by (${opens.length})`));
  if (kids[id].length) detail.append(list(kids[id]));
  if (opens.length > kids[id].length) { const q = el("p", "dim"); q.textContent = "and through those: " + opens.filter(x => !kids[id].includes(x)).map(x => byId[x].name).join(", "); detail.append(q); }
  if (!opens.length) detail.append(el("p", "dim", "nothing"));
}
function center(e, side) { const g = graph.getBoundingClientRect(), r = e.getBoundingClientRect(); return [side ? r.right - g.left : r.left - g.left, r.top + r.height / 2 - g.top]; }
function curve(a, b, cls) {
  const p = document.createElementNS("http://www.w3.org/2000/svg", "path");
  const dx = Math.max(30, Math.abs(b[0] - a[0]) / 2);
  p.setAttribute("d", `M${a[0]},${a[1]} C${a[0] - dx},${a[1]} ${b[0] - dx},${b[1]} ${b[0]},${b[1]}`);
  p.setAttribute("class", cls); svg.append(p);
}
function drawEdges() {
  svg.replaceChildren();
  if (!selected) return;
  const g = graph.getBoundingClientRect(); svg.setAttribute("width", g.width); svg.setAttribute("height", g.height);
  const me = graph.querySelector(`.chip[data-id="${selected}"]`);
  for (const d of byId[selected].deps) { const e = graph.querySelector(`.chip[data-id="${d}"]`); if (e) curve(center(me, false), center(e, false), byId[selected].need[d] === HEUR ? "need heur" : "need"); }
  for (const k of kids[selected]) { const e = graph.querySelector(`.chip[data-id="${k}"]`); if (e) curve(center(me, false), center(e, false), "unlock"); }
}
function select(id, scroll) {
  selected = id;
  graph.classList.toggle("focus", !!id);
  const a = id ? ancestors(id) : new Set(), d = id ? descendants(id) : new Set();
  for (const c of graph.querySelectorAll(".chip")) {
    c.classList.toggle("sel", c.dataset.id === id); c.classList.toggle("anc", a.has(c.dataset.id)); c.classList.toggle("desc", d.has(c.dataset.id));
    c.setAttribute("aria-pressed", c.dataset.id === id ? "true" : "false");
  }
  if (id) { show(id); panel.classList.add("open"); document.body.classList.add("panel-open"); }
  else { panel.classList.remove("open"); document.body.classList.remove("panel-open"); }
  drawEdges();
  const chipEl = id && graph.querySelector(`.chip[data-id="${id}"]`);
  if (chipEl && scroll) chipEl.scrollIntoView({ block: "center", behavior: "smooth" });
  else if (chipEl && panel.offsetHeight && getComputedStyle(panel).position === "fixed" && chipEl.getBoundingClientRect().bottom > innerHeight - panel.offsetHeight - 16)
    window.scrollBy({ top: chipEl.getBoundingClientRect().top - innerHeight * 0.2, behavior: "smooth" });
  if (id) setTimeout(drawEdges, 450);
  try { history.replaceState(null, "", id ? "#" + id.toLowerCase() : location.pathname); } catch (e) {}
}
document.addEventListener("click", e => {
  const t = e.target.closest("[data-id]");
  if (t) { const id = t.dataset.id; select(selected === id && t.classList.contains("chip") ? null : id, !t.classList.contains("chip")); return; }
  if (e.target.id === "close") select(null);
});
document.addEventListener("keydown", e => { if (e.key === "Escape") select(null); });
window.addEventListener("resize", drawEdges);
const start = location.hash.slice(1).toUpperCase();
if (byId[start]) select(start, true);
</script>
</body>
</html>
"""


def dump(d, nodes, main, problems, hrows, rv):
    by_n = {nd["n"]: nd for nd in nodes}
    print("main line:", " > ".join(f"{by_n[n]['n']} {by_n[n]['name']}" for n in sorted(x["n"] for x in nodes if x["main"])))
    for nd in nodes:
        if nd["main"]:
            continue
        an = by_n.get(nd["anchor"])
        print(f"  branch #{nd['n']:3} {nd['name']:24} {nd['code']} {nd['colour']:5} after #{nd['anchor']:2} "
              f"{an['name'] if an else 'start':24} gap {nd['n'] - nd['anchor']:3} [{nd['status']}] needs {nd['need']}"
              + (f" (without heuristic edges: after #{nd['firm']})" if nd["firm"] != nd["anchor"] else ""))
    print("edges by source:", edge_counts(nodes))
    print("heuristic (power-up flash + lowest chest):")
    for p, level, pred, given in hrows:
        names = ", ".join(f"{d.treasure_name(c)} [{k}]" for c, k in given) or "none"
        ok = "agrees" if pred in [c for c, _ in given] else "DIFFERS"
        print(f"  {d.treasure_name(p):24} {d.code(level)}: predicts {d.treasure_name(pred) if pred else '-':22} requirements: {names:50} {ok}")
    print("review:")
    for r in rv:
        print("  ", r["id"], "|", "; ".join(r["reasons"]), "|", " ".join(r["checks"]))
    for p in problems:
        print("PROBLEM:", p)


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--check", action="store_true", help="only check that the page is up to date")
    parser.add_argument("--dump", action="store_true", help="print the graph as text")
    args = parser.parse_args()

    d = tm.Data()
    steps, problems = tm.analyse(d)
    reqs = json.loads(REQS.read_text())["treasures"]
    missing = set(d.order) - set(reqs)
    if missing:
        raise SystemExit(f"{REQS.relative_to(ROOT)} has no entry for {', '.join(sorted(missing))}")
    nodes, main_line, more = build(d, steps, reqs)
    problems += more
    hrows = heuristic_check(d, steps, reqs)
    for p, level, pred, given in hrows:
        for c, kind in given:
            if kind == HEURISTIC and c != pred:
                problems.append(f"{c}: its {p} edge is marked heuristic, but the heuristic picks {pred}")
    rv = review(d, nodes, hrows)
    if args.dump:
        dump(d, nodes, main_line, problems, hrows, rv)
        return 1 if problems else 0
    for p in problems:
        print("problem:", p)
    new = html_page(d, nodes, main_line, problems, hrows, rv)
    new_md = review_md(review_entries(d, nodes, rv), edge_counts(nodes))
    if args.check:
        stale = [f for f, text in ((PAGE, new), (REVIEW, new_md)) if not f.exists() or f.read_text() != text]
        for f in stale:
            print(f"{f.relative_to(ROOT)} is out of date: run python3 tools/treasure_graph.py")
        return 1 if stale or problems else 0
    PAGE.write_text(new)
    REVIEW.write_text(new_md)
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
