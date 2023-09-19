//
//  ManageAccountViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 09/08/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import Kingfisher
import ActionSheetPicker_3_0
import DropDown
import Photos

class ManageAccountViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var changePasswod: UIView!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var deleteAccountBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var changeNameBtn: UIButton!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var changeImageBtn: UIButton!
    
    let imagePicker = UIImagePickerController()
    private var imageTemp: UIImage?
    private let storage = Storage.storage().reference()
    private var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureChangePassword = UITapGestureRecognizer(target: self, action: #selector(goToChangePassword))
        
        tapGestureChangePassword.delegate = self
        
        changePasswod.addGestureRecognizer(tapGestureChangePassword)
        databaseRef = Database.database().reference()
        
        setUI()
    }
    
    func setUI(){
        nameTxt.isEnabled = false
        nameTxt.borderStyle = .none
        
        setUIAvartar(image: image)
        setUIButton(button: logOutBtn)
        setUIButton(button: deleteAccountBtn)
        
        email.text = UserDefaults.standard.string(forKey: "email")
        LoadDataAccount()
    }
    
    func LoadDataAccount(){
        getDataAccount { name,image in
            self.nameTxt.text = name
            if let imageURL = URL(string: image) {
                self.image.kf.setImage(with: imageURL)
            }
        }
    }
    
    func handleChooseAvatar() {
        let alertViewController = UIAlertController(title: "Chọn Ảnh", message: "", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openFromCamera()
        }
        let gallery = UIAlertAction(title: "Bộ sưu tập", style: .default) { (_) in
            self.openFromLibrary()
        }
        let cancel = UIAlertAction(title: "Huỷ bỏ", style: .cancel) { (_) in
            
        }
        alertViewController.addAction(camera)
        alertViewController.addAction(gallery)
        alertViewController.addAction(cancel)
        self.present(alertViewController, animated: true)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    private func uploadImage(_ image: UIImage) {
        guard let imageData = image.pngData() else {
            return
        }
        
        let imageRef = storage.child("account/\(Auth.auth().currentUser?.uid ?? "")/image.jpg")
        
        // Tải lên ảnh thú cưng
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error updating pet image: \(error)")
                return
            }
            
            // Lấy URL tải về ảnh thú cưng
            imageRef.downloadURL { url, error in
                guard let downloadURL = url, error == nil else {
                    print("Failed to get download URL")
                    return
                }
                
                // Lưu URL vào cơ sở dữ liệu
                self.databaseRef.child("account/\(Auth.auth().currentUser?.uid ?? "")/image").setValue(downloadURL.absoluteString)
                
                // Cập nhật ảnh trong giao diện
                DispatchQueue.main.async {
                    self.image.image = image
                }
            }
        }
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            
            UserDefaults.standard.removeObject(forKey: "isLoggedIn")
            UserDefaults.standard.removeObject(forKey: "email")
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                appDelegate.window?.rootViewController = loginVC
            }
        }catch{
            self.showAlert(title: "Error", message: "Logout failure")
        }
    }
    
    @IBAction func changeImageAction(_ sender: Any) {
        guard let currentUser = Auth.auth().currentUser?.uid else {
            return
        }
        imagePicker.delegate = self
        handleChooseAvatar()
    }
    
    @IBAction func changeNameTxt(_ sender: Any) {
        nameTxt.isEnabled = true
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteAccountAction(_ sender: Any) {
        if let account = Auth.auth().currentUser {
            account.delete { error in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.showAlert(title: "Success", message: "Account delete succesfull")
                }
            }
        }
    }
    
    @objc func goToChangePassword(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let changePassword = storyboard.instantiateViewController(withIdentifier: "ChangePasswordViewController")
        navigationController?.pushViewController(changePassword, animated: true)
    }
    

}
extension ManageAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func openSettingCamera() {
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        DispatchQueue.main.async {
            UIApplication.shared.open(settingURL)
        }
    }
    
    func openFromLibrary() {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            
            if status == .authorized {
                //Quyền truy cập thư viện đã được cấp
                DispatchQueue.main.async {
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .photoLibrary
                    self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                    self.imagePicker.modalPresentationStyle = .popover
                    self.present(self.imagePicker, animated: true)
                }
                
            } else if status == .notDetermined {
                //Quyền truy cập chưa được xác nhậnVxin
                self.openSettingCamera()
            } else if status == .denied {
                //Quyền truy cập bị từ chối
                self.openSettingCamera()
            } else if status == .limited {
                //Quyền truy cập bị hạn chế
                self.openSettingCamera()
            } else if status == .restricted {
                //Quyền truy cập bị hạn chế
                self.openSettingCamera()
            }
        }
    }
    
    func openFromCamera() {
        AVCaptureDevice.requestAccess(for: .video) { response in
            if response {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    DispatchQueue.main.async {
                        self.imagePicker.allowsEditing = true
                        self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                        self.imagePicker.modalPresentationStyle = .fullScreen
                        self.present(self.imagePicker, animated: true)
                    }
                } else {
                    self.showAlert(title: "Lỗi", message: "Camera không có sẵn")
                }
            } else {
                print("Camera is denied")
                self.openSettingCamera()
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            //handle image
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 300, height: 300))
            DispatchQueue.main.async {
                self.image.image = resizedImage
            }
            imageTemp = resizedImage
            uploadImage(image)
            
        } else if let image = info[.editedImage] as? UIImage {
            //handle image
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 300, height: 300))
            DispatchQueue.main.async {
                self.image.image = resizedImage
            }
            imageTemp = resizedImage
        } else if let image = info[.cropRect] as? UIImage {
            //handle image
            let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 300, height: 300))
            self.image.image = resizedImage
            imageTemp = resizedImage
        }
        
        imagePicker.dismiss(animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true)
    }
}
