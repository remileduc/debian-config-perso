# some personnal aliases

# cowsay lit la température :
alias cowtemp='/home/sid/.cowsay_helper.sh'

alias updrade='sudo apt update && sudo apt upgrade && sudo apt-get autoremove --purge'

# éteint l'écran :
alias etoff='xset dpms force off'

# éteint compositing
alias compoff='qdbus org.kde.KWin /Compositor org.kde.kwin.Compositing.suspend'
# allume compositing
alias compon='qdbus org.kde.KWin /Compositor org.kde.kwin.Compositing.resume'

### DON'T FORGET TO ADD THESE LINES TO .bashrc AT THE END ###
## PERSO : appel de cowtemp
# cowtemp;
