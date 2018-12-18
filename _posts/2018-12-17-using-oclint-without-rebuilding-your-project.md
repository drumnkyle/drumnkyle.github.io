---
layout: post
title: Using OCLint Without Rebuilding Your Project
date: 2018-12-17
tags: 
    - Software Development
read_time: about 6 minutes to read
---

## Overview
For those of you still using Objective-C in your iOS projects, [OCLint](http://oclint.org/) is a [linter](https://en.wikipedia.org/wiki/Lint_(software)) for Objective-C that is often stated as the best. If you go through the standard steps to setup OCLint from a tutorial or on their site, they will instruct you to build your app separately with `xcodebuild` in order to run OCLint on your project. This means that if you build in Xcode, you'd have to build it twice. I didn't want to double our build time in order to be able to even run OCLint, so I decided to see if I could figure out how to avoid this requirement.

Before we go any further, I want to let you know upfront that I didn't get to a fully working solution. This article is about my process and showing the trade-offs I made and how far I was able to get. There is still a mostly working solution by the end. I encourage you to read on. 

You can also download my finished scripts [at this gist](https://gist.github.com/drumnkyle/b4328e7447b63af88e6f9a9daecc918d). 

## Finding a Solution
I investigated what OCLint needed to run. It simply took the build log of `xcodebuild`, ran it through `xcpretty`, and used it as input. I figured Xcode must generate the same output as `xcodebuild`. My plan was to find where Xcode stored the log, get that file, and run it through `xcpretty` the same way `xcodebuild`’s output is run before sending it along to OCLint via `oclint-json-compilation-database`, which will run OCLint on your project. 

### Using the Xcode Log
I looked around in the Derived Data folder since that is where all of the build related files are stored. I found a folder named `Logs` with a subfolder named `Build`. There you will find multiple folders named with a random UUID. However, you know that the most recently modified file will be the one you want since you will be running this right after your build finishes. 

The file type is `xcactivitylog`. So, I googled a bit for this and found a [helpful article from Michele Titolo](https://michele.io/test-logs-in-xcode/). The file is actually a gzip of the log. So, I renamed it to have the extension `.gzip`. Double-clicking it gave me another file that I then tried changing to a `.log` file extension. This worked! I then found [another article by Joe Burgess](http://joemburgess.com/2014/10/04/diving-into-xcode-logs/) that confirmed they had gone through a similar process, though for a different reason. 

Now, I needed to run this file through `xcpretty`. Surprisingly, `xcpretty` took several hours to run to completion. I then looked and saw this was a 2MB file. Apparently `xcpretty` was not optimized for processing a large file. I seemed to hit a dead end.

### Using a Deprecated Tool
Just when all hope seemed lost, I found a deprecated tool in OCLint called `oclint-xcodebuild`. This tool was meant to take an xcodebuild.log file and turn it into a JSON file for use by OCLint. Though it was no longer maintained, I figured I'd try it and see if it worked on my file. So, I renamed my file to the expected `xcodebuild.log` file. 

This didn't work at all. However, I quickly found that it was because the [line endings](https://confluence.qps.nl/fledermaus/questions-answers/other/differences-in-end-of-line-characters-mac-windows-and-linux) were classic Mac style instead of the needed Unix style. So, I opened the file in Sublime Text and converted the line endings just to test if it would work. To my surprise, it ran extremely quickly and output the expected `compile_commands.json` file. 

### OCLint Error
When I tried to finally run this file using the `oclint-json-compilation-database` command, it failed with the following error: 

> oclint: error: one compiler command contains multiple jobs

I googled this error and found [this issue on the OCLint Github.](https://github.com/oclint/oclint/issues/462)I tried setting `COMPILER_INDEX_STORE_ENABLE` to `NO` as was suggested. This worked, but when I looked into what this flag did, it would not be great for the developer experience when using Swift; this disabled indexing while building. 

So, I diffed the JSON file with the flag on and off to see what the differences were. I found the following line was present when the flag was not set to `YES`:
> -index-store-path /Users/ksherman/Library/Developer/Xcode/DerivedData/\<project-directory\>/Index/DataStore

To test if this was the only issue, I simply did a find/replace to remove that text anywhere in the file. This worked! This is definitely quite a hack that is likely necessary because this particular OCLint tool is deprecated. In this case, I felt it was worth using this hack as this is a tool and will not affect our users if it breaks. 

## Scripting the Solution
I want to be able to run this process from a script within Xcode. This way I can run it on every build and show errors and warnings inline within the Xcode interface.

_If you'd like to skip to downloading the scripts I made, I have posted them [in a gist here](https://gist.github.com/drumnkyle/b4328e7447b63af88e6f9a9daecc918d)_.

First, I needed to find where the logs were stored from the script. I knew that the build system provided different environment variables that give you information and paths that are useful. I found[this link](https://help.apple.com/xcode/mac/8.0/#/itcaec37c2a6)that lists all the different environment variables available.  I searched through this list for the best candidate: I found `BUILD_DIR` to be the closest path. 

I then needed to find the right log file, so I used the `ls` command to list the files with the options `-t1`. `t` sorts them by last modified and `1` shows one line at a time so I can extract the path I need. 

I needed to convert the line endings with a command line tool. The fastest way I found to do that was the following command:
```bash
tr '\r' '\n' < inputFile > xcodebuild.log
```

I wanted to write a Swift script as it's faster for me to write code in Swift than Bash since I'm not very well-versed in Bash scripting. So, you'll find that my scripts are split between the 2 types. 

Feel free to explore the scripts. I also left code in there to help with debugging issues. I'm not extremely proud of the quality of the code, but it does its job. 

## Uncovering a Big Problem
I thought I had done it; it was working! But then, I ran it in our CI builds using Jenkins and it failed. This is when I realized it was always failing after a clean build. This was because the log file was not written to the directory until after the build completes. The build doesn't actually finish until all of the Run Script phases had finished. 

This means that my script was always operating on the build log of the previous build. I needed to execute my script after the build was done, but I couldn't find any way to do this using Xcode options. 

## A Workaround That Only Slightly Works
I was about to call it quits and just say we wouldn't have OCLint for our builds. I came up with one final idea: I could background the task so that the build would finish before my script started. 

The biggest problem with this solution is that I could not find a way to report the errors in Xcode from the backgrounded script. I decided to just make it work enough so I could claim some victory and not have this all be a waste of time. I made my script output the results to a file that I added to the Xcode project. Every time my script ran, it would delete that file. This means you at least get the visual indication of red text for the file name in Xcode when the script starts because the file is missing. Then, the text will change back to the standard black color (in light mode) once the script finishes. You can then just read the results. 

To accomplish this, I added the following as a Run Script in Xcode:
```bash
source ~/.bash_profile
cd <path to oclint scripts>
nohup ./run_oclint.sh -b=${BUILD_DIR} -e=${PROJECT_DIR}/oclint_exclusions -r=${PROJECT_DIR} -p=${PROJECT_DIR} &> ${BUILD_DIR}/oclint_output.log &
```

## A Call for Help
This is as far as I got. I'm posting this to show my complete process so that others can learn from it. I'm also hoping maybe someone will read this and have an idea.

I hope this will also encourage others to post stories of their development that didn’t quite work out. Whether we are early in our career as a developer or very experienced, we all have problems for which we just aren't able to find a good solution. In my opinion, these stories are important to hear about, just like the successes. 

Again, you can download [all my scripts at this gist](https://gist.github.com/drumnkyle/b4328e7447b63af88e6f9a9daecc918d). 