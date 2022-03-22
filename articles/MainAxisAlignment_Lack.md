# 前言

![ui.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ed65e79ed9e141f0b67a4c94251613c5~tplv-k3u1fbpfcp-watermark.image?)

最近UI小姐姐給我的畫面裡有個足球球隊陣容排列，排個4-3-3之類的。

本來以為很簡單用Column或Row設定一下mainAxisAlignment就可以輕鬆解決，但是圖中兩個3要求中間的空是兩側的一半，看了MainAxisAlignment裡居然沒有我要的！！！

雖然可以用別的方式實現，以Row為例，👇我這裡用Spacer()。


![my.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/15cc4d6bd8ea4e838bac32392b05b881~tplv-k3u1fbpfcp-watermark.image?)

```
Row(
  children: [
    Spacer(flex: 2),
    Container(
      color: Colors.*lightBlue*,
      width: 50,
      height: 50,
    ),
    Spacer(flex: 1),
    Container(
      color: Colors.*amber*,
      width: 50,
      height: 50,
    ),
    Spacer(flex: 1),
    Container(
      color: Colors.*green*,
      width: 50,
      height: 50,
    ),
    Spacer(flex: 2),
  ],
)
```

Spacer()可讓留空按比例呈現，很靈活，但我總覺得不夠好，不夠方便。

所以我打算直接修改源碼！造一個客製化的自己的MainAxisAlignment排列方式！

# MainAxisAlignment

看源碼flex.dart 文件，MainAxisAlignment定義了6種(方便觀看刪去註釋)。

```
enum MainAxisAlignment {
  start,
  end,
  center,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}
```
實際在計算位置的時候定義了三個變量：

```
///我的理解

///剩餘的空間
final double remainingSpace = math.max(0.0, actualSizeDelta);
///前面的空間，在column可看作上方的空間，在row可看作左邊的空間
late final double leadingSpace;
///間隔空間，子組件之間的空間
late final double betweenSpace;
```

通過switch六種MainAxisAlignment改變上面👆三個變量來排版。

### MainAxisAlignment.start

![start.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/44f34c16779e40adb7483047b72be302~tplv-k3u1fbpfcp-watermark.image?)

註釋：
```
/// Place the children as close to the start of the main axis as possible.
///
/// If this value is used in a horizontal direction, a [TextDirection] must be
/// available to determine if the start is the left or the right.
///
/// If this value is used in a vertical direction, a [VerticalDirection] must be
/// available to determine if the start is the top or the bottom.
```

在switch裡：
```
//剩餘空間全部放到後方，子組件緊密排列。
case MainAxisAlignment.start:
  leadingSpace = 0.0;
  betweenSpace = 0.0;
  break;
```



### MainAxisAlignment.end


![end.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1bf90bcd01294facbec8ccab1f1ef6ed~tplv-k3u1fbpfcp-watermark.image?)

註釋：
```
/// Place the children as close to the end of the main axis as possible.
///
/// If this value is used in a horizontal direction, a [TextDirection] must be
/// available to determine if the end is the left or the right.
///
/// If this value is used in a vertical direction, a [VerticalDirection] must be
/// available to determine if the end is the top or the bottom.
```

在switch裡：
```
//剩餘空間全部放到前面，子組件從緊密排列。
case MainAxisAlignment.end:
  leadingSpace = remainingSpace;
  betweenSpace = 0.0;
  break;
```



### MainAxisAlignment.center

![center.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d4063c1be7304d66887d3677f710525e~tplv-k3u1fbpfcp-watermark.image?)

註釋：
```
/// Place the children as close to the middle of the main axis as possible.
```
在switch裡：
```
//剩餘空間左右(上下)平分，子組件緊密排列。
case MainAxisAlignment.center:
  leadingSpace = remainingSpace / 2.0;
  betweenSpace = 0.0;
  break;
```



### MainAxisAlignment.spaceBetween

![spaceBetween.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/19345e6056b54a57986ef221db4168ff~tplv-k3u1fbpfcp-watermark.image?)

註釋：
```
/// Place the free space evenly between the children.
```
在switch裡：
```
//前後方0空間，剩餘空間平分到子組件中間。
case MainAxisAlignment.spaceBetween:
  leadingSpace = 0.0;
  betweenSpace = childCount > 1 ? remainingSpace / (childCount - 1) : 0.0;
  break;
```



### MainAxisAlignment.spaceAround

![spaceAround.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/01ef727e2e4b432c9589f80281dc563f~tplv-k3u1fbpfcp-watermark.image?)

註釋：
```
/// Place the free space evenly between the children as well as half of that
/// space before and after the first and last child.
```
在switch裡：
```
//兩側空間是間隔空間的一半。
case MainAxisAlignment.spaceAround:
  betweenSpace = childCount > 0 ? remainingSpace / childCount : 0.0;
  leadingSpace = betweenSpace / 2.0;
  break;
```



### MainAxisAlignment.spaceEvenly

![spaceEvenly.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/fb40ffecb77d402bbfd818960c6ddaad~tplv-k3u1fbpfcp-watermark.image?)

註釋：
```
/// Place the free space evenly between the children as well as before and
/// after the first and last child.
```
在switch裡：
```
//均分剩餘空間。
case MainAxisAlignment.spaceEvenly:
  betweenSpace = childCount > 0 ? remainingSpace / (childCount + 1) : 0.0;
  leadingSpace = betweenSpace;
  break;
```

# 修改源碼

flutter的好處(？)之一，你可以直接修改原代碼。他會跳出提示，OK按下去😁😁。注意修改後升級flutter會跳出警告，大概意思指你改了源碼，升級後會消失這樣。如果這個修改很重要建議備份。
![show.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/28e4b409538b46488ab8e05ea104928a~tplv-k3u1fbpfcp-watermark.image?)

首先在枚舉裡面加入自訂的內容
```
enum MainAxisAlignment {
  start,
  end,
  center,
  spaceBetween,
  spaceAround,
  spaceEvenly,
  
  ///訂製排版child之間空間是兩側的一半
  mySpaceAround,
}
```

因為  
$後方空間 = 前方空間 = 2*間隔空間$  
$間隔空間數量 = 子組件數量-1$

所以   
$間隔空間 = 剩餘空間 / (子組件數量+3)$

在switch裡：

```
case MainAxisAlignment.mySpaceAround:
  betweenSpace = remainingSpace / (childCount+3);
  leadingSpace = betweenSpace *2;
  break;
```

然後就可以直接用啦！！！

```
Row(
  mainAxisAlignment: MainAxisAlignment.mySpaceAround,
)
```

別人要跑你的code的話，你必須丟給他一份改過的源碼～～