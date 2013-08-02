# Flash Game

This game was made for a class in Human-Machine Interaction and is called "Jogo da Glória". Delivered in Jan 28, 2012.

## Game structure

The game can be played by one or two players.

The answers to questions are multiple choice.

## Rules

 -  Number of houses: 30
 -  Number of players: 1 or 2
 -  "Special houses": 3
    *  house 10: move forward 1 house
    *  house 20: move back 1 house
    *  house 28: go back to the start
 -  You win the game when you reach (or move past) house 30
 -  Questions should not be repeated during each game

## Target audience

Kids in 5th and 6th grade.

## Authoring

Authoring material is in `authoring`, with .fla and ActionScript files (`scripts/org/siriux`).

### Adding more players

The code supports any number of players, but additional tracks need to be created for each one. Since the track is curved, it's best to create these paths manually to avoid having player pieces overlapping each other.

