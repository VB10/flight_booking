# Flutter Refactoring Masterclass: 6 - Theme & Design System (Prompt + Skill)

> Translated from Turkish YouTube video

## Video Metadata

| Field | Value |
|-------|-------|
| **Original Title** | Flutter Refactoring Masterclass: 6- Theme & Design System ( prompt + Skill) |
| **Channel** | HardwareAndro |
| **Duration** | 19:44 |
| **Category** | Education |
| **Upload Date** | 2026-02-20 |
| **Video ID** | 2-Q91EDSiTg |

---

## Description (English)

In the sixth episode of the series, we're building the visual identity and user experience of our application! After completing the foundational configurations (v5), we're now tackling the Theme & Design System processes that will bring color to that structure. How do we standardize color palettes, typography, and UI components into a manageable and reusable structure? And while doing it, how do we leverage the power of AI (Prompts) and our own capabilities (Skills)?

If your application has grown to the point where color codes (hex), font sizes, and widget styles are scattered everywhere, and even a tiny design change has become a nightmare, this video will completely transform your project's UI/UX management.

🚀 What You'll Learn in This Episode:

**Design System Setup:** Standardizing the visual language of the project. Centralized and clean management of foundational building blocks like Colors, Typography, and Spacing/Paddings.

**Dynamic Theme Management:** Seamlessly integrating Light and Dark mode transitions, and customizing Flutter's ThemeData class to fit the architecture.

**AI (Prompt)-Powered Development:** How do we leverage AI tools (prompt engineering) when building the design system, and how do we accelerate the labor-intensive coding process?

**Custom UI Components (Skill):** Adding our own skills to create design-aligned, reusable custom widgets (buttons, cards, input fields, etc.).

This episode ensures that your application not only looks "good" but also has a UI architecture that stays true to software principles, is much faster, and is scalable when adding a new screen or changing the theme.

🕒 CHAPTERS (Time-Line)
00:00 Introduction: The Importance of Design Systems and Goals of Episode Six
04:15 Laying the Foundations of ThemeData and the Design System
11:30 Setting Standards for Color, Typography, and Spacing
14:45 Strategies for AI-Assisted Theme Integration Using Prompts

🔗 Useful Resources and Links
GitHub (Project Code): https://github.com/VB10/flight_booking
Flutter Architecture Guide: https://vb10.github.io/#/
Twitter: https://twitter.com/10VBacik
Medium: https://medium.com/@vbacik-10

#FlutterTheme #DesignSystem #FlutterArchitecture #FlutterUI #Dart #PromptEngineering #CleanUI #MobileDevelopment #FlutterDesign #FlutterDevelopment

Note: The flexible design system we built in this video will allow the screens we develop in upcoming episodes to come together much faster, without code repetition, and consistently. If you found the content useful, don't forget to subscribe to the channel and like the video!

---

## Tags (English)

`flutter`, `flutter theme`, `design system`, `flutter architecture`, `flutter ui`, `dart`, `prompt engineering`, `clean ui`, `mobile development`, `refactoring`, `masterclass`, `flutter design`, `themedata`, `light dark mode`

---

## Full Transcript (English) - Timestamped

**[00:00]** Hello dear friends. I hope you're doing well. Health, wellbeing, your family's health, everyone's health is good. If you're looking for a job, good opportunities are with you. Hopefully, you're getting the recognition you deserve from the teams you work with, and you're developing great features. Now, we're on the 6th part of our Flight Booking series — the Refactoring Masterclass series, if I counted correctly. This time, friends, we're diving into the theme topic. We'll cover the theme infrastructure, colors,

**[00:30]** typography, padding, and so on. After this video, I've decided to change my approach. From now on, I'll lean fully into AI-based development, leveraging the power AI gives us, and I'll prepare these things for you with configurations. Because as we all know now, writing code from scratch end-to-end no longer makes sense. I'll quickly show you the key elements on a single page, and for the remaining parts, I'll provide prompts and demonstrations so you can at least understand how I thought about the idea —

