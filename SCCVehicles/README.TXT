SCCVehicles for Arma 3 (Version 0.1 - 2020-05-13)
by samscodeco <sam@samscode.co>

A simple system for randomly spawning vehicles.

If you have a question, suggestions or feedback, I can be contacted by email or on the BIS forums.

-----------------------------------
1. INSTALLATION
-----------------------------------

1. Place the 'SCCVehicles' folder inside the root mission directory.
2. Add the following line to your mission's init.sqf:

[] execVM "SCCVehicles\vehInit.sqf";

-----------------------------------
2. USAGE
-----------------------------------

When the script is installed, vehicles will be spawned in at the beginning of a mission based on the parameters specified in 'SCCVehicles\Config\vehConfig.sqf'.

Vehicles can be saved/unsaved by using the scroll-wheel action menu. Saved vehicles will not disappear during a cleanup.

To clean up all unsaved vehicles and spawn new ones, set 'sccvehiclesReset' to true somewhere in your mission.

-----------------------------------
3. FAQ
-----------------------------------

Q: Can I edit/use/reupload this?
A: You are free to use or modify this script in any way, as long as the original copyright notice is retained.

Q: How do I modify the script to do x/y?
A: Make sure to read through this Readme carefully for help with configuring the script. If you're still stuck, get in touch!

-----------------------------------
4. LICENSE
-----------------------------------

This script released under the BSD License. You are free to modify or distribute it, provided that the original copyright notice is retained.
For more information, see the license file in the source directory.

-----------------------------------
5. SPECIAL THANKS
-----------------------------------

- BIS Forums/Wiki contributors for answering all my dumb questions.
- The r/armadev and r/arma communities for help and inspiration respectively.