extends TileMap

export var water_cycle_speed: int = 15

var atlases: Array

func generate_atlas_list(tileset_atlas_index : int) -> Array:
	var tilemap = self
	var cell_size = tilemap.cell_size
	var array = Array()
	var tileset : TileSet = tilemap.tile_set
	var region = tileset.tile_get_region(tileset_atlas_index)
	var start = region.position / cell_size
	var end = region.end / cell_size
	for x in range(start.x, end.x):
		for y in range(start.y, end.y):
			var autotile_coord = Vector2(x, y)
			var priority = tileset.autotile_get_subtile_priority(
				tileset_atlas_index, autotile_coord
			)
			for p in priority:
				array.append(autotile_coord)
	return array
	
func cycle_tile(tile, atlas_index):
	var atlas = atlases[atlas_index]
	var autotile_coord = atlas[randi() % atlas.size()]
	set_cell(
		tile.x,
		tile.y,
		0,
		false,
		false,
		false,
		autotile_coord
	)

# Called when the node enters the scene tree for the first time.
func _ready():
	for atlas in 1:
		atlases.append(generate_atlas_list(atlas))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var offset = 0
	for tile in get_used_cells_by_id(0):
		if (Engine.get_frames_drawn() + int(tile.x*tile.y) + offset) % water_cycle_speed == 0:
			cycle_tile(tile, 0)
		offset += 1
