//
//  InsightEngine.swift
//  CalmSteps
//
//  sends break data to openai and gets back a suggestion for the parent
//  docs- platform.openai.com/docs/api-reference/chat
//

import Foundation
import Combine

@MainActor
final class InsightEngine: ObservableObject {
    
    @Published var suggestion: String = ""
    @Published var isLoading: Bool = false
    
    private let apiKey = ""
    private let baseURL = "https://api.openai.com/v1/chat/completions"
    
    //called from insightsview when the screen loads
    func generateSuggestion(from breakEvents: [(title: String, count: Int)]) async {
        
        guard !breakEvents.isEmpty else {
            suggestion = "no break data yet, keep using the app and suggestions will appear here"
            return
        }
        
        isLoading = true
        
        //build a summary string from the break data
        // "Brush Teeth: 5 breaks Get Dressed: 3 breaks"
        var summary = ""
        for i in 0..<breakEvents.count {
            let item = breakEvents[i]
            if item.count == 1 {
                summary += "\(item.title): 1 break"
            } else {
                summary += "\(item.title): \(item.count) breaks"
            }
            if i < breakEvents.count - 1 {
                summary += ", "
            }
        }
        
        //this is what we actually send to the ai
        let prompt = """
        a parent is using CalmSteps, a routine support app for their autistic child aged 5-10.
        the app helps children complete morning and evening routines with visual timers, step by step guidance and break support.
        these are the steps where the child needed the most breaks recently: \(summary).
        based on this, give one short warm suggestion (2 sentences max) to help the parent adjust the routine or support their child better.
        mention the specific step if possible. keep it simple and friendly.
        """
        
        //call the api and wait for the result
        do {
            let result = try await callOpenAI(prompt: prompt)
            suggestion = result
        } catch {
            suggestion = "could not generate a suggestion right now"
        }
        
        isLoading = false
    }
    
    //sends the prompt to openai and returns the response text
    //docs- platform.openai.com/docs/api-reference/chat
    private func callOpenAI(prompt: String) async throws -> String {
        
        //build the url
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        
        //set up the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //these headers are required by openai got them from the docs
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        //the request bod
        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "max_tokens": 150,
            "messages": [
                [
                    "role": "system",
                    "content": "you are a helpful assistant supporting parents of autistic children. keep responses warm, short and practical"
                ],
                [
                    "role": "user",
                    "content": prompt
                ]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        //send the request and wait for the response
        let (data, response) = try await URLSession.shared.data(for: request)
        
        //check the response status code
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            print("OpenAI returned status code:", httpResponse.statusCode)
            throw URLError(.badServerResponse)
        }
        
        //dig into the json response to get the text
        //the structure is choices[0].message.content
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            if let choices = json["choices"] as? [[String: Any]] {
                if let firstChoice = choices.first {
                    if let message = firstChoice["message"] as? [String: Any] {
                        if let text = message["content"] as? String {
                            return text
                        }
                    }
                }
            }
        }
        
        //if we couldnt parse the response
        print("could not parse OpenAI response")
        return "could not generate a suggestion right now"
    }
}
