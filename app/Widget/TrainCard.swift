import SwiftUI

/// One train card (design.md, D-45…D-50). Phase 0 approximation of the Iter. 4 boards:
/// structure and states are faithful, exact typography and colours come in Phase 1.
struct TrainCard: View {
    let train: TrainInfo
    let now: Date

    private var isCancelled: Bool { train.status == .cancelled }
    private var isNoRealtime: Bool { train.status == .noRealtime }
    private var leaveNow: Bool { !isCancelled && train.leaveAt <= now }

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                firstRow
                secondRow
            }
            Spacer(minLength: 4)
            if train.status == .realtime {
                PlatformBadge(platform: train.platform,
                              scheduledPlatform: train.scheduledPlatform,
                              status: train.platformStatus,
                              inverted: leaveNow)
            }
            DashedLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                .foregroundStyle(leaveNow ? Color.white.opacity(0.6) : Color.secondary.opacity(0.5))
                .frame(width: 1)
            rightColumn
                .frame(width: 72, alignment: .trailing)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .foregroundStyle(leaveNow ? Color.white : Color.primary)
        .background(cardBackground)
    }

    private var firstRow: some View {
        HStack(spacing: 4) {
            Text(train.number).font(.caption.monospaced())
            Text("·")
            Text(train.terminus).lineLimit(1).truncationMode(.tail).layoutPriority(-1)
            Text("·")
            Text("\(train.durationMinutes) min")
        }
        .font(.caption)
    }

    private var secondRow: some View {
        HStack(spacing: 6) {
            Text("\(train.departure.formatted(date: .omitted, time: .shortened)) → \(train.arrival.formatted(date: .omitted, time: .shortened))")
                .font(.subheadline.weight(.semibold).monospacedDigit())
                .strikethrough(isCancelled)
            statusPill
        }
    }

    @ViewBuilder
    private var statusPill: some View {
        if isNoRealtime {
            Label("Senza real time", systemImage: "antenna.radiowaves.left.and.right.slash")
                .font(.caption2)
                .labelStyle(.titleAndIcon)
        } else if train.status == .realtime && train.delayMinutes >= 2 {
            // D-46: pill only for a delay of at least 2 minutes.
            Text("+\(train.delayMinutes) min")
                .font(.caption2.bold())
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Capsule().fill(leaveNow ? Color.white.opacity(0.25) : Color.orange))
                .foregroundStyle(Color.white)
        }
    }

    @ViewBuilder
    private var rightColumn: some View {
        if isCancelled {
            VStack(alignment: .trailing, spacing: 2) {
                Image(systemName: "xmark")
                Text("Soppresso").font(.caption.bold())
            }
            .foregroundStyle(Color.red)
        } else if leaveNow {
            Text("Esci ora").font(.headline.bold())
        } else {
            VStack(alignment: .trailing, spacing: 0) {
                Text("Esci tra").font(.caption2)
                Text(timerInterval: now...train.leaveAt, countsDown: true, showsHours: false)
                    .font(.title2.bold().monospacedDigit())
                    .multilineTextAlignment(.trailing)
            }
        }
    }

    @ViewBuilder
    private var cardBackground: some View {
        let shape = RoundedRectangle(cornerRadius: 12, style: .continuous)
        if leaveNow {
            shape.fill(Color.orange)
        } else if isCancelled {
            shape.fill(Color.red.opacity(0.15))
        } else if isNoRealtime {
            // D-47: no fill, dashed border 10/6.
            shape.strokeBorder(Color.secondary, style: StrokeStyle(lineWidth: 1, dash: [10, 6]))
        } else {
            shape.fill(Color.primary.opacity(0.07))
        }
    }
}

/// D-48: 28 × 28 pt platform square with scheduled / confirmed / changed states.
struct PlatformBadge: View {
    let platform: String?
    let scheduledPlatform: String?
    let status: TrainInfo.PlatformStatus
    let inverted: Bool

    private var color: Color {
        if inverted { return .white }
        return status == .changed ? .orange : .primary
    }

    var body: some View {
        VStack(spacing: 0) {
            Text("BIN").font(.system(size: 7, weight: .semibold))
            Text(platform ?? "–").font(.system(size: 13, weight: .bold).monospacedDigit())
        }
        .frame(width: 28, height: 28)
        .foregroundStyle(color)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(status == .changed && !inverted ? Color.orange.opacity(0.15) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(status == .scheduled ? color.opacity(0.35) : color, lineWidth: 1)
        )
        .overlay(alignment: .topTrailing) {
            if status != .scheduled {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(inverted ? Color.white : (status == .changed ? Color.orange : Color.green))
                    .offset(x: 4, y: -4)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
    }

    private var accessibilityText: String {
        let number = platform ?? "non disponibile"
        switch status {
        case .scheduled: return "binario \(number) programmato"
        case .confirmed: return "binario \(number) confermato"
        case .changed: return "binario cambiato: \(number), era \(scheduledPlatform ?? "?")"
        }
    }
}

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}
