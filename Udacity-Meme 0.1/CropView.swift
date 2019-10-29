//
//  CropView.swift
//  Udacity-Meme 0.1
//
//  Created by Saeed Khader on 05/10/2019.
//  Copyright © 2019 Saeed Khader. All rights reserved.
//

import Foundation
import UIKit

class CropView: UIView, UIGestureRecognizerDelegate {

    
    var cropAreaView = UIView()
    var topBorder = UIView()
    var bottomBorder = UIView()
    var rightBorder = UIView()
    var leftBorder = UIView()
    
    let topBorderInTopRightCorner = UIView()
    let rightBorderInTopRightCorner = UIView()
    
    let topBorderInTopLeftCorner = UIView()
    let leftBorderInTopLeftCorner = UIView()
    
    let bottomBorderInBottomRightCorner = UIView()
    let rightBorderInBottomRightCorner = UIView()
    
    let bottomBorderInBottomLeftCorner = UIView()
    let leftBorderInBottomLeftCorner = UIView()
    
    let top = UIView()
    let bottom = UIView()
    let right = UIView()
    let left = UIView()
    
    let topRightCorenr = UIView()
    let topLeftCorenr = UIView()
    let bottomRightCorenr = UIView()
    let bottomLeftCorenr = UIView()
    
    var topBorderHeight: NSLayoutConstraint?
    var bottomBorderHeight: NSLayoutConstraint?
    var leftBorderWidth: NSLayoutConstraint?
    var rightBorderWidth: NSLayoutConstraint?
    
    var topBorderHeightInTopRightCorner: NSLayoutConstraint?
    var rightBorderWidthInTopRightCorner: NSLayoutConstraint?
    
    var topBorderHeightInTopLeftCorner: NSLayoutConstraint?
    var leftBorderWidthInTopLeftCorner: NSLayoutConstraint?
    
    var bottomBorderHeightInBottomRightCorner: NSLayoutConstraint?
    var rightBorderWidthInBottomRightCorner: NSLayoutConstraint?
    
    var bottomBorderHeightInBottomLeftCorner: NSLayoutConstraint?
    var leftBorderWidthInBottomLeftCorner: NSLayoutConstraint?
    
    
    let topBackgroud = UIView()
    let bottomBackgroud = UIView()
    let rightBackground = UIView()
    let leftBackgroud = UIView()
    