**[01:00]** so you can think about your own projects in the same way. This way, you'll both quickly integrate your own project and get the underlying ideas. There are some things I prepared in advance for this project. Especially, I started placing prompts at the bottom of the documentation. For example, the theme extension — that's about how I created this topic. I wrote it in Turkish, but you can change it however you want — for better understanding. I added a theme prompt, for example. With this prompt, you can take it and through any AI tool

**[01:30]** instantly access most of what I've done. On another note, I set up skills. Regarding skills — since I'm not really an AI-based content creator — many things will appear in your tools. To avoid having to provide the prompt every time, I created a skill set. You'll have access to that in this project too. I have a main TEAM.md file. I'll explain it — why I created it and the general concept — let me summarize it simply this way. Now friends, in this Flutter project, the theme situation is the most critical point.

**[02:00]** When the project is set up correctly, you'll be very comfortable; when set up incorrectly, you can end up anywhere. Right now, I'll show you the most-used aspects and what to pay attention to in just a few words. But of course, in real life, a few problems will come up. I'll address those with some preventive measures and present them to you. Now friends, in the most basic concept, beyond just the theme, I also dealt with radii. The most important point here is that the project needs to have a certain

**[02:30]** structure. The simplest example is generally using multiples of 4. Colors should come in a defined scheme, paddings should align with specific size sets, and so on. If we set all of these up correctly from the start, the rest will flow naturally. By the way, this is my broken page. Now, I'll start with the simplest of the structures I use in my own projects with that idea, and I'll move forward from there.

**[03:00]** Now friends, in the most basic concept, I'm essentially creating two themes in my project: one light and one dark theme. The dark mode robot already comes by default in Flutter. If you want, you can load a font family and pull it from there. I configure these at the very beginning through a static class. Now here, for example, making a getter — the AI did it this way, but actually, doing it like this is nicer. Because this theme will only be created once and won't change throughout the project's lifetime, defining it as final is

**[03:30]** more elegant in my opinion. But what did it take here? It said `AppColorScheme.light`. Where did it use that scheme? It could have done it like this. Let me grab this from there, dear friends. When I write `static final light` — I gave it the data. TeamData — what's it complaining about?

**[04:00]** One second. I actually set it up correctly. Let me delete this. Let me fix the code right away. When we say light/dark, what should be static was supposed to be like this. Why did the light name shift? Did I shift the name? Let me call this Light2. The naming shifted. Anyway, you can also define it this way.

**[04:30]** So actually, defining it as final is more logical. When you use `get`, every time you'll have to recalculate the theme. To at least calculate it once in memory and not redo it, that's definitely what I recommend. Right now, the AI did that side that way, but you can dig into it. The important point here is to define my color sets and the text theme I use at the start, so I can move forward in the project's later stages without revisiting,

**[05:00]** discussing, or making additions to it. So that's why we're already setting the theme set here. Here I have a few constant classes I created for colors, themes, and texts, and I have two places where I define them as dark and light. In the color scheme, friends, I previously defined these on a palette — and again, it's worth making this final. For example, doing it this way isn't quite right. I have palettes. In the palette, I currently have a place where I use abstractions

**[05:30]** for the main classes I rely on. Inside it, I have my color set prepared to be filled with dark and light. If you can pull this in this way using Figma in your own project, it's incredibly nice. But of course, in real life, things don't always come together this neatly. Many color issues arise. This is actually the ideal scenario when you work with a good project and design team. Color sets and so on should align with the theme, but in practice, this isn't always healthy. At this point, it's worth understanding this: the main theme should always

**[06:00]** play around light and dark. So if you have color sets or intermediate themes, you need to manage them with extensions and color extensions you create on top of these. They should always be theme-compatible, but if there are special colors in some places, you need to separate them as light and dark as well. Not everything should be written into the theme color. For example, we write these here. When something not in here comes up, we keep adding it here, but that doesn't work either every time you add a color. Because in the theme, especially when working with a designer team, you may not always be in sync. Pay attention to

**[06:30]** this. Manage these with intermediate classes. Regarding that, I'll show you here — for example, writing a custom extension. Maybe write a custom extension and set your own special colors as light and dark there. There's a nice structural example here. For example, this `appExtension` is actually a custom color class. Normally, you'd have, say, `colorSecondary`, but here you have a color called `brandPrimary`. This is a special definition. Through this, you'll be accessing it. So what's the advantage?

