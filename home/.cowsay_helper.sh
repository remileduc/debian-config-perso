#!/bin/bash
#
# cowsay lit la température

# Début script
{
# cow file
  ((cow = RANDOM * 50 / 32767 + 1));
# cow appearence (young, deand...)
  ((app = RANDOM * 11 / 32767 + 500));
# cowthink/say
  ((say = RANDOM * 4 / 32767 + 600));

  clear;

  printf \
      "$(date "+%A %d %B %Y, %T.%N")
      $(($(cat /sys/class/thermal/thermal_zone2/temp) / 1000))°C    |    $(($(cat /sys/class/thermal/thermal_zone3/temp) / 1000))°C" | \
      $(grep $(printf %03d $say) ~/.cowsay_cows.perso | cut -f 2) \
      $(grep $(printf %03d $app) ~/.cowsay_cows.perso | cut -f 2) -f \
      $(grep $(printf %03d $cow) ~/.cowsay_cows.perso | cut -f 2) \
      -W 75;

# Affiche les options de cowsay choisis (say/think, apparence et cows)
  echo -e \
      "$(grep $(printf %03d $say) ~/.cowsay_cows.perso | cut -f 2)" \
      "$(grep $(printf %03d $app) ~/.cowsay_cows.perso | cut -f 2) -f" \
      "$(grep $(printf %03d $cow) ~/.cowsay_cows.perso | cut -f 2) \n\n";
}
# Fin script
