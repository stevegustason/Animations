//
//  ContentView.swift
//  Animations
//
//  Created by Steven Gustason on 4/1/23.
//

import SwiftUI

struct ContentView: View {
    // Variable to store the size for our animation scaling
    @State private var animationAmount = 1.0
    // Second variable to store a different animation amount
    @State private var animationAmountTwo = 0.0
    
    var body: some View {
        VStack {
            // Here our stepper is bound to $animationAmount.animation so SwiftUI will automatically animate it. Because we're attached to the value to watch, we don't need to specify the value that our modifiers need to watch for changes. This is animating binding changes since we attached the animation modifier to a binding.
            Stepper("Scale amount", value: $animationAmount.animation(.easeInOut(duration: 1)), in: 1...10)

            Spacer()

            // Button just changes the amount with no animation
            Button("Tap Me") {
                animationAmount += 1
            }
            .padding(40)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount)
            
            Spacer()
            
            Button("Tap Me") {
                // Because we don't have an animation modifier attached to this button, we need to use an explicit animation. Here we use the withAnimation closure so SwiftUI will ensure any changes resulting from the new state get animated. We can also use all the same modifiers in an animation parameter here.
                withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                    animationAmountTwo += 360
                }
                    }
                    .padding(50)
                    .background(.black)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            // Here we can add rotation along an axis or multiple at once. Think of the axis as a skewer - x axis allows us to spin forward and backward, y axis allows us to spin left and right, z access allows us to rotate left and right
                    .rotation3DEffect(.degrees(animationAmountTwo), axis: (x: 0, y: 0, z: 1))
            
            Spacer()
            
            Button("Tap Me") {
                /* // Increase our animation scale variable by 1 each time our button is pressed
                 animationAmount += 0.5 */
            }
            .padding(25)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            
            /* // Draws the button at the given scale 1.0 = 100%
             .scaleEffect(animationAmount) */
            
            /* //Make our button blurry the more it's clicked
             .blur(radius: (animationAmount - 1) * 3) */
            
            /* //Apply a default animation whenever animationAmount changes - note that this applies to all properties of our button (as long as they're above the animation). This is an implicit animation because we attached the animation modifier to a view.
             .animation(.default, value: animationAmount) */
            
            /* //Ease out starts fast, but then slows down to a smooth stop
             .animation(.easeOut, value: animationAmount) */
            
            /* //Interpolating spring causes the animation to overshoot its target and bounce until it settles on the correct value
             .animation(.interpolatingSpring(stiffness: 50, damping: 1), value: animationAmount) */
            
            // Overlays create a new view at the same size and position as the view we're overlaying
            .overlay(
                Circle()
                    .stroke(.red)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .animation(
                        // You can use repeatForever for continuous animations
                        .easeOut(duration: 1)
                        .repeatForever(autoreverses: false),
                        value: animationAmount
                    )
            )
            
            /* // You can also control the duration in seconds like the below. When you do this, you're actually creating an instance of the animation struct, so we can add our own modifiers to it, like the delay here. You can also repeat an animation a specific number of times using repeatCount.
             .animation(.easeInOut(duration: 1).delay(0.25).repeatCount(3, autoreverses: true), value: animationAmount) */
            
            // When you use an animation in combination with onAppear - you can make an animation that starts immediately and continues through the life of the view
            .onAppear {animationAmount = 2
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
