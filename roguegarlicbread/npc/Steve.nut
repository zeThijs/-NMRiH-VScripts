#include math
self.ConnectOutput("OnDamaged", "Wimper")

/*
 * Important implicit detail about scripted sequences:
 * If the sequence is allowed to finish, it it destroyed
 * If the sequence is cancelled, it is NOT destroyed and slurps up memory/edict
 * When canceling sequences make sure to destroy the sequences instance
 * Especially important on single use sequences
 * 
 * Also make sure to null your handle storage variable when destroying!
 * Make sure to check your handle variable with IsValid() too!
*/


printcl(100,100,200, "Setting up Steve")


const givesound = "steve.give"
const justworkingsound = "steve.justworkingsound"
const dontshoot = "steve.dontshoot"
const pain = "steve.pain"
const death = "steve.death"


const StevesHealth = 200


local hActiveSequence = null

self.PrecacheSoundScript(pain)
self.PrecacheSoundScript(givesound)
self.PrecacheSoundScript(justworkingsound)
self.PrecacheSoundScript(dontshoot)
self.PrecacheSoundScript(death)



function OnPostSpawn(){
    self.SetHealth(StevesHealth);
    RepairIdle()
}

function NoViolence(){
    self.EmitSound(givesound)
}
function JustWorking(){
    self.EmitSound(justworkingsound)
}
function DontShoot(){
    self.EmitSound(dontshoot)
}


//returns origin of hand attachment
function FindAttachmentlocation(attachmentName){

    local attId = self.LookupAttachment(attachmentName);
    //get relevant attachment information
    local attOrigin = self.GetAttachmentOrigin(attId);
    local attAngles = self.GetAttachmentAngles(attId);
    //attAngles.x = (attAngles.x-90)
    return attOrigin;
}


/*
    One cannot change a scripted sequences' origin post spawn therefore you have to make a fresh one with each move sequence
*/
function MoveToPlayerNearest(){
    local hPlayer = null
    if ( (hPlayer = Entities.FindByClassnameNearest("player", self.GetOrigin(), 1024)) == null || hPlayer == false)
    {
        printcl(100,100,200, "Could not find nearby player")
        return
    }
        

    local playerOrigin = hPlayer.GetOrigin()
    local newAngle = Get_dvect_Ents(self, hPlayer)
    local newOrigin = Get_OffsetOrigin(hPlayer, self, -40.0) 

    local hMoveSequence = null
    if ((hMoveSequence = Entities.CreateByClassname("scripted_sequence")) == null)
        return
    EntFireByHandle(hMoveSequence, "addoutput", "m_iszEntity Steve")
    EntFireByHandle(hMoveSequence, "addoutput", "m_bIgnoreGravity 0")
    EntFireByHandle(hMoveSequence, "addoutput", "m_bDisableNPCCollisions 0")
    EntFireByHandle(hMoveSequence, "addoutput", "m_bLoopActionSequence 0")
    EntFireByHandle(hMoveSequence, "addoutput", "m_bSynchPostIdles 0")
    EntFireByHandle(hMoveSequence, "addoutput", "m_flRadius 0")
    EntFireByHandle(hMoveSequence, "addoutput", "m_flRepeat 0")
    EntFireByHandle(hMoveSequence, "addoutput", "m_fMoveTo 1")
    EntFireByHandle(hMoveSequence, "addoutput", "spawnflags 0")

    hMoveSequence.SetAngles(newAngle)
    hMoveSequence.SetOrigin(newOrigin)
    DispatchSpawn(hMoveSequence)

    //turn off active sequence, else new sequence cannot start
    //ATTENTION! if a loop exists in a canceled sequence, it is not cleaned up and will brick an edict slot as well as slurp up memory
    if (hActiveSequence!=null && hActiveSequence.IsValid()){
        EntFireByHandle(hActiveSequence, "CancelSequence", "")
        hActiveSequence.Destroy()
        hActiveSequence = null
    }

    EntFireByHandle(hMoveSequence, "beginsequence", "")

    hActiveSequence = hMoveSequence

}




local hMed = null

function CreateNGiveMedkit(){

    printl("creating med..")
    local attachOrigin = FindAttachmentlocation("anim_attachment_LH");

    if ((hMed = Entities.CreateByClassname("item_first_aid")) == null)
    {
        printl("unable to create med")
        return
    }

    EntFireByHandle(hMed, "addoutput", "spawnflags 1")
    hMed.SetOrigin(attachOrigin)
    hMed.SetParent(self, "anim_attachment_LH")
    hMed.SetOrigin(Vector(0,5,5))
    DispatchSpawn(hMed)
}

