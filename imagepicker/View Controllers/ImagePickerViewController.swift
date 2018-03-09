// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import SwiftyJSON
import LocalAuthentication
import UserNotifications


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
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
        searchTheResults()
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
        
        
        
        view.bringSubview(toFront: more)
        
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
        
        
        
        
        //Testing out the Notification functionality
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.body = "Body"
        content.sound = UNNotificationSound.default()
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
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

extension ViewController {
    
    
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
                
////                // Get face annotations
//                let faceAnnotations: JSON = responses["faceAnnotations"]
//                if faceAnnotations != nil {
//                    let emotions: Array<String> = ["joy", "sorrow", "surprise", "anger"]
//
//                    let numPeopleDetected:Int = faceAnnotations.count
//
//                    self.faceResults.text = "Faces detected: \(numPeopleDetected)\n\nEmotions detected:\n"
//
//                    var emotionTotals: [String: Double] = ["sorrow": 0, "joy": 0, "surprise": 0, "anger": 0]
//                    var emotionLikelihoods: [String: Double] = ["VERY_LIKELY": 0.9, "LIKELY": 0.75, "POSSIBLE": 0.5, "UNLIKELY":0.25, "VERY_UNLIKELY": 0.0]
//
//                    for index in 0..<numPeopleDetected {
//                        let personData:JSON = faceAnnotations[index]
//
//                        // Sum all the detected emotions
//                        for emotion in emotions {
//                            let lookup = emotion + "Likelihood"
//                            let result:String = personData[lookup].stringValue
//                            emotionTotals[emotion]! += emotionLikelihoods[result]!
//
//                        }
//                    }
//                    // Get emotion likelihood as a % and display in UI
//                    for (emotion, total) in emotionTotals {
//                        let likelihood:Double = total / Double(numPeopleDetected)
//                        let percent: Int = Int(round(likelihood * 100))
//                        self.faceResults.text! += "\(emotion): \(percent)%\n"
//                    }
//                } else {
//                    self.faceResults.text = "No faces found"
//                }

                

                // Get label annotations
                let labelAnnotations: JSON = responses["labelAnnotations"]
                let numLabels: Int = labelAnnotations.count
                var labels: Array<String> = []
                if numLabels > 0 {
                    var labelResultsText:String = ", "
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
                    var faceResultsText:String = " ,"
                    for index in 0..<numLogos {
                        let logo = logoAnnotations[index]["description"].stringValue
                        logos.append(logo)
                    }
                    for logo in logos {
                        if logos[logos.count - 1] != logo {
                            faceResultsText += ", \(logo), "
                        } else {
                            faceResultsText += "\(logo)."
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
    
    
//    faceResults.isHidden = true
//    labelResults.isHidden = true
    
    
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

extension ViewController {
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
    
    func searchTheResults(){
        let word = self.faceResults.text + self.userInfo.text! + self.labelResults.text
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
                        "maxResults": 8
                    ],
                    [
                        "type": "FACE_DETECTION",
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



//@IBAction func testTuch(_ sender: Any) {
//    TouchIDCall()
//}
//
//func TouchIDCall(){
//    let authContext : LAContext = LAContext()
//    var error : NSError?
//
//    if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error){
//
//        authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Confirm Payment?", reply: {
//            (wasSuccesful : Bool, error : Error?) in
//
//            if wasSuccesful{
//                self.searchWeb()
//            } else{
//                NSLog("NO")
//            }
//        })
//
//    } else {
//
//    }
//}

//    @IBAction func takePhoto(_ sender: Any) {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//    }
//
//    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .photoLibrary
//
//        present(imagePicker, animated: true, completion: nil)
//    }


//                let propertiesAnnotations: JSON = responses["propertiesAnnotations"]
//                if propertiesAnnotations != nil {
//                    let colours: Array<String> = ["red", "green", "blue"]
//
//                    var colourTotals: [String: Double] = ["red": 0, "green": 0, "blue": 0]
//                    var colourLikelihoods: [String:]
//                }


//    @IBAction func searchWeb(_ sender: Any) {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//
//        }
