#include 'protheus.ch'

// Se na selecao de título origem, existir algum anterior a RJ, todos os titulos
// serão gerados pela rotina como Bloqueados para Pagamento 

User Function FA290()

Local cLiber := GetNewPar( "MV_FINALAP", "000001")
Local aArea := GetArea()

DbSelectArea("SE2") 
RecLock("SE2", .F.)
if lBloqueioRJ             
	SE2->E2_APROVA  := ""
	SE2->E2_DATALIB := CtoD("  /  /    ")
	SE2->E2_STATLIB := ""
	SE2->E2_USUALIB := ""
	SE2->E2_CODAPRO := cLiber    
	SE2->E2_XRJ     := "S"
else 
	SE2->E2_APROVA  := ""
	SE2->E2_DATALIB := dDataBase
	SE2->E2_STATLIB := "03"
	SE2->E2_USUALIB := "GERACAO APOS REC JUDIC"
	SE2->E2_CODAPRO := "000000"   // Como o titulo foi gravado como liberado, gravado esse código de liberador
	SE2->E2_XRJ     := "N"
endif
SE2->(MsUnLock())

RestArea(aArea)

Return(.T.)
