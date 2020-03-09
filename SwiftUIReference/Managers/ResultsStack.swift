//
//  ResultsStack.swift
//  SwiftUIReference
//
//  Created by David S Reich on 4/2/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

class ResultsStack<T> {
    private var resultsStack = [ResultBox]()

    private struct ResultBox {
        //for title
        var title: String
        var values: [T]
    }

    func clear() {
        resultsStack.removeAll()
    }

    var resultsCount: Int {
        resultsStack.count
    }

    func pushResults(title: String, values: [T]) {
        resultsStack.append(ResultBox(title: title, values: values))
//        print(">>>>>> \(title) :: \(resultsStack.count) :: \(values.count)")
    }

    func popResults() -> (title: String, values: [T])? {
        _ = resultsStack.popLast()

        return getLast()
    }

    func popToTop() -> (title: String, values: [T])? {
        guard resultsStack.count > 0 else {
            return nil
        }
        resultsStack.removeLast(resultsStack.count - 1)

        return getLast()
    }

    func getLast() -> (title: String, values: [T])? {
        if let resultBox = resultsStack.last {
            return (resultBox.title, resultBox.values)
        }

        return nil
    }

    func getPenultimate() -> (title: String, values: [T])? {
        let count = resultsStack.count
        if count < 2 {
            return getLast()
        }

        let resultBox = resultsStack[count - 2]

        return (resultBox.title, resultBox.values)
    }
}
