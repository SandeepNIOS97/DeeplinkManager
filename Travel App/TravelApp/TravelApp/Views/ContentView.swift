//
//  ContentView.swift
//  TravelApp
//
//  Created by Sandeep Nigam on 11/05/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CountriesViewModel()
    @StateObject private var router: ViewRouter = ViewRouter.sharedInstance

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Top Destinations")
                    .font(.largeTitle.bold())
                    .padding([.horizontal, .top])

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }

                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack(spacing: 16, pinnedViews: []) {
                        ForEach(viewModel.countries) { country in
                            NavigationLink(value: country) {
                                CountryCardView(country: country)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationDestination(for: Country.self) { country in
                CountryDetailView(detailVM: CountryDetailVM(countryName: country.name))
            }
            .navigationDestination(isPresented: $router.isPushDestinationView) {
                redirectDeepLinkView()
            }
            .fullScreenCover(isPresented: $router.isPresentDestinationView) {
                redirectDeepLinkView()
            }
        }
        .onAppear {
            // ensure data is loaded
            viewModel.loadCountries()
            handleDeepLink()
        }
    }
    
    @ViewBuilder
    func redirectDeepLinkView() -> some View {
        switch router.currentPage {
        case .countryDetail(let dataModel):
            if let vm = router.currentPage.prepareVM() as? CountryDetailVM {
                CountryDetailView(detailVM: vm)
            }
        case .none:
            EmptyView()
        }
    }
    
    private func handleDeepLink() {
        DispatchQueue.main.async {
            guard let value = DeepLinkManager.shared.deepLinkNavigation, value != .none else { return }
            let routeDestination = value.identifyViewDestination()
            if routeDestination.isPresentDestinationView {
                router.isPresentDestinationView = routeDestination.isPresentDestinationView
            }
            if routeDestination.isPushDestinationView {
                router.isPushDestinationView = routeDestination.isPushDestinationView
            }
            DeepLinkManager.shared.deepLinkNavigation = DeepLinkNavigation.none
            router.currentPage = routeDestination
        }
    }
}

#Preview {
    ContentView()
}
