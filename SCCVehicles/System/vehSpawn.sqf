// Variables
_allWheels = ["hitlfwheel", "hitrfwheel", "hitlf2wheel", "hitrf2wheel", "hitlmwheel", "hitrmwheel", "hitlbwheel", "hitrbwheel"];

// Functions
_getLowestChance = {
	
	_itemList = _this select 0;
	
	_currentLowestChance = 101;
	_classnamesToReturn = [];
	_currentWithLowestChance = [];
	
	{
		
		_entryToCheck = _x;
		_classToCheck = _x select 0;
		_chanceToCheck = _x select 1;
		
		if (_chanceToCheck < _currentLowestChance) then {
			
			_currentLowestChance = _chanceToCheck;
			_currentWithLowestChance = [];
			_currentWithLowestChance pushBack _entryToCheck;
			
		} else {
			
			if (_chanceToCheck == _currentLowestChance) then {
				
				_currentWithLowestChance pushBack _entryToCheck;
				
			};
			
		};
		
		
	} forEach _itemList;
	
	{
		
		_classnamesToReturn pushBack (_x select 0);
		
	} forEach _currentWithLowestChance;
	
	_classnamesToReturn;
	
};

_addVehicleActions = {
	_vehObj = _this select 0;
	_vehClass = typeOf _vehObj;
	_vehDisplayName = getText (configfile >> "CfgVehicles" >> _vehClass >> "displayName");

	_vehObj addAction 
	[
		("Save " + _vehDisplayName), 
		{
		
			// Get parameters
			params ["_target", "_caller", "_actionId", "_arguments"];
			
			// Mark vehicle as owned so that it does not get deleted on cleanup
			sccvehiclesAllOwnedVehicles pushBack _target;
			
		},
		[],
		1.5, 
		true, 
		true, 
		"",
		"!(_target in sccvehiclesAllOwnedVehicles) && (vehicle player == player)",
		10,
		false,
		"",
		""
	];

	_vehObj addAction 
	[
		("Unsave " + _vehDisplayName), 
		{
		
			// Get parameters
			params ["_target", "_caller", "_actionId", "_arguments"];
			
			// Mark vehicle as unowned so that it gets deleted on cleanup
			sccvehiclesAllOwnedVehicles deleteAt (sccvehiclesAllOwnedVehicles find _target);
			
		},
		[],
		1.5, 
		true, 
		true, 
		"",
		"(_target in sccvehiclesAllOwnedVehicles) && (vehicle player == player)",
		10,
		false,
		"",
		""
	];
	
};

_damageVehicle = {
	
	_vehDmgObj = _this select 0;
	_vehDmgClass = typeOf _vehDmgObj;
	_vehHitPoints = (getAllHitPointsDamage _vehDmgObj) select 0;
	
	// If vehicle has wheels, apply damage
	_numWheels = count (configfile >> "CfgVehicles" >> _vehDmgClass >> "Wheels");
	
	if (_numWheels > 0) then {
	
		for [{_wheelCount = 0}, {_wheelCount < _numWheels}, {_wheelCount = _wheelCount + 1}] do {
		
			_partToDmg = _allWheels select _wheelCount;
			_partDamagedChance = [0, 100] call BIS_fnc_randomInt;
			_partMissingChance = [0, 100] call BIS_fnc_randomInt;
			
			if (_partDamagedChance < sccvehiclesDamagedPartChance) then {
			
				if (_partMissingChance < sccvehiclesMissingPartChance) then {
					
					_vehDmgObj setHitPointDamage [_partToDmg, 1];
					
				} else {
					
					_damageAmount = ([0, 100] call BIS_fnc_randomInt) / 100;
					_vehDmgObj setHitPointDamage [_partToDmg, _damageAmount];
				
				};
			
			};
			
		};
	
	};

	// Set other part damage
	{
		
		// Exclude wheels
		if (!(_x in _allWheels)) then {
			
			_partDamagedChance = ([0, 100] call BIS_fnc_randomInt) / 100;
			
			if (_partDamagedChance < sccvehiclesDamagedPartChance) then {
			
				_partMissingChance = [0, 100] call BIS_fnc_randomInt;
				
				if (_partMissingChance < sccvehiclesMissingPartChance) then {
					
					_vehDmgObj setHitPointDamage [_x, 1];
					
				} else {
				
					_damageAmount = ([25, 75] call BIS_fnc_randomInt) / 100;
					_vehDmgObj setHitPointDamage [_x, _damageAmount];
				
				};
				
			};
			
		};
		
	} forEach _vehHitPoints;
	
	// Set fuel
	if (sccvehiclesDamagedPartChance > 0) then {
		
		_vehDmgObj setFuel (([0, 100] call BIS_fnc_randomInt) / 100);
		
	};
	
};

// Spawn a vehicle sccvehiclesNumToSpawn times
for [{_vehCount = 0}, {_vehCount < sccvehiclesNumToSpawn}, {_vehCount = _vehCount + 1}] do {
	
	// Generate a random number
	_randomNumber = [1,100] call BIS_fnc_randomInt;
	
	_possibleVehiclesToSpawn = [];
	
	// If there are vehicles in the list
	if (count sccvehiclesList > 0) then {
		
		// Iterate through vehicles list
		{
			
			// Get potential vehicles to spawn
			if (_x select 1 >= _randomNumber) then {
			
				_possibleVehiclesToSpawn pushBack _x;
				
			};
			
		} forEach sccvehiclesList;
		
		// Prioritise vehicle with lowest chance
		_vehToSpawn = selectRandom ([_possibleVehiclesToSpawn] call _getLowestChance);
		_vehToSpawnPos = [];
		
		_randomMapPosLand = [nil, ["water"]] call BIS_fnc_randomPos;
		_nearestRoads = _randomMapPosLand nearRoads 500;
		
		// If there is a road nearby, spawn vehicle on the road
		if (count _nearestRoads > 0) then {
			
			_vehToSpawnPos = getPos (_nearestRoads select 0);
			
		} else {
			
			_vehToSpawnPos = _randomMapPosLand;
			
		};
		
		_vehObj = _vehToSpawn createVehicle _vehToSpawnPos;
		
		// Get display name from the config file
		_vehDisplayName = getText (configfile >> "CfgVehicles" >> _vehToSpawn >> "displayName");
		
		// Write debug output
		if (sccvehiclesDebug) then {
			
			_debugMsg = format ["[SCCVehicles] Spawned a %1 at %2", _vehDisplayName, _vehToSpawnPos];
			systemChat _debugMsg;
			
		};
		
		// Clear items from the vehicle
		clearItemCargoGlobal _vehObj;
		clearWeaponCargoGlobal _vehObj;
		clearBackpackCargoGlobal _vehObj;
		clearMagazineCargoGlobal _vehObj;
		
		// Add actions to the vehicle
		[_vehObj] call _addVehicleActions;
		
		// Add any damage to the vehicle
		[_vehObj] call _damageVehicle;

		
		sccvehiclesAllSpawnedVehicles pushBack _vehObj;
		
	};
	
};