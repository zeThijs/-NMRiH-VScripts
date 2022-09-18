
/*
    This script allows you to put your npc in a "sleep" mode and wake him up with slumprise animation


    on npcs:
        playbackrate is reset every now and again
        this will break trying to freeze an a npc sequence with
        setplaybackrate(0)
        The reason playbackrate gets reset is because it gets reset on each task update 
            discovered by monitorign playbackrate and npc_task_text
        
        Instead of doing setplaybackrate: try doing SCHED_NPC_FREEZE
*/


local hActiveSequence = null;

local thinkOverflow = 0
function EnableSlump(){

    hActiveSequence = Sleep(self.GetOrigin(), self.GetAngles(), "Slumprise")

    //freeze npc to stop task updates
    self.SetSchedule("SCHED_NPC_FREEZE")
    self.SetPlaybackRate(0.0)
    // wait untill playback rate is reset once more on next update, and re-set to 0
    thinkOverflow = 0
    AddThinkToEnt(self, "DelayedNoPlayback")
    //will still moan, time to gag
    self.AcceptInput("GagEnable", "", self, self)    
}


function DelayedNoPlayback(){
    local Rate = self.GetPlaybackRate()
    if (Rate != 0 || thinkOverflow > 10){
        self.SetPlaybackRate(0.0)
        self.StopThinkFunction();
        }
    thinkOverflow++
    return 0.5
}

function SlumpRise(){
    if (hActiveSequence==null || self.GetSequenceName(self.GetSequence()) != "Slumprise"){
        printl("No slumprise enabled, you derp xd")
    }
    self.SetPlaybackRate(1.0)
    self.SetCondition("COND_NPC_UNFREEZE")
    self.AcceptInput("GagDisable", "", self, self)
}



/*
    Start animation at given LocAngles
*/
function Sleep(location, angles, animName){

    local name = self.GetName()
    if (name == "")
        {
            printcl("ERROR: Cannot set a scripted_sequence to a nameless npc, exiting..")
            return hActiveSequence
        }

    local hSleepSequence = null
    if ((hSleepSequence = Entities.CreateByClassname("scripted_sequence")) == null)
        return
    EntFireByHandle(hSleepSequence, "addoutput", "m_iszEntity " + self.GetName())
    EntFireByHandle(hSleepSequence, "addoutput", "m_bIgnoreGravity 0")
    EntFireByHandle(hSleepSequence, "addoutput", "m_bDisableNPCCollisions 0")
    EntFireByHandle(hSleepSequence, "addoutput", "m_bLoopActionSequence 0")
    EntFireByHandle(hSleepSequence, "addoutput", "m_bSynchPostIdles 0")
    EntFireByHandle(hSleepSequence, "addoutput", "m_flRadius 0")
    EntFireByHandle(hSleepSequence, "addoutput", "m_flRepeat 0")
    EntFireByHandle(hSleepSequence, "addoutput", "m_fMoveTo 4")
    EntFireByHandle(hSleepSequence, "addoutput", "spawnflags 112")
    //EntFireByHandle(hSleepSequence, "addoutput", "targetname working")

    EntFireByHandle(hSleepSequence, "addoutput", "m_iszPlay " + animName)
    hSleepSequence.SetAngles(angles)
    hSleepSequence.SetOrigin(location)
    DispatchSpawn(hSleepSequence)
    
    //turn off active sequence, and start new sequence
    if (hActiveSequence!=null && hActiveSequence.IsValid() ){
        EntFireByHandle(hActiveSequence, "CancelSequence", "")
        hActiveSequence.Destroy()
        hActiveSequence = null
    }

    EntFireByHandle(hSleepSequence, "beginsequence", "")

    return hSleepSequence
    
}



// function AnimSlower(){
//     local newRate = self.GetPlaybackRate() - 0.1
//     if (newRate<0)
//         return;

//     printcl(100,100,200,"new playbackrate: " + newRate.tostring() )
//     self.SetPlaybackRate(newRate)
// }
// local counter
// function AnimMonitor(){
    
//     AddThinkToEnt(self, "AnimThink")
//     //hActiveSequence = Sleep(self.GetOrigin(), self.GetAngles(), "wake_up")

// }

// function AnimThink(){
//     local Rate = self.GetPlaybackRate()
//     printcl(100,100,200, "playbackrate: " + Rate.tostring() )
//     if (Rate != 0)
//         self.SetPlaybackRate(0.0)
//     // printl(self.GetNPCState())
//     // printl(self.GetSchedule())
//     return 0.5
// }

// function AnimFaster(){
//     local newRate = self.GetPlaybackRate() + 0.1
//     if (newRate<0)
//         return;
        
//     printcl(100,100,200,"new playbackrate: " + newRate.tostring() )
//     self.SetPlaybackRate(newRate)
// }