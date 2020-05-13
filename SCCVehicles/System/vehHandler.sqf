// Write debug output
if (sccvehiclesDebug) then {

	systemChat "[SCCVehicles] Starting vehicle spawn system...";
	
};

sccvehiclesReset = false;
sccvehiclesMapMarkers = [];
sccvehiclesAllSpawnedVehicles = [];
sccvehiclesAllOwnedVehicles = [];

// Initial vehicle spawn
[] execVM "SCCVehicles\System\vehSpawn.sqf";

// Enable map if debug mode is on
if (sccvehiclesDebug) then {
	
	[] execVM "SCCVehicles\System\vehMap.sqf";
	
};

while {true} do {
	
	// Wait for the reset signal
	if (sccvehiclesReset) then {
		
		// Revert reset signal to default
		sccvehiclesReset = false;
		
		// Clean up existing vehicles
		_vehicleCleanup = [] execVM "SCCVehicles\System\vehCleanup.sqf";
		
		waitUntil {scriptDone _vehicleCleanup};
		
		// Spawn new vehicles
		[] execVM "SCCVehicles\System\vehSpawn.sqf";
		
	};
	
	// Remove vehicle saving functionality from destroyed vehicles
	{
		
		if (!alive _x) then {
			
			if (_x in sccvehiclesAllOwnedVehicles) then {
			
				sccvehiclesAllOwnedVehicles deleteAt (sccvehiclesAllOwnedVehicles find _x);
				
			};
			
			removeAllActions _x;
			
		};
		
	} forEach sccvehiclesAllSpawnedVehicles;
	
	sleep 1;
	
};