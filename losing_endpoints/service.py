from flask import Flask
from flask import request
import socket
import os
import sys
import requests

app = Flask(__name__)

@app.route('/status')
def hello():
    return ("We're fine. We're all fine here, now, thank you. How are you?")

@app.route('/fail')
def fail():
    raise ValueError("No. That's not true. That's impossible.")


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
