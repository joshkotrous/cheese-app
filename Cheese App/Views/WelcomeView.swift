import SwiftUI

struct WelcomeView: View {
    @State private var opacity: Double = 1.0

    var body: some View {
        ZStack {
            // Background color
            CustomColors.background
                .edgesIgnoringSafeArea(.all) // Extend the color to the edges of the screen
            Image("cheeses")
                .resizable()
                .aspectRatio(contentMode: .fill) // Adjust the aspect ratio
                .clipped() // Ensure the image fits within the frame

            // Foreground content
            VStack {
                Text("Cheese \n App")
                    .font(.custom("IowanOldStyle-Roman", size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(CustomColors.textColor)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .opacity(opacity)
        .onAppear {
            // Delay the animation by 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    opacity = 0.0
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
