import os
from typing import Dict, List, Tuple
from dateutil import parser
import datetime
import json
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import pandas as pd

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
    df = pd.DataFrame(metric_data_raw, columns=["value", "time"])
    # remove outliers
    df = df[(df["value"] - df["value"].mean()).abs() < 3 * df["value"].std()]

    # round off the time to seconds
    df["time"] = df["time"].apply(round_seconds)

    # group by time and compute the average
    df = df.groupby("time").mean()

    # return list of tuples
    return df.to_dict()["value"]


def split_vus_data(vus_data_raw: List[Tuple[float, datetime.datetime]]) -> Dict[datetime.datetime, float]:
    df = pd.DataFrame(vus_data_raw, columns=["value", "time"])
    # round off the time to seconds
    df["time"] = df["time"].apply(round_seconds)

    # group by time and compute the average
    df = df.groupby("time").mean()

    # return list of tuples
    return df.to_dict()["value"]


def generate_graph(metric_data_avg: Dict[datetime.datetime, float], vus_data: Dict[datetime.datetime, float], watched_metric: str, backend: str) -> None:
    # the chart will have two Y axes
    fig = make_subplots(specs=[[{"secondary_y": True}]])

    fig.add_trace(
        go.Scatter(x=list(metric_data_avg.keys()),
                   y=list(metric_data_avg.values()),
                   name=f"Average {watched_metric} (ms)"),
        secondary_y=False,
    )

    fig.add_trace(
        go.Scatter(x=list(vus_data.keys()),
                   y=list(vus_data.values()),
                   name="VU count"),
        secondary_y=True,
    )
    fig.update_xaxes(title_text="Time")
    fig.update_yaxes(
        title_text=f"Average {watched_metric} (ms)", secondary_y=False)
    fig.update_yaxes(title_text="VU count", secondary_y=True)
    fig.update_layout(
        autosize=False,
        width=1500,
    )
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
