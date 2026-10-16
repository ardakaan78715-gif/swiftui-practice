import SwiftUI

struct ContentView: View {
    @State private var temperature = 19.5
    @State private var humidity = 64.0

    private var reading: RoomReading {
        RoomReading(temperature: temperature, humidity: humidity)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VerdictCard(report: ComfortReport(reading: reading))
                    ReadingsGrid(reading: reading)
                    controls
                    Text("General guidance for living spaces. Not a medical device.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
            .navigationTitle("Room Comfort")
        }
        .tint(.teal)
    }

    private var controls: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Adjust the room")
                .font(.headline)
            ReadingSlider(
                title: "Temperature",
                valueText: temperature.celsiusText,
                value: $temperature,
                range: 10...32,
                step: 0.5
            )
            ReadingSlider(
                title: "Humidity",
                valueText: humidity.percentText,
                value: $humidity,
                range: 20...90,
                step: 1
            )
        }
    }
}

struct ReadingSlider: View {
    let title: String
    let valueText: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            LabeledContent(title, value: valueText)
                .monospacedDigit()
            Slider(value: $value, in: range, step: step) {
                Text(title)
            }
            .accessibilityValue(valueText)
        }
    }
}

#Preview {
    ContentView()
}
