//
//  NetworkingService.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation

protocol NetwotkingServiceProtocol {
    func getData(withComplition complition: @escaping (ResponseHeader?) -> Void)
}

class NetwotkingService: NetwotkingServiceProtocol {
    
    func getData(withComplition complition: @escaping (ResponseHeader?) -> Void) {
        
        let urlString = "https://8ball.delegator.com/magic/JSON/tell_me_smth"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared.dataTask(with: url) { (data, respose, error) in
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(ResponseHeader.self, from: data)
                complition(response)
            } catch {
                print(error.localizedDescription)
            }
        }
        session.resume()
    }
}
