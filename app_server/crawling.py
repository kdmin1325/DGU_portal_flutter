import requests
from bs4 import BeautifulSoup

def noti_page_parser(link):
    headers = {'User-Agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36'}
    data = requests.get(link, headers=headers)
    soup = BeautifulSoup(data.text, 'html.parser')

    #리턴용 리스트 및 변수 작성
    Noti_Compression = list()

    for i in range(1, 10):
        Noti_num_list = list()
        i = i + 1

        # 공지 제목
        title = soup.select_one(
            '#wrap > div.ly-right > div.contents > div > div.board > div.board_list > ul > li:nth-child(%d) > a > div.top > p' % i)
        Noti_num_list.append(title.get_text(strip=True))

        # 고유 코드
        title = soup.select_one('#wrap > div.ly-right > div.contents > div > div.board > div.board_list > ul > li:nth-child(%d) > a > div.mark > span' % i)
        Noti_num_list.append(title.get_text(strip=True))

        if (title.get_text(strip=True) == "공지"):
            continue

        #공지 날짜
        title = soup.select_one('#wrap > div.ly-right > div.contents > div > div.board > div.board_list > ul > li:nth-child(%d) > a > div.top > div.info > span:nth-child(1)' %i)
        Noti_num_list.append(title.get_text(strip=True))
        i = i + 1

        Noti_Compression.append(Noti_num_list)

    return Noti_Compression

print(noti_page_parser('https://wise.dongguk.ac.kr/article/generalnotice/list#none'))