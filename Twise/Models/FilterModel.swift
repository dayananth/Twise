//
//  FilterModel.swift
//  Twise
//
//  Created by Ramasamy Dayanand on 5/26/18.
//  Copyright © 2018 Daya Inc. All rights reserved.
//

import SwiftyJSON

struct FilterModel {

    let text: String

    let imageURL: String

    init(json: JSON) {
        self.text = json["text"].string ?? ""
        self.imageURL = json["entities"]["media"]["media_url_https"].string ?? ""
    }
}
