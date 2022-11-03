import fastwsgi
from main import app

if __name__ == '__main__':
    fastwsgi.run(wsgi_app=app, host='127.0.0.1', port=8080)