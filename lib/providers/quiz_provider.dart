import 'package:flutter/material.dart';
import 'dart:math';
import '../models/question.dart';

enum QuizMode { standard, timed, category }

class QuizProvider with ChangeNotifier {
  int _currentQuestion = 0;
  int _score = 0;
  bool _answered = false;
  String? _selectedAnswer;
  List<Question> _currentSet = [];
  int _totalAnswered = 0;
  int _totalCorrect = 0;
  int _totalPoints = 0;
  final List<String> _achievements = [];
  final int _questionsPerRound = 5;
  QuizMode _mode = QuizMode.standard;
  String? _selectedCategory;
  int _timeLeft = 30;
  bool _isTimerRunning = false;
  final Map<String, Map<String, dynamic>> _categoryResults = {
    'Old Testament': {'score': 0, 'total': 0, 'completed': false},
    'New Testament': {'score': 0, 'total': 0, 'completed': false},
    'Miracles': {'score': 0, 'total': 0, 'completed': false},
    'Parables': {'score': 0, 'total': 0, 'completed': false},
    'Verses': {'score': 0, 'total': 0, 'completed': false},
    'General': {'score': 0, 'total': 0, 'completed': false},
    'History': {'score': 0, 'total': 0, 'completed': false},
  };

  final List<Question> _questions = [
    Question(
      question: "Who built the ark?",
      options: ["Abraham", "Moses", "Noah", "David"],
      answer: "Noah",
      difficulty: "Easy",
      category: "Old Testament",
    ),
    Question(
      question: "In which city was Jesus born?",
      options: ["Nazareth", "Jerusalem", "Bethlehem", "Galilee"],
      answer: "Bethlehem",
      difficulty: "Easy",
      category: "New Testament",
    ),
    Question(
      question: "What did God create on the first day?",
      options: ["Land", "Animals", "Light", "Water"],
      answer: "Light",
      difficulty: "Easy",
      category: "Old Testament",
    ),
    Question(
      question: "Who was swallowed by a great fish?",
      options: ["Elijah", "Jonah", "Paul", "Peter"],
      answer: "Jonah",
      difficulty: "Easy",
      category: "Old Testament",
    ),
    Question(
      question: "Who betrayed Jesus with a kiss?",
      options: ["Peter", "Judas", "Thomas", "James"],
      answer: "Judas",
      difficulty: "Easy",
      category: "New Testament",
    ),
    Question(
      question: "What miracle did Jesus perform at the wedding in Cana?",
      options: [
        "Fed 5,000 people",
        "Healed the blind",
        "Walked on water",
        "Turned water into wine",
      ],
      answer: "Turned water into wine",
      difficulty: "Easy",
      category: "Miracles",
    ),
    Question(
      question: "How many books are in the Bible?",
      options: ["66", "72", "39", "27"],
      answer: "66",
      difficulty: "Medium",
      category: "General",
    ),
    Question(
      question: "What is the last book of the Bible?",
      options: ["Genesis", "Malachi", "Revelation", "Acts"],
      answer: "Revelation",
      difficulty: "Easy",
      category: "New Testament",
    ),
    Question(
      question: "Which disciple walked on water toward Jesus?",
      options: ["James", "John", "Thomas", "Peter"],
      answer: "Peter",
      difficulty: "Medium",
      category: "Miracles",
    ),
    Question(
      question: "Who was thrown into the lion's den?",
      options: ["Daniel", "David", "Moses", "Solomon"],
      answer: "Daniel",
      difficulty: "Easy",
      category: "Old Testament",
    ),
    Question(
      question: "Which parable talks about a son who returns home?",
      options: [
        "The Good Samaritan",
        "The Lost Sheep",
        "The Prodigal Son",
        "The Sower",
      ],
      answer: "The Prodigal Son",
      difficulty: "Easy",
      category: "Parables",
    ),
    Question(
      question: "Who received the Ten Commandments from God?",
      options: ["Abraham", "Moses", "Aaron", "Joshua"],
      answer: "Moses",
      difficulty: "Easy",
      category: "Old Testament",
    ),
    Question(
      question: "What is the shortest verse in the Bible?",
      options: [
        "Jesus wept.",
        "Pray continually.",
        "Rejoice always.",
        "Love one another.",
      ],
      answer: "Jesus wept.",
      difficulty: "Medium",
      category: "Verses",
    ),
    Question(
      question: "Who denied Jesus three times?",
      options: ["Thomas", "Judas", "Peter", "John"],
      answer: "Peter",
      difficulty: "Easy",
      category: "New Testament",
    ),
    Question(
      question: "Which Old Testament figure is known for great wisdom?",
      options: ["Solomon", "David", "Joseph", "Samuel"],
      answer: "Solomon",
      difficulty: "Easy",
      category: "Old Testament",
    ),
    Question(
      question: "How many days did it take to create the world?",
      options: ["3", "5", "6", "7"],
      answer: "6",
      difficulty: "Easy",
      category: "Old Testament",
    ),
    Question(
      question: "What happened on the seventh day of creation?",
      options: [
        "God created man",
        "God created animals",
        "God rested",
        "God made the earth",
      ],
      answer: "God rested",
      difficulty: "Easy",
      category: "Old Testament",
    ),
    Question(
      question: "Who was the first king of Israel?",
      options: ["David", "Solomon", "Saul", "Samuel"],
      answer: "Saul",
      difficulty: "Medium",
      category: "History",
    ),
    Question(
      question: "Which apostle is known for doubting Jesus' resurrection?",
      options: ["Peter", "John", "James", "Thomas"],
      answer: "Thomas",
      difficulty: "Easy",
      category: "New Testament",
    ),
    Question(
      question: "Where was Jesus baptized?",
      options: ["Sea of Galilee", "Red Sea", "Jordan River", "Dead Sea"],
      answer: "Jordan River",
      difficulty: "Easy",
      category: "New Testament",
    ),
    Question(
      question: "Who was the mother of Jesus?",
      options: ["Elizabeth", "Mary", "Ruth", "Martha"],
      answer: "Mary",
      difficulty: "Easy",
      category: "New Testament",
    ),
    Question(
      question: "What is the first book of the New Testament?",
      options: ["Luke", "John", "Matthew", "Mark"],
      answer: "Matthew",
      difficulty: "Medium",
      category: "New Testament",
    ),
    Question(
      question: "Which prophet was taken to heaven in a chariot of fire?",
      options: ["Elijah", "Elisha", "Isaiah", "Jeremiah"],
      answer: "Elijah",
      difficulty: "Medium",
      category: "Old Testament",
    ),
    Question(
      question: "Who was the strongest man in the Bible?",
      options: ["David", "Goliath", "Samson", "Saul"],
      answer: "Samson",
      difficulty: "Easy",
      category: "Old Testament",
    ),
    Question(
      question: "Which disciple was a tax collector?",
      options: ["Peter", "John", "Matthew", "James"],
      answer: "Matthew",
      difficulty: "Medium",
      category: "New Testament",
    ),
    Question(
      question: "Which Old Testament character interpreted dreams in Egypt?",
      options: ["Joseph", "Moses", "Daniel", "Aaron"],
      answer: "Joseph",
      difficulty: "Medium",
      category: "Old Testament",
    ),
    Question(
      question: "What did Jesus feed to 5,000 people?",
      options: [
        "Fish and wine",
        "Bread and water",
        "Bread and fish",
        "Meat and bread",
      ],
      answer: "Bread and fish",
      difficulty: "Easy",
      category: "Miracles",
    ),
    Question(
      question: "What was Paul's name before his conversion?",
      options: ["Stephen", "Saul", "Simon", "Barnabas"],
      answer: "Saul",
      difficulty: "Medium",
      category: "New Testament",
    ),
    Question(
      question: "Who interpreted Nebuchadnezzar's dreams?",
      options: ["Ezekiel", "Joseph", "Daniel", "Isaiah"],
      answer: "Daniel",
      difficulty: "Medium",
      category: "Old Testament",
    ),
    Question(
      question: "Who was Jesus' cousin who baptized Him?",
      options: ["James", "John the Baptist", "Peter", "Andrew"],
      answer: "John the Baptist",
      difficulty: "Easy",
      category: "New Testament",
    ),
    Question(
      question: "Which Gospel is the shortest?",
      options: ["Matthew", "Mark", "Luke", "John"],
      answer: "Mark",
      difficulty: "Medium",
      category: "New Testament",
    ),
    Question(
      question: "What is the longest book in the Bible?",
      options: ["Genesis", "Isaiah", "Psalms", "Exodus"],
      answer: "Psalms",
      difficulty: "Medium",
      category: "Verses",
    ),
    Question(
      question: "What is the first commandment?",
      options: [
        "Honor your parents",
        "You shall not steal",
        "You shall have no other gods",
        "Do not kill",
      ],
      answer: "You shall have no other gods",
      difficulty: "Medium",
      category: "Old Testament",
    ),
    Question(
      question: "How many disciples did Jesus have?",
      options: ["10", "11", "12", "13"],
      answer: "12",
      difficulty: "Easy",
      category: "New Testament",
    ),
    Question(
      question: "What did Jesus do after rising from the dead?",
      options: [
        "Went to heaven immediately",
        "Preached for 40 days",
        "Disappeared",
        "Wrote letters",
      ],
      answer: "Preached for 40 days",
      difficulty: "Medium",
      category: "New Testament",
    ),
    Question(
      question: "What type of insect did John the Baptist eat?",
      options: ["Ants", "Bees", "Locusts", "Flies"],
      answer: "Locusts",
      difficulty: "Hard",
      category: "New Testament",
    ),
    Question(
      question: "How many plagues did God send on Egypt?",
      options: ["7", "10", "12", "3"],
      answer: "10",
      difficulty: "Medium",
      category: "Old Testament",
    ),
    Question(
      question: "Who was the oldest man mentioned in the Bible?",
      options: ["Methuselah", "Noah", "Adam", "Abraham"],
      answer: "Methuselah",
      difficulty: "Medium",
      category: "Old Testament",
    ),
    Question(
      question: "What did God use to speak to Moses in the desert?",
      options: ["Thunder", "Angel", "Fire", "Burning bush"],
      answer: "Burning bush",
      difficulty: "Easy",
      category: "Old Testament",
    ),
    Question(
      question: "Who was David’s best friend?",
      options: ["Samuel", "Jonathan", "Saul", "Solomon"],
      answer: "Jonathan",
      difficulty: "Medium",
      category: "Old Testament",
    ),
    Question(
      question: "What is the Golden Rule?",
      options: [
        "Love one another",
        "Do unto others as you would have them do unto you",
        "Pray always",
        "Honor your parents",
      ],
      answer: "Do unto others as you would have them do unto you",
      difficulty: "Easy",
      category: "Verses",
    ),
    Question(
      question: "What does the name Emmanuel mean?",
      options: ["God with us", "Savior", "The chosen one", "Prince of peace"],
      answer: "God with us",
      difficulty: "Medium",
      category: "Verses",
    ),
    Question(
      question: "Who wrote the Book of Revelation?",
      options: ["Paul", "John", "Peter", "James"],
      answer: "John",
      difficulty: "Medium",
      category: "New Testament",
    ),
    Question(
      question: "Where did Jesus pray before His arrest?",
      options: ["Temple", "Nazareth", "Garden of Gethsemane", "Bethlehem"],
      answer: "Garden of Gethsemane",
      difficulty: "Medium",
      category: "New Testament",
    ),
  ];

