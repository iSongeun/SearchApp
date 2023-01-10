//
//  AlertActionConvertible.swift
//  SearchApp
//
//  Created by 이송은 on 2022/12/01.
//

import UIKit

protocol AlertActionConvertible{
    var title : String {get}
    var style : UIAlertAction.Style {get}
}
