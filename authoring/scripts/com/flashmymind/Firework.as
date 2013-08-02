﻿package com.flashmymind {		import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.display.MovieClip;	import flash.events.*; 	/*	This class represents one firework that starts to move upwards	and then explodes.	*/	public class Firework extends MovieClip{		//Each firework has its own speed		private var speedY:Number = 0; 		private var timer:Timer;		function Firework ():void { 			//Assign a random y speed			speedY = (-1) * Math.random() * 10 - 2; 			//Draw the firework (you could also use an image or something more fancy)			graphics.beginFill (0xffffff);			graphics.drawCircle (0, 0, 2);			graphics.endFill (); 			//We want the firework to immediately start moving upwards			takeOff();		} 		//This function adds event listeners for the animation		private function takeOff ():void { 			addEventListener (Event.ENTER_FRAME, takeOffEnterFrame); 			/*			Add a timer so we know when to make an explosion.			In this case the firework explodes after 2 seconds.			*/			timer = new Timer(2000,1);			timer.start ();			timer.addEventListener (TimerEvent.TIMER_COMPLETE, explode);		} 		//Firework moves up...		private function takeOffEnterFrame (e:Event):void {			this.y += speedY;		} 		/*		This function is called when the timer is finished.		That's when we want to explode the firework.		*/		private function explode (e:Event):void {			//Remove the take off animation			removeEventListener (Event.ENTER_FRAME, takeOffEnterFrame); 			//Create an explosion to the same position as where this firework is			var explosion:Explosion = new Explosion();			explosion.x = this.x;			explosion.y = this.y; 			//Add the explosion to stage			stage.addChild (explosion); 			//Make the firework invisible, we don't want to show it when the explosion starts			this.visible = false; 		}	}}