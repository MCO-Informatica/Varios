#INCLUDE "Protheus.CH"
#INCLUDE "Protheus.CH"
#INCLUDE "rwmake.CH" 
#INCLUDE "TOPCONN.CH"
#INCLUDE "Tbiconn.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATE012  �Autor  �Ricardo Nisiyama    � Data �  21/12/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina respons�vel por substituir a consulta padr�o de     ���
���          � produto.                                                   ���
�������������������������������������������������������������������������͹��
���Uso P11   � Protheus 12 - Espec�fico para a empresa Prozyn.            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFATE012()                        

Local oBtnBuscar
Local oComboBo1                 
Local nComboBo1 	:= ""
Local oGroup1
Local oRadMenu1
Local nRadMenu1 	:= 1
Local oSay1
Local oTxtFiltro
Local cTxtFiltro 	:= "                                             "

Private oWBrowse1
Private aWBrowse1	:= {}
     
//����������������������������������������������������������Ŀ
//�Fazer somente se existir o aHeader, pois em alguns lugares�
//�fora da modelo 3 do pedido de venda nao haver aheader e   �
//�daria erro                                                �
//������������������������������������������������������������
If Type("aHeader")=="A"

	Static oDlg
	
	  DEFINE MSDIALOG oDlg TITLE "Consulta Produtos" FROM 000, 000  TO 550, 800 COLORS 0, 16777215 PIXEL 
	
	    @ 009, 008 GROUP oGroup1 TO 064, 115 PROMPT "Filtrar por produtos" OF oDlg COLOR 0, 16777215 PIXEL
	    @ 023, 016 RADIO oRadMenu1 VAR nRadMenu1 ITEMS "Tabela de pre�os ", "Todos os Produtos"  SIZE 080, 036 OF oDlg ON CHANGE Filtrar2(nRadMenu1) COLOR 0, 16777215 PIXEL
	    @ 012, 260 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"","IGUAL","CONTEM","INICIO"} SIZE 135, 010 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 013, 180 SAY oSay1 PROMPT "Escolha o tipo de filtro:" SIZE 058, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 025, 260 MSGET oTxtFiltro VAR cTxtFiltro SIZE 135, 010 OF oDlg  COLORS 0, 16777215 PIXEL
	    @ 052, 350 BUTTON oBtnBuscar PROMPT "&Filtrar" 		SIZE 039, 012 OF oDlg ACTION Filtrar(cTxtFiltro,nRadMenu1,nComboBo1) PIXEL
	    @ 256, 250 BUTTON oButton0   PROMPT "&Visualizar"	SIZE 039, 012 OF oDlg ACTION Visualizar(aWBrowse1[oWBrowse1:nAt,1])  PIXEL
	    @ 256, 300 BUTTON oButton1   PROMPT "&Ok"    		SIZE 039, 012 OF oDlg ACTION Retornar(aWBrowse1[oWBrowse1:nAt,1]) 	 PIXEL
	    @ 256, 350 BUTTON oButton2   PROMPT "&Cancelar" 	SIZE 039, 012 OF oDlg ACTION Retornar2() 							 PIXEL
		
	  	fWBrowse1("")
	
	  ACTIVATE MSDIALOG oDlg CENTERED                                


Else
	Aviso(ProcName() + " - Aten��o!!!","Consultar customizada de produtos n�o compativel nesta tela",{"Ok"})
EndIf
	
Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATE012  �Autor  �Ricardo Nisiyama    � Data �  21/12/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel por fazer a filtragem dos produtos de   ���
���          � acordo com os par�metros escolhidos.                       ���
�������������������������������������������������������������������������͹��
���Uso P12   � Uso espec�fico Prozyn                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Filtrar(_cTexto,_nRadio,_nCombo)
    
Local _aSAcols := aClone(oWBrowse1:AARRAY)
	
aWBrowse1 := oWBrowse1:AARRAY := {}
_cQuery   := ""

If Empty(_nCombo)
	Aviso(ProcName() + " - Aten��o!!!", "Escolha o tipo de filtro", {"OK"})
	Return
EndIf	
	
