//
//  FilterViewModel.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/26/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

import UIKit

protocol FilterViewModelProtocol: class {

    /// Twitter post text
    var text: String {get}

    /// Profile URL
    var imageURL: String {get}
}

class FilterViewModel: FilterViewModelProtocol {

    let text: String

    let imageURL: String

    init(filterModel: FilterModel) {
        self.text = filterModel.text
        self.imageURL = filterModel.imageURL
    }

}
