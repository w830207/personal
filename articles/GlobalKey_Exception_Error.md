## 情況
實習公司的Fluttr APP有關首頁的跳轉頁面，有時會出現GlobalKey重複的無限例外報錯。
這些GlobalKey是用來記錄滾動捲軸裡widget的位置，保障返回首頁時捲軸狀態不變。

## 例外報錯
在我努力的測試後，發現只有登入前會出現這種錯誤。
離開首頁時會因為使用者未登入，被中間件轉到登入頁，回來首頁後會顯示：**Duplicate GlobalKeys detected in widget tree.**

GlobalKey重複出現了🤔️🤔️🤔️

![Exception1.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/92ab10c6358d49f99c3af902fd6fb152~tplv-k3u1fbpfcp-watermark.image?)

然後滑動捲軸時出現地獄式無限例外報錯：**Multiple widgets used the same GlobalKey.**

多個widget同個GlobalKey。

![Exception2.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5584ad9d699a424b88b5ee6fd13a9074~tplv-k3u1fbpfcp-watermark.image?)

一開始完全摸不著頭腦，但問題發生在登入前從登入頁回來的首頁。應該從路由跳轉來分析。

## 路由
路由使用的是Getx的快捷路由。
-   Get.toName : Navigation.pushNamed() shortcut.Pushes a new named page to the stack.
-   Get.offName : Navigation.pushReplacementNamed() shortcut.Pop the current named page in the stack and push a new one in its place.

Home 登入前跳轉 使用Get.toName("/login")的話，被中間件轉到login ，所以路由stack：home、login。

Login 返回用的是Get.offName("/home")，所以路由stack：home、home就有兩個home，從而引起錯誤。

所以只要我努力一點重複上面兩個步驟就可以把路由stack塞的很深😳。（並沒有什麼軟用）

路由stack：“好深！”

![截圖 2022-01-03 下午3.39.47.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/13975bf05548447ca03774a9c1204df0~tplv-k3u1fbpfcp-watermark.image?)

## 解決方法

由於Get.offName 離開home，Element unmount 會調用_unregisterGlobalKey，捲軸位置會遺失。所以我目前採取的解決方法是，登入前首頁的跳轉全部使用Get.offName，登入後使用Get.otName（除了底部導航跳轉）來保留捲軸位置。