//
//  ToastViewModifier.swift
//  Snowport
//
//  Created by Peyton McKee on 1/2/24.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    self.mainToastView()
                        .offset(y: 32)
                }.animation(.spring(), value: self.toast)
            )
            .onChange(of: self.toast) {
                self.showToast()
            }
    }
    
    @ViewBuilder func mainToastView() -> some View {
        if let toast = self.toast {
            VStack {
                ToastView(
                    style: toast.style,
                    message: toast.message,
                    width: toast.width
                ) {
                    self.dismissToast()
                }
                Spacer()
            }
        }
    }
    
    private func showToast() {
        guard let toast = self.toast else { return }
        
        UIImpactFeedbackGenerator(style: .light)
            .impactOccurred()
        
        if toast.duration > 0 {
            self.workItem?.cancel()
            
            let task = DispatchWorkItem {
                self.dismissToast()
            }
            
            self.workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            self.toast = nil
        }
        
        self.workItem?.cancel()
        self.workItem = nil
    }
}
