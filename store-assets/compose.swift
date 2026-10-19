import AppKit

let root = URL(fileURLWithPath: CommandLine.arguments[1])
let background = NSColor(calibratedRed: 0.97, green: 0.95, blue: 0.91, alpha: 1)
let ink = NSColor(calibratedRed: 0.16, green: 0.18, blue: 0.17, alpha: 1)
let accent = NSColor(calibratedRed: 0.72, green: 0.28, blue: 0.24, alpha: 1)

func text(_ value: String, _ rect: CGRect, size: CGFloat, color: NSColor = ink, bold: Bool = false) {
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    (value as NSString).draw(in: rect, withAttributes: [
        .font: bold ? NSFont.systemFont(ofSize: size, weight: .bold) : NSFont.systemFont(ofSize: size),
        .foregroundColor: color, .paragraphStyle: style
    ])
}

func image(_ url: URL, in rect: CGRect) {
    guard let source = NSImage(contentsOf: url) else { fatalError("Missing capture: \(url)") }
    source.draw(in: rect, from: .zero, operation: .sourceOver, fraction: 1, respectFlipped: true, hints: [.interpolation: NSImageInterpolation.high])
}

// Original front-facing device mockup, inspired by the reference's rounded
// hardware silhouette. No Screenhance template or Apple bezel is reproduced.
func device(_ capture: URL, in available: CGRect, tablet: Bool = false) {
    let source = NSImage(contentsOf: capture)!
    let edge: CGFloat = tablet ? 0.033 : 0.026
    let scale = min(available.width / (source.size.width * (1 + edge * 2)),
                    available.height / (source.size.height + source.size.width * edge * 2))
    let sw = source.size.width * scale, sh = source.size.height * scale
    let bezel = sw * edge
    let screen = CGRect(x: available.midX - sw / 2, y: available.midY - sh / 2, width: sw, height: sh)
    let shell = screen.insetBy(dx: -bezel, dy: -bezel)
    let radius = sw * (tablet ? 0.047 : 0.145)
    let body = NSBezierPath(roundedRect: shell, xRadius: radius, yRadius: radius)

    NSGraphicsContext.saveGraphicsState()
    let shadow = NSShadow()
    shadow.shadowColor = .black.withAlphaComponent(0.20)
    shadow.shadowBlurRadius = sw * 0.055
    shadow.shadowOffset = CGSize(width: sw * 0.006, height: sw * 0.018)
    shadow.set()
    NSColor.black.setFill()
    body.fill()
    NSGraphicsContext.restoreGraphicsState()

    let steel = NSGradient(colors: [
        NSColor(calibratedWhite: 0.32, alpha: 1),
        NSColor(calibratedWhite: 0.80, alpha: 1),
        NSColor(calibratedWhite: 0.49, alpha: 1),
        NSColor(calibratedWhite: 0.88, alpha: 1),
        NSColor(calibratedWhite: 0.27, alpha: 1)
    ])!
    steel.draw(in: body, angle: 0)
    NSColor(calibratedWhite: 0.14, alpha: 1).setStroke()
    body.lineWidth = sw * 0.002
    body.stroke()

    let gasket = shell.insetBy(dx: sw * 0.008, dy: sw * 0.008)
    NSColor(calibratedWhite: 0.035, alpha: 1).setFill()
    NSBezierPath(roundedRect: gasket, xRadius: radius - sw * 0.008, yRadius: radius - sw * 0.008).fill()

    // Physical buttons protrude from the chassis, rather than the screenshot.
    let buttonWidth = sw * 0.009
    let buttonRects: [CGRect] = tablet ? [
        CGRect(x: shell.maxX - 1, y: shell.minY + shell.height * 0.12, width: buttonWidth, height: sh * 0.052)
    ] : [
        CGRect(x: shell.minX - buttonWidth + 1, y: shell.minY + sh * 0.155, width: buttonWidth, height: sh * 0.031),
        CGRect(x: shell.minX - buttonWidth + 1, y: shell.minY + sh * 0.215, width: buttonWidth, height: sh * 0.061),
        CGRect(x: shell.minX - buttonWidth + 1, y: shell.minY + sh * 0.29, width: buttonWidth, height: sh * 0.061),
        CGRect(x: shell.maxX - 1, y: shell.minY + sh * 0.235, width: buttonWidth, height: sh * 0.094)
    ]
    for rect in buttonRects {
        steel.draw(in: NSBezierPath(roundedRect: rect, xRadius: buttonWidth * 0.35, yRadius: buttonWidth * 0.35), angle: 0)
    }

    NSGraphicsContext.saveGraphicsState()
    let screenRadius = sw * (tablet ? 0.025 : 0.117)
    NSBezierPath(roundedRect: screen, xRadius: screenRadius, yRadius: screenRadius).addClip()
    image(capture, in: screen)
    NSGraphicsContext.restoreGraphicsState()

    if tablet {
        let lens = CGRect(x: shell.midX - bezel * 0.13, y: shell.minY + bezel * 0.42,
                          width: bezel * 0.26, height: bezel * 0.26)
        NSColor(calibratedWhite: 0.005, alpha: 1).setFill()
        NSBezierPath(ovalIn: lens).fill()
        NSColor(calibratedRed: 0.16, green: 0.22, blue: 0.29, alpha: 1).setFill()
        NSBezierPath(ovalIn: lens.insetBy(dx: lens.width * 0.25, dy: lens.height * 0.25)).fill()
    } else {
        let speaker = CGRect(x: shell.midX - sw * 0.065, y: shell.minY + bezel * 0.30, width: sw * 0.13, height: sw * 0.0025)
        NSColor(calibratedWhite: 0.29, alpha: 1).setFill()
        NSBezierPath(roundedRect: speaker, xRadius: speaker.height / 2, yRadius: speaker.height / 2).fill()
    }
}

