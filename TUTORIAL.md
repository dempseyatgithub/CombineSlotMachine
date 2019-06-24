CombineSlotMachine Tutorial
=================================

### Step 1 ###
_Tag: Step1_  
This app is a basic slot machine game with three reels. You tap a button and get back a random spin result. The game does not keep score at all at present.

The interface is basic:

- A label with static text with the game title
- A Spin button
- A label that presents the spin results using emoji (`spinResultsLabel`)

The implementation has:

- Three String properties marked with @Published. When their values change, they will publish that value downstream.

- A `cancellable` property to hold the 'Cancellable' the Subscriber at the end of the chain that can be cancelled.

- A `reelChoices` property holding an array of emoji strings to use for the results of the reels.

- A `spin(_:)` action method that updates each of the reel values with a random element of the `reelChoices` array.

Last, but not least, in `viewDidLoad()` the Combine chain is set up:

We create a Zip3 publisher that is initialized with the three reel values. 

Note that the names of the properties use the '$' prefix. This indicates that we are passing in the *publisher* that wraps that value, *not* the value itself.  

The Zip3 publisher will wait until values are published for all three reels before sending a tuple of all three values downstream. One benefit of the zip publisher is putting those values together and passing them along in a tuple, but another benefit is waiting for all the values to arrive.

Zip produces a tuple of three string values. The `map` operator lets us transform that tuple into the string that will be displayed. In the map closure we pull the values out of the tuple and create the string that will be displayed.

Finally, the `assign` subscriber assigns the string to the `text` property of the `spinResultsLabel` which updates the user interface.
