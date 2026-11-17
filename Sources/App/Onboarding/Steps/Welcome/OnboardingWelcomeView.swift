import Foundation
import Shared
import SwiftUI

// MARK: - SisteMatich iOS Welcome Screen

struct OnboardingWelcomeView: View {

    private enum Constants {
        static let maxContentWidth: CGFloat = 520
        static let logoWidth: CGFloat = 250
        static let logoHeight: CGFloat = 190
        static let buttonHeight: CGFloat = 58
    }

    @Environment(\.verticalSizeClass)
    private var verticalSizeClass

    @Environment(\.layoutDirection)
    private var layoutDirection

    @State private var showStore = false

    // Mevcut iOS sunucu kesif akisina devam eder.
    let continueAction: () -> Void

    private let storeURL = URL(
        string: "https://sistematich.com"
    )!

    // MARK: - SisteMatich Background

    private var sistematichBackground: LinearGradient {
        LinearGradient(
            stops: [
                .init(
                    color: Color(
                        red: 213.0 / 255.0,
                        green: 244.0 / 255.0,
                        blue: 242.0 / 255.0
                    ),
                    location: 0
                ),
                .init(
                    color: Color(
                        red: 226.0 / 255.0,
                        green: 232.0 / 255.0,
                        blue: 244.0 / 255.0
                    ),
                    location: 0.40
                ),
                .init(
                    color: Color(
                        red: 240.0 / 255.0,
                        green: 220.0 / 255.0,
                        blue: 231.0 / 255.0
                    ),
                    location: 0.70
                ),
                .init(
                    color: Color(
                        red: 250.0 / 255.0,
                        green: 217.0 / 255.0,
                        blue: 217.0 / 255.0
                    ),
                    location: 1
                )
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Adaptive Layout

    private var isCompact: Bool {
        verticalSizeClass == .compact
    }

    // MARK: - Main View

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 0) {

                    Spacer(minLength: isCompact ? 8 : 50)

                    logoBlock

                    Spacer(minLength: isCompact ? 12 : 34)

                    titleBlock

                    Spacer(minLength: isCompact ? 8 : 26)

                    sloganBlock

                    Spacer(minLength: isCompact ? 24 : 65)

                    actionButtons

                    Spacer(minLength: 35)
                }
                .frame(maxWidth: Constants.maxContentWidth)
                .frame(
                    maxWidth: .infinity,
                    minHeight: max(
                        0,
                        proxy.size.height
                    )
                )
                .padding(.horizontal, 22)
            }
            .scrollIndicators(.hidden)
            .background {
                sistematichBackground
                    .ignoresSafeArea()
            }
            .offset(
                x: SafeAreaCenteringOffset.horizontal(
                    safeAreaInsets: proxy.safeAreaInsets,
                    layoutDirection: layoutDirection
                )
            )
        }
        .sheet(isPresented: $showStore) {
            SafariWebView(url: storeURL)
        }
    }

    // MARK: - SisteMatich Logo

    private var logoBlock: some View {
        Image("launchScreen-logo")
            .resizable()
            .scaledToFit()
            .frame(
                width: isCompact ? 150 : Constants.logoWidth,
                height: isCompact ? 100 : Constants.logoHeight
            )
            .accessibilityLabel("SisteMatich")
            .launchSplashLogoAnchor()
    }

    // MARK: - Title

    private var titleBlock: some View {
        VStack(spacing: 8) {
            Text("SisteMatich")
                .font(
                    .system(
                        size: isCompact ? 27 : 34,
                        weight: .bold,
                        design: .rounded
                    )
                )

            Text("Akıllı Yaşam Teknolojileri")
                .font(
                    .system(
                        size: isCompact ? 18 : 23,
                        weight: .semibold
                    )
                )
        }
        .foregroundStyle(
            Color(red: 0.12, green: 0.16, blue: 0.23)
        )
        .multilineTextAlignment(.center)
    }

    // MARK: - Slogan

    private var sloganBlock: some View {
        Text(
            "Cihazlarınızı Akıllandırın, " +
            "Tek Bir Uygulamadan Yönetin!"
        )
        .font(
            .system(
                size: isCompact ? 15 : 18,
                weight: .regular
            )
        )
        .foregroundStyle(
            Color(red: 0.35, green: 0.36, blue: 0.40)
        )
        .multilineTextAlignment(.center)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 8)
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        VStack(spacing: 18) {

            // Server connection

            Button(action: continueAction) {
                Label(
                    "Sunucuna Bağlan",
                    systemImage: "house.fill"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )
                .frame(maxWidth: .infinity)
                .frame(height: Constants.buttonHeight)
            }
            .buttonStyle(SisteMatichWelcomeButtonStyle())
            .accessibilityIdentifier(
                AccessibilityIdentifier
                    .onboardingWelcomeContinue
                    .rawValue
            )

            // SisteMatich website / store

            Button {
                showStore = true
            } label: {
                Label(
                    "Mağaza",
                    systemImage: "bag.fill"
                )
                .font(
                    .system(
                        size: 19,
                        weight: .semibold
                    )
                )
                .frame(maxWidth: .infinity)
                .frame(height: Constants.buttonHeight)
            }
            .buttonStyle(SisteMatichWelcomeButtonStyle())
        }
        .frame(maxWidth: 400)
        .padding(.horizontal, 16)
    }
}

// MARK: - SisteMatich Button Style

private struct SisteMatichWelcomeButtonStyle:
    ButtonStyle {

    func makeBody(
        configuration: Configuration
    ) -> some View {

        configuration.label
            .foregroundStyle(
                Color(
                    red: 0.13,
                    green: 0.15,
                    blue: 0.19
                )
            )
            .background {
                RoundedRectangle(
                    cornerRadius: 35,
                    style: .continuous
                )
                .fill(
                    Color.white.opacity(
                        configuration.isPressed
                            ? 0.30
                            : 0.42
                    )
                )
                .overlay {
                    RoundedRectangle(
                        cornerRadius: 35,
                        style: .continuous
                    )
                    .stroke(
                        Color.white.opacity(0.75),
                        lineWidth: 1.5
                    )
                }
                .shadow(
                    color: Color.black.opacity(0.12),
                    radius: 9,
                    x: 0,
                    y: 5
                )
            }
            .scaleEffect(
                configuration.isPressed
                    ? 0.98
                    : 1.0
            )
            .animation(
                .easeOut(duration: 0.16),
                value: configuration.isPressed
            )
    }
}

// MARK: - SwiftUI Preview

#Preview("SisteMatich Welcome") {
    NavigationStack {
        OnboardingWelcomeView(
            continueAction: {}
        )
    }
}
