---
layout: post
title: Measuring iOS scroll performance is tough. Use this to make it simple & automated
date: 2018-08-28
tags: 
    - Software Development
read_time: about 5 minutes to read
---

## Introduction
iOS Developers who want to create the best experience strive to have a buttery smooth 60 frames-per-second scrolling. There’s nothing more frustrating — both for the user and developer — than having the UI stutter while scrolling. It breaks the illusion of a fluid interface that responds to your every gesture. But now there is an easy way for developers to ensure that scrolling is always nice and smooth. Historically, analyzing scroll performance has been a tedious, manual process that is hard to measure precisely. This process usually involves manually running Instruments on a device, which requires building for profiling (longer build time) and observing the frame rate manually.

I would like to introduce automated scroll performance testing. An important note is that you will need to run these types of tests on a physical device; running on the simulator will not give accurate numbers. In order to get the best data, you should run on an older, slower device that you support to ensure the performance is adequate.

## Analyzing Scroll Performance
I spent a long time analyzing scroll performance and looking at different numbers to understand what criteria can be used to judge the scroll performance of a view controller. The average frame rate is not fine-grained enough to use as a specific measure.

I came up with two metrics that should never exceed a certain threshold. These two numbers combined give you the best picture of scroll performance:
1. Number of dropped frames at any instant
2. Number of times a frame drop event occurs during a single scroll event
A large number of frames dropped at a single instant will cause a very noticeable stop in the fluidity of the interface. Too many frame drop events during one scroll will make it seem like the whole scroll event is sluggish even if the number of frames dropped at a time is small. These limits can change based on expectations of scroll performance and the type of views being measured. 

## Frame Rate Reporter
Below you will see the code for the class that monitors the frame rate and communicates it back to your code. The code hooks into `CADisplayLink` in order to do this. Using the duration of a frame, we compare the current and previous timestamps and divide by the duration to get the number of frames. Using this information, we can calculate how many frames were dropped. We also keep a running count of how many frames were dropped. These values can be reset at any time.

<script src="https://gist.github.com/drumnkyle/89180f310d705df75647e45dc5f8fd59.js"></script>

## Ways To Run Your Test
You can use this class and the associated delegate to either run tests in an automated fashion or run the detector while using your debug app to collect information. You can also choose both.

Other factors can influence your scroll performance that is outside the control of your app. It is important to ensure that there are not many background tasks using up the CPU and GPU while you are running your test. The code below gives you the current CPU and GPU activity. I borrowed this from code that my previous coworker, [Benjamin Hendricks](https://www.linkedin.com/in/benjaminwhendricks/). You can use this to check the activity before each test to ensure a reasonable baseline that will not skew your results.

<script src="https://gist.github.com/drumnkyle/e011bdb3c1419a240788a0cbbbbcc9ce.js"></script>

### UI Tests
For UI tests, you need a method that reliably scrolls at a steady speed. A fast scroll may cause certain optimizations in things like `UICollectionView` or `UITableView`. Also, you need to know when you have reached the end of the scroll view. I tried using both [KIF](https://github.com/kif-framework/KIF) and XCUITest for this purpose. Unfortunately, XCUITest did not allow me to control the speed. I also could not reliably detect when we hit the bottom of the list. Therefore, KIF was my chosen framework. You can use KIF to scroll through a view until it hits the bottom. As you see in the code below, we reset the counts of the frame rate reporter after each scroll is finished.

<script src="https://gist.github.com/drumnkyle/28759b11628eac860e77fb1297cdc7e9.js"></script>

In the GIF below you can see what the test looks like when it runs. We are measuring the frame drops from the time a scroll starts until it ends (comes to rest). Then, we reset the counts and measure on the next scroll event. Using this method, we can know exactly when it fails if it does.

![](/images/scroll-perf-lo-fi.gif)

### While Running Debug Builds
You can also use the frame rate reporter in your app code. The code should be safe to run for production apps and should be able to make it through app review as no private APIs are being used. Therefore, you could set it up to log any time your frame drop limits are hit. Or, you could just run it in debug builds and assert if your limits are hit. I'd love to hear about the ways you use it for your app.

## Writing Your Test
You can use this framework to test the scroll performance of two different kinds of elements: a view controller’s view, or a single UI component. Measuring scroll performance at a view controller level will quickly verify that the interaction of many different components will not cause any scroll performance degradation. However, if you are building a shared component for use throughout your app, you can catch any issues early on if you test that single component in isolation.

### KIF
In order to write an automated UI test to test scroll performance, you need to set up a test app. If you are testing your app’s view controllers, you will want to ensure you have accessibility identifiers for the controls that will take you to the correct view to test. Also, you’ll need an accessibility identifier on the table or collection view to scroll. If you want to test single views in isolation, you should create a separate test app and create a collection view or table view with many different versions of that view. You will see an easy way to create this in the next section. 

### LayoutTest
In order to ensure optimizations of classes like `UICollectionView` and `UITableView` are not triggered, you want to make sure that your rows have different data and/or configurations. A great way to ensure this is to use a library called [LayoutTest](https://github.com/linkedin/LayoutTest-iOS). If you haven't seen this library, please take a look at what it does. I am a huge fan of this library and was working with the author, [Peter Livesey](https://www.linkedin.com/in/pdlivesey/) when he was building it. The specific feature of LayoutTest I suggest using for your scroll performance tests is called [Catalog](https://linkedin.github.io/LayoutTest-iOS/pages/060_catalog.html). You can learn more about this feature and how to use it by watching [this video](https://www.linkedin.com/learning/learning-layouttest-for-ios-development/using-catalog-view) from [my course on LinkedIn Learning](https://www.linkedin.com/learning/learning-layouttest-for-ios-development/) on LayoutTest.

LayoutTest’s Catalog feature can be used to write a scroll performance test for a single view like a custom button, a particular type of cell, etc. The Catalog feature creates a view controller with every possible combination of specifications for that view very easily. The result is a perfect sample test app with a long, scrolling view of all of the different ways this view can be laid out. Every edge case of your layout will be tested to ensure it doesn't degrade scroll performance.

## Thanks
Special thanks to [Benjamin Hendricks](https://www.linkedin.com/in/benjaminwhendricks/) for writing the code that was the basis for this project. Also, special thanks to [Peter Livesey](https://www.linkedin.com/in/pdlivesey/) for creating the awesome LayoutTest library that continues to be extremely useful.

I hope you can use this code to help you improve the performance and user experience of your apps! Please let me know your experience by visiting the Contact page of my site.

You can see a gist with all of the code from this article [here](https://gist.github.com/drumnkyle/37665e4534cd5b7609d7b4592b10b603). Please feel free to use it as is in your own projects.