//
//  DataLoader.swift
//  SwiftUIReference
//
//  Created by David S Reich on 10/12/19.
//  Copyright © 2019 Stellar Software Pty Ltd. All rights reserved.
//

import Combine
import UIKit

class DataLoader: ObservableObject {
    var dataPublisher = PassthroughSubject<Data, Never>()
    static var dataCache = [String: Data]()

    var data = Data() {
        didSet {
            dataPublisher.send(data)
        }
     }

    init(urlString: String) {

        if let data = DataLoader.dataCache[urlString] {
            DispatchQueue.main.async {
                self.data = data
            }

            return
        }

        //using a guard let ... or a if let ... would make this very confusing
        let downloadTask = URLSession.urlSessionDataTask(urlString: urlString) { data, error in
            guard error == nil else {
                print("\(error!)")
                return
            }
            guard let data = data else {
                print("No data!")
                return
            }

            DispatchQueue.main.async {
                DataLoader.dataCache[urlString] = data
                self.data = data
            }
        }

        guard let task = downloadTask else {
            return
        }

        task.resume()
    }
}
