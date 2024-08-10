from flask import Flask
application = Flask(__name__)

@application .route('/')
def Check_connection():
    return '1'

@application .route('/num')
def num():
    return '10'

if __name__ == '__main__':
    application .run()