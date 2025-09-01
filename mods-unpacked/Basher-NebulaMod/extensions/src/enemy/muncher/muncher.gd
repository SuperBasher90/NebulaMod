extends Node2D
var args := {
	targetPlayer = null
}
var targetPlayer:Node2D

# coins given on death
var coins := 6
# enemy base
@onready var enemy = $Enemy
@onready var sprite = $Sprite

var delta := 0.0

var knockbackVel := Vector2.ZERO
var bellowKnockback := Vector2.ZERO
var frozen := false
# velocity multiplier
var drainSpeed := 1.0

var vel := Vector2.ZERO

var attached := false
var side := 0

func _ready():
	if args.targetPlayer:
		targetPlayer = args.targetPlayer
	else:
		targetPlayer = Global.player
	enemy.spawn()

func _physics_process(delta):
	delta *= Global.timescale
	self.delta = delta
	#just the hexagon code.
	if attached:
		if side == 0:
			position.x = Global.windowRect.end.x
			vel.x = 0
			if position.y > Global.windowRect.end.y:
				position.y = Global.windowRect.end.y
				vel.y = -abs(vel.y)
			if position.y < Global.windowRect.position.y:
				position.y = Global.windowRect.position.y
				vel.y = abs(vel.y)
		if side == 1:
			position.y = Global.windowRect.end.y
			vel.y = 0
			if position.x > Global.windowRect.end.x:
				position.x = Global.windowRect.end.x
				vel.x = -abs(vel.x)
			if position.x < Global.windowRect.position.x:
				position.x =  Global.windowRect.position.x
				vel.x = abs(vel.x)
		if side == 2:
			position.x = Global.windowRect.position.x
			vel.x = 0
			if position.y > Global.windowRect.end.y:
				position.y = Global.windowRect.end.y
				vel.y = -abs(vel.y)
			if position.y < Global.windowRect.position.y:
				position.y = Global.windowRect.position.y
				vel.y = abs(vel.y)
		if side == 3:
			position.y = Global.windowRect.position.y
			vel.y = 0
			if position.x > Global.windowRect.end.x:
				position.x = Global.windowRect.end.x
				vel.x = -abs(vel.x)
			if position.x < Global.windowRect.position.x:
				position.x =  Global.windowRect.position.x
				vel.x = abs(vel.x)
	else:
		vel = 30.0 * (targetPlayer.position - position).normalized()
		if Global.windowRect.has_point(position):
			attached = true
			var sides := [
				{side = 0, dist = Global.windowRect.end.x - position.x},
				{side = 1, dist = Global.windowRect.end.y - position.y},
				{side = 2, dist = Global.windowRect.position.x - position.x},
				{side = 3, dist = Global.windowRect.position.y - position.y}
			]
			sides.sort_custom(func(a,b):
				return abs(a.dist) < abs(b.dist)
			)
			side = sides[0].side
			vel = 100.0 * Vector2.from_angle((side+1.0)/4.0 * TAU)
			Global.main.wallHit.connect(wallHit)


	#position += Global.windowVelocity + vel * delta
	if not frozen:
		position += vel * delta


func kill(soft := false):
	if not soft:
		Audio.play(preload("res://src/sounds/enemyDie.ogg"), 0.8, 1.2)
	#for i in 4:
		#Utils.spawn(preload("res://src/particle/enemy_pop/enemy_pop.tscn"), position, get_parent(), {color = line_2d.default_color})
	if Global.options.pEnemyPop:
		Utils.spawn(preload("res://src/particle/enemy_pop/enemy_pop2.tscn"), position, get_parent(), {color = Color(1, 0.792, 0.122)})
	
	Stats.stats.totalEnemiesKilled += 1
	Stats.metaStats.totalEnemiesKilled += 1
	
	queue_free()

func knockback(from:Vector2, power := 1.0, reset := false):
	var new = power*2000.0 * (position - from).normalized()
	knockbackVel = new if reset else knockbackVel + new
	enemy.flash()


func wallHit(_side:int):
	if _side == side:
		enemy.damage(0.25)
