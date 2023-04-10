import os
import json
import plotly.graph_objects as go


def create_graphs_dir():
    if not os.path.exists("graphs"):
        os.mkdir("graphs")


def get_property_results(prop: str):
    servers = os.listdir("./benchmark/results/")
    results = {}
    for server in servers:
        with open(f"./benchmark/results/{server}", encoding="utf8") as fp:
            data = json.load(fp)
            results[server] = data[prop]
    return results


def grouped_bar_graph(prop1: str, prop2: str, title: str, filename: str):
    sync_get = get_property_results(prop1)
    sync_post = get_property_results(prop2)
    x = list(server.split(".")[0] for server in sync_get.keys())
    y_get = list(sync_get.values())
    y_post = list(sync_post.values())
    barplots = [
        go.Bar(x=x, y=y_get, name="GET",
               text=y_get, textposition="outside", texttemplate="%{text:.2f}"),
        go.Bar(x=x, y=y_post, name="POST",
               text=y_post, textposition="outside", texttemplate="%{text:.2f}"),
    ]

    layout = go.Layout(title=title, barmode="group",
                       xaxis_title="Servers", yaxis_title="RTT (ms)",)
    fig = go.Figure(data=barplots, layout=layout)
    fig.write_image(filename, scale=2)


def bar_graph(prop: str, title: str, filename: str):
    data = get_property_results(prop)
    x = list(server.split(".")[0] for server in data.keys())
    y = list(data.values())
    barplot = go.Bar(x=x, y=y,
                     text=y, textposition="outside", texttemplate="%{text:.2f}")
    layout = go.Layout(title=title, xaxis_title="Servers",
                       yaxis_title="RTT (ms)",)
    fig = go.Figure(data=barplot, layout=layout)
    fig.write_image(filename, scale=2)


if __name__ == "__main__":
    create_graphs_dir()
    grouped_bar_graph("get_rtt", "post_rtt",
                      "Sync Requests", "graphs/sync.jpeg")
    grouped_bar_graph("get_rtt_parallel", "post_rtt_parallel",
                      "Async Requests", "graphs/async.jpeg")
    bar_graph("parse_json", "JSON Parsing", "graphs/json.jpeg")
    bar_graph("send_file", "File Sending", "graphs/multipart.jpeg")
