


# 二階貝茲曲線動畫
----
**創建動畫與動畫控制器**

```js
    animationController = AnimationController(
        duration: const Duration(milliseconds: 5000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInCirc));
```

