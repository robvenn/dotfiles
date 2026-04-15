# 03-functions.nu — Shell functions for interactive use

def o [...args: string] {
    match $nu."os-info".name {
        "macos" => { ^open ...$args }
        "windows" => { ^start ...$args }
        _ => { ^xdg-open ...$args }
    }
}
