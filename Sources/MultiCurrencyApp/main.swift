import MultiCurrencyCore
#if canImport(SwiftUI)
import SwiftUI

@main
struct MultiCurrencyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var amountText: String = "1"
    @State private var rates: CurrencyRates?
    @State private var lastUpdated: Date?

    private let fetcher: CurrencyRateFetcher

    init() {
        let primary = ExchangeRateAPIService(apiKey: "YOUR_API_KEY")
        let fallback = OpenExchangeAPIService(apiKey: "YOUR_API_KEY")
        fetcher = CurrencyRateFetcher(primary: primary, fallbacks: [fallback])
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Amount", text: $amountText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: amountText) { _ in Task { await load() } }
                    .padding()

                if let rates {
                    List(rates.rates.sorted(by: { $0.key < $1.key }), id: \.key) { code, rate in
                        HStack {
                            Text(code)
                            Spacer()
                            Text(String(format: "%.2f", rate * (ExpressionParser.evaluate(amountText) ?? 1)))
                        }
                    }
                } else {
                    Text("No data")
                }

                if let lastUpdated {
                    Text("Last updated: \(lastUpdated.formatted(date: .abbreviated, time: .standard))")
                        .font(.footnote)
                        .padding()
                }
            }
            .navigationTitle("Rates")
            .toolbar {
                NavigationLink("Settings") {
                    SettingsView()
                }
            }
            .task { await load() }
        }
    }

    private func load() async {
        if let fetched = await fetcher.fetchRates(base: "USD") {
            rates = fetched
            lastUpdated = fetched.lastUpdated
        }
    }
}
#endif
