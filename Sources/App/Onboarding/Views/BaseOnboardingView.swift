import Shared
import SwiftUI

/// SisteMatich - Ortak iOS kurulum ekrani.
/// Mevcut onboarding islevleri korunur.
/// Dashboard bu arka plandan etkilenmez.
public struct BaseOnboardingView<Illustration: View, Content: View>: View, KeyboardReadable {

    @State private var isKeyboardVisible = false

    @Environment(\.disableOnboardingPrimaryAction)
    private var disablePrimaryAction

    // MARK: - SisteMatich Arka Plan

    private var sistematichBackground: LinearGradient {
        LinearGradient(
            colors: [
                Color(
                    red: 213.0 / 255.0,
                    green: 244.0 / 255.0,
                    blue: 242.0 / 255.0
                ),
                Color(
                    red: 232.0 / 255.0,
                    green: 221.0 / 255.0,
                    blue: 238.0 / 255.0
                ),
                Color(
                    red: 250.0 / 255.0,
                    green: 217.0 / 255.0,
                    blue: 217.0 / 255.0
                )
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Inputs

    private let illustration: () -> Illustration
    private let title: String
    private let primaryDescription: String
    private let secondaryDescription: String?

    private let content: (() -> Content)?

    private let primaryActionTitle: String
    private let primaryAction: () -> Void
    private let primaryActionIdentifier: String?

    private let secondaryActionTitle: String?
    private let secondaryAction: (() -> Void)?
    private let secondaryActionIdentifier: String?

    // MARK: - Layout

    private let verticalSpacing: CGFloat

    private let maxContentWidth: CGFloat =
        Sizes.maxWidthForLargerScreens

    private let bottomAnchor = "bottom-anchor"

    // MARK: - Initializer With Custom Content

    public init(
        @ViewBuilder illustration: @escaping () -> Illustration,
        title: String,
        primaryDescription: String,
        secondaryDescription: String? = nil,
        @ViewBuilder content: @escaping () -> Content,
        primaryActionTitle: String,
        primaryAction: @escaping () -> Void,
        primaryActionIdentifier: String? = nil,
        secondaryActionTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil,
        secondaryActionIdentifier: String? = nil,
        illustrationTopPadding: CGFloat = DesignSystem.Spaces.four,
        verticalSpacing: CGFloat = DesignSystem.Spaces.three
    ) {
        self.illustration = illustration
        self.title = title
        self.primaryDescription = primaryDescription
        self.secondaryDescription = secondaryDescription
        self.content = content
        self.primaryActionTitle = primaryActionTitle
        self.primaryAction = primaryAction
        self.primaryActionIdentifier = primaryActionIdentifier
        self.secondaryActionTitle = secondaryActionTitle
        self.secondaryAction = secondaryAction
        self.secondaryActionIdentifier = secondaryActionIdentifier
        self.verticalSpacing = verticalSpacing
    }

    // MARK: - Initializer Without Custom Content

    public init(
        @ViewBuilder illustration: @escaping () -> Illustration,
        title: String,
        primaryDescription: String,
        secondaryDescription: String? = nil,
        primaryActionTitle: String,
        primaryAction: @escaping () -> Void,
        primaryActionIdentifier: String? = nil,
        secondaryActionTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil,
        secondaryActionIdentifier: String? = nil,
        illustrationTopPadding: CGFloat = DesignSystem.Spaces.four,
        verticalSpacing: CGFloat = DesignSystem.Spaces.three
    ) where Content == EmptyView {
        self.illustration = illustration
        self.title = title
        self.primaryDescription = primaryDescription
        self.secondaryDescription = secondaryDescription
        self.content = nil
        self.primaryActionTitle = primaryActionTitle
        self.primaryAction = primaryAction
        self.primaryActionIdentifier = primaryActionIdentifier
        self.secondaryActionTitle = secondaryActionTitle
        self.secondaryAction = secondaryAction
        self.secondaryActionIdentifier = secondaryActionIdentifier
        self.verticalSpacing = verticalSpacing
    }

    // MARK: - Main View

    public var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack(spacing: verticalSpacing) {

                    // MARK: Illustration

                    Group {
                        if let image = illustration() as? Image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 130)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .center
                                )
                        } else {
                            illustration()
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .center
                                )
                        }
                    }
                    .padding(
                        .top,
                        DesignSystem.Spaces.two
                    )

