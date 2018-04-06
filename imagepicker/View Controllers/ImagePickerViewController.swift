//
//  ImagePickerViewController.swift
//  Final Year Project
//
//  Created by Eoghan Casey on 17/01/2018.
//  Copyright © 2018 Eoghan Casey. All rights reserved.
//

import UIKit
import SwiftyJSON
import LocalAuthentication
import UserNotifications
import Moltin


class ImagePickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var products: [Product] = []
    var category: ProductCategory!
    
    
    
    let imagePicker = UIImagePickerController()
    let session = URLSession.shared
    
    var choosePicButtonCenter: CGPoint!
    var takePicButtonCenter: CGPoint!
    var searchButtonCenter: CGPoint!
    var userHelperCenter: CGPoint!
    var helpButtonCenter: CGPoint!
    
    var googleAPIKey = "AIzaSyCv04_8KAF1A8_fKy3EV5h9ngOwPXWFtms"
    var googleURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(googleAPIKey)")!
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var labelResults: UITextView!
    @IBOutlet weak var faceResults: UITextView!
    @IBOutlet weak var allResults: UITextView!
    
   //our annimated menu buttons
    @IBOutlet weak var takePic: UIButton!
    @IBOutlet weak var choosePic: UIButton!
    @IBOutlet weak var more: UIButton!
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var userHelper: UITextField!
    @IBOutlet weak var helpButton: UIButton!
    
    //users manually entered info
    @IBOutlet weak var userInfo: UITextField!
    
    
    
    @IBAction func searchClicked(_ sender: Any) {
        searchMyStore()
//        searchTheWeb()
        
    }
    
    
    
    @IBAction func selectClicked(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func takePicClicked(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func infoClicked(_ sender: UIButton) {
        helpButton.adjustsImageWhenHighlighted = false
        
        if helpButton.currentImage == #imageLiteral(resourceName: "info") {
            UIView.animate(withDuration: 0.3, animations: {
                self.userHelper.alpha = 1
                
                self.userHelper.center = self.userHelperCenter
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.userHelper.alpha = 0
                
                self.userHelper.center = self.helpButton.center
            })
        }
        if sender.currentImage == #imageLiteral(resourceName: "info") {
            sender.setImage(#imageLiteral(resourceName: "blackInfo"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "info"), for: .normal)
        }
    }
    @IBAction func moreClicked(_ sender: UIButton) {
        more.adjustsImageWhenHighlighted = false
        
        if more.currentImage == #imageLiteral(resourceName: "horizDots") {
            UIView.animate(withDuration: 0.3, animations: {
                self.takePic.alpha = 1
                self.choosePic.alpha = 1
                self.search.alpha = 1
                self.helpButton.alpha = 1
                
                
                self.takePic.center = self.takePicButtonCenter
                self.choosePic.center = self.choosePicButtonCenter
                self.search.center = self.searchButtonCenter
                
                self.helpButton.center = self.helpButtonCenter
                
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.takePic.alpha = 0
                self.choosePic.alpha = 0
                self.search.alpha = 0
                self.userHelper.alpha = 0
                self.helpButton.alpha = 0
                
                
                self.takePic.center = self.more.center
                self.choosePic.center = self.more.center
                self.search.center = self.more.center
                self.userHelper.center = self.more.center
                self.helpButton.center = self.more.center
            })
            
        }
        if sender.currentImage == #imageLiteral(resourceName: "horizDots") {
            sender.setImage(#imageLiteral(resourceName: "verticalDots"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "horizDots"), for: .normal)
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //changing the colour of the navigation bar content
        UIApplication.shared.statusBarStyle = .default
        
        
        
//        view.bringSubview(toFront: more)
        
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        labelResults.isHidden = true
        faceResults.isHidden = true
        spinner.hidesWhenStopped = true
        
        choosePicButtonCenter = choosePic.center
        takePicButtonCenter = takePic.center
        searchButtonCenter = search.center
        userHelperCenter = userHelper.center
        helpButtonCenter = helpButton.center
        
        //hide buttons behind expand button
        choosePic.center = more.center
        takePic.center = more.center
        search.center = more.center
        userHelper.center = more.center
        helpButton.center = more.center
        //This should allow me to edit the value of this TextView as if it's a String variable, should.
        labelResults.delegate = self
        
        
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

/// Image processing

extension ImagePickerViewController {
    
    
    func analyzeResults(_ dataToParse: Data) {
        
        // Update UI on the main thread
        DispatchQueue.main.async(execute: {
            
            
            // Use SwiftyJSON to parse results
            let json = JSON(data: dataToParse)
            let errorObj: JSON = json["error"]
            
            self.spinner.stopAnimating()
//            self.imageView.image = pickedImage
            self.labelResults.isHidden = false
            self.faceResults.isHidden = false
            self.faceResults.text = ""
            
            // Check for errors
            if (errorObj.dictionaryValue != [:]) {
                self.faceResults.text = "Error code \(errorObj["code"]): \(errorObj["message"])"
            } else {
                // Parse the response
                print(json)
                let responses: JSON = json["responses"][0]
                
                // Get label annotations
                let labelAnnotations: JSON = responses["labelAnnotations"]
                let numLabels: Int = labelAnnotations.count
                var labels: Array<String> = []
                if numLabels > 0 {
                    var labelResultsText:String = " "
                    for index in 0..<numLabels {
                        let label = labelAnnotations[index]["description"].stringValue
                        labels.append(label)
                    }
                    for label in labels {
                        // if it's not the last item add a comma
                        if labels[labels.count - 1] != label {
                            labelResultsText += "\(label), "
                        } else {
                            labelResultsText += "\(label)."
                        }
                    }
                    self.labelResults.text = labelResultsText
                } else {
                    self.labelResults.text = "No labels found"
                }
                
//             //Get logo annotations
                let logoAnnotations: JSON = responses["logoAnnotations"]
                let numLogos: Int = logoAnnotations.count
                var logos: Array<String> = []
                if numLogos > 0 {
                    var faceResultsText:String = " "
                    for index in 0..<numLogos {
                        let logo = logoAnnotations[index]["description"].stringValue
                        logos.append(logo)
                    }
                    for logo in logos {
                        if logos[logos.count - 1] != logo {
                            faceResultsText += ", \(logo), "
                        } else {
                            faceResultsText += "\(logo),"
                        }
                    }
                    self.faceResults.text = faceResultsText
                } else {
                    self.faceResults.text = ""
                }
            }
            
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            spinner.startAnimating()

            
            // Base64 encode the image and create the request
            let binaryImageData = base64EncodeImage(pickedImage)
            createRequest(with: binaryImageData)
        }
        
        dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        imageView.layer.cornerRadius = 10

        return resizedImage!
        
    }
}
/// Networking

extension ImagePickerViewController {
    func base64EncodeImage(_ image: UIImage) -> String {
        var imagedata = UIImagePNGRepresentation(image)
        
        // Resize the image if it exceeds the 2MB API limit
        if (imagedata?.count > 2097152) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imagedata = resizeImage(newSize, image: image)
        }
        
        return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    
    //In the notification, if there is no product found in my inventory then let the alert button search the web
    func searchMyStore(){
        
        let searchText = self.userInfo.text
        let newQuery = MoltinQuery(
            offset: nil,
            limit: nil,
            sort: nil,
            filter: "eq(description, \(String(describing: searchText)))",
            include: [])
        
        
        Moltin.product.list(withQuery: newQuery) { result in
            switch result {
            case .success(let productList):
                
                
                let newProductList = productList.products.filter { $0.name == searchText }
                print(newProductList.self)

            
                if newProductList.count == 1 {

                    let controller = ProductDetailViewController()
                    controller.product = newProductList.first!
                    self.navigationController?.pushViewController(controller, animated: true)

                } else {

                    let alert = UIAlertController(title: "We're Sorry", message: "We found no matching results.", preferredStyle: UIAlertControllerStyle.alert)

                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    let search = UIAlertAction(title: "Search The Web!", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                        self.searchTheWeb()
                    })
                    alert.addAction(search)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            case .failure(let error): break
            }
        }
    }
    
    func searchTheWeb(){
        let word =  self.userInfo.text! + self.faceResults.text!  + self.labelResults.text!
        if let encoded = word.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: "https://www.google.com/#q=\(encoded)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func createRequest(with imageBase64: String) {
        // Create our request URL
        
        var request = URLRequest(url: googleURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        
        // Build our API request
        let jsonRequest = [
            "requests": [
                "image": [
                    "content": imageBase64
                ],
                "features": [
                    [
                        "type": "LABEL_DETECTION",
                        "maxResults": 5
                    ],
                    [
                        "type": "LOGO_DETECTION",
                        "maxResults": 2
                    ],
                    [
                        "type": "IMAGE_PROPERTIES",
                        "maxResults": 3
                    ]
                ]
            ]
        ]
        let jsonObject = JSON(jsonDictionary: jsonRequest)
        // Serialize the JSON
        guard let data = try? jsonObject.rawData() else {
            return
        }
        request.httpBody = data
        // Run the request on a background thread
        DispatchQueue.global().async { self.runRequestOnBackgroundThread(request) }
    }
    func runRequestOnBackgroundThread(_ request: URLRequest) {
        // run the request
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            self.analyzeResults(data)
        }
        task.resume()
    }
}
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
