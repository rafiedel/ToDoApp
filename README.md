# To Do App

## Features:

- **Basic Task Management:**
  - Create, edit, delete, and mark tasks as finished.
  - Daily Task Option

- **Task Attribute**
  - Name
  - Description
  - Images
  - Category
  - Prioritize Task
  - Starts - Ends (year, month, day)

- **Search Functionality:**
  - Search tasks by date, name, and category.

- **App Sections:**
  - View ongoing and upcoming tasks.
  - Calendar table to search for tasks.
  - Detail screen of every task
  - Screen of images in every task
  - Create task sheet
  - About me screen (the developer)

- **User Identity and Preferences:**
  - Home top bar background
  - Profile picture
  - Display name
  - Brightness theme
  - Manage Daily Task
  - Summary of tasks (finished, not yet, and late)
  - History of user activity

- **Specifications:**
  - Local database
  - No internet needed

#NOTE : Upon the initial launch, users will find sample tasks preloaded into the app. Please note that these sample tasks are provided solely for demonstration purposes. If users wish to use the app for their personal task management, I kindly ask for their understanding as they'll need to remove these tasks individually. I apologize for any inconvenience this may cause. 🙏🏻


## Third Party Packages Dependencies & Development Dependencies:

- flutter_bloc
- google_nav_bar
- google_fonts
- intl
- table_calendar
- popover
- animated_toggle_switch
- animated_custom_dropdown
- action_slider
- slide_countdown
- card_swiper
- video_player
- hive
- hive_flutter
- build_runner
- hive_generator
- image_picker
- image_cropper

## What I've Learned:

From the process of making this app, I gained valuable knowledge on how to create Flutter applications like widgets, state management, integrating data from local storage, and a time-based job scheduler. Not only that, I also learned about other software engineering principles. Throughout my exploration, I encountered various challenges, but those challenges became valuable sources of knowledge to level up my skills. For instance, when determining and displaying DateTime data in an AlertDialog or ShowModal Bottom Sheet, if I only used regular setState, the data wouldn't update, and it would still display the previous date. Therefore, Flutter provides state managers like Provider and Bloc to address such issues.

All of that I obtained through my exploration via PubDev, Stack Overflow, GitHub Discussions, YouTube, and various other websites. What I've learned from this is to create as many projects as possible and as often as possible, look up references by browsing, and don't be afraid to try new things. Because of going through those experiences, I went from simply following other people's code and work to understanding the basics of creating a feature and being able to write the code myself. Of course, my learning doesn't stop there. I want to dive deeper and advance further into mobile development.