  QuizProvider() {
    _resetSet();
  }

  // Getters
  int get currentQuestion => _currentQuestion;
  int get score => _score;
  bool get isAnswered => _answered;
  String? get selectedAnswer => _selectedAnswer;
  List<Question> get questions => _currentSet;
  int get totalAnswered => _totalAnswered;
  int get totalCorrect => _totalCorrect;
  int get totalPoints => _totalPoints;
  List<String> get achievements => _achievements;
  QuizMode get mode => _mode;
  String? get selectedCategory => _selectedCategory;
  int get timeLeft => _timeLeft;
  bool get isTimerRunning => _isTimerRunning;
  Map<String, Map<String, dynamic>> get categoryResults => _categoryResults;

  // Set quiz mode and category
  void setMode(QuizMode mode, {String? category}) {
    _mode = mode;
    _selectedCategory = category;
    _isTimerRunning = mode == QuizMode.timed;
    _resetSet();
  }

  // Reset current question set
  void _resetSet() {
    var filteredQuestions = _selectedCategory == null
        ? _questions
        : _questions.where((q) => q.category == _selectedCategory).toList();
    if (filteredQuestions.isEmpty) {
      filteredQuestions = _questions;
      _selectedCategory = null;
    }
    filteredQuestions = List.from(filteredQuestions)..shuffle(Random());
    _currentSet = filteredQuestions.take(_questionsPerRound).toList();
    _currentQuestion = 0;
    _score = 0;
    _answered = false;
    _selectedAnswer = null;
    _timeLeft = 30;
    notifyListeners();
  }

