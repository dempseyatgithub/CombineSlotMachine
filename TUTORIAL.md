CombineSlotMachine Tutorial
=================================

### Step 2 ###
_Tag: Step2_  
For a little while, it’s fun to tap the spin button and see random symbols appear. But part of the fun of a slot machine is getting a winning combination of symbols.  

This step will start down the path of including scoring for the slot machine. The eventual goal is that you will be able to start a new game session with a set amount of points (“money”). Each spin will cost a certain amount of points and winning combinations will add to your points. This functionality will happen over the next few steps.

To do this, each time the three reel values update, two different things need to happen. First, the updated results need to be presented on screen—this is already happening. The second thing that needs to happen is the updated results must be translated into a numeric score indicating how much the user has won.

The same published data needs to be used by two different subscribers: one to handle presenting the reels, and one to handle scoring.

I initially tried to use the `multicast()` operator to have the same results of the Zip3 publisher split off to two different chains of processing ending in two different subscribers. At present, though, that method not undocumented and I was unable to get it to work.

Instead, I am creating two different Zip3 publishers, each ending in its own subscriber. (This may very well be the preferred approach anyway. I don't know much about the `multicast()` operator yet.)

There are a few changes in this step:

- Rename `cancellable` property to `reelCancellable` to disambiguate between the two 'pipelines'.
- Add `scoreCancellable` property for the second publisher to subscriber pipeline.
- Create a new Zip3 publisher, use the same `map` transformation as before, and use the `sink` subscriber to print the results

In this case the `sink` subscriber is handy for printing out the results to check that the subscriber is receiving what is expected.

At the moment, the same string that is displayed to the user is printed to the console. In future steps the new publisher will start delivering a score for each combination instead of a string. But for now, printing to the console shows that both data streams are working as expected. 


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