func render(width: Int, height: Int, destination: URL, draw: (CGFloat, CGFloat) -> Void) {
    let graphics = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8,
        bytesPerRow: width * 4, space: CGColorSpace(name: CGColorSpace.sRGB)!,
        bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
    let context = NSGraphicsContext(cgContext: graphics, flipped: false)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context
    context.cgContext.translateBy(x: 0, y: CGFloat(height))
    context.cgContext.scaleBy(x: 1, y: -1)
    NSGraphicsContext.current = NSGraphicsContext(cgContext: context.cgContext, flipped: true)
    background.setFill()
    CGRect(x: 0, y: 0, width: width, height: height).fill()
    draw(CGFloat(width), CGFloat(height))
    NSGraphicsContext.restoreGraphicsState()
    try! FileManager.default.createDirectory(at: destination.deletingLastPathComponent(), withIntermediateDirectories: true)
    let bitmap = NSBitmapImageRep(cgImage: graphics.makeImage()!)
    try! bitmap.representation(using: .png, properties: [:])!.write(to: destination)
}

// Simulator PNGs can contain an alpha channel even when every pixel is opaque.
// Flatten at the original pixel dimensions for Apple's upload requirements.
for folder in ["raw/iphone-large", "raw/ipad-13", "screenshots/watch-ultra"] {
    let directory = root.appendingPathComponent(folder)
    for url in (try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)) ?? [] {
        guard url.pathExtension == "png", let bitmap = NSBitmapImageRep(data: try! Data(contentsOf: url)) else { continue }
        render(width: bitmap.pixelsWide, height: bitmap.pixelsHigh, destination: url) { w, h in
            image(url, in: CGRect(x: 0, y: 0, width: w, height: h))
        }
    }
}

