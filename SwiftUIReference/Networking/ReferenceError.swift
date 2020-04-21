//
//  ReferenceError.swift
//  SwiftUIReference
//
//  Created by David S Reich on 6/1/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

public enum ReferenceError: Error {
    //Session/network errors
    case dataTask(error: Error)
    case noResponse
    case notHttpURLResponse
    case responseNot200(responseCode: Int)
    case apiNotHappy(message: String)
    case wrongMimeType(targeMimeType: String, receivedMimeType: String)
    case noData

    //"api", data and JSON errors
    case badURL
    indirect case noFetchJSON(referenceError: ReferenceError)   //recursive!!!
    case decodeJSON(reason: String)

    /*
        Most of these should be more user friendly and less technical.
        This is a job for the UX/CX people.
    */

    public var errorDescription: String? {
        switch self {
        case .dataTask(let error):
            return "Error getting data: \(error)"
        case .noResponse:
            return "Query failed to return a response code"
        case .notHttpURLResponse:
            return "Query response was not a Http URL response"
        case .responseNot200(let responseCode):
            return "Query failed with response code: \(responseCode)"
        case .apiNotHappy(let message):
            return message
        case .wrongMimeType(let targeMimeType, let receivedMimeType):
            return "Response was not \(targeMimeType).  Was: \(receivedMimeType)"
        case .noData:
            return "Query did not return any data"

        case .badURL:
            //this also isn't helpful to the user unless they were able to enter inappropriate characters
            return "Unable to construct a valid URL"
        case .noFetchJSON(let referenceError):
            if let errorDescription = referenceError.errorDescription {
                return "Couldn't fetch JSON: \(errorDescription)"
            } else {
                return "Couldn't fetch JSON"
            }
        case .decodeJSON(let reason):
            return "Couldn't decode JSON: \(reason)"
        }
    }

    public var errorName: String {
        switch self {
        case .dataTask:
            return "dataTask"
        case .noResponse:
            return "noResponse"
        case .notHttpURLResponse:
            return "notHttpURLResponse"
        case .responseNot200:
            return "responseNot200"
        case .apiNotHappy:
            return "apiNotHappy"
        case .wrongMimeType:
            return "wrongMimeType"
        case .noData:
            return "noData"
        case .badURL:
            return "badURL"
        case .noFetchJSON:
            return "noFetchJSON"
        case .decodeJSON:
            return "decodeJSON"
        }
    }
}
