#Include "Protheus.ch"

User Function MT103LDV()
Local aLinha := PARAMIXB[1]
Local cAlias := PARAMIXB[2]
Local aArea := GetArea()                         
Local nPosLote 	:= Ascan(aLinha,{|x| x[1]=='D1_LOTECTL' })
Local nPosNFor 	:= Ascan(aLinha,{|x| x[1]=='D1_NFORI' })
Local nPosSeor 	:= Ascan(aLinha,{|x| x[1]=='D1_SERIORI' })

If IsInCallStack("MATA103") .And. cTipo == 'D' .And. nPosLote > 0	// Se For Uma Nota de Devolução
	//Busca Lote

	aLinha[nPosLote,2] := (cAlias)->D2_LOTECTL
Endif

RestArea(aArea)
Return aLinha
