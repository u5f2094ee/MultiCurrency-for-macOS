import MultiCurrencyCore
#if canImport(SwiftUI)
import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedProvider") private var provider: String = PersistenceManager.shared.selectedProviderIdentifier ?? "ExchangeRateAPI"

    var body: some View {
        Form {
            Picker("API Provider", selection: $provider) {
                Text("ExchangeRate-API").tag("ExchangeRateAPI")
                Text("OpenExchangeAPI").tag("OpenExchangeAPI")
            }
        }
        .onChange(of: provider) { newValue in
            PersistenceManager.shared.selectedProviderIdentifier = newValue
        }
        .navigationTitle("Settings")
    }
}
#endif
