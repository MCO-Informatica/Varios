#Include 'Protheus.ch'

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa:  �MA30ROTA   �Autor: �Armando                �Data: �22/04/2010 ���
����������������������������������������������������������������������������͹��
���Descricao: �Ponto de entrada utilizado para trocar as funoes de alteracao ��� 
���           �e exclusao no menu do sistema.Montagem da tela para realizar  ���
���           �a alteracao no grupo de venda.                                ���
����������������������������������������������������������������������������͹��
���Uso:       �Certisign - Certificadora Digital.                            ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
User Function MA030ROT()

	Local nI		 := 0
	Local aRotAux	 := {}

	For nI := 1 To Len(aRotina)
		Do Case
			Case ValType(aRotina[nI][2]) == "C" .AND. AllTrim(Upper(aRotina[nI][2])) == "A030ALTERA"
				Aadd( aRotAux, {aRotina[nI][1], "U_XA030ALTERA", aRotina[nI][3], aRotina[nI][4], aRotina[nI][5], aRotina[nI][6]} )
			Case ValType(aRotina[nI][2]) == "C" .AND. AllTrim(Upper(aRotina[nI][2])) == "A030DELETA"
				Aadd( aRotAux, {aRotina[nI][1], "U_XA030DELETA", aRotina[nI][3], aRotina[nI][4], aRotina[nI][5], aRotina[nI][6]} )
			OtherWise
				Aadd( aRotAux, {aRotina[nI][1], aRotina[nI][2], aRotina[nI][3], aRotina[nI][4], aRotina[nI][5], aRotina[nI][6]} )
		Endcase
	Next nI
	
	//-- Adicionando o novo botao no menu.
	AAdd( aRotAux, { "Alt.Grp.Vend.", "u_MA30ROTA", 2, 0 } )
	
	aRotina := Aclone( aRotAux )

Return(.T.)


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa:  �XA030ALTERA�Autor: �Armando                �Data: �22/04/2010 ���
����������������������������������������������������������������������������͹��
���Descricao: �Esta funcao controla a alteracao do cliente conforme          ��� 
���           �disponibilidade de acesso compartilhado com as funcoes de     ���
���           �integracao com o GAR.                                         ���
����������������������������������������������������������������������������͹��
���Uso:       �Certisign - Certificadora Digital.                            ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
User Function XA030ALTERA(cAlias,nReg,nOpc)

If !U_GarCliLock(SA1->A1_COD)
	MsgStop("Cliente em manutencao pela integra��o GAR n�o est� dispon�vel para esta opera��o...")
	Return(.F.)
Endif

A030ALTERA(cAlias,nReg,nOpc)

U_GarCliUnLock(SA1->A1_COD)

Return(.T.)


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa:  �XA030DELETA�Autor: �Armando                �Data: �22/04/2010 ���
����������������������������������������������������������������������������͹��
���Descricao: �Esta funcao controla a exclusao do cliente conforme           ��� 
���           �disponibilidade de acesso compartilhado com as funcoes de     ���
���           �integracao com o GAR.                                         ���
����������������������������������������������������������������������������͹��
���Uso:       �Certisign - Certificadora Digital.                            ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
User Function XA030DELETA(cAlias,nReg,nOpc)

If !U_GarCliLock(SA1->A1_COD)
	MsgStop("Cliente em manutencao pela integra��o GAR n�o est� dispon�vel para esta opera��o...")
	Return(.F.)
Endif

A030DELETA(cAlias,nReg,nOpc)

U_GarCliUnLock(SA1->A1_COD)

