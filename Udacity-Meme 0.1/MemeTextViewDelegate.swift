//
//  MemeTextViewDelegate.swift
//  Udacity-Meme 0.1
//
//  Created by Saeed Khader on 30/09/2019.
//  Copyright © 2019 Saeed Khader. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeTextView = textView
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        activeTextView = textView
        
        if (textView.text == " ") {
            textView.text = ""
        }
        
        textView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2025096318)
        
        previousCenterLocation = CGPoint(x: textView.frame.midX, y: textView.frame.midY)
        
    }
    

    
    func textViewDidChangeSelection(_ textView: UITextView) {
       
        print("bluh")
        
        let maxWidth = UIScreen.main.bounds.width - 15
        let maxHeight = canvasView.bounds.height - 10
        let newSize = textView.sizeThatFits(CGSize(width: maxWidth, height: maxHeight))
        textView.frame.size = newSize
        
        let extendedOnRight = { () -> CGFloat in
            let x = maxWidth - textView.frame.maxX
            if x < 0 {
                return x
            } else {
                return 0
            }
        }
        
        let extendedOnLeft = { () -> CGFloat in
            let x = textView.frame.minX - 15
            if x < 0 {
                return -x
            } else {
                return 0
            }
        }
        
        let extendedOnTop = { () -> CGFloat in
            let y = maxHeight - textView.frame.maxY
            if y < 0 {
                return y
            } else {
                return 0
            }
        }
        
        let extendedOnBottom = { () -> CGFloat in
            let y = textView.frame.minY - 10
            if y < 0 {
                return -y
            } else {
                return 0
            }
        }
        
        if var previousCenterLocation = previousCenterLocation {
            textView.center = previousCenterLocation
            previousCenterLocation.x += extendedOnRight() + extendedOnLeft()
            previousCenterLocation.y += extendedOnTop() + extendedOnBottom()
            textView.center = previousCenterLocation
        }
        
        if let keyboardHeight = keyboardHeight {
            if (textView.superview != nil) {
                canvasView.frame.origin.y = orginalCanvasOriginY!
                let safeArea = view.frame.height - keyboardHeight - fontView.frame.height
                let textMaxY = textView.frame.maxY + (textView.superview?.frame.minY)!
                if ( textMaxY > safeArea ) {
                    canvasView.frame.origin.y -= ( textMaxY - safeArea )
                }
            }
        }
        
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
                
        textView.backgroundColor = UIColor.clear
        
        textView.isEditable = false
        
        if (textView.text == "" ) {
            let text = textView as! TextMemeView
            text.deleteButton?.removeFromSuperview()
            textView.removeFromSuperview()
            activeTextView = nil
        }
        
    }
    
}
