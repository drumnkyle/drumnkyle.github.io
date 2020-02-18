---
layout: post
title: Ensuring Designs Work for All Users With SwiftUI Previews
date: 2020-02-18
tags: 
    - Software Development
read_time: about 3 minutes to read
---

## Introduction
SwiftUI introduced a new way to rapidly iterate your UI using a preview canvas that constantly updates right next to your code. SwiftUI previews also have the ability to show multiple different previews simultaneously.

There are many different ways you can utilize previews; you could even switch between different sets of previews. To take advantage of this new tool, I made an easy way to make sure that the UI you've created will work well in all different configurations, including device type (iPhone, iPad), accessibility features, internationalization, and landscape mode.

If you'd like to skip to the code, it’s all here [gist here](https://gist.github.com/drumnkyle/b936ed856e4d41eb0122d487cc98c24b), covered under the MIT license, so feel free to copy it and do whatever you'd like with it. 

## Developing a Solution
A great aspect of SwiftUI is how you can easily create your own view modifiers that encapsulate multiple other view modifiers and logic within one small, single-line statement. 

Here is an example of a custom view modifier:

<script src="https://gist.github.com/drumnkyle/f2d65ace67d04ad6ed678f2c0adb74f7.js"></script>

I haven't yet found a way to limit a modifier to only be available in a `PreviewProvider`. If you know a way to do this, [tweet at me](https://twitter.com/drumnkyle) or send me a message through the [contact form](https://thisiskyle.me/contact).  

Previews allow you to make a `Group` around a set of different views or configurations to show multiple previews simultaneously. Using this concept, I figured I could make a view modifier that encapsulates the view created for a preview in a `Group` and make multiple versions of the given content with different configurations.

Here is an example of a preview using a group to make multiple previews: 

<script src="https://gist.github.com/drumnkyle/8da86fa3ae4972c14a1ac833a02e3e52.js"></script>

There are 2 cases I want to test: a view that is meant to display full screen, and one that is a reusable component. The cases are different because in the former case, you want to have different device types tested, whereas in the latter case, it is likely a custom size. Therefore, the properties you change for testing on a reusable component are only environment properties like text size and color scheme, rather than device type. With these 2 cases in mind, I created 2 different view modifiers: `AllDevicesPreview` and `AllComponentPreviews`.  

If you have a preview, just add `.allPreviewDevices()` or `.allComponentPreviews()` to your full screen view or reusable component, respectively. You're also able to define multiple cases to preview, such as different sample data. For instance, in this example we set one small string and one long one. Adding the `.allComponentPreviews()` will make 2 previews of each edge case with each set of data. 

<script src="https://gist.github.com/drumnkyle/e8b69ab01c2b402daf05a1b670244982.js"></script>

The `.allPreviewDevices()` modifier also takes in a parameter of `deviceTypes` where you can specify only `iPhone` or `iPad`. If you're in a tvOS target, you can specify `tv`. 

These previews can take a while to render and use a lot of CPU, so I recommend using just a single preview while creating the view. Then, once you finish a certain part of the view and want to check how it performs, add the modifier to see if the design breaks. 

Feel free to reach out to me on [Twitter](https://twitter.com/drumnkyle) or through the [contact form](https://thisiskyle.me/contact) to tell me what you think. 

Here is a [link to the gist](https://gist.github.com/drumnkyle/b936ed856e4d41eb0122d487cc98c24b) with the full code covered under the MIT license, so feel free to copy it into your own project and do whatever you'd like with it 

_Note_: SwiftUI previews are limited to show 15, so I made a decision on what cases I felt were most important and provided the best coverage. Feel free to make your own determination.