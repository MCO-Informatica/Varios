#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function M310CABEC
    Local cProg := PARAMIXB[1]
    Local aCabec := PARAMIXB[2]
    // Local aPar := PARAMIXB[3]
    If cProg == 'MATA410'    
        aadd(aCabec,{'C5_TRANSP','000547',Nil}) 
        aadd(aCabec,{'C5_FECENT',dDatabase,Nil}) 
        aadd(aCabec,{'C5_TPFRETE',"C",Nil}) 
        aadd(aCabec,{'C5_NATUREZ',"10301     ",Nil}) 
    Endif
Return(aCabec)