If _nRadio == 1 .and. !empty(M->C5_TABELA)
	
	_cQuery := "SELECT DISTINCT SB1.B1_COD, SB1.B1_TIPO, SB1.B1_DESCINT, B1_MSBLQL, ISNULL((SB2.B2_QATU-SB2.B2_RESERVA),0) AS [B2_SALDO], DA1.DA1_PRCVEN FROM " + RetSqlName("DA1") + " DA1 "
	_cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 "
	_cQuery += "ON DA1.DA1_CODPRO=SB1.B1_COD "
	_cQuery += "LEFT JOIN " + RetSqlName("SB2") + " SB2 "
	_cQuery += "ON SB2.B2_COD=SB1.B1_COD "                 
	_cQuery += "AND SB2.D_E_L_E_T_='' "
	_cQuery += "AND SB2.B2_FILIAL=" + xFilial("SB2") + " "
	_cQuery += "WHERE SB1.B1_FILIAL='" + xFilial("SB1") + "' "
	_cQuery += "AND SB1.D_E_L_E_T_='' "
	_cQuery += "AND DA1.DA1_FILIAL='" + xFilial("DA1") + "' "
	_cQuery += "AND DA1.D_E_L_E_T_='' "
	//_cQuery += "AND SB1.B1_BLQVEND <> '1' "  //Adicionado por Ricardo Nisiyama 22/06/2016 
	//Verifica se o m�dulo � o faturamento ou o call center
	If Upper(AllTrim(FunName()))=="MATA410"                   		
		_cQuery += "AND DA1.DA1_CODTAB='" + M->C5_TABELA + "' "
	Else
		_cQuery += "AND DA1.DA1_CODTAB='" + M->UA_TABELA + "' "
	EndIf     
	
Else 
	
	_cQuery := "SELECT DISTINCT SB1.B1_COD, SB1.B1_TIPO, SB1.B1_DESCINT, B1_MSBLQL FROM " + RetSqlName("SB1") + " SB1 "
	_cQuery += " WHERE SB1.B1_FILIAL='" + xFilial("SB1") + "' "
	_cQuery += " AND SB1.D_E_L_E_T_='' "
Endif     
	
//	If _nCombo=="C�DIGO PROD." .And. !Empty(_cTexto)
//		_cQuery += "AND UPPER(SB1.B1_COD) LIKE '%" + _cTexto + "%' "
	If _nCombo=="IGUAL" .And. !Empty(_cTexto)
		_cQuery += " AND UPPER(SB1.B1_DESCINT)='" + alltrim(_cTexto) + "' "
	ElseIf _nCombo=="CONTEM" .And. !Empty(_cTexto)
		_cQuery += " AND UPPER(SB1.B1_DESCINT) LIKE '%" + alltrim(_cTexto) + "%' "
	ElseIf _nCombo=="INICIO" .And. !Empty(_cTexto)
		_cQuery += " AND UPPER(SB1.B1_DESCINT) LIKE '" + alltrim(_cTexto) + "%' "
//	ElseIf _nCombo=="PROMO/OU/DESCONTI" .And. !Empty(_cTexto)
//		_cQuery += "AND UPPER(SB1.B1_PRODTP)='" + _cTexto + "' "
//	ElseIf _nCombo=="PROMO/E/DESCONTI"
//		_cQuery += "AND UPPER(SB1.B1_PRODTP)!=''"
	EndIf        
	
//	_cQuery += Permissoes()

_cQuery += " ORDER BY SB1.B1_DESCINT "
_cQuery := ChangeQuery(_cQuery)

	//  Gera arquivo txt com query para teste
	//	MemoWrite("C:\Users\Adriano Leonardo\Desktop\sql.txt",_cQuery)
	
	// Cria tabela tempor�ria com resultado da query
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.F.)
	
	dbSelectArea("TRB")
	dbGoTop()
	
	While !EOF()
		If TRB->B1_MSBLQL <> '1'
		   	Aadd(aWBrowse1,{TRB->B1_COD,TRB->B1_TIPO,TRB->B1_DESCINT})
		Endif
		dbSelectArea("TRB")	     
		dbSkip()
	EndDo
	                                                                                           
	dbSelectArea("TRB")
	dbCloseArea()

