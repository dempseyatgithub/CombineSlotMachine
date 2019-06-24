CombineSlotMachine Tutorial
=================================

### Step 3 ###
_Tag: Step3_  
Okay, now two subscribers are getting updates when the slot machine reel values change. But they are both consuming the same end value. In this step, the score subscriber will receive an integer score indicating if the user won with the current spin.

The big change in this step is adding a method that takes a tuple of three String values (the reels) and returns an Int.
`func score(for reels: (String, String, String)) -> Int` 

For any three-of-a-kind combination, points are awarded. Any other combination is not a winner. In this step, this is a very stingy slot machine. The payouts are rare. Game play will be addressed in a future step.

The other little change with a big effect is changing the map closure in the   `scoreCancellable` pipeline.

The closure calls into the `score(for:)` method which returns an Int.

Since the `sink` subscriber will accept whatever type it receives from upstream, and the sink closure uses string interpolation to print its value no other change is needed. Now with each spin the score is printed out.

Some questions:
_Is the view controller the best place for the `score(for:)` method?_
Probably not. But at the moment there are only about 60 lines of code in the file. It's not unweildly yet at all. I'm pretty certain that will be refactored somewhere else in a future step.

_Is switching on a 3-tuple of Strings going to work in the long run?_
Also probably not. Eventually we will probably want scores for two-of-a-kind regardless of their position and that would make for a crazy big switch statement. But it is easy to do it this way to get rolling.

One of the nice things about chaining Combine operators is that you can change details in the middle of the chain, but as long as the input and output on either side of the change remain the same, you don't have rewrite the entire chain.

_Is there now a reference cycle caused by the new map closure that captures self?_
I'm not 100% sure of my answer after just a bit of investigating, but it seems like the answer is yes.  

The view controller owns `scoreCancellable` which is a reference type: `Subscribers.Sink`. As long as the sink sticks around the closure in the `map` needs to stick around, so it must be held onto strongly somewhere. And then the closure strongly references the view controller.  

This is the best indication yet that the `score(for:)` method should live somewhere else. 

However, in this is a single view app, the single view controller, the sink, and the closure are all around for the lifetime of the app anyway. So we can live with this reference cycle for a few more steps.



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
