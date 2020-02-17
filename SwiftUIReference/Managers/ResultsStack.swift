//
//  ResultsStack.swift
//  SwiftUIReference
//
//  Created by David S Reich on 4/2/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

class ResultsStack {
    //use a dictionary so we don't have to worry about saving the same set multiple times.
    //the dictionary key is the mainViewLevel, so we have a 1:1 mapping.
    private var resultsStack = [Int: ResultBox]()

    struct ResultBox {
        //for title
        var tagString: String
        var images: [ImageDataModelProtocolWrapper]
    }

    func saveResults(index: Int, tagsString: String, images: [ImageDataModelProtocolWrapper]) {
        let resultBox = ResultBox(tagString: tagsString, images: images)

        resultsStack[index] = resultBox
    }

    func getResults(index: Int) -> (tagsString: String, images: [ImageDataModelProtocolWrapper])? {
        if let resultBox = resultsStack[index] {
            return (resultBox.tagString, resultBox.images)
        }

        return nil
    }
}
