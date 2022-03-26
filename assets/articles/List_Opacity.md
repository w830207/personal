本文已参与「新人创作礼」活动，一起开启掘金创作之路。

![透明度.gif](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c70ff231a85141c99468a9070541dada~tplv-k3u1fbpfcp-watermark.image?)

# 前言
----
公司前輩要我把產品的列表加一點效果。

為了不要太花俏，透明度的變化效果-淡出淡入是不二選擇。

我的思路是吧滾動列表裡的項目根據列表滾動的距離做變化。

# 思路
----
**列表的總長度** 是 **列表內容** **超出畫面** 的長度！（個人理解如有錯誤歡迎大家指出。）

所以假設列表公有a個items，畫面容納b個，所以列表總長度是a-b個items的長度。

需要知道滑動的百分比,滑動0 到 1/(a-b)位置是第一個淡出item、滑動1/(a-b) 到 2/(a-b)位置是第二個淡出item，以此類推。
```js
//getx的寫法，可以用setstate取代
scrollController.addListener(() {
      scrollLevel.value =
          scrollController.offset / scrollController.position.maxScrollExtent;
});
```

我這裡的情況是畫面可以容納2個，items存在list裡，所以列表總長度 list.length-2個長度

假設滑動到item的一般開始淡出，也就是滑動到$(0.5 + index) / (this.games.length - 2)$時開始淡出


所以  $scrollLevel.value -
(0.5 + index) / (this.games.length - 2)$ 就是 超出item一半的位置

半個items的長度 是 $0.5 / (this.games.length - 2)$

有點小複雜，組合起來後的樣子
```js
//計算不透明度
                opacity() {
                  double opa = 1 -
                      ((scrollLevel.value -
                              ((0.5 + index) / (this.games.length - 2))) /
                          (0.5 / (this.games.length - 2)));
                  if (opa >= 1) return 1.0;
                  if (opa <= 0) return 0.0;
                  return opa;
                }
```

在用透明度widget抱起來就好啦！！
```js
 Opacity(
   opacity: opacity(),
   child: Container(),
 )                       
```


        

