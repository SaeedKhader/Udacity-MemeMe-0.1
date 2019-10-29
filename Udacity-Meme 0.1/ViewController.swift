//
//  ViewController.swift
//  Udacity-Meme 0.1
//
//  Created by Saeed Khader on 28/09/2019.
//  Copyright © 2019 Saeed Khader. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {

    // MARK: UI Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var cropButton: UIButton!
    
    var cropView: CropView!
    var fontView = FontView()
    
    // MARK: Properties
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.backgroundColor: UIColor.clear,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -5
    ]
   
    var previousCenterLocation: CGPoint?
    
    var activeTextView: UITextView?
    
    var orginalCanvasOriginY: CGFloat?
    
    var isDeleteModeOn: Bool = false
    
    var isCropModeOn: Bool = false
    
    var orginalImage: UIImage?
    
    var croppedImageFrame: CGRect?
    
    var keyboardHeight: CGFloat?
    
    var isTextUnderKeyboard: Bool = false
    
    struct Meme {
        let textViews: [TextMemeView]
        let orginalImage: UIImage
        let croppedImageFrame: CGRect
        let memedImage: UIImage
    }

    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        addTextButton.setTitleColor(UIColor.systemGray, for: .disabled)
  
        orginalCanvasOriginY = canvasView.frame.origin.y
        
        view.addSubview(fontView)
        fontView.setUp()
        fontView.setUpLayout()
        fontView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeToKeyboardNotification()
    }
    
    
    
    // MARK: UI Functions
    
    @IBAction func pickAnImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func takeAnImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func share() {
        let image = generateMemeImage()
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (type,completed,items,error) in
            if (completed) {
               self.save()
            }
        }
        if isDeleteModeOn { toggleDeleteMode() }
        present(activityViewController, animated: true, completion: nil)
           
    }
    
    @IBAction func addText() {

        if isDeleteModeOn { toggleDeleteMode() }
        
        let newTextView: TextMemeView = {
            let textView = TextMemeView()
            textView.typingAttributes = memeTextAttributes
            textView.delegate = self
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleTextPan))
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTextTap))
            panGestureRecognizer.delegate = self
            tapGestureRecognizer.delegate = self
            textView.addGestureRecognizer(panGestureRecognizer)
            textView.addGestureRecognizer(tapGestureRecognizer)
            textView.textAlignment = .center
            textView.isScrollEnabled = false
            textView.backgroundColor = UIColor.clear
            textView.layer.borderColor = #colorLiteral(red: 1, green: 0.2301670313, blue: 0.1861662865, alpha: 0.2510702055)
            textView.layer.cornerRadius = 6
            textView.text = " "
            return textView
        }()
        
        let deleteButton : TextViewDeleteButton = {
            let button = TextViewDeleteButton()
            button.textview = newTextView
            button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            button.addTarget(self, action: #selector(removeText(button:)), for: .touchUpInside)
            button.tintColor = UIColor.systemRed
            button.backgroundColor = UIColor.white
            button.layer.cornerRadius = 20
            button.isHidden = true
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        newTextView.deleteButton = deleteButton
   
        canvasView.addSubview(newTextView)
        newTextView.center = CGPoint(x: canvasView.frame.width/2, y: canvasView.frame.height/2)
        previousCenterLocation = newTextView.center
        newTextView.becomeFirstResponder()
        canvasView.addSubview(deleteButton)
        deleteButton.leadingAnchor.constraint(equalTo: newTextView.trailingAnchor, constant: -10).isActive = true
        deleteButton.topAnchor.constraint(equalTo: newTextView.topAnchor, constant: -10).isActive = true
        
    }
    
    @IBAction func toggleDeleteMode() {
        isDeleteModeOn.toggle()
        
        if isDeleteModeOn {
            trashButton.tintColor = UIColor.systemRed
            trashButton.layer.borderWidth = 1
            trashButton.layer.borderColor = UIColor.systemRed.cgColor
            dismissKeyboard()
        } else {
            trashButton.tintColor = UIColor.white
            trashButton.layer.borderWidth = 0
        }
        
        for view in canvasView.subviews as [UIView] {
            if let deleteButton = view as? TextViewDeleteButton {
                deleteButton.isHidden = !isDeleteModeOn
                if isDeleteModeOn {
                    deleteButton.textview?.layer.borderWidth = 2
                } else {
                    deleteButton.textview?.layer.borderWidth = 0
                }
            }
        }
   }
    
    @IBAction func toggleCropMode() {

        isCropModeOn.toggle()
        
        UIView.animate(withDuration: 0.1, animations: {
           
            if self.isCropModeOn {
                self.canvasView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            } else {
                self.canvasView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
            
        })
        
        
        if !isCropModeOn {
            crop()
            cropView.userInteractive(bool: false)
            cropButton.layer.borderWidth = 0
        } else {
            imageView.image = orginalImage
            cropView.userInteractive(bool: true)
            cropButton.layer.borderWidth = 1
            cropButton.layer.borderColor = UIColor.white.cgColor
            if isDeleteModeOn {
                toggleDeleteMode()
            }
            
        }

        
        addTextButton.isEnabled = !isCropModeOn
        trashButton.isEnabled = !isCropModeOn
        cropView.isHidden = !isCropModeOn
        shareButton.isEnabled = !isCropModeOn
        libraryButton.isEnabled = !isCropModeOn
        cameraButton.isEnabled = !isCropModeOn && UIImagePickerController.isSourceTypeAvailable(.camera)
        
        for view in canvasView.subviews as [UIView] {
            if let textview = view as? TextMemeView {
                textview.isHidden = isCropModeOn
            }
        }
        
        
        
        
    }

    
    // MARK: functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            orginalImage = image
            imageView.image = image
            shareButton.isEnabled = true
            cropButton.isEnabled = true
            setUpCropView()
        }
        
    }
    
    func save() {
        var textViews = [TextMemeView]()
        for view in canvasView.subviews as [UIView] {
            if let textview = view as? TextMemeView {
                textViews.append(textview)
            }
        }
        
        let meme = Meme(textViews: textViews,
                        orginalImage: orginalImage!,
                        croppedImageFrame: croppedImageFrame ?? cropView.getImageFrame(imageViewSize: imageView.frame.size,
                        imageSize: imageView.image!.size),
                        memedImage: generateMemeImage()
                    )
    }
    
    
    func generateMemeImage() -> UIImage {
        
        UIGraphicsBeginImageContext(self.canvasView.frame.size)
        let frame = CGRect(x: 0, y: 0, width: canvasView.frame.width, height: canvasView.frame.height)
        canvasView.drawHierarchy(in: frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    @objc func removeText(button: TextViewDeleteButton){
        button.textview?.removeFromSuperview()
        button.removeFromSuperview()
    }
    
    func crop() {
        
        let xFactor = orginalImage!.size.width / cropView.frame.width
        let yFactor = orginalImage!.size.height / cropView.frame.height
        let width = cropView.cropAreaView.frame.width * xFactor
        let x = cropView.cropAreaView.frame.minX * xFactor
        let height = cropView.cropAreaView.frame.height * yFactor
        let y = cropView.cropAreaView.frame.minY * yFactor
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let croppedCGImage = imageView.image?.cgImage?.cropping(to: frame)
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        
        
        imageView.image = croppedImage
        croppedImageFrame = frame
    }
    
    func setUpCropView() {
        
        cropView = CropView()
        
        cropView.frame = cropView.getImageFrame(imageViewSize: imageView.frame.size, imageSize: imageView.image!.size)
        
        imageView.addSubview(cropView)
        cropView.setUpCropView()
        cropView.setUpLayout()
        
        cropView.isHidden = true
    }
    
    
    // keyboard function
    
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification){
        let safeArea = view.frame.height - getKeyboardHeight(notification) - fontView.frame.height
        let textMaxY = activeTextView!.frame.maxY + (activeTextView!.superview?.frame.minY)!
        if ( textMaxY > safeArea ) {
            canvasView.frame.origin.y -= ( textMaxY - safeArea )
        } else {
            canvasView.frame.origin.y = orginalCanvasOriginY!
        }
        
        fontView.bottomLayout?.constant = -getKeyboardHeight(notification)
        fontView.isHidden = false
        checkFont()
    }
    
    @objc func keyboardWillHide(_ notification: Notification){
        canvasView.frame.origin.y = orginalCanvasOriginY!
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        keyboardHeight = keyboardSize.cgRectValue.height
        return keyboardSize.cgRectValue.height
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        activeTextView = nil
        fontView.isHidden = true
    }
    
    
    @objc func handleTextPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if let activeTextView = activeTextView {
            if activeTextView.isFirstResponder {
                return
            }
        }
        
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            var translation = gestureRecognizer.translation(in: self.canvasView)
            
            let xLimit = canvasView.frame.width - 15
            let yLimit = canvasView.frame.height - 10
            let minX = gestureRecognizer.view!.frame.minX - 15
            let minY = gestureRecognizer.view!.frame.minY - 10
            
            if ( minX < 0 &&  translation.x < 0 ) || ( gestureRecognizer.view!.frame.maxX > xLimit &&  translation.x > 0 ) {
                translation.x = 0
            }
            
            if  ( minY < 0 &&  translation.y < 0 ) || ( gestureRecognizer.view!.frame.maxY > yLimit &&  translation.y > 0 ) {
                translation.y = 0
            }
            
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.canvasView)
            previousCenterLocation = gestureRecognizer.view!.center
            
        }

    }
    
    @objc func handleTextTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let textview = gestureRecognizer.view as! UITextView
        activeTextView = textview
        textview.isEditable = true
        textview.becomeFirstResponder()
        if isDeleteModeOn { toggleDeleteMode() }
    }
    
    
    func gestureRecognizer(_: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isCropModeOn {
            if let touch = touches.first {
                let position = touch.location(in: canvasView)
                if cropView.topRightCorenr.frame.contains(position){
                    cropView.topBorderHeightInTopRightCorner!.constant = 6
                    cropView.rightBorderWidthInTopRightCorner!.constant = 6
                } else if cropView.topLeftCorenr.frame.contains(position) {
                    cropView.topBorderHeightInTopLeftCorner!.constant = 6
                    cropView.leftBorderWidthInTopLeftCorner!.constant = 6
                } else if cropView.bottomRightCorenr.frame.contains(position) {
                    cropView.bottomBorderHeightInBottomRightCorner!.constant = 6
                    cropView.rightBorderWidthInBottomRightCorner!.constant = 6
                } else if cropView.bottomLeftCorenr.frame.contains(position) {
                    cropView.bottomBorderHeightInBottomLeftCorner!.constant = 6
                    cropView.leftBorderWidthInBottomLeftCorner!.constant = 6
                } else if cropView.top.frame.contains(position) {
                    cropView.topBorderHeight!.constant = 5
                } else if cropView.bottom.frame.contains(position) {
                    cropView.bottomBorderHeight!.constant = 5
                } else if cropView.right.frame.contains(position) {
                    cropView.rightBorderWidth!.constant = 5
                } else if cropView.left.frame.contains(position) {
                    cropView.leftBorderWidth!.constant = 5
                }
            }
        }
    }
    
    class TextViewDeleteButton: UIButton {
        var textview: UITextView?
    }
    
    class TextMemeView: UITextView {
        var deleteButton: UIButton?
    }
    
    
    // Font View
    
    class FontView: UIStackView {
        
        var bottomLayout: NSLayoutConstraint?
        
        let fontOne: UIButton = {
            var button = UIButton()
            button.addTarget(self, action: #selector(fontOneChosen), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let fontTwo: UIButton = {
            var button = UIButton()
            button.addTarget(self, action: #selector(fontTowChosen), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let fontThree: UIButton = {
            var button = UIButton()
            button.addTarget(self, action: #selector(fontThreeChosen), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        let fontFour: UIButton = {
            var button = UIButton()
            button.addTarget(self, action: #selector(fontFourChosen), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        func setUp() {
            self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2536654538)
            self.axis = .horizontal
            self.spacing = 15
            self.distribution = .fillEqually
            self.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
            self.isLayoutMarginsRelativeArrangement = true
            
            setUpButtonStyle(button: fontOne, title: "F", font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 25)!)
            
            setUpButtonStyle(button: fontTwo, title: "F", font: UIFont(name: "Didot-Bold", size: 24)!)
            setUpButtonStyle(button: fontThree, title: "F", font: UIFont(name: "Noteworthy-Bold", size: 25)!)
            setUpButtonStyle(button: fontFour, title: "F", font: UIFont(name: "SnellRoundhand-Black", size: 21)!)
            
            self.addArrangedSubview(fontOne)
            self.addArrangedSubview(fontTwo)
            self.addArrangedSubview(fontThree)
            self.addArrangedSubview(fontFour)
        }
        
        func setUpLayout() {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor).isActive = true
            self.heightAnchor.constraint(equalToConstant: 55).isActive = true
            
            bottomLayout = self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: 0)
            bottomLayout?.isActive = true
            
        }
        
        func setUpButtonStyle(button: UIButton, title: String, font: UIFont){
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3527932363)
            button.titleLabel?.font = font
            button.titleLabel?.textAlignment = .center
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = 19.5
            let widthContraints =  NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 39)
            NSLayoutConstraint.activate([widthContraints])
        }
    }
    
    @objc func fontOneChosen() {
        activeTextView!.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
        activeTextView!.typingAttributes[NSAttributedString.Key.strokeWidth] = -5
        let text = activeTextView!.text ?? ""
        activeTextView!.text = nil
        activeTextView!.text = text
        setChosenFontButtonStyle(button: fontView.fontOne)
    }
    
    @objc func fontTowChosen() {
        activeTextView!.font = UIFont(name: "Didot-Bold", size: 40)
        activeTextView!.typingAttributes[NSAttributedString.Key.strokeWidth] = -1
        let text = activeTextView!.text ?? ""
        activeTextView!.text = nil
        activeTextView!.text = text
        setChosenFontButtonStyle(button: fontView.fontTwo)
    }
    
    @objc func fontThreeChosen() {
        activeTextView!.font = UIFont(name: "Noteworthy-Bold", size: 40)
        activeTextView!.typingAttributes[NSAttributedString.Key.strokeWidth] = -2
        let text = activeTextView!.text ?? ""
        activeTextView!.text = nil
        activeTextView!.text = text
        setChosenFontButtonStyle(button: fontView.fontThree)
    }
    
    @objc func fontFourChosen() {
        activeTextView!.font = UIFont(name: "SnellRoundhand-Black", size: 40)
        activeTextView!.typingAttributes[NSAttributedString.Key.strokeWidth] = -1
        let text = activeTextView!.text ?? ""
        activeTextView!.text = nil
        activeTextView!.text = text
        setChosenFontButtonStyle(button: fontView.fontFour)
    }
    
    func checkFont() {
        switch activeTextView!.font?.fontName {
        case "HelveticaNeue-CondensedBlack":
            setChosenFontButtonStyle(button: fontView.fontOne)
        case "Didot-Bold":
            setChosenFontButtonStyle(button: fontView.fontTwo)
        case "Noteworthy-Bold":
            setChosenFontButtonStyle(button: fontView.fontThree)
        case "SnellRoundhand-Black":
            setChosenFontButtonStyle(button: fontView.fontFour)
        default:
            return
        }
    
    }
    
    func setChosenFontButtonStyle(button: UIButton){
        resetFontButtonStyle(button: fontView.fontOne)
        resetFontButtonStyle(button: fontView.fontTwo)
        resetFontButtonStyle(button: fontView.fontThree)
        resetFontButtonStyle(button: fontView.fontFour)
        
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .black
    }
    
    func resetFontButtonStyle(button: UIButton) {
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3527932363)
    }
}

