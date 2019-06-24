CombineSlotMachine Read Me
=================================

This project demonstrates some uses of the Combine framework introduced with Xcode 11 by building a rudimentary iOS slot machine game.

This example is intended to show using the Combine framework with a traditional UIKit app and so it does not use SwiftUI.

It requires Xcode 11 and the Combine framework. It is based on Xcode 11 beta 2, which introduces Combine support to the Foundation framework.

This example demonstrates the following:

Step 1:
- Publishing properties with the @Published attribute
- Combining publishers using the Zip3 publisher
- Map operation
- Assign subscriber
- Standard library random methods

Step 2:
- Multiple publisher -> subscriber chains from same published properties
- Sink subscriber


### TUTORIAL.md file ###

The intent for this project is to tag a commit that represents a step along the way to building the project.

The TUTORIAL.md file contains the name of the tag and some explanation of that step. The most recent step is the top of the file, so you don't need to scroll to the end of the document to see the information about the most recent step.

It's a little experiment I'm trying, we'll see how it goes!

### Feeback ###

The Combine framework is new and the Foundation support I am using in this project appeared in Beta 2 a week before I made this example public.

The code here demonstrates a way to do something that worked for me, but is by no means a definitive guide to the best way to get something done.

If you have feedback or suggestions, please feel free to provide them, especially if there is a cleaner way to implement something or if new documentation or sample code is released that shows intended usage.

Feel free to contact me at @jamesdempsey on [Micro.blog](https://micro.blog/jamesdempsey) and [Twitter](https://twitter.com/jamesdempsey).
