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

Hello! In this episode of our Flutter Refactoring series, we're tackling the heart of our project: the Login Module. In this video, we don't just clean up code — we also develop a new "Refactor Command" to automate the process and accelerate our workflow.

What Did We Do?
With this update, we made radical decisions to reduce technical debt in our project and improve sustainability:

🏗️ **Architectural Transformation:** We separated the Login module from its classic structure and split it into View — ViewModel — Mixin layers. This way, UI (Interface), Business Logic, and Reusable Behaviors are completely isolated from each other.

🤖 **Automation Power:** With the new Flutter View Refactor command we added, we can automatically migrate our modules to a standard structure.

📦 **Dependency Management:** For project health, we updated all package dependencies and clarified our v7 roadmap in the todo.md file.

📊 **Technical Summary:** We carried out approximately 1000 lines of improvements across 13 files.

Technical Details You'll Watch:
- Application of the Separation of Concerns principle.
- State management organization with ViewModel.
- Avoiding code duplication using Mixins.
- Project planning discipline through todo.md.

For Those Who Missed the Previous Video: https://youtu.be/2-Q91EDSiTg

Timestamps:
00:00 Introduction and General Statistics
02:15 Introducing the New Refactor Command
05:30 Login Module: Transition to MVVM Structure
10:45 Mixin Usage and Its Advantages
15:20 Dependency Updates and Closing

#Flutter #FlutterRefactoring #MVVM #Dart #CleanCode #MobileDevelopment #FlutterArchitecture #SoftwareEngineering #FlutterTutorial #VeliBacik #Programming #Refactoring #ViewModel #Mixin

https://github.com/VB10/flight_booking
Technical PR Summary:
Change: +946 lines added / -197 lines removed.

Focus: Improving code organization and building sustainable architecture.

Branch: All changes successfully integrated into the main branch. 🎉

If you'd like to check out the GitHub project: https://github.com/VB10/flight_booking

Don't forget to subscribe and turn on notifications! Enjoy watching.

---

## Tags (English)

`flutter`, `flutter refactoring`, `mvvm`, `dart`, `clean code`, `mobile development`, `flutter architecture`, `software engineering`, `flutter tutorial`, `viewmodel`, `mixin`, `view model`, `separation of concerns`, `masterclass`

---

## Full Transcript (English) - Timestamped

**[00:00]** Hello dear friends. I hope you're well. Health and wellbeing are good. You're living a beautiful life with your family and loved ones. If you're looking for a job, good opportunities are with you. If you're working in good teams, hopefully you're getting the recognition for your effort in the teams you work with. You have managers who understand you and you can communicate with — let's start optimistically. Now let me get straight to the point, dear friends. Today, with all of you, we're in the Refactoring Masterclass series.

**[00:30]** In the Refactoring Masterclass series, we're now moving to the 7th video. For friends joining for the first time and so on, you can already access all the videos from here. So far in 6 episodes, we've examined the project, looked at the code. Package architecture, package dropdown — that probably got applied or there's a typo in the name. I'll fix it. Here, we set up our structure. Lastly, in the 6th episode, friends, we entered into the project and I started with masterclass theme cleanup, and

**[01:00]** after the last one, I started integrating prompts and skills into the project. Now in this minimal episode, dear friends, in this video I'll be talking about one of the truly important parts of the project — the View-ViewModel-Mixin structure. I'll be explaining this currently without any packages or extras so you can grasp the idea. After that, I'll talk about widget composition — meaning the breaking down of these widgets. And subsequently, I have right in front of me the existing login, login response, login

**[01:30]** code. I'll be showing you the clean-code version of these. I prepared all of this. Prepared the prompts. Prepared the skills, and at the end of the day, you'll be able to easily take these to your own projects — both watching here and understanding, and then quickly using your own project with those skills, dear friends. Now before quickly moving on to the technical details for the prompt, I'll first quickly explain the problem here, and then we'll proceed with the solution architecture. Now friends, in many projects this and these

**[02:00]** kinds of architectural approaches and mistakes are something I see. The most obvious problem here, for example: in a page file, in a view file on the Flutter side specifically, I can't reach my build method. For example, this is one of the biggest problems. I can't see it right now. This is somewhere way down — for example, this is a problem. So basically, in the simplest math, we need to separate view and view's logic. Look, what I call the view's logic is pressing buttons and so on. But for example, the View, "go save this in the backend" — that becomes the View's

