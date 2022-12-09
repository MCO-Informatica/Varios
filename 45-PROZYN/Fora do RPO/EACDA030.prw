#INCLUDE "Acda030.ch"
#Include "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � EACDA030 � Autor � NewBridge/Zanni       � Data � 23/03/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de manutencao no arquivo mestre de inventario     ���
���          � Personalizado para adicionar botoes                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAACD                                                    ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
���              �        �      �                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function EACDA030()
	Local aCores := {}
	//��������������������������������������������������������������Ŀ
	//� Define Array contendo as Rotinas a executar do programa      �
	//� ----------- Elementos contidos por dimensao ------------     �
	//� 1. Nome a aparecer no cabecalho                              �
	//� 2. Nome da Rotina associada                                  �
	//� 3. Usado pela rotina                                         �
	//� 4. Tipo de Transa��o a ser efetuada                          �
	//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
	//�    2 - Simplesmente Mostra os Campos                         �
	//�    3 - Inclui registros no Bancos de Dados                   �
	//�    4 - Altera o registro corrente                            �
	//�    5 - Remove o registro corrente do Banco de Dados          �
	//����������������������������������������������������������������
	PRIVATE aRotina := { { STR0001						, "AxPesqui"  	, 0 , 1},;	 		//"Pesquisar"
	{ STR0002				, "AxVisual"  	, 0 , 2},;		 	//"Visualizar"
	{ STR0003				, "ACDA30Inc"  	, 0 , 3},;		 	//"Incluir"
	{ STR0004				, "ACDA30Alt"  	, 0 , 4, 15},;	 	//"Alterar"
	{ STR0005				, "ACDA30Del"	, 0 , 5, 16} ,;	 	//"Excluir"
	{ STR0006				, "AIVA30Aut"	, 0 , 3, 16},;	 	//"Automatico"
	{ STR0017				, "ACDA032"		, 0 , 2, 16},;	    //"Monitor"
	{ STR0018				, "ACDR030"		, 0 , 1},;	        //"Relatorio"
	{ 'Planilha Elantas'	, "U_PLAN030"	, 0 , 3},;	        //"Relatorio"
	{ STR0007				, "AIVA30Lg" 	, 0 , 3 }}  		//"Legenda"
	PRIVATE cDelFunc := "ACDA30Exc()"
	PRIVATE lLocaliz := GetMv('MV_LOCALIZ')=='S'

	//CBChkTemplate()
	If ! IntAcd(.t.)
		Return .f.
	EndIF

	If ! SuperGetMV("MV_CBPE012",.F.,.F.)
		CBAlert(STR0019) //"Necessario ativar o parametro MV_CBPE012"
		Return .F.
	EndIf

	//��������������������������������������������������������������Ŀ
	//� Define o cabecalho da tela de atualizacoes                   �
	//����������������������������������������������������������������
	PRIVATE cCadastro := STR0008 // //"Mestre de inventario"

	aCores := {  	{ "CBA->CBA_STATUS == '0'", "BR_VERDE" },;
	{ "CBA->CBA_STATUS == '1'", "BR_AMARELO" },;
	{ "CBA->CBA_STATUS == '2'", "BR_CINZA"  },;
	{ "CBA->CBA_STATUS == '3'", "BR_LARANJA"  },;				 	
	{ "CBA->CBA_STATUS == '4'", "BR_AZUL"  },;				 	
	{ "CBA->CBA_STATUS == '5'", "BR_VERMELHO"  }}
	mBrowse( 6, 1, 22, 75, "CBA", , , , , , aCores, , , ,{|x|TimerBrw(x)})
Return      

