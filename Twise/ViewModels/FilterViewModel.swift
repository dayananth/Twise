//
//  FilterViewModel.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/26/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

import UIKit

class FilterViewModel {

    let text: String

    let imageURL: String

    init(filterModel: FilterModel) {
        self.text = filterModel.text
        self.imageURL = filterModel.imageURL
    }

}
