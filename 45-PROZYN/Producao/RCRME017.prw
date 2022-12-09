/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RESTR048    � Autor � Adriano Leonardo  � Data �  07/07/15 ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o respos�vel por criar tela de markbrowse para sele��o���
���          � dos contatos a serem selecionados                          ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa Prozyn                			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RCRME017()
	Private _cTabTmp3 	:= GetNextAlias()
	Private _cSZ1Tmp 	:= GetNextAlias()
	Private _cEnt		:= CHR(13) + CHR(10)
	Private cMarca3   	:= GetMark()
	Private _cQryTmp           
	Private _cArm		:= ""	
	Private cCadastro	:= "Selecione os documentos"
	
	//Fun��es chamadas na tela do markbrowse
	Private aRotina 	:= {{"&Confirmar"	, "U_RESTR48G()",0,1},;
							{"In&verter"	, "U_RESTR48H()",0,1} }
	
	Private bMark3    	:= {|| MarkSel3()}
	
	_aCpoTmp3 := {} // Campos que serao exibidos no MarkBrowse
	
	AADD(_aCpoTmp3,{"TD_OK"		," "," "				})
	AADD(_aCpoTmp3,{"TD_CODIGO"	," ","C�digo"			})
	AADD(_aCpoTmp3,{"TD_DESC"	," ","Descri��o"		        })
	
	_aEstru3 := {} // Estrutura do Arquivo Temporario
	
	AADD(_aEstru3,{"TD_OK"			, "C",02,0})
	AADD(_aEstru3,{"TD_CODIGO"		, "C",06,0})
	AADD(_aEstru3,{"TD_DESC"		, "C",60,0})
	
	_cArq3 := CriaTrab(_aCpoTmp3,.F.) //Nome do arquivo tempor�rio
	DbCreate(_cArq3,_aEstru3)
	DbUseArea(.T.,,_cArq3,_cTabTmp3,.F.)
	
	//Consulta no banco de dados para sele��o dos tipos de produtos que ser�o considerados no relat�rio
	_cQryTmp := "SELECT '' AS [ZN_OK], ZN_CODIGO, ZN_DESC FROM " + RetSqlName("SZN") + " SZN " + _cEnt
	_cQryTmp += "WHERE SZN.D_E_L_E_T_='' " + _cEnt
	_cQryTmp += "AND SZN.ZN_FILIAL='" + xFilial("SZN") + "' " + _cEnt
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryTmp),_cSZ1Tmp,.F.,.T.)
	
	dbSelectArea(_cSZ1Tmp)
	dbGoTop()
	
	While (_cSZ1Tmp)->(!EOF())
		
		dbSelectArea(_cTabTmp3)
		
		//Preencho a tabela tempor�ria com o resultado da query
		RecLock(_cTabTmp3,.T.)
			(_cTabTmp3)->TD_OK 		:= (_cSZ1Tmp)->ZN_OK
			(_cTabTmp3)->TD_CODIGO 	:= (_cSZ1Tmp)->ZN_CODIGO
			(_cTabTmp3)->TD_DESC 	:= RTRIM((_cSZ1Tmp)->ZN_DESC)
		(_cTabTmp3)->(MsUnlock())
		
		dbSelectArea(_cSZ1Tmp)
		dbSkip()
	EndDo
	
	//Crio tela para marca��o dos itens a serem impressos, dentro do intervalo de par�metros definidos pelo usu�rio
	MarkBrowse(_cTabTmp3,"TD_OK",,_aCpoTmp3,,cMarca3,"U_RESTR48G()",,,,"eval(bMark3)")
	
Return(_cArm)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RESTR048    � Autor � Adriano Leonardo  � Data �  07/07/15 ���
�������������������������������������������������������������������������͹��
���Descricao � Confirma sele��o dos armaz�ns (markbrowse).                ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa LDI                			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RESTR48G()
	_lRestr048 := .T.
	CloseBrowse()
Return(_cArm)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RESTR048    � Autor � Adriano Leonardo  � Data �  07/07/15 ���
�������������������������������������������������������������������������͹��
���Descricao � Inverte sele��o dos armaz�ns (markbrowse).                 ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa LDI                			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function RESTR48H()
	
	(_cTabTmp3)->(DbGoTop())
	While (_cTabTmp3)->(!EOF())
	   MarkSel3()
	   (_cTabTmp3)->(DbSkip())
	EndDo
	
Return()
                 
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RESTR048    � Autor � Adriano Leonardo  � Data �  26/05/15 ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o respos�vel por marcar os tipos de produtos selecio- ���
���          � nados pelo usu�rio para impress�o do cat�logo.             ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico para a empresa LDI                			  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

Static Function MarkSel3()
	
	Local lDesmarc := IsMark("TD_OK", cMarca3, .T.)
	
	If !Empty((_cTabTmp3)->TD_OK)
	   DbSelectArea(_cTabTmp3)
	   
	   RecLock(_cTabTmp3,.F.)
		   Replace TD_OK With Space(2)
		   _cArm := StrTran(_cArm,", "+RTRIM((_cTabTmp3)->TD_DESC),"")
	   	   _cArm := StrTran(_cArm,RTRIM((_cTabTmp3)->TD_DESC)	,"")

			If SubStr(AllTrim(_cArm),1,1)==", "
				_cArm := SubStr(AllTrim(_cArm),2,Len(AllTrim(_cArm)))
			EndIf
			
	   MsUnlock()
	Else
	   DbSelectArea(_cTabTmp3)
	   
	   RecLock(_cTabTmp3,.F.)
		   Replace TD_OK With cMarca3
		   _cArm += IIF(Empty(_cArm),RTRIM((_cTabTmp3)->TD_DESC),", " + RTRIM((_cTabTmp3)->TD_DESC))
	   MsUnlock()
	EndIf
	
Return()