/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
User Function PLAN030
	cPerg    := 'EACDA030'
	PutSx1(cPerg,"01","Do Operador             ?", "Do Grupo de Produtos    ?", "Do Grupo de Produtos    ?", "mv_ch1","C", 15,0,0,"G","","CB1","","","mv_par01","","","","","","","","","","","","","","","","",{'Operador inicial a ser considerado',''})
	PutSx1(cPerg,"02","Ate o Perador           ?", "Ate o Grupo de Produtos ?", "Ate o Grupo de Produtos ?", "mv_ch2","C", 15,0,0,"G","","CB1","","","mv_par02","","","","","","","","","","","","","","","","",{'Operador final a ser considerado',''})
	PutSx1(cPerg,"03","Do Produto              ?", "Do Produto              ?", "Do Produto              ?", "mv_ch3","C", 15,0,0,"G","","SB1","","","mv_par03","","","","","","","","","","","","","","","","",{'Produto inicial a ser considerado',''})
	PutSx1(cPerg,"04","Ate o Produto           ?", "Ate o Produto           ?", "Ate o Produto           ?", "mv_ch4","C", 15,0,0,"G","","SB1","","","mv_par04","","","","","","","","","","","","","","","","",{'Produto final a ser considerado',''})
	PutSx1(cPerg,"05","Tipo Tolerancia (Qtd/%) ?", "Tipo Tolerancia (Qtd/%) ?", "Tipo Tolerancia (Qtd/%) ?", "mv_ch5","N", 01,0,2,"C",'',''   ,'','','mv_par05','Quantidade','Qtd','Qtd','','Percentual','%','%','','','','','','','','','', {'Define o tipo de tolerancia a considerar'})
	PutSx1(cPerg,"06","Tolerancia              ?", "Tolerancia              ?", "Tolerancia              ?", "mv_ch6","C", 08,0,2,"C",'',''   ,'','','mv_par06','','','','','','','','','','','','','','','','', {'Tolerancia a considerar','Qtde ou percentual (Parametro anteriro)'})
	PutSx1(cPerg,"07","Somente divergentes     ?", "Somente divergentes     ?", "Somente divergentes     ?", "mv_ch7","N", 01,0,2,"C",'',''   ,'','','mv_par07','Sim','Si','Yes','','Nao','No','No','','','','','','','','','', {'Apresenta somente os itens divergentes',''})
	PutSx1(cPerg,"08","Tipo de Inventario      ?", "Tipo de Inventario      ?", "Tipo de Inventario      ?", "mv_ch8","N", 01,0,2,"C",'',''   ,'','','mv_par08','Normal','Si','Yes','','Rotativo','No','No','','','','','','','','','', {'Analitica = quebra linha por cada etiqueta','Sintetico = Sumariza por Produto e Lote'})
	PutSx1(cPerg,"09","Gerar SB7               ?", "Tipo de Planilha        ?", "Tipo de Planilha        ?", "mv_ch9","N", 01,0,2,"C",'',''   ,'','','mv_par09','Sim','Si','Yes','','Nao','No','No','','','','','','','','','', {'Permite gerar (ou n�o) o invent�rio (SB7)','Ap�s a gera��o da planilha'})
	PutSx1(cPerg,"10","Prod invent Rotativo    ?", "Prod invent Rotativo    ?", "Prod invent Rotativo    ?", "mv_cha","C", 50,0,0,"C",'',''   ,'','','mv_par10','','','','','','','','','','','','','','','','', {'Selecionar os produtos que ser�o inventariados rotativo','Inventario Rotativo'})
	If !Pergunte(cPerg, .T.)
		Return .F.
	EndIf         

	MsgRun( 'Efetuando pesquisas de estoque / leituras efetuadas',;
	'Aguarde...',;
	{|| PLAN030x()})
Return .T.

