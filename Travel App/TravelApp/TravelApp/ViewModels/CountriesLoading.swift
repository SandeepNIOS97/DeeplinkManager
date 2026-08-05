//
//  CountriesLoading.swift
//  TravelApp
//
//  Created by Sandeep Nigam on 05/08/26.
//

import Foundation

/// Protocol that provides countries. Use different implementations (bundle, network, mock).
protocol CountriesLoading {
    func loadCountries() async throws -> [Country]
}
