
## 前言
一個好哥們託我一起在fb留言排隊搶衣服，我就想說為什麼不試試看我為了深度學習自學的selenium呢？

## 流程
1. 註冊新fb賬號
   避免FB有反爬蟲等功能，把我的賬號鎖了。

![擷取.JPG](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3a4401f352e8437abc0624ee60f2d210~tplv-k3u1fbpfcp-watermark.image?)

2. 關閉通知

登錄fb的時候會有彈窗的通知，他會導致selenium操作失敗。
更改 chrome 瀏覽器 notifications 的設定。
![20103256NXQG79ycFT.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/30aba269a21e411ca09b1aa0d0c851da~tplv-k3u1fbpfcp-watermark.image?)


```js
# 關閉通知
options = webdriver.ChromeOptions()
prefs = {
    'profile.default_content_setting_values':
        {
            'notifications': 2
        }
}
options.add_experimental_option('prefs', prefs)
options.add_argument("disable-infobars")  
```

3. 打開貼文網址
   *implicitly_wait*()是用來等待頁面加載完成的

![2.JPG](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b794e6e2ba0a49e887eb5b518b2de463~tplv-k3u1fbpfcp-watermark.image?)

```js
#打開貼文網址
driver= webdriver.Chrome(options=options)
driver.get('https://www.facebook.com/photo/?fbid=10218567078959752&set=a.1191098789180')
driver.implicitly_wait(6)
```

4. 登錄
   用send_keys()輸入內容
   用.click()來點擊
   time.sleep()停頓一下模仿人類

```js
#輸入email
context = driver.find_element_by_xpath('//*[@id="login_form"]/div[2]/div[1]/label/input')
context.send_keys("YOUR EMAIL")
time.sleep(0.5)

#輸入password
context = driver.find_element_by_xpath('//*[@id="login_form"]/div[2]/div[2]/label/input')
context.send_keys("YOUR PASSWORD")
time.sleep(0.5)

#登錄按鈕
driver.find_element_by_xpath('//*[@id="login_form"]/div[2]/div[3]/div/div').click()
time.sleep(0.5)
```

5. 留言
   跟上面一樣
```js
#輸入內容
context = driver.find_element_by_xpath('//*[@id="facebook"]/body/div[1]/div/div[1]/div/div[3]/div/div/div[1]/div[1]/div/div[2]/div/div/div/div[1]/div[5]/div/div[2]/form/div/div/div[1]/p')
context.send_keys("L+1 白色優先黑色其次")
time.sleep(0.5)
```

6. 到時發送
   貼文要求11點開搶，懂得不多所以我的做法是使用迴圈比對當前時間和目標時間。

```js
#到時發送
while True :
    if time.asctime( time.localtime(time.time()) ) == 'Fri Aug 27 23:00:00 2021' :
        context.send_keys(Keys.ENTER)
        break
```


![擷4444.JPG](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5a45991c11df465092d8e3a85691bab2~tplv-k3u1fbpfcp-watermark.image?)