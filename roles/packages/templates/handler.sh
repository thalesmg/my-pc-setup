#!/bin/bash
# Default acpi script that takes an entry for all actions

# $ cat /proc/asound/cards
# 0 [HDMI           ]: HDA-Intel - HDA Intel HDMI
#                      HDA Intel HDMI at 0xf7414000 irq 50
# 1 [PCH            ]: HDA-Intel - HDA Intel PCH
#                      HDA Intel PCH at 0xf7410000 irq 48
# $ cat /proc/asound/cards | awk '/^[0-9]/ && /Intel PCH/ { print $1 }'
# 1

mute () {
  amixer -c {{ acpid_sound_card_number }} sset Master mute
  amixer -c {{ acpid_sound_card_number }} sset Headphone mute
}

unmute () {
  amixer -c {{ acpid_sound_card_number }} sset Master unmute
  amixer -c {{ acpid_sound_card_number }} sset Headphone unmute
}

case "$1" in
    button/power)
        case "$2" in
            PBTN|PWRF)
                logger 'PowerButton pressed'
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    button/sleep)
        case "$2" in
            SLPB|SBTN)
                logger 'SleepButton pressed'
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    ac_adapter)
        case "$2" in
            AC|ACAD|ADP0)
                case "$4" in
                    00000000)
                        logger 'AC unpluged'
                        ;;
                    00000001)
                        logger 'AC pluged'
                        ;;
                esac
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    battery)
        case "$2" in
            BAT0)
                case "$4" in
                    00000000)
                        logger 'Battery online'
                        ;;
                    00000001)
                        logger 'Battery offline'
                        ;;
                esac
                ;;
            CPU0)
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    button/lid)
        case "$3" in
            close)
                logger 'LID closed'
                ;;
            open)
                logger 'LID opened'
                ;;
            *)
                logger "ACPI action undefined: $3"
                ;;
        esac
        ;;

    jack/headphone)
      case "$3" in
        HEADPHONE)
          case "$4" in
            plug)
              unmute
              ;;
            unplug)
              mute
              ;;
            *)
              logger "ACPI action undefined: $4"
              ;;
          esac
          ;;

        plug)
          unmute
          ;;

        unplug)
          mute
          ;;

        *)
          logger "ACPI thing undefined: $3"
          ;;
      esac
      ;;

    *)
        logger "ACPI group/action undefined: $1 / $2"
        ;;
esac

# vim:set ts=4 sw=4 ft=sh et:
