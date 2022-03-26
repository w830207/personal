## 前言
前段時間看到這篇文章 ➡️ # [🔥Flutter 那些花里胡哨的底部菜单🔥 进来绝不后悔](https://juejin.cn/post/6992127843740155918)

覺得威武酷炫屌炸天，最近公司任務量也比較少，索性自主學習就來挑一張來練習以及學習。綠色這張一看就很漂亮、很難讓人摸不著頭緒。


![9.gif](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/067a9ed481694caeaaf1b272b46549d5~tplv-k3u1fbpfcp-watermark.image?)


於是我就試做了一個簡易的醜醜版本，請大家輕噴😂，還有很多可以修改的空間。

![螢幕錄製 2022-02-24 下午1.55.51.gif](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/27a1e604d3934b7e94cac9da424304ac~tplv-k3u1fbpfcp-watermark.image?)

## 分析

動圖一直看眼睛也是很累的，也很難看清所有東西。
所以逐幀分析，釐清重點。

![截圖 2022-02-24 下午2.15.42.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/23c781ab45804492814c85d5f0f1763b~tplv-k3u1fbpfcp-watermark.image?)

![截圖 2022-02-24 下午2.16.43.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/60de0f36ae5a446697a0b572c10f4451~tplv-k3u1fbpfcp-watermark.image?)

從途中可以得到兩個重點：1.遠距離是5點在飛行，上三下二。 2.圖標變色是半圓“進入/變化”。

最後可以把動畫拆解成四個部分：
1. 圖標縮放
2. 圓點飛行
3. 圖標置換變色
4. 外環擴張  //我懶得做的了

### 圖標縮放
從最簡單的開始。

圖標從小到大再到，可以組合tween動畫來完成，從1到1.1再到1，weight比重在這裡按比例分配動畫時間。

widget使用ScaleTransition，其中scale是Animation< double >類型不像一般的組件是double類型，就不需要使用AnimationBuilder或是setState之類的來使畫面更新。

```
ScaleTransition({
    Key? key,
    required Animation  scale,
    Alignment alignment = Alignment.center,
    FilterQuality? filterQuality,
    Widget? child,
})
```
```
@override
void initState() {
  animationController =
      AnimationController(duration: Duration(milliseconds: 500), vsync: this);
  animation = TweenSequence<double>([
    TweenSequenceItem<double>(tween: Tween(begin: 1, end: 1.1), weight: 1),
    TweenSequenceItem<double>(tween: Tween(begin: 1.1, end: 1), weight: 1),
  ]).animate(animationController);
  super.initState();
}
```


```
ScaleTransition(
  scale: animation,
  child: child,
)
```

### 圓點飛行
1. 圓點會隨時間放大然後縮小
2. 要讓圓點以弧線飛行，可以使用貝茲/貝賽爾曲線，參考這篇 ➡️  [Flutter - 利用贝塞尔曲线实现添加购物车效果](https://juejin.cn/post/6844904169388638216)

上面三個點，下面兩個點，原本應該要使用一兩個AnimationController，搭配交錯動畫來讓五點作動，需要一點計算，微微麻煩。

因為我懶，所以我讓一點一個AnimationController，寫起來比較方便😊，簡單的用迴圈把5個AnimationController放到上下的List裡面

```
for (int i = 0; i < 3; i++) {
  listTop.add(AnimationController(
      vsync: this, duration: Duration(milliseconds: time)));
}

for (int i = 0; i < 2; i++) {
  listBottom.add(AnimationController(
      vsync: this, duration: Duration(milliseconds: time)));
}
```
播放動畫就可以用連續的timer播放了
```
//between是間隔時間

Timer.periodic(Duration(milliseconds: between), (timer) {
  listTop[countBottom].forward();
  countBottom++;
  if (countBottom == listTop.length) {
    timer.cancel();
    countBottom = 0;
  }
});

//上面的點提前出發
Timer(Duration(milliseconds: between ~/ 2), () {
  Timer.periodic(Duration(milliseconds: between), (timer) {
    listBottom[countTop].forward();
    countTop++;
    if (countTop == listBottom.length) {
      timer.cancel();
      countTop = 0;
    }
  });
});
```



這裡我用CustomPainter來畫圓點，使用 canvas.drawCircle

```
class PointPainter extends CustomPainter {
  final Color color;
  final List<AnimationController> listTop;
  final List<AnimationController> listBottom;
  final Offset from;
  final Offset to;

  PointPainter(this.color, this.listTop, this.listBottom, this.from, this.to);

  //取得位置
  getOffset(double time, bool bottom) {
    double x0 = from.dx;
    double y0 = from.dy;

    double x2 = to.dx;
    double y2 = to.dy;

    double x1 = (from.dx + to.dx) / 2;
    double y1 = bottom ? from.dy * 2 : 0;

    double dx =
        pow(1 - time, 2) * x0 + 2 * time * (1 - time) * x1 + pow(time, 2) * x2;
    double dy =
        pow(1 - time, 2) * y0 + 2 * time * (1 - time) * y1 + pow(time, 2) * y2;
    return Offset(dx, dy);
  }

  //取得半徑，連續的三元表達式比較醜總之半徑是0-4-0的過程
  getRadius(double time) {
    double r = time <= 0.2
        ? 20 * time
        : time <= 0.8
            ? 4
            : 20 * (1 - time);
    return r;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeWidth = 1.0
      ..color = color;

    for (int i = 0; i < listTop.length; i++) {
      canvas.drawCircle(getOffset(listTop[i].value, false),
          getRadius(listTop[i].value), paint);
    }

    for (int i = 0; i < listBottom.length; i++) {
      canvas.drawCircle(getOffset(listBottom[i].value, true),
          getRadius(listBottom[i].value), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
```

### 圖標置換變色

這裡我想到的方法是把選中前後兩個圖標用Stack疊在一起，選中前在下，選中後的在上。
然後使用Clip+動畫 動態地去剪裁選中上面的圖標，從分析圖來看是用圓來剪裁，這裡用ClipOval。

```js
ClipOval({
    Key? key,
    CustomClipper? clipper,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
})
```
其中CustomClipper? clipper可以自訂剪裁的位置和大小，所以只要動態改變位置，就可以實際半圓出現被選中圖標的動畫了。動畫可以用AnimationBuilder來做。

```
class MyClipper extends CustomClipper<Rect> {
  MyClipper({
    required this.width,
    required this.height,
    required this.left,
  });
  final double width;
  final double height;
  final double left;

  //L:left T:top W:width H:height
  @override
  Rect getClip(Size size) => Rect.fromLTWH(left, 0, width, height);

  //會動態重複剪裁，所以設true
  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}
```

最後再處理一下暈頭的按鈕交互和一些細節就大致完成了簡易版的啦！！！

## 總結

- 厲害的UI很重要😭
- 漂亮的UI更重要😭