                    // MARK: Title

                    Text(title)
                        .font(
                            DesignSystem.Font.largeTitle.bold()
                        )
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .padding(
                            .horizontal,
                            DesignSystem.Spaces.two
                        )

                    // MARK: Descriptions

                    VStack(
                        spacing: DesignSystem.Spaces.two
                    ) {
                        Text(primaryDescription)
                            .font(DesignSystem.Font.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        if let secondaryDescription {
                            Text(secondaryDescription)
                                .font(DesignSystem.Font.body)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        // Existing custom content

                        if let content {
                            content()
                        }
                    }
                    .padding(
                        .horizontal,
                        DesignSystem.Spaces.two
                    )

                    Spacer(
                        minLength: DesignSystem.Spaces.four
                    )

                    // Keyboard scrolling anchor

                    Text("")
                        .frame(height: 100)
                        .id(bottomAnchor)
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .top
                )
                .frame(maxWidth: maxContentWidth)
                .onChange(of: isKeyboardVisible) { newValue in
                    if newValue {
                        proxy.scrollTo(bottomAnchor)
                    }
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )

        // MARK: Bottom Actions

        .safeAreaInset(edge: .bottom) {
            bottomActions
        }

        // MARK: SisteMatich Pastel Background

        .background {
            sistematichBackground
                .ignoresSafeArea()
        }

        // MARK: Keyboard Monitoring

        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            isKeyboardVisible = newIsKeyboardVisible
        }
    }

    // MARK: - Bottom Buttons

    @ViewBuilder
    private var bottomActions: some View {
        VStack(
            spacing: DesignSystem.Spaces.one
        ) {

            // Primary button

            Button(action: primaryAction) {
                Text(primaryActionTitle)
            }
            .buttonStyle(.primaryButton)
            .disabled(disablePrimaryAction)
            .accessibilityIdentifier(
                primaryActionIdentifier ?? ""
            )

            // Secondary button

            if let secondaryActionTitle,
               let secondaryAction {

                Button(action: secondaryAction) {
                    Text(secondaryActionTitle)
                }
                .buttonStyle(.secondaryButton)
                .tint(Color.haPrimary)
                .accessibilityIdentifier(
                    secondaryActionIdentifier ?? ""
                )
            }
        }
        .padding(
            .bottom,
            Current.isCatalyst
                ? DesignSystem.Spaces.two
                : DesignSystem.Spaces.one
        )
        .frame(
            maxWidth: Sizes.maxWidthForLargerScreens
        )
        .padding(
            [.horizontal, .top],
            DesignSystem.Spaces.two
        )
        .background(Color.clear)
    }
}

// MARK: - Previews

#Preview("SisteMatich - Location") {
    NavigationView {
        BaseOnboardingView(
            illustration: {
                Image(.Onboarding.world)
            },
            title: "Use this device's location for automations",
            primaryDescription: "Location sharing enables powerful automations, such as turning off the heating when you leave home. This option shares the device's location only with your Home Assistant system.",
            secondaryDescription: "This data stays in your home and is never sent to third parties. It also helps strengthen the security of your connection to Home Assistant.",
            primaryActionTitle: "Share my location",
            primaryAction: {},
            secondaryActionTitle: "Do not share my location",
            secondaryAction: {}
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("SisteMatich - Custom Content") {
    NavigationView {
        BaseOnboardingView(
            illustration: {
                Image(.Onboarding.world)
            },
            title: "Use this device's location for automations",
            primaryDescription: "Location sharing enables powerful automations.",
            secondaryDescription: "This data stays in your home and is never sent to third parties.",
            content: {
                VStack(
                    spacing: DesignSystem.Spaces.one
                ) {
                    Toggle(isOn: .constant(true)) {
                        Text("Also share precise location")
                    }
                    .toggleStyle(.switch)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )

                    Text("You can change this later in Settings.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                }
                .frame(
                    maxWidth: DesignSystem.List.rowMaxWidth
                )
            },
            primaryActionTitle: "Share my location",
            primaryAction: {},
            secondaryActionTitle: "Do not share my location",
            secondaryAction: {}
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}
