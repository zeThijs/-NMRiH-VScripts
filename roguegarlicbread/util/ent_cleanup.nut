
/*
 * Params: Classname, an origin point to search from, distance; 0 is global deletion, include named entities
*/
function DestroyEnts(classname, searchOriginEnt, distance, includeNamed){ 

    local searchent = null;
    searchent = ( Entities.FindByName( searchent, searchoriginent) );
    if (searchent == null){
        Printl("--Entity destroy Error--; could not find entity " + searchoriginent + "  to search from");
        return;
    }
    local v_searchorigin = searchent.GetOrigin();

    local ent = null;
    while ( (ent = (Entities.FindByClassnameWithin( ent, classname, v_searchorigin, distance)) ) != null ){
        if (ent.GetName() == "" || bIncludeNamed == true )
            DestroyEntity(ent)
    }
}
/*
 * Params: Classname, an origin point to search from, distance; 0 is global deletion
*/
function DestroyEntsGlobal(classname, bIncludeNamed){ 
    local count = 0
    local ent = null;
    while ( (ent = Entities.FindByClassname( ent, classname) ) != null ){
        if (bIncludeNamed == true || ent.GetName() == "" ){
            DestroyEntity(ent)
            count++
        }
    }
    printcl(100,100,200, " " + classname + " " + count + " removed.")
}

/*  note to self: do NOT use CBaseEntity::Destroy() in an entity loop. 
 *      It does not update things correctly and will cause 
 *      the loop to destroy the same entity multiple times.
*/                 
function DestroyEntity(hEntity)
{
    EntFireByHandle(hEntity, "Kill", "", 0.0, 0.0)
}
