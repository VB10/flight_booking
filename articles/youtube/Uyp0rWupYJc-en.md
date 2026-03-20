# Flutter Refactoring Masterclass: 7.1 - View-ViewModel-Mixin Architecture (Prompt + Skill)

> Translated from Turkish YouTube video

## Video Metadata

| Field | Value |
|-------|-------|
| **Original Title** | Flutter Refactoring Masterclass: 7.1- View-ViewModel-Mixin Yapısı (Prompt + Skill) |
| **Channel** | HardwareAndro |
| **Duration** | 15:54 |
| **Category** | Education |
| **Upload Date** | 2026-03-06 |
| **Video ID** | Uyp0rWupYJc |

---

## Description (English)

Hello! In this episode of our Flutter Refactoring series, we're tackling the heart of our project - the Login Module. In this video, we're not just reorganizing code; we're also developing a new "Refactor Command" to automate our workflow and speed things up.

**What Did We Do?**

With this update, we made radical decisions to reduce technical debt and increase sustainability in our project:

**Architectural Transformation:** We separated the Login module from its classic structure and divided it into View - ViewModel - Mixin layers. This way, UI (Interface), Business Logic, and Reusable Behaviors are completely isolated from each other.

**Automation Power:** With the newly added Flutter View Refactor command, we can automatically migrate our modules to a standardized structure.

**Dependency Management:** We updated all package dependencies for project health and clarified our v7 roadmap in the todo.md file.

**Technical Summary:** We made approximately 1000 lines of improvements across 13 files.

**Technical Details You'll Watch:**
- Application of Separation of Concerns principle
- State management organization with ViewModel
- Preventing code repetition using Mixins
- Project planning discipline through todo.md

**For Those Who Missed the Previous Video:** https://youtu.be/2-Q91EDSiTg

**Timestamps:**
- 00:00 Introduction and General Statistics
- 02:15 Introduction to the New Refactor Command
- 05:30 Login Module: Transition to MVVM Structure
- 10:45 Mixin Usage and Advantages
- 15:20 Dependency Updates and Closing

https://github.com/VB10/flight_booking

**Technical PR Summary:**
- Change: +946 lines added / -197 lines deleted
- Focus: Improving code organization and establishing sustainable architecture
- Branch: All changes successfully integrated into main branch

To review the GitHub project: https://github.com/VB10/flight_booking

Don't forget to subscribe and turn on notifications! Enjoy watching.

---

## Tags (English)

`mobile`, `flutter`, `use case`, `refactoring`, `masterclass`, `MVVM`, `clean code`, `mobile development`, `flutter architecture`, `software engineering`, `flutter tutorial`, `programming`, `viewmodel`, `mixin`

---

## Full Transcript (English) - Timestamped

**[00:00]** Hello dear friends. I hope you're doing well. Health and wellness to you. I hope you're living a good life with your family and loved ones. If you're looking for a job, may good opportunities come your way. If you're working in good teams, I hope you're getting the recognition you deserve. I hope you have managers who understand you and whom you can communicate with. Let's start with good intentions. Now let's get straight to business, dear friends. Today we're actually in the Refactoring Masterclass series.

**[00:30]** In the Refactoring Masterclass series, we're now moving to video 7. For those joining for the first time, you can access all the videos from here. So far in 6 episodes, we've reviewed the project and looked at the code. We worked on the package architecture. I think this might have been misnamed - I'll fix that. We've set up our structure here. Finally, in the 6th episode friends, our project is ready and...

**[01:00]** After the last one, I've now integrated prompts and skills into the project. In this video, dear friends, I'll talk about one of the most important parts of the project - the View-ViewModel-Mixin structure. I'll explain this without any packages for now so you get the concept. After that, I'll discuss widget composition - breaking down widgets. Following that, I'll show you the clean code version of the existing login module.

**[01:30]** I've prepared all of this. I've prepared the prompts. I've prepared the skills. At the end of the day, you'll be able to take these into your own projects - watch and understand here, then quickly use those skills in your own projects. Now, before getting into the technical details, let me quickly explain the problem here. Then we'll move to the solution architecture. In many projects, I see these kinds of architectural approaches and mistakes.

