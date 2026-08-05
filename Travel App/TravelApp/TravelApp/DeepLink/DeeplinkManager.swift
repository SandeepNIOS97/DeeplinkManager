//
//  DeeplinkManager.swift
//  TravelApp
//
//  Created by Sandeep Nigam on 23/05/26.
//

import Foundation
import SwiftUI

final class DeepLinkManager: ObservableObject {
    @Published var deepLinkURL: URL?
    /*@Published*/ var deepLinkNavigation: DeepLinkNavigation?
    static let shared: DeepLinkManager = DeepLinkManager()
    
    private init() {}
    
    enum DeepLinkType {
        case pushNotifcation
        case appNotification
    }
    
    func handleDeepLink(_ url: URL?) {
        deepLinkURL = url
        self.parseURL(url: url)
    }
    
    private func parseURL(url: URL?) {
        DispatchQueue.main.async {
            guard let url = url else { return }
            let urlRequest = URLRequest (url: url)
            let pathComponents = urlRequest.url?.pathComponents
            _ = urlRequest.url?.pathExtension
            _ = urlRequest.url?.lastPathComponent
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            _ = components?.query
            let queryItems = components?.queryItems
            let deepLink = self.findDeepLinkNavigation(pathComponents: pathComponents, queryItems: queryItems)
            self.deepLinkNavigation = deepLink
        }
        
    }
    
    func convertQueryItemsToModel<T: Codable>(type: T.Type, dictionaryData: [String: Any]) -> T? {
        // Convert dictionary to JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionaryData)
        else {
            return nil
        }
        // Decode JSON data into the model
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(T.self, from: jsonData)
            return model
        }
        catch {
            print ("Decoding failed: \(error)")
            return nil
        }
    }
    private func findDeepLinkNavigation(pathComponents: [String]?, queryItems: [URLQueryItem]?) -> DeepLinkNavigation? {
        let queryItemsDict = queryItems?.queryDictionary ?? [:]
        let screenType = ScreenType(rawValue: queryItemsDict["screenType"] ?? "")
        if let dataModel = screenType?.getDeepLinkDataModel(), let model =
            convertQueryItemsToModel(type: dataModel.self, dictionaryData: queryItemsDict) {
            switch screenType {
            case .countryDetail:
                if let screenTypeModel = model as? DeepLinkModel {
                    return DeepLinkNavigation.countryDetail(dataModel: screenTypeModel)
                }
            case .none:
                return nil
            }
        }
        return nil
    }
}

enum DeepLinkNavigation {
    case countryDetail(dataModel: DeepLinkModel)
    case none
}

extension DeepLinkNavigation: Equatable {
    static func == (lhs: DeepLinkNavigation, rhs: DeepLinkNavigation) -> Bool {
        switch (lhs, rhs) {
        case (.countryDetail, .countryDetail): return true
        case (.none, .none): return true
        default: return false
        }
    }
    
    func identifyViewDestination () -> ViewDestination {
        switch self {
        case .countryDetail(let dataModel):
            ViewDestination.countryDetail(dataModel: dataModel)
        case .none:
                .none
        }
    }
}

enum ScreenType: String {
    case countryDetail = "countryDetail"
    
    func getDeepLinkDataModel() -> Codable.Type {
        switch self {
        case .countryDetail:
            return DeepLinkModel.self
        }
    }
}

extension Array where Element == URLQueryItem {
    var queryDictionary: [String: String] {
        self.reduce(into: [:]) { $0[$1.name] = $1.value }
    }
}
