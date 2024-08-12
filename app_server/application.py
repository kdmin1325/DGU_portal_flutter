from flask import Flask, jsonify
import crawling

application = Flask(__name__)

@application.route('/')
def Check_connection():
    return '1'

@application.route('/num')
def num():
    return '10'

@application.route('/information')
def information():
    return jsonify(crawling.noti_page_parser('https://wise.dongguk.ac.kr/article/generalnotice/list#none'))

if __name__ == '__main__':
    application.run()