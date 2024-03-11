//
//  FormSubmitButton.swift
//  Snowport
//
//  Created by Peyton McKee on 1/4/24.
//

import SwiftUI

struct FormSubmitButton: View {
    var submissionText: SubmissionText
    var onSubmit: () -> Void
    var body: some View {
        Button(self.submissionText.rawValue, action: self.onSubmit)
            .frame(maxWidth: .infinity)
    }
}

