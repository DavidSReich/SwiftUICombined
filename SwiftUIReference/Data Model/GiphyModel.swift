//
//  GiphyModel.swift
//  SwiftUIReference
//
//  Created by David S Reich on 3/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

struct GiphyModel: Decodable {
    var meta: MetaModel
    var data: [ImageDataModel]
}
