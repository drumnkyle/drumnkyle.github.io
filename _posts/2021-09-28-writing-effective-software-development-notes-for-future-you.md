---
layout: post
title: Writing Effective Software Development Notes for Future You
date: 2021-09-28
tags: 
    - Software Development
read_time: about 4 minutes to read
---

Have you ever found yourself saying, “I feel like I've solved this type of issue before, but I can’t remember how I did it”? Have you found it difficult to come back to a task once you've been interrupted? These issues can be solved by taking notes during development. I started experimenting with taking notes quite a few years ago and found the benefits to be quite substantial. It may sound like just another thing for you to do. Through this article, I will show you how it can be very little effort and very effective for solving these issues and making you a better, more organized, and more efficient developer. 

## What Kind of Notes?
The purpose of this style of note-taking is to be thorough. This allows you to search through this text later. The notes should be detailed enough to be able to transport yourself back into the code later, the way you were engrossed in the problem when you first worked on it. With these goals in mind, it’s best to write these notes in a step-by-step, stream of consciousness style. This allows you to be transported back into your consciousness very naturally. Write as if you were explaining to someone every step of what you’re doing. 

To write verbose notes that don’t become unwieldy, an outline format using headings, subheadings, and bullet points is best. This enables you to section off approaches you explore and ideas you have and make bullet points for the steps you take with sub-bullets for detailed sub-steps.

## Why?
Taking notes in this fashion has many benefits, such as:
- Easily come back to a problem after being distracted or away from the problem
- Be able to search all text to find problems you've solved before, which are similar to the one you're facing now
- Provide information on alternative approaches and reasoning for your solution to other developers
- Provide context for later in the future when you may leave and others need to work with your code
- Stay focused

## Writing the Notes
### Picking your tool
First, you should pick an app. The best thing is to research and pick one app and stick with it, so you don’t waste time moving between apps often. I've tried quite a few, and here are the requirements I think it should have:

#### Requirements
- Spell check disabled for marked blocks of text
- Doesn’t autocorrect in bad ways in these marked blocks
- Export to PDF
- Export to plain text
- Allow for writing structured code within it

#### Nice to Have
- Helps with code indentation
	- At least doesn’t actively work against you
- Outline view
- Drawing for diagrams
	- Searching of handwriting
- Syntax highlighting
- Links to other notes
- Tagging
- Collaboration

#### Apps I Recommend
I have found 2 apps to be most useful for these types of notes: [Ulysses](https://ulysses.app/) and [Bear](https://bear.app/). Both of these tools offer great organization options for your notes like tagging, folders, and advanced filtering. They also both have numerous helpful export options. This allows you to be able to move your note to another tool or share with others easily. They both use a form of Markdown for writing, which I find very natural and easy for making this type of outline notes and writing code within your note. 

### Note Structure
#### Individual note structure
The way you organize your note can help you organize your thoughts. Let's start with the title of the note. You should have a title that reminds you of the problem you’re trying to solve. I also recommend mentioning a task number if there is one that you can associate with the task or bug in the task management system you use. This way, you can search through your notes effortlessly. 
I recommend always having a short overview section of what you are trying to do in the task. 

Depending on how much you already know about the problem, the organization after that can either be set up initially or will present itself to you as you move through solving the problem. The process I usually follow goes something like this:

- Start with an Investigation section
- Use bullet points for each thought I have or strategy I try
- Indent as I go off in a specific direction to keep my bullets short and organized
- As I find that there is a particularly long sub-bullet section, pull that out into its own sub-heading

Oftentimes, I find that a direction I went down didn’t prove fruitful. In this case, I don’t delete my notes, I simply start a new main heading and potentially rename the last one. At this point, I understand the problem more and can give this new section a better title than just Investigation. 

In the end, my note structure ends up looking something like this:

```md
# <taskNumber> Implement cool feature
_link to task_

## Overview
Short summary of task

## Investigation
- Short bullets following my thought process
	- Sub-bullets for steps related specifically to the parent bullet

### Unexpected difficult situation
- Subheadings like these throughout to keep nesting shallow

## Implementation
- Step-by-step implementation
- Throughout the note always use full `MyClass` and `myFunction` names to make searching easier

### Bug: Something isn't working
- If I encounter a bug during implementation
- This helps if you run into this again as a regression if you change things later
```

To keep track of all my notes, I like to add “In Progress” and “Completed” tags to my notes. There are also times when you start a task and end up abandoning it. In that case, I can remove the “In Progress” tag, but not add the “Completed” tag. This way I can filter by these tasks that were abandoned if I want to pick them up later. 

### How Note-Taking Supports Effective Software Teams
Make sure that you keep all of these notes in a searchable format, so you can get the benefit of learning from past problems you've solved. Furthermore, it can be very helpful to put the note, or a modified overview of the note, in that task management system you or your team use, like Jira, Notion, GitHub, etc. Taking this thorough approach to documentation helps other developers understand why you made specific changes when they reference source control commits, particularly as code ages and team members change. 

## Conclusion
In addition to this type of notes, I also utilize diagrams (like UML class and sequence diagrams) and create test projects, so don’t feel bound to only use this format. I will potentially be writing a post about how I use diagrams and test projects. Reach out to me if you are interested in this topic. I highly recommend trying out this note-taking approach. I have been doing it for a few years now and have been shocked by how much benefit it has provided me. Others I have told about this approach to note-taking have echoed similar sentiments back to me. If you do try this, please let me know how it goes. Please don't hesitate to reach out using the contact form in the About Me section of this site.