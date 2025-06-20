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