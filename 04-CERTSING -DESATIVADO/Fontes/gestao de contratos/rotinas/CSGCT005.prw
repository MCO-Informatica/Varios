#Include "Totvs.ch" 

//+------------+------------+-------+------------------------+------+------------+
//| Função:    | CSGCT005   | Autor | Renato Ruy             | Data | 18/02/2014 | 
//+------------+------------+-------+------------------------+------+------------+
//| Descrição: | Validação no campo CN9_XOPORT para preencher acols de vendedores|
//+------------+-----------------------------------------------------------------+
//| Ultima Atualização: 04/01/2018 - David.Santos                                |
//+------------------------------------------------------------------------------+
User Function CSGCT005()

	Local COLS
	Local cRet       := .T.
	Local oModelX    := FWModelActive()					//-- Captura o modelo ativo.
	Local oGetDadCNU := oModelx:GetModel('CNUDETAIL')	//-- Captura modelo da tabela CNU.
	Local nCount     := 0
	
	If Empty(M->CN9_XOPORT)
		cRet := .F.
		MsgAlert("O campo de oportunidade não foi preenchido!")
	EndIf

	AD1->( dbSetOrder(1) )
	COLS := 1 
	IF AD1->( dbSeek( xFilial('CN9') + M->CN9_XOPORT ) )
		oGetDadCNU:aCols := {}
		AAdd(oGetDadCNU:aCols,{AD1->AD1_VEND,0,"CNU",COLS,.F.})
		oGetDadCNU:aCols[COLS][4] := oGetDadCNU:aCols[COLS][4]
		
		DBSELECTAREA("AD2")
		AD2->(DBGOTOP())
		AD2->( dbSetOrder(1) )
	
		IF AD2->( dbSeek( xFilial('CN9') + AD1->AD1_NROPOR + AD1->AD1_REVISA) )
		 	WHILE (AD1->AD1_NROPOR + AD1->AD1_REVISA) = (AD2->AD2_NROPOR + AD2->AD2_REVISA)
		 		COLS++
		 		if ascan(oGetDadCNU:aCols,{|x|x[1]==AD2->AD2_VEND}) <= 0
		 			AAdd(oGetDadCNU:aCols,{AD2->AD2_VEND,0,"CNU",COLS,.F.})
		 			oGetDadCNU:aCols[COLS][4] := oGetDadCNU:aCols[COLS][4]
		 		endif
		 		AD2->(DBSKIP())
		 	ENDDO	 
		ENDIF
		
		//-- Gatilha a informação de vendedores no grid de vendedores.
		For nX := 1 To Len(oGetDadCNU:aCols)		
			nCount := oGetDadCNU:Length() + 1
			oGetDadCNU:GoLine(oGetDadCNU:Length())
		
			If oGetDadCNU:Length() == 1
				oGetDadCNU:SetValue('CNU_CODVD',oGetDadCNU:aCols[nX,1])
			ElseIf oGetDadCNU:AddLine() == nCount
				oGetDadCNU:SetValue('CNU_CODVD',oGetDadCNU:aCols[nX,1])
			Endif
		Next nX

		AD2->(DBCLOSEAREA())
	EndIF

Return( cRet )
