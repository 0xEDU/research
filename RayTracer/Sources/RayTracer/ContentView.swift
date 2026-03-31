import SwiftUI

struct ContentView: View {
    @State private var renderedImage: NSImage? = nil

    private let imageWidth  = 800
    private let imageHeight = 600

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let img = renderedImage {
                Image(nsImage: img)
                    .resizable()
                    .interpolation(.none)
                    .aspectRatio(contentMode: .fit)
            } else {
                VStack(spacing: 16) {
                    ProgressView()
                        .controlSize(.large)
                        .colorScheme(.dark)
                    Text("Rendering…")
                        .foregroundStyle(.white)
                        .font(.headline)
                }
            }
        }
        .frame(width: CGFloat(imageWidth), height: CGFloat(imageHeight))
        .task {
            await renderAsync()
        }
    }

    private func renderAsync() async {
        let tracer = RayTracer(width: imageWidth, height: imageHeight)
        let img = await Task.detached(priority: .userInitiated) {
            tracer.render()
        }.value
        renderedImage = img
    }
}

#Preview {
    ContentView()
}
