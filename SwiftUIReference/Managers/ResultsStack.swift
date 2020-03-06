//
//  ResultsStack.swift
//  SwiftUIReference
//
//  Created by David S Reich on 4/2/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

class ResultsStack {
    private var resultsStack = [ResultBox]()

    private struct ResultBox {
        //for title
        var tagString: String
        var images: [ImageDataModelProtocolWrapper]
    }

    func pushResults(tagsString: String, images: [ImageDataModelProtocolWrapper]) {
        resultsStack.append(ResultBox(tagString: tagsString, images: images))
    }

    func popResults() -> (tagsString: String, images: [ImageDataModelProtocolWrapper])? {
        if let resultBox = resultsStack.popLast() {
            return (resultBox.tagString, resultBox.images)
        }

        return nil
    }

    func getLast() -> (tagsString: String, images: [ImageDataModelProtocolWrapper])? {
        if let resultBox = resultsStack.last {
            return (resultBox.tagString, resultBox.images)
        }

        return nil
    }

    func popToTop() -> (tagsString: String, images: [ImageDataModelProtocolWrapper])? {
        guard resultsStack.count > 0 else {
            return nil
        }
        resultsStack.removeLast(resultsStack.count - 1)

        return getLast()
    }
}
