import os
import signal
import subprocess
import time

import requests

root_dir = os.getcwd()

backends = os.listdir('./backends')


for backend in backends:
    # if backend == "dart_conduit":
    #     continue

    print(f"Testing {backend}...")

    # Start server
    os.chdir(f"./backends/{backend}/")
    os.chmod("run.sh", 0o777)
    running_server = subprocess.Popen(
        ["./run.sh"], shell=True, preexec_fn=os.setsid)
    os.chdir(root_dir)

    # Wait for the server to start
    while True:
        try:
            response = requests.get("http://localhost:8080", timeout=10)
            if response.status_code == 200:
                break
        except requests.exceptions.ConnectionError:
            print("Waiting for server to start...")
            time.sleep(5)

    # Run the benchmark
    os.chdir("./benchmark/")
    benchmark = subprocess.Popen(["dart", "run", "benchmark", backend])
    benchmark.communicate()
    benchmark.wait()

    print("Killing server...", running_server.pid)
    os.killpg(os.getpgid(running_server.pid), signal.SIGTERM)

    os.chdir(root_dir)
