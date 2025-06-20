# Godot 4 & Rust WebAssembly

<p align="center">
<img width="600" src="https://github.com/godot-game-samples/godot-wasm/blob/main/assets/screenshot/logo.png">
</p>

To use Rust with Godot 4, use godot-wasm.

**GitHub**

[godot-wasm](https://github.com/ashtonmeuser/godot-wasm)

Now, let's go ahead and install "godot-wasm" on Godot.

Create a new project with any name.

<img width="250" src="https://github.com/godot-game-samples/godot-wasm/blob/main/assets/screenshot/image_1.png">

Select the AssetLib tab and enter "asm" to find "godot-wasm".

<img width="350" src="https://github.com/godot-game-samples/godot-wasm/blob/main/assets/screenshot/image_2.png">

<img width="350" src="https://github.com/godot-game-samples/godot-wasm/blob/main/assets/screenshot/image_3.png">

Now, we will also create a project on the Rust side.

Create a new project with cargo new at an arbitrary location.

```
cargo new --lib rust --vcs none
```

```
cd rust
```

Add "cdylib" to the created Cargo.toml.

```
[package]
name = "rust"
version = "0.1.0"
edition = "2024"

[lib]
crate-type = ["cdylib"]

[dependencies]
```

Modify lib.rs as follows.

```
#![no_main]
#![no_std]

use core::panic::PanicInfo;

static MESSAGE: &str = "Hello WebAssembly!";

#[unsafe(no_mangle)]
pub extern "C" fn hello() -> *const u8 {
    MESSAGE.as_ptr()
}

#[unsafe(no_mangle)]
pub extern "C" fn hello_len() -> usize {
    MESSAGE.len()
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
```
Add wasm32-unknown-unknown with target and run build command.

```
rustup target add wasm32-unknown-unknown
cargo build --release --target wasm32-unknown-unknown
```

A wasm file is generated in the following path, and this is added to the Godot project.

```
target/wasm32-unknown-unknown/release/godot_wasm.wasm
```

<img width="250" src="https://github.com/godot-game-samples/godot-wasm/blob/main/assets/screenshot/image_4.png">

You can add them to Godot's file system by dragging and dropping.

<img width="250" src="https://github.com/godot-game-samples/godot-wasm/blob/main/assets/screenshot/image_5.png">

The file itself does not appear in the file system, but it is added.

Now, create a 2D scene in Godot, rename it to Main and attach the script.

<img width="250" src="https://github.com/godot-game-samples/godot-wasm/blob/main/assets/screenshot/image_6.png">

We will modify main.gd as follows.

```
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
```

If the Godot console displays "Hello WebAssembly!

<img width="300" src="https://github.com/godot-game-samples/godot-wasm/blob/main/assets/screenshot/image_7.png">

## Article

Here's an article with more details.

https://www.webcyou.com/?p=12274

## Author

**Daisuke Takayama**

-   [@webcyou](https://twitter.com/webcyou)
-   [@panicdragon](https://twitter.com/panicdragon)
-   <https://github.com/webcyou>
-   <https://github.com/webcyou-org>
-   <https://github.com/panicdragon>
-   <https://www.webcyou.com/>
