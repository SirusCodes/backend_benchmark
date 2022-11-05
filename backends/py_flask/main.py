import os
from flask import Flask, jsonify, request


host, port = "127.0.0.1", 8080

app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
    return jsonify({'response': 'Hello World!'})

@app.route('/echo', methods=['POST'])
def echo():
    body = request.get_json()
    return jsonify({"response": f"Hello, {body['name']}!"})

@app.route('/file_upload', methods=['POST'])
def file_upload():
    file = request.files["benchmark"]
    size = file.seek(0, os.SEEK_END)
    return str(size)

@app.route('/json_obj', methods=['POST'])
def json_obj():
    body = request.get_json()
    return str(len(body))



if __name__ == '__main__':
    app.run(host=host, port=port, debug=True)