import os
from typing import Dict, List, Tuple
from dateutil import parser
import datetime
import json
import sys
import plotly.graph_objects as go
from plotly.subplots import make_subplots

REQUIRED_METRICS = ["http_req_duration", "vus"]


def create_graphs_dir():
    if not os.path.exists("graphs"):
        os.mkdir("graphs")


def round_seconds(date_time_object: datetime.datetime):
    new_date_time = date_time_object

    if new_date_time.microsecond >= 500_000:
        new_date_time = new_date_time + datetime.timedelta(seconds=1)

    return new_date_time.replace(microsecond=0)


def load_data(file_name: str) -> Dict[str, Tuple[float, datetime.datetime]]:
    data: Dict[str, Tuple[float, datetime.datetime]] = {}
    with open(file_name, "r") as f:
        for line in f.readlines():
            line_data = json.loads(line)
            if line_data["type"] == "Point" and line_data["metric"] in REQUIRED_METRICS:
                metric = line_data["metric"]
                metric_data = data.get(metric, [])
                metric_data.append(
                    (line_data["data"]["value"], parser.parse(line_data["data"]["time"])))
                data[metric] = metric_data
    return data


def get_avg_from_data(metric_data_raw: List[Tuple[float, datetime.datetime]]) -> Dict[datetime.datetime, float]:
    # prepare dicts for (sum, count)
    metric_data_sum_count = {}

    for (value, time) in metric_data_raw:
        # round the time to seconds
        time = round_seconds(time)

        # find the current entry
        entry = metric_data_sum_count.get(time, (0, 0))
        # and update its sum and count
        metric_data_sum_count[time] = (entry[0] + value, entry[1] + 1)

    # compute data avg
    metric_data_avg: Dict[datetime.datetime, float] = {}
    for (time, (val, count)) in metric_data_sum_count.items():
        metric_data_avg[time] = val / count

    return metric_data_avg


def split_vus_data(vus_data_raw: List[Tuple[float, datetime.datetime]]) -> List[int]:
    # prepare lists for (time, vus)
    vus_data_time = []
    vus_data_vus = []

    for (value, time) in vus_data_raw:
        # add the time to the time list
        vus_data_time.append(time)

        # add the vus to the vus list
        vus_data_vus.append(value)

    return [vus_data_time, vus_data_vus]


def generate_graph(metric_data_avg: Dict[datetime.datetime, List[float]], vus_data: List[int], watched_metric: str, backend: str) -> None:
    # the chart will have two Y axes
    fig = make_subplots(specs=[[{"secondary_y": True}]])

    fig.add_trace(
        go.Scatter(x=list(metric_data_avg.keys()),
                   y=list(metric_data_avg.values()),
                   name=f"Average {watched_metric} (ms)"),
        secondary_y=False,
    )

    fig.add_trace(
        go.Scatter(x=vus_data[0],
                   y=vus_data[1],
                   name="VU count"),
        secondary_y=True,
    )
    fig.update_xaxes(title_text="Time")
    fig.update_yaxes(
        title_text=f"Average {watched_metric} (ms)", secondary_y=False)
    fig.update_yaxes(title_text="VU count", secondary_y=True)
    fig.write_image(f"graphs/{backend}.jpeg", scale=2)


def process_file(file_name: str, watched_metric: str):
    # load data from the file
    print(f"Processing {file_name} for {watched_metric}...")
    data = load_data(file_name)
    print(f"File processed...")

    print("Parsing data...")
    # get avg and vus from data
    metric_data_avg = get_avg_from_data(data[watched_metric])
    vus_data = split_vus_data(data["vus"])

    # display a chart
    generate_graph(metric_data_avg, vus_data, watched_metric,
                   file_name.split("/")[-1].split(".")[0])


if __name__ == "__main__":
    create_graphs_dir()
    results = os.listdir("results")
    for result in results:
        process_file(f"results/{result}", "http_req_duration")
