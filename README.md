# Hokm The Video Game
![Hokm The Video Game Banner](<assets/Artworks/Hokm the Video Game Banner V2.png>)
A video game adaptation of a unique Iranian card game. Made in the Godot game engine with Krita for some art.

## About the Project
Hokm is a traditional Iranian trick-taking card game, which I have learned and enjoyed playing last November with my friend. These memories have inspired me to take it upon myself to make a video game adaptation as a learning experience. Maybe one day, I could play multiplayer eventually with these same friends..?

### Rules
I was taught the rules by my friend Ferdowski, but [this website](https://www.pagat.com/whist/hokm.html) is also a good reference.

### How was it made?
I used Maack's [Godot Game template](https://github.com/Maaack/Godot-Game-Template) as a starting point, and built on top of that. The inner game logic was originally coded based on a card game tutorial, but I soon realised it's method is well.. not very scalable 🥀. 
Several custom classes are used. The system uses a central gameManager class that controls the flow of the game. Objects like hands and scorepiles use inherited classes, and act as a purely visual container. Cards are managed with a custom resource class called CardData, containing rank, suit and sprite data. 

## Gallery
![mainmenu](https://cdn.hackclub.com/019edfaf-df37-788a-a016-f5aca0c506f9/htvg-mainmenu.png)
![2player](https://cdn.hackclub.com/019edfaf-d9ce-7f04-85b4-cac51204ffc8/htvg-2player.png)
![4player](https://cdn.hackclub.com/019edfaf-dc87-70a4-b267-f9b60342675b/htvg-4player.png)
![modeselect](https://cdn.hackclub.com/019edfaf-e22f-79a4-8f5e-ebc3fc099f60/htvg-modeselection.png)
![3player](https://cdn.hackclub.com/019edfaf-e4bd-7432-a702-00033df91572/htvg-3player.png)

## License
(©)2025 Henry Wauzivuff & Collaborators. Most rights reserved
