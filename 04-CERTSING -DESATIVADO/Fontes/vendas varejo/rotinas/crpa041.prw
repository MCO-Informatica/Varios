#INCLUDE "totvs.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CRPA041   � Autor � RENATO RUY BERNARDO� Data �  18/07/17   ���
�������������������������������������������������������������������������͹��
���Descricao � MANUTEN��O MANUAL PARA LAN�AMENTOS PRODUTO SERVIDOR        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CERTISIGN - REMUNERA��O DE PARCEIROS                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CRPA041


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Lancamento Produto Servidor"
//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := { {"Pesquisar"	,"AxPesqui",0,1} ,;
		             {"Visualizar"	,"u_CRPA041A('2')",0,2} ,;
		             {"Incluir"		,"u_CRPA041A('3')",0,3} ,;
		             {"Alterar"		,"u_CRPA041A('4')",0,4} ,;
		             {"Excluir"		,"u_CRPA041A('5')",0,5} }

//���������������������������������������������������������������������Ŀ
//� Monta array com os campos para o Browse                             �
//�����������������������������������������������������������������������

Private aCampos := { {"PERIODO"	   		,"Z6_PERIODO"	,"",00,00,""} ,;
           			 {"CODIGO CCR"		,"Z6_CODENT"	,"",00,00,""} ,;
           			 {"DESC. CCR"		,"Z6_DESENT"	,"",00,00,""} ,;
           			 {"PRODUTO"			,"Z6_PRODUTO"	,"",00,00,""} ,;
					 {"DESC.PRODUTO"	,"Z6_DESCRPR"	,"",00,00,""} ,;
           			 {"VALOR COMISSAO"	,"Z6_VALCOM"	,"",00,00,""} ,;
      				 {"DESC.PRODUTO"	,"Z6_DESGRU"	,"",00,00,""} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SZ6"
Private aIndex  := {}
Private cFiltro := "Z6_FILIAL = ' ' AND Z6_PEDGAR = 'SERVIDOR'"

dbSelectArea("SZ6")
dbSetOrder(1)
dbSelectArea(cString)

mBrowse( 6,1,22,75,cString,aCampos,,,,,,,,,,,,,cFiltro)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  CRPA041A   � Autor � RENATO RUY BERNARDO� Data �  18/07/17   ���
�������������������������������������������������������������������������͹��
���Descricao � TELA PARA MANUTEN��O DOS LAN�AMENTOS                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CERTISIGN - REMUNERA��O DE PARCEIROS                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

USER FUNCTION CRPA041A(cFuncao)
 
Local aBotoes	:= {}         //Vari�vel onde ser� incluido o bot�o para a legenda
Local oSay1, oSay2, oSay3, oSay4
Local oFont := TFont():New('Courier new',,-12,.T.)
Private cCombo1
Private cGet1 	:= SZ6->Z6_CODENT
Private cGet2 	:= SZ6->Z6_DESENT
Private cGet3 	:= SZ6->Z6_PRODUTO
Private cGet4 	:= SZ6->Z6_DESCRPR
Private cGet5 	:= SZ6->Z6_DESGRU
Private cGet6 	:= SZ6->Z6_VALCOM
Private cGet7 	:= SZ6->Z6_VLRPROD
Private otGet1, otGet2, otGet3, otGet4, otGet5, otGet6
Private lGet := .T.
Private oLista                    //Declarando o objeto do browser
Private aCabecalho  := {}         //Variavel que montar� o aHeader do grid
Private aColsEx 	:= {}         //Vari�vel que receber� os dados

If cFuncao $ "4/5" .And. SZ6->Z6_PERIODO < AllTrim(GetMv("MV_REMMES"))
	Alert("O lan�amento n�o pode ser alterado, o per�odo: "+SZ6->Z6_PERIODO+" j� foi est� encerrado!")
	Return
Endif

If cFuncao $ "2/5"
	lGet := .F.
Endif

DEFINE MSDIALOG oDlg TITLE "MANUTEN��O DE LAN�AMENTOS" FROM 000, 000  TO 300, 500  PIXEL
        
oSay1	:= TSay():New( 35,01,{||'Entidade'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
otGet1 	:= TGet():New( 45,01,bSetGet(cGet1),oDlg,050,,'@!',{|| CPOS041('SZ3') },,,,.F.,,.T.,,.F.,{|| lGet},.F.,.F., ,.F.,.F.,,"cGet1",,,,)
otGet1:cF3 := "SZ3"
        
oSay2	:= TSay():New( 35,60,{||'Descri��o'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
otGet2 	:= TGet():New( 45,60,bSetGet(cGet2),oDlg,180,,'@!',{|| .T. },,,,.F.,,.T.,,.F.,{|| .F.},.F.,.F., ,.F.,.F.,,"cGet2",,,,)

oSay3	:= TSay():New( 65,01,{||'Produto'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
otGet3 	:= TGet():New( 75,01,bSetGet(cGet3),oDlg,050,,'@!',{|| CPOS041('PA8') },,,,.F.,,.T.,,.F.,{|| lGet},.F.,.F., ,.F.,.F.,,"cGet3",,,,)
otGet3:cF3 := "PA8"

oSay4	:= TSay():New( 65,60,{||'Desc.Produto'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
otGet4 	:= TGet():New( 75,60,bSetGet(cGet4),oDlg,180,,'@!',{|| .T. },,,,.F.,,.T.,,.F.,{|| lGet},.F.,.F., ,.F.,.F.,,"cGet4",,,,) 

oSay5	:= TSay():New( 90,01,{||'Projeto'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
otGet5 	:= TGet():New( 100,01,bSetGet(cGet5),oDlg,180,,'@!',{|| .T. },,,,.F.,,.T.,,.F.,{|| lGet},.F.,.F., ,.F.,.F.,,"cGet5",,,,)

oSay7	:= TSay():New( 115,01,{||'Faturamento'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
otGet7 	:= TGet():New( 125,01,bSetGet(cGet7),oDlg,050,,'@E 999,999,999.99',{|| .T. },,,,.F.,,.T.,,.F.,{|| lGet},.F.,.F., ,.F.,.F.,,"cGet7",,,,) 

oSay6	:= TSay():New( 115,60,{||'Comiss�o'},oDlg,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
otGet6 	:= TGet():New( 125,60,bSetGet(cGet6),oDlg,050,,'@E 999,999,999.99',{|| .T. },,,,.F.,,.T.,,.F.,{|| lGet},.F.,.F., ,.F.,.F.,,"cGet6",,,,)
 
EnchoiceBar(oDlg, {|| CRPA41G(cFuncao) }, {|| oDlg:End() },,aBotoes)
 
ACTIVATE MSDIALOG oDlg CENTERED

RETURN

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CPOS041   � Autor � RENATO RUY BERNARDO� Data �  18/07/17   ���
�������������������������������������������������������������������������͹��
���Descricao � GATILHO PARA CAMPOS DA SZ3 E PA8                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CERTISIGN - REMUNERA��O DE PARCEIROS                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CPOS041(cTabela) 

Local lRet := .T.

If cTabela == "SZ3"
	SZ3->(DbSetOrder(1))
	If !SZ3->(DbSeek(xFilial("SZ3")+cGet1))
		Alert("CCR n�o Localizado!")
		cGet1 := SPACE(6)
		cGet2 := SPACE(100)
		lRet  := .F.
	Elseif SZ3->(DbSeek(xFilial("SZ3")+cGet1)) .And. SZ3->Z3_TIPENT != "9"
		Alert("Nesta tela somente pode ser informado um CCR!")
		cGet1 := SPACE(6)
		cGet2 := cGet2 := SPACE(100)
		lRet  := .F.
	Else
		cGet1 := SZ3->Z3_CODENT
		cGet2 := SZ3->Z3_DESENT
	Endif
Elseif cTabela == "PA8"
	PA8->(DbSetOrder(1))
	If PA8->(DbSeek(xFilial("SZ3")+cGet3))
		cGet3 := PA8->PA8_CODBPG
		cGet4 := PA8->PA8_DESBPG
	Else
		MsgInfo("O produto n�o existe no cadastro e a informacao dever� ser lan�ada manualmente!")
	Endif
Endif

Return lRet

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CRPA41G   � Autor � RENATO RUY BERNARDO� Data �  18/07/17   ���
�������������������������������������������������������������������������͹��
���Descricao � GRAVA OU EXCLUI INFORMA��ES DOS LAN�AMENTOS                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CERTISIGN - REMUNERA��O DE PARCEIROS                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CRPA41G(cFuncao)

If Empty(cGet1)
	Alert("O CCR deve ser preenchido!")
	return
ElseIf Empty(cGet3)
	Alert("O c�digo do produto deve ser preenchido!")
	return
ElseIf Empty(cGet4)
	Alert("A descri��o do produto deve ser preenchida!")
	return
ElseIf Empty(cGet5)
	Alert("A descri��o do projeto deve ser preenchida!")
	return
ElseIf cGet6 == 0
	Alert("O valor do lan�amento deve ser diferente que zero!")
	return
Endif

If cFuncao == "3"
	Reclock("SZ6",.T.)
		SZ6->Z6_PERIODO := AllTrim(GetMv("MV_REMMES"))
		SZ6->Z6_TIPO	:= "SERVER"
		SZ6->Z6_PEDGAR  := "SERVIDOR"
		SZ6->Z6_CODAC   := Posicione("SZ3",1,xFilial("SZ3")+cGet1,"Z3_CODAC")
		SZ6->Z6_CODCCR  := cGet1
		SZ6->Z6_CODENT  := cGet1
		SZ6->Z6_DESENT  := cGet2
		SZ6->Z6_PRODUTO := cGet3
		SZ6->Z6_DESCRPR := cGet4
		SZ6->Z6_DESGRU  := cGet5
		SZ6->Z6_VALCOM	:= cGet6
		SZ6->Z6_VLRPROD	:= cGet7
		SZ6->Z6_BASECOM	:= cGet7
		SZ6->Z6_TPENTID := "4"
		SZ6->Z6_CATPROD := "2"
		SZ6->Z6_REGCOM  := DtoC(dDatabase) + " - " + Time() + " - Incluido pelo Usu�rio: " + cUserName
	SZ6->(MsUnlock())
Elseif cFuncao == "4"
	Reclock("SZ6",.F.)
		SZ6->Z6_PERIODO := AllTrim(GetMv("MV_REMMES"))
		SZ6->Z6_TIPO	:= "SERVER"
		SZ6->Z6_PEDGAR  := "SERVIDOR"
		SZ6->Z6_CODAC   := Posicione("SZ3",1,xFilial("SZ3")+cGet1,"Z3_CODAC")
		SZ6->Z6_CODCCR  := cGet1
		SZ6->Z6_CODENT  := cGet1
		SZ6->Z6_DESENT  := cGet2
		SZ6->Z6_PRODUTO := cGet3
		SZ6->Z6_DESCRPR := cGet4
		SZ6->Z6_DESGRU  := cGet5
		SZ6->Z6_VALCOM	:= cGet6
		SZ6->Z6_VLRPROD	:= cGet7
		SZ6->Z6_BASECOM	:= cGet7
		SZ6->Z6_TPENTID := "4"
		SZ6->Z6_CATPROD := "2"
		SZ6->Z6_REGCOM  := DtoC(dDatabase) + " - " + Time() + " - Alterado pelo Usu�rio: " + cUserName
	SZ6->(MsUnlock())
Elseif cFuncao == "5"
	Reclock("SZ6",.F.)
		SZ6->Z6_REGCOM  := DtoC(dDatabase) + " - " + Time() + " - Excluido pelo Usu�rio: " + cUserName
		SZ6->(DbDelete())	
	SZ6->(MsUnlock())
Endif

oDlg:End()

Return