aWBrowse1      := aClone(oWBrowse1:AARRAY)
oWBrowse1:NLEN := Len(oWBrowse1:AARRAY)
oWBrowse1:nAt  :=1
oWBrowse1:Refresh()

Return()
  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATE012  �Autor  �Ricardo Nisiyama    � Data �  21/12/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel por fazer a filtragem dos produtos de   ���
���          � acordo com a op��o definida no radio button.               ���
�������������������������������������������������������������������������͹��
���Uso P12   � Uso espec�fico Prozyn                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Filtrar2(_nRadio)

	Local _aSAcols := aClone(oWBrowse1:AARRAY)

	aWBrowse1 := oWBrowse1:AARRAY := {}


IF _nRadio == 1.and. !empty(M->C5_TABELA)
		
	_cQuery := "SELECT DISTINCT SB1.B1_COD, SB1.B1_TIPO, SB1.B1_DESCINT, B1_MSBLQL, ISNULL((SB2.B2_QATU-SB2.B2_RESERVA),0) AS [B2_SALDO], DA1.DA1_PRCVEN FROM " + RetSqlName("DA1") + " DA1 "
	_cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 "
	_cQuery += "ON DA1.DA1_CODPRO=SB1.B1_COD "
	_cQuery += "LEFT JOIN " + RetSqlName("SB2") + " SB2 "
	_cQuery += "ON SB2.B2_COD=SB1.B1_COD "                 
	_cQuery += "AND SB2.D_E_L_E_T_='' "
	_cQuery += "AND SB2.B2_FILIAL=" + xFilial("SB2") + " "
	_cQuery += "WHERE SB1.B1_FILIAL='" + xFilial("SB1") + "' "
	_cQuery += "AND SB1.D_E_L_E_T_='' "
	_cQuery += "AND DA1.DA1_FILIAL='" + xFilial("DA1") + "' "
	_cQuery += "AND DA1.D_E_L_E_T_='' "
	If Upper(AllTrim(FunName()))=="MATA410"                   		
		_cQuery += "AND DA1.DA1_CODTAB='" + M->C5_TABELA + "' "
	Else
		_cQuery += "AND DA1.DA1_CODTAB='" + M->UA_TABELA + "' "
	EndIf     
	
Else 
	
	_cQuery := "SELECT DISTINCT SB1.B1_COD, SB1.B1_TIPO, SB1.B1_DESCINT, B1_MSBLQL FROM " + RetSqlName("SB1") + " SB1 "
	_cQuery += " WHERE SB1.B1_FILIAL='" + xFilial("SB1") + "' "
	_cQuery += " AND SB1.D_E_L_E_T_='' "
Endif     
	
_cQuery += " ORDER BY SB1.B1_DESCINT "
_cQuery := ChangeQuery(_cQuery)        

	//  Gera arquivo txt com query para teste
	//	MemoWrite("C:\Users\Adriano Leonardo\Desktop\sql.txt",_cQuery)
	
	// Cria tabela tempor�ria com resultado da query
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.F.)
	
	dbSelectArea("TRB")
	dbGoTop()
	
	While !EOF()
		If TRB->B1_MSBLQL <> '1'
//		   	Aadd(aWBrowse1,{TRB->B1_COD,EVAL({||Posicione("SB2",1,xFilial("SB2")+B1_COD,"B2_COD"),SaldoSB2()}),TRB->B1_PRODTP, Posicione("DA1",1,xFilial("DA1")+B1_COD,"DA1_PRCVEN") ,TRB->B1_DESCESP})
		   	Aadd(aWBrowse1,{TRB->B1_COD,TRB->B1_TIPO,TRB->B1_DESCINT})
		Endif
		dbSelectArea("TRB")	     	
		dbSkip()
	EndDo
	                                                                                           
	dbSelectArea("TRB")
	dbCloseArea()

	aWBrowse1      := aClone(oWBrowse1:AARRAY)
	oWBrowse1:NLEN := Len(oWBrowse1:AARRAY)
	oWBrowse1:Refresh()

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fWBrowse1 �Autor  �Ricardo Nisiyama    � Data �  21/12/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel listar os itens no browse.              ���
�������������������������������������������������������������������������͹��                                   
���Uso P11   � Programa Principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fWBrowse1(_cFiltro)