**[07:00]** Every time, instead of "go grab this color, take that one," you'll directly access your color set through context and use it appropriately for dark/light. Why do we access it through context? Because we'll be doing theme changes for light/dark through this context. So this is something I'll explain — one of the important points before going into the rest is the theme extension. With theme extensions, friends, especially if you set them up correctly, you can use them through context when needed. Why use color through context? Because

**[07:30]** the color property has a chance of changing at runtime. But for example, you don't write a context extension and put `size` in it. That's nonsense — I won't put `size` there just because I can access it easily. Because there's no point in accessing it. My goal is to manipulate things on that context. So that's why writing this context extension is nice. By setting up something like this with a definition, you can directly access this extension through the theme. I also created this for accessing textTheme. You can also use cards.

**[08:00]** I also define this text style guideline here at the start. I shape what my font families will be and what my font sizes will correspond to here. Again, in real life these won't always align, but for the major ones, you can match them. And I integrate this into the theme in my project. One important usage here — `appSize`, for example — you shouldn't pass them by hand everywhere. Sometimes you see 16, sometimes 15 — set 16. Design and team conventions

**[08:30]** establish certain rules for these things. So I do this for keeping these in defined places. Not within the theme itself, but at the project's foundation. I also have my radii. I have radii I use frequently — for example. Always, things like radius, color, size are always being used, and the more we standardize them, the more important it becomes as the project grows. When using these, you either name them properly, or we go on top of it. For example, I'll explain `pagePadding` shortly. Like `pagePadding`, if you explain what it is with comments, it'll be nice. I already mentioned the colors. So this theme

**[09:00]** topic — since I'm not explaining it from scratch, because we're doing refactoring here — is something you can easily research and understand at a basic level. For example, here at AppPadding, I have a class like this. But I wanted to show this too. Like this, when AI generated something like this, but actually it's not the most correct usage. Because why would I make this a getter? Just defining it as a constant — making it more correct is in your hands. So I don't define them this way. For example, I have a really nice

**[09:30]** extension here called AppPadding that I derived, where I made my own definitions and positioned them. I'm placing a nice class. This way, I say, "no need for this usage." I delete it from here and move on. So this is simply my theme features. Now here, friends, the important thing is your skill set, and I have a prompt for doing this on top of you. Skill is important. If you give the theme features here to the skill, in your project, the theme skill feature

**[10:00]** means you won't need to revisit this every time you do new tasks. It already takes these as reference and uses them. This is important. Second point — I still create a TEAM.md in my project. In this TEAM file, friends, I put the equivalents of the colors and paddings within the project. Why do I do something like this? Because in the project, sometimes there's a need. Like, "what was this color? What was that color?" You may need to look it up. So you don't keep going to the light/dark theme. To see it from here in two minutes — that's the kind of approach I take.

**[10:30]** In summary, even down to the prompt, you have everything in your hands right now. You can easily apply this as a refactor to any of your projects. Now let's get to refactoring this part here. Of course I'd use it with the skill sets I'll provide, but let's say I'm not giving it through the skill sets. What I'll do here, friends, is — if the background color is white, normally I'd manage it through the color theme. So if I have my colors here, like AppColor, in my color

**[11:00]** sets — for example, here it's a bit incomplete. Normally, in my colors, if I have my scheme, I'd see my scheme through the palette, or come here from the light palette. What's the light palette? I'll find it from the light palette here, or it should be in that theme so I can find it correctly. Let's say we found it — let's say it's `10primary`. That's my color. At this point, it's worth checking the dark version too. For example, `10primaryDark` is like this. Of course, looking at these definitions in more detail, once you've found that it's `10primary`,

**[11:30]** then I say, "OK, since I'll be using the theme here, I want `10primary` from the AppTheme." For example, I'm saying "AppTheme" — but this AppTheme is actually a custom one I wrote. But since I'll be pulling from the main theme, for example here I have `textTheme` — let me add it as `appTextTheme` here. For example, let's also do something like AppTheme — let me say `themeData` actually wait,

