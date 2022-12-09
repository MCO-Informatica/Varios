#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BuscaCEP  �Autor  �Anderson Zanni      � Data �  04/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Busca endere�o baseado no CEP digitado. Caso o CEP tenha   ���
���          � mais de um logradouro, apresenta listbox para escolha.     ���
�������������������������������������������������������������������������͹��
���Uso       �Version 2.0                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SearchCEP(cOrigem)

	Local oDlgCEP
	Local _cCep    	:= &(ReadVar())
	Local _cAreaCEP	:= GetArea()
	Local _nPos    	:= 1
	Local _cVar    	:= ReadVar()
	Local _nTamCEP 	:= Len(AllTrim(_cCep))
	Local _aCEP    	:= {}
	Local _aRET    	:= {}
	Local lChoice	:= .f.
	Local cSQL  	:= ''
	Local cTRB  	:= ''

	Default cOrigem	:= ''

	cSQL 	:= "Select PA7_CODCEP, PA7_LOGRA, PA7_BAIRRO, PA7_MUNIC, PA7_ESTADO, PA7_CODMUN, PA7_CODUF, PA7_CODPAI From "+RetSqlName('PA7')
	cSQL 	+= "	Where D_E_L_E_T_ = ' ' And"
	cSQL 	+= "	      SUBSTR(PA7_CODCEP,1,"+AllTrim(Str(_nTamCEP))+") = '"+_cCep+"'"

	cTRB := GetNextAlias()
	cSQL := ChangeQuery( cSQL )
	PLSQuery( cSQL, cTRB )
	
	While .NOT. (cTRB)->( EOF() )
		aAdd(_aCEP, (cTRB)->(PA7_CODCEP+' - '+AllTrim(PA7_LOGRA) + ' - '+AllTrim(PA7_BAIRRO)+ ' - '+AllTrim(PA7_MUNIC)+ ' - '+AllTrim(PA7_ESTADO)))
		aAdd(_aRet, (cTRB)->({PA7_CODCEP, PA7_LOGRA, PA7_BAIRRO, PA7_MUNIC, PA7_ESTADO, PA7_CODMUN, PA7_CODUF, PA7_CODPAI}))
		(cTRB)->( dbSkip() )
	End
	(cTRB)->( dbCloseArea() )
	FErase( cTRB + GetDBExtension() )

	If Len(_aCep) == 0
		Aviso('Erro no campo CEP','CEP Nao encontrado na base de dados',{'Ok'})
		RestArea(_cAreaCEP)
		Return .f.
	EndIf

	lChoice := iif(Len(_aCEP) > 1 .or. _nTamCEP < 8, .t., .f.)

	If lChoice
		lChoice := !IsBlind()
	Endif

	If lChoice
		lChoice := !SubStr( FunName(), 1, 3) == "GAR"
	Endif

	If lChoice
		oDlgCEP:= MSDIALOG():Create()
		oDlgCEP:cName := "oDlgCEP"
		oDlgCEP:cCaption := "Busca por CEP"
		oDlgCEP:nLeft := 0
		oDlgCEP:nTop := 0
		oDlgCEP:nWidth := 733
		oDlgCEP:nHeight := 282
		oDlgCEP:lShowHint := .F.
		oDlgCEP:lCentered := .T.
	
		oLbCEP := TSAY():Create(oDlgCEP)
		oLbCEP:cCaption := "O CEP digitado possui mais de um logradouro."
		oLbCEP:nLeft := 6
		oLbCEP:nTop := 8
		oLbCEP:nWidth := 344
		oLbCEP:nHeight := 17
	
		oListCEP := TLISTBOX():Create(oDlgCEP)
		oListCEP:nLeft := 4
		oListCEP:nTop := 29
		oListCEP:nWidth := 716
		oListCEP:nHeight := 185
		oListCEP:nAt := 0
		oListCEP:aItems := _aCEP
		oListCEP:cVariable := '_nPos'
		oListCEP:bSetGet := {|u| If(PCount()>0,_npos:=u,_npos) }
	
		oOk := SBUTTON():Create(oDlgCEP)
		oOk:cName := "oOk"
		oOk:cCaption := "Seleciona"
		oOk:nLeft := 660
		oOk:nTop := 227
		oOk:nWidth := 56
		oOk:nHeight := 22
		oOk:nType := 1
		oOk:bAction := {|| Fecha(@oDlgCEP) }
    
		oDlgCEP:Activate()
	
	Else
		_nPos := 1
	Endif
   
	If 'CEPC' $ _cVar .And. cOrigem == ' '
		M->A1_CEPC     := _aRet[_nPos, 1]
		M->A1_ENDCOB   := _aRet[_nPos, 2]
		M->A1_BAIRROC  := _aRet[_nPos, 3]
		M->A1_MUNC     := _aRet[_nPos, 4]
		M->A1_ESTC     := _aRet[_nPos, 5]
		M->A1_CODMUNC  := _aRet[_nPos, 6]		// verificar os Folders
		M->A1_CODUFC   := _aRet[_nPos, 7]		//
		M->A1_PABCB    := _aRet[_nPos, 8]       //

	ElseIf 'CEPE' $ _cVar .And. Empty(cOrigem)
		M->A1_CEPE     := _aRet[_nPos, 1]
		M->A1_ENDENT   := _aRet[_nPos, 2]
		M->A1_BAIRROE  := _aRet[_nPos, 3]
		M->A1_MUNE     := _aRet[_nPos, 4]
		M->A1_ESTE     := _aRet[_nPos, 5]		// Existe Ok
		M->A1_CODMUNE  := _aRet[_nPos, 6]		// criar
		M->A1_PAISENT  := _aRet[_nPos, 8]       // criar
	ElseIF 'CEPENT' $ _cVar .And. cOrigem == '1' //- Dados de entrega do fornecedor (Processo Cart�rios)
		M->A2_CEPENT   	:= _aRet[_nPos, 1]
		M->A2_ENDENT   	:= _aRet[_nPos, 2]
		M->A2_BAIRROE 	:= _aRet[_nPos, 3]
		M->A2_MUNE     	:= _aRet[_nPos, 4]
		M->A2_ESTE     	:= _aRet[_nPos, 5]
		M->A2_CODMUNE  	:= _aRet[_nPos, 6]
	Else
		If 'A1' $ _cVar
			M->A1_CEP      	:= _aRet[_nPos, 1]
			M->A1_END      	:= _aRet[_nPos, 2]
			M->A1_BAIRRO   	:= _aRet[_nPos, 3]
			M->A1_MUN      	:= _aRet[_nPos, 4]
			M->A1_EST      	:= _aRet[_nPos, 5]
			M->A1_COD_MUN  	:= _aRet[_nPos, 6]		// Folder 3
			M->A1_COD_EST  	:= _aRet[_nPos, 7]     // Folder 0, tem que colocar no 3
			M->A1_COD_PAI  	:= _aRet[_nPos, 8]
		Else
			M->A2_CEP      	:= _aRet[_nPos, 1]
			M->A2_END      	:= _aRet[_nPos, 2]
			M->A2_BAIRRO   	:= _aRet[_nPos, 3]
			M->A2_MUN      	:= _aRet[_nPos, 4]
			M->A2_EST      	:= _aRet[_nPos, 5]
			M->A2_COD_MUN  	:= _aRet[_nPos, 6]		// Codigo do Municipio - Folder 2
			M->A2_COD_EST  	:= _aRet[_nPos, 7]		// Codigo do Estado - Folder 2
			M->A2_CODPAIS   := _aRet[_nPos, 8]		// Ok, encontrado no dicionario

			IF INCLUI
				M->A2_CEPENT   	:= _aRet[_nPos, 1]
				M->A2_ENDENT   	:= _aRet[_nPos, 2]
				M->A2_BAIRROE 	:= _aRet[_nPos, 3]
				M->A2_MUNE     	:= _aRet[_nPos, 4]
				M->A2_ESTE     	:= _aRet[_nPos, 5]
				M->A2_CODMUNE  	:= _aRet[_nPos, 6]
			EndIF
		EndIf
	EndIf

	RestArea(_cAreaCEP)

Return(.T.)

Static Function Fecha(oDlgCEP)
	oDlgCEP:End()
Return(.T.)