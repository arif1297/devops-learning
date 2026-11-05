from flask import Flask

import redis

app = Flask(__name__)
redis_client = redis.Redis(host='redis' , port=6379, db=0)

@app.route('/')
def hello_world():
    return 'CoderCo Containers Session!'

@app.route('/count')
def count():
    visits = redis_client.incr('visits')
    return f'Visitor Count: {visits}'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
