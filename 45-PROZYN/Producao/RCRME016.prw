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

User Function RCRME016()
	Private _cTabTmp3 	:= GetNextAlias()
	Private _cSZ1Tmp 	:= GetNextAlias()
	Private _cEnt		:= CHR(13) + CHR(10)
	Private cMarca3   	:= GetMark()
	Private _cQryTmp           
	Private _cArm		:= ""	
	Private cCadastro	:= "Selecione os contatos"
	
	//Fun��es chamadas na tela do markbrowse
	Private aRotina 	:= {{"&Confirmar"	, "U_RESTR48E()",0,1},;
							{"In&verter"	, "U_RESTR48F()",0,1} }
	
	Private bMark3    	:= {|| MarkSel3()}     
	Private cCodCli 	:= M->ZL_CODCLI
	Private cCodLoj		:= M->ZL_LOJA
	Private cCodEnt		:= cCodCli + cCodLoj
	
	_aCpoTmp3 := {} // Campos que serao exibidos no MarkBrowse
	
	AADD(_aCpoTmp3,{"TD_OK"		," "," "				})
	AADD(_aCpoTmp3,{"TD_CODIGO"	," ","C�digo"			})
	AADD(_aCpoTmp3,{"TD_DESC"	," ","Nome"		        })
	
	_aEstru3 := {} // Estrutura do Arquivo Temporario
	
	AADD(_aEstru3,{"TD_OK"			, "C",02,0})
	AADD(_aEstru3,{"TD_CODIGO"		, "C",06,0})
	AADD(_aEstru3,{"TD_DESC"		, "C",15,0})
	
	_cArq3 := CriaTrab(_aCpoTmp3,.F.) //Nome do arquivo tempor�rio
	DbCreate(_cArq3,_aEstru3)
	DbUseArea(.T.,,_cArq3,_cTabTmp3,.F.)
	
	//Consulta no banco de dados para sele��o dos tipos de produtos que ser�o considerados no relat�rio
	_cQryTmp := "SELECT '' AS [U5_OK], U5_CODCONT, U5_CONTAT FROM  " + RetSqlName("SU5") + "  SU5 " + _cEnt
	_cQryTmp += "INNER JOIN  " + RetSqlName("AC8") + "  AC8 " + _cEnt
	_cQryTmp += "ON SU5.U5_CODCONT = AC8.AC8_CODCON " + _cEnt
	_cQryTmp += "AND AC8_ENTIDA = 'SA1' " + _cEnt
	_cQryTmp += "AND AC8_CODENT = '"+cCodEnt+"' " + _cEnt
	_cQryTmp += "AND SU5.D_E_L_E_T_='' " + _cEnt
		
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryTmp),_cSZ1Tmp,.F.,.T.)
	
	dbSelectArea(_cSZ1Tmp)
	dbGoTop()
	
	While (_cSZ1Tmp)->(!EOF())
		
		dbSelectArea(_cTabTmp3)
		
		//Preencho a tabela tempor�ria com o resultado da query
		RecLock(_cTabTmp3,.T.)
			(_cTabTmp3)->TD_OK 		:= (_cSZ1Tmp)->U5_OK
			(_cTabTmp3)->TD_CODIGO 	:= (_cSZ1Tmp)->U5_CODCONT
			(_cTabTmp3)->TD_DESC 	:= RTRIM((_cSZ1Tmp)->U5_CONTAT)
		(_cTabTmp3)->(MsUnlock())
		
		dbSelectArea(_cSZ1Tmp)
		dbSkip()
	EndDo
	
	//Crio tela para marca��o dos itens a serem impressos, dentro do intervalo de par�metros definidos pelo usu�rio
	MarkBrowse(_cTabTmp3,"TD_OK",,_aCpoTmp3,,cMarca3,"U_RESTR48E()",,,,"eval(bMark3)")
	
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

User Function RESTR48E()
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

User Function RESTR48F()
	
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
		   _cArm := StrTran(_cArm,","+RTRIM((_cTabTmp3)->TD_DESC),"")
	   	   _cArm := StrTran(_cArm,RTRIM((_cTabTmp3)->TD_DESC)	,"")

			If SubStr(AllTrim(_cArm),1,1)==","
				_cArm := SubStr(AllTrim(_cArm),2,Len(AllTrim(_cArm)))
			EndIf
			
	   MsUnlock()
	Else
	   DbSelectArea(_cTabTmp3)
	   
	   RecLock(_cTabTmp3,.F.)
		   Replace TD_OK With cMarca3
		   _cArm += IIF(Empty(_cArm),RTRIM((_cTabTmp3)->TD_DESC),"," + RTRIM((_cTabTmp3)->TD_DESC))
	   MsUnlock()
	EndIf
	
Return()