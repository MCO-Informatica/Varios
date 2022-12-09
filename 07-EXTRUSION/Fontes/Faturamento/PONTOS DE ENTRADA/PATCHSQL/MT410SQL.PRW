#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"

User Function M410FSQL()

Local _aGrupo := UsrRetGrp(,RetCodUsr())
Local _cGrupo := Iif(Len(_aGrupo)<=0,"",_aGrupo[1])
Local _vpFiltro := ""

IF Alltrim(_cGrupo)$"000001"

   _vpFiltro := "C5_XTIPO == 'P'"
    
ElseIf Alltrim(_cGrupo)$"000002"

  _vpFiltro := "C5_XTIPO <> 'P'"

Else 

_vpFiltro := NIL  

EndIf   
 	
Return(_vpFiltro)

