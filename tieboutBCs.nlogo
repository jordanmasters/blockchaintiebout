extensions [ rnd ]



breed [groups group]
breed [parties party]

turtles-own [mygroup my-position dictator]
parties-own [incumbent]

globals [groupxys ordered-groups ordered-groups-set types popular-vote global-vote groups-positions a-pos a-pos-new]


to setup
  clear-all
  ask patches [set pcolor 63]
  make-groups

  decentralized-heirarchical-split ;; hardcode this so we done need to see it in the interface
  assign-groups-institution
  populate-groups
  populate-parties
  assign-dictators
  assign-proprep-incumbent

  reset-ticks
end

to assign-proprep-incumbent
  ask parties with [color = magenta and who < rows * columns] [set incumbent 1]


end

to go
  ; on first go, let each inst arrganement voting protocol choose between the available parties in a group
  ;
  ;
  ; for each jusisdiction,
  ; for each turtle in each jurisdiction
  ; check its position against all parties
  ;calculate-citizen-party-distance
  ; vote-in-jurisdiction
  ; switch-jurisdictions
  ;   check-if-grass-is-greener
  ;   move-to-greener-grass
  ; mutate non-incumbent parties
  ; 15-shades-of-grey update shade of grey of agents in relation to incumbent position in their jurisdiction




  ;calc-group-vote
  ;calc-popular-vote
  ;die-birth
  pick-a-party
  check-if-grass-is-greener


  mutate-non-incumbents
  tick
end

to assign-dictators
  let i 0
  while [i < olig-count]
  [
    ;show i
    ask one-of turtles with [mygroup = i and breed != groups and breed != parties] [set dictator 1]
    set i i + 1
  ]
end

