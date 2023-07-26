# HP Envy 16-H1000 Linux Patches

Patches for [HP Envy 16-H1000](https://support.hp.com/us-en/product/hp-envy-16-inch-laptop-pc-16-h1000/2101525785) (tested specifically on: HP 16-H1023DX) to fixup the internal speakers on Linux.

## The Issue

The laptop features an internal amplifier+DSP ([Cirrus CS35L41](https://www.cirrus.com/products/cs35l41/)) to drive the speakers. However, the driver from the OEM have hardcoded the mappings of this amp into the vendor-specific Windows driver rather than using ACPI. Additionally, these vendor-specific drivers provide tuning in the form a binary blob specific for the hardware, however it is possible to use a generic tune to provide sound. 

Linux supports this amp, however it relies on the ACPI tables to provide the mappings need to intialize the device. This creates an issue, where the driver will refuse to initialize the amp since it expects to find this information through ACPI.

## The Fix

`acpi/` provides an SSDT patch that includes the mapping needed to initialize the driver. Build it using an ASL compiler (i.e iasl). You will then it to apply it to your installation. There are a variety of methods of applying DSDT/SSDT tables to the kernel.

`kernel/` provides a patch file that adds the laptop sound device to the HD-audio quirk table. This is needed for audio output.

## Issues

* Audio "isn't as loud" when compared to Windows. This fix will load the generic tune, so it might be that. Need to look into the OEM driver more.
* May need `sof-firmware` package to work.
* Microphone mute on keyboard not working.
* Need to disable Secure Boot to apply SSDT patch due to Kernel Lockdown.

## Related Works

* https://www.spinics.net/lists/alsa-devel/msg162072.html - Alternative approach, allows for secure boot via MOK
* https://bugzilla.kernel.org/show_bug.cgi?id=216194#c29 - Cirrus