Return(.T.)


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa:  �MA30ROTA   �Autor: �David Alves dos Santos �Data: �14/12/2016 ���
����������������������������������������������������������������������������͹��
���Descricao: �Montagem da tela para realizar a alteracao no grupo de venda. ���
����������������������������������������������������������������������������͹��
���Uso:       �Certisign - Certificadora Digital.                            ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
User Function MA30ROTA()

	Local oGetCod
	Local oGetLoj
	Local oGetNom
	Local oGetGVe
	Local oGetNGV
	Local oGroup
	Local oSayCod
	Local oSayLoj
	Local oSayNom
	Local oSayGve
	Local oSayNGV
	Local oBtnSave
	Local oBtnCanc
	
	Local cGetCod := SA1->A1_COD
	Local cGetLoj := SA1->A1_LOJA
	Local cGetNom := SA1->A1_NOME
	Local cGetGVe := SA1->A1_GRPVEN
	Local cGetNGV := Space(Len(SA1->A1_GRPVEN))
	
	
	Static oDlg
	
	//-- Montagem da tela de alteracao do A1_GRPVEN.
  	DEFINE MSDIALOG oDlg TITLE "Altera��o Grupo de Venda" FROM 000, 000  TO 220, 500 PIXEL
		
		//-- Grupo.
		@ 007, 006 GROUP oGroup TO 081, 244 PROMPT " Informa��es do Cliente: " OF oDlg PIXEL
		
		//-- Rotulos.
		@ 021, 012 SAY oSayCod PROMPT "Codigo"           SIZE 025, 007 OF oDlg PIXEL
		@ 021, 161 SAY oSayLoj PROMPT "Loja"             SIZE 025, 007 OF oDlg PIXEL
		@ 041, 012 SAY oSayNom PROMPT "Nome"             SIZE 025, 007 OF oDlg PIXEL
		@ 060, 012 SAY oSayGve PROMPT "Grp. Venda Atual" SIZE 047, 007 OF oDlg PIXEL
		@ 060, 130 SAY oSayNGV PROMPT "Novo Grp. Venda"  SIZE 050, 007 OF oDlg PIXEL
		
		//-- Campos.    
		@ 020, 036 MSGET oGetCod VAR cGetCod SIZE 060, 010 OF oDlg WHEN .F.   PIXEL
		@ 020, 175 MSGET oGetLoj VAR cGetLoj SIZE 060, 010 OF oDlg WHEN .F.   PIXEL
		@ 039, 035 MSGET oGetNom VAR cGetNom SIZE 200, 010 OF oDlg WHEN .F.   PIXEL
		@ 058, 056 MSGET oGetGVe VAR cGetGVe SIZE 060, 010 OF oDlg WHEN .F.   PIXEL
		@ 058, 175 MSGET oGetNGV VAR cGetNGV SIZE 060, 010 OF oDlg F3 ("ACY") PIXEL
		
		//-- Botoes.
		DEFINE SBUTTON oBtnSave FROM 090, 175 TYPE 13 OF oDlg ACTION {|| cGetGVe := AltGrpVen(cGetNGV)} ENABLE
		DEFINE SBUTTON oBtnCanc FROM 090, 217 TYPE 02 OF oDlg ACTION {|| oDlg:End()} ENABLE

	ACTIVATE MSDIALOG oDlg CENTERED

Return


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa:  �AltGrpVen  �Autor: �David Alves dos Santos �Data: �14/12/2016 ���
����������������������������������������������������������������������������͹��
���Descricao: �Alteracao do campo grupo de venda.                            ���
����������������������������������������������������������������������������͹��
���Parametros:�cGrpVen...: Codigo do novo grupo de venda.                    ���
����������������������������������������������������������������������������͹��
���Uso:       �Certisign - Certificadora Digital.                            ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function AltGrpVen(cGrpven)

	Local cQuery := ""

	//-- Realiza a alteracao do registro posicionado.
	RecLock("SA1")
		SA1->A1_GRPVEN := cGrpven
	SA1->(MsUnLock())

	//-- Informa o usuario que foi alterado com sucesso.
	MsgInfo("Grupo de vendas atualizado com sucesso!")

Return( cGrpven )


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa:  �IniDesGV   �Autor: �David Alves dos Santos �Data: �16/12/2016 ���
����������������������������������������������������������������������������͹��
���Descricao: �Funcao para retornar a descricao do grupo de venda do cliente.���
����������������������������������������������������������������������������͹��
���Parametros:�cCodLoj...: Codigo e loja do cliente.                         ���
����������������������������������������������������������������������������͹��
���Uso:       �Certisign - Certificadora Digital.                            ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
User Function IniDesGV(cCodLoj)
	
	Local cRetorno := ""
	Local cGrpVen  := ""
	
	cGrpVen  := POSICIONE( "SA1" ,1 ,XFILIAL("SA1") + cCodLoj ,"A1_GRPVEN"  )
	cRetorno := POSICIONE( "ACY" ,1 ,XFILIAL("ACY") + cGrpVen ,"ACY_DESCRI" )

