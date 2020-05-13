// Load config file
call compile preprocessFileLineNumbers "SCCVehicles\Config\vehConfig.sqf";

// Run ambient vehicle handler
[] execVM "SCCVehicles\System\vehHandler.sqf";