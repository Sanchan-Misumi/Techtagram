//
//  ViewController.swift
//  Techtatagram
//
//  Created by Maho Misumi on 2018/05/29.
//  Copyright © 2018年 Maho Misumi. All rights reserved.
//

import UIKit
//写真をSNSに投稿したい時に必要なフレームワーク
import Accounts

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var cameraImageView: UIImageView!
    
    //画像加工するための元となる画像
    var originalImage: UIImage!
    
    //画像加工するフィルターの宣言
    var filter: CIFilter!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //撮影するときのメソッド
    @IBAction func useCamera(){
        //カメラが使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //カメラを起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            
            present(picker, animated:true,completion: nil)
            
        } else{
            print("error")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        cameraImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        originalImage = cameraImageView.image
        
        dismiss(animated: true, completion: nil)
    }
    
    //表示している画像にフィルター加工するメソッド
    @IBAction func applyFilter(){
        
        let filterImage: CIImage = CIImage(image: originalImage)!
        
        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        //彩度の調整
        filter.setValue(1.0, forKey: "inputSaturation")
        //明度の調整
        filter.setValue(0.5, forKey: "inputBrightness")
        //コントラストの調整
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
        
    }
    
    //編集した画像を保存するためのメソッド
    @IBAction func save(){
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
    }
    
    //カメラロールにある画像を読み込むメソッド
    @IBAction func openAlbum(){
        //カメラロールを使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            //カメラロールの画像を選択して画像を表示する
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            
            picker.allowsEditing = true
            
            present(picker, animated: true, completion: nil)
        }
    }
    
    //編集した画像をシェアするメソッド
    @IBAction func share(){
        //投稿する時に一緒に載せるコメント
        let shareText = "写真加工できた！"
        
        //投稿する画像の選択
        let shareImage = cameraImageView.image!
        
        //投稿するコメントと画像の準備
        let activityItems: [Any] = [shareText, shareImage]
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        let excludedActivityTypes = [UIActivityType.postToWeibo, .saveToCameraRoll, .print]
        
        activityViewController.excludedActivityTypes = excludedActivityTypes
        
        present(activityViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

