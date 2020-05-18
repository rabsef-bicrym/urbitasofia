/+  *server, default-agent, verb
/=  tile-js
  /^  octs
  /;  as-octs:mimes:html
  /:  /===/app/hud/js/tile
  /|  /js/
      /~  ~
  ==
/=  hud-png
  /^  (map knot @)
  /:  /===/app/hud/img  /_  /png/
=,  format
::
|%
+$  card  card:agent:gall
+$  state-base
  $:  %0
      ::  My Ship Values
      baseh=@uv                           ::  Current base hash
      homeh=@uv                           ::  Current home hash
      uptime=cord                         ::  Uptime in cord format
      leef=(unit @ud)                     ::  Lives
      reef=(unit @ud)                     ::  Rifts
      bootup=tarp                         ::  Start of uptime in @da
      timecheck=@                         ::  Checks if you've been offline
      ::  Other Ship Values
      oleef=(unit @ud)                    ::  Other Lives
      oreef=(unit @ud)                    ::  Other Rifts
  ==
--
::
=|  state-base
=*  state  -
::
%+  verb  |
^-  agent:gall
=<
|_  bol=bowl:gall
+*  this  .
    auxil-core  +>
    aux  ~(. auxil-core bol)
    def  ~(. (default-agent this %|) bol)