Local _cFiltro  
Local _nLin
Local _cGroup

IF !empty(M->C5_TABELA)
		     
	_cGroup := "B1_COD, B1_DESCINT, B1_MSBLQL, DA1_PRCVEN, SB1.B1_TIPO "	
                                        
	_cQuery := "SELECT SB1.B1_COD, SB1.B1_TIPO, SB1.B1_DESCINT, B1_MSBLQL, "
 	_cQuery += "(SELECT ISNULL(SUM(SB2.B2_QATU-SB2.B2_RESERVA),0) FROM " + RetSqlName("SB2") + " SB2 WHERE B2_COD=SB1.B1_COD AND SB2.D_E_L_E_T_='' AND SB2.B2_FILIAL='" + xFilial("SB2") + "' AND SB2.B2_LOCAL='01') AS [B2_SALDO], "
	_cQuery += "DA1.DA1_PRCVEN "
	_cQuery += "FROM " + RetSqlName("DA1") + " DA1 "
	_cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 "
	_cQuery += "ON DA1.DA1_CODPRO=SB1.B1_COD "
	_cQuery += "AND SB1.B1_FILIAL='" + xFilial("SB1") + "' "
	_cQuery += "AND SB1.D_E_L_E_T_='' "
	//_cQuery += "AND SB1.B1_BLQVEND <> '1' "  //Adicionado por Ricardo Nisiyama 22/06/2016
	_cQuery += "AND DA1.DA1_FILIAL='" + xFilial("DA1") + "' " 
	_cQuery += "AND DA1.D_E_L_E_T_='' "          
		
	//Verifica se o m�dulo � o faturamento ou o call center
	If Upper(AllTrim(FunName()))=="MATA410"                   		
		_cQuery += "AND DA1.DA1_CODTAB='" + M->C5_TABELA + "' "
	Else
		_cQuery += "AND DA1.DA1_CODTAB='" + M->UA_TABELA + "' "
	EndIf

Else 
	
	_cGroup := "B1_COD, B1_DESCINT, B1_MSBLQL,  SB1.B1_TIPO "	

	_cQuery := "SELECT DISTINCT SB1.B1_COD, SB1.B1_TIPO, SB1.B1_DESCINT, B1_MSBLQL FROM " + RetSqlName("SB1") + " SB1 "
	_cQuery += " WHERE SB1.B1_FILIAL='" + xFilial("SB1") + "' "
	_cQuery += " AND SB1.D_E_L_E_T_='' "
Endif     
	
_cQuery += "GROUP BY "+_cGroup
_cQuery += " ORDER BY SB1.B1_DESCINT "
_cQuery := ChangeQuery(_cQuery)        


                         
// Cria tabela tempor�ria com resultado da query
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB",.T.,.F.)

    dbSelectArea("TRB")
    dbGoTop()
    
    While !EOF()
    	If TRB->B1_MSBLQL <> '1'  	
		   	Aadd(aWBrowse1,{TRB->B1_COD,TRB->B1_TIPO,TRB->B1_DESCINT})
		Endif
        dbSelectArea("TRB")
	    dbSkip()
	EndDo
	
	dbSelectArea("TRB")
	dbCloseArea()                                                                                
	                            
    @ 070, 008 LISTBOX oWBrowse1 Fields HEADER "C�digo Produto","Tipo","Descri��o Produto.", SIZE 390, 180 OF oDlg PIXEL ColSizes 60,20,10,20,100
    oWBrowse1:SetArray(aWBrowse1)
    
    If !Empty(aWBrowse1)
	    oWBrowse1:nAt := 1
	    oWBrowse1:bLine := {|| {;
	      aWBrowse1[oWBrowse1:nAt,1],;
	      aWBrowse1[oWBrowse1:nAt,2],;
	      aWBrowse1[oWBrowse1:nAt,3],;
	    }}
    Else
	    oWBrowse1:nAt := 1
	    oWBrowse1:bLine := {|| {;
	      "      ",;
	      "      ",;
	      "      ",;
	    }}      
	 Endif 
        
    // DoubleClick event
    oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := Retornar(aWBrowse1[oWBrowse1:nAt,1]),;
    oWBrowse1:DrawSelect()}

     _nPosProd := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
    _cProduto := M->C6_PRODUTO 
	_nLinha := 1
	                                                         
	For _nLin := 1 to Len(aWBrowse1)
	  If Alltrim(_cProduto) $ aWBrowse1[_nLin,1] 
	  	_nLinha := _nLin
	    Exit
	  EndIf
	Next 
		
	If _nLinha < 1  .OR. _nLinha > Len(aWBrowse1)
		_nLinha := 1
	EndIf
	
	
	oWBrowse1:nAt := _nLinha
	
	//Seta o foco na grid
	oWBrowse1:SetFocus()

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Retornar  �Autor  �Ricardo Nisiyama    � Data �  21/12/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para retornar o c�digo do produto selecionado.      ���
�������������������������������������������������������������������������͹��
���Uso P12   � Programa Principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Retornar(_cCodigo)

	_cProduto := _cCodigo
	dbSelectArea("SB1")
	dbSetOrder(1)
	If !dbSeek(xFilial("SB1") + PADR(_cProduto,TAMSX3("B1_COD")[01]),.T.,.F.)
		Alert("Produto inexistente!")
		_cProduto := Space(TAMSX3("B1_COD")[01])
	EndIf
	Close(oDlg)