**[02:00]** The most obvious problem here is, for example, in a page file, a view file - especially in Flutter - I can't reach my build method. I can't see it right now. It's somewhere way down there. This is the problem. In simple terms, we need to separate the view and the view's logic. When I say view logic, I mean things like button presses. But when I say "save this to the backend," that's the view's business logic.

**[02:30]** We need to separate these here. First point. Second, within these layers, we should never directly use third-party packages. I'll explain that in another video. There's that part too. Additionally, friends, the code inside views needs to be separated into sub-widgets, dedicated components, making them more readable and accessible. We'll clean these up using part and part of directives with view structure.

**[03:00]** Following that, I haven't integrated localization support yet, but we will. We won't use sized boxes like this. We already wrote code for packages like our AppSizer from the previous video. We'll use those here so our project structure stays standard. And after doing all of this, when I come back and look at this, friends, I'll be able to ask "what is this login page, what does it do" and see a clean structure.

**[03:30]** I've seen many projects, a lot of code - especially on the frontend, where people say "it's just UI, nothing special" - and when you look at the UI it might look nice, but the backend is full of terrible code. Based on this, don't say "is this how it's written?" I've seen it a lot. These approaches, these ideas here - the mapping, the modeling - we'll discuss all of these.

**[04:00]** I'm specifically talking about this in this video because I've seen so much of it everywhere. So we've now mentally framed the problem. What is the actual issue? What's the fundamental logic? What do we need to do? Where do we need to get to? We've now roughly outlined three things in our heads. So what will we do? As I said, since this is a Refactoring Masterclass, I won't tell you "take this, convert it, do that refactor."

**[04:30]** I've already prepared the architectural approach and solution for you. As I mentioned, in all these videos, I'll focus more on giving you ideas. There's no need to write code from scratch anymore in this era. We're all aware of that. Let's get the idea, and after getting it, use it with the right prompts and texts. Let's develop these ideas and grow them according to our project situations.

**[05:00]** Now friends, look - what I've directly done, and the prompt is ready right now. The change you see before you with everything included is right here in front of your eyes. When you look here, just seeing this brings relief compared to what it was before. Because there's clean usage. The view is broken down. Mixin is done. I know where my model folder is. I know where my view layers are. ViewModel is added. Page body separates the login inner pages. I'm aware of all this.

**[05:30]** Almost everything I want is here as an architectural approach. I have it ready and I'm using it from here. Here, for example, I'll explain what we'll do. We might add more, but what have we changed now? First, as you noticed, we're making our classes final. Always - unless we're inheriting from somewhere, and generally in Flutter we don't do that inheritance. That's also the widget composition approach.

**[06:00]** We constantly break down into sub-widgets. At this point, as much as possible, you break structures down and by making them final, you ensure build-time performance and prevent any class from being inheritable. This is the first rule. The second rule - my fundamental point - is that when I look at the View, I should only see View code. When I look at the View, I see my AppBar, my scaffold, my inner pages. These are managed and it continues from there.

**[06:30]** What I've done here with login page body - there's a class you see here. There are actually some sub-modules here. For now, I've put them together here, but normally I'd do this differently. For example, if I come here, let me show you more simply. Let's say I have a login test account info field. Normally I'd come here and create login test account info. I'd extract it here. Then I'd come here, quickly add a part of reference.

**[07:00]** This will actually be directly with login page. I'd add it like this with login page. Then when I come here, friends - did I use the widget correctly? I've parted it inside the view widget. The part of here is probably wrong. Let me fix this. Added another one. Click, it's done. Since there's only one more of these, it's complaining about that. Actually, the most correct approach here, the cleanest approach, friends...

**[07:30]** ...is for all of these to be here. Also, if I take it like this, it'll fix itself. These sub-widgets - I've broken down all my components below like this. Such partitioned widgets - you can create them as sub-widgets if you want. Or make them private like this. No other class can access them. It's used very quickly. And each has its own sub-widgets that do their job and continue the game. This is the most basic approach. In all architectures, we'll divide into sub-widgets and manage privates.