/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
Static Function PLAN030x          
	// Query oficial do Relatorio
	_cQryTot := "Select CBC_CODINV, CBC_NUM, CBC_COD, CBC_LOCAL, CBC_QUANT, CBC_LOCALI, CBC_LOTECT, CBC_CODETI, B1_DESC, CBB_USU, CB1_NOME"

	// Avalia quantidade de leituras
	_cQryLei := "Select Distinct CBC_NUM"

	_cQuery1 := "	From "+RetSqlName('CBC')+" CBC, "+RetSqlName('CBA')+" CBA, "+RetSqlName('SB1')+" SB1, "+RetSqlName('CBB')+" CBB, "+RetSqlName('CB1')+" CB1"
	_cQuery1 += "	Where CBA_CODINV = CBC_CODINV And"
	_cQuery1 += "		  CBA_CODINV = CBB_CODINV And"
	_cQuery1 += "		  CBB_NUM    = CBC_NUM And"
	_cQuery1 += "	      CB1_CODOPE = CBB_USU And"
	_cQuery1 += "	      CBC_COD    = B1_COD And"
	_cQuery1 += "	      CBA_CODINV = '"+CBA->CBA_CODINV+"' And"
	//_cQuery1 += "	      CBA_CODINV = '000000003' And"
	_cQuery1 += "	      CB1_CODOPE Between '"+mv_par01+"' And '"+mv_par02+"' And"
	_cQuery1 += "         B1_COD     Between '"+mv_par03+"' And '"+mv_par04+"' And"
	_cQuery1 += "		  CBC.D_E_L_E_T_ = '' And CBA.D_E_L_E_T_ = '' And SB1.D_E_L_E_T_ ='' And CBB.D_E_L_E_T_ ='' And CB1.D_E_L_E_T_ =''" 

	_cOrder  := "	Order By CBC_NUM, CBC_COD, CBC_LOTECT"

	// Efetua query para apurar qtde de leituras
	_cQuery := _cQryLei+_cQuery1
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),'TMPCB',.T.,.T.)
	_aLeituras := {}
	Do While !EoF()
		aAdd(_aLeituras, TMPCB->CBC_NUM)

		DbSkip()
	EndDo
	TMPCB->(DbCloseArea())

	// Efetua query oficial do relatorio
	_cQuery := _cQryTot+_cQuery1+_cOrder
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),'TMPCB',.T.,.T.)
	_aExcel := {}
	Do While !EoF()
		//If mv_par08 == 2   	// Sintetico
		_nPos   := aScan( _aExcel, {|_x| _x[1] == TMPCB->CBC_COD .And. _x[4] == TMPCB->CBC_LOTECT})
		If Empty(_nPos)         
			_nSaldo := CalcEstL(TMPCB->CBC_COD,TMPCB->CBC_LOCAL,dDataBase+1,TMPCB->CBC_LOTECT)[1]
			SB2->(DbSeek(xFilial('SB2')+TMPCB->CBC_COD+TMPCB->CBC_LOCAL))
			_nCM    := SB2->B2_CM1
			TMPCB->(aAdd(_aExcel, {CBC_COD, B1_DESC, CBC_LOCAL, CBC_LOTECT, _nSaldo}))

			For _nI := 1 To Len(_aLeituras)
				_nTam := Len(_aExcel)
				aAdd(_aExcel[_nTam], If(_aLeituras[_nI] == TMPCB->CBC_NUM, TMPCB->CBC_QUANT, 0)) 	//Leitura atual
				aAdd(_aExcel[_nTam], _aExcel[_nTam, (_nI*2)+4] - _nSaldo)   						//Diferenca perante ao estoque
			Next  
			aAdd(_aExcel[_nTam], _nCM)
			aAdd(_aExcel[_nTam], If(!Empty(TMPCB->CBC_CODETI),TMPCB->CBC_CODETI+'/',''))      
		Else   
			_nPLei := aScan(_aLeituras, TMPCB->CBC_NUM) * 2
			_aExcel[_nPos, _nPLei+4] += TMPCB->CBC_QUANT
			_aExcel[_nPos, _nPlei+5] := _aExcel[_nPos, _nPlei+4] - _aExcel[_nPos, 5]

			_nTam := Len(_aExcel[_nPos])
			_aExcel[_nPos, _nTam] := _aExcel[_nPos, _nTam]+If(!Empty(TMPCB->CBC_CODETI),TMPCB->CBC_CODETI+'/','')
		EndIf
		//Else					// Analitico
		//EndIf   
		DbSkip()   
	EndDo

	//COmplementa Planilha com itens em estoque nao lidos
	_cQuery := "Select B8_PRODUTO, B8_LOCAL, B8_DATA, B8_SALDO, B8_LOTECTL "
	_cQuery += "	From "+RetSqlName('SB8')+" SB8"
	_cQuery += "	Where B8_LOCAL = '"+CBA->CBA_LOCAL+"' And "    
	_cQuery += "	      B8_SALDO > 0 And"  
	If mv_par08 == 2   	// Rotativo 
		_cQuery += "	      B8_PRODUTO IN "+FormatIn(MV_PAR10,";")+"AND"
	endif
	_cQuery += "	      D_E_L_E_T_ = '' "

	dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),'TMPB8',.T.,.T.)

	Do While !EoF()      
		_nPos   := aScan( _aExcel, {|_x| _x[1] == TMPB8->B8_PRODUTO .And. _x[4] == TMPB8->B8_LOTECTL}) 
		If Empty(_nPos)                            
			SB1->(DbSeek(xFilial('SB1')+TMPB8->B8_PRODUTO))  
			SB2->(DbSeek(xFilial('SB2')+TMPB8->B8_PRODUTO+TMPB8->B8_LOCAL))
			TMPB8->(aAdd(_aExcel, {B8_PRODUTO, SB1->B1_DESC, B8_LOCAL, B8_LOTECTL, B8_SALDO}))

			_nTam := 0
			For _nI := 1 To Len(_aLeituras)
				_nTam := Len(_aExcel)
				aAdd(_aExcel[_nTam],  0) 											//Leitura atual
				aAdd(_aExcel[_nTam], 0 - _aExcel[_nTam,5])   						//Diferenca perante ao estoque
			Next  
			If _nTam > 0
				aAdd(_aExcel[_nTam], SB2->B2_CM1)      
				aAdd(_aExcel[_nTam], '*** SEM LEITURA - ITEM EM ESTOQUE ***')      
			EndIf   
		EndIf

		DbSkip()
	EndDo

	TMPB8->(DbCloseArea())

	// Recalcula o Saldo em estoque
	For _nI := 1 To Len(_aExcel)
		If Empty(_aExcel[_nI, 5])   
			SB1->(DbSeek(xFilial('SB1')+_aExcel[_nI, 1]))
			If SB1->B1_RASTRO = 'L'
				_nSaldo := CalcEstL(_aExcel[_nI, 1], _aExcel[_nI, 3], dDataBase+1, _aExcel[_nI, 4])[1]
			Else 
				_nSaldo := CalcEst(_aExcel[_nI, 1], _aExcel[_nI, 3], dDataBase+1)[1]
			EndIf   
			_aExcel[_nI, 5] := _nSaldo
		EndIf                        
	Next
	TMPCB->(DbCloseArea())             

	_cTitulo   := 'Rela��o de Inventario - '+DtoC(dDataBase)+' (Mestre: '+CBA->CBA_CODINV+')'
	//If mv_par08 == 2	// Sintetico
	_aCabec    := {'Produto','Descricao','Armazem','Lote','Estoque'}                
	For _nI := 1 To Len(_aLeituras)
		aAdd(_aCabec, AllTrim(Str(_nI))+'a. Leitura')       
		aAdd(_aCabec, 'Diferenca')
	Next                           
	aAdd(_aCabec, 'Custo Medio')
	aAdd(_aCabec, 'Etiquetas lidas')
	//Else				// Analitico
	//EndIf
	_cArqXls   := U_List2Excel(_aExcel, _aCabec, _cTitulo) //, _aCores)
	//_cAccount  := GetMV( "MV_RELACNT" )
	//_cPassword := GetMV( "MV_RELAPSW"  )
	//_cServer   := GetMV( "MV_RELSERV" )                    
	//_cTo       := 'anderson.zanni@meliora.com.br' //AllTrim(PswRet()[1,14])
	//_cTo       := AllTrim(AA1->AA1_EMAIL)
	//AcSendMail(_cAccount,_cPassword,_cServer,_cAccount,_cTo,'Vendas X Faturamento (Clone) - Detalhe',DtoC(dDataBase)+' - '+Time(),_cArqXls,,)
	//__CopyFile(_cArqXls, "\CFINR003.XLS")
	//MsgInfo('A planilha foi enviada para o e-mail '+_cTo,'Envio de Planilha')

	If mv_par09 == 1 .and. MsgYesNo('Confirma a geracao do arquivo de inventario (SB7)?','Geracao de Invantario ERP')
		Processa({|| fProcessa() },'Gera��o de invent�rio (SB7)')   
		MsgInfo('Favor verificar os inventarios gerados no SB7.','Inventario ERP')
	EndIf
