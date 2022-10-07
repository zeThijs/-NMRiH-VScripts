//Purpose: fly off props after detachment by fubar
self.ConnectOutput("OnMotionEnabled", "BarRelease");

function BarRelease(){
    try
    {   
        local dirvector = Vector(0,0,0)
        dirvector.x = 150;
        dirvector.y = 0;
        dirvector.z = 10;
        self.ApplyAbsVelocityImpulse(dirvector);
    }
    catch(id)
    {
        printl("Impulse failed! " + id);
    }

}