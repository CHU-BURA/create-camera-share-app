# カメラアプリ②
[カメラアプリ①](https://github.com/CHU-BURA/create-camera-app)を再度自分なりに改善したもの。  
## 改善点
- UI部分の改善
  - 各ボタンを`UIToolbar`上に表示
  - アラートの表示
- 対象の写真を削除する機能の追加

## 対応すべき点
- 写真ライブラ展開時における写真削除ボタンの表示切り替え  
現状、遅延処理にて写真ライブラ展開後に、写真削除ボタンの表示を行っている。(`ViewController.swift`:100)

## 不具合履歴
### Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value
#### 事象内容
以下手順の場合においてアプリ側でクラッシュし、
`Threa 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value` が発生する。

#### 再現手順
1. 写真を撮影する or ライブラリから写真を選択する
2. ホーム画面に対象の写真が表示される
3. 表示された写真を削除する
4. Shareボタンを押下する

#### 対象コード
```swift
/*   
SNS投稿
*/
@IBAction func shareAction(_ sender: Any) {
  if let shareImage = photoImageView.image {  ←  【ここで発生】
    let shareItems = [shareImage]
    let avc = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
    avc.popoverPresentationController?.sourceView = view // iPad対応
    present(avc, animated: true, completion: nil) // SNS投稿用のメニュー表示
  } else {
    print("投稿する写真がありません")
    // アラート表示
    let alert = UIAlertController(title: nil, message: "投稿する写真がありません", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}
```

#### 対処
- Optional型へラップする
`removeImageView.removeFromSuperview()`により削除された`UIImageView`に対して、nilの許容を反映する。  
`photoImageView`に対して、`?`を付与してOptional型にすることでnilの代入を可能とする。  

【参考】[SwiftのOptionalとType Safety](https://qiita.com/motokiee/items/f9b2678d22ad06599308)

```swift
/*
SNS投稿
*/
@IBAction func shareAction(_ sender: Any) {
  //
  if let shareImage = photoImageView?.image {  ←  【Optional型へラップ】
    let shareItems = [shareImage]
    let avc = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
    avc.popoverPresentationController?.sourceView = view // iPad対応
    present(avc, animated: true, completion: nil) // SNS投稿用のメニュー表示
  } else {
    print("投稿する写真がありません")
    // アラート表示
    let alert = UIAlertController(title: nil, message: "投稿する写真がありません", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}
```

## 今後
- iOS12のPortraitMatteなどの機能を対応させたい。  
深度情報を操作できるようにする。  
> 【参考】
> - [[iOS 12] Portrait Matteで背景分離／セグメンテーション](https://qiita.com/shu223/items/2b4b6c048b7426474cf0) 
> - [iOSDCで「深度（デプス）」について話しました #iosdc](http://shu223.hatenablog.com/entry/2018/09/06/095452#fnref:4)
> - [デプス（深度）をiOSで扱う方法を網羅したサンプルコード集「iOS-Depth-Sampler」を公開しました](http://shu223.hatenablog.com/entry/2018/09/18/072233)
