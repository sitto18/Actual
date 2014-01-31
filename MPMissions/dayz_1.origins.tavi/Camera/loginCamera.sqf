private [ "_camera", "_welcomeMessage", "_camDistance" ];
_welcomeMessage = format["Bienvenidos al Server Oficial del Clan de la Mancuerna, Disfruta de tu estancia!",format["%1", name player]];
_camDistance = 60;
 
waitUntil {!isNil ("dayzLoginRecord")};
 
//intro move
showCinemaBorder true;
camUseNVG false;
 
_camera = "camera" camCreate [(position player select 0)-2, position player select 1,(position player select 2)+_camDistance];
_camera cameraEffect ["internal","back"];
 
_camera camSetFOV 2.000;
_camera camCommit 0;
waitUntil {camCommitted _camera};
 
_camera camSetTarget vehicle player;
_camera camSetRelPos [0,0,2];
_camera camCommit 8;
 
cutText [_welcomeMessage, "PLAIN DOWN"];
sleep 4;
cutText ["NO respeteis a los demas jugadores","PLAIN DOWN"];
sleep 4;
cutText ["Hablad en el chat si os parece, aqui no hay reglas","PLAIN DOWN"];
 
waitUntil {camCommitted _camera};
 
_camera cameraEffect ["terminate","back"];
camDestroy _camera;