import SwiftUI

struct ContentView: View {
    @State private var progress: Double = 0
    @State private var sliderValue: Double = 0
    @State private var message = "დააჭირე ჩამოტვირთვას"
    @State private var isDownloading = false

    var body: some View {
        VStack(spacing: 28) {
            Text("ჩამოტვირთვა")
                .font(.largeTitle)
                .bold()

            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .padding(.horizontal)

            Text("\(Int(progress * 100))%")
                .font(.title2)

            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(minHeight: 30)

            Slider(value: $sliderValue, in: 0...100)
                .padding(.horizontal)

            Text("სლაიდერი: \(Int(sliderValue))")
                .foregroundStyle(.secondary)

            Button("ჩამოტვირთვა (GCD)") {
                startGCDDownload()
            }
            .buttonStyle(.borderedProminent)
            .disabled(isDownloading)

            Button("ჩამოტვირთვა (async/await)") {
                Task {
                    await startAsyncDownload()
                }
            }
            .buttonStyle(.bordered)
            .disabled(isDownloading)
        }
        .padding()
    }

    private func startGCDDownload() {
        guard !isDownloading else { return }
        isDownloading = true
        progress = 0
        message = "იტვირთება..."

        for step in 1...3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(step)) {
                progress = Double(step) / 3.0

                if step == 3 {
                    message = "მზადაა!"
                    isDownloading = false
                }
            }
        }
    }

    @MainActor
    private func startAsyncDownload() async {
        guard !isDownloading else { return }
        isDownloading = true
        progress = 0
        message = "იტვირთება..."

        for step in 1...3 {
            do {
                try await Task.sleep(for: .seconds(1))
            } catch {
                isDownloading = false
                return
            }

            progress = Double(step) / 3.0

            if step == 3 {
                message = "მზადაა!"
                isDownloading = false
            }
        }
    }
}
