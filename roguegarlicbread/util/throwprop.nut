
self.ConnectOutput("OnPhysGunDrop", "Dropped");

local debug=0;
local force=300;

function Dropped()
{
    local player = null;    
    if (    (player = Entities.FindByClassnameNearest( "Player", self.GetOrigin(), 512 ) ) != null ){

        try
        {
            local angle = player.EyeAngles();
            local dirvector = AngleVectors(angle);
            if (debug!=0){
                printl(angle);
                printl(dirvector.x);
                printl(dirvector.y);
                printl(dirvector.z);
            }
            dirvector.x = dirvector.x * force;
            dirvector.y = dirvector.y * force;
            dirvector.z = dirvector.z * force;
            self.ApplyAbsVelocityImpulse(dirvector);
        }
        catch(id)
        {
            printl("Impulse failed! " + id);
        }
    }
    else{
        printl("Could not find any player, while looking up who threw Prop_Physics")
    }
}
