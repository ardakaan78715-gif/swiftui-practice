import Foundation

struct RoomReading: Equatable {
    let temperature: Double
    let humidity: Double

    init(temperature: Double, humidity: Double) {
        self.temperature = temperature
        self.humidity = min(max(humidity, 1), 100)
    }

    var dewPoint: Double {
        let b = 17.62
        let c = 243.12
        let gamma = log(humidity / 100) + b * temperature / (c + temperature)
        return c * gamma / (b - gamma)
    }

    var temperatureBand: TemperatureBand {
        TemperatureBand(celsius: temperature)
    }

    var humidityBand: HumidityBand {
        HumidityBand(percent: humidity)
    }
}

enum TemperatureBand: Equatable {
    case cold, cool, comfortable, warm, hot

    init(celsius: Double) {
        switch celsius {
        case ..<16: self = .cold
        case ..<18: self = .cool
        case ...24: self = .comfortable
        case ...27: self = .warm
        default: self = .hot
        }
    }

    var label: String {
        switch self {
        case .cold: "Cold"
        case .cool: "Cool"
        case .comfortable: "Comfortable"
        case .warm: "Warm"
        case .hot: "Hot"
        }
    }

    var problem: String? {
        self == .comfortable ? nil : label.lowercased()
    }

    var tip: String? {
        switch self {
        case .cold: "Turn the heating up and close the curtains at dusk to keep the warmth in."
        case .cool: "Nudge the thermostat up a degree or two. 18 to 21 °C suits most living rooms."
        case .comfortable: nil
        case .warm: "Open a window on the shady side of the house to let cooler air through."
        case .hot: "Close the blinds on sunny windows, keep the air moving with a fan and drink water often."
        }
    }
}

enum HumidityBand: Equatable {
    case dry, comfortable, damp

    init(percent: Double) {
        switch percent {
        case ..<40: self = .dry
        case ...60: self = .comfortable
        default: self = .damp
        }
    }

    var label: String {
        switch self {
        case .dry: "Dry"
        case .comfortable: "Just right"
        case .damp: "Damp"
        }
    }

    var problem: String? {
        switch self {
        case .dry: "dry air"
        case .comfortable: nil
        case .damp: "damp air"
        }
    }

    var tip: String? {
        switch self {
        case .dry: "A bowl of water on a radiator or a few house plants will add some moisture."
        case .comfortable: nil
        case .damp: "Run the extractor fan after cooking and showers, and wipe condensation off the windows."
        }
    }
}