Return(_cProduto)


Static Function Retornar2(_cCodigo)

	DbSelectArea("SB1")
	DbGoBottom()
		While !Eof()
		
		DbSelectArea("SB1")
		DbSkip()
			
	EndDo
	_cProduto := "      "
	Close(oDlg)
Return(_cProduto)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Permissoes�Autor  �Adriano Leonardo    � Data �  02/01/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para retornar o trecho da query respons�vel por     ���
��           � filtrar os produtos de acordo com a permiss�o do grupo.    ���
�������������������������������������������������������������������������͹��
���Uso P11   � Programa Principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/              
/*
Static Function Permissoes()

	//Retorna o c�digo do grupo que o usu�rio pertence
//	_cCodGru := UsrRetGrp(UsrRetName(RetCodUsr()))[1]

	_cFiltro := ""

	dbSelectArea("SZ4") //Permiss�es
	dbSetOrder(1) // Filial + N�mero
	//Retorna em branco caso n�o exista cadastro para esse grupo
	If !MsSeek(xFilial("SZ4")+_cCodGru,.T.,.F.)
		Return(_cFiltro)
	EndIf
	
	_nCont := 1
	
	//Monta a string com o filtro a partir do cadastro de permiss�es	
	While !EOF() .And. AllTrim(SZ4->Z4_GRUPO)==_cCodGru
        If _nCont == 1    
        	_cFiltro += "AND ( "
			_cFiltro += "B1_TIPO='" + AllTrim(SZ4->Z4_TIPO) + "' "
		Else
			_cFiltro += "OR B1_TIPO='" + AllTrim(SZ4->Z4_TIPO) + "' "
		EndIf   
		
		dbSelectArea("SZ4")
		dbSetOrder(1) // Filial + N�mero
		dbSkip()
		_nCont++
	EndDo	                  

	//Fecha os condicionais 'OR' da query
	If _nCont >1
		_cFiltro += ") "
	EndIf
Return(_cFiltro) 
*/
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Visualizar�Autor  �Adriano Leonardo    � Data �  07/05/2013 ���
����������������������0���������������������������������������������������͹��
���Desc.     � Fun��o para retornar o c�digo do produto selecionado.      ���
�������������������������������������������������������������������������͹��
���Uso P11   � Programa Principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Visualizar(_cCodigo)

Local _cProduto := _cCodigo

dbSelectArea("SB1")
dbSetOrder(1)
If !MsSeek(xFilial("SB1") + PADR(_cProduto,TAMSX3("B1_COD")[01]),.T.,.F.)
	Alert("Produto inexistente!")
	_cProduto := Space(TAMSX3("B1_COD")[01])
Else
	_nReg := SB1->(Recno())
EndIf

A010Visul("SB1",_nReg,2)  // Para realizar a visualiza��o da fotos dos produtos
//AxVisual( "SB1", _nReg,3,,,,,{})

Return(_cProduto)