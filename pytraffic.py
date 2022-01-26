from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.common.exceptions import TimeoutException, WebDriverException
import random
from random import randint
from time import sleep

# selenium chrome options
chrome_options = Options()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
chrome_options.add_argument('--disable-gpu')
# chrome_options.setPageLoadStrategy(PageLoadStrategy.EAGER)

urlFileName='url.txt'

minSleep=15
maxSleep=45

pageTimeout=25

# random number for log file
file_name = str(randint(500000,10000000))

# selenium loop to generate realistic traffic
while True:
    try:
        # sets random URL from url.txt
        url = random.choice(open(urlFileName).readlines())

        # open logfile
        logfile = open("/logs/"+file_name+".log", "a")

        # log attempt
        logfile.write(f'Attempting to access {url}\n') 

        # set webdriver
        driver = webdriver.Chrome('/usr/local/bin/chromedriver', options=chrome_options)

        # set timeout to pageTimeout on page load
        driver.set_page_load_timeout(pageTimeout)

        # open page and maximize window
        driver.get(url)
        driver.maximize_window()

        # print URL and page title
        logfile.write(f'Sucessfully loaded {url}\n') 
        print(f'{url} driver title: {driver.title}\n')

    # if timeout reached, restart loop    
    except TimeoutException as e:
        timeoutMsg=f'TimeoutException: {pageTimeout} second timeout reached on {url} stack: {e}\n'
        # log TimeoutException, close log file
        logfile.write(timeoutMsg)

        # print TimeoutException to docker logs and quit driver
        print (timeoutMsg)

    # if WebDriverException (connection loss), restart loop
    except WebDriverException as e:
        webDriverMsg=f'WebDriverException: connection dropped on {url}\n'

        # log WebDriverException, close log file
        logfile.write(webDriverMsg)

        # print WebDriverException to docker logs and quit driver
        print (webDriverMsg)
    except Exception as e:
        otherException=f'Another type of exception for {url} occurred: {e}\n'
        logfile.write(otherException)
        print (otherException)
    finally:
        logfile.close()
        sleep(randint(minSleep,maxSleep))
        driver.quit()