**[12:00]** like this for example — let me pull this theme from here. From here. AppTheme, right? This now matches. Let me say "team" like this. I said team. From here I go to onColorScheme. For example, I say `onSurface`. I take it from here. Even taking it a step further, here I can also say `colorScheme`. I can directly say "go give me

**[12:30]** the colorScheme back." I'll show these in better usage with extensions. Now one of the nice usages we'll do here, friends, is this. Let's say there's a field called Flight Booking. You can do something like this. From AppTheme.text, I took it. I said `bodyLarge`. Like, find the color from here in a way that fits the design and update it. The colors also work this way — for example, here if you have something, if it's primary, it'll give your set. You update these places. Sorry, I'm talking about this text. From its style, you say copy

**[13:00]** with — using copyWith like this — for example, color — and you update here. But there's an important detail here, friends. What I'd recommend here, also internally, is using a class called `productText`. For example, I really love this. With an extension I created on top of text, I can use it comfortably and do my operations comfortably. For example, let's say I'm going to use this productText. This is a title. I say on product, for example, let me add here — H1

**[13:30]** for example, I write Flight Booking here, and I access it from my own context. For example, I say "look, in all my themes I'll be using my style guideline — sure, you can pass your own text style yourself, OK to that, like here using your own text style." But actually there's no point in taking style here — for example this AI-generated code is wrong, because I'm already setting the theme thing. The important thing here, friends, is being able to provide its relevant sets through copyWith.

**[14:00]** For example, when this came here — wait. What did it do? It took the theme. Let's do it this way. In the theme, for example, I gave that extension. Like this, I can give the white as default. If I do all of them this way, here for example, all of them have automatically taken my theme set and are using it. This is an important usage for me. Because I can comfortably take these usages. Look, with these super usages, I've already passed the main data. For example, it said, "professor, color may or may not be there, in that case

**[14:30]** it's worth passing the color this way." Because color is a very commonly used property generally. For example, I can also pass color here in a way that overrides. For example, I said H1, then H3 — I went to H3. Here there's no need for the styleGuide — "professor, what this will be is already clear." I corrected this. I used it this way. This is also a nice usage. Of course, this Flight Booking won't be written like this. We'll get these from localization. I'm adding it to the TODO here. Then for example,

**[15:00]** padding. Again, I explained padding to you earlier. Using AppPagePadding, using padding, you can get a very clean usage here. So I don't come here and write this by hand. The advantage I gain here especially is that I don't want to lose constants and immutables. That's why I do this. Now after this size, I can come here and say my AppSizes — like, my AppSize is here. This AppSize

**[15:30]** inside, friends, here I have my specific lengths — that's correct, but I can also come here and say, "professor, let me put spacings here too — at worst this way they're at least bundled together here." For example, again here text was used — we pulled the text to bodySmall. There was no color in bodySmall. I had it add color right away. We deleted the styleGuide style — "professor, no need for this style." It came from here. It took here. Or I can declare an `error` color extension myself —

**[16:00]** if I use it a lot, I can do something like that to avoid overriding it again and again. Right now I'm only creating these according to my own scenario, so that tomorrow when used in the scenario I mentioned, it comes quickly for me. For example, look, here's a new scenario. Let me delete these too. Let me delete the minimumSize and such, friends. For example, I came here. According to this usage, here for example, let me say, login — login settled there. This background color

**[16:30]** if it has, for example, a new screen is expected to be blue here as background color. Again, it's not there now — normally I should pull from there, but I went to my palette. In my palette, I said "I'm looking for blue in light." Secondary — and it's worth checking what its dark version is. For example, secondaryDark was named. These should of course be made more harmonious.

**[17:00]** What else did I have? I had my own colors. For example, my own color — here I have my AppColor, my AppTheme. This is my own theme. From here, I could say `brandPrimary`. So it shouldn't be the background color. So this way, I could have established this. Let me center this too. Like this, for example, this login — for example here, again, color — like, "professor, look, this color is different." We could also feed the color from here quickly. Like this — I deleted the styleGuide again.

