﻿/* *  Jogo da Glória (projecto para Interacção Homem-Máquina) *  Copyright (C) 2013  Helder Correia * *  This program is free software; you can redistribute it and/or modify *  it under the terms of the GNU General Public License as published by *  the Free Software Foundation; either version 2 of the License, or *  (at your option) any later version. * *  This program is distributed in the hope that it will be useful, *  but WITHOUT ANY WARRANTY; without even the implied warranty of *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the *  GNU General Public License for more details. * *  You should have received a copy of the GNU General Public License along *  with this program; if not, write to the Free Software Foundation, Inc., *  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA. */package org.siriux {	import com.greensock.TweenLite;	import flash.display.MovieClip;	import flash.geom.Point;	import flash.events.MouseEvent;	import flash.events.Event;	import flash.events.EventDispatcher;	public class Game extends EventDispatcher {		public static const ENDED = "Game Ended";		private var _context:MovieClip;		private var _dice:Dice;		private var _cardPos:Point; // default question card position		private var _questions:Array;		private var _usedQuestions:Array = new Array();		private var _players:Array = new Array();		private var _currentPlayer:int = -1; // index from _players Array		private var _lastPosition:int = 0; // current player's position before play		private var _winner:Player;		public function Game(context:MovieClip) {			_context = context;			_dice = Dice(_context.dice);			_dice.roll_btn.addEventListener(MouseEvent.MOUSE_UP, rollDice);			_dice.continue_btn.addEventListener(MouseEvent.MOUSE_UP, continuePlay);		}		public function setQuestions(questions:XMLList, cardPos:Point) {			_questions = Util.xml2array(questions);			Util.shuffle(_questions);			_cardPos = cardPos;		}		public function addPlayer(name:String, mc:MovieClip, pos:Point) {			var player:Player = new Player(name, mc);			player.addEventListener(Player.STOP, playerPositionHandler);			mc.x = pos.x;			mc.y = pos.y;			_players.push(player);			player.id = "player" + _players.length;		}		public function start() {			// add players from last to first because of depth arrangement			for (var i:int = _players.length-1; i >= 0; i--) {				_context.board.addChild(_players[i].movieClip);			}			nextToPlay();		}		public function nextToPlay() {			_currentPlayer++;			if (_currentPlayer > (_players.length-1)) {				_currentPlayer = 0;			}			_lastPosition = currentPlayer().position;			_dice.playing.text = currentPlayer().name;			_dice.roll_btn.mouseEnabled = true;			updateScoreBoard();			showMessage("É a tua vez, " + currentPlayer().name + ".");		}		public function currentPlayer():Player {			return _players[_currentPlayer];		}		public function updateScoreBoard() {			for (var i:uint = 0; i < _players.length; i++) {				var player:Player = _players[i];				_context.scoreBoard[player.id+"Name_txt"].text = player.name;				_context.scoreBoard[player.id+"House_txt"].text = player.position;				_context.scoreBoard[player.id+"Right_txt"].text = player.right;				_context.scoreBoard[player.id+"Wrong_txt"].text = player.wrong;			}		}		private function rollDice(evt:MouseEvent) {			_dice.roll_btn.mouseEnabled = false;			var roll:int = _context.dice.roll();			showMessage("Avança " + roll + " casa" + (roll!=1?"s":"") + ".");			currentPlayer().forward(roll);		}		private function continuePlay(evt:MouseEvent) {			nextToPlay();			_dice.continuePlay();		}		private function playerPositionHandler(evt:Event) {			if (Player(evt.currentTarget) != currentPlayer()) {				return;			}			switch (currentPlayer().position) {				case 0:					if (_lastPosition > 0) {						_dice.hold();					}					return;				case 10:					showMessage("Alcançaste a casa 10. Avança uma casa.");					currentPlayer().forward(1);					return;				case 20:					showMessage("Alcançaste a casa 20. Retrocede uma casa.");					currentPlayer().rewind(1);					return;				case 28:					showMessage("Alcançaste a casa 28. Volta ao início. Melhor sorte para a próxima!");					currentPlayer().moveTo(0);					return;			}			if (currentPlayer().position == _lastPosition) {				return;			}			nextCard();		}		public function nextCard() {			if (_questions.length == 0) {				_questions = _usedQuestions;				Util.shuffle(_questions);				_usedQuestions = new Array();			}			try {				var question:XML = _questions.shift();				_usedQuestions.push(question);				showCard(question);			}			catch (e:TypeError) {				trace(e.getStackTrace());				nextCard();			}		}		public function showCard(question:XML) {			var card:Card = new Card(question);			card.x = _cardPos.x;			card.y = _cardPos.y;			_context.addChild(card);			card.addEventListener(Card.ANSWERED, answerHandler);			appendMessage(" Responde à pergunta. Uma resposta errada retorna à casa " + _lastPosition + ".");			_context.restart_btn.mouseEnabled = false;		}		private function answerHandler(evt:Event) {			var cue:MovieClip;			var correct:Boolean = Card(evt.target).correct();			currentPlayer().answer(correct);			if (correct) {				cue = new Correct() as MovieClip;				if (currentPlayer().position < 30) {					nextToPlay();				} else {					_winner = currentPlayer();					updateScoreBoard();					dispatchEvent(new Event(ENDED));				}			} else {				cue = new Wrong() as MovieClip;				showMessage("Erraste, portanto voltas à casa " + _lastPosition + ".");				currentPlayer().moveTo(_lastPosition);				_dice.hold();			}			_context.restart_btn.mouseEnabled = true;			_context.removeChild(Card(evt.target));			showCue(cue);		}		public function showCue(cue:MovieClip) {			cue.x = 675;			cue.y = 320;			_context.addChild(cue);			cue.scaleX = 0.5;			cue.scaleY = 0.5;			TweenLite.to(cue, 1.5, {scaleX:1, scaleY:1, alpha:0, onComplete:completed});			function completed() {				_context.removeChild(cue);			}		}		public function showMessage(msg:String) {			_context.feedback_txt.text = msg;		}		public function appendMessage(msg:String) {			_context.feedback_txt.text += msg;		}		public function get winner() {			return _winner;		}	}}