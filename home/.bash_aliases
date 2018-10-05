# some personnal aliases

# cowsay lit la température :
alias cowtemp='/home/xinouch/.cowsay_helper.sh'

# éteint l'écran :
alias etoff='xset dpms force off'

# éteint compositing
alias compoff='qdbus org.kde.KWin /Compositor org.kde.kwin.Compositing.suspend'
# allume compositing
alias compon='qdbus org.kde.KWin /Compositor org.kde.kwin.Compositing.resume'

### DON'T FORGET TO ADD THESE LINES TO .bashrc AT THE END ###
## PERSO : appel de cowtemp
# cowtemp;
