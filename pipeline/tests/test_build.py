"""Tests for the GTFS reduction. Run from the repo root:
    python -m unittest discover -s pipeline/tests
"""
import datetime as dt
import io
import json
import sys
import unittest
import zipfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import build  # noqa: E402

A, B, X = "S01322", "S01513", "S99999"

FEED = {
    "stops.txt": [
        "stop_id,stop_name,stop_lat,stop_lon",
        f"{A},Monza,0,0",
        f"{B},Cernusco-Merate,0,0",
        f"{X},Lecco,0,0",
        "S00001,Milano Porta Garibaldi,0,0",
    ],
    "routes.txt": [
        "route_id,agency_id,route_short_name,route_long_name,route_type",
        "S8,1,S8,S8,2",
        "TN_Bus,1,TN Bus,TN Bus sostitutivi,3",
    ],
    "trips.txt": [
        "trip_id,route_id,trip_short_name,service_id",
        "t1,S8,S8 - 24711,svc1",   # Milano -> Monza -> Cernusco -> Lecco
        "t2,S8,S8 - 24711,svc2",   # same train, other period, same dates as svc1
        "t3,S8,S8 - 24716,svc1",   # Lecco -> Cernusco -> Monza (other direction)
        "t4,S8,S8 - 24799,svc1",   # Monza only, does not stop at Cernusco
        "t5,TN_Bus,1001A,svc3",    # substitute bus Monza -> Cernusco
        "t6,S8,S8 - 24713,svc4",   # only runs in the past
    ],
    "stop_times.txt": [
        "trip_id,arrival_time,departure_time,stop_id,stop_sequence",
        "t1,07:00:00,07:00:00,S00001,1",
        f"t1,07:20:00,07:21:00,{A},2",
        f"t1,07:45:00,07:46:00,{B},3",
        f"t1,08:05:00,08:05:00,{X},4",
        "t2,07:00:00,07:00:00,S00001,1",
        f"t2,07:20:00,07:21:00,{A},2",
        f"t2,07:45:00,07:46:00,{B},3",
        f"t2,08:05:00,08:05:00,{X},4",
        f"t3,18:00:00,18:00:00,{X},1",
        f"t3,18:19:00,18:20:00,{B},2",
        f"t3,18:44:00,18:45:00,{A},3",
        f"t4,09:00:00,09:01:00,{A},1",
        "t4,09:20:00,09:20:00,S00001,2",
        f"t5,24:10:00,24:10:00,{A},1",
        f"t5,24:55:00,24:55:00,{B},2",
        f"t6,10:00:00,10:00:00,{A},1",
        f"t6,10:25:00,10:25:00,{B},2",
    ],
    "calendar_dates.txt": [
        "service_id,date,exception_type",
        "svc1,20261101,1",
        "svc1,20261102,1",
        "svc1,20261103,1",
        "svc2,20261102,1",
        "svc2,20261103,1",
        "svc3,20261104,1",
        "svc4,20261001,1",
    ],
    "feed_info.txt": ["feed_publisher_name,feed_publisher_url,feed_lang", "Trenord,https://trenord.it/,it-IT"],
}

TODAY = dt.date(2026, 11, 2)
CONFIG = {"stazioni": [A, B]}


def make_zip(files=FEED):
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w") as z:
        for name, lines in files.items():
            z.writestr(name, "﻿" + "\n".join(lines) + "\n")
    buf.seek(0)
    return buf


def run(files=FEED):
    return build.build(make_zip(files), CONFIG, TODAY)


def corse(out, da, a):
    return [t for t in out["tratte"] if t["da"] == da and t["a"] == a][0]["corse"]


class BuildTest(unittest.TestCase):
    def test_header_has_attribution_and_validity(self):
        out = run()
        self.assertEqual(out["versione"], 1)
        self.assertIn("Trenord", out["attribuzione"])
        self.assertIn("CC BY 4.0", out["attribuzione"])
        self.assertEqual(out["valido_al"], "2026-11-04")
        self.assertEqual(out["stazioni"], {A: "Monza", B: "Cernusco-Merate"})

    def test_both_directions_only_direct_trips(self):
        out = run()
        self.assertEqual({(t["da"], t["a"]) for t in out["tratte"]}, {(A, B), (B, A)})
        self.assertEqual([c["treno"] for c in corse(out, B, A)], ["24716"])

    def test_trip_fields(self):
        c = corse(run(), A, B)[0]
        self.assertEqual(c["treno"], "24711")
        self.assertEqual(c["linea"], "S8")
        self.assertEqual(c["mezzo"], "treno")
        self.assertEqual(c["partenza"], "07:21")  # departure at origin
        self.assertEqual(c["arrivo"], "07:45")    # arrival at destination
        self.assertEqual(c["capolinea"], "Lecco")  # last stop of the trip

    def test_same_train_in_several_periods_merges_dates(self):
        cs = [c for c in corse(run(), A, B) if c["treno"] == "24711"]
        self.assertEqual(len(cs), 1)
        out = run()
        dates = out["calendari"][cs[0]["giorni"]]
        self.assertEqual(dates, ["2026-11-02", "2026-11-03"])  # past date dropped

    def test_substitute_bus_is_flagged_and_keeps_times_after_midnight(self):
        bus = [c for c in corse(run(), A, B) if c["mezzo"] == "bus"]
        self.assertEqual(len(bus), 1)
        self.assertEqual(bus[0]["treno"], "1001A")
        self.assertEqual(bus[0]["partenza"], "24:10")  # GTFS service-day time, kept as is

    def test_trips_only_in_the_past_are_dropped(self):
        self.assertNotIn("24713", [c["treno"] for c in corse(run(), A, B)])

    def test_trips_sorted_by_departure(self):
        p = [c["partenza"] for c in corse(run(), A, B)]
        self.assertEqual(p, sorted(p))

    def test_unknown_station_is_an_error(self):
        with self.assertRaises(build.FeedError):
            build.build(make_zip(), {"stazioni": [A, "S00000"]}, TODAY)

    def test_missing_file_is_an_error(self):
        files = dict(FEED)
        del files["calendar_dates.txt"]
        with self.assertRaises(build.FeedError):
            build.build(make_zip(files), CONFIG, TODAY)

    def test_no_trips_is_an_error(self):
        files = dict(FEED)
        files["calendar_dates.txt"] = ["service_id,date,exception_type", "svc1,20200101,1"]
        with self.assertRaises(build.FeedError):
            build.build(make_zip(files), CONFIG, TODAY)

    def test_output_is_json_serializable(self):
        json.dumps(run())


if __name__ == "__main__":
    unittest.main()
