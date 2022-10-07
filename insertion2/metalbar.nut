/*  
 *  Purpose: fly off props after detachment by fubar
 *           play metallic ringing sound
 *
 *  TODO:   Add Latejoin precache, cleanup code
*/


const debug = 1;
// local bar_snds = ["insertion2/impact_steel_ringing_01.mp3", "insertion2/impact_steel_ringing_02.mp3", "insertion2/impact_steel_ringing_03.mp3", "insertion2/impact_steel_ringing_04.mp3"];
local prev_snd;

printl("-Init metalbar-");

self.ConnectOutput("OnMotionEnabled", "BarRelease");
self.PrecacheSoundScript("metalbar.klink")


function BarRelease(){
    try
    {   
        local dirvector = Vector(0,0,0)
        dirvector.x = 80;
        dirvector.y = 0;
        dirvector.z = 120;
        self.ApplyAbsVelocityImpulse(dirvector);
        self.EmitSound("metalbar.klink")
    }
    catch(id)
    {
        printl("Impulse failed! " + id);
    }

}