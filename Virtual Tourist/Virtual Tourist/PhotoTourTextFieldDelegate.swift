//
//  PhotoTourTextFieldDelegate.swift
//  VirtualTourist
//
//  Created by Sharath Srinivasan In on 2017/02/04.
//  Copyright © 2017 Sharath Srinivasan In. All rights reserved.
//
import Foundation
import UIKit

class PhotoTourTextFieldDelegate: NSObject, UITextFieldDelegate {
    private let MaxChars: Int = 50
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //textField.text is an unwrapped optional.
        if let text = textField.text {
            
            let newText = (text as NSString).replacingCharacters(in: range, with: string)
            
            //if the text is too long, don't add.  Otherwise, return true to add the text
            if newText.characters.count > MaxChars {
                return false
            }
            else {
                return true
            }
        }
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text {
            if text == "Untitled" {
                textField.text = ""
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
