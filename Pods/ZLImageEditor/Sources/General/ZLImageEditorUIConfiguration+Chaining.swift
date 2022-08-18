//
//  ZLImageEditorUIConfiguration+Chaining.swift
//  ZLImageEditor
//
//  Created by long on 2022/5/13.
//
//  Copyright (c) 2020 Long Zhang <495181165@qq.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

extension ZLImageEditorUIConfiguration {
    
    @discardableResult
    public func languageType(_ type: ZLImageEditorLanguageType) -> ZLImageEditorUIConfiguration {
        languageType = type
        return self
    }
    
    @discardableResult
    public func customImageNames(_ names: [String]) -> ZLImageEditorUIConfiguration {
        customImageNames = names
        return self
    }
    
    @discardableResult
    public func customImageForKey(_ map: [String: UIImage?]) -> ZLImageEditorUIConfiguration {
        customImageForKey = map
        return self
    }
    
    @discardableResult
    public func adjustSliderNormalColor(_ color: UIColor) -> ZLImageEditorUIConfiguration {
        adjustSliderNormalColor = color
        return self
    }
    
    @discardableResult
    public func adjustSliderTintColor(_ color: UIColor) -> ZLImageEditorUIConfiguration {
        adjustSliderTintColor = color
        return self
    }
    
    @discardableResult
    public func editDoneBtnBgColor(_ color: UIColor) -> ZLImageEditorUIConfiguration {
        editDoneBtnBgColor = color
        return self
    }
    
    @discardableResult
    public func editDoneBtnTitleColor(_ color: UIColor) -> ZLImageEditorUIConfiguration {
        editDoneBtnTitleColor = color
        return self
    }
    
    @discardableResult
    public func ashbinNormalBgColor(_ color: UIColor) -> ZLImageEditorUIConfiguration {
        ashbinNormalBgColor = color
        return self
    }
    
    @discardableResult
    public func ashbinTintBgColor(_ color: UIColor) -> ZLImageEditorUIConfiguration {
        ashbinTintBgColor = color
        return self
    }
    
}
