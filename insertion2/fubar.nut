
//instead of doing kill prop_physics: teleport to some different dimension
//when needed again: copy angles, origin of dynamic prop, and apply them to this physics prop

//Or have non rendered prop_dynamic with nocollision and then ontrigger: copy origin+angles from dynamic, set on physics and disable pickup.

/*
 *  A fubar physics prop is moved to the objective area. A trigger_once with filter for this prop deactives similar triggers, fubar prop dynamic visible, enables trigger_use, and teleports the prop_physics out of players' sight into "the vault"
 *  Repeated use of the trigger progress use rotates the fubar dynamic prop until a random success chance is achieved
 *  This success now does the following: 
            - a delay is waited:
            - rotate brush is removed as well as the fubar prop dyn
            - the  fubar's prop dyn origin an angles are used to teleport fubar prop_physics back for repeated use
            - enables motion on prop_physics: nails and metalbar. These props have their own scripts to make them fly off and make sound
            - trigger_once with filters are re-enabled
 *  
 *
*/


const MAXFUBAROBJECTIVES = 8
const successrate = 30  //percentages
local timer_refire = 0.1
local detachflag = 0;
local leverflag = 0;

printl("-Init fubar-");
self.ConnectOutput("OnTrigger", "RandSuccess")

self.PrecacheSoundScript("truss.creak")

//set up and find entitites
local str_Name = self.GetName()
local str_Bud = str_Name + "_rotatebud"
local str_Fubar = str_Name + "_fubar"
local str_MetalBar = str_Name + "_metalbar"
local h_RotateBud = null
if ( (h_RotateBud = Entities.FindByName(h_RotateBud, str_Bud)) == null){
    printl("Insertion2 fubar script: Cannot find _rotatebud for " + str_Name)
}
local h_FubarBud = null
if ( (h_FubarBud = Entities.FindByName(h_FubarBud, str_Fubar)) == null){
    printl("Insertion2 fubar script: Cannot find _fubar for " + str_Name)
}
local h_MetalBar = null
if ( (h_MetalBar = Entities.FindByName(h_MetalBar, str_MetalBar)) == null){
    printl("Insertion2 fubar script: Cannot find _metalbar for " + str_Name)
}

local timer = null

// }
function OnTimer() 
{
    if (detachflag>=1){ //delay detachment with one unit time

        detachflag++
    }
    if (detachflag==5){

        h_FubarBud.AcceptInput("DisableCollision", "", null, null)
        //DetachMetalbar
        h_MetalBar.AcceptInput("EnableMotion", "",null, null )
        print(str_Name + "_nails")
        EntFire(str_Name + "_nails", "EnableMotion", "", 0, null, null)

        h_RotateBud.AcceptInput("Stop", "", self, self)
        //Move and replace fubar-bud prop with fubar prop-physics entity
        //TP_Fubar_PhysProp
        local h_FubarPhysProp = null
        if ( (h_FubarPhysProp = Entities.FindByName(h_FubarPhysProp, "obj_fubar_item")) == null){
            printl("Insertion2 fubar script: Cannot find Fubar Physics Prop to teleport back (fubar progress-use script)")
        }

        local angles = h_FubarBud.GetAngles()
        local origin = h_FubarBud.GetOrigin()

        h_RotateBud.AcceptInput("kill", "", null, null)         //remove  RotateBud and FubarBud, as FubarBud is parented to RotateBud 

        h_FubarPhysProp.SetOriginAngles(origin, angles)
        local dirvector = Vector(-50,0,200)

        h_FubarPhysProp.ApplyAbsVelocityImpulse(dirvector);
        return
    }
    else if (detachflag==20){

        timer.AcceptInput("kill", "", null, null)               //remove  timer edict
        detachflag = 0

        //re-enable all fubar objectives
        for ( local i = 0; i<MAXFUBAROBJECTIVES; i++){
            local string = "fubar_triggeruse" + i + "_trigger"
            EntFire(string, "Enable", "", 0, null, null)
        }
        

        return
    }

    if (leverflag>=3){

        EntFireByHandle( timer, "Disable", "", 0, null, null )
        h_RotateBud.AcceptInput("Stop", "", self, self)
        leverflag = 0
    }
    else if (detachflag==0){
        leverflag++

    }
}
//create timer for delayed actions

if( timer == null )
{
    timer = Entities.CreateByClassname( "logic_timer" )
    // set refire time
    timer.__KeyValueFromFloat( "RefireTime", timer_refire +  RandomFloat(-0.05, 0.05) )
    timer.ValidateScriptScope()
    local scope = timer.GetScriptScope()
    // add a reference to the function
    scope.OnTimer <- OnTimer
    // connect the OnTimer output,
    // every time the timer fires the output, the function is executed
    timer.ConnectOutput( "OnTimer", "OnTimer" )
}


function LeverFubar(){
    h_RotateBud.AcceptInput("Start", "", null, null)
    EntFireByHandle( timer, "Enable", "", 0, null, null )
}

//randomize progress-use success 
function RandSuccess(){
    local randInt = RandomInt(00 100)
    if (randInt < successrate ){
        self.AcceptInput("Disable", "", self, self)         //disable progress_use
        //Move and replace fubar-bud prop with fubar prop-physics entity
        //After timer expire: use flag to evaluate if this sequence is desired
        detachflag = 1
        LeverFubar()
        self.StopSound("truss.creak")
        return
    }
    else{   //open slightly
        LeverFubar()
        self.EmitSound("truss.creak")
    }
}










//code graveyard:


// function DetachMetalbar(){
//     h_MetalBar.AcceptInput("EnableMotion", "",null, null )
//     EntFire("fubar_triggeruse0_nails", "EnableMotion", "", 0, null, null)
// }

// //Move The physics prop back from the vault and on the fubarbud prop's location. TODO: Add impulse?
// function TP_Fubar_PhysProp(){
//     local h_FubarPhysProp = null
//     if ( (h_FubarPhysProp = Entities.FindByName(h_FubarPhysProp, "obj_fubar_item")) == null){
//         printl("Insertion2 fubar script: Cannot find Fubar Physics Prop to teleport back (fubar progress-use script)")
//     }

//     local angles = h_FubarBud.GetAngles()
//     local origin = h_FubarBud.GetOrigin()

//     h_FubarPhysProp.SetOriginAngles(origin, angles)
// }


// function Hide_FubarBud(){
//     h_FubarBud.AcceptInput("Alpha", "0", null, null)
//     h_FubarBud.AcceptInput("DisableCollision", "", null, null)
// }
// function OnTimerMetalBarBreak(){
//     printl("Metalbar break execute")
//     EntFireByHandle( timer, "Disable", "", 0, null, null )
// 	h_RotateBud.AcceptInput("Stop", "", self, self)
//     h_RotateBud.AcceptInput("kill", "", null, null)               //remove edict
//     timer.AcceptInput("kill", "", null, null)               //remove edict
//     DetachMetalbar()
//     //Move and replace fubar-bud prop with fubar prop-physics entity
//     Hide_FubarBud()
//     TP_Fubar_PhysProp()