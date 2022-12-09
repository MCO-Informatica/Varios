#INCLUDE "PROTHEUS.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �TesGaia   � Autor � Rafael Augusto        � Data �16/11/2010���
�������������������������������������������������������������������������Ĵ��
���Locacao   � SuperTech        �Contato � rafael@stch.com.br             ���
�������������������������������������������������������������������������Ĵ��
���Descricao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Bops � Manutencao Efetuada                    ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �      �                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function TesGaia()

Local _aArea   		:= {}
Local _aAlias  		:= {}
Private oDlg				// Dialog Principal
Private VISUAL 		:= .F.
Private INCLUI 		:= .F.
Private ALTERA 		:= .F.
Private DELETA 		:= .F.
Private oGetDados1

DEFINE MSDIALOG oDlg TITLE "Autentica��o Bancaria" FROM C(242),C(245) TO C(452),C(642) PIXEL

// Defina aqui a chamada dos Aliases para o GetArea
CtrlArea(1,@_aArea,@_aAlias,{"SA1","SA2"}) // GetArea

// Cria Componentes Padroes do Sistema
@ C(010),C(010) Say "J� foi impresso Boleto do Bradesco para os titulos:" Size C(121),C(008) COLOR CLR_BLACK PIXEL OF oDlg
DEFINE SBUTTON FROM C(090),C(163) TYPE 1 ENABLE OF oDlg

// Cria ExecBlocks dos Componentes Padroes do Sistema

// Chamadas das GetDados do Sistema
fGetDados1()

CtrlArea(2,_aArea,_aAlias) // RestArea

ACTIVATE MSDIALOG oDlg CENTERED

Return(.T.)

/*����������������������������������������������������������������������������������
������������������������������������������������������������������������������������
��������������������������������������������������������������������������������Ŀ��
���Programa   �fGetDados1()� Autor � Rafael Augusto            � Data �16/11/2010���
��������������������������������������������������������������������������������Ĵ��
���Descricao  � Montagem da GetDados                                             ���
��������������������������������������������������������������������������������Ĵ��
���Observacao � O Objeto oGetDados1 foi criado como Private no inicio do Fonte   ���
���           � desta forma voce podera trata-lo em qualquer parte do            ���
���           � seu programa:                                                    ���
���           �                                                                  ���
���           � Para acessar o aCols desta MsNewGetDados: oGetDados1:aCols[nX,nY]���
���           � Para acessar o aHeader: oGetDados1:aHeader[nX,nY]                ���
���           � Para acessar o "n"    : oGetDados1:nAT                           ���
���������������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������������
����������������������������������������������������������������������������������*/
Static Function fGetDados1()
// Variaveis deste Form
Local nX			:= 0
//�����������������������������������Ŀ
//� Variaveis da MsNewGetDados()      �
//�������������������������������������
// Vetor responsavel pela montagem da aHeader
Local aCpoGDa       	:= {""}

// Vetor com os campos que poderao ser alterados
Local aAlter       	:= {""}
Local nSuperior    	:= C(028)           // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda    	:= C(007)           // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nInferior    	:= C(085)           // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita     	:= C(189)           // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
Local nOpc         	:= GD_INSERT+GD_DELETE+GD_UPDATE
Local cLinOk       	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.

// Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do
// segundo campo>+..."
Local nFreeze      	:= 000              // Campos estaticos na GetDados.
Local nMax         	:= 999              // Numero maximo de linhas permitidas. Valor padrao 99
Local cFieldOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo
Local cSuperDel     := ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cDelOk        := "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols

// Objeto no qual a MsNewGetDados sera criada
Local oWnd          := oDlg
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader
Local aCol         	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols

// Carrega aHead
DbSelectArea("SX3")
SX3->(DbSetOrder(2)) // Campo
For nX := 1 to Len(aCpoGDa)
	If SX3->(DbSeek(aCpoGDa[nX]))
		Aadd(aHead,{ AllTrim(X3Titulo()),;
		SX3->X3_CAMPO	,;
		SX3->X3_PICTURE ,;
		SX3->X3_TAMANHO ,;
		SX3->X3_DECIMAL ,;
		SX3->X3_VALID	,;
		SX3->X3_USADO	,;
		SX3->X3_TIPO	,;
		SX3->X3_F3 		,;
		SX3->X3_CONTEXT ,;
		SX3->X3_CBOX	,;
		SX3->X3_RELACAO})
	Endif
Next nX
// Carregue aqui a Montagem da sua aCol
aAux := {}
For nX := 1 to Len(aCpoGDa)
	If DbSeek(aCpoGDa[nX])
		Aadd(aAux,CriaVar(SX3->X3_CAMPO))
	Endif
Next nX
Aadd(aAux,.F.)
Aadd(aCol,aAux)

/*
FUNCOES PARA AUXILIO NO USO DA NEWGETDADOS
PARA MAIORES DETALHES ESTUDE AS FUNCOES AO FIM DESTE FONTE
==========================================================

// Retorna numero da coluna onde se encontra o Campo na NewGetDados
Ex: NwFieldPos(oGet1,"A1_COD")

// Retorna Valor da Celula da NewGetDados
// OBS: Se nLinha estiver vazia ele acatara o oGet1:nAt(Linha Atual) da NewGetDados
Ex: NwFieldGet(oGet1,"A1_COD",nLinha)

// Alimenta novo Valor na Celula da NewGetDados
// OBS: Se nLinha estiver vazia ele acatara o oGet1:nAt(Linha Atual) da NewGetDados
Ex: NwFieldPut(oGet1,"A1_COD",nLinha,"Novo Valor")

// Verifica se a linha da NewGetDados esta Deletada.
// OBS: Se nLinha estiver vazia ele acatara o oGet1:nAt(Linha Atual) da NewGetDados
Ex: NwDeleted (oGet1,nLinha)
*/

oGetDados1:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinOk,cTudoOk,cIniCpos,;
aAlter,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oWnd,aHead,aCol)

// Cria ExecBlocks da GetDados

Return Nil

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()   � Autores � Norbert/Ernani/Mansano � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolucao horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640							// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else									// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//���������������������������Ŀ
//�Tratamento para tema "Flat"�
//�����������������������������
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CtrlArea � Autor �Ricardo Mansano     � Data � 18/05/2005  ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Static Function auxiliar no GetArea e ResArea retornando   ���
���          � o ponteiro nos Aliases descritos na chamada da Funcao.     ���
���          � Exemplo:                                                   ���
���          � Local _aArea  := {} // Array que contera o GetArea         ���
���          � Local _aAlias := {} // Array que contera o                 ���
���          �                     // Alias(), IndexOrd(), Recno()        ���
���          �                                                            ���
���          � // Chama a Funcao como GetArea                             ���
���          � P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4"})         ���
���          �                                                            ���
���          � // Chama a Funcao como RestArea                            ���
���          � P_CtrlArea(2,_aArea,_aAlias)                               ���
�������������������������������������������������������������������������͹��
���Parametros� nTipo   = 1=GetArea / 2=RestArea                           ���
���          � _aArea  = Array passado por referencia que contera GetArea ���
���          � _aAlias = Array passado por referencia que contera         ���
���          �           {Alias(), IndexOrd(), Recno()}                   ���
���          � _aArqs  = Array com Aliases que se deseja Salvar o GetArea ���
�������������������������������������������������������������������������͹��
���Aplicacao � Generica.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function CtrlArea(_nTipo,_aArea,_aAlias,_aArqs)
Local _nN
// Tipo 1 = GetArea()
If _nTipo == 1
	_aArea   := GetArea()
	For _nN  := 1 To Len(_aArqs)
		DbSelectArea(_aArqs[_nN])
		AAdd(_aAlias,{ Alias(), IndexOrd(), Recno()})
	Next
	// Tipo 2 = RestArea()
