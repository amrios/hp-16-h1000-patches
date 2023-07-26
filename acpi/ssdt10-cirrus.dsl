DefinitionBlock("", "SSDT", 1, "HPQOEM", "8BE5    ", 0x0000000A)
{
    External (_SB_.GGIV, MethodObj)    // 1 Arguments
    External (_SB_.PC00.I2C1, DeviceObj)

    Name (GPIB, ResourceTemplate ()
    {
        GpioIo (Exclusive, PullDown, 0x0000, 0x0000, IoRestrictionOutputOnly,
            "\\_SB.GPI0", 0x00, ResourceConsumer, ,
            )
            {   // Pin list
                0x0131
            }
        GpioIo (Exclusive, PullUp, 0x0000, 0x0000, IoRestrictionInputOnly,
            "\\_SB.GPI0", 0x00, ResourceConsumer, ,
            )
            {   // Pin list
                0x0051
            }
        GpioIo (Shared, PullUp, 0x0064, 0x0000, IoRestrictionInputOnly,
            "\\_SB.GPI0", 0x00, ResourceConsumer, ,
            )
            {   // Pin list
                0x0132
            }
        GpioInt (Edge, ActiveBoth, Shared, PullUp, 0x0064,
            "\\_SB.GPI0", 0x00, ResourceConsumer, ,
            )
            {   // Pin list
                0x0132
            }
    })
    Scope (\_SB.PC00.I2C1)
    {
        Device (SPKR)
        {
            Name (_HID, "CSC3551")  // _HID: Hardware ID
            Method (_SUB, 0, NotSerialized)  // _SUB: Subsystem ID
            {
                If ((\_SB.GGIV (0x090E000C) == One))
                {
                    Return ("103C8BE5")
                }
                Else
                {
                    Return ("103C8BE6")
                }
            }

            Name (_UID, One)  // _UID: Unique ID
            Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
            {
                Name (IBUF, ResourceTemplate ()
                {
                    I2cSerialBusV2 (0x0040, ControllerInitiated, 0x000F4240,
                        AddressingMode7Bit, "\\_SB.PC00.I2C1",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                    I2cSerialBusV2 (0x0041, ControllerInitiated, 0x000F4240,
                        AddressingMode7Bit, "\\_SB.PC00.I2C1",
                        0x00, ResourceConsumer, , Exclusive,
                        )
                })
                Return (ConcatenateResTemplate (IBUF, GPIB))
            }

            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }

            Method (_DIS, 0, NotSerialized)  // _DIS: Disable Device
            {
            }

	Name (_DSD, Package ()
        {
            ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
            Package ()
            {
                Package () { "cirrus,dev-index", Package () { 0x0040, 0x0041 }},
                Package () { "reset-gpios", Package () {
                SPKR, Zero, Zero, Zero,
                    SPKR, Zero, Zero, Zero
                } },
                Package () { "spk-id-gpios", Package () {
                    SPKR, 0x02, Zero, Zero,
                    SPKR, 0x02, Zero, Zero
                } },
                Package () { "cirrus,speaker-position", Package () { Zero, One } },
                // gpioX-func: 0 not used, 1 VPSK_SWITCH, 2: INTERRUPT, 3: SYNC
                Package () { "cirrus,gpio1-func", Package () { One, One } },
                Package () { "cirrus,gpio2-func", Package () { 0x02, 0x02 } },
                // boost-type: 0 internal, 1 external
                Package () { "cirrus,boost-type", Package () { One, One } }
            },
        })
        }
    }
}

