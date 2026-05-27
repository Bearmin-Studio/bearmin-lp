import AppKit
import Foundation

let canvas = CGSize(width: 1200, height: 630)
let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let logoURL = root.appendingPathComponent("assets/images/logo.png")
let heroURL = root.appendingPathComponent("assets/images/hero_black_gold.png")
let outputURL = root.appendingPathComponent("assets/images/ogp.png")

guard let logo = NSImage(contentsOf: logoURL), let hero = NSImage(contentsOf: heroURL) else {
  fputs("Missing logo or hero image\n", stderr)
  exit(1)
}

let rep = NSBitmapImageRep(
  bitmapDataPlanes: nil,
  pixelsWide: Int(canvas.width),
  pixelsHigh: Int(canvas.height),
  bitsPerSample: 8,
  samplesPerPixel: 4,
  hasAlpha: true,
  isPlanar: false,
  colorSpaceName: .deviceRGB,
  bitmapFormat: [.alphaFirst],
  bytesPerRow: 0,
  bitsPerPixel: 0
)!

NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
let ctx = NSGraphicsContext.current!.cgContext

func color(_ hex: UInt32, _ alpha: CGFloat = 1) -> NSColor {
  let r = CGFloat((hex >> 16) & 0xff) / 255
  let g = CGFloat((hex >> 8) & 0xff) / 255
  let b = CGFloat(hex & 0xff) / 255
  return NSColor(calibratedRed: r, green: g, blue: b, alpha: alpha)
}

func fillRounded(_ rect: CGRect, radius: CGFloat, color: NSColor) {
  color.setFill()
  NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()
}

func strokeRounded(_ rect: CGRect, radius: CGFloat, color: NSColor, width: CGFloat) {
  color.setStroke()
  let path = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
  path.lineWidth = width
  path.stroke()
}

func drawText(_ text: String, in rect: CGRect, font: NSFont, color: NSColor, lineHeight: CGFloat? = nil, weight: NSFont.Weight? = nil) {
  let paragraph = NSMutableParagraphStyle()
  paragraph.lineBreakMode = .byWordWrapping
  if let lineHeight {
    paragraph.minimumLineHeight = lineHeight
    paragraph.maximumLineHeight = lineHeight
  }
  let descriptor = font.fontDescriptor.addingAttributes([
    .traits: [NSFontDescriptor.TraitKey.weight: weight ?? .regular]
  ])
  let weightedFont = NSFont(descriptor: descriptor, size: font.pointSize) ?? font
  let attributes: [NSAttributedString.Key: Any] = [
    .font: weightedFont,
    .foregroundColor: color,
    .paragraphStyle: paragraph
  ]
  (text as NSString).draw(in: rect, withAttributes: attributes)
}

func drawCircle(_ center: CGPoint, radius: CGFloat, fill: NSColor, stroke: NSColor? = nil) {
  let rect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
  let path = NSBezierPath(ovalIn: rect)
  fill.setFill()
  path.fill()
  if let stroke {
    stroke.setStroke()
    path.lineWidth = 2
    path.stroke()
  }
}

// Background
let gradient = NSGradient(colors: [color(0xffffff), color(0xf7f9fb), color(0xf7f1ea)])!
gradient.draw(in: CGRect(origin: .zero, size: canvas), angle: 0)

fillRounded(CGRect(x: 34, y: 34, width: 1132, height: 562), radius: 34, color: color(0xffffff, 0.72))
strokeRounded(CGRect(x: 34, y: 34, width: 1132, height: 562), radius: 34, color: color(0xd4a574, 0.24), width: 1.5)

// Decorative gold rhythm.
for i in 0..<15 {
  let x = CGFloat(860 + i * 18)
  drawCircle(CGPoint(x: x, y: 88), radius: 2.6, fill: color(0xd4a574, 0.34))
}
for row in 0..<5 {
  for col in 0..<7 {
    drawCircle(CGPoint(x: CGFloat(1030 + col * 18), y: CGFloat(470 + row * 18)), radius: 2.4, fill: color(0xd4a574, 0.32))
  }
}

ctx.setLineWidth(1.4)
ctx.setStrokeColor(color(0xd4a574, 0.34).cgColor)
ctx.move(to: CGPoint(x: 52, y: 438))
ctx.addCurve(to: CGPoint(x: 250, y: 362), control1: CGPoint(x: 110, y: 520), control2: CGPoint(x: 186, y: 310))
ctx.addCurve(to: CGPoint(x: 514, y: 398), control1: CGPoint(x: 342, y: 438), control2: CGPoint(x: 396, y: 330))
ctx.addCurve(to: CGPoint(x: 728, y: 312), control1: CGPoint(x: 602, y: 462), control2: CGPoint(x: 650, y: 298))
ctx.strokePath()

