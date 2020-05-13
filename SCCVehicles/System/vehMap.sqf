while {true} do {

	// Delete the existing markers
	if (count sccvehiclesMapMarkers > 0) then {

		{
			
			deleteMarker _x;
			
		} forEach sccvehiclesMapMarkers;
		
	};
	
	_markerCount = 0;

	// Draw new markers
	{
		// Get vehicle position
		_vehPos = getPos _x;
		_vehClass = typeOf _x;
		_vehDisplayName = getText (configfile >> "CfgVehicles" >> _vehClass >> "displayName");
		
		// Create a marker name and add it to the index
		_markerName = "sccvehicles" + (str _markerCount);
		sccvehiclesMapMarkers pushBack _markerName;
		
		// Create the new marker
		_markerToCreate = createMarker [_markerName, _vehPos];
		_markerToCreate setMarkerText _vehDisplayName;
		_markerToCreate setMarkerType "c_car";
		_markerToCreate setMarkerColor "ColorBlack";
	
		_markerCount = _markerCount + 1;
	
	} forEach sccvehiclesAllSpawnedVehicles;
	
	sleep 1;
	
};