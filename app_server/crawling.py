import requests
from bs4 import BeautifulSoup

def noti_page_parser(link):
    headers = {'User-Agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36'}
    data = requests.get(link, headers=headers)
    soup = BeautifulSoup(data.text, 'html.parser')
    Noti_Compression = list()


    for i in range(1, 10):
        title = soup.select_one('#wrap > div.ly-right > div.contents > div > div.board > div.board_list > ul > li:nth-child(%d) > a > div.top > p' %i)
        Noti_Compression.append(title.get_text(strip=True))

        title = soup.select_one('#wrap > div.ly-right > div.contents > div > div.board > div.board_list > ul > li:nth-child(%d) > a > div.top > div.info > span:nth-child(1)' %i)
        print(title.get_text(strip=True))

        title = soup.select_one('#wrap > div.ly-right > div.contents > div > div.board > div.board_list > ul > li:nth-child(%d) > a > div.mark > span' % i)
        print(title.get_text(strip=True))

    return Noti_Compression