**[02:30]** business actually. Now we need to separate these here. That's first. Second, again within these layers, we should never directly use third-party packages. I'll cover that in another video already. There's that part. Subsequently, friends, the code inside views also needs to be split into sub-widgets, into their own components, sub-widgets, to become more readable and accessible. For this, we'll be cleaning these up by playing with `part`, `part of`, view structures.

**[03:00]** Subsequently, although I haven't integrated this yet, we'll integrate localization support. We won't use SizedBoxes this way. We already had code we wrote in the previous video like AppSizer packages. From here, for example, we'll get them so that our project structure is standard. And after doing all of this, dear friends, when I look back, I want to be able to look at the LoginPage and quickly see, "Login page — what was this? What does it do?"

**[03:30]** I've seen many projects, seen a lot of code, especially on the front-end side — really, a lot of "no big deal" attitude. Or when you look at the UI, the UI might be impressive at the moment. Maybe right now nothing's wrong, but in the future stages, let's say because of how nice the UI looks, the back side is filled with such bad code — I've seen this. Looking at this, "is this how it's written?" — don't say that. I've really seen a lot of these, and these approaches: like the

**[04:00]** mapping of these, the modeling — which we'll also be discussing — they're connected this way everywhere. I see this a lot, that's why I'm specifically talking about this in this video. Now we have this in our minds mathematically. What's the actual problem? What's the basic logic? What do we need to do? Where do we need to get? Roughly we've now mentally constructed it. So what will we do? Now, as I said, since this is the Refactor Masterclass, I won't be talking to you directly about the code

**[04:30]** because in advance, friends, I prepared the architectural approach, the solution, all of it. As I said, in all of these videos I'll be giving more ideas. There's no need to write code from scratch in this era anymore. We're all aware. Let's take the idea. After taking the idea, let's use the right prompts, the right texts. Let's evolve these ideas and progress according to situations in our projects, grow them. Now friends, look — what I directly did, and the prompt is now ready. With everything together, the change in front of you is directly here

**[05:00]** before your eyes. Just looking at this — even the human eye relaxes when you think about how it was before. Because there's clean usage. Views are split. Mixin is done. Model folder. I know where my model is. I know where my View layers are. ViewModel was placed — for example, I'm aware of that. For example, with PageBody, the inner pages of login are split — I'm aware of that. So almost everything I want here, in terms of architectural approach, is ready in my hands and I

**[05:30]** use it from here. Here, for example, I'll explain what we'll do. Maybe we'd add extra things, but what did we change now? First, at the start — I don't know if you noticed at the very beginning — for example, we make our classes `final class`. Always — meaning if we're not inheriting from somewhere, and generally on the Flutter side we don't do this kind of inheritance. There's that widget composition approach already. We constantly break things into sub-widgets. At this point, going for codeexion as much as possible. As much as you can, friends, breaking the structures up

**[06:00]** and applying `final` — both for build-time performance and to ensure a basic class isn't inheritable — we pay attention to. So this is the first rule. Now the second rule — actually the most basic thing I do is this point: when I look at View, I should only see View code. So I look at View — there's my AppBar, whatever there is. The TODOs are placed, my inner pages are there. These places are managed and from here it proceeds. Now what I did here as `loginPageBody` — what you see here is actually a class. There are a few sub-modules, what you see here. Here

**[06:30]** for example, for now I put this here for it to be bundled together, but normally I wouldn't do this either. For example, when it comes here, let me extract this for simplicity and visibility. For example, let's say I have a field called `loginTestAccountInfo`. Normally I'd come here. Like this — `loginTestAccountInfo`. I extract it here. And here, friends, I'd very quickly add a `part of` here. With LoginPageBody — actually it would be directly with LoginPage.

**[07:00]** For example, I'd give that here with LoginPage like this. And then for example when I come here, friends — here did I provide widget correctly? I split it inside view widget. Hmm. That part of is probably wrong. Let me fix this. I added one more. Tick came in. Now since there's only one more of this, it's complaining about it. Actually here, the most correct approach, the cleanest approach, dear friends,

**[07:30]** is for all of these to be here. Even if I take here this way, it'll fix itself. For these sub-widgets, for example, I now broke down all my components. Such broken widgets — you can either create them as single sub-widgets, or you make them private this way. No other class can access. Used very quickly. Also, its own private sub-widgets do their own things and the game continues. So this is the most basic approach first. This is in any architecture — we'll break down to sub-widgets. We'll manage in privates. If inner pages —

