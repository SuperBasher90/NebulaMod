extends Node


const BASHER_NEBULAMOD_DIR := "Basher-NebulaMod"
const BASHER_NEBULAMOD_LOG_NAME := "Basher-NebulaMod:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

@onready var modUtils = get_node("/root/ModLoader/ombrellus-modutils")
@onready var icon_texture = preload("res://src/title/bg_icons/mods.svg")

func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(BASHER_NEBULAMOD_DIR)
	# Add extensions
	install_script_extensions()
	# Add translations
	add_translations()


func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	# ModLoaderMod.install_script_extension(extensions_dir_path.path_join(...))


func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")
	# ModLoaderMod.add_translation(translations_dir_path.path_join(...))


func _ready() -> void:
	modUtils.addTitleWindow(BASHER_NEBULAMOD_DIR,"Nebula Mod",icon_texture,Color.BLUE_VIOLET,[preload("res://mods-unpacked/Basher-NebulaMod/titleWindow.tscn")])
	modUtils.addEnemyToPool(BASHER_NEBULAMOD_DIR,"muncher",0.5)
	ModLoaderLog.info("NebulaMod Loaded!", BASHER_NEBULAMOD_LOG_NAME)
