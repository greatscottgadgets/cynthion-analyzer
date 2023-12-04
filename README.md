# Cynthion USB Analyzer Integration Environment

This repository is for developing the USB analyzer mode of [Cynthion](https://greatscottgadgets.com/cynthion/).

It includes several other projects as submodules to aid with making changes across all of them:
- [Apollo](https://github.com/greatscottgadgets/apollo)
- [Amaranth](https://github.com/amaranth-lang/amaranth) (plus `-boards` and `-stdio`)
- [LUNA](https://github.com/greatscottgadgets/luna)
- [Cynthion](https://github.com/greatscottgadgets/luna)
- [Packetry](https://github.com/greatscottgadgets/packetry)

## Usage

To set up the environment and build everything:

`make`

To update Apollo on an attached Cynthion:

`make update-apollo`

To update analyzer gateware on an attached Cynthion:

`make update-analyzer`

To run Packetry:

`./packetry`

## Modifications

If you make changes to any of the submodules, they should be picked up automatically when you run `make`.

This works because:
- It always runs `make` for the Apollo firmware.
- It always runs `cargo build` for Packetry.
- All Python submodules are installed in editable mode.
- All Python files the gateware depends on are detected and saved in `analyzer.deps` using [this trick](https://stackoverflow.com/questions/52715864/python-create-makefile-of-dependencies), so if any of them change, the gateware will be automatically rebuilt.

Still, this is probably not completely foolproof, so if you want to clean up and start from scratch just run:

`make clean`

Note that this does not run `cargo clean` for Packetry, because Cargo's own caching works well, and the Rust dependencies take a long time to build.
