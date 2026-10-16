import SwiftUI

struct VerdictCard: View {
    let report: ComfortReport

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var headerLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 12))
            : AnyLayout(HStackLayout(alignment: .top, spacing: 16))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerLayout {
                Image(systemName: report.concern.symbolName)
                    .font(.largeTitle)
                    .foregroundStyle(report.concern.color)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(report.headline)
                        .font(.title2.bold())
                        .accessibilityAddTraits(.isHeader)
                    Text(report.detail)
                        .foregroundStyle(.secondary)
                }
            }

            ForEach(report.tips, id: \.self) { tip in
                Label(tip, systemImage: "lightbulb")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(report.concern.color.opacity(0.12), in: .rect(cornerRadius: 20))
        .animation(.default, value: report)
    }
}

extension ComfortReport.Concern {
    var color: Color {
        switch self {
        case .comfortable: .green
        case .cold: .blue
        case .warm: .orange
        case .humidity: .teal
        }
    }

    var symbolName: String {
        switch self {
        case .comfortable: "checkmark.circle.fill"
        case .cold: "thermometer.snowflake"
        case .warm: "thermometer.sun.fill"
        case .humidity: "humidity.fill"
        }
    }
}
