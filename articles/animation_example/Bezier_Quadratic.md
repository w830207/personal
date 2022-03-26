# 二階貝茲曲線動畫
----
**貝茲原理與公式**

![](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/B%C3%A9zier_2_big.svg/480px-B%C3%A9zier_2_big.svg.png)
![](https://i.imgur.com/xWWfaDZ.jpg)
需要設置三個點

**創建動畫與動畫控制器**

```js
    animationController = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInCirc));
```

**AnimatedBuilder**
setstate會整體刷新，AnimatedBuilder會根據參數animation局部刷新。

```js
AnimatedBuilder(
        child: Image.asset(
          widget.imageAsset,
          width: 50,
        ),
        animation: animation,
        builder: (context, child) {
          double x0 = 100.0;
          double y0 = 100.0;

          double x2 = 1000.0;
          double y2 = 800.0;

          double x1 = (x0 + x2) * 0.7;
          double y1 = y0 - 80;

          return Transform.translate(
            offset: Offset(
                pow(1 - animation.value, 2) * x0 +
                    2 * animation.value * (1 - animation.value) * x1 +
                    pow(animation.value, 2) * x2,
                pow(1 - animation.value, 2) * y0 +
                    2 * animation.value * (1 - animation.value) * y1 +
                    pow(animation.value, 2) * y2),
            child: child,
          );
        })
```