//
//  NetworkManager.swift
//  bnet-test
//
//  Created by Tigran Danielian on 07.06.2020.
//  Copyright © 2020 Tigran Danielian. All rights reserved.
//

import Foundation
import Network
import SystemConfiguration



protocol NetworkManagerDelegate {
    func didUpdateData (_: NetworkManager, models: [DataModel])
}

class NetworkManager {
    private let token = "dKwqY1w-CK-c2IRaO1"
    private let urlString = "https://bnet.i-partner.ru/testAPI/"
    private let defaults = UserDefaults.standard
    var sessionId: String?
    var delegate: NetworkManagerDelegate?
    
    
//   let monitor = NWPathMonitor()

//   func checkInternet() -> Bool {
//    var status = false
//       monitor.pathUpdateHandler = { path in
//           if path.status == .satisfied {
//               status = true  // online
//           } else {
//            status = false
//            print("no connection")
//
//        }
//       }
//       return status
//   }
    
    
    func newSession() {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue(token, forHTTPHeaderField: "token")
            guard let httpBody = "a=new_session".data(using: .utf8) else {return}
            request.httpBody = httpBody
          
            if sessionId == nil {
                  
                let session = URLSession.shared
                session.dataTask(with: request) { (data, response, error) in
                    if let response = response {
                        print(response)
                    }
                    guard let data = data else {return}
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                        let decoder = JSONDecoder()
                        do {
                            let decodedData = try decoder.decode(RecievedData.self, from: data)
                            self.defaults.set(decodedData.data.session, forKey: "sessionId")
                            self.sessionId = decodedData.data.session
                        } catch {
                            print(error)
                        }
                        
                    } catch {
                        print(error)
                    }
                }.resume()
            } else {
                sessionId = defaults.string(forKey: "sessionId")
            }
        }
    }
    
    func getEntries() {
        
        if let url = URL(string: urlString) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue(token, forHTTPHeaderField: "token")
        
        let session = URLSession.shared
            
        guard let s = sessionId else {return}
            
        guard let httpBody = "a=get_entries&session=\(s)".data(using: .utf8) else {return}
        request.httpBody = httpBody
        session.dataTask(with: request) { (data, response, error) in
                       if let response = response {
                           print(response)
                       }
                       guard let data = data else {return}
                       do {
                           let json = try JSONSerialization.jsonObject(with: data, options: [])
                           print(json)
                           
                           if let models = self.parseJSON(data: data) {
                           self.delegate?.didUpdateData(self, models: models)
                            
                           }
                           
                       } catch {
                           print(error)
                       }
                   }.resume()
        }
    }
    
    func addEntry(body: String) {
        
        if let url = URL(string: urlString) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue(token, forHTTPHeaderField: "token")
            guard let s = sessionId else {return}
            let httpBody = "a=add_entry&session=\(s)&body=\(body)".data(using: .utf8)
            request.httpBody = httpBody
            
            let session = URLSession.shared
                    session.dataTask(with: request) { (data, response, error) in
                        if let response = response {
                            print(response)
                        }
                        guard let data = data else {return}
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print(json)
                        } catch {
                            print(error)
                        }
                    }.resume()
            
        }
    }
    
    func parseJSON(data: Data) -> [DataModel]? {
        let decoder = JSONDecoder()
        var models: [DataModel] = []
        do {
            let decodedData = try decoder.decode(EntriesData.self, from: data)
//            print(decodedData.data[0][0].body)
            
            for i in 0..<decodedData.data[0].count {
                
            let body = decodedData.data[0][i].body
            let da = decodedData.data[0][i].da
            let dm = decodedData.data[0][i].dm
            let id = decodedData.data[0][i].id
            let model = DataModel(session: id, dateAdded: Double(da), dateModified: Double(dm), entry: body)
            models.append(model)
                
            }
            return models
        } catch {
            print(error)
            return nil
        }
    }
    
    public static func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    
}


