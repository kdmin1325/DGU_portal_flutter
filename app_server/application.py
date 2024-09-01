from flask import Flask, jsonify
from flask_cors import CORS  # CORS 추가
import crawling
import time as t
import url

# 업데이트 주기 파악용 시간 측정
start_general_noti_time = t.time()
start_acd_noti_time = t.time()
start_empprg_noti_time = t.time()

# 각 공지 크롤링 함수
general_noti = crawling.noti_page_parser(url.general)
acd_noti = crawling.noti_page_parser(url.acd)
empprg_noti = crawling.noti_page_parser(url.empprg)

application = Flask(__name__)
CORS(application)  # Flask 앱에 CORS 적용


# 연결 확인용
@application.route('/')
def Check_connection():
    return '1'


# 호출할 공지 갯수 설정
@application.route('/num', methods=['GET'])
def num():
    return '10'


# 일반 공지
@application.route('/information/generalnotice', methods=['GET'])
def generalnotice_information():
    global start_general_noti_time, general_noti
    now_time = t.time() - start_general_noti_time
    print("일반 공지 요청")

    if(now_time > 3600):
        start_general_noti_time = t.time()
        print("공지 새로 고침")
        general_noti = crawling.noti_page_parser(url.general)

    return jsonify(general_noti)


# 학사 공지
@application.route('/information/acdnotice')
def acdnotice_information():
    global start_acd_noti_time, acd_noti
    now_time = t.time() - start_acd_noti_time
    print("학사 공지 요청")

    if(now_time > 3600):
        start_acd_noti_time = t.time()
        print("공지 새로 고침")
        acd_noti = crawling.noti_page_parser(url.acd)

    return jsonify(acd_noti)


# 취업 공지
@application.route('/information/empprgnoti')
def empprgnoti_information():
    global start_empprg_noti_time, empprg_noti
    now_time = t.time() - start_empprg_noti_time
    print("취업 공지 요청")

    if(now_time > 3600):
        start_empprg_noti_time = t.time()
        print("공지 새로 고침")
        empprg_noti = crawling.noti_page_parser(url.empprg)

    return jsonify(empprg_noti)


@application.route('/user/click/<count>')
def get_click_count(count):
    global start_empprg_noti_time, empprg_noti
    now_time = t.time() - start_empprg_noti_time
    print("취업 공지 요청")

    if(now_time > 3600):
        start_empprg_noti_time = t.time()
        print("공지 새로 고침")
        empprg_noti = crawling.noti_page_parser(url.empprg)

    return jsonify(empprg_noti)


if __name__ == '__main__':
    application.run()