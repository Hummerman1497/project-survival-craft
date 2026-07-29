class_name RecipeData
extends Resource

@export_multiline var description: String = ""
@export var input: Array[SlotData]
@export var output: Array[SlotData]

# Dynamische Eigenschaften (werden nicht im Inspector angezeigt/gespeichert)
var recipe_name: String:
	get:
		if output.size() > 0 and output[0] and output[0].item_data:
			return output[0].item_data.name
		return ""

var recipe_texture: Texture2D:
	get:
		if output.size() > 0 and output[0] and output[0].item_data:
			return output[0].item_data.texture
		return null
