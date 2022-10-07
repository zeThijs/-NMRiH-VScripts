
// Function:    CBaseEntity::SetOrigin
// Signature:   void CBaseEntity::SetOrigin(Vector)

// Function:    CBaseEntity::SetOriginAngles
// Signature:   void CBaseEntity::SetOriginAngles(Vector, Vector)
// Description: Set both the origin and the angles

//Purpose: Moving Fubar physics prop from player view and storing it for later use.

local TheVault  = Vector(0,0,-512)      //hollowed map brush for storing the phys prop

self.ConnectOutput("OnTrigger", "TP_FubarPhysProp")

function TP_FubarPhysProp(){
    local h_FubarPhysProp = null
    if ( (h_FubarPhysProp = Entities.FindByName(h_FubarPhysProp, "obj_fubar_item")) == null){
        printl("Insertion2 fubar script: Cannot find Fubar Physics Prop for fubartrigger script")
    }
    h_FubarPhysProp.SetOrigin(TheVault)
}

