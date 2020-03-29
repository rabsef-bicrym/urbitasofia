!:
:-  %say
|=  [[now=@da eny=@uvJ bec=beak] [incometape=tape action=@tas ~] [customdeck=(list @ud) ~]]
:-  %noun
|^
=/  tempvaltape=(list @ud)  (convert incometape)
=/  swapdeck=deckform  ?~(customdeck deckbuilder (customdeckbuilder customdeck))
=/  tempvalcard=@ud  `@ud`(keystreamcard (findoperant (triplecut (jokerbfunc (jokerafunc swapdeck)))))
=/  passone=@ud  0
=|  numencodemsg=(list @ud)
^-  tape
|-
?~  tempvaltape
  (alphashift numencodemsg)
%=  $
  tempvalcard  `@ud`(keystreamcard (findoperant (triplecut (jokerbfunc (jokerafunc (findoperant (triplecut (jokerbfunc (jokerafunc swapdeck)))))))))
  numencodemsg  [?:(=(%encode action) (add i.tempvaltape tempvalcard) ?:((gte tempvalcard i.tempvaltape) (sub (add 26 i.tempvaltape) ?:((gth tempvalcard 26) (mod tempvalcard 26) tempvalcard)) (sub i.tempvaltape ?:((gth tempvalcard 26) (mod tempvalcard 26) tempvalcard)))) numencodemsg]
  tempvaltape  t.tempvaltape
  swapdeck  `deckform`(findoperant (triplecut (jokerbfunc (jokerafunc swapdeck))))
==
+$  suits  ?(%heart %spade %club %diamond %joker)
+$  value  ?(%ace %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 %jack %queen %king %a %b)
+$  card  ?([s=suits v=value])
+$  deckform  (list card)
++  suitlist  `(list suits)`~[%club %heart %spade %diamond]
++  suitpoints
  ^-  (map suits @ud)
  %-  my
  :~  :-  %club  0
      :-  %diamond  13
      :-  %heart  26
      :-  %spade  39
  ==
++  valuelist  `(list value)`~[%ace %2 %3 %4 %5 %6 %7 %8 %9 %10 %jack %queen %king]
++  valuepoints
  =/  valuepl=(list value)  valuelist
  =/  counter=@ud  1
  =|  valuemap=(map value @ud)
  |-  ^-  (map value @ud)
  ?~  valuepl
    valuemap
  $(valuemap (~(put by valuemap) i.valuepl counter), valuepl t.valuepl, counter +(counter))
++  deckbuilder
::  This deck's head is the bottom card in the deck, if using a physical deck
::  We recommend doing the manipulations with cards face up, if using a physical deck
::  Assuming the two above, your physical deck's top card (facing you) should be the Ace of Diamonds
::
  =/  deckvalue=(list value)  valuelist
  =/  decksuit=(list suits)  (flop suitlist)
  =|  deck=(list card)
  |-  ^-  deckform
  ?~  decksuit
    (into (into deck 13 `card`[%joker %a]) 27 `card`[%joker %b])
  ?~  deckvalue
    $(decksuit t.decksuit, deckvalue valuelist)
  $(deck [[i.decksuit i.deckvalue] deck], deckvalue t.deckvalue)
++  convert
  |=  msg=tape
  =.  msg  (cass msg)
  ^-  (list @ud)
  %+  turn  msg
  |=  a=@t
  (sub `@ud`a 96)
++  cardtovalue
  |=  crd=card
  ^-  @ud
  =/  suitpt=(map suits @ud)  suitpoints
  =/  valuept=(map value @ud)  valuepoints
  ?:  =(s.crd %joker)
      53
  (add (~(got by suitpt) s.crd) (add 1 (~(got by valuept) v.crd)))
++  jokerafunc
  |=  incomingdeck1=deckform
  ^-  deckform
  =/  startera  (find [%joker %a]~ incomingdeck1)
  =/  posita=@ud  ?~(startera ~|("No Joker A in Deck" !!) ?:(=(0 u.startera) 100 (dec u.startera)))
  ?:  =(posita 100)
    `deckform`(into `deckform`(oust [0 1] incomingdeck1) 51 `card`[%joker %a])
  `deckform`(into `deckform`(oust [+(posita) 1] incomingdeck1) posita `card`[%joker %a])