    func getImageFrame(imageViewSize: CGSize, imageSize: CGSize)->CGRect{
        
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        
        if imageRatio < imageViewRatio {
            
            let scaleFactior = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactior
            let x = ( imageViewSize.width - width ) * 0.5
            return CGRect(x: x, y: 0, width: width, height: imageViewSize.height)
            
        } else {
            
            let scaleFactior = imageViewSize.width / imageSize.width
            let height = imageSize.height * scaleFactior
            let y = ( imageViewSize.height - height ) * 0.5
            return CGRect(x: 0, y: y, width: imageViewSize.width, height: height)
            
        }
    }
    
    
    func userInteractive(bool: Bool) {
        top.isUserInteractionEnabled = bool
        bottom.isUserInteractionEnabled = bool
        left.isUserInteractionEnabled = bool
        right.isUserInteractionEnabled = bool
        topRightCorenr.isUserInteractionEnabled = bool
        topLeftCorenr.isUserInteractionEnabled = bool
        bottomRightCorenr.isUserInteractionEnabled = bool
        bottomLeftCorenr.isUserInteractionEnabled = bool
    }
    
    
    func setUpCropView() {
        
        
        cropAreaView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        topBackgroud.backgroundColor = #colorLiteral(red: 0.0976927951, green: 0.09711972624, blue: 0.09813826531, alpha: 0.7466556079)
        bottomBackgroud.backgroundColor = #colorLiteral(red: 0.0976927951, green: 0.09711972624, blue: 0.09813826531, alpha: 0.7466556079)
        rightBackground.backgroundColor = #colorLiteral(red: 0.0976927951, green: 0.09711972624, blue: 0.09813826531, alpha: 0.7466556079)
        leftBackgroud.backgroundColor = #colorLiteral(red: 0.0976927951, green: 0.09711972624, blue: 0.09813826531, alpha: 0.7466556079)
        
        topBorder.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        bottomBorder.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        leftBorder.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        rightBorder.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        topBorderInTopRightCorner.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        rightBorderInTopRightCorner.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        topBorderInTopLeftCorner.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        leftBorderInTopLeftCorner.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        bottomBorderInBottomRightCorner.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        rightBorderInBottomRightCorner.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        bottomBorderInBottomLeftCorner.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        leftBorderInBottomLeftCorner.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
//        top.backgroundColor = .systemRed
//        left.backgroundColor = .systemBlue
//        right.backgroundColor = .systemGray
//        bottom.backgroundColor = .systemPink
//        topRightCorenr.backgroundColor = .systemIndigo
//        topLeftCorenr.backgroundColor = .systemIndigo
//        bottomRightCorenr.backgroundColor = .systemIndigo
//        bottomLeftCorenr.backgroundColor = .systemIndigo
                
        let topBorderPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleTopBorderPan))
        topBorderPanGestureRecognizer.delegate = self
        top.addGestureRecognizer(topBorderPanGestureRecognizer)
        
        let bottomBorderPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleBottomBorderPan))
        bottomBorderPanGestureRecognizer.delegate = self
        bottom.addGestureRecognizer(bottomBorderPanGestureRecognizer)
        
        let leftBorderPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleLeftBorderPan))
        leftBorderPanGestureRecognizer.delegate = self
        left.addGestureRecognizer(leftBorderPanGestureRecognizer)
        
        let rightBorderPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleRightBorderPan))
        rightBorderPanGestureRecognizer.delegate = self
        right.addGestureRecognizer(rightBorderPanGestureRecognizer)
        
        let topRightCornerPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleTopRightCornerPan))
        topRightCornerPanGestureRecognizer.delegate = self
        topRightCorenr.addGestureRecognizer(topRightCornerPanGestureRecognizer)
        
        let topLeftCornerPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleTopLeftCornerPan))
        topLeftCornerPanGestureRecognizer.delegate = self
        topLeftCorenr.addGestureRecognizer(topLeftCornerPanGestureRecognizer)
        
        let bottomRightCornerPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleBottomRightCornerPan))
        bottomRightCornerPanGestureRecognizer.delegate = self
        bottomRightCorenr.addGestureRecognizer(bottomRightCornerPanGestureRecognizer)
        
        let bottomLeftCornerPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleBottomLeftCornerPan))
        bottomLeftCornerPanGestureRecognizer.delegate = self
        bottomLeftCorenr.addGestureRecognizer(bottomLeftCornerPanGestureRecognizer)
        
        self.addSubview(cropAreaView)
        
        cropAreaView.addSubview(topBorder)
        cropAreaView.addSubview(bottomBorder)
        cropAreaView.addSubview(leftBorder)
        cropAreaView.addSubview(rightBorder)
        
        cropAreaView.addSubview(topBorderInTopRightCorner)
        cropAreaView.addSubview(rightBorderInTopRightCorner)
        
        cropAreaView.addSubview(topBorderInTopLeftCorner)
        cropAreaView.addSubview(leftBorderInTopLeftCorner)
        
        cropAreaView.addSubview(bottomBorderInBottomRightCorner)
        cropAreaView.addSubview(rightBorderInBottomRightCorner)
        
        cropAreaView.addSubview(bottomBorderInBottomLeftCorner)
        cropAreaView.addSubview(leftBorderInBottomLeftCorner)
        
        self.superview!.superview!.addSubview(top)
        self.superview!.superview!.addSubview(bottom)
        self.superview!.superview!.addSubview(right)
        self.superview!.superview!.addSubview(left)
        
        self.superview!.superview!.addSubview(topRightCorenr)
        self.superview!.superview!.addSubview(topLeftCorenr)
        self.superview!.superview!.addSubview(bottomRightCorenr)
        self.superview!.superview!.addSubview(bottomLeftCorenr)
        
        self.addSubview(topBackgroud)
        self.addSubview(leftBackgroud)
        self.addSubview(rightBackground)
        self.addSubview(bottomBackgroud)
    }
    
    
    func setUpLayout() {
        
        topBorder.translatesAutoresizingMaskIntoConstraints = false
        topBorder.topAnchor.constraint(equalTo: cropAreaView.topAnchor, constant: 0).isActive = true
        topBorder.leadingAnchor.constraint(equalTo: cropAreaView.leadingAnchor, constant: 0).isActive = true
        topBorder.trailingAnchor.constraint(equalTo: cropAreaView.trailingAnchor, constant: 0).isActive = true
        topBorderHeight = topBorder.heightAnchor.constraint(equalToConstant: 2)
        topBorderHeight!.isActive = true
        
        top.translatesAutoresizingMaskIntoConstraints = false
        top.topAnchor.constraint(equalTo: cropAreaView.topAnchor, constant: -15).isActive = true
        top.leadingAnchor.constraint(equalTo: cropAreaView.leadingAnchor, constant: 0).isActive = true
        top.trailingAnchor.constraint(equalTo: cropAreaView.trailingAnchor, constant: 0).isActive = true
        top.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder.bottomAnchor.constraint(equalTo: cropAreaView.bottomAnchor, constant: 0).isActive = true
        bottomBorder.leadingAnchor.constraint(equalTo: cropAreaView.leadingAnchor, constant: 0).isActive = true
        bottomBorder.trailingAnchor.constraint(equalTo: cropAreaView.trailingAnchor, constant: 0).isActive = true
        bottomBorderHeight = bottomBorder.heightAnchor.constraint(equalToConstant: 2)
        bottomBorderHeight!.isActive = true
        
        bottom.translatesAutoresizingMaskIntoConstraints = false
        bottom.bottomAnchor.constraint(equalTo: cropAreaView.bottomAnchor, constant: 15).isActive = true
        bottom.leadingAnchor.constraint(equalTo: cropAreaView.leadingAnchor, constant: 0).isActive = true
        bottom.trailingAnchor.constraint(equalTo: cropAreaView.trailingAnchor, constant: 0).isActive = true
        bottom.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        leftBorder.translatesAutoresizingMaskIntoConstraints = false
        leftBorder.bottomAnchor.constraint(equalTo: cropAreaView.bottomAnchor, constant: 0).isActive = true
        leftBorder.topAnchor.constraint(equalTo: cropAreaView.topAnchor, constant: 0).isActive = true
        leftBorder.leadingAnchor.constraint(equalTo: cropAreaView.leadingAnchor, constant: 0).isActive = true
        leftBorderWidth = leftBorder.widthAnchor.constraint(equalToConstant: 2)
        leftBorderWidth!.isActive = true
        
        left.translatesAutoresizingMaskIntoConstraints = false
        left.bottomAnchor.constraint(equalTo: cropAreaView.bottomAnchor, constant: 0).isActive = true
        left.topAnchor.constraint(equalTo: cropAreaView.topAnchor, constant: 0).isActive = true
        left.leadingAnchor.constraint(equalTo: cropAreaView.leadingAnchor, constant: -15).isActive = true
        left.widthAnchor.constraint(equalToConstant: 40).isActive = true

        
        rightBorder.translatesAutoresizingMaskIntoConstraints = false
        rightBorder.bottomAnchor.constraint(equalTo: cropAreaView.bottomAnchor, constant: 0).isActive = true
        rightBorder.topAnchor.constraint(equalTo: cropAreaView.topAnchor, constant: 0).isActive = true
        rightBorder.trailingAnchor.constraint(equalTo: cropAreaView.trailingAnchor, constant: 0).isActive = true
        rightBorderWidth = rightBorder.widthAnchor.constraint(equalToConstant: 2)
        rightBorderWidth!.isActive = true
        
        right.translatesAutoresizingMaskIntoConstraints = false
        right.bottomAnchor.constraint(equalTo: cropAreaView.bottomAnchor, constant: 0).isActive = true
        right.topAnchor.constraint(equalTo: cropAreaView.topAnchor, constant: 0).isActive = true
        right.trailingAnchor.constraint(equalTo: cropAreaView.trailingAnchor, constant: 15).isActive = true
        right.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        topBorderInTopRightCorner.translatesAutoresizingMaskIntoConstraints = false
        topBorderInTopRightCorner.topAnchor.constraint(equalTo: cropAreaView.topAnchor, constant: 0).isActive = true
        topBorderInTopRightCorner.trailingAnchor.constraint(equalTo: cropAreaView.trailingAnchor, constant: 0).isActive = true
        topBorderInTopRightCorner.widthAnchor.constraint(equalToConstant: 30).isActive = true
        topBorderHeightInTopRightCorner = topBorderInTopRightCorner.heightAnchor.constraint(equalToConstant: 4)
        topBorderHeightInTopRightCorner!.isActive = true
        
        rightBorderInTopRightCorner.translatesAutoresizingMaskIntoConstraints = false
        rightBorderInTopRightCorner.topAnchor.constraint(equalTo: cropAreaView.topAnchor, constant: 0).isActive = true
        rightBorderInTopRightCorner.trailingAnchor.constraint(equalTo: cropAreaView.trailingAnchor, constant: 0).isActive = true
        rightBorderInTopRightCorner.heightAnchor.constraint(equalToConstant: 30).isActive = true
        rightBorderWidthInTopRightCorner = rightBorderInTopRightCorner.widthAnchor.constraint(equalToConstant: 4)
        rightBorderWidthInTopRightCorner!.isActive = true
        
        topRightCorenr.translatesAutoresizingMaskIntoConstraints = false
        topRightCorenr.topAnchor.constraint(equalTo: cropAreaView.topAnchor, constant: -15).isActive = true
        topRightCorenr.trailingAnchor.constraint(equalTo: cropAreaView.trailingAnchor, constant: 15).isActive = true
        topRightCorenr.widthAnchor.constraint(equalToConstant: 40).isActive = true
        topRightCorenr.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        topBorderInTopLeftCorner.translatesAutoresizingMaskIntoConstraints = false
        topBorderInTopLeftCorner.topAnchor.constraint(equalTo: cropAreaView.topAnchor, constant: 0).isActive = true
        topBorderInTopLeftCorner.leadingAnchor.constraint(equalTo: cropAreaView.leadingAnchor, constant: 0).isActive = true
        topBorderInTopLeftCorner.widthAnchor.constraint(equalToConstant: 30).isActive = true
        topBorderHeightInTopLeftCorner = topBorderInTopLeftCorner.heightAnchor.constraint(equalToConstant: 4)
        topBorderHeightInTopLeftCorner!.isActive = true
        
        leftBorderInTopLeftCorner.translatesAutoresizingMaskIntoConstraints = false
        leftBorderInTopLeftCorner.topAnchor.constraint(equalTo: cropAreaView.topAnchor, constant: 0).isActive = true
        leftBorderInTopLeftCorner.leadingAnchor.constraint(equalTo: cropAreaView.leadingAnchor, constant: 0).isActive = true
        leftBorderInTopLeftCorner.heightAnchor.constraint(equalToConstant: 30).isActive = true
        leftBorderWidthInTopLeftCorner = leftBorderInTopLeftCorner.widthAnchor.constraint(equalToConstant: 4)
        leftBorderWidthInTopLeftCorner!.isActive = true
        
        topLeftCorenr.translatesAutoresizingMaskIntoConstraints = false
        topLeftCorenr.topAnchor.constraint(equalTo: cropAreaView.topAnchor, constant: -15).isActive = true
        topLeftCorenr.leadingAnchor.constraint(equalTo: cropAreaView.leadingAnchor, constant: -15).isActive = true
        topLeftCorenr.widthAnchor.constraint(equalToConstant: 40).isActive = true
        topLeftCorenr.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bottomBorderInBottomRightCorner.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderInBottomRightCorner.bottomAnchor.constraint(equalTo: cropAreaView.bottomAnchor, constant: 0).isActive = true
        bottomBorderInBottomRightCorner.trailingAnchor.constraint(equalTo: cropAreaView.trailingAnchor, constant: 0).isActive = true
        bottomBorderInBottomRightCorner.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bottomBorderHeightInBottomRightCorner = bottomBorderInBottomRightCorner.heightAnchor.constraint(equalToConstant: 4)
        bottomBorderHeightInBottomRightCorner!.isActive = true
        
        rightBorderInBottomRightCorner.translatesAutoresizingMaskIntoConstraints = false
        rightBorderInBottomRightCorner.bottomAnchor.constraint(equalTo: cropAreaView.bottomAnchor, constant: 0).isActive = true
        rightBorderInBottomRightCorner.trailingAnchor.constraint(equalTo: cropAreaView.trailingAnchor, constant: 0).isActive = true
        rightBorderInBottomRightCorner.heightAnchor.constraint(equalToConstant: 30).isActive = true
        rightBorderWidthInBottomRightCorner = rightBorderInBottomRightCorner.widthAnchor.constraint(equalToConstant: 4)
        rightBorderWidthInBottomRightCorner!.isActive = true
        
        bottomRightCorenr.translatesAutoresizingMaskIntoConstraints = false
        bottomRightCorenr.bottomAnchor.constraint(equalTo: cropAreaView.bottomAnchor, constant: 15).isActive = true
        bottomRightCorenr.trailingAnchor.constraint(equalTo: cropAreaView.trailingAnchor, constant: 15).isActive = true
        bottomRightCorenr.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bottomRightCorenr.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bottomBorderInBottomLeftCorner.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderInBottomLeftCorner.bottomAnchor.constraint(equalTo: cropAreaView.bottomAnchor, constant: 0).isActive = true
        bottomBorderInBottomLeftCorner.leadingAnchor.constraint(equalTo: cropAreaView.leadingAnchor, constant: 0).isActive = true
        bottomBorderInBottomLeftCorner.widthAnchor.constraint(equalToConstant: 30).isActive = true
        bottomBorderHeightInBottomLeftCorner = bottomBorderInBottomLeftCorner.heightAnchor.constraint(equalToConstant: 4)
        bottomBorderHeightInBottomLeftCorner!.isActive = true

        leftBorderInBottomLeftCorner.translatesAutoresizingMaskIntoConstraints = false
        leftBorderInBottomLeftCorner.bottomAnchor.constraint(equalTo: cropAreaView.bottomAnchor, constant: 0).isActive = true
        leftBorderInBottomLeftCorner.leadingAnchor.constraint(equalTo: cropAreaView.leadingAnchor, constant: 0).isActive = true
        leftBorderInBottomLeftCorner.heightAnchor.constraint(equalToConstant: 30).isActive = true
        leftBorderWidthInBottomLeftCorner = leftBorderInBottomLeftCorner.widthAnchor.constraint(equalToConstant: 4)
        leftBorderWidthInBottomLeftCorner!.isActive = true
        
        bottomLeftCorenr.translatesAutoresizingMaskIntoConstraints = false
        bottomLeftCorenr.bottomAnchor.constraint(equalTo: cropAreaView.bottomAnchor, constant: 15).isActive = true
        bottomLeftCorenr.leadingAnchor.constraint(equalTo: cropAreaView.leadingAnchor, constant: -15).isActive = true
        bottomLeftCorenr.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bottomLeftCorenr.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        topBackgroud.translatesAutoresizingMaskIntoConstraints = false
        topBackgroud.bottomAnchor.constraint(equalTo: cropAreaView.topAnchor, constant: 0).isActive = true
        topBackgroud.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        topBackgroud.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        topBackgroud.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        
        bottomBackgroud.translatesAutoresizingMaskIntoConstraints = false
        bottomBackgroud.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        bottomBackgroud.topAnchor.constraint(equalTo: cropAreaView.bottomAnchor, constant: 0).isActive = true
        bottomBackgroud.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        bottomBackgroud.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        
        leftBackgroud.translatesAutoresizingMaskIntoConstraints = false
        leftBackgroud.bottomAnchor.constraint(equalTo: bottomBackgroud.topAnchor, constant: 0).isActive = true
        leftBackgroud.topAnchor.constraint(equalTo: topBackgroud.bottomAnchor, constant: 0).isActive = true
        leftBackgroud.trailingAnchor.constraint(equalTo: cropAreaView.leadingAnchor, constant: 0).isActive = true
        leftBackgroud.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        
        rightBackground.translatesAutoresizingMaskIntoConstraints = false
        rightBackground.bottomAnchor.constraint(equalTo: bottomBackgroud.topAnchor, constant: 0).isActive = true
        rightBackground.topAnchor.constraint(equalTo: topBackgroud.bottomAnchor, constant: 0).isActive = true
        rightBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        rightBackground.leadingAnchor.constraint(equalTo: cropAreaView.trailingAnchor, constant: 0).isActive = true
        
    }
    
    
    @objc func handleTopBorderPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self)
            
            if cropAreaView.frame.minY <= 0 &&  translation.y < 0  {
                return
            }
            
            let postHeight = cropAreaView.frame.height - translation.y
            let postY = cropAreaView.frame.minY + translation.y
            
            if postHeight >= 180 && postY >= 0 {
                cropAreaView.frame.size.height = postHeight
                cropAreaView.frame.origin.y += translation.y
            } else {
                return
            }

            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            
        } else if gestureRecognizer.state == .ended {
                
            topBorderHeight!.constant = 2
            
        }
        
    }

    
    
    @objc func handleBottomBorderPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self)
            
            if cropAreaView.frame.maxY >= self.frame.height && translation.y > 0  {
                return
            }
              
            let postHeight = cropAreaView.frame.height + translation.y
            let postMaxY = cropAreaView.frame.maxY + translation.y
            
            if postHeight >= 180 && postMaxY <= self.frame.height {
                  cropAreaView.frame.size.height = postHeight
            } else {
                return
            }
              
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            
        } else if gestureRecognizer.state == .ended {
                
            bottomBorderHeight!.constant = 2
            
        }

    }
    
    @objc func handleLeftBorderPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self)
            
            if cropAreaView.frame.minX <= 0 &&  translation.x < 0  {
                return
            }
            
            let postWidth = cropAreaView.frame.width - translation.x
            let postX = cropAreaView.frame.minX + translation.x
            
            if postWidth >= 180 && postX >= 0  {
                cropAreaView.frame.size.width = postWidth
                cropAreaView.frame.origin.x += translation.x
            } else {
                return
            }

            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            
        } else if gestureRecognizer.state == .ended {
                
            leftBorderWidth!.constant = 2
            
        }
        
    }
    
    
    @objc func handleRightBorderPan(_ gestureRecognizer: UIPanGestureRecognizer) {
           
        if gestureRecognizer.state == .changed {
               
            let translation = gestureRecognizer.translation(in: self)
           
            if cropAreaView.frame.maxX >= self.frame.width && translation.x > 0  {
                return
            }
             
            let postWidth = cropAreaView.frame.width + translation.x
            let postMaxX = cropAreaView.frame.maxX + translation.x
           
            if postWidth >= 180 && postMaxX < self.frame.width {
                cropAreaView.frame.size.width = postWidth
            } else {
                return
            }
             
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
               
        } else  if gestureRecognizer.state == .ended {
            
            rightBorderWidth!.constant = 2
            
        }

    }
    
    @objc func handleTopRightCornerPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self)
            
            if ( cropAreaView.frame.minY <= 0 &&  translation.y < 0 ) || ( cropAreaView.frame.maxX >= self.frame.width && translation.x > 0 ) {
                return
            }

            let postHeight = cropAreaView.frame.height - translation.y
            let postY = cropAreaView.frame.minY + translation.y
            let postWidth = cropAreaView.frame.width + translation.x
            let postMaxX = cropAreaView.frame.maxX + translation.x
            
            if postHeight >= 180 && postY >= 0 {
                cropAreaView.frame.size.height = postHeight
                cropAreaView.frame.origin.y += translation.y
            }
            
            if postWidth >= 180 && postMaxX < self.frame.width {
                cropAreaView.frame.size.width = postWidth
            }

            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            
        } else if gestureRecognizer.state == .ended {
                
            topBorderHeightInTopRightCorner!.constant = 4
            rightBorderWidthInTopRightCorner!.constant = 4
            
        }

    }
    
    @objc func handleTopLeftCornerPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self)
            
            if ( cropAreaView.frame.minY <= 0 &&  translation.y < 0 ) || ( cropAreaView.frame.minX <= 0 &&  translation.x < 0 )  {
                return
            }
            
            let postHeight = cropAreaView.frame.height - translation.y
            let postY = cropAreaView.frame.minY + translation.y
            let postWidth = cropAreaView.frame.width - translation.x
            let postX = cropAreaView.frame.minX + translation.x
            
            if postHeight >= 180 && postY >= 0 {
                cropAreaView.frame.size.height = postHeight
                cropAreaView.frame.origin.y += translation.y
            }
            
            if postWidth >= 180 && postX >= 0  {
               cropAreaView.frame.size.width = postWidth
               cropAreaView.frame.origin.x += translation.x
           }

            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            
        } else if gestureRecognizer.state == .ended {
                
            topBorderHeightInTopLeftCorner!.constant = 4
            leftBorderWidthInTopLeftCorner!.constant = 4
            
        }

    }
    
    @objc func handleBottomRightCornerPan(_ gestureRecognizer: UIPanGestureRecognizer) {
           
        if gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self)
            
            if ( cropAreaView.frame.maxY >= self.frame.height && translation.y > 0 ) || ( cropAreaView.frame.maxX >= self.frame.width && translation.x > 0  )  {
                return
            }
              
            let postHeight = cropAreaView.frame.height + translation.y
            let postMaxY = cropAreaView.frame.maxY + translation.y
            let postWidth = cropAreaView.frame.width + translation.x
            let postMaxX = cropAreaView.frame.maxX + translation.x
            
            if postHeight >= 180 && postMaxY <= self.frame.height {
                  cropAreaView.frame.size.height = postHeight
            }
            
            if postWidth >= 180 && postMaxX < self.frame.width {
                cropAreaView.frame.size.width = postWidth
            }
              
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            
        } else if gestureRecognizer.state == .ended {
                
            bottomBorderHeightInBottomRightCorner!.constant = 4
            rightBorderWidthInBottomRightCorner!.constant = 4
            
        }

    }
    
    @objc func handleBottomLeftCornerPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self)
            
            if ( cropAreaView.frame.maxY >= self.frame.height && translation.y > 0 ) || ( cropAreaView.frame.minX <= 0 &&  translation.x < 0 )  {
                return
            }
              
            let postHeight = cropAreaView.frame.height + translation.y
            let postMaxY = cropAreaView.frame.maxY + translation.y
            let postWidth = cropAreaView.frame.width - translation.x
            let postX = cropAreaView.frame.minX + translation.x
            
            if postHeight >= 180 && postMaxY <= self.frame.height {
                  cropAreaView.frame.size.height = postHeight
            }
            
            if postWidth >= 180 && postX >= 0  {
                cropAreaView.frame.size.width = postWidth
                cropAreaView.frame.origin.x += translation.x
            }
              
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            
        } else if gestureRecognizer.state == .ended {
                
            bottomBorderHeightInBottomLeftCorner!.constant = 4
            leftBorderWidthInBottomLeftCorner!.constant = 4
            
        }

    }
    

}
