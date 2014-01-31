private [_body, _name, _kills, _killsH, _killsB, _headShots, _humanity];
 
titleText [Diario del superviviente.,PLAIN DOWN]; titleFadeOut 5;
sleep 2;
 
_body = _this select 3;
_name = _body getVariable [bodyName,unknown];
_kills = _body getVariable [zombieKills,0];
_killsH = _body getVariable [humanKills,0];
_killsB = _body getVariable [banditKills,0];
_headShots = _body getVariable [headShots,0];
_humanity = _body getVariable [humanity,0];
 
hint parseText format[
t size='1.5' font='Bitstream' color='#5882FA'%1's Journaltbrbr
t size='1.25' font='Bitstream' align='left'Zombies Muertos tt size='1.25' font='Bitstream' align='right'%2tbr
t size='1.25' font='Bitstream' align='left'Heroes Asesinados tt size='1.25' font='Bitstream' align='right'%3tbr
t size='1.25' font='Bitstream' align='left'Bandidos Asesinados tt size='1.25' font='Bitstream' align='right'%4tbr
t size='1.25' font='Bitstream' align='left'Headshots tt size='1.25' font='Bitstream' align='right'%5tbr
t size='1.25' font='Bitstream' align='left'Humanidad tt size='1.25' font='Bitstream' align='right'%6tbr,
_name,_kills,_killsH,_killsB,_headShots,_humanity];