import SwiftUI
import SwiftData
import MapKit

struct ModalSearch: View {
    @FocusState var isTextFieldFocused: Bool
    private let maxHeight: PresentationDetent = .fraction(0.9)
    @ObservedObject var viewModel: ModalSearchViewModel
    @EnvironmentObject private var filterVM: FilterViewModel
    private func showTenant(tenants: [Tenant]) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading){
                Text("Tenants")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(0)
                Divider()
            }
            if !tenants.isEmpty {
                ForEach(tenants) {tenant in
                    TenantCard(tenant: tenant, displayFoods: viewModel.getDisplayFoods(tenant: tenant, searchTerm: viewModel.searchTerm))
                        .environmentObject(filterVM)
                }
            } else {
                Text("Not Found")
                    .font(.subheadline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
            }
        }
    }

    private func showRecentSearch() -> some View {
        VStack(alignment: .leading) {
            Text("Your Search History")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(0)
            Divider()
            HStack{
                ForEach(viewModel.recentSearch, id: \.self) { recent in
                    Button {
                        viewModel.searchTerm = recent
                    } label: {
                        Text(recent)
                            .foregroundStyle(Color.primary)
                            .font(.caption)
                            .padding(10)
                            .background(Color(.systemGray5))
                            .clipShape(Capsule())
                    }
                    
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            SearchBar(searchTerm: $viewModel.searchTerm,
                      isTextFieldFocused: _isTextFieldFocused,
                      onCancel: viewModel.onClose,
                      onSearch: {
                        viewModel.saveRecentSearch(searchTerm: viewModel.searchTerm)
                      })
            if (viewModel.sheeHeight != .fraction(0.1)){
                Filter(categories: viewModel.categories, filterMode: FilterMode.none)
                    .environmentObject(filterVM)
                ScrollView(.vertical){
                    //Recent search (max 5)
                    if !viewModel.recentSearch.isEmpty {
                        showRecentSearch()
                    }
                    VStack {
                        showTenant(tenants: viewModel.doSearch(searchTerm: viewModel.searchTerm))
                    }.padding(.top, viewModel.recentSearch.isEmpty ? 0 : 10)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .presentationDetents([.fraction(0.1), .fraction(0.7), .fraction(0.9)], selection: $viewModel.sheeHeight)
        .interactiveDismissDisabled()
        .presentationBackgroundInteraction(.enabled(upThrough: maxHeight))
        .onChange(of: isTextFieldFocused, initial: false) { _, newValue in
            withAnimation {
                viewModel.sheeHeight = newValue ? .fraction(0.7) : .fraction(0.1)
            }
        }
        .onChange(of: viewModel.sheeHeight) { _, newValue in
            if newValue == .fraction(0.1) {
                isTextFieldFocused = false
                viewModel.onClose()
            }
        }

    }
}
