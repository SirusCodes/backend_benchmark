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


def gen_sync_req_graph():
    sync_get = get_property_results("get_rtt")
    sync_post = get_property_results("post_rtt")
    x = list(server.split(".")[0] for server in sync_get.keys())
    y_get = list(sync_get.values())
    y_post = list(sync_post.values())
    barplots = [
        go.Bar(x=x, y=y_get, name="GET",
               text=y_get, textposition="outside", texttemplate="%{text:.2f}"),
        go.Bar(x=x, y=y_post, name="POST",
               text=y_post, textposition="outside", texttemplate="%{text:.2f}"),
    ]

    layout = go.Layout(title="Sync Requests", barmode="group",
                       xaxis_title="Servers", yaxis_title="RTT (ms)",)
    fig = go.Figure(data=barplots, layout=layout)
    fig.write_image("graphs/sync.jpeg", scale=2)


def gen_generic_graph(prop: str, title: str, filename: str):
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
    gen_sync_req_graph()
    gen_generic_graph("get_rtt_parallel", "Async GET Requests",
                      "graphs/async_get.jpeg")
    gen_generic_graph("post_rtt_parallel",
                      "Async POST Requests", "graphs/async_post.jpeg")
    gen_generic_graph("parse_json", "JSON Parsing", "graphs/json.jpeg")
    gen_generic_graph("send_file", "File Sending", "graphs/multipart.jpeg")
