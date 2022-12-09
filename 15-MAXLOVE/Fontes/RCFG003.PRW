#Include "protheus.ch"

User Function RCFG003()

ALERT(GetMv( "MV_TPSALDO" , .T. , 0 ))
ALERT(SX6->X6_FIL+" "+SX6->X6_VAR+" "+SX6->X6_TIPO+" "+SX6->X6_CONTEUD)


Return()