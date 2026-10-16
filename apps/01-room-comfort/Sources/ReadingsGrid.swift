import SwiftUI

struct ReadingsGrid: View {
    let reading: RoomReading

    var body: some View {
        ViewThatFits(in: .horizontal) {
            Grid(alignment: .topLeading, horizontalSpacing: 12, verticalSpacing: 12) {
                GridRow {
                    temperatureTile
                    humidityTile
                    dewPointTile
                }
            }

            Grid(alignment: .topLeading, horizontalSpacing: 12, verticalSpacing: 12) {
                GridRow {
                    temperatureTile
                    humidityTile
                }
                GridRow {
                    dewPointTile
                        .gridCellColumns(2)
                }
            }

            VStack(spacing: 12) {
                temperatureTile
                humidityTile
                dewPointTile
            }
        }
    }

    private var temperatureTile: some View {
        ReadingTile(
            title: "Temperature",
            systemImage: "thermometer.medium",
            value: reading.temperature.celsiusText,
            detail: reading.temperatureBand.label
        )
    }

    private var humidityTile: some View {
        ReadingTile(
            title: "Humidity",
            systemImage: "humidity",
            value: reading.humidity.percentText,
            detail: reading.humidityBand.label
        )
    }

    private var dewPointTile: some View {
        ReadingTile(
            title: "Dew point",
            systemImage: "drop",
            value: reading.dewPoint.celsiusText,
            detail: "Windows colder than this mist up"
        )
    }
}

struct ReadingTile: View {
    let title: String
    let systemImage: String
    let value: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: systemImage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title2.weight(.semibold))
                .monospacedDigit()
            Text(detail)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.fill.tertiary, in: .rect(cornerRadius: 16))
        .accessibilityElement(children: .combine)
    }
}