function UnparentMed(){
    if (hMed == null || !hMed.IsValid())
        return
    hMed.SetParent(null, "")
    hMed.SetOrigin(FindAttachmentlocation("anim_attachment_LH"))
}

/*
    One cannot change a scripted sequences' origin post spawn therefore you have to make a fresh one with each move sequence
*/
function GivePlayer(hPlayer){

    local playerOrigin = hPlayer.GetOrigin()
    local newAngle = Get_dvect_Ents(self, hPlayer)
    local newOrigin = Get_OffsetOrigin(hPlayer, self, -40.0) 

    local hGiveSequence = null
    if ((hGiveSequence = Entities.CreateByClassname("scripted_sequence")) == null)
        return
    EntFireByHandle(hGiveSequence, "addoutput", "m_iszEntity Steve")
    EntFireByHandle(hGiveSequence, "addoutput", "m_bIgnoreGravity 0")
    EntFireByHandle(hGiveSequence, "addoutput", "m_bDisableNPCCollisions 0")
    EntFireByHandle(hGiveSequence, "addoutput", "m_bLoopActionSequence 0")
    EntFireByHandle(hGiveSequence, "addoutput", "m_bSynchPostIdles 0")
    EntFireByHandle(hGiveSequence, "addoutput", "m_flRadius 0")
    EntFireByHandle(hGiveSequence, "addoutput", "m_flRepeat 0")
    EntFireByHandle(hGiveSequence, "addoutput", "m_fMoveTo 1")
    EntFireByHandle(hGiveSequence, "addoutput", "spawnflags 0")
    EntFireByHandle(hGiveSequence, "addoutput", "targetname give")

    EntFireByHandle(hGiveSequence, "addoutput", "m_iszPlay AM_Office_FileGive")
    hGiveSequence.SetAngles(newAngle)
    hGiveSequence.SetOrigin(newOrigin)
    DispatchSpawn(hGiveSequence)

    //turn off active sequence, else new sequence cannot start
    //ATTENTION! if a loop exists in a canceled sequence, it is not cleaned up and will brick an edict slot as well as slurp up memory
    if (hActiveSequence!=null && hActiveSequence.IsValid()){
        EntFireByHandle(hActiveSequence, "CancelSequence", "")
        hActiveSequence.Destroy()
        hActiveSequence = null
    }

    EntFireByHandle(hGiveSequence, "beginsequence", "")

    hActiveSequence = hGiveSequence

    hGiveSequence.AddOutput("OnEndSequence", "Steve", "RunScriptCode", "NoViolence()", 0.0, 0.0)
    hGiveSequence.AddOutput("OnEndSequence", "Steve", "RunScriptCode", "RepairIdle()", 4.0, 0.0)
    hGiveSequence.AddOutput("OnBeginSequence", "Steve", "RunScriptCode", "CreateNGiveMedkit()", 2.0, 0.0)
    hGiveSequence.AddOutput("OnBeginSequence", "Steve", "RunScriptCode", "UnparentMed()", 4.0, 0.0)
}

function GivePlayerNearest(){
    printcl(100,100,200, "Finding nearest player to give something...")
    local hPlayer = null
    if ( (hPlayer = Entities.FindByClassnameNearest("player", self.GetOrigin(), 256)) == null || hPlayer == false)
        printcl(100,100,200, "Could not find nearby player")
    else 
        GivePlayer(hPlayer)
}


/*
    Work loop at the specified location
*/
function StartWorking(location, angles){

    local hWorkSequence = null
    if ((hWorkSequence = Entities.CreateByClassname("scripted_sequence")) == null)
        return
    EntFireByHandle(hWorkSequence, "addoutput", "m_iszEntity Steve")
    EntFireByHandle(hWorkSequence, "addoutput", "m_bIgnoreGravity 0")
    EntFireByHandle(hWorkSequence, "addoutput", "m_bDisableNPCCollisions 0")
    EntFireByHandle(hWorkSequence, "addoutput", "m_bLoopActionSequence 1")
    EntFireByHandle(hWorkSequence, "addoutput", "m_bSynchPostIdles 0")
    EntFireByHandle(hWorkSequence, "addoutput", "m_flRadius 0")
    EntFireByHandle(hWorkSequence, "addoutput", "m_flRepeat 0")
    EntFireByHandle(hWorkSequence, "addoutput", "m_fMoveTo 1")
    EntFireByHandle(hWorkSequence, "addoutput", "spawnflags 112")
    EntFireByHandle(hWorkSequence, "addoutput", "targetname working")

    EntFireByHandle(hWorkSequence, "addoutput", "m_iszPostIdle AM_Console01a_work")
    hWorkSequence.SetAngles(angles)
    hWorkSequence.SetOrigin(location)
    DispatchSpawn(hWorkSequence)
    
    //turn off active sequence, and start new sequence
    if (hActiveSequence!=null && hActiveSequence.IsValid() ){
        EntFireByHandle(hActiveSequence, "CancelSequence", "")
        hActiveSequence.Destroy()
        hActiveSequence = null
    }

    EntFireByHandle(hWorkSequence, "beginsequence", "")

    hActiveSequence = hWorkSequence
}