**[08:00]** if a shared layer — meaning if it's used in 3-4 pages, we'll move it to a public place. As for the second one, now friends, in our examination, when I come to LoginPage, the most important point for me is page mixins. Mixins — you can use them in widgets in any of your widgets in your life, or in any class. A mixin is actually an abstract class. We can't take constructors. The basic mentality here is entirely something we write in front of the class — like a plugin. Meaning it's a feature we integrate, something with state — this also integrating

**[08:30]** that, so only those derived from this should use it — saying this for an approach where anyone can't use it freely. The most basic point here is the controllers used by the view, methods if there are any, for example let me close these — methods. I gather all of these here so I can see what the controller does, what the view does. Of course, as view logic grows, as you go down many sub-branches, I separate the business-level ones. But for example in sub-widgets — pressing the button, for example onPressed, will load. There's no point in throwing a huge LoginPage at this. The button itself should manage that — kind of decision

**[09:00]** you'll be making as you progress. Now of course I put my methods here. I set all my disposes. I again placed it cleanly. One important approach here, again, that I'd recommend and you should do — I see lots of setState usage. Sub-widget, for example, the button's loading state — very simple situation and there's a management. You can manage setState here, but if there are page-level state-changing situations, at this point, even without state management — which there's no need to enter into at the start, basic things are quite sufficient. For example, ValueNotifier and

**[09:30]** a simple immutable class you'd write in front of ValueNotifier. Here, as you can see — there's no need to add comments to these by the way, the AI made it up. Let me set it up here. By making it an immutable class, instead of saying setState, setState for huge objects, you actually create an object that you manage your page very simply with ValueNotifier. For example, who's using this here? For example, the state-using is here, the state is here — is there one setting it? For example, here for example — do you see anywhere setting the state? I said `value`. State.

**[10:00]** Value — "go, brother, update with copyWith." When this update happens, automatically in the view, anyone listening for it via ValueListenableBuilder will be triggered automatically. So this is also a nice usage. A clean usage — and as you see, there's quite a clean usage. By the way, I especially want to show this. As I said, you don't have to use any of these. The Flutter community gets state management pumped into them quite often. There's not much sense in this. Because logic and area —

**[10:30]** depending on each, everything is sufficient. Code is written based on the need. That's how it always is in life. Meaning, taking a 3-line project and putting a giant clean architecture on it has no meaning and benefits no one. You can write much simpler tests here and solve your case. So that's why what I'll show you here is a simple ViewModel layer, and it has no special features. Nothing extra. Just a class and putting its methods inside — what does that give me, you know? When I look back at View — view's mixin, in mixin there's view's

**[11:00]** logic. ViewModel's businesses — what's business? Work — I mean, login, log successful, save user to cache, login command — if these exist, we'll fix these too — but as a simple idea, view-wise, this is quite sufficient. I should also mention that these should also be here. For example, I said that. OK. I now know where what is here, and at least I know where I'm running and where I'll go — saying that. So creating such a class and gathering them inside is exquisite for your objects. You'll say, "boss, but these are the lowest-class widgets — those state managements help you a lot

**[11:30]** at those points." We'll be discussing those too. This is the most primitive, simplest way you can clean up — and applicable to any of your widget views, not just any view, actually any stateful class, any stateless class easily. The solutions I'm showing you are these. I'm sure they'll be useful in many places — these methods, I mean. Like with `part`, `part of`, separating sub-classes and giving the relevant fields to the relevant objects, using ValueListenableBuilder, keeping objects clean, applying `final`, making these immutable —

**[12:00]** then creating the model and inside the model — for example, this LoginResponseModel — I haven't gone into it now. In the next video I'll be explaining the service layer and model layers — I'll fix that. For example, this is wrong. We'll fix this too — but for example, inside my state object — I did the state cleanly. Being immutable is very important. References not shifting, and when you set multiple objects or in a state situation, them not having problems — being immutable is quite important. We set them. Other than that

**[12:30]** for example, here we set the LoginViewModel. I mentioned we already gathered LoginPage. For example, we gathered our objects here. We separated the ViewModel, PageMixin, body. Basically, friends, any Flutter View — as long as you do this breaking-down — you proceed cleanly. It's quite a beautiful approach. Actually, what did we do? We took our View. The scattered, nested code — we extracted all of it. We pulled out our ResponseModel. Below model, we created a folder called widget

**[13:00]** and put our privates there. We put the Body. On top, with a mixin structure setup, we separated the View's logics. With State, we made the View even better. We saved it from setState. We said, "trigger the places that need it." Lastly, with a small layer like LoginViewModel, very simply, without any management, we managed what we call the business layer — meaning backend, etc. And at the end of the day, as a developer, when I came here