Else
	For _nN := 1 To Len(_aAlias)
		DbSelectArea(_aAlias[_nN,1])
		DbSetOrder(_aAlias[_nN,2])
		DbGoto(_aAlias[_nN,3])
	Next
	RestArea(_aArea)
Endif
Return Nil

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   � NwFieldPos � Autor � Ricardo Mansano       � Data �06/09/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Retorna numero da coluna onde se encontra o Campo na         ���
���           � NewGetDados                                                  ���
����������������������������������������������������������������������������Ĵ��
���Parametros � oObjeto := Objeto da NewGetDados                             ���
���           � cCampo  := Nome do Campo a ser localizado                    ���
����������������������������������������������������������������������������Ĵ��
���Retorno    � Numero da coluna localizada pelo aScan                       ���
���           � OBS: Se retornar Zero significa que nao localizou o Registro ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function NwFieldPos(oObjeto,cCampo)
Local nCol := aScan(oObjeto:aHeader,{|x| AllTrim(x[2]) == Upper(cCampo)})
Return(nCol)

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   � NwFieldGet � Autor � Ricardo Mansano       � Data �06/09/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Retorna Valor da Celula da NewGetDados                       ���
����������������������������������������������������������������������������Ĵ��
���Parametros � oObjeto := Objeto da NewGetDados                             ���
���           � cCampo  := Nome do Campo a ser localizado                    ���
���           � nLinha  := Linha da GetDados, caso o parametro nao seja      ���
���           �            preenchido o Default sera o nAt da NewGetDados    ���
����������������������������������������������������������������������������Ĵ��
���Retorno    � xRet := O Valor da Celula independente de seu TYPE           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function NwFieldGet(oObjeto,cCampo,nLinha)
Local nCol := aScan(oObjeto:aHeader,{|x| AllTrim(x[2]) == Upper(cCampo)})
Local xRet
// Se nLinha nao for preenchida Retorna a Posicao de nAt do Objeto
Default nLinha := oObjeto:nAt
xRet := oObjeto:aCols[nLinha,nCol]
Return(xRet)

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   � NwFieldPut � Autor � Ricardo Mansano       � Data �06/09/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Alimenta novo Valor na Celula da NewGetDados                 ���
����������������������������������������������������������������������������Ĵ��
���Parametros � oObjeto := Objeto da NewGetDados                             ���
���           � cCampo  := Nome do Campo a ser localizado                    ���
���           � nLinha  := Linha da GetDados, caso o parametro nao seja      ���
���           �            preenchido o Default sera o nAt da NewGetDados    ���
���           � xNewValue := Valor a ser inputado na Celula.                 ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function NwFieldPut(oObjeto,cCampo,nLinha,xNewValue)
Local nCol := aScan(oObjeto:aHeader,{|x| AllTrim(x[2]) == Upper(cCampo)})
// Se nLinha nao for preenchida Retorna a Posicao de nAt do Objeto
Default nLinha := oObjeto:nAt
// Alimenta Celula com novo Valor se este foi preenchido
If !Empty(xNewValue)
	oObjeto:aCols[nLinha,nCol] := xNewValue
Endif
Return Nil

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   � NwDeleted  � Autor � Ricardo Mansano       � Data �06/09/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Verifica se a linha da NewGetDados esta Deletada.            ���
����������������������������������������������������������������������������Ĵ��                                                       
���Parametros � oObjeto := Objeto da NewGetDados                             ���
���           � nLinha  := Linha da GetDados, caso o parametro nao seja      ���
���           �            preenchido o Default sera o nAt da NewGetDados    ���
����������������������������������������������������������������������������Ĵ��
���Retorno    � lRet := True = Linha Deletada / False = Nao Deletada         ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function NwDeleted(oObjeto,nLinha)
Local nCol := Len(oObjeto:aCols[1])
Local lRet := .T.
// Se nLinha nao for preenchida Retorna a Posicao de nAt do Objeto
Default nLinha := oObjeto:nAt
// Alimenta Celula com novo Valor
lRet := oObjeto:aCols[nLinha,nCol]
Return(lRet)
