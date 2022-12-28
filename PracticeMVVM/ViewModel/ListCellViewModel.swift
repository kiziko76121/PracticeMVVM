//
//  ListCellViewModel.swift
//  PracticeMVVM
//
//  Created by MOJO on 2022/12/27.
//  Copyright © 2022 Thinkpower. All rights reserved.
//

import Foundation
import UIKit


class ListCellViewModel {
    var title: String
    var description: String
    var imageUrlString: String
    
    // operations
    private let downloadImageQueue = OperationQueue()
    
    var onImageDownloaded: ((UIImage?) -> Void)?
    
    init(title: String, description: String, imageUrl: String) {
        self.title = title
        self.description = description
        self.imageUrlString = imageUrl
    }
    
    func getImage() {
        
        guard let url = URL(string: imageUrlString) else { return }
        downloadImageQueue.addOperation { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                guard let imageDownloaded = self?.onImageDownloaded else { return }
                imageDownloaded(image)
                
            } catch let error {
                printLog(logs: [error.localizedDescription], title: "Get Image Error-")
            }
        }
    }
}