::
  ++  on-init
    ^-  (quip card:agent:gall _this)
    =/  launcha
      [%launch-action !>([%add %hud /hudtile '/~hud/js/tile.js'])]
    :_  this
    :~  [%pass / %arvo %e %connect [~ /'~hud'] %hud]
        [%pass /hud %agent [our.bol %launch] %poke launcha]
        [%pass / %arvo %b %wait (add now.bol ~s1)]
    ==
  ++  on-save  !>(state)
  ++  on-load   ~&  'OK'  on-load:def
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card:agent:gall _this)
    ?+  mark  (on-poke:def mark vase)
      %handle-http-request
        =+  !<([eyre-id=@ta =inbound-request:eyre] vase)
        :_  this
        %+  give-simple-payload:app  eyre-id
        %+  require-authorization:app  inbound-request
        poke-handle-http-request:aux
      %noun
        ::  ~&  'Current HUD Data: '  :: if you want to see notice
        ::  ~&  state :: if you want to see state
        :_  this
        :~  [%pass / %arvo %b %wait (add now.bol ~m1)]
        [%give %fact ~[/hudtile] %json !>((to-json.aux state))]  ==
      %update-hud
        ::  ~&  'Current HUD Data: '  :: if you want to see notice
        ::  ~&  state :: if you want to see state
        ::
        :_  this(timecheck (add now.bol ~m2))
        :~  [%pass / %arvo %b %wait (add now.bol ~m1)]
        [%give %fact ~[/hudtile] %json !>((to-json.aux state))]  ==
      %json
        =^  cards  state
        (poke-json.aux !<(json vase))
        [cards this]
    ==
  ++  on-watch
    |=  =wire
    ^-  (quip card _this)
    ?+  wire  (on-watch:def wire)
      [%http-response *]
        `this
      [%hudtile ~]
        :_  this
        [%give %fact ~ %json !>((to-json.aux state))]~
    ==
  ++  on-leave  on-leave:def
  ++  on-peek   on-peek:def
  ++  on-agent  on-agent:def
  ++  on-arvo
    |=  [=wire =sign-arvo]
    ^-  (quip card _this)
    ?:  ?=(%wake +<.sign-arvo)
      ?:  (gth `@`now.bol timecheck)
        :_  %=  this
            bootup  (yell now.bol)
            uptime  '0 d 0 hrs 0 min'
            baseh  (poke-bh.aux %base)
            homeh  (poke-bh.aux %home)
            leef  (poke-lr.aux [%life our.bol])
            reef  (poke-lr.aux [%rift our.bol])  ==
        :~  [%pass / %arvo %d %flog %text "You've been offline"]
        [%pass / %agent [our.bol %hud] %poke %update-hud !>(~)]  ==
        :_  %=  this
            baseh  (poke-bh.aux %base)
            homeh  (poke-bh.aux %home)
            leef  (poke-lr.aux [%life our.bol])
            reef  (poke-lr.aux [%rift our.bol])              
            uptime  (tarpsicord.aux (uptime-check.aux (yell now.bol)))  ==
        :~  ::  [%pass / %arvo %d %flog %text "Online check passed"]
        [%pass / %agent [our.bol %hud] %poke %update-hud !>(~)]  ==
    ?.  ?=(%bound +<.sign-arvo)
      (on-arvo:def wire sign-arvo)
    [~ this]
  ++  on-fail   on-fail:def
--
|_  bol=bowl:gall
  ++  tarpsicord
    |=  in=tarp
    =/  days=tape   (weld (scow %ud d.in) " d ")
    =/  hours=tape  (weld (scow %ud h.in) " hrs ")
    =/  min=tape    (weld (scow %ud m.in) " min")
    =/  timetape=tape  (weld days (weld hours min))
    (crip timetape)
  ++  poke-bh
    |=  action=?(%base %home)
    =/  o=@ta  (scot %p our.bol)
    =/  n=@ta  (scot %da now.bol)
    ^-  @uv
    ?-  action
        %base  .^(@uv %cz ~[o ~.base n])
        %home  .^(@uv %cz ~[o ~.home n])
    ==
  ++  poke-lr
    |=  [action=?(%life %rift) p=@p]
    =/  n=@ta  (scot %da now.bol)
    ::  lol pp
    ::
    =/  o=@ta  (scot %p p)
    ?-  action
        %life  .^((unit @ud) %j `path`~[o ~.lyfe n o])
        %rift  .^((unit @ud) %j `path`~[o ~.ryft n o])
    ==
  ++  poke-json
    |=  jon=json
    =,  dejs:format
    ^-  (quip card _state)
    =|  p=@p
    ?.  ?=(%o -.jon)
      [~ state]
    =/  top=tape  (trip (~(gut by ((om so) jon)) 'patp-query' ''))
    ?~  top
      :_  %=  state
        oleef  ~
        oreef  ~  ==
      [%pass / %agent [our.bol %hud] %poke %update-hud !>(~)]~
    ?:  =('~' i.top)
      =/  cb=dime  (scan t.top crub:^so)
      =.  p  `@p`+.cb
      :_  %=  state
          oleef  (poke-lr [%life p])
          oreef  (poke-lr [%rift p])  ==
      [%pass / %agent [our.bol %hud] %poke %update-hud !>(~)]~
    =/  cb=dime  (scan top crub:^so)
    =.  p  `@p`+.cb
    :_  %=  state
        oleef  (poke-lr [%life p])
        oreef  (poke-lr [%rift p])  ==
    [%pass / %agent [our.bol %hud] %poke %update-hud !>(~)]~
++  poke-handle-http-request
    |=  =inbound-request:eyre
    =+  url=(parse-request-line url.request.inbound-request)
    ?+  site.url  not-found:gen
        [%'~hud' %js %tile ~]    (js-response:gen tile-js)
    ::
        [%'~hud' %img @t *]
      =/  name=@t  i.t.t.site.url
      =/  img  (~(get by hud-png) name)
      ?~  img
        not-found:gen
      (png-response:gen (as-octs:mimes:html u.img))
    ==
  ++  uptime-check
    |=  tempnow=tarp
    ^-  tarp
    =|  currup=tarp
    ?:  =(bootup `tarp`[d=0 h=0 m=0 s=0 f=~])
      =.  currup  [d=0 h=0 m=0 s=0 f=~]
      `tarp`currup
    =/  startmin=@ud  (add (mul d.bootup 1.440) (add (mul h.bootup 60) m.bootup))
    =/  nowmin=@ud    (add (mul d.tempnow 1.440) (add (mul h.tempnow 60) m.tempnow))
    =/  uptotal=@ud   ?:((gte nowmin startmin) (sub nowmin startmin) 0)
    =/  da=@ud        (div uptotal 1.440)
    =.  uptotal       (mod uptotal 1.440)
    =/  ha=@ud        (div uptotal 60)
    =.  uptotal       (mod (mod uptotal 1.440) 60)
    =/  ma=@ud        uptotal
    =.  currup  `tarp`[d=da h=ha m=ma s=0 f=~]
    `tarp`currup
  ++  to-json
    |=  stat=_state
    ^-  json
    %-  pairs:enjs:format
    :~  :+  %base
            %s
        (scot %uv baseh.stat)
        :+  %home
            %s
        (scot %uv homeh.stat)
        :+  %uptime
            %s
        uptime.stat
        :+  %life
            %s
        ?~(leef.stat '' (scot %ud u.+.leef.stat))
        :+  %rift
            %s
        ?~(reef.stat '' (scot %ud u.+.reef.stat))
        :+  %olife
            %s
        ?~(oleef.stat '' (scot %ud u.+.leef.stat))
        :+  %orift
            %s
        ?~(oreef.stat '' (scot %ud u.+.reef.stat))
    ==
--