// If there is no module list, create one
if (isNil "sccModules") then {
	
	sccModules = [];
	
};

// Load config file
call compile preprocessFileLineNumbers "SCCVehicles\Config\vehConfig.sqf";

// Run ambient vehicle handler
[] execVM "SCCVehicles\System\vehHandler.sqf";

// Add module to the list of active modules
sccModules pushBackUnique "vehicles";