**[08:00]** Internal page items - if they're going to be used in 3-4 pages as a shared layer, we'll put them in a public place. Moving to the second point, friends, when we look at the login page in our review, the point I care most about is page mixins. You can use mixins in all widgets here or in any class. A mixin is basically an abstract class. We can't have constructors. The fundamental mentality here is like a plugin that we write before the class.

**[08:30]** We integrate features and by also integrating state, we say only those who inherit from this can use it - an approach no one can use arbitrarily. The main point here is collecting everything the view uses - controllers, methods if any - I collect them all here so I can see what the controller does, what my view does. Of course, as view logic grows and goes into many sub-branches, I separate the business-level ones anyway.

**[09:00]** But for example, in sub-widgets, when I press a button, onPress will have loading. There's no point in passing the whole login page. The button should manage that itself - you'll make these decisions as you progress. Now I've placed my methods here. I've set up all my disposals. I've put them cleanly. One important approach I'll recommend - I see a lot of setState patterns. For sub-widgets, like a button's loading state, it's a very simple state and management.

**[09:30]** You can manage that with setState. But when there are states forming within the page and page content - if you haven't yet adopted state management, which you don't need initially, it's quite sufficient - for example, ValueNotifier and a simple immutable class you write before the ValueNotifier. As you see here - actually, no need to add comments to these, that was just thrown in. Let me add it here like this.

**[10:00]** By creating an immutable class, instead of saying setState, setState everywhere, you're actually creating an object that you'll manage your page with very simply using ValueNotifier. For example, who's using this here? Who's using the state? Is anyone setting the state here? For example, do you see state here? I said value. State. Value - go, buddy, I'm updating with copyWith. When this updates, automatically if anyone is listening to this in the view, it will be triggered automatically with ValueListenableBuilder.

**[10:30]** This is a nice usage. It's a clean usage, and as you see here, there's quite clean usage. By the way, I want to specifically show this - as I said, you don't have to use anything. In this Flutter community, state management is heavily pushed on you. It doesn't mean much. Because logic and depending on the domain, everything is sufficient. Code is written based on need. Life is always like this. There's no meaning and no benefit to anyone in creating a huge clinic architecture for a three-line project.

**[11:00]** Here you can write much simpler tests and solve your issue. That's why, for example, what I'll show you here is a simple ViewModel layer with no special features. Nothing extra. Just a class and placing methods inside - you know what this provides me? When I look back, there's my view, my view's mixin, my mixin has view logic. My ViewModel has business - what is business? Work, meaning login, log successful, save to user cache, login command - if these exist, we'll update them.

**[11:30]** But as a simple concept, this is quite sufficient. I need to say these should also be here. I said it. OK. I now know where everything is here, and at least I know where I'm going and what I'm running towards. By creating a class like this and collecting inside, your objects become delightful. You might say "but these are the lowest level classes and widgets" - state management will really help you at those points. We'll discuss those too.

**[12:00]** This is the most primitive, simplest way you can clean up - solutions that you can very easily integrate into any of your widget views, not just any view but any stateful class, any stateless class - I'm showing you now. I'm sure these methods will be useful to you in many places. Breaking down sub-classes with parts and part-of, giving relevant fields to relevant objects, using ValueListenableBuilder, keeping objects clean, adding finals, making them immutable...

**[12:30]** Then creating a model and inside the model - for example, login response model - I haven't gone into it yet, I'll explain in the next video about fixing the service layer and model layers. For example, this is wrong, we'll fix this too. But for example, my state object exists - I did the state properly. Being immutable is very important. For references not to shift and when you set multiple objects or in such situations, it's quite important for not having problems.

**[13:00]** We're setting these. Beyond this, for example, we're setting the login view model here. I already mentioned we collected the login page. We collected our objects here. We separated the ViewModel, page mixin, body. Basically, friends, any Flutter View - as long as you do this breakdown - you'll progress cleanly. It's quite a nice approach. What have we actually done? We took our view. The messy, nested code - we extracted all of it.

