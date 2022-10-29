import requests


url = "http://127.0.0.1:8080"
res = requests.post(f"{url}/echo", json={"name": "John"})

print(res.json())