Return( cRetorno )


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa:  �Upd30ROT   �Autor: �David Alves dos Santos �Data: �16/12/2016 ���
����������������������������������������������������������������������������͹��
���Descricao: �Update para criacao de campos do processo de grupo de venda.  ���
����������������������������������������������������������������������������͹��
���Uso:       �Certisign - Certificadora Digital.                            ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
User Function Upd30ROT()
	Local cModulo := 'FAT'
	Local bPrepar := {|| u_P030ROT() }
	Local nVersao := 01
	
	NGCriaUpd(cModulo,bPrepar,nVersao)
Return


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa:  �P030ROT    �Autor: �David Alves dos Santos �Data: �16/12/2016 ���
����������������������������������������������������������������������������͹��
���Descricao: �Preparacao para o update.                                     ���
����������������������������������������������������������������������������͹��
���Uso:       �Certisign - Certificadora Digital.                            ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
User Function P030ROT()
	
	aSX3  := {}
	aSX7  := {}
	aHelp := {}
	
	//-- Criacao dos campos.
	AAdd( aSX3 ,{ "AD1" ,"62" ,"AD1_XGRPVE" ,"C" ,6  ,0 ,"Grp.Vendas" ,"Grp.Vendas" ,"Grp.Vendas" ,"Grupo de Vendas"          ,"Grupo de Vendas"          ,"Grupo de Vendas"          ,"@!" ,"" ,"���������������" ,'IF( !INCLUI, POSICIONE( "SA1", 1, XFILIAL("SA1") + M->AD1_CODCLI + M->AD1_LOJCLI, "A1_GRPVEN" ), "" )' ,"ACY" ,0 ,"��" ,"" ,"" ,"U" ,"S" ,"V" ,"V" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,'POSICIONE( "SA1",1, XFILIAL("SA1")+AD1->AD1_CODCLI+AD1->AD1_LOJCLI, "A1_GRPVEN")' ,"" ,"1" ,"" ,"" ,"" ,"" ,"N" ,"N" ,"" ,"" } )
	AAdd( aSX3 ,{ "AD1" ,"63" ,"AD1_XDESGV" ,"C" ,30 ,0 ,"Desc. Gv."  ,"Desc. Gv."  ,"Desc. Gv."  ,"Descricao Grupo de Venda" ,"Descricao Grupo de Venda" ,"Descricao Grupo de Venda" ,"@!" ,"" ,"��������������"  ,'IF( !INCLUI, U_INIDESGV(AD1->AD1_CODCLI+AD1->AD1_LOJCLI), "" )'                                        ,""    ,0 ,"��" ,"" ,"" ,"U" ,"S" ,"V" ,"V" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"u_IniDesGV(AD1->AD1_CODCLI+AD1->AD1_LOJCLI)"                                      ,"" ,"1" ,"" ,"" ,"" ,"" ,"N" ,"N" ,"" ,"" } )
	
	//-- Criacao dos helps.
	AAdd( aHelp ,{ "AD1_XGRPVE" ,"C�digo do grupo de venda do cliente."   } )
	AAdd( aHelp ,{ "AD1_XDESGV" ,"Descri��o do grupo de venda do cliente" } )
	
	//-- Criacao dos Gatilhos.
	AAdd( aSX7 ,{ "AD1_CODCLI" ,"009" ,"SA1->A1_GRPVEN"                                                       ,"AD1_XGRPVE" ,"P" ,"N" ,"" ,0 ,"" ,"" ,"U" } )
	AAdd( aSX7 ,{ "AD1_CODCLI" ,"010" ,'POSICIONE( "ACY", 1, XFILIAL("ACY") + SA1->A1_GRPVEN, "ACY_DESCRI" )' ,"AD1_XDESGV" ,"P" ,"N" ,"" ,0 ,"" ,"" ,"U" } )
	
Return
