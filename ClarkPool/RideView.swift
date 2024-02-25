
import SwiftUI
import UIKit

struct HomeList: View {
    

   var courses = coursesData
   @State var showContent = false

    var body: some View {
        
       ScrollView {
          VStack {
             
             // Profile picture and circle background
             HStack {
                 Image("Face2")
                     .resizable()
                     .aspectRatio(contentMode: .fill)
                     .frame(width: 75, height: 75)
                     .clipShape(Circle())
                     .shadow(color: .init(red:0.02, green:0.44, blue:0.00), radius: 10, x: 0, y: 10)
                     .overlay(Circle().stroke(Color.init(red: 0.38, green: 0.85, blue: 0.22), lineWidth: 4))
                    
                 
                 Spacer()
             }
             .padding(.horizontal, 20)
             
             HStack {
                VStack(alignment: .leading) {
                   Text("My Trips")
                      .font(.largeTitle)
                      .fontWeight(.heavy)

                   Text("5 Carpools planned")
                      .foregroundColor(.gray)
                }
                Spacer()
             }
             .padding(.leading, 60.0)
              
             ScrollView(.horizontal, showsIndicators: false) {
                 HStack(spacing: 20) {
                     ForEach(courses) { course in
                         GeometryReader { geometry in
                             CourseView(title: course.title, image: course.image, color: course.color, shadowColor: course.shadowColor)
                                 .padding(.vertical)
                                 .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 30) / -20), axis: (x: 0, y: 50.0, z: 0))
                         }
                         .frame(width: 275, height: 460)
                     }
                 }
                 .padding(.horizontal, 30)
                 .padding(.leading, 30)
             }
             
             // New image added at the bottom right corner
             Image("clarkpoollogo1")
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .frame(width: 200, height: 100) // Adjust the size as needed
                 .padding(.leading, 200) // Adjust the padding as needed
                 .padding(.bottom, 50) // Adjust the padding as needed
         }
           
         .padding(.top, 78)
       }
    }
 }


#if DEBUG
struct HomeList_Previews: PreviewProvider {
   static var previews: some View {
      HomeList()
   }
}
#endif

struct CourseView: View {

    var title: String
    var image: String
    var color: Color
    var shadowColor: Color

    var body: some View {
 
        VStack(alignment: .leading, spacing: 0) {
           
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.top, 20)
                .lineLimit(3)

            Spacer()

            Image(image)
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .overlay(
                    LinearGradient(gradient: Gradient(colors: [Color.yellow.opacity(0.1), Color.green.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                )
                .clipShape(RoundedRectangle(cornerRadius: 50, style: .continuous))
                .shadow(radius: 20)
                .padding(.horizontal, 30)
                .padding(.vertical, 50)
        }
        .background(Gradient(colors: [.init(red: 0.38, green: 0.85, blue: 0.22),.init(red:0.02, green:0.44, blue:0.00),]))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: .init(red:0.02, green:0.44, blue:0.00), radius: 15, x: 0, y: 15)
        .padding(.bottom, 60)
    }
}


struct Course: Identifiable {
   var id = UUID()
   var title: String
   var image: String
   var color: Color
   var shadowColor: Color
}

let coursesData = [
   Course(title: "Shopping Trip!",
          image: "CVS",
          color: Color("background3"),
          shadowColor: Color("backgroundShadow3")),
   Course(title: "Weekly Walmart",
          image: "walmart",
          color: Color("background4"),
          shadowColor: Color("backgroundShadow4")),
   Course(title: "Rock Concert",
          image: "Rock",
          color: Color("background7"),
          shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
   Course(title: "Day in Boston",
          image: "Boston",
          color: Color("background8"),
          shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
   Course(title: "PAX East",
          image: "Pax",
          color: Color("background9"),
          shadowColor: Color(hue: 0.677, saturation: 0.701, brightness: 0.788, opacity: 0.5)),
]