Return .T.                                                       

/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
Static Function fProcessa
	ProcRegua(Len(_aExcel))
	For _nI := 1 To Len(_aExcel)
		IncProc('Lancando inventario para produto '+_aExcel[_nI,2])

		//         TMPCB->(aAdd(_aExcel, {CBC_COD, B1_DESC, CBC_LOCAL, CBC_LOTECT, _nSaldo}))
		SB1->(DbSeek(xFilial('SB1')+_aExcel[_nI,1]))
		SB8->(DbSetOrder(3), DbSeek(xFilial('SB8')+SB1->B1_COD+_aExcel[_nI,3]+_aExcel[_nI, 4]))
		RecLock('SB7',.T.)
		Replace B7_FILIAL  With xFilial('SB7')
		Replace B7_LOCAL   With _aExcel[_nI,3]
		Replace B7_TIPO    With SB1->B1_TIPO
		Replace B7_COD     With SB1->B1_COD
		Replace B7_DOC     With CBA->CBA_CODINV
		Replace B7_QUANT   With _aExcel[_nI,6]
		Replace B7_QTSEGUM With 0
		Replace B7_DATA    With CBA->CBA_DATA
		Replace B7_LOTECTL With _aExcel[_nI,4]
		Replace B7_NUMLOTE With ''
		Replace B7_LOCALIZ With ''
		Replace B7_NUMSERI With ''
		Replace B7_STATUS  With '1'
		Replace B7_DTVALID With SB8->B8_DTVALID
		MsUnlock()    
	Next


