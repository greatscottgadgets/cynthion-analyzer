MAJOR ?= 1
MINOR ?= 3

ENV_PYTHON=environment/bin/python
ENV_INSTALL=environment/bin/pip install
TIMESTAMP=environment/timestamp
PLATFORM=cynthion.gateware.platform:CynthionPlatformRev$(MAJOR)D$(MINOR)
BOARD_VARS=BOARD_REVISION_MAJOR=$(MAJOR) BOARD_REVISION_MINOR=$(MINOR)
APOLLO_VARS=APOLLO_BOARD=cynthion $(BOARD_VARS)
FIRMWARE=dependencies/apollo/firmware/_build/cynthion_d11/firmware.bin
ANALYZER=cynthion.gateware.analyzer.top
PACKETRY=dependencies/packetry/target/release/packetry
APOLLO=environment/bin/apollo

all: analyzer firmware packetry

.PHONY: all clean analyzer firmware update-firmware update-apollo update-analyzer update-packetry

update-firmware:
	$(APOLLO_VARS) make -C dependencies/apollo/firmware get-deps
	$(APOLLO_VARS) make -C dependencies/apollo/firmware

update-apollo: firmware.bin
	dfu-util -d 1d50:615c --detach
	sleep 1
	dfu-util -d 1d50:615c --download firmware.bin

update-analyzer: analyzer.bit
	$(APOLLO) flash-erase
	$(APOLLO) flash-program analyzer.bit

update-packetry:
	cd dependencies/packetry; cargo build --release

firmware: firmware.bin

firmware.bin: $(FIRMWARE)
	cp $< $@

$(FIRMWARE): update-firmware

analyzer: analyzer.bit

analyzer.bit: $(TIMESTAMP) $(file < analyzer.deps)
	$(ENV_PYTHON) find-python-dependencies.py $(ANALYZER) > analyzer.deps
	LUNA_PLATFORM=$(PLATFORM) $(ENV_PYTHON) -m $(ANALYZER) -o $@

packetry: $(PACKETRY)
	cp $< $@

$(PACKETRY): update-packetry

environment:
	python -m venv environment

$(TIMESTAMP): environment
	$(ENV_INSTALL) -e dependencies/amaranth
	$(ENV_INSTALL) -e dependencies/amaranth-boards
	$(ENV_INSTALL) -e dependencies/amaranth-stdio
	$(ENV_INSTALL) -e dependencies/apollo
	$(ENV_INSTALL) -e dependencies/python-usb-protocol
	$(ENV_INSTALL) --no-deps -e dependencies/luna
	$(ENV_INSTALL) -e dependencies/cynthion/cynthion/python
	$(ENV_INSTALL) libusb1==1.9.2
	rm -rf dependencies/amaranth-stdio/build
	touch $(TIMESTAMP)

clean:
	rm -f firmware.bin analyzer.bit analyzer.deps packetry
	$(APOLLO_VARS) make -C dependencies/apollo/firmware clean
	rm -rf environment
