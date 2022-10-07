/*
 * Clean Up unnecessary entities at new game
 * Point Spotlight and spotlight_end are apparently only used at initialization and then never get used,
 * being useless edict use
*/

DoIncludeScript("roguegarlicbread/util/ent_cleanup.nut", null)

function DoClean(){
    printcl(100,100,200,"Cleaning unnecessary entities...")
    DestroyEntsGlobal("point_spotlight", false)
    DestroyEntsGlobal("spotlight_end", false)
}

function DoCleanManual(){
    printcl(100,100,200,"Cleaning unnecessary entities...")
    DestroyEntsGlobal("point_spotlight", false)
    DestroyEntsGlobal("spotlight_end", false)
}