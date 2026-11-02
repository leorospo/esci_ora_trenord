import ActivityKit
import SwiftUI
import WidgetKit

struct TrainLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TrainActivityAttributes.self) { context in
            LockScreenView(route: context.attributes.route, state: context.state, isStale: context.isStale)
        } dynamicIsland: { context in
            // Dynamic Island is low priority (stato.md): minimal content for Phase 0.
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    if let train = context.state.trains.first {
                        TrainCard(train: train, now: .now)
                    }
                }
            } compactLeading: {
                Image(systemName: "tram.fill")
            } compactTrailing: {
                if let train = context.state.trains.first {
                    CompactLeaveText(train: train)
                }
            } minimal: {
                Image(systemName: "tram.fill")
            }
        }
    }
}

/// Lock Screen layout (design.md, Iter. 4): up to two cards and the footer.
struct LockScreenView: View {
    let route: String
    let state: TrainActivityAttributes.ContentState
    let isStale: Bool

    var body: some View {
        VStack(spacing: 6) {
            ForEach(Array(state.trains.prefix(2))) { train in
                TrainCard(train: train, now: .now)
            }
            footer
        }
        .padding(12)
    }

    @ViewBuilder
    private var footer: some View {
        let time = state.updatedAt.formatted(date: .omitted, time: .shortened)
        HStack {
            if state.realtimeUnavailable {
                Text("⚠ Tempo reale non raggiungibile · agg. \(time)")
                    .foregroundStyle(Color.orange)
            } else {
                Text(route)
                Spacer()
                // "#N" and "scaduto" are Phase 0 diagnostics.
                Text("Aggiornato alle \(time) · #\(state.updateCount)\(isStale ? " · scaduto" : "")")
            }
        }
        .font(.caption2)
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
}

struct CompactLeaveText: View {
    let train: TrainInfo

    var body: some View {
        let now = Date.now
        if train.leaveAt > now {
            Text(timerInterval: now...train.leaveAt, countsDown: true, showsHours: false)
                .monospacedDigit()
                .frame(maxWidth: 44)
        } else {
            Text("Ora").foregroundStyle(Color.orange)
        }
    }
}
