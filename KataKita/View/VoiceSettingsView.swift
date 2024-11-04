//
//  VoiceSettingsView.swift
//  KataKita
//
//  Created by Gwynneth Isviandhy on 04/11/24.
//

import SwiftUI

struct VoiceSettingsView: View {
    var body: some View {
        List {
                    Section(header: Text("Choose a Voice")) {
                        Button("Girl") {
                            // Handle selecting Girl voice
                        }
                        Button("Boy") {
                            // Handle selecting Boy voice
                        }
                        NavigationLink(destination: PersonalizedVoiceRecordingView()) {
                            Text("Personalized Voice")
                        }
                    }
                }
                .navigationTitle("Voice Settings")    }
}
struct PersonalizedVoiceRecordingView: View {
    @State private var isRecording = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Personalized Voice Setup")
                .font(.title)
                .padding(.top)
            
            Text("Please read the passage below aloud to create a personalized voice for the app.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("“The quick brown fox jumps over the lazy dog.”")
                .font(.headline)
                .padding()
            
            Button(action: {
                isRecording.toggle()
                // Start or stop recording
            }) {
                Text(isRecording ? "Stop Recording" : "Start Recording")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            if isRecording {
                Text("Recording...")
                    .foregroundColor(.red)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Personalized Voice")
    }
}


#Preview {
    VoiceSettingsView()
}
