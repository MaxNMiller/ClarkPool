import UIKit

class RidesViewController: UIViewController {


 
    @IBOutlet weak var coursesScrollView: UIScrollView!
    
 
    @IBOutlet weak var coursesStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCourses()
    }

    func setupCourses() {
        let courseData = [
            Course(title: "Build an app with SwiftUI", image: "Illustration1", color: .systemBlue, shadowColor: .systemGray),
            Course(title: "Design and animate your UI", image: "Illustration2", color: .systemGreen, shadowColor: .systemGray),
            Course(title: "Swift UI Advanced", image: "Illustration3", color: .systemOrange, shadowColor: .systemGray),
            Course(title: "Framer Playground", image: "Illustration4", color: .systemPurple, shadowColor: .systemGray),
            Course(title: "Flutter for Designers", image: "Illustration5", color: .systemRed, shadowColor: .systemGray)
        ]

        for course in courseData {
            let courseView = CourseView()
            courseView.configure(with: course)
            coursesStackView.addArrangedSubview(courseView)
        }
    }
}

class CourseView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var courseImageView: UIImageView!

    func configure(with course: Course) {
        titleLabel.text = course.title
        courseImageView.image = UIImage(named: course.image)
        backgroundColor = course.color
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        layer.shadowColor = course.shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.5
    }
}

struct Course {
    var title: String
    var image: String
    var color: UIColor
    var shadowColor: UIColor
}
