//
//  CountryDetailVM.swift
//  TravelApp
//
//  Created by Sandeep Nigam on 05/08/26.
//

import Foundation

class CountryDetailVM: ObservableObject {
    @Published var country: Country?
    @Published var errorMessage: String?
    
    private let loader: CountriesLoading
    private let countryName: String
    
    init(countryName: String, loader: CountriesLoading = BundleCountriesLoader()) {
        self.countryName = countryName
        self.loader = loader
    }
    
    func load() async {
        do {
            let all = try await loader.loadCountries()
            DispatchQueue.main.async {
                self.country = all.first { $0.name == self.countryName }
                if self.country == nil {
                    self.errorMessage = "Country with id \(self.countryName) not found"
                }
            }
        } catch {
            self.errorMessage = "Failed to load country: \(error.localizedDescription)"
        }
    }
}
