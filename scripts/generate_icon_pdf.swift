// Generate a PDF menu bar icon — PDF template images work better
// with macOS system-level rendering (Globe key overlay, etc.)
import Cocoa

let size = NSSize(width: 16, height: 16)
let pdfData = NSMutableData()

guard let consumer = CGDataConsumer(data: pdfData as CFMutableData) else {
    fatalError("Failed to create data consumer")
}

var mediaBox = CGRect(origin: .zero, size: CGSize(width: 16, height: 16))
guard let context = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else {
    fatalError("Failed to create PDF context")
}

context.beginPDFPage(nil)

// Draw Bengali "অ" in black on transparent background
let font = NSFont.systemFont(ofSize: 13, weight: .medium)
let attrs: [NSAttributedString.Key: Any] = [
    .font: font,
    .foregroundColor: NSColor.black
]
let str = "অ" as NSString
let strSize = str.size(withAttributes: attrs)
let point = NSPoint(
    x: (16 - strSize.width) / 2,
    y: (16 - strSize.height) / 2
)

NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: false)
str.draw(at: point, withAttributes: attrs)
NSGraphicsContext.restoreGraphicsState()

context.endPDFPage()
context.closePDF()

let outputPath = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "iconTemplate.pdf"
pdfData.write(toFile: outputPath, atomically: true)
print("PDF icon written to \(outputPath)")
