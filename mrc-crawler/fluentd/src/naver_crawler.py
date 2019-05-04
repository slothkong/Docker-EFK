# import re
# import pandas as pd
from selenium import webdriver
import os
import sys
import json
import datetime
import time
import random

options = webdriver.ChromeOptions()
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')
driver = webdriver.Chrome("/usr/bin/chromedriver", chrome_options=options)
# driver = webdriver.Chrome("/usr/bin/chromedriver")

def content_crawler(URL, ct_code, now, ct_name):
    for page in range(1, 2):
        driver.get('{}&sid1={}&page={}'.format(URL, ct_code, page))
        issue_sect = driver.find_elements_by_xpath("//div[@id='main_content']/div[@class='list_body section_index']/div[@id='section_body']/ul/li/dl/dt/a")

        issues = {}
        for element in issue_sect:
            issues[element.get_attribute("href")] = element.text

        for link in issues.keys():
            content = {}
            driver.get(link)
            driver.implicitly_wait(1)

            content['title'] = issues[link]
            content['location'] = 'Naver news'
            # content['category'] = driver.find_element_by_xpath("//*[@class='nclicks(LNB.pol)']/span").text
            content['category'] = ct_name
            published_date = driver.find_element_by_xpath("//span[@class='t11']").text
            content['published_date'] = datetime.datetime.strptime(published_date, "%Y-%m-%d %H:%M")  # 2019-03-26 15:20
            content['text'] = driver.find_element_by_xpath("//*[@id='articleBodyContents']").text
            content['language'] = 'ko'

            if now - content['published_date'] > datetime.timedelta(hours=1):
                return

            # from pprint import pprint
            print(json.dumps(content, ensure_ascii=False, default=default))
            time.sleep(random.randint(1, 3))
            driver.back()
            time.sleep(random.randint(1, 3))

def default(o):
    if isinstance(o, (datetime.date, datetime.datetime)):
        return o.isoformat()

def news_crawler(URL):
    # Get the 'issue section news'
    catg_list = ["정치", "경제", "사회", "생활/문화", "세계", "IT/과학"]

    now = datetime.datetime.now()
    for ct_code, ct_name in zip([100 + i for i in range(len(catg_list))], catg_list):
        content_crawler(URL, ct_code, now, ct_name)


def main():
    URL = "https://news.naver.com/main/main.nhn?mode=LSD&mid=shm"
    # output_file = open("/Crawler/news.json", "w+")
    # output_file = open('/Users/dev01/Desktop/news.json', 'w+', encoding='utf-8')
    news_crawler(URL)
    # output_file.close()
    driver.close()

if __name__ == '__main__':
    main()
