//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Adam Miller on 6/24/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingScore: Bool = false
    @State private var scoreTitle: String = ""
    
    @State private var countries: [String] = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer: Int = Int.random(in: 0...2)
    
    @State private var score: Int = 0
    @State private var questionNumber: Int = 0
    
    var continueGame: Bool {
        var allCorrect = (questionNumber + 1 == score)
        var maxQuestions = (questionNumber >= 7)
        return allCorrect && !maxQuestions
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                Gradient.Stop(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                Gradient.Stop(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag!")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of:")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.primary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("Score: \(score)")
                    .font(.title.weight(.bold))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            .shadow(radius: 5)
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            if continueGame {
                Button("Continue") {
                    questionNumber += 1
                    nextQuestion()
                }
            } else {
                Button("Reset") {
                    reset()
                }
            }
        } message: {
            Text("Your score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            if (questionNumber + 1 == 8) {
                scoreTitle = "🎉 Congratulations! You've gotten 8/8 countries correct!"
            } else {
                scoreTitle = "👍 Correct!"
            }
            score += 1
        } else {
            scoreTitle = "🙅🏻‍♂️ Wrong! That's the flag of \(countries[number])"
        }
        
        showingScore = true
        print("questionNumber: \(questionNumber), score: \(score)")
    }
    
    func nextQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        score = 0
        questionNumber = 0
        nextQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