**[13:30]** and looked, what's where, how did it go, what did it do — I see and use very easily, dear friends. So this is the main idea I'll give you, this is it. Let's say you want to use this. Right now I'm using it on Cursor depending on the situation. I use it on CL. I use it on Gemini. None of this matters. What matters is the place and area where I generate the prompt. Now I created a prompt called `viewRefactor` at the bottom of the doc, friends. If you want, you can take this `viewRefactor` prompt. On any of your pages, just take this prompt and

**[14:00]** say, "fix the view of A" — that's enough to use this prompt. There's no need to do anything else to use this prompt. Even a friend watching this video can fix other pages and submit a PR if they want — but this prompt is quite sufficient for you. Actually everything I did is in this prompt. Also, for you for example, I intentionally didn't put the cloud in `.gitignore` so you can see it. I also created a skill. By taking this skill, you can also use it on any project at any time, and turn this clean structure into something usable for yourself.

**[14:30]** For example, what else did I add? Take AppSize, for example. If there are statics used in the page, read them from where they should be. Themes should come, and so on. I tried to add all of these into the prompt, into the skills. I created these here. If you want, you can use these prompts and skills to connect your pages cleanly and progress, friends. So I say. Even now, to wrap up, dear friends, I committed what we did. Let me grab the latest version of what we did.

**[15:00]** OK. Hop, my commit is complete. I had already created my branch. Coming to TODO. Now from the planned items, friends, I changed the order of V7 a bit, because I thought View-ViewModel-Mixin was more important and I explained that. Now in the next one, I'll move on to a free model. I'll fix that duplicate. Then a bit of state management — we'll save this project and at the end of the day, we'll have many prompts and many skills, and we'll be integrating them according to ourselves. Saying this, dear friends. Thank you again for listening. Hopefully

**[15:30]** an idea has formed. I'm sending the PR right now. Those who want can check the PR. Those who want — as I said — can integrate the other pages. They can send me a PR. I'll look at that depending on the situation. Already, friends, your hands and effort to your health. Wishing you ease. See you in the next other video. I just clicked PR. Yes. All set. See you, dear friends. Yeah.

---

## Copy-Paste Section

### YouTube Title
```
Flutter Refactoring Masterclass: 7.1 - View-ViewModel-Mixin (Prompt + Skill)
```

### YouTube Description
```
Hello! In this episode of our Flutter Refactoring series, we're tackling the heart of our project: the Login Module. In this video, we don't just clean up code — we also develop a new "Refactor Command" to automate the process and accelerate our workflow.

What Did We Do?
With this update, we made radical decisions to reduce technical debt in our project and improve sustainability:

🏗️ Architectural Transformation: We separated the Login module from its classic structure and split it into View — ViewModel — Mixin layers. This way, UI (Interface), Business Logic, and Reusable Behaviors are completely isolated from each other.

🤖 Automation Power: With the new Flutter View Refactor command we added, we can automatically migrate our modules to a standard structure.

📦 Dependency Management: For project health, we updated all package dependencies and clarified our v7 roadmap in the todo.md file.

📊 Technical Summary: We carried out approximately 1000 lines of improvements across 13 files.

Technical Details You'll Watch:
- Application of the Separation of Concerns principle.
- State management organization with ViewModel.
- Avoiding code duplication using Mixins.
- Project planning discipline through todo.md.

For Those Who Missed the Previous Video: https://youtu.be/2-Q91EDSiTg

Timestamps:
00:00 Introduction and General Statistics
02:15 Introducing the New Refactor Command
05:30 Login Module: Transition to MVVM Structure
10:45 Mixin Usage and Its Advantages
15:20 Dependency Updates and Closing

#Flutter #FlutterRefactoring #MVVM #Dart #CleanCode #MobileDevelopment #FlutterArchitecture #SoftwareEngineering #FlutterTutorial #VeliBacik #Programming #Refactoring #ViewModel #Mixin

https://github.com/VB10/flight_booking
Technical PR Summary:
Change: +946 lines added / -197 lines removed.

Focus: Improving code organization and building sustainable architecture.

Branch: All changes successfully integrated into the main branch. 🎉

If you'd like to check out the GitHub project: https://github.com/VB10/flight_booking

Don't forget to subscribe and turn on notifications! Enjoy watching.
```

### YouTube Tags
```
flutter, flutter refactoring, mvvm, dart, clean code, mobile development, flutter architecture, software engineering, flutter tutorial, viewmodel, mixin, view model, separation of concerns, masterclass
```
