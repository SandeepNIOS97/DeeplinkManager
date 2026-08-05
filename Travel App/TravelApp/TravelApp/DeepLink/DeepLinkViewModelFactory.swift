//
//  DeepLinkViewModelFactory.swift
//  TravelApp
//
//  Created by Sandeep Nigam on 25/07/26.
//

import Foundation

struct DeepLinkViewModelFactory {}

extension DeepLinkViewModelFactory {
    struct MAITripVMFactory {
        static func makeCountryDetailVM(countryDetailDataModel: DeepLinkModel) -> CountryDetailVM {
            return CountryDetailVM(countryName: countryDetailDataModel.countryName ?? "")
        }
    }
}
