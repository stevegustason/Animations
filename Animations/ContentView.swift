//
//  ContentView.swift
//  Animations
//
//  Created by Steven Gustason on 4/1/23.
//

import SwiftUI

// We can create our own .modifier transitions like so
struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

// We likely then want to make an extension so that we don't have to use the unwieldy .modifier transition. After making the extension below, we can simply call .transition(.pivot) and it will make it rotate from -90 to 0 on its top leading corner.
extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {
    // Variable to store the size for our animation scaling
    @State private var animationAmount = 1.0
    // Second variable to store a different animation amount
    @State private var animationAmountTwo = 0.0
    // Variable to track button state
    @State private var enabled = false
    
    // Variable to store the amount of a user's drag
    @State private var dragAmount = CGSize.zero
    
    let letters = Array("Hello SwiftUI")
    
    // Variable to track condition for displaying a view
    @State private var isShowingRed = false
    
    var body: some View {
        
        // Here we make use of our custom transition
        ZStack {
            // We have a blue rectangle, with an onTapGesture that toggles our isShowingRed value
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            // If isShowingRed is toggled, we pivot our red rectangle over top
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
                }
        
        /*
         // This section is about transitions
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            // Here we have a condition for our view to show
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                // We can use transitions to control that transition between showing and not showing. We can also use an asymmetric transition to do one thing when the view is shown and one when it's removed.
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
         */
        
        /*
        // Here, we create an HStack with each single letter in our Hello SwiftUI array having its own padding, a background color that changes when we let go of it, and a delay animation. We can combine that with our drag gesture to have the letters each move according to the dragAmount, using our offset, then return to their original place and change color. Fairly simple code for a really cool effect.
        HStack(spacing: 0) {
                    ForEach(0..<letters.count, id: \.self) { num in
                        Text(String(letters[num]))
                            .padding(5)
                            .font(.title)
                            .background(enabled ? .blue : .red)
                            .offset(dragAmount)
                            .animation(.default.delay(Double(num) / 20), value: dragAmount)
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { dragAmount = $0.translation }
                        .onEnded { _ in
                            dragAmount = .zero
                            enabled.toggle()
                        }
                )
         */
        
        /*
         // This is all about gestures
        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(width: 300, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
        // Our offset here changes where our card is using dragAmount, which will be set in the gesture below
                    .offset(dragAmount)
        // Here we create a gesture, specifically a drag gesture to allow us to drag the card around
                    .gesture(
                        DragGesture()
                        // onChanged lets us run a closure whenever the user moves their finger. Here, we set dragAmount to be equal to the translation of the drag, or how far away it is from the start point, which causes our offset to change, making our view move with the drag.
                            .onChanged { dragAmount = $0.translation }
                        // onEnded lets us run a closure when the user lifts the finger off the screen, ending the drag. Here, we ignore the input entirely because we want to set dragAmount to zero so our card goes back to its original position when the user lets go. Here, we're adding an explicit animation to our end of drag, so our card nicely falls back to its original position instead of snapping back.
                            .onEnded { _ in withAnimation(.spring()) { dragAmount = .zero }
                            }
                    )
         // Instead of explicitly animating the onEnded closure, we could implicitely animate the card, which will cause both the drag and the release to be animated.
         .animation(.spring(), value: dragAmount)
         */

        
        /* // This is all experimentation with buttons and basic animations
        VStack {
            Spacer()
            
            // This button example shows that we can have multiple animations at the same time. The order of the animations matters, just like the order of regular modifiers matters. Each animation only animates the things above it. You can also disable animations by passing nil as a value, which is valuable if you need a modifier to be in a particular order but don't want to animate it - if you didn't add a nil animation, the next animation in the stack would still animate it.
            Button("Hit me") {
                enabled.toggle()
            }
            .frame(width: 100, height: 100)
            .background(enabled ? .blue : .red)
            .animation(nil, value: enabled)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
            .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)
            
            
            Spacer()
            
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
        } */
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
