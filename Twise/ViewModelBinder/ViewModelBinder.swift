//
//  ViewModelBinder.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/28/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

import UIKit

class ViewModelBinder<T> {

    var bind :(T) -> () = { _ in }

    var value :T? {
        didSet {
            bind(value!)
        }
    }

    init(_ v :T) {
        value = v
    }
}
