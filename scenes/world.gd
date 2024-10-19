extends Node2D

const MAP_SIZE = Vector2(3000, 1500)
const SPIDERS_NUMBER = 100

var SpiderScene = preload("res://scenes/spider2.tscn")
var NetScene = preload("res://scenes/net2.tscn")

@onready var fly_2 = $Fly2
@onready var hud = $CanvasLayer/HUD

func _ready():
	Global.score = 0
	fillWithSpiders()

func fillWithSpiders():
	for n in range(SPIDERS_NUMBER):
		var pos = randomPosition(MAP_SIZE.x,MAP_SIZE.y)
		spawnSpider(pos)

func randomPosition(maxx, maxy) -> Vector2:
	var random_position: Vector2
	random_position.x = randf_range(0, maxx)
	random_position.y = randf_range(0, maxy)
	return random_position

func spawnSpider(pos: Vector2):
	var spider = SpiderScene.instantiate()
	spider.position = pos
	add_child(spider)
	spider.connect("netStartSignal", startNet)
	spider.connect("netUpdateSignal", updateNet)
	spider.connect("body_entered", gameOver)
	spider.add_to_group("spiders")

func gameOver(body):
	if body is Fly2:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func startNet(spiderFromSignal: Spider2):
	var net = NetScene.instantiate()
	add_child(net)
	net.position = spiderFromSignal.position
	spiderFromSignal.currentNet = net

func updateNet(spiderFromSignal: Spider2):
	var local_position = spiderFromSignal.currentNet.to_local(spiderFromSignal.position)
	spiderFromSignal.currentNet.lengthenNet(local_position)

func _on_timer_timeout():
	Global.score += 1
	hud.updateScore(Global.score)


func _on_fly_2_caught_in_net():
	var closestSpider = get_closest_spider()
	closestSpider.targetPlace = fly_2.position
	closestSpider.followMode = true
	closestSpider.currentState = 0

func get_closest_spider():
	var closest = null
	var closest_distance = 99999  
	for spider in get_tree().get_nodes_in_group("spiders"):
		var distance = fly_2.position.distance_to(spider.position)
		if distance < closest_distance:
			closest_distance = distance
			closest = spider
	return closest
