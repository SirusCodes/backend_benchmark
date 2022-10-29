from flask import Flask, jsonify, request


host, port = "127.0.0.1", 8080

app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
    return 'Hello, World!'

@app.route('/echo', methods=['POST'])
def echo():
    body = request.get_json()
    return jsonify({"response": f"Hello, {body['name']}!"})


if __name__ == '__main__':
    app.run(host=host, port=port)