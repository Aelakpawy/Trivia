import Foundation

struct Question: Hashable, Codable {
    let text: String
    let answers: [String]
    let correctAnswer: Int
    let difficulty: Difficulty
    
    enum Difficulty: String, Codable {
        case easy
        case medium
        case hard
    }
    
    // Implementing Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(answers)
        hasher.combine(correctAnswer)
        hasher.combine(difficulty)
    }
    
    // Implementing Equatable (required by Hashable)
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.text == rhs.text &&
               lhs.answers == rhs.answers &&
               lhs.correctAnswer == rhs.correctAnswer &&
               lhs.difficulty == rhs.difficulty
    }
    
    // Codable implementation
    enum CodingKeys: String, CodingKey {
        case text
        case answers
        case correctAnswer
        case difficulty
    }
}

struct QuestionBank {
    static let allQuestions = [
        // Science Questions (Hard)
        Question(
            text: "What is the half-life of Carbon-14?",
            answers: ["3,570 years", "5,730 years", "7,230 years", "8,730 years"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "Which quantum number describes the orientation of an electron orbital?",
            answers: ["Principal", "Angular momentum", "Magnetic", "Spin"],
            correctAnswer: 2,
            difficulty: .hard
        ),
        Question(
            text: "What is the Goldbach Conjecture?",
            answers: ["Every even number is the sum of two primes", "Every odd number is prime", "Every number is perfect", "Every prime is odd"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        
        // Science Questions (Medium)
        Question(
            text: "What is the most abundant element in the universe?",
            answers: ["Helium", "Oxygen", "Hydrogen", "Carbon"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        Question(
            text: "Which planet has the most moons?",
            answers: ["Jupiter", "Saturn", "Uranus", "Neptune"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        
        // History Questions (Hard)
        Question(
            text: "In which year did the Byzantine Empire fall?",
            answers: ["1453", "1492", "1066", "1204"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "Who was the first Emperor of the Qin Dynasty?",
            answers: ["Qin Shi Huang", "Liu Bang", "Sun Tzu", "Wu Zetian"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        
        // History Questions (Medium)
        Question(
            text: "Which treaty ended World War I?",
            answers: ["Treaty of Paris", "Treaty of Versailles", "Treaty of London", "Treaty of Rome"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        Question(
            text: "Who was the first woman to win a Nobel Prize?",
            answers: ["Mother Teresa", "Marie Curie", "Jane Addams", "Pearl Buck"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        
        // Technology Questions (Hard)
        Question(
            text: "What was the first message sent by ARPANET?",
            answers: ["Hello World", "LOGIN", "Hi", "Test"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "Which programming language was used to write the first compiler?",
            answers: ["Assembly", "FORTRAN", "COBOL", "Machine Code"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        
        // Technology Questions (Medium)
        Question(
            text: "Who is considered the first computer programmer?",
            answers: ["Ada Lovelace", "Grace Hopper", "Alan Turing", "Charles Babbage"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What year was the first iPhone released?",
            answers: ["2005", "2006", "2007", "2008"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        
        // Geography Questions (Hard)
        Question(
            text: "Which country is located in all four hemispheres?",
            answers: ["Russia", "Brazil", "Kiribati", "France"],
            correctAnswer: 2,
            difficulty: .hard
        ),
        Question(
            text: "What is the deepest point in the ocean?",
            answers: ["Mariana Trench", "Tonga Trench", "Philippine Trench", "Puerto Rico Trench"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        
        // Geography Questions (Medium)
        Question(
            text: "Which country has the most islands in the world?",
            answers: ["Indonesia", "Japan", "Philippines", "Sweden"],
            correctAnswer: 3,
            difficulty: .medium
        ),
        Question(
            text: "What is the smallest country in the world?",
            answers: ["Monaco", "San Marino", "Vatican City", "Liechtenstein"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        
        // Art & Literature Questions (Hard)
        Question(
            text: "Who wrote 'One Hundred Years of Solitude'?",
            answers: ["Jorge Luis Borges", "Gabriel García Márquez", "Pablo Neruda", "Octavio Paz"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "Which artist is known for cutting off his own ear?",
            answers: ["Pablo Picasso", "Claude Monet", "Vincent van Gogh", "Salvador Dalí"],
            correctAnswer: 2,
            difficulty: .hard
        ),
        
        // Art & Literature Questions (Medium)
        Question(
            text: "Who painted the Mona Lisa?",
            answers: ["Leonardo da Vinci", "Michelangelo", "Raphael", "Donatello"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "Who wrote '1984'?",
            answers: ["Aldous Huxley", "George Orwell", "Ray Bradbury", "H.G. Wells"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        
        // Mathematics Questions (Hard)
        Question(
            text: "What is the value of Euler's number 'e' to 4 decimal places?",
            answers: ["2.7182", "3.1415", "1.6180", "2.5029"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "What is the only even prime number?",
            answers: ["0", "1", "2", "4"],
            correctAnswer: 2,
            difficulty: .hard
        ),
        
        // Add more questions here...
        
        // Current Events Questions (Medium)
        Question(
            text: "Which company created ChatGPT?",
            answers: ["Google", "Microsoft", "OpenAI", "Meta"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        Question(
            text: "What is the name of Elon Musk's space exploration company?",
            answers: ["Blue Origin", "SpaceX", "Virgin Galactic", "NASA"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        
        // Music Questions (Hard)
        Question(
            text: "Which composer wrote 'The Four Seasons'?",
            answers: ["Bach", "Mozart", "Vivaldi", "Beethoven"],
            correctAnswer: 2,
            difficulty: .hard
        ),
        Question(
            text: "In what year was the first Grammy Awards ceremony held?",
            answers: ["1949", "1959", "1969", "1979"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        
        // Music Questions (Medium)
        Question(
            text: "Which band released 'Dark Side of the Moon'?",
            answers: ["Led Zeppelin", "Pink Floyd", "The Beatles", "The Rolling Stones"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        Question(
            text: "What instrument is BB King famous for playing?",
            answers: ["Piano", "Drums", "Guitar", "Saxophone"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        
        // Sports Questions (Hard)
        Question(
            text: "In which year were women first allowed to compete in the modern Olympics?",
            answers: ["1900", "1912", "1920", "1928"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "Who holds the record for most Olympic medals?",
            answers: ["Usain Bolt", "Michael Phelps", "Larisa Latynina", "Carl Lewis"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        
        // Sports Questions (Medium)
        Question(
            text: "How many players are on a standard soccer team?",
            answers: ["9", "10", "11", "12"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        Question(
            text: "Which country won the first FIFA World Cup?",
            answers: ["Brazil", "Uruguay", "Argentina", "Italy"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        
        // Movies & TV Questions (Hard)
        Question(
            text: "Who was the first African American to win an Academy Award?",
            answers: ["Sidney Poitier", "Hattie McDaniel", "Dorothy Dandridge", "James Baskett"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "Which film won the first Academy Award for Best Animated Feature?",
            answers: ["Toy Story", "Shrek", "Beauty and the Beast", "Snow White"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        
        // Movies & TV Questions (Medium)
        Question(
            text: "What was the first Marvel Cinematic Universe movie?",
            answers: ["Spider-Man", "The Avengers", "Iron Man", "Captain America"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        Question(
            text: "Which TV show holds the record for most Emmy Awards?",
            answers: ["Game of Thrones", "The Simpsons", "Friends", "Saturday Night Live"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        
        // Food & Cuisine Questions (Hard)
        Question(
            text: "What is the main ingredient in traditional Japanese mochi?",
            answers: ["Rice flour", "Wheat flour", "Tapioca starch", "Cornstarch"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "Which cheese is traditionally used in authentic Greek Moussaka?",
            answers: ["Feta", "Halloumi", "Kefalotyri", "Graviera"],
            correctAnswer: 2,
            difficulty: .hard
        ),
        
        // Food & Cuisine Questions (Medium)
        Question(
            text: "What is the national dish of Spain?",
            answers: ["Paella", "Gazpacho", "Tortilla Española", "Patatas Bravas"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "Which country invented sushi?",
            answers: ["Japan", "China", "Korea", "Thailand"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        
        // Business & Economics Questions (Hard)
        Question(
            text: "Who was the first person to become a billionaire by creating a software company?",
            answers: ["Steve Jobs", "Bill Gates", "Larry Ellison", "Paul Allen"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "What year was the first stock market crash, known as the 'Tulip Mania'?",
            answers: ["1637", "1720", "1792", "1829"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        
        // Business & Economics Questions (Medium)
        Question(
            text: "Which company was the first to reach a $1 trillion market cap?",
            answers: ["Microsoft", "Amazon", "Apple", "Google"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        Question(
            text: "What is the currency of Brazil?",
            answers: ["Peso", "Real", "Bolivar", "Sol"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        
        // Science & Nature Questions (Hard)
        Question(
            text: "What is the speed of light in meters per second?",
            answers: ["299,792,458", "300,000,000", "299,999,999", "298,792,458"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "What is the hardest natural substance on Earth?",
            answers: ["Graphene", "Diamond", "Wurtzite boron nitride", "Lonsdaleite"],
            correctAnswer: 2,
            difficulty: .hard
        ),
        
        // Science & Nature Questions (Medium)
        Question(
            text: "What is the largest organ in the human body?",
            answers: ["Liver", "Brain", "Skin", "Large Intestine"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        Question(
            text: "Which animal has the longest lifespan?",
            answers: ["Greenland Shark", "Giant Tortoise", "Bowhead Whale", "Antarctic Sponge"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        
        // Psychology Questions (Hard)
        Question(
            text: "Who is known as the father of psychoanalysis?",
            answers: ["Sigmund Freud", "Carl Jung", "B.F. Skinner", "William James"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        
        /// Add these to the allQuestions array
        
        // Islamic/Arabic History (Hard)
        Question(
            text: "In which year did the Islamic Golden Age begin?",
            answers: ["622 CE", "750 CE", "632 CE", "661 CE"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "Who was the founder of the Umayyad Caliphate?",
            answers: ["Abu Bakr", "Muawiya I", "Umar ibn Al-Khattab", "Ali ibn Abi Talib"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "Which Muslim scholar is known as the 'Father of Modern Medicine'?",
            answers: ["Al-Razi", "Ibn Sina", "Al-Kindi", "Ibn Al-Haytham"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "Which city was the capital of the Abbasid Caliphate?",
            answers: ["Damascus", "Baghdad", "Cairo", "Medina"],
            correctAnswer: 1,
            difficulty: .medium
        ),

        // US History (Hard)
        Question(
            text: "Who was the first US Supreme Court Chief Justice?",
            answers: ["John Marshall", "John Jay", "John Rutledge", "Oliver Ellsworth"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "What year was the Articles of Confederation ratified?",
            answers: ["1776", "1781", "1783", "1787"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "Which US President served the shortest term in office?",
            answers: ["William Henry Harrison", "James A. Garfield", "Zachary Taylor", "Warren G. Harding"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "What was the first state to ratify the US Constitution?",
            answers: ["Virginia", "Pennsylvania", "Delaware", "Massachusetts"],
            correctAnswer: 2,
            difficulty: .medium
        ),

        // Space Exploration (Hard)
        Question(
            text: "What was the name of the first space station?",
            answers: ["Mir", "Skylab", "Salyut 1", "ISS"],
            correctAnswer: 2,
            difficulty: .hard
        ),
        Question(
            text: "Who was the first human to conduct a spacewalk?",
            answers: ["Yuri Gagarin", "Alexei Leonov", "Ed White", "John Glenn"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "What was the first probe to land on Mars?",
            answers: ["Viking 1", "Mars 2", "Mars 3", "Pathfinder"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "Which space mission first photographed the far side of the Moon?",
            answers: ["Apollo 8", "Luna 3", "Ranger 7", "Surveyor 1"],
            correctAnswer: 1,
            difficulty: .hard
        ),

        // Ancient History (Hard)
        Question(
            text: "Who was the last active ruler of the Ptolemaic Kingdom of Egypt?",
            answers: ["Cleopatra VII", "Ptolemy XIII", "Ptolemy XIV", "Ptolemy XV"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "What was the capital of the Inca Empire?",
            answers: ["Machu Picchu", "Cusco", "Quito", "Lima"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "Which ancient civilization invented the concept of zero?",
            answers: ["Greeks", "Mayans", "Indians", "Babylonians"],
            correctAnswer: 2,
            difficulty: .hard
        ),
        Question(
            text: "Who was the first Emperor of unified China?",
            answers: ["Qin Shi Huang", "Han Gaozu", "Emperor Wu", "Emperor Wen"],
            correctAnswer: 0,
            difficulty: .medium
        ),

        // Modern History (Hard)
        Question(
            text: "When did the Berlin Wall fall?",
            answers: ["1987", "1988", "1989", "1990"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        Question(
            text: "Which country was the first to give women the right to vote?",
            answers: ["United States", "New Zealand", "United Kingdom", "France"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "When was the United Nations founded?",
            answers: ["1943", "1944", "1945", "1946"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        Question(
            text: "What year did the Soviet Union dissolve?",
            answers: ["1989", "1990", "1991", "1992"],
            correctAnswer: 2,
            difficulty: .medium
        ),

        // Space Science (Hard)
        Question(
            text: "What is the largest known dwarf planet in our solar system?",
            answers: ["Ceres", "Eris", "Pluto", "Haumea"],
            correctAnswer: 2,
            difficulty: .hard
        ),
        Question(
            text: "Which spacecraft has traveled the farthest from Earth?",
            answers: ["Voyager 1", "Voyager 2", "Pioneer 10", "New Horizons"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "What is the name of SpaceX's first crewed spacecraft?",
            answers: ["Dragon", "Crew Dragon", "Starship", "Falcon"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        Question(
            text: "Which moon in our solar system is known to have liquid oceans?",
            answers: ["Europa", "Titan", "Enceladus", "All of the above"],
            correctAnswer: 3,
            difficulty: .hard
        ),
        // Add these to the allQuestions array

        // Pop Culture (Medium)
        Question(
            text: "Which social media platform was originally called 'Twttr'?",
            answers: ["Facebook", "Twitter", "Instagram", "Snapchat"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        Question(
            text: "What year did YouTube launch?",
            answers: ["2003", "2004", "2005", "2006"],
            correctAnswer: 2,
            difficulty: .medium
        ),

        // Ancient History (Hard)
        Question(
            text: "Which ancient wonder was located in Alexandria?",
            answers: ["Colossus of Rhodes", "Lighthouse", "Hanging Gardens", "Temple of Artemis"],
            correctAnswer: 1,
            difficulty: .hard
        ),
        Question(
            text: "Who was the first Roman Emperor?",
            answers: ["Julius Caesar", "Augustus", "Nero", "Caligula"],
            correctAnswer: 1,
            difficulty: .hard
        ),

        // Biology (Hard)
        Question(
            text: "What is the process of cellular self-destruction called?",
            answers: ["Mitosis", "Meiosis", "Apoptosis", "Necrosis"],
            correctAnswer: 2,
            difficulty: .hard
        ),
        Question(
            text: "Which organelle is known as the 'powerhouse' of the cell?",
            answers: ["Nucleus", "Mitochondria", "Golgi Body", "Endoplasmic Reticulum"],
            correctAnswer: 1,
            difficulty: .medium
        ),

        // Chemistry (Hard)
        Question(
            text: "What is the most electronegative element?",
            answers: ["Oxygen", "Chlorine", "Fluorine", "Nitrogen"],
            correctAnswer: 2,
            difficulty: .hard
        ),
        Question(
            text: "What is the atomic number of Gold (Au)?",
            answers: ["77", "79", "81", "83"],
            correctAnswer: 1,
            difficulty: .hard
        ),

        // Literature (Medium)
        Question(
            text: "Who wrote 'Pride and Prejudice'?",
            answers: ["Jane Austen", "Emily Brontë", "Virginia Woolf", "Charlotte Brontë"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What is the name of Harry Potter's owl?",
            answers: ["Errol", "Fawkes", "Hedwig", "Pigwidgeon"],
            correctAnswer: 2,
            difficulty: .medium
        ),

        // Video Games (Medium)
        Question(
            text: "Which company created Mario?",
            answers: ["Sega", "Nintendo", "Sony", "Microsoft"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        Question(
            text: "What year was Minecraft first released?",
            answers: ["2009", "2010", "2011", "2012"],
            correctAnswer: 0,
            difficulty: .medium
        ),

        // Space Exploration (Hard)
        Question(
            text: "Who was the first human to walk on the moon?",
            answers: ["Buzz Aldrin", "Neil Armstrong", "Yuri Gagarin", "John Glenn"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        Question(
            text: "What was the first artificial satellite in space?",
            answers: ["Explorer 1", "Vanguard 1", "Sputnik 1", "Telstar 1"],
            correctAnswer: 2,
            difficulty: .hard
        ),

        // Medicine (Hard)
        Question(
            text: "What is the most common blood type in humans?",
            answers: ["A+", "B+", "O+", "AB+"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        Question(
            text: "Who discovered penicillin?",
            answers: ["Louis Pasteur", "Alexander Fleming", "Robert Koch", "Joseph Lister"],
            correctAnswer: 1,
            difficulty: .hard
        ),

        // Mathematics (Hard)
        Question(
            text: "What is the sum of the angles in a triangle?",
            answers: ["90 degrees", "180 degrees", "270 degrees", "360 degrees"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        Question(
            text: "What is the square root of -1 called?",
            answers: ["Imaginary number", "Complex number", "i", "Undefined"],
            correctAnswer: 2,
            difficulty: .hard
        ),

        // Environmental Science (Medium)
        Question(
            text: "What is the largest source of ocean pollution?",
            answers: ["Oil spills", "Plastic", "Chemical waste", "Sewage"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        Question(
            text: "Which gas is most responsible for the greenhouse effect?",
            answers: ["Oxygen", "Carbon Dioxide", "Nitrogen", "Methane"],
            correctAnswer: 1,
            difficulty: .medium
        ),

        // World Languages (Hard)
        Question(
            text: "Which language has the most native speakers?",
            answers: ["English", "Spanish", "Hindi", "Mandarin Chinese"],
            correctAnswer: 3,
            difficulty: .hard
        ),
        Question(
            text: "How many official languages does the UN have?",
            answers: ["4", "5", "6", "7"],
            correctAnswer: 2,
            difficulty: .hard
        ),

        // Famous Inventions (Medium)
        Question(
            text: "Who invented the telephone?",
            answers: ["Thomas Edison", "Alexander Graham Bell", "Nikola Tesla", "George Eastman"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        Question(
            text: "In which year was the World Wide Web invented?",
            answers: ["1989", "1991", "1993", "1995"],
            correctAnswer: 0,
            difficulty: .hard
        ),

        // Additional questions
        Question(
            text: "What was Creed's job title?",
            answers: ["Quality Assurance", "Sales Representative", "Accountant", "Manager"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What was the name of Kevin's band?",
            answers: ["Scrantonicity", "Scrantonicity 2", "Dunder Band", "The Police"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What was Andy's college nickname?",
            answers: ["Nard Dog", "Big Tuna", "Broccoli Rob", "A Cappella Andy"],
            correctAnswer: 0,
            difficulty: .easy
        ),
        Question(
            text: "What was the name of the company that bought Dunder Mifflin?",
            answers: ["Sabre", "Prince Family Paper", "Staples", "Michael Scott Paper Company"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What did Jim give Pam as a Christmas gift in Season 2?",
            answers: ["A teapot", "A bracelet", "A painting", "A stuffed bear"],
            correctAnswer: 0,
            difficulty: .easy
        ),
        Question(
            text: "What was the name of Stanley's wife?",
            answers: ["Teri", "Cynthia", "Phyllis", "Karen"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What is Toby's daughter's name?",
            answers: ["Sasha", "Maddie", "Lily", "Sophia"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What is the name of the warehouse foreman?",
            answers: ["Darryl Philbin", "Lonny Collins", "Roy Anderson", "Madge"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What was the theme of Kelly's birthday party?",
            answers: ["America", "The Office", "Hawaii", "Netflix and Chill"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What does Jim say is his favorite food?",
            answers: ["Soft-shell crab", "Pizza", "Hot dogs", "Chicken Alfredo"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "Who started the fire in the office?",
            answers: ["Ryan", "Michael", "Dwight", "Pam"],
            correctAnswer: 0,
            difficulty: .easy
        ),
        Question(
            text: "What is Michael's middle name?",
            answers: ["Gary", "Scott", "James", "Wayne"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What kind of car does Dwight drive?",
            answers: ["Pontiac Trans Am", "Toyota Camry", "Chevrolet Malibu", "Ford Taurus"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What is the name of Phyllis's husband?",
            answers: ["Bob Vance", "Stanley Hudson", "Roy Anderson", "David Wallace"],
            correctAnswer: 0,
            difficulty: .easy
        ),
        Question(
            text: "What sport does Jim play?",
            answers: ["Basketball", "Soccer", "Baseball", "Tennis"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What was Pam's role before becoming a salesperson?",
            answers: ["Receptionist", "HR Assistant", "Secretary", "Office Manager"],
            correctAnswer: 0,
            difficulty: .easy
        ),
        Question(
            text: "What is the name of the documentary's boom mic operator?",
            answers: ["Brian", "Mark", "Steve", "Mike"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "What is Michael's catchphrase?",
            answers: ["That's what she said!", "No, God, please no!", "Boom, roasted!", "Bears. Beets. Battlestar Galactica."],
            correctAnswer: 0,
            difficulty: .easy
        ),
        Question(
            text: "Who does Michael hit with his car?",
            answers: ["Meredith", "Stanley", "Kevin", "Toby"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What is the name of the temp who becomes VP?",
            answers: ["Ryan Howard", "Andy Bernard", "Jim Halpert", "Toby Flenderson"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What is the name of Dwight's babysitter who he dates?",
            answers: ["Melvina", "Angela", "Jan", "Pam"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "What type of pizza does Michael insist on ordering?",
            answers: ["New York-style", "Stuffed crust", "Chicago-style", "Thin crust"],
            correctAnswer: 0,
            difficulty: .easy
        ),
        Question(
            text: "What does Pam name her painting of the office building?",
            answers: ["Dunder Mifflin", "Home", "Scranton", "The Office"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What is Kevin's special chili ingredient?",
            answers: ["Undercooked onions", "Paprika", "Beans", "Tomato paste"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What did Michael burn his foot on?",
            answers: ["A George Foreman grill", "A hot plate", "A curling iron", "A heater"],
            correctAnswer: 0,
            difficulty: .easy
        ),
        Question(
            text: "Who was Dwight's sensei?",
            answers: ["Ira", "Sensei Billy", "Michael", "Mose"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        Question(
            text: "What is the name of the HR representative who Michael despises?",
            answers: ["Toby", "Holly", "Karen", "Ryan"],
            correctAnswer: 0,
            difficulty: .easy
        ),
        Question(
            text: "What was the name of Pam and Angela’s party planning committee rival group?",
            answers: ["The Committee to Plan Parties", "Party People", "Fun Squad", "Party Planners"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What does Creed do when he sees the police at the office?",
            answers: ["Runs away", "Hides under his desk", "Asks for a lawyer", "Offers them paper"],
            correctAnswer: 0,
            difficulty: .easy
        ),
        Question(
            text: "What was Michael's favorite ice cream flavor?",
            answers: ["Mint Chocolate Chip", "Rocky Road", "Cookie Dough", "Vanilla"],
            correctAnswer: 1,
            difficulty: .medium
        ),
        Question(
            text: "What is the name of the cat Angela sprinkles with ashes?",
            answers: ["Sprinkles", "Bandit", "Comstock", "Garbage"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        Question(
            text: "Who did Dwight trick into thinking the apocalypse had arrived?",
            answers: ["Erin", "Kevin", "Stanley", "Jim"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What role does Jan take after leaving Dunder Mifflin?",
            answers: ["Running her candle company", "Executive at a different company", "Stay-at-home mom", "Corporate trainer"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "What is the title of the song Andy performs in the talent show?",
            answers: ["Take a Chance on Me", "I Will Survive", "Faith", "Zombie"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What does Pam draw on her first day as receptionist?",
            answers: ["A house", "A bear", "A receptionist desk", "Dunder Mifflin logo"],
            correctAnswer: 3,
            difficulty: .hard
        ),
        Question(
            text: "What kind of toy does Dwight bring to Michael's roast?",
            answers: ["A doll", "A blowtorch", "A dummy", "A bobblehead"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        Question(
            text: "What is Meredith’s son’s name?",
            answers: ["Jake", "Sam", "Brian", "Ben"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What is Holly’s middle name?",
            answers: ["Parrish", "Flax", "Gary", "Green"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "What does Dwight give Angela for Christmas?",
            answers: ["A cat statue", "A key to his farm", "A wooden nutcracker", "A framed picture of them"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What nickname does Michael give to Oscar?",
            answers: ["The Senator", "Number Cruncher", "Actually", "Oscar Mayer Weiner Lover"],
            correctAnswer: 3,
            difficulty: .hard
        ),
        Question(
            text: "What is Andy’s nickname for Angela?",
            answers: ["Monkey", "Angel", "Kitty", "Peanut"],
            correctAnswer: 0,
            difficulty: .medium
        ),
        Question(
            text: "What is Michael’s proposed TV show?",
            answers: ["The Michael Scott Variety Hour", "Threat Level Midnight 2", "Michael Scott's Life Stories", "The Michael Show"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "What flavor cake does Stanley prefer for his birthday?",
            answers: ["Vanilla", "Chocolate", "Carrot", "Cheesecake"],
            correctAnswer: 1,
            difficulty: .easy
        ),
        Question(
            text: "What was Andy’s major at Cornell?",
            answers: ["A cappella Studies", "Business", "History", "Performing Arts"],
            correctAnswer: 2,
            difficulty: .hard
        ),
        Question(
            text: "What was the original branch of Dunder Mifflin?",
            answers: ["Buffalo", "Scranton", "Utica", "New York"],
            correctAnswer: 3,
            difficulty: .medium
        ),
        Question(
            text: "What food does Michael force Kevin to eat in 'Michael’s Last Dundies'?",
            answers: ["A cupcake", "Broccoli", "A chili dog", "A salad"],
            correctAnswer: 1,
            difficulty: .easy
        ),
        Question(
            text: "What does Ryan want to order at the bowling alley?",
            answers: ["Milk", "Chicken tenders", "Nachos", "A Cosmo"],
            correctAnswer: 0,
            difficulty: .hard
        ),
        Question(
            text: "What is the theme of Andy's garden party?",
            answers: ["Cornell", "Traditional", "Victorian", "Casual"],
            correctAnswer: 2,
            difficulty: .medium
        ),
        Question(
            text: "What is the name of Dwight's cousin?",
            answers: ["Mose", "Zeke", "Nate", "Jeb"],
            correctAnswer: 0,
            difficulty: .easy
        ),
        Question(
            text: "What fake disease does Dwight create for the health insurance forms?",
            answers: ["Hot Dog Fingers", "Count Choculitis", "Horse Teeth", "Tiny Heart Disease"],
            correctAnswer: 1,
            difficulty: .easy
        ),
        Question(
            text: "What did Michael buy for Ryan’s baby shower?",
            answers: ["A stroller", "A cactus", "A pair of shoes", "A onesie"],
            correctAnswer: 3,
            difficulty: .medium
        ),
        Question(
            text: "What food does Michael use to propose to Holly?",
            answers: ["A doughnut", "A cupcake", "A pretzel", "A cookie"],
            correctAnswer: 3,
            difficulty: .medium
        ),
        Question(
            text: "What game do the office employees play during 'Beach Games'?",
            answers: ["Sumo wrestling", "Hot dog eating", "Egg race", "Flonkerton"],
            correctAnswer: 3,
            difficulty: .medium
        ),
        // Add more if needed to complete!

        // Continue to add more for 50 total...

        // Continue with similar pattern, making sure to cover different aspects of the show
        // and varying difficulty levels
    ]
    
    static func getQuestionsByDifficulty(_ difficulty: Question.Difficulty) -> [Question] {
        return allQuestions.filter { $0.difficulty == difficulty }
    }
}
