//
//  ViewControllerViewModel.swift
//  PracticeMVVM
//
//  Created by MOJO on 2022/12/27.
//  Copyright © 2022 Thinkpower. All rights reserved.
//

import Foundation

class ViewControllerViewModel {
    
    let service = RequestCommunicator<DownloadMusic>()
    var musicHandlers: [MusicHandler] = []
    var listCellViewModels: [ListCellViewModel] = []
    var onRequestEnd: (() -> Void)?
    var searchText: String = "" {
      didSet {
        prepareRequest(with: searchText)
      }
    }
    
    func prepareRequest(with name: String) {
        service.request(type: .searchMusic(media: "music", entity: "song", term: name)) { [weak self] (result) in
            switch result {
            case .success(let response):
                  guard let musicHandelr = MusicHandler.updateSearchResults(response.data, section: 0),
                        let requestEnd = self?.onRequestEnd else  { return }
                  self?.musicHandlers.append(contentsOf: musicHandelr)
                  self?.convertMusicToViewModel(musics: musicHandelr)
                            
                case .failure(let error):
                  print("Network error: \(error.localizedDescription)")
                }
        }
        
    }
    
    private func convertMusicToViewModel(musics: [MusicHandler]) {
      for music in musics {
        let listCellViewModel = ListCellViewModel(title: music.collectionName,
                                            description: music.name,
                                               imageUrl: music.imageUrl)
        listCellViewModels.append(listCellViewModel)
      }
       onRequestEnd?()
    }
       
}
