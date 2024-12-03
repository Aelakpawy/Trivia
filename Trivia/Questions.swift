import Foundation

struct Question: Hashable {
    let text: String
    let answers: [String]
    let correctAnswer: Int
    let category: QuizCategory  // Added category property
    
    // Implementing Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(answers)
        hasher.combine(correctAnswer)
        hasher.combine(category)
    }
    
    // Implementing Equatable (required by Hashable)
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.text == rhs.text &&
               lhs.answers == rhs.answers &&
               lhs.correctAnswer == rhs.correctAnswer &&
               lhs.category == rhs.category
    }
}

struct QuestionBank {
    static let allQuestions = [
        // Geography Questions
        Question(
            text: "What is the capital of Japan?",
            answers: ["Beijing", "Seoul", "Tokyo", "Bangkok"],
            correctAnswer: 2,
            category: .geography
        ),
        Question(
            text: "Which ocean borders California?",
            answers: ["Atlantic", "Indian", "Pacific", "Arctic"],
            correctAnswer: 2,
            category: .geography
        ),
        Question(
            text: "What is the capital of Australia?",
            answers: ["Sydney", "Melbourne", "Canberra", "Brisbane"],
            correctAnswer: 2,
            category: .geography
        ),
        Question(
            text: "Which language is primarily spoken in Brazil?",
            answers: ["Spanish", "Portuguese", "English", "French"],
            correctAnswer: 1,
            category: .geography
        ),
        Question(
            text: "What is the currency of the United Kingdom?",
            answers: ["Euro", "Dollar", "Pound", "Franc"],
            correctAnswer: 2,
            category: .geography
        ),
        Question(
            text: "What is the main language spoken in Canada?",
            answers: ["English", "French", "Spanish", "German"],
            correctAnswer: 0,
            category: .geography
        ),
        Question(
            text: "Which country is famous for the Great Wall?",
            answers: ["India", "China", "Japan", "South Korea"],
            correctAnswer: 1,
            category: .geography
        ),
        Question(
            text: "What is the largest continent by land area?",
            answers: ["Africa", "Asia", "Europe", "Australia"],
            correctAnswer: 1,
            category: .geography
        ),
        Question(
            text: "What country is home to the kangaroo?",
            answers: ["South Africa", "India", "Australia", "New Zealand"],
            correctAnswer: 2,
            category: .geography
        ),
        Question(
            text: "What is the currency used in Japan?",
            answers: ["Dollar", "Yuan", "Won", "Yen"],
            correctAnswer: 3,
            category: .geography
        ),
        Question(
            text: "What is the largest island in the world?",
            answers: ["Australia", "Greenland", "New Guinea", "Borneo"],
            correctAnswer: 1,
            category: .geography
        ),
        Question(
            text: "What is the tallest building in the world?",
            answers: ["Shanghai Tower", "Burj Khalifa", "One World Trade Center", "Eiffel Tower"],
            correctAnswer: 1,
            category: .geography
        ),
        
        // Science Questions
        Question(
            text: "Which planet is closest to the Sun?",
            answers: ["Earth", "Venus", "Mercury", "Mars"],
            correctAnswer: 2,
            category: .science
        ),
        Question(
            text: "What is the largest organ in the human body?",
            answers: ["Heart", "Liver", "Brain", "Skin"],
            correctAnswer: 3,
            category: .science
        ),
        Question(
            text: "How many bones are in the adult human body?",
            answers: ["206", "205", "208", "210"],
            correctAnswer: 0,
            category: .science
        ),
        Question(
            text: "What is the chemical symbol for water?",
            answers: ["H2O", "O2", "CO2", "HO"],
            correctAnswer: 0,
            category: .science
        ),
        Question(
            text: "What is the hardest rock?",
            answers: ["Granite", "Marble", "Quartz", "Diamond"],
            correctAnswer: 3,
            category: .science
        ),
        Question(
            text: "What is the smallest planet in our solar system?",
            answers: ["Mars", "Mercury", "Venus", "Pluto"],
            correctAnswer: 1,
            category: .science
        ),
        Question(
            text: "How many days are in a leap year?",
            answers: ["364", "365", "366", "367"],
            correctAnswer: 2,
            category: .science
        ),
        Question(
            text: "What is the freezing point of water in Fahrenheit?",
            answers: ["0°F", "32°F", "100°F", "212°F"],
            correctAnswer: 1,
            category: .science
        ),
        Question(
            text: "Who discovered penicillin?",
            answers: ["Marie Curie", "Isaac Newton", "Albert Einstein", "Alexander Fleming"],
            correctAnswer: 3,
            category: .science
        ),
        Question(
            text: "What is the speed of light?",
            answers: ["299,792 km/s", "150,000 km/s", "300,000 km/s", "350,000 km/s"],
            correctAnswer: 0,
            category: .science
        ),
        Question(
            text: "What is the most abundant gas in Earth's atmosphere?",
            answers: ["Oxygen", "Carbon Dioxide", "Nitrogen", "Hydrogen"],
            correctAnswer: 2,
            category: .science
        ),
        Question(
            text: "Which mammal is known to have the most powerful bite?",
            answers: ["Lion", "Crocodile", "Jaguar", "Hippopotamus"],
            correctAnswer: 3,
            category: .science
        ),
        Question(
            text: "What is the main ingredient in chocolate?",
            answers: ["Cocoa", "Vanilla", "Cinnamon", "Sugar"],
            correctAnswer: 0,
            category: .science
        ),
        Question(
            text: "What color are emeralds?",
            answers: ["Blue", "Green", "Red", "Yellow"],
            correctAnswer: 1,
            category: .science
        ),
        Question(
            text: "What is the chemical symbol for potassium?",
            answers: ["P", "Po", "K", "Pt"],
            correctAnswer: 2,
            category: .science
        ),
        Question(
            text: "How many planets are in our solar system?",
            answers: ["7", "8", "9", "10"],
            correctAnswer: 1,
            category: .science
        ),
        Question(
            text: "What is the main ingredient in sushi?",
            answers: ["Rice", "Bread", "Noodles", "Tortilla"],
            correctAnswer: 0,
            category: .science
        ),
        
        // History Questions
        Question(
            text: "What year did the Titanic sink?",
            answers: ["1910", "1912", "1914", "1916"],
            correctAnswer: 1,
            category: .history
        ),
        Question(
            text: "Who was the first President of the United States?",
            answers: ["Thomas Jefferson", "George Washington", "Abraham Lincoln", "John Adams"],
            correctAnswer: 1,
            category: .history
        ),
        Question(
            text: "What year did man first land on the moon?",
            answers: ["1965", "1969", "1970", "1972"],
            correctAnswer: 1,
            category: .history
        ),
        Question(
            text: "Who was the 16th president of the United States?",
            answers: ["George Washington", "Abraham Lincoln", "Theodore Roosevelt", "Thomas Jefferson"],
            correctAnswer: 1,
            category: .history
        ),
        
        // Technology Questions
        Question(
            text: "What does 'www' stand for in a web address?",
            answers: ["Wide World Web", "Web World Wide", "World Wide Web", "Wide Web World"],
            correctAnswer: 2,
            category: .technology
        ),
        Question(
            text: "Who invented the light bulb?",
            answers: ["Thomas Edison", "Nikola Tesla", "Benjamin Franklin", "Alexander Bell"],
            correctAnswer: 0,
            category: .technology
        ),
        Question(
            text: "Which company created the iPhone?",
            answers: ["Google", "Samsung", "Apple", "Nokia"],
            correctAnswer: 2,
            category: .technology
        ),
        Question(
            text: "What does 'ATM' stand for?",
            answers: ["Automatic Teller Machine", "Automated Transaction Machine", "Automatic Time Machine", "Automated Teller Machine"],
            correctAnswer: 3,
            category: .technology
        ),
        Question(
            text: "Who is known as the father of computers?",
            answers: ["Albert Einstein", "Charles Babbage", "Isaac Newton", "Thomas Edison"],
            correctAnswer: 1,
            category: .technology
        ),
        
        // Art Questions
        Question(
            text: "Who painted 'Starry Night'?",
            answers: ["Pablo Picasso", "Vincent van Gogh", "Claude Monet", "Salvador Dali"],
            correctAnswer: 1,
            category: .art
        ),
        Question(
            text: "Who painted the Sistine Chapel ceiling?",
            answers: ["Raphael", "Michelangelo", "Leonardo da Vinci", "Donatello"],
            correctAnswer: 1,
            category: .art
        ),
        Question(
            text: "Who wrote 'To Kill a Mockingbird'?",
            answers: ["Harper Lee", "J.K. Rowling", "Ernest Hemingway", "Mark Twain"],
            correctAnswer: 0,
            category: .art
        ),
        
        // Entertainment Questions
        Question(
            text: "What is the highest-grossing film of all time?",
            answers: ["Avatar", "Titanic", "Avengers: Endgame", "The Lion King"],
            correctAnswer: 2,
            category: .entertainment
        ),
        
        // Sports Questions
        Question(
            text: "What is the tallest animal in the world?",
            answers: ["Elephant", "Giraffe", "Rhino", "Horse"],
            correctAnswer: 1,
            category: .sports
        ),
        Question(
            text: "Which country hosted the 2016 Summer Olympics?",
            answers: ["Brazil", "China", "Japan", "Russia"],
            correctAnswer: 0,
            category: .sports
        )
    ]
    static func getQuestions(for category: QuizCategory) -> [Question] {
            if category == .general {
                return allQuestions
            }
            return allQuestions.filter { $0.category == category }
        }
        
        // Helper method to get question count for a category
        static func getQuestionCount(for category: QuizCategory) -> Int {
            return getQuestions(for: category).count
        }
    }

