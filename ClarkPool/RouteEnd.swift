import SwiftUI

struct ResultsView: View {
    @State private var resultNumber: Double = 0
    let targetNumber: Double = 3
    let animationDuration: Double = 2.0

    var body: some View {
        ZStack {
            Color.green.opacity(0.1)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("You Saved")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 50)
                    .foregroundColor(.green)

                Text("\(Int(resultNumber))")
                    .font(.system(size: 100))
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .onAppear() {
                        withAnimation(.linear(duration: self.animationDuration)) {
                            self.resultNumber = self.targetNumber
                        }
                    }

                Spacer()

                Button(action: {
                    // Action to perform when button is pressed
                }) {
                    Text("Continue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