  // Check answer and update score, points, achievements, category results
  void checkAnswer(String answer, BuildContext context) {
    if (!_answered) {
      _answered = true;
      _selectedAnswer = answer;
      if (answer == _currentSet[_currentQuestion].answer) {
        _score++;
        _totalCorrect++;
        _totalPoints += 10;
        if (_score == _questionsPerRound &&
            !_achievements.contains('Perfect Round')) {
          _achievements.add('Perfect Round');
        }
      }
      _totalAnswered++;
      if (_totalAnswered >= 10 && !_achievements.contains('10 Questions')) {
        _achievements.add('10 Questions');
      }
      if (_totalAnswered >= 25 && !_achievements.contains('25 Questions')) {
        _achievements.add('25 Questions');
      }

      // Update category results
      if (_selectedCategory != null) {
        _categoryResults[_selectedCategory!]!['score'] =
            (_categoryResults[_selectedCategory!]!['score'] as int) +
            (answer == _currentSet[_currentQuestion].answer ? 1 : 0);
        _categoryResults[_selectedCategory!]!['total'] =
            (_categoryResults[_selectedCategory!]!['total'] as int) + 1;
      }

      if (_currentQuestion == 2) {
        showInterstitialAd();
      }
      _isTimerRunning = false;
      notifyListeners();
    }
  }