++  jokerbfunc
  |=  incomingdeck2=deckform
  ^-  deckform
  =/  starterb  (find [%joker %b]~ incomingdeck2)
  =/  positb=@ud  ?~(starterb ~|("No Joker B in Deck" !!) ?:((lth u.starterb 2) ?:(=(0 u.starterb) 100 101) (dec (dec u.starterb))))
  ?:  (gth positb 53)
    ?:  =(positb 100)
      `deckform`(into `deckform`(oust [0 1] incomingdeck2) 50 `card`[%joker %b])
    `deckform`(into `deckform`(oust [1 1] incomingdeck2) 51 `card`[%joker %b])
  `deckform`(into `deckform`(oust [(add positb 2) 1] incomingdeck2) positb `card`[%joker %b])
++  triplecut
  |=  incomingdeck3=deckform
  ^-  deckform
  =/  startera  (find [%joker %a]~ incomingdeck3)
  =/  starterb  (find [%joker %b]~ incomingdeck3)
  =/  posita=@ud  ?~(startera !! u.startera)
  =/  positb=@ud  ?~(starterb !! u.starterb)
  =/  higherjoker=@ud  ?:((gth posita positb) posita positb)
  =/  lowerjoker=@ud  ?:((lth posita positb) posita positb)
  =/  toptobottom=deckform  (slag +(higherjoker) incomingdeck3)
  =/  topcutlength=@ud  (lent toptobottom)
  =/  middle=deckform  (slag lowerjoker (oust [+(higherjoker) topcutlength] incomingdeck3))
  =/  midcutlength=@ud  (lent middle)
  =/  bottomtotop=deckform  (oust [lowerjoker (add midcutlength topcutlength)] incomingdeck3)
  `deckform`(weld (weld toptobottom middle) bottomtotop)
++  findoperant
  |=  incomingdeck4=deckform
  ^-  deckform
  =/  bcardval=@ud  (cardtovalue `card`(snag 0 incomingdeck4))
  =/  tempcutcards=deckform  (slag (sub 54 bcardval) incomingdeck4)
  =/  tempcardcut=deckform  (slag 1 (oust [(sub 54 bcardval) bcardval] incomingdeck4))
  =/  primacard=card  (snag 0 incomingdeck4)
  ?:  =(53 bcardval)
    `deckform`(findoperant (triplecut (jokerbfunc (jokerafunc incomingdeck4))))
  `deckform`(weld (into tempcutcards 0 primacard) tempcardcut)
++  keystreamcard
  |=  incomingdeck5=deckform
  ^-  @ud
  =/  opc=card  `card`(snag 53 incomingdeck5)
  =/  tempval=@ud  (cardtovalue opc)
  =/  keycard=card  (snag (sub 53 tempval) incomingdeck5)
  `@ud`(cardtovalue keycard)
++  alphashift
  |=  inclist=(list @ud)
  =|  outlist=tape
  |-
  ?~  inclist
    outlist
  $(outlist [`@t`(add 96 ?:((gth i.inclist 26) (mod i.inclist 26) i.inclist)) outlist], inclist t.inclist)
++  customdeckbuilder
  |=  decksettings=(list @ud)
  =/  valuefrom=(list value)  valuelist
  =|  outputdeck=deckform
  |-  ^-  deckform
  ?~  decksettings
    (flop outputdeck)
  ?:  &((gth i.decksettings 0) (lte i.decksettings 13))
    $(decksettings t.decksettings, outputdeck [`card`[%club (snag i.decksettings valuefrom)] outputdeck])
  ?:  &((gte i.decksettings 14) (lte i.decksettings 26))
    $(decksettings t.decksettings, outputdeck [`card`[%diamond (snag (sub i.decksettings 13) valuefrom)] outputdeck])
  ?:  &((gte i.decksettings 27) (lte i.decksettings 39))
    $(decksettings t.decksettings, outputdeck [`card`[%heart (snag (sub i.decksettings 26) valuefrom)] outputdeck])
  ?:  &((gte i.decksettings 40) (lte i.decksettings 52))
    $(decksettings t.decksettings, outputdeck [`card`[%spade (snag (sub i.decksettings 39) valuefrom)] outputdeck])
  ?:  =(53 i.decksettings)
    $(decksettings t.decksettings, outputdeck [`card`[%joker %a] outputdeck])
  ?:  =(54 i.decksettings)
    $(decksettings t.decksettings, outputdeck [`card`[%joker %b] outputdeck])
  !!  
--
