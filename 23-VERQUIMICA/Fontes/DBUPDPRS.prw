#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

user function DBUPDPRS()
	local chkfV2P := chkfile('V2P')
	local chkfV2Z := chkfile('V2Z')
	local chkfSVA := chkfile('SVA')
	local cDesc := " "
	
	IF chkfV2P
		cDesc += "V2P OK  ---- "
	Else
		cDesc += "V2P NOK ----"
	EndIf
	
	IF chkfV2Z
		cDesc += "V2Z OK  ---- "
	Else
		cDesc += "V2Z NOK ----"
	EndIf
	
	IF chkfSVA
		cDesc += "SVA OK  ---- "
	Else
		cDesc += "SVA NOK ----"
	EndIf
	
	
   MsgInfo(cDesc)         
return