// Hero image panel.
let heroPanel = CGRect(x: 710, y: 88, width: 410, height: 454)
ctx.saveGState()
NSBezierPath(roundedRect: heroPanel, xRadius: 28, yRadius: 28).addClip()
let srcSize = hero.size
let srcAspect = srcSize.width / srcSize.height
let dstAspect = heroPanel.width / heroPanel.height
var source = CGRect(origin: .zero, size: srcSize)
if srcAspect > dstAspect {
  let newWidth = srcSize.height * dstAspect
  source.origin.x = (srcSize.width - newWidth) / 2
  source.size.width = newWidth
} else {
  let newHeight = srcSize.width / dstAspect
  source.origin.y = (srcSize.height - newHeight) / 2
  source.size.height = newHeight
}
hero.draw(in: heroPanel, from: source, operation: .sourceOver, fraction: 1)
ctx.restoreGState()
strokeRounded(heroPanel, radius: 28, color: color(0xd4a574, 0.28), width: 1.4)

// Floating dashboard chips over image.
fillRounded(CGRect(x: 640, y: 130, width: 232, height: 92), radius: 18, color: color(0xffffff, 0.9))
strokeRounded(CGRect(x: 640, y: 130, width: 232, height: 92), radius: 18, color: color(0xd4a574, 0.22), width: 1)
ctx.setLineWidth(5)
ctx.setStrokeColor(color(0xd4a574).cgColor)
ctx.move(to: CGPoint(x: 670, y: 186))
ctx.addCurve(to: CGPoint(x: 844, y: 154), control1: CGPoint(x: 718, y: 140), control2: CGPoint(x: 770, y: 202))
ctx.strokePath()

fillRounded(CGRect(x: 966, y: 382, width: 172, height: 116), radius: 18, color: color(0xffffff, 0.9))
strokeRounded(CGRect(x: 966, y: 382, width: 172, height: 116), radius: 18, color: color(0xd4a574, 0.22), width: 1)
for i in 0..<4 {
  let h = CGFloat([28, 46, 62, 82][i])
  fillRounded(CGRect(x: CGFloat(996 + i * 30), y: 474 - h, width: 15, height: h), radius: 5, color: i == 3 ? color(0x1a1a1a) : color(0xd4a574, 0.82))
}

// Logo and copy.
let logoRect = CGRect(x: 92, y: 94, width: 228, height: 60)
logo.draw(in: logoRect, from: .zero, operation: .sourceOver, fraction: 1)

fillRounded(CGRect(x: 92, y: 178, width: 238, height: 40), radius: 20, color: color(0xf3eee8))
drawText("月額制で継続改善", in: CGRect(x: 114, y: 187, width: 194, height: 24), font: NSFont.systemFont(ofSize: 18), color: color(0x1a1a1a), weight: .bold)

drawText(
  "時間と余裕を\n提供します。",
  in: CGRect(x: 88, y: 242, width: 542, height: 160),
  font: NSFont.systemFont(ofSize: 62),
  color: color(0x1a1a1a),
  lineHeight: 74,
  weight: .heavy
)

drawText(
  "Excel自動化・業務システム構築・RPA導入をまとめて支援する、業務効率化システム構築の月額制サービス。",
  in: CGRect(x: 94, y: 420, width: 548, height: 82),
  font: NSFont.systemFont(ofSize: 24),
  color: color(0x343434),
  lineHeight: 34,
  weight: .medium
)

let chips = ["Excel自動化", "システム構築", "RPA導入"]
var chipX: CGFloat = 92
for chip in chips {
  let width = CGFloat(chip.count * 18 + 42)
  fillRounded(CGRect(x: chipX, y: 526, width: width, height: 38), radius: 19, color: color(0x1a1a1a))
  drawText(chip, in: CGRect(x: chipX + 20, y: 534, width: width - 40, height: 22), font: NSFont.systemFont(ofSize: 16), color: color(0xffffff), weight: .bold)
  chipX += width + 12
}

NSGraphicsContext.restoreGraphicsState()

guard let png = rep.representation(using: .png, properties: [:]) else {
  fputs("Failed to encode PNG\n", stderr)
  exit(1)
}
try png.write(to: outputURL)
print(outputURL.path)