**[17:30]** I dropped its style. I sat the login down from here, and all of these came in. Can't we do this everyone-thing? OK, professor. Let's clean up all these errors too. For example, again text. I took here. I deleted these. No need for size, professor — if we didn't shift a comma. So at the simplest level, I've essentially made all of my operations here

**[18:00]** clean. Of course, we're doing refactoring there. Right now we're only on this topic, but I've simply shown you here what the color scheme is. Now, what will I do after this? I created this. This is OK. My prompts are OK. My structure is OK. The structure I created is OK. The only thing I'll do is tell the skill, "go, organize my inner pages — main and all — for me with this color scheme, create this for me, and give it back the cleanest, fastest way." This is the path you'll all use in production

**[18:30]** projects, and through this, when a new task comes up, when something new happens, you'll have built all your structures appropriate to performance, needs, the architecture, and any person on your project team. In future stages, we can pull all of these under modules, but for now this is quite sufficient for me, dear friends. By the way, I dropped all my prompts here so you can easily access them right now. All of these, friends —

**[19:00]** in the design section here, I'm also dropping V6 here, friends. So from now on, we've also done this part because I deleted that too. In the next one, I want to start cleaning these views a bit. They really bother me. Then we'll proceed to the other parts. Let me also do a PR for this one, friends. I opened the PR. Anyone who wants can grab these prompts from here. Understand the structure.

**[19:30]** Understand the structure. If they want, they can add things in front of them and integrate their projects cleanly. Dear friends, thank you for listening. Hope it was helpful. The PR is out there. Take great care of yourselves. See you in the next content. Yeah.

---

## Copy-Paste Section

### YouTube Title
```
Flutter Refactoring Masterclass: 6 - Theme & Design System (Prompt + Skill)
```

### YouTube Description
```
In the sixth episode of the series, we're building the visual identity and user experience of our application! After completing the foundational configurations (v5), we're now tackling the Theme & Design System processes that will bring color to that structure. How do we standardize color palettes, typography, and UI components into a manageable and reusable structure? And while doing it, how do we leverage the power of AI (Prompts) and our own capabilities (Skills)?

If your application has grown to the point where color codes (hex), font sizes, and widget styles are scattered everywhere, and even a tiny design change has become a nightmare, this video will completely transform your project's UI/UX management.

🚀 What You'll Learn in This Episode:

Design System Setup: Standardizing the visual language of the project. Centralized and clean management of foundational building blocks like Colors, Typography, and Spacing/Paddings.

Dynamic Theme Management: Seamlessly integrating Light and Dark mode transitions, and customizing Flutter's ThemeData class to fit the architecture.

AI (Prompt)-Powered Development: How do we leverage AI tools (prompt engineering) when building the design system, and how do we accelerate the labor-intensive coding process?

Custom UI Components (Skill): Adding our own skills to create design-aligned, reusable custom widgets (buttons, cards, input fields, etc.).

This episode ensures that your application not only looks "good" but also has a UI architecture that stays true to software principles, is much faster, and is scalable when adding a new screen or changing the theme.

🕒 CHAPTERS (Time-Line)
00:00 Introduction: The Importance of Design Systems and Goals of Episode Six
04:15 Laying the Foundations of ThemeData and the Design System
11:30 Setting Standards for Color, Typography, and Spacing
14:45 Strategies for AI-Assisted Theme Integration Using Prompts

🔗 Useful Resources and Links
GitHub (Project Code): https://github.com/VB10/flight_booking
Flutter Architecture Guide: https://vb10.github.io/#/
Twitter: https://twitter.com/10VBacik
Medium: https://medium.com/@vbacik-10

#FlutterTheme #DesignSystem #FlutterArchitecture #FlutterUI #Dart #PromptEngineering #CleanUI #MobileDevelopment #FlutterDesign #FlutterDevelopment

Note: The flexible design system we built in this video will allow the screens we develop in upcoming episodes to come together much faster, without code repetition, and consistently. If you found the content useful, don't forget to subscribe to the channel and like the video!
```

### YouTube Tags
```
flutter, flutter theme, design system, flutter architecture, flutter ui, dart, prompt engineering, clean ui, mobile development, refactoring, masterclass, flutter design, themedata, light dark mode
```