/*\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\*/
User Function List2Excel(_aLista, _aCab, _cTitulo, _aCores)    
	_cNome   := CriaTrab(,.F.)
	_cArqXls := AllTrim(GetTempPath())+_cNome+".XLS"
	_nHdl := fCreate(_cArqXls)
	If _nHdl == -1
		MsgAlert("O arquivo de nome "+_cArqXls+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif

	// Cria o cabe�alho do arquivo excel
	_cHtml := "<html><body>"
	_cHtml += "<meta http-equiv='Content-Type' content='application/vnd.ms-excel;charset=iso-8859-1'>"
	_cHtml += "<style type='text/css'>"
	_cHtml += "	td.tabela {"
	_cHtml += "		font-size: 10px; "
	_cHtml += "    	font-family: verdana,tahoma,arial,sans-serif; "
	_cHtml += "    	border-width: 1px; "
	_cHtml += "    	padding: 0px; "
	_cHtml += "    	border-style: dotted; "
	_cHtml += "    	border-color: gray; "
	_cHtml += "    	-moz-border-radius: ; "
	_cHtml += "	}"
	_cHtml += "</style>"
	_cHtml += "<font face=verdana,tahoma,arial,sans-serif size=3 color='#000066'><b>"+_cTitulo+"</b></font>"
	_cHtml += "<table>"
	_cHtml += "<tr>"

	For _nCab := 1 To Len(_aCab) 
		_cHtml += "<td class=tabela bgcolor=#C0C0C0><b>"+_aCab[_nCab]+"</b></td>"
	Next
	_cHtml += "</tr>"
	fWrite(_nHdl,_cHtml,Len(_cHtml))

	//Cores poss�veis
	_aCor := {{'VERM','#FF0000'},;
	{'VERD','#00FF00'},;
	{'AMAR','#FFFF00'},;
	{'AZUL','#0000FF'},;
	{'PRET','#999999'},;
	{'LARA','#FFA500'},;
	{'CINZ','#C0C0C0'},;
	{'ZEBR','#E6E6FA'}}
	For _nI := 1 To Len(_aLista)
		_cHtml := "<tr>"
		FOR _nX:=1 To Len(_aLista[_nI])
			_cHtml += "<td class=tabela "                     
			_lCor := .F.
			If Type('_aCores') == 'A' .and. !Empty(_aCores)
				For _nC := 1 To Len(_aCores)
					If _nX == _aCores[_nC, 1]
						If ValType(_aLista[_nI, _nX]) == ValType(_aCores[_nC, 2]) .and. _aLista[_nI, _nX] == _aCores[_nC, 2]
							_nPos := aScan(_aCor, {|_x| _x[1] == _aCores[_nC,3]})
							If !Empty(_nPos)   
								_cHtml += "bgcolor="+_aCor[_nPos,2]
								_lCor  := .T.
							EndIf
						EndIf
					EndIf
				Next
			EndIf

			If Mod(_nI,2) == 0
				If !_lCor
					_cHtml += "bgcolor=##E6E6FA"
				EndIf	   
			EndIf   
			_cHtml += '>'   

			// Converte Tipos diferente de caracter
			_xVar := _aLista[_nI,_nX]         
			If Type('_xVar') == 'D'
				_xVar := DtoC(_xVar)
			ElseIf Type('_xVar') == 'N'
				_xVar := Transform(_xVar, '@E 999,999,999.9999')   
			ElseIf Type('_xVar') == 'L'   
				_xVar := If(_xVar, 'Sim','Nao')
			ElseIf Type('_xVar') == 'O'
				_xVar := ''   
			EndIf   

			_cHtml += _xVar+" </td>"
		Next _nX
		_cHtml += "</tr>"
		fWrite(_nHdl,_cHtml,Len(_cHtml))
	Next _nI    
	_cHtml := "<TR></TR>"
	fWrite(_nHdl,_cHtml,Len(_cHtml))

	fClose(_nHdl)
	ShellExecute("open",_cArqXls,"","",5)
Return _cArqXls

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TimerBrw  � Autor � Eduardo Motta         � Data � 06/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao que cria timer no mbrowse                           ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cMBrowse -> form em que sera criado o timer                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T.                                                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static Function TimerBrw(oMBrowse)
	Local oTimer
	DEFINE TIMER oTimer INTERVAL 1000 ACTION TmBrowse(GetObjBrow(),oTimer) OF oMBrowse
	oTimer:Activate()
Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � TmBrowse � Autor � Eduardo Motta         � Data � 06/04/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de timer do mbrowse                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros� cMBrowse -> objeto mbrowse a dar refresh                   ���
���          � oTimer   -> objeto timer                                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T.                                                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static Function TmBrowse(oObjBrow,oTimer)
	oTimer:Deactivate()
	oObjBrow:Refresh()
	oTimer:Activate()
Return .T.


User Function MestreOper(_cOperCBA)
	Public _cOper := CBRetOpe()
	_lRet  := .T.
	If !Empty(_cOperCBA)
		If _cOperCBA == _cOper
			_lRet := .T.
		Else
			_lret := .F.   
		EndIf
	EndIf  

Return _lRet