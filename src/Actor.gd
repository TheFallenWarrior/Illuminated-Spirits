#Contains basic attributes for game actors
extends KinematicBody
class_name Actor

const FLOOR = Vector3.UP

var speed: = 1.0
var velocity: = Vector3.ZERO
var acceleration: = 1.0
var gravity: = Vector3.DOWN * 8
