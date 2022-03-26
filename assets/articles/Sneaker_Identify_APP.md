
# 前言
----
身為一個大學生，為了專題在掘金上自學flutter很久，也想來模仿大佬們寫寫開發學習的文章。

我和同學從喜歡的球鞋入手想製作一款球鞋辨識的APP，但是球鞋品牌型號實在太多太雜，網上也沒有品牌公開完整的鞋款型錄，這對我們的起步造成很大困難。所以我們從YEEZY入手，從stockX選了12個型號共84款配色開始，自行爬取資料、訓練圖像分類模型。

模型訓練的很醜，就不分享了，主要分享APP建構的思路與內容，如有錯誤麻煩各位大大指正。


# 插件
----

![get.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/46077835316e497bbd856d953e8ee540~tplv-k3u1fbpfcp-watermark.image?)

- [get](https://pub.dev/packages/get)
  即getx，方便易學的狀態管理、路由管理。

- [tflite](https://pub.dev/packages/tflite)
  可使用TensorFlow Lite的插件。pub.dev上有配置方法。

- [image_picker](https://pub.dev/packages/image_picker)
  熱門插件，可以使用手機的圖庫和相機獲取圖片。

- [firebase_core](https://pub.dev/packages/firebase_core)
  使用firebase插件都要有。

- [cloud_firestore](https://pub.dev/packages/cloud_firestore)
  Cloud Firestore API，我們把爬取來的球鞋信息存在NoSQL的Firestore裡。


# 思路
----
**0. 首先**

創建controller，把邏輯都寫在這裡。

```js
import 'package:get/get.dart';
class Controller extends GetxController { }
```

**1. 加載模型**

使用tflite插件，加載模型和標籤

```js
import 'package:tflite/tflite.dart';

loadModel() async {
    await Tflite.loadModel(
        model: "assets/models/YOURMODEL.tflite",
        labels: "assets/models/YOURLABEL.txt");
  }
```

**2. 獲取圖片**


```js
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();
late final theImage = XFile("").path.obs;
///使用相機
  openCamera() async {
    var pathC = (await _picker.pickImage(source: ImageSource.camera));
    theImage.value = pathC!.path;
  }
  ///使用相冊
  openGallery() async {
    var pathG = (await _picker.pickImage(source: ImageSource.gallery));
    theImage.value = pathG!.path;
  }
```

**3. 辨識圖片**


```js
RxString output = ''.obs;

runModelOnImage() async{
    var res = await Tflite.runModelOnImage(
      path: theImage.value,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
    );
    output.value = res[0]['label'];
}

```

**4. 獲取球鞋資訊**

辨識完得到標籤內容後，去firestore撈在StockX上爬來的資料。

四種資料：圖片網址、最低售價、最高買價、上次成交價。

```js
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
  //賦予初始值
  RxString imageURL =
      'https://findicons.com/files/icons/1008/quiet/256/no.png'.obs;
  RxString highestBid = 'Highest Bid'.obs;
  RxString lowestAsk = 'Lowest Ask'.obs;
  RxString lastSale = 'Last Sale'.obs;

  getData() async {
    await Firebase.initializeApp();
    //路徑因人而異
    var data = await FirebaseFirestore.instance
        .collection(type.value)
        .doc(output.value)
        .get();

    imageURL.value = data.data()!['IMAGE URL'];
    lowestAsk.value = data.data()!['Lowest Ask'];
    lastSale.value = data.data()!['Last Sale'];
    highestBid.value = data.data()!['Highest Bid'];
  }
```

# 最後
----
- 感謝掘金的大佬們讓我學到不少
- 第一次寫文章有點不知所措，請各位見諒
- 細節和畫面等不重要的地方就不放上來了
- 這個小專案已經放在github上 [鏈結](https://github.com/w830207/yeezyid_bygetx)