//
//  ReusableCell.swift
//  News
//
//  Created by Dzmitry Bosak on 11/26/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

protocol ReusableCellProtocol: class {
    var reuseIdentifier: String { get }
}

final class ReusableCell: NSObject, ReusableCellProtocol {
    let reuseIdentifier: String = "TableNewsCell"
}