**[13:30]** We extracted our response model. Created a widget folder under model and put our privates. Put the body. On top of that, by designing a mixin structure, we separated the view's logic. By adding state, we made the view even better. We got rid of setState. We said let only the necessary parts be triggered. Finally, by writing a small layer like login ViewModel, without any management, we very simply managed that business layer - the backend interactions.

**[14:00]** And at the end of the day, as a developer, when I come here and look, I can very easily see what went where, how, and what was done, dear friends. Now this is the main idea I'll give you. If you want to use this for yourself - I use it depending on the situation. I use it in Claude. I use it in Gemini. That doesn't matter. What matters is the prompt I produce and the area.

**[14:30]** Now, friends, under the documentation, I've created a prompt called view refactor. If you want, you can take this view refactor prompt. On any of your pages, just taking this view prompt and saying "fix my view" is enough to use this prompt. You don't need to do anything else to use this prompt. Actually, if a friend watching this video wants, they can fix other pages and send a PR. But this prompt will be quite sufficient for you.

**[15:00]** Everything I've done is in this prompt. Also, I deliberately didn't add git ignore to Claude so you can see. I also created a skill. By taking this skill and using it at any moment in any project, you'll be able to get this clean structure for yourself. For example, what else did I add? AppSize usage. If there are static values on the page, read them from web size. Themes coming here and so on. I tried to add all of these into the prompts and skills.

**[15:30]** I created these here. If you want, by using these prompts and skills, you can bind your pages very cleanly and progress, friends. I'm saying this. Also, finally, dear friends, I've committed what we did. Let me get the final version of what we did. Done, committed. I already created my branch. Coming to the todo. From the planned items, friends - this V7 first one, I changed the order a bit because I thought it was more important, so I explained the ViewModel mixin.

**[15:54]** In the next one, I'll move to service and model. This duplicate will be fixed. Then some state management - like this, we'll save this project. At the end of the day, we'll have many prompts, many skills, and we'll integrate these according to ourselves. Thank you again for listening. I hope it gave you some ideas. I'm posting the PR as of now. Those who want can look at the PR. Those who want can integrate other pages as I mentioned. You can send me a PR. You'll see depending on the situation. Thank you for your effort and work in advance, friends. Good luck. See you in the next video. Just pushed the PR. Yes. Done. See you, dear friends. Yeah.

---

## Copy-Paste Section

### YouTube Title
```
Flutter Refactoring Masterclass: 7.1 - View-ViewModel-Mixin Architecture (Prompt + Skill)
```

### YouTube Description
```
Hello! In this episode of our Flutter Refactoring series, we're tackling the heart of our project - the Login Module. In this video, we're not just reorganizing code; we're also developing a new "Refactor Command" to automate our workflow.

What Did We Do?

Architectural Transformation: We separated the Login module from its classic structure and divided it into View - ViewModel - Mixin layers. This way, UI, Business Logic, and Reusable Behaviors are completely isolated.

Automation Power: With the newly added Flutter View Refactor command, we can automatically migrate our modules to a standardized structure.

Dependency Management: We updated all package dependencies for project health and clarified our v7 roadmap in the todo.md file.

Technical Summary: We made approximately 1000 lines of improvements across 13 files.

Technical Details:
- Separation of Concerns principle application
- State management with ViewModel
- Code reuse with Mixins
- Project planning through todo.md

Previous Video: https://youtu.be/2-Q91EDSiTg

Timestamps:
00:00 Introduction and Statistics
02:15 New Refactor Command Introduction
05:30 Login Module: MVVM Transition
10:45 Mixin Usage and Benefits
15:20 Dependency Updates and Closing

GitHub: https://github.com/VB10/flight_booking

Technical PR Summary:
+946 lines added / -197 lines deleted across 13 files

#Flutter #FlutterRefactoring #MVVM #Dart #CleanCode #MobileDevelopment #FlutterArchitecture #SoftwareEngineering #FlutterTutorial #Programming #Refactoring #ViewModel #Mixin
```

### YouTube Tags
```
mobile, flutter, use case, refactoring, masterclass, MVVM, clean code, mobile development, flutter architecture, software engineering, flutter tutorial, programming, viewmodel, mixin, dart, android, ios
```
