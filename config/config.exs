# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :p2_dasm, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:p2_dasm, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"

#config %{p2_dasm: %{p2one:
#                    %{pinname: %{p0: :p2oneTX, p1: :p2oneRX},
#                    %{connections: [:p2oneTX, :p2oneRX]}
#                    }
#                   }
#}


## Configure the virtual P2 called ":p2one"

## configured_machines: list of machines to configure

## pins: When smartpins are created, they'll be registered with
# these names in the process registry

## connections: Each key points to a list of pins to send data to
# as they are electrically "connected".  Note - I put in both
# directions just we deal with protocols that switch directions.

## firmware: Automatically start the Hub with this firmware image

## initialstate: :stopped or :running.

config :p2_dasm, [
                  configured_machines: [:p2one],
                  p2one: %{pins:        %{p0: :p2oneTX, p1: :p2oneRX},
                           connections: %{p2oneTX: [:p2oneRX], p2oneRX: [:p2oneTX]},
                           firmware:    "smartpin_serial_turnaround.eeprom",
                           initialstate: :stopped
                          }
                 ]