  // Move to next question or end round
  void nextQuestion(BuildContext context) {
    if (_currentQuestion < _currentSet.length - 1) {
      _currentQuestion++;
      _answered = false;
      _selectedAnswer = null;
      _timeLeft = 30;
      _isTimerRunning = _mode == QuizMode.timed;
      notifyListeners();
    } else {
      if (_selectedCategory != null) {
        int totalCategoryQuestions = _questions
            .where((q) => q.category == _selectedCategory)
            .length;
        if (_categoryResults[_selectedCategory!]!['total'] >=
            totalCategoryQuestions) {
          _categoryResults[_selectedCategory!]!['completed'] = true;
          Navigator.pushNamed(
            context,
            '/results',
            arguments: {
              'score': _score,
              'totalPoints': _totalPoints,
              'category': _selectedCategory,
            },
          );
        } else {
          Navigator.pushNamed(
            context,
            '/mini_results',
            arguments: {'score': _score, 'totalPoints': _totalPoints},
          );
        }
      } else {
        Navigator.pushNamed(
          context,
          '/mini_results',
          arguments: {'score': _score, 'totalPoints': _totalPoints},
        );
      }
    }
  }

  // Reset quiz for a new round
  void resetQuiz() {
    _resetSet();
    notifyListeners();
  }

  // Timer tick for timed mode
  void tickTimer(BuildContext context) {
    if (_mode == QuizMode.timed &&
        _timeLeft > 0 &&
        !_answered &&
        _isTimerRunning) {
      _timeLeft--;
      if (_timeLeft == 0) {
        _answered = true;
        _isTimerRunning = false;
        notifyListeners();
      } else {
        notifyListeners();
      }
    }
  }

  // Pause timer
  void pauseTimer() {
    if (_mode == QuizMode.timed) {
      _isTimerRunning = false;
      notifyListeners();
    }
  }

  // Resume timer
  void resumeTimer() {
    if (_mode == QuizMode.timed && !_answered) {
      _isTimerRunning = true;
      notifyListeners();
    }
  }

  // Use hint to eliminate one incorrect option
  void useHint() {
    if (_totalPoints >= 5 && !_answered && _currentSet.isNotEmpty) {
      _totalPoints -= 5;
      final correct = _currentSet[_currentQuestion].answer;
      final incorrectOptions = _currentSet[_currentQuestion].options
          .where((opt) => opt != correct)
          .toList();
      if (incorrectOptions.isNotEmpty) {
        incorrectOptions.shuffle(Random());
        _currentSet[_currentQuestion].options.remove(incorrectOptions.first);
        notifyListeners();
      }
    }
  }

  // Mock interstitial ad
  void showInterstitialAd() {
    // Mock implementation
  }
}
