library(ggplot2)
library(data.table)
library(plotly)
library(forcats)

#Read in data
currentWr<-fread('current_wr.csv', header = TRUE)

#Normalize Characters
currentWr[Character %in% c('Baby Mario', 'Baby Luigi', 'Baby Peach', 'Baby Daisy', 'Baby Rosalina', 'Lemmy Koopa', 'Mii Light'),Character:='Baby Mario']
currentWr[Character %in% c('Toad', 'Shy Guy', 'Koopa Troopa', 'Lakitu', 'Wendy Koopa', 'Larry Koopa', 'Toadette'),Character:='Toad']
currentWr[Character %in% c('Peach', 'Daisy', 'Yoshi'),Character:='Peach']
currentWr[Character %in% c('Mario', 'Luigi', 'Iggy Koopa', 'Ludwig Koopa', 'Mii Medium'),Character:='Mario']
currentWr[Character %in% c('Donkey Kong', 'Waluigi', 'Rosalina', 'Roy Koopa'),Character:='Donkey Kong']
currentWr[Character %in% c('Metal Mario', 'Pink Gold Peach'),Character:='Metal Mario']
currentWr[Character %in% c('Wario', 'Bowser', 'Dry Bowser', 'Morton', 'Mii Heavy'),Character:='Wario']

#Normalize Bodies
currentWr[Vehicle %in% c('Standard Kart', 'Prancer', 'Cat Cruiser', 'Sneeker', 'The Duke', 'Teddy Buggy'),Character:='Standard Kart']
currentWr[Vehicle %in% c('Gold Standard', 'Mach 8', 'Circuit Special', 'Sports Coupe'),Character:='Gold Standard']
currentWr[Vehicle %in% c('Blue Falcon', 'Streetle'),Character:='Blue Falcon']
currentWr[Vehicle %in% c('Blue Falcon', 'Streetle'),Character:='Blue Falcon']
