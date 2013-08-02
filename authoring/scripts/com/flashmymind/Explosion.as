package com.flashmymind {
 
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.motion.Color;
	import flash.geom.ColorTransform;
 
	/*
	This class represents the explosion that starts from the firework.
	*/
 
	public class Explosion extends MovieClip {
 
		private var particlesArray:Array;
		private var numberOfParticles:uint = 0;
 
		function Explosion ():void {
 
			//Create a new array where to put all the exploded particles
			particlesArray = new Array();
 
			//Explosions have a random number of particles (10-40 particles)
			numberOfParticles = Math.floor(Math.random() * 30) + 10;
 
			//Assign a random color for explosion
			var ct:Color = new Color();
			ct.setTint (0xFFFFFF * Math.random(),1);
 
			//We use the scale to make the particles of different size
			var scale:Number = Math.random();
 
			/*
			We want the particles to explode in circle.
			We calculate the angle difference between the particles.
			*/
			var angleDifference:Number = 360 / numberOfParticles;
			var angle = 0;
 
			for (var i = 0; i < numberOfParticles; i++) {
 
				var particle:Particle = new Particle();
 
				//Each particle gets exploded into the direction specified by the angle
				particle.speedY = Math.sin(angle * Math.PI/180)*3;
				particle.speedX = Math.cos(angle * Math.PI/180)*3;
 
				//Assign the scale to change the particle's size
				particle.scaleX = scale;
				particle.scaleY = scale;
				particlesArray.push (particle);
 
				//Assign the color
				particle.transform.colorTransform = ct;
 
				addChild (particle);
 
				//Update the angle for the next particle
				angle += angleDifference;
			}
			addEventListener (Event.ENTER_FRAME, enterFrameHandler);
		}
		function enterFrameHandler (e:Event):void {
			for (var i = 0; i < particlesArray.length; i++) {
				var particle:Particle = particlesArray[i];
 
				//Update y and x coordinates
				particle.y += particle.speedY;
				particle.x += particle.speedX;
 
				//Fade away the particle
				particle.alpha -= 0.02;
 
				//Remove the explosion animation when all the particles are invisible
				if (particle.alpha < -0.1) {
					removeEventListener (Event.ENTER_FRAME, enterFrameHandler);
				}
			}
		}
	}
}