to pick-a-party ; vote on and select the winning party in a jurisdiction based on inst arrangement
    ; given a jurisdiction, select (from TODO label) all the parties
    ; set party-scores up a [[ to hold total scores for all parties
    ; loop through the parties
    ;   set up x for this party
    ;   loop through each agent in the jurisdiction
    ;     cum sum them
    ;   lput array into party-scores
    ;
    ; parties have to have a bool? of incumbent
    ; set bool 1 to winner, losers 0
    ; coun tmutate non-incumbents here for comp efficientcy....
  ; for each jurisdiction
  let i 0
  while [i < rows * columns]
  [
    ;; each high level inner while loop here is executing part of the above while loop and jumping ahead...


    ; for each party in each jurisdiction for a given inst arrangement

    ; ok we have to cum join all the iter limits here cause of fixed group ordering
    ;
    ; OLIG
    ; pick a range citizen to the the dictator
    ; compare that agents score to all parties
    ; pick the closest
    let j 0
    let selected-party []
    ; Run through oligarch jurisdictions
    while [i < olig-count]
    [
      ;show "Oligarch Jurisdiction"
      ; check the dictator position against all the parties
      ; the one with the lowest difference should be set to incumbent 1
      ;ask turtles with [mygroup = i and ]
      let temp []
      let dict-pos []
      ask turtles with [mygroup = i and dictator = 1] [set dict-pos my-position]
      ;lput this instead of show - to list
      ;show dict-pos
      let dists []
      let dists-whos []
      ask turtles with [mygroup = i and breed = parties] [set dists lput calculate-citizen-party-distance my-position dict-pos dists set dists-whos lput who dists-whos]
      ;calculate-citizen-party-distance turtles with [mygroup = i and dictator = 1] turtles with
      ;show dists
      ;show dists-whos

      let temp-len length dists
      let ii 0
      let minval min dists
      ; Run through parties in jurisdiction
      while [ii < temp-len]
      [
        ; we need a tiebreaking procedure... otherwise we get multi dictators in a group on ties
        ; did it with one-of - did not work....
        ;  could build this into the setting of the if statement, jump to last ii on completing, why doesn't netlogo have "break"?
        ; in effect this selects the first of the tiebreak options
        if item ii dists = minval [ask parties with [who = item ii dists-whos] [ask parties with [mygroup = i] [set incumbent 0] set incumbent 1 set ii temp-len]]
        set ii ii + 1
      ]
      set i i + 1
      ;;
    ]

    ; DEMREF
    ; Each agent votes for the party that gives her the highest utility.
    ; median of votes - this assumes only 2 parties......tell me im wrong.... it has to if reasonably based on median...


    ; Run through demref jurisdictions
    while [i < olig-count + demref-count]
    [
      ;show "demREF"
      ; run through all agents in the group and compare them to the party
      ; keep a running tally

      ; loop through all loci in positions
      ; loop through all agents in jurisdiction and take mode of their vector of their positions
      ; append mode to a new list
      let loci 0
      let new-pos []
      while [loci < issues] [
        ;
        let loci-votes []
        let loci-mode 0

        ask turtles with [mygroup = i and breed != parties and who > rows * columns] [set loci-votes lput item loci my-position loci-votes]
        ;show loci-votes
        ;show one-of modes loci-votes
        set loci loci + 1
        set new-pos lput one-of modes loci-votes new-pos
      ]
      ;show new-pos
      ;ask turtles with [mygroup = i and breed = parties] [set incumbent 0] always only one incumbent
      ask one-of turtles with [mygroup = i and breed = parties] [set my-position new-pos set incumbent 1] ; just one, dont need one-of


      set i i + 1
    ]

    ; DIRCOMP
    ; Each agent votes for the party that gives her the highest utility.
    ; winning party implements its platform in the jurisdiction
    ;let j 0
    while [i < olig-count + demref-count + dircomp-count]
    [
      ;show "DirComp Jurisdiciton"
      ; run through all agents in the group and compare them to one of the two parties
      ; keep a running tally
;      let dists []
      let dists-whos []
      let dists-scores []
      let party-who-votes []
      ; highest level loop should be based on citzens in group since we want their votes
      ask turtles with [mygroup = i and breed != parties and who > rows * columns] [
        ;; loop through parties in a jurisdiction
        let cit-pos my-position
        let parties-whos []
        let dists []
        ask turtles with [mygroup = i and breed = parties] [
          set parties-whos lput who parties-whos
          set dists lput calculate-citizen-party-distance my-position cit-pos dists
          ;show "cit vs party"
          ;show cit-pos
          ;show my-position
        ]
        let min-dist min dists
        let k 0
        while [k < length dists][
          if item k dists = min-dist [set party-who-votes lput item k parties-whos party-who-votes set k length dists]
          set k k + 1
        ]
        ;show parties-whos
        ;show dists
        ;show party-who-votes
;        while [ii < demref-parties-count] [
;          show calculate-citizen-party-distance my-position dict-pos
;          show calculate-citizen-party-distance my-position dict-pos
;        ]
      ]
      ;show party-who-votes
      let incumb one-of modes party-who-votes
      ;show incumb
      ask parties with [who = incumb] [ask parties with [mygroup = i] [set incumbent 0] set incumbent 1]
      set i i + 1



    ]

    ; PROPREP - Do this tomorrow, fuck it!  not need for finishing and running poc sims & analysis...
    ; This seems like....
    ; Each agent votes for the party that gives her the highest utility.
    ; then use this proportion to weighted vote on each invidivual issue
    ; Their description & code is inconsistent
    while [i < olig-count + demref-count + dircomp-count + proprep-count]
    [
     show "magenta!"
      ;; maybe use this procedure for all sets
     if sum [incumbent] of parties with [mygroup = i and breed = parties] = 0 [
     ask one-of turtles with [mygroup = i and breed = parties] [set incumbent 1]
      ] ; just one, dont need one-of



     ; First do mode voting like in the base of Dircomp
     ; then use the proportional voting ratios to do referendum voting



     show i
     show olig-count + demref-count + dircomp-count + proprep-count





     set i i + 1

    ]


  ;set i i + 1
  ]
end

; could use first observed higher value or max after scanning all
to check-if-grass-is-greener
  ; for each agent, loop through all incumbent positions and make a list of the compared values
  ; take the index of the highest value and move (die->ressurect) the agent to that group

  ; ask citizen turtles to look at each other incument group, do the dist comp
  ; and if it is lower than theirs in their group, replace the value of the will-move-to var with that
  ask turtles with [who >= rows * columns and breed != parties] [
;    show " "
;    show "TURTLE:"
    ;show who
    let mygroup-temp mygroup
    let my-position-temp my-position
    let best-alt mygroup
    let my-group-diff 0
    ;ask parties with [mygroup = mygroup-temp and incumbent = 1] [set my-group-pos my-position]
    ;let diff calculate-citizen-party-distance my-position my-group-pos
    ;show "my-pos vs my-pos-group"
    ;show diff
    let better-jurisdictions-for-me []
    let better-diff-for-me []
    ; get the current different from given agent to its incumbent in its group
    ;let temp1 0
    let my-status 0
    ask parties with [mygroup = mygroup-temp and incumbent = 1]
    [
      ;show "vs my incumbent"
      ;show who
      set my-group-diff calculate-citizen-party-distance my-position-temp my-position
;      show my-group-diff
      ;set temp1 temp1 + 1
      set my-status my-group-diff
      set better-jurisdictions-for-me lput mygroup better-jurisdictions-for-me
      set better-diff-for-me lput my-group-diff better-diff-for-me
    ]
    ;show temp1


    ; Check all other incumbents parties
    ;let temp2 0
    ;let better-jurisdictions-for-me []
    ;let better-diff-for-me []
    ask parties with [mygroup != mygroup-temp and incumbent = 1]
    [
      ;show "grass is greener"
      ;show who
      set my-group-diff calculate-citizen-party-distance my-position-temp my-position
      ;show my-group-diff
      ;set temp2 temp2 + 1
      if my-status > my-group-diff [
        set better-jurisdictions-for-me lput mygroup better-jurisdictions-for-me
        set better-diff-for-me lput my-group-diff better-diff-for-me
      ]
    ]
    ;show temp2
    ;show "I would switch to..."
    ;show better-jurisdictions-for-me
    ;show better-diff-for-me

    let pp 0
    let move-to-jur 0
    ; ERROR Can't find the minimum of a list with no numbers: []
    ; this could be fixed by just always applying your own group to the possible places to move to...
    ; this worked
    let my-min min better-diff-for-me
    while [pp < length better-diff-for-me] [
      if item pp better-diff-for-me = my-min [set move-to-jur item pp better-jurisdictions-for-me]
      set pp pp + 1
    ]
    ;show mygroup
    ;show "moving to:"
    ;show move-to-jur

    ; use the group we want to move to and get the color of the jurisdiction - by selecting turtle with who < rows * columns
    ; relabel the agent in questions my-group and color!

    let new-color color

    ; this is stupidly running M number of times for one operation instead of 1 only once.. optimize if time
    ask turtles with [who < rows * columns and mygroup = move-to-jur] [set new-color color set mygroup move-to-jur]
    ;show new-color
    set color new-color

  ]



  ; at the end of each run through the jurisdictions, move the turtle to its best option (move can be only in group label, and not visually or spacially.... do this first -
  ; this may actually just be better in general, less computationally intesne, and no overhead at all)
  ;
end

to mutate-non-incumbents
  ; run this after all pick-a-party loops have run
  ; loop through all jurisdictions,
  ;   loop through all parties and if they are not incumbent, do one mutation to them
  let i 0
  while [i < rows * columns]
  [
    ask parties with [mygroup = i and incumbent = 0] [set my-position mutate-position my-position ] ; show "mutated-non-incumbent"
    set i i + 1

  ]
end


; used like:
; set a-pos mutate-position a-pos ; show a-pos ----- for full replacement
to-report mutate-position [a-position]
  let len length a-position
;  show "len"
;  show len
  let rng range len
;  show "rng"
;  show rng
  let loci one-of rng
;  show "loci"
;  show loci
  ; do the flipping
  ifelse item loci a-position = 0 [set a-position replace-item loci a-position 1] [set a-position replace-item loci a-position 0]
  report a-position

end

to calc-popular-vote
  set popular-vote (sum [my-position] of turtles) / (count turtles - (rows * columns))
end

to make-groups
  set-default-shape turtles "circle"
  create-groups rows * columns
  [
    ;hide-turtle        ;; we don't want to see the spawners
  ]
  arrange-groups
  ;set first-parens nobody
end

to arrange-groups
  ;; arrange the groups around the world in a grid
  let i 0
  while [i < rows * columns]
  [
    ask turtle i
    [
      set color gray
      set size 2
      let x-int world-width / columns
      let y-int world-height / rows
      setxy (-1 * max-pxcor + x-int / 2 + (i mod columns) * x-int)
            (max-pycor + min-pycor / rows - int (i / columns) * y-int)
    ]
    set i i + 1
  ]
end

to assign-groups-institution ; this should also assign them with some other label is nessecary - we might just use color for all inst labels.
  let i 0
  while [i < olig-count]
    [
      ask turtles with [who = i] [set color red]
    set i i + 1
    ]
  while [i < demref-count + olig-count]
    [
      ask turtles with [who = i] [set color blue]
    set i i + 1
    ]
  while [i < dircomp-count + demref-count + olig-count]
    [
      ask turtles with [who = i] [set color yellow]
    set i i + 1
    ]
  while [i < proprep-count + dircomp-count + demref-count + olig-count]
    [
      ask turtles with [who = i] [set color magenta]
    set i i + 1
    ]

end

;; hide this later
to decentralized-heirarchical-split
  ask turtles with [who < rows * columns] [

    ;;if random-float 1 > percent-acephalous
    ;;hide-turtle


  ]
end

to populate-groups
  ; order the list of groups for easy processing
  ; remove from globals - keep this local
  set ordered-groups sort-on [who] turtles

  ; convert the ordered list to an agentset
  set ordered-groups-set turtles with [member? self ordered-groups]

  ;set ordered-groups-set sort-on [whoc ordered-groups-set
  ; create a list of all the xy cors for each group location
  ; there is too much redundency in lists here
  set groupxys [ (list who xcor ycor) ] of ordered-groups-set with [who < rows * columns]
  ;let mygr 0

  ;let group-num 0
  foreach groupxys [
    [ xy_coords ] ->
    populate-group group-radius group-count item 1 xy_coords item 2 xy_coords item 0 xy_coords
    ;mygr
    ;set group-num group-num + 1
  ]
end


to populate-group [radius n x_cors y_cors mygr]
  ;layout-circle turtles 10
  ;; turtles should be evenly spaced around the circle

  create-ordered-turtles n [

    set size 0.3  ;; easier to see
    set mygroup mygr ;; brand turtle with group label
    setxy x_cors y_cors ;; position at group location
    fd radius
    rt 90
    set my-position []
    let i 0
    while [i < issues] [
      set my-position lput one-of [1 0] my-position
      set i i + 1
    ]
    ; set the position for each turtle in a group to unifor between [-1,1] this could be done globally, but for speed of coding...!
    ;set my-position random-float 2 - 1
;    set vote-prob 1 / sqrt group-count

    if mygr < olig-count [set color red]
    if mygr >= olig-count and mygr < olig-count + demref-count [set color blue]
    if mygr >= olig-count + demref-count and mygr < olig-count + demref-count + dircomp-count  [set color yellow]
    if mygr >= olig-count + demref-count + dircomp-count [set color magenta]
;    if my-position > 0 [set color yellow]
;    if my-position < 0 [set color blue]
    ;; this is the hackiest single band-aid which should do fine for the amount of batch runs we are trying to do, but perhaps put one more level of manual recursion to force it if its an issue.
    ;if my-position = 0 [set my-position random-float 2 - 1 ]



  ]
end




;; these procedures are for creating the psrties, placing, and initing them with coin values
to populate-parties
  ; order the list of groups for easy processing
  ; remove from globals - keep this local
  set ordered-groups sort-on [who] turtles

  ; convert the ordered list to an agentset
  set ordered-groups-set turtles with [member? self ordered-groups]

  ;set ordered-groups-set sort-on [whoc ordered-groups-set
  ; create a list of all the xy cors for each group location
  ; there is too much redundency in lists here
  set groupxys [ (list who xcor ycor) ] of ordered-groups-set with [who < rows * columns]
;  foreach
  ;set groupxys2
  ;let mygr 0
  ;show ordered-groups
  ;show groupxys
  ;let group-num 0
  ;let i 0
  foreach groupxys [
    [ xy_coords ] ->
    ;; assuming that we always populate groups in serial order like we did in assign-groups-institution we can just use if statments to make sure we are addressing the correct groups with the right party counts.
    let temp-count 0
    let i item 0 xy_coords
    if i < olig-count
    [
      ;show "olig test in loop"
      ;show xy_coords
      ;show olig-party-count
      ;ask turtles with [who = i] [set color red]
      set temp-count olig-party-count
      ;set i i + 1
    ]

    if i >= olig-count and i < demref-count + olig-count
    [
      ;;ask turtles with [who = i] [set color blue]
      set temp-count demref-party-count
      ;set i i + 1
    ]
    if i >= demref-count + olig-count and i < dircomp-count + demref-count + olig-count
    [
      set temp-count dircomp-party-count
      ;set i i + 1
    ]
    if i >= dircomp-count + demref-count + olig-count ; dont think i need this condition --- and i < dircomp-count + demref-count + olig-count
    [
      set temp-count proprep-party-count
      ;set i i + 1
    ]
    ;show "temp count right before populate"
    ;show temp-count

    populate-party party-radius temp-count item 1 xy_coords item 2 xy_coords item 0 xy_coords
    ;mygr
    ;set group-num group-num + 1
    set temp-count temp-count + 1
  ]
end


; this is a super simple version of the situation
; ideally use the economist formula: -(distance^2)
; since we only have binary values, all we have to do here is check if each corresponding entry is identical, if not, they are different and add one to the distance
to-report calculate-citizen-party-distance [cit-pos party-pos]
  ;show "running calculate-citizen-party-distance"
  let len length cit-pos
  let i 0
  let diff 0
  while [i < len]
  [
    if item i cit-pos != item i party-pos [
      set diff diff + 1
    ]
    set i i + 1
  ]
  ;show diff
  report diff
end




to populate-party [radius n x_cors y_cors mygr]
  ;layout-circle turtles 10
  ;; turtles should be evenly spaced around the circle
  create-ordered-parties n [

    set size 0.6  ;; easier to see
    set mygroup mygr ;; brand turtle with group label
    ;set party 1
    setxy x_cors y_cors ;; position at group location
    fd radius
    rt 90
    set my-position []
    let i 0
    while [i < issues] [
      set my-position lput one-of [1 0] my-position
      set i i + 1
    ]
    set color black



  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
627
12
1283
669
-1
-1
19.64
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

SLIDER
147
197
265
230
rows
rows
1
10
2.0
1
1
NIL
HORIZONTAL

SLIDER
147
157
265
190
columns
columns
1
10
2.0
1
1
NIL
HORIZONTAL

BUTTON
17
70
83
103
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
99
23
162
56
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
165
23
246
56
go once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1934
800
2072
833
NIL
populate-groups
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1934
668
2086
701
NIL
clear-all\nreset-ticks
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1934
712
2050
745
NIL
make-groups
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1620
641
1798
674
percent-acephalous
percent-acephalous
0
1
0.0
0.01
1
NIL
HORIZONTAL

BUTTON
1932
759
2159
792
NIL
decentralized-heirarchical-split
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
17
198
138
231
group-count
group-count
1
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
19
157
140
190
group-radius
group-radius
-1
3
1.5
0.5
1
NIL
HORIZONTAL

TEXTBOX
20
21
89
55
Setup
24
0.0
1

TEXTBOX
1935
614
2146
644
Manual Setup\n
24
0.0
1

SLIDER
2220
702
2392
735
p
p
0
1 - q - r
0.82
0.01
1
NIL
HORIZONTAL

SLIDER
2219
742
2391
775
q
q
0
1 - p - r
0.09
0.01
1
NIL
HORIZONTAL

SLIDER
2219
782
2391
815
r
r
0
1 - p - q
0.09
0.01
1
NIL
HORIZONTAL

TEXTBOX
2219
656
2544
685
p q r - Joint Force maxed to 1
22
0.0
1

PLOT
2110
77
2310
227
Popular Vote
NIL
NIL
0.0
10.0
-1.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot popular-vote"

MONITOR
1981
52
2076
97
NIL
popular-vote
17
1
11

PLOT
2116
282
2316
432
Global Vote
NIL
NIL
0.0
10.0
-1.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot global-vote"

SLIDER
423
239
595
272
olig-party-count
olig-party-count
1
5
2.0
1
1
NIL
HORIZONTAL

SLIDER
422
275
594
308
demref-party-count
demref-party-count
1
1
1.0
1
1
NIL
HORIZONTAL

SLIDER
421
311
595
344
dircomp-party-count
dircomp-party-count
0
5
2.0
1
1
NIL
HORIZONTAL

SLIDER
422
349
595
382
proprep-party-count
proprep-party-count
0
5
2.0
1
1
NIL
HORIZONTAL

TEXTBOX
422
211
572
231
Party counts
16
0.0
1

SLIDER
422
43
594
76
olig-count
olig-count
0
rows * columns - demref-count - dircomp-count - proprep-count
1.0
1
1
NIL
HORIZONTAL

SLIDER
421
82
593
115
demref-count
demref-count
0
rows * columns - olig-count - dircomp-count - proprep-count
1.0
1
1
NIL
HORIZONTAL

SLIDER
420
121
594
154
dircomp-count
dircomp-count
0
rows * columns - olig-count - demref-count - proprep-count
1.0
1
1
NIL
HORIZONTAL

SLIDER
421
159
595
192
proprep-count
proprep-count
0
rows * columns - olig-count - demref-count - dircomp-count
1.0
1
1
NIL
HORIZONTAL

TEXTBOX
424
20
574
40
Institution Count
16
0.0
1

MONITOR
279
171
376
216
Citizen Count
columns * rows * group-count
0
1
11

SLIDER
18
120
141
153
party-radius
party-radius
-1
1
-0.6
.2
1
NIL
HORIZONTAL

SLIDER
423
406
595
439
issues
issues
1
20
20.0
1
1
NIL
HORIZONTAL

PLOT
2140
488
2340
638
plot 1
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles"

PLOT
32
266
360
595
Avg Citizens Per Jurisdiction Type
NIL
NIL
0.0
10.0
10.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -2674135 true "" "plot count turtles with [color = red] / olig-count"
"pen-1" 1.0 0 -13345367 true "" "plot count turtles with [color = blue] / demref-count"
"pen-2" 1.0 0 -1184463 true "" "plot count turtles with [color = yellow] / dircomp-count"
"pen-3" 1.0 0 -5825686 true "" "plot count turtles with [color = magenta] / proprep-count"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
