"""Reduce the Trenord GTFS feed to a compact JSON for the app.

Usage:
    python pipeline/build.py --feed feed.zip --config pipeline/config.json --out site/orari.json
    python pipeline/build.py --url <gtfs zip url> ...   (downloads the feed)

Output format: see pipeline/README.md. Standard library only.
"""
import argparse
import csv
import datetime as dt
import io
import json
import sys
import urllib.request
import zipfile
from collections import defaultdict
from itertools import permutations

FEED_URL = "https://www.dati.lombardia.it/download/3z4k-mxz9/application%2Fzip"
ATTRIBUTION = "Orari: Trenord, dati aperti Regione Lombardia, licenza CC BY 4.0"
BUS_ROUTE_TYPE = "3"
REQUIRED = ["stops.txt", "routes.txt", "trips.txt", "stop_times.txt", "calendar_dates.txt"]


class FeedError(Exception):
    pass


def _read(z, name):
    with z.open(name) as f:
        return list(csv.DictReader(io.TextIOWrapper(f, encoding="utf-8-sig")))


def _hhmm(t):
    h, m, _ = t.strip().split(":")
    return f"{int(h):02d}:{m}"


def _iso(d):
    return f"{d[:4]}-{d[4:6]}-{d[6:]}"


def _train_number(short_name):
    # "S8 - 24711" -> "24711"; buses have plain codes like "1001A"
    return short_name.split(" - ")[-1].strip()


def build(feed, config, today):
    """feed: path or file object of the GTFS zip; today: datetime.date."""
    stations = config["stazioni"]
    with zipfile.ZipFile(feed) as z:
        missing = [n for n in REQUIRED if n not in z.namelist()]
        if missing:
            raise FeedError(f"File mancanti nel feed: {missing}")
        stops = {r["stop_id"]: r["stop_name"] for r in _read(z, "stops.txt")}
        unknown = [s for s in stations if s not in stops]
        if unknown:
            raise FeedError(f"Stazioni non presenti nel feed: {unknown}")
        routes = {r["route_id"]: r for r in _read(z, "routes.txt")}
        trips = {r["trip_id"]: r for r in _read(z, "trips.txt")}

        wanted = set(stations)
        at_station = defaultdict(dict)  # trip -> stop -> (seq, arr, dep)
        last_stop = {}                  # trip -> (seq, stop)
        for r in _read(z, "stop_times.txt"):
            seq = int(r["stop_sequence"])
            t = r["trip_id"]
            if t not in last_stop or seq > last_stop[t][0]:
                last_stop[t] = (seq, r["stop_id"])
            if r["stop_id"] in wanted:
                at_station[t][r["stop_id"]] = (seq, r["arrival_time"], r["departure_time"])

        first = today.strftime("%Y%m%d")
        dates = defaultdict(set)
        for r in _read(z, "calendar_dates.txt"):
            if r["date"] < first:
                continue
            if r["exception_type"].strip() == "1":
                dates[r["service_id"]].add(r["date"])
            else:
                dates[r["service_id"]].discard(r["date"])

    tratte = []
    calendars, cal_index = [], {}
    for da, a in permutations(stations, 2):
        merged = {}  # trip identity -> set of dates
        for trip_id, st in at_station.items():
            if da not in st or a not in st or st[da][0] >= st[a][0]:
                continue
            trip = trips[trip_id]
            days = dates.get(trip["service_id"])
            if not days:
                continue
            route = routes[trip["route_id"]]
            is_bus = route.get("route_type", "").strip() == BUS_ROUTE_TYPE
            key = (
                _train_number(trip.get("trip_short_name", "")),
                "Bus" if is_bus else route["route_short_name"],
                "bus" if is_bus else "treno",
                _hhmm(st[da][2]),
                _hhmm(st[a][1]),
                stops[last_stop[trip_id][1]],
            )
            merged.setdefault(key, set()).update(days)
        corse = []
        for key, days in merged.items():
            cal = tuple(sorted(_iso(d) for d in days))
            if cal not in cal_index:
                cal_index[cal] = len(calendars)
                calendars.append(list(cal))
            treno, linea, mezzo, partenza, arrivo, capolinea = key
            corse.append({
                "treno": treno, "linea": linea, "mezzo": mezzo,
                "partenza": partenza, "arrivo": arrivo,
                "capolinea": capolinea, "giorni": cal_index[cal],
            })
        corse.sort(key=lambda c: (c["partenza"], c["treno"]))
        tratte.append({"da": da, "a": a, "corse": corse})

    if not any(t["corse"] for t in tratte):
        raise FeedError("Nessuna corsa diretta valida tra le stazioni configurate")

    all_days = [d for cal in calendars for d in cal]
    return {
        "versione": 1,
        "generato": dt.datetime.now(dt.timezone.utc).isoformat(timespec="seconds"),
        "attribuzione": ATTRIBUTION,
        "valido_dal": min(all_days),
        "valido_al": max(all_days),
        "stazioni": {s: stops[s] for s in stations},
        "tratte": tratte,
        "calendari": calendars,
    }


def main(argv=None):
    p = argparse.ArgumentParser()
    p.add_argument("--feed", help="GTFS zip già scaricato")
    p.add_argument("--url", default=FEED_URL)
    p.add_argument("--config", required=True)
    p.add_argument("--out", required=True)
    args = p.parse_args(argv)

    if args.feed:
        feed = args.feed
    else:
        req = urllib.request.Request(args.url, headers={"User-Agent": "EsciOra-pipeline/1.0"})
        with urllib.request.urlopen(req, timeout=120) as resp:
            feed = io.BytesIO(resp.read())
    with open(args.config, encoding="utf-8") as f:
        config = json.load(f)
    today = dt.datetime.now(dt.timezone(dt.timedelta(hours=1))).date()
    out = build(feed, config, today)
    with open(args.out, "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, separators=(",", ":"))
    n = sum(len(t["corse"]) for t in out["tratte"])
    print(f"OK: {n} corse, validità {out['valido_dal']} → {out['valido_al']}")


if __name__ == "__main__":
    sys.exit(main())