function RepairIdle()
{
    StartWorking(Vector(-1977, 2400, -2329), Vector(0,270,0))
}


local hurt = false
function Wimper(){
    self.StopSound("steve.give")
    self.StopSound("steve.justworkingsound")

    self.EmitSound(pain)
    if(!hurt)
        AddThinkToEnt(self, "HurtTimer");
    hurt = true
    

    local hWimper = null
    if ((hWimper = Entities.CreateByClassname("scripted_sequence")) == null)
        return
    EntFireByHandle(hWimper, "addoutput", "m_iszEntity Steve")
    EntFireByHandle(hWimper, "addoutput", "m_bIgnoreGravity 0")
    EntFireByHandle(hWimper, "addoutput", "m_bDisableNPCCollisions 0")
    EntFireByHandle(hWimper, "addoutput", "m_bLoopActionSequence 1")
    EntFireByHandle(hWimper, "addoutput", "m_bSynchPostIdles 0")
    EntFireByHandle(hWimper, "addoutput", "m_flRadius 0")
    EntFireByHandle(hWimper, "addoutput", "m_flRepeat 0")
    EntFireByHandle(hWimper, "addoutput", "spawnflags 112")
    EntFireByHandle(hWimper, "addoutput", "targetname " + "Fear_Reaction")

    EntFireByHandle(hWimper, "addoutput", "m_iszPlay " + "Fear_Reaction")  

    DispatchSpawn(hWimper)
    
    //turn off active sequence, and start new sequence
    if (hActiveSequence!=null && hActiveSequence.IsValid() ){
        EntFireByHandle(hActiveSequence, "CancelSequence", "")
        hActiveSequence.Destroy()
        hActiveSequence = null
    }

    EntFireByHandle(hWimper, "beginsequence", "")
    

    hActiveSequence = hWimper
}



function HurtTimer()
{
    if (!hurt)
        RepairIdle()
    hurt = false
    return 20.0
}

function OnDeath()
{
    self.EmitSound(death)
}


function FacePlayer(){
     local  hPlayer = null
    if ( ( hPlayer = Entities.FindByClassnameNearest("player", self.GetOrigin(), 256)) == null || hPlayer == false || !hPlayer.IsAlive() )
        printcl(100,100,200, "Could not find nearby player")
    else
        self.SetAngles(Get_dvect_Ents(self, hPlayer)) //face player
}  

/*
    Returns angle from entity0 to entity 1
*/
function Get_dvect_Ents(h_ent0, h_ent1){

    local origin0 = h_ent0.GetOrigin();
    local origin1 = h_ent1.GetOrigin();
    
    local differenceVector = Vector( (origin1.x - origin0.x), (origin1.y - origin0.y), (origin1.z - origin0.z) );
    local normalizedVectorVector = differenceVector.Normalized();
    local angles = VectorAngles(normalizedVectorVector);
    return angles;
}

/*
    Example: ent0 is destination, ent1 needs to move. keep offsetamount distance to dest
*/
function Get_OffsetOrigin(h_ent0, h_ent1, offsetamount){    //offsetamound is offset length

    local origin0 = h_ent0.GetOrigin();
    local origin1 = h_ent1.GetOrigin();
    
    //get anglevector
    local differenceVector = Vector( (origin1.x - origin0.x), (origin1.y - origin0.y), (origin1.z - origin0.z) );
    local normalizedVector = differenceVector.Normalized();
    //get distance

    origin0.x = origin0.x - (normalizedVector.x * offsetamount)
    origin0.y = origin0.y - (normalizedVector.y * offsetamount)
    origin0.z = origin0.z - (normalizedVector.z * offsetamount)
    return origin0;
}


function Calc_Dist(dx, dy){
    local dist = sqrt( pow(dx, 2) + pow(dy, 2) );
    return dist;
}


function OnPlayerUse(){
    printl("player interacted with me")
}
