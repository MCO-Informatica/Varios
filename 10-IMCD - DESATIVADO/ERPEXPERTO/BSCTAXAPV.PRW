#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} BSCTAXAPV
	(long_description)
	@type  Function
	@author Junior Carvalho
	@since 27/10/2021
	@version 1.0
	@param nMoeda, cTipo
	@return Taxa 

	/*/

User Function BSCTAXAPV(nMoeda,cTipo)

	Local nCotacao := 0
	Local cCampo := ""
	Local cMesAno:= ""
	Local cAno := ""
	Local cMes := ""

	IF cTipo == 'D'
		
		cCampo := 'M2_MOEDA' + ALLTRIM(str(nMoeda,1) )
		
		DbSelectArea("SM2")
		DbSetOrder(1)
		IF DbSeek(dDataBase)
			nCotacao := &cCampo
		ELSE
			MsgAlert("Taxa da Moeda não informada para o dia " + DTOC(DDATABASE) , "Taxa Mês Anterior"  )
		ENDIF

	ELSEIF cTipo == 'M'

		dDataAtual := MonthSub( dDataBase, 1 )

		cMes := strzero(MONTH( dDataAtual ),2)
		cAno := str(YEAR(dDataAtual),4)
		cMesAno := cMes+cAno

		DbSelectArea("SZM")
		DbSetOrder(1)

		IF dbSeek(xFilial("SZM")+cMesAno)
			nCotacao := IIF(nMoeda == 2,SZM->ZM_TXDOLAR,SZM->ZM_TXEURO)
		ELSE
			MsgAlert("Taxa Mensal da Moeda não informada para " + cMes+"/"+cAno, "Taxa Mês Anterior"  )
		ENDIF
		
	ENDIF

	//RestArea(aAreaTX)

Return nCotacao
