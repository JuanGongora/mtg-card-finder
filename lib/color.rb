require "tco"

conf = Tco.config
conf.names["purple"] = "#622e90"
conf.names["dark-blue"] = "#2d3091"
conf.names["blue"] = "#00aaea"
conf.names["green"] = "#02a552"
conf.names["yellow"] = "#fdea22"
conf.names["orange"] = "#f37f5a"
conf.names["red"] = "#eb443b"
conf.names["light_purp"] = "#c8c2ce"
Tco.reconfigure conf

COLORS = ["purple", "dark-blue", "blue", "green", "yellow", "orange", "red", "light_purp"]

mtg = <<-EOS
----------BB----BB-----------BBBBBBBBB-------BBBBBBBBB-----
---------BBBB--BBBB-------------BBB--------BBBB-----BBB----
-------BBBBBBBBBBBBBB-----------BBB--------BBB-------------
-----BBBB----BB----BBBB---------BBB--------BBB------BBBBBB-
----BBB--------------BBB--------BBB--------BBBB-------BBB--
--BBBBBB------------BBBBBB------BBB---------BBBBBBBBBBB----
-----------------------------------------------------------
----BBBBBBB--------BBBB--------BBBBBBB------BBBBBBB--------
---BBB------------BB--BB-------BB---BBB-----BB----BBB------
--BBB------------BBB--BBB------BB---BBB-----BB-----BBB-----
--BBB-----------BBBBBBBBBB-----BBBBBB-------BB-----BBB-----
---BBB---------BBB-----BBBB----BB---BBB-----BB----BBB------
----BBBBBB----BBB-------BBBB---BB----BBB----BBBBBBB--------
-----------------------------------------------------------
---BBBBBBBBBB--BB--BBB------BB--BBBBBBB-----BBBBBBB--BBBBBBB
---BB----------BB--BB-BB----BB--BB----BBB---BB-------BB--BBB
---BBBBBBBBB---BB--BB--BB---BB--BB-----BBB--BBBBB----BBBBBB
---BB----------BB--BB---BB--BB--BB-----BBB--BB-------BB---BB
---BB----------BB--BB----BB-BB--BB----BBB---BB-------BB----BB
---BB----------BB--BB-----BBBB--BBBBBBBB----BBBBBBB--BB-----BB
EOS


print mtg.fg "orange"
