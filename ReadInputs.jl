function readpdbfile(inpdb)

    # Tested, not used
    pdb=open(inpdb,"r")
    nlines=countlines(pdb)
    # println(nlines)    

    #
    global atomlist=[]  
    natoms=0 
    open(inpdb,"r") do stream
        for line in eachline(stream)
            sline=split(line)
            ntmp=length(sline)
            if ntmp > 0
                if uppercase(sline[1]) == "HETATM" || uppercase(sline[1]) == "ATOM"
                   natoms = natoms+1    
                   # println(line[23:26],line[31:38],line[39:46],line[47:54]) 
                    ifrag = parse(Int32,line[23:26])
                  icharge = 0 
                       dx = parse(Float64,line[31:38])              
                       dy = parse(Float64,line[39:46])              
                       dz = parse(Float64,line[47:54])              
                    if length(line) > 80
                        icharge = parse(Int32,line[81:82])
                        push!(atomlist,ATOMS(natoms,ifrag,icharge,line[13:16],(dx,dy,dz),0.0))
                    else                              
                        push!(atomlist,ATOMS(natoms,ifrag,icharge,line[13:16],(dx,dy,dz),0.0))
                    end   
                end 
            end 
        end 
    end 
    global total_atoms=natoms  

    for i in 1:100
        if i > total_atoms  
            break
        else
            println(atomlist[i])
        end  
    end
    if total_atoms > 100
        println("... (more) ")
    end 

    ifrag=0
    global fraglist=[]
    icharge    = 0 
    multiple   = 1
    natoms_frg = 0
    for i in 1:total_atoms
        #println("atomlist[i][1] : ",atomlist[i].ifrag)
        if atomlist[i].ifrag != ifrag
            if ifrag != 0
                istart=atomlist[i].idx-natoms_frg
                push!(fraglist,FRAGS(ifrag,istart,natoms_frg,icharge,1,0.0))
            end 
            ifrag = ifrag+1
            icharge    = 0 
            natoms_frg = 0
        end 
        if atomlist[i].ifrag == ifrag
            natoms_frg=natoms_frg+1
        end 
        if atomlist[i].icharge != 0
            icharge=icharge+atomlist[i][3]
        end
        if i == total_atoms
            istart=atomlist[i].idx-natoms_frg+1 
            push!(fraglist,FRAGS(ifrag,istart,natoms_frg,icharge,1,0.0))
        end 
    end
    global total_frags=ifrag

#    println("total_frags : ",total_frags) 
#    for i in 1:total_frags
#        println(fraglist[i]) 
#    end 

end 

function readinp(infile)
    open(infile,"r") do stream
        for line in eachline(stream)
            sline=split(line)
            ntmp=length(sline) 
            if ntmp > 0 
                if uppercase(sline[1]) == "TASK"
#                    println(uppercase(sline[1])) 
                    if uppercase(sline[2]) == "DFT"
                        global runtype = "DFT"
                    end  
                    if uppercase(sline[3]) == "FRAG"
                        global runtype2 = "FRAG"
                    end  
                end
                if uppercase(sline[1]) == "ENGINE"
                    if uppercase(sline[2]) == "NWCHEM"
                        global qcdriver = "NWCHEM"
                    end  
                    if uppercase(sline[3]) == "NWCHEM"
                        global qcdriver = "NWCHEM"
                    end  
                end
                if uppercase(sline[1]) == "COORD"
                    global pdbfile = sline[2]
                    readpdbfile(pdbfile)
                end
                if uppercase(sline[1]) == "LOADBALANCE"
                    global LBfile  = sline[2] 
                end
                if uppercase(sline[1]) == "WORKDIR"
                    global workdir = sline[2] 
                end
            end 
        end
    end
    #println("runtype,runtype2,qcdriver,pdbfile,LBfile")
    #println(runtype,runtype2,qcdriver,pdbfile,LBfile)
    #return runtype,runtype2,qcdriver,pdbfile,LBfile
end 



function readPDB(flag)

    println(" ")
    println("-----------------------------------------------------------")
    if uppercase(flag) == "GRIDMOL"
        println("PDBs from GridMol package ") 
    else
        println("PDBs (standard) ")
    end 
    println("-----------------------------------------------------------")
    println(" ")

end 


