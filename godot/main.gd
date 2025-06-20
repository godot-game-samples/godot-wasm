extends Node2D

@onready var wasm: Wasm = Wasm.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load WASM file
	var file = FileAccess.open("res://rust.wasm", FileAccess.READ)
	var bytecode = file.get_buffer(file.get_length())
	file.close()
	# If you don't need import, just leave it empty.
	var imports = {}
	# Loading Modules
	wasm.load(bytecode, imports)
	# Call function "hello" (no arguments)
	var ptr = wasm.function("hello", [])
	var len = wasm.function("hello_len", [])
	# Get data from memory buffer (note: [0] = success flag, [1] = PoolByteArray)
	var result = wasm.memory.seek(ptr).get_data(len)
	
	if result[0] == 0:
		var data: PackedByteArray = result[1]
		var text = data.get_string_from_utf8()
		print("from wasm:", text)
	else:
		print("Failed to read memory.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
