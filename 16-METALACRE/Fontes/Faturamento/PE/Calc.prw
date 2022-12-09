#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch"
#INCLUDE "Tbiconn.ch" 

User Function Calc ()
      
dData  := DATE()
dData1 :=  "07/10/1997"

dResult := STRZERO(dData - CTOD(dData1), 4)
alert(dResult)


Return


