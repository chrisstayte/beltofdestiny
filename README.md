# Belt Of Destiny

### Concept

This game is an endless runner type experience where you need to sort trash as it comes in on a conveyor belt. Your goal is to know what items can and should be recycled. There will be a temp bar on the side of the screen that determines the heat of the earth. Every piece of trash that goes into the incinerator will cause the earth to go up in temperature. Every piece of trash that is properly recycled will cause the temp to go down. When something that should not be recycled gets into the recycler it will short out the switch box causing you to lose progress by forcing the trash to be the only option for a while being.

## Gameplay

### Core

The play will have the ability to alter the flow of the endless conveyor belt. They can choose to allow items to go into the incinerator or allow items to go into the recycler. Their objective is to learn what items can be and what can't be recycled in order to keep the earth's temperature from hitting the cap. Each item that goes into the incinerator will cause the temperature of the earth to go up with items that can be recycled to go up more than usual. If the user recycles an item that should not be recycled the ability to control the flow of the conveyor will be locked to incinerator for a period of time.

> **Info**
> The game needs a system to keep track of points or accomplishments. I am leaning towards points based upon the number of items recycled.

### Progression

With the game being and endless runner type of experience the ways we can control is the rate/speed of the conveyor belt along with the frequency of items. As the player gets past item counts the rate and frequency will go up with a final cap.

### UI

The game will feature a conveyor belt coming in from the bottom and headed towards the top of the screen where it will split into two separate belts. Each subsequent belts will feed into either an incinerator or a recycled.

Along the right side of the screen you will also see a bar that measures the temperature of the earth. The bar will progress upwards for each item that gets put into the incinerator. Each item that gets properly recycled will bring the meter downwards.

Above the machinery at the top of the screen will be a point counter that continuously counts upwards the users scores.

There will be a pause button to pause the game.

### Designs

Game idea initial sketch
![game idea 1](/readme/game-idea-1.jpg)

More refined sketch

- ![game idea 2](/readme/game-idea-2.jpg)

Screen progression sketch

- ![game idea 3](/readme/game-idea-3.jpg)

## Developer Notes

### Backend

- Hosting (Web): Firebase
- Remote Config: Firebase Remote Config
- Analytics: Firebase Analytics
- Crashlytics: Firebase Crashlytics

### Before You Build

- I stopped tracking `lib/firebase_options.dart` in the repo to keep my api key for firebase being so easily accessible.
  - This can be re-added by running `flutterfire configure` and tying the application to the firebase account

### Remote Config

The remote config was added as a way for the game to adjust gameplay feel and mechanics without a redeploy and build. There are several ways to do so:

- **baseSpeed**: this is to control the initial speed of them items going down the conveyor belt. This is described as pixels per second. `speed * dt` . The default value is `320`
- **maxSpeedIncreaseMultiplier**: as the game progresses and the score goes up there is a need to increase difficulty. To do so there will be a speed increase that should be capped at a certain point. This is a multiplier applied to the base speed. So a value of `2` would make the max speed `640` with a base speed of `320`
- **speedIncreasePer100Points**: the game awards 100 points per item of garbage that is properly recycled. Each time this will increase the speed by said value. The default is `10`
- **lowestTemp**: the initial temperature will also be the lowest value. Consequently this is also the lowest we can drop the temperature if we recycle properly
- **highestTemp**: this highest temperature of the game and also if hit will cause a game over
- **increaseTemperatureUnitCount**: every time an item goes into the recycler the temp bar will go up and for each properly recycled item of garbage the recycled the temp bar goes down. This is a number that will divide the temp range into evenly. ie. a value of `100` will cause the game to accept a straight 100 items before it quits out.

### Docs Folder

In order to have a landing page to advertise the game that is SEO friendly I decided to host a website in github pages that just takes you to the game. It's not entirely important but it lives under the docs folder. I used rapid weaver to create it. Only reason was so I could do it in 5 minutes.

### Browser Compatibility

Everything seemed to be working fine in safari up until the part where I added sprites and sprite animations. Then safari got super laggy.
