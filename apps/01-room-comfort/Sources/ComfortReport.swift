import Foundation

struct ComfortReport: Equatable {
    enum Concern: Equatable {
        case comfortable, cold, warm, humidity
    }

    let headline: String
    let detail: String
    let concern: Concern
    let tips: [String]

    init(reading: RoomReading) {
        let temperature = reading.temperatureBand
        let humidity = reading.humidityBand
        let problems = [temperature.problem, humidity.problem].compactMap { $0 }

        if problems.isEmpty {
            headline = "Comfortable"
            detail = "Temperature and humidity are both in a comfortable range."
        } else {
            let sentence = problems.joined(separator: " and ")
            headline = sentence.prefix(1).uppercased() + sentence.dropFirst()
            detail = "Aim for 18 to 24 °C and 40 to 60% humidity."
        }

        switch (temperature, humidity) {
        case (.cold, _), (.cool, _): concern = .cold
        case (.warm, _), (.hot, _): concern = .warm
        case (.comfortable, .comfortable): concern = .comfortable
        case (.comfortable, _): concern = .humidity
        }

        tips = [temperature.tip, humidity.tip].compactMap { $0 }
    }
}
