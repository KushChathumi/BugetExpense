//
//  LunchScreeen.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-28.
//

import SwiftUI

struct LunchScreeen: View {
    @State var progress: Float = 0.5
    
    var body: some View {
        VStack {
            ProgressView(value: progress)
                .progressViewStyle(CircularProgressViewStyle())
                .foregroundColor(.blue)
            Button("Increase Progress") {
                progress += 0.05
            }
            .padding()
        }
    }
}

