//
//  ViewController.swift
//  CameraShareApp
//
//  Created by Sho Nozaki on 2018/09/09.
//  Copyright © 2018年 sho.nozaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var closedViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 写真削除ボタンの表示判定
        if (photoImageView != nil) {
            closedViewButton.isHidden = true // 写真削除ボタンの非表示設定
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     カメラ撮影完了時に呼ばれる処理
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let cmopletedImageView = photoImageView else {
            return
        }
        cmopletedImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage // 撮影した写真の取得・設定
        closedViewButton.isHidden = false // 写真削除ボタンの表示設定
        self.view.sendSubview(toBack: cmopletedImageView)
        dismiss(animated: true, completion: nil) // カメラのダイアログを閉じる
    }
    
    /*
     撮影キャンセル時に呼ばれる処理
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("撮影がキャンセルされました")
        closedViewButton.isHidden = true // 写真削除ボタンの非表示設定
        picker.dismiss(animated: true, completion: nil)
    }

    /*
     カメラ起動
     */
    @IBAction func cameraLaunchAction(_ sender: Any) {
        
        // カメラの起動確認
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("カメラは使用可能です")
            // カメラのデータ取得
            let ipc = UIImagePickerController()
            ipc.sourceType = .camera
            ipc.delegate = self
            present(ipc, animated: true, completion: nil) // カメラのダイアログ表示
        } else {
            print("カメラは使用不可能です")
            let alert = UIAlertController(title: nil, message: "カメラの起動に失敗しました", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
  
    /*
     SNS投稿
     
     - comment: nilの許容忘れによるエラー(80行) → https://qiita.com/motokiee/items/f9b2678d22ad06599308
     */
    @IBAction func shareAction(_ sender: Any) {
        //
        if let shareImage = photoImageView?.image {
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
    
    /*
     写真ライブラリ
     - TODO: 遅延処理以外の方法を検討する
     */
    @IBAction func photoLibraryAction(_ sender: Any) {
        let ipc = UIImagePickerController()
        ipc.sourceType = .photoLibrary
        ipc.delegate = self
        present(ipc, animated: true, completion: nil)
        // 遅延処理 → 1秒後に実行 TODO:closeボタンの表示タイミングは改善が必要
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.closedViewButton.isHidden = false
        }
    }
    
    /*
     写真削除
     */
    @IBAction func closedViewAction(_ sender: Any) {
        print("写真を削除する処理")
        if let removeImageView = photoImageView {
            closedViewButton.isHidden = true
            removeImageView.removeFromSuperview()
        }
    }
    
}

