//
//  NetworkingService.swift
//  FortuneTeller
//
//  Created by Dmitry Grin on 8/18/19.
//  Copyright © 2019 Dmitry Grin. All rights reserved.
//

import Foundation
import Alamofire

final class NetwotkingService: Networking {

    func getAnswer(withCompletion completion: @escaping (ResponsePackage?) -> Void) {

        guard let url = URL(string: "https://8ball.delegator.com/magic/JSON/tell_me_smth") else { return }
        var requestSetup = URLRequest(url: url)
        requestSetup.timeoutInterval = 17.0

        AF.request(requestSetup).responseJSON { response in
            guard let json = response.data else { return completion(nil) }
            do {
                let response = try JSONDecoder().decode(ResponsePackage.self, from: json)
                print(response)
                completion(response)
            } catch {
                print("Error here\(error)")
            }
        }
    }
}