let screens = [
    ("01-map", "You care where they are", "See your circle on one map."),
    ("02-detail", "A little less wondering", "Check their location, device and battery."),
    ("03-places", "Know when they arrive", "Set places for the moments that matter."),
    ("04-circles", "Your people. Your circles.", "Share with the people you choose."),
    ("05-settings", "Sharing on your terms", "Manage your profile and sharing settings.")
]
// One accepted portrait size per supported display family. The UI capture is
// aspect-fitted, never stretched or cropped; only the marketing canvas changes.
let sizes: [(String, Int, Int, String)] = [
    ("iphone-duo-outer", 1398, 2034, "iphone-large"),
    ("iphone-duo-inner", 2007, 2853, "ipad-13"),
    ("iphone-dynamic-island-large", 1320, 2868, "iphone-large"),
    ("iphone-face-id-large", 1284, 2778, "iphone-large"),
    ("iphone-dynamic-island-medium", 1206, 2622, "iphone-large"),
    ("iphone-face-id-medium", 1170, 2532, "iphone-large"),
    ("iphone-home-button-large", 1242, 2208, "iphone-large"),
    ("iphone-home-button-medium", 750, 1334, "iphone-large"),
    ("ipad-13", 2064, 2752, "ipad-13"),
    ("ipad-12.9", 2048, 2732, "ipad-13"),
    ("ipad-11", 1668, 2420, "ipad-13"),
    ("ipad-10.5", 1668, 2224, "ipad-13"),
    ("ipad-9.7", 1536, 2048, "ipad-13")
]

for (folder, width, height, source) in sizes {
    for (filename, title, caption) in screens {
        let input = root.appendingPathComponent("raw/\(source)/\(filename).png")
        render(width: width, height: height, destination: root.appendingPathComponent("screenshots/\(folder)/\(filename).png")) { w, h in
            text("KINAROUND", CGRect(x: w * 0.06, y: h * 0.035, width: w * 0.88, height: h * 0.04), size: w * 0.027, color: accent, bold: true)
            text(title, CGRect(x: w * 0.06, y: h * 0.079, width: w * 0.88, height: h * 0.087), size: w * 0.064, bold: true)
            text(caption, CGRect(x: w * 0.06, y: h * 0.169, width: w * 0.88, height: h * 0.04), size: w * 0.028)
            let available = CGRect(x: w * 0.07, y: h * 0.235, width: w * 0.86, height: h * 0.725)
            device(input, in: available, tablet: source == "ipad-13")
        }
    }
}

for (w, h) in [(5244, 2950), (3840, 1646)] {
    render(width: w, height: h, destination: root.appendingPathComponent("headers/header-\(w)x\(h).png")) { width, height in
        text("KinAround", CGRect(x: width * 0.035, y: height * 0.25, width: width * 0.46, height: height * 0.16), size: height * 0.10, color: accent, bold: true)
        text("You care\nwhere they are", CGRect(x: width * 0.035, y: height * 0.42, width: width * 0.46, height: height * 0.32), size: height * 0.09, bold: true)
        let source = root.appendingPathComponent("raw/iphone-large/01-map.png")
        device(source, in: CGRect(x: width * 0.51, y: height * 0.045, width: width * 0.40, height: height * 0.91))
    }
}

render(width: 1800, height: 1080, destination: root.appendingPathComponent("preview.png")) { w, h in
    for (index, screen) in screens.enumerated() {
        let source = root.appendingPathComponent("screenshots/iphone-dynamic-island-large/\(screen.0).png")
        image(source, in: CGRect(x: 20 + CGFloat(index) * 356, y: 130, width: 336, height: 730))
    }
    text("KinAround · App Store screenshots", CGRect(x: 0, y: 35, width: w, height: 55), size: 40, bold: true)
    text("Real app views · Fictional sample data", CGRect(x: 0, y: 920, width: w, height: 50), size: 26, color: accent)
}
render(width: 1800, height: 1200, destination: root.appendingPathComponent("duo-preview.png")) { w, h in
    text("KinAround · iPhone Duo size exports", CGRect(x: 0, y: 25, width: w, height: 55), size: 38, bold: true)
    for (index, entry) in [("iphone-duo-outer", "Outer · 1398 × 2034"), ("iphone-duo-inner", "Inner · 2007 × 2853")].enumerated() {
        let input = root.appendingPathComponent("screenshots/\(entry.0)/01-map.png")
        let source = NSImage(contentsOf: input)!
        let scale = min(760 / source.size.width, 950 / source.size.height)
        let sw = source.size.width * scale, sh = source.size.height * scale
        let center = CGFloat(index) * 900 + 450
        text(entry.1, CGRect(x: center - 400, y: 95, width: 800, height: 45), size: 26, color: accent)
        image(input, in: CGRect(x: center - sw / 2, y: 160, width: sw, height: sh))
    }
}
print("Exported 65 screenshots, 2 headers and previews.")
