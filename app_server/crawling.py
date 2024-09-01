import requests
from bs4 import BeautifulSoup
import url
import re


#크롤링 결과물에 광고를 추가하는 함수
def puting_ad():

    #TODO
    None

def noti_page_parser(noti_link):
    headers = {'User-Agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36'}
    data = requests.get(noti_link + 'list#none', headers=headers)
    soup = BeautifulSoup(data.text, 'html.parser')

    noti_dic = {'link': noti_link + 'detail/'}

    #리턴용 리스트 및 변수 작성
    Noti_Compression = [['일반 공지', noti_link + 'detail/']]


    #한 페이지 전체를 크롤링 하도록 16 으로 설정
    for i in range(1, 16):
        Noti_num_list = list()


        #공지인 경우 크롤링을 진행하지 않음
        title = soup.select_one('#wrap > div.ly-right > div.contents > div > div.board > div.board_list > ul > li:nth-child(%d) > a > div.top > p > span' % i)
        if title is not None:
            continue

        # 공지 제목 추출
        title = soup.select_one('#wrap > div.ly-right > div.contents > div > div.board > div.board_list > ul > li:nth-child(%d) > a > div.top > p' % i)
        Notice_Title = title.get_text(strip=True)

        '''
        #공지 날짜 추출
        title = soup.select_one('#wrap > div.ly-right > div.contents > div > div.board > div.board_list > ul > li:nth-child(%d) > a > div.top > div.info > span:nth-child(1)' %i)
        Noti_num_list.append(title.get_text(strip=True))
        '''


        # 링크 고유 코드 추출
        title = soup.select_one('#wrap > div.ly-right > div.contents > div > div.board > div.board_list > ul > li:nth-child(%d) > a' %i)
        onclick_value = title['onclick']
        match = re.search(r'goDetail\((\d+)\)', onclick_value)

        #리스트 저장 부분
        #Noti_num_list.append(Notice_Title)
        #Noti_num_list.append(match.group(1))
        #Noti_Compression.append(Noti_num_list)


        #딕셔너리 저장 부분
        noti_dic[match.group(1)] = Notice_Title


        #공지 내용이 5개라면 크롤링 중지?
        if(len(noti_dic) == 7):
            break

    puting_ad()
    #TODO

    return noti_dic


print(noti_page_parser(url.general))
#print(noti_page_parser(url.empprg))
#noti_page_parser('https://wise.dongguk.ac.kr/article/acdnotice/')