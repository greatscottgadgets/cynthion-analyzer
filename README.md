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

To clean up and start from scratch:

`make clean`

To update Apollo on an attached Cynthion:

`make update-apollo`

To update analyzer gateware on an attached Cynthion:

`make update-analyzer`

To run Packetry:

`./packetry`
