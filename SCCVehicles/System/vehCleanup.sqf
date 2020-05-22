_vehCount = 0;
_vehToDelete = [];

// Iterate through all spawned vehicles
{
	_vehObj = _x;
	
	// If the vehicle is not owned
	if (!(_vehObj in sccvehiclesAllOwnedVehicles)) then {
		
		// Delete the vehicle
		deleteVehicle _vehObj;
		_vehToDelete pushBack _vehObj;

	};
	
} forEach sccvehiclesAllSpawnedVehicles;

{

	sccvehiclesAllSpawnedVehicles deleteAt (sccvehiclesAllSpawnedVehicles find _x);

} forEach _vehToDelete;

true;