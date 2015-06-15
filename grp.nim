# Nim port of Python's "grp" module.

# Written by Adam Chesak.
# Released under the MIT open source license.


import strutils


type
    Grp* = ref GrpInternal
    
    GrpInternal* = object
        gr_name : string
        gr_passwd : string
        gr_gid : int
        gr_mem : seq[string]


# Internal constant.
const GROUP_FILE = "/etc/group"


proc getgrall*(): seq[Grp] = 
    ## Returns a sequence of all entries in the group file.
    
    var f : string = readFile(GROUP_FILE)
    var lines : seq[string] = f.splitLines()
    var grps : seq[Grp] = newSeq[Grp](len(lines))
    
    for i in 0..high(lines):
        if lines[i].strip(leading = true, trailing = true) == "":
            break
        var s : seq[string] = lines[i].split(":")
        var g : Grp = Grp(gr_name: s[0], gr_passwd: s[1], gr_gid: parseInt(s[2]), gr_mem: s[3].split(","))
        grps[i] = g
    
    return grps


proc getgrgid*(gid : int): Grp = 
    ## Returns the entry with the given ``gid``. Returns ``nil`` if not found.
    
    var grps : seq[Grp] = getgrall()
    
    for i in grps:
        if i.gr_gid == gid:
            return i
    
    return nil


proc getgrnam*(name : string): Grp = 
    ## Returns the entry with the given ``name``. Returns ``nil`` if not found.
    
    var grps : seq[Grp] = getgrall()
    
    for i in grps:
        if i.gr_name == name:
            return i
    
    return nil
