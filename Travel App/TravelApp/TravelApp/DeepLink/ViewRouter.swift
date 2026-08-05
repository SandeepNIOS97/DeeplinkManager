//
//  ViewRouter.swift
//  TravelApp
//
//  Created by Sandeep Nigam on 25/07/26.
//

import Foundation

enum ViewDestination {
    case countryDetail(dataModel: DeepLinkModel)
    case none
    
    init?(from value: String, dataModel: Codable) {
        switch value {
        case "countryDetail":
            self = ViewDestination.createNotification(for: dataModel, as: DeepLinkModel.self, createCase: { .countryDetail(dataModel: $0 )})
        default:
            self = .none
        }
    }
    
    private static func createNotification<T: Codable>(for dataModel: Codable, as type: T.Type,
                                                       createCase: (T)-> ViewDestination) -> ViewDestination {
        guard let typeData = dataModel as? T else {
            return .none
        }
        return createCase(typeData)
    }
    
    var isPushDestinationView: Bool {
        switch self {
        case .countryDetail:
            return true
        case .none:
            return false
        }
    }
    
    var isPresentDestinationView: Bool {
        switch self {
        case .countryDetail, .none:
            return false
        }
    }
    
    func prepareVM() -> (any ObservableObject)? {
        switch self {
        case .countryDetail(let dataModel):
            return DeepLinkViewModelFactory.MAITripVMFactory.makeCountryDetailVM(countryDetailDataModel: dataModel)
        case .none:
            return nil
        }
    }
}
    
class ViewRouter: ObservableObject {
    var currentPage: ViewDestination = .none
    @Published var isPresentDestinationView: Bool = false
    @Published var isPushDestinationView: Bool = false
    static let sharedInstance: ViewRouter = ViewRouter()
    
    private init() {}
    
    func navigate(to destination: ViewDestination) {
        isPushDestinationView = destination.isPushDestinationView
        isPresentDestinationView = destination.isPresentDestinationView
        currentPage = destination
    }
}
