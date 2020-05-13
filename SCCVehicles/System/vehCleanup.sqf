_vehCount = 0;

// Iterate through all spawned vehicles
{
	_vehObj = _x;
	
	// If the vehicle is not owned
	if (!(_vehObj in sccvehiclesAllOwnedVehicles)) then {
		
		// Delete the vehicle and remove it from the index of spawned vehicles
		deleteVehicle _vehObj;
		sccvehiclesAllSpawnedVehicles deleteAt (sccvehiclesAllSpawnedVehicles find _vehObj);

	};
	
} forEach sccvehiclesAllSpawnedVehicles;

true;