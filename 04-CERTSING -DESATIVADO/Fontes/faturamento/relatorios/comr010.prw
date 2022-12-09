#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �COMR010   �Autor  �Armando M. Tessaroli� Data �  25/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Emissao dos valores apurados nos lancamentos para pagamento ���
���          �de comissao.                                                ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function COMR010()

//��������������������������������������������������������������Ŀ
//�             Define Variaveis                                 �
//����������������������������������������������������������������
Local wnrel   	:= "COMR010"			// Nome do Arquivo utilizado no Spool
Local Titulo 	:= "PREVISAO das comissoes a pagar"
Local cDesc1 	:= "Emite uma relacao das previsoes dos valores de comissao a pagar com base nos lan�amentos em aberto."
Local cDesc2 	:= ""
Local cDesc3 	:= "A emiss�o ocorrer� baseada nos par�metros do relat�rio"
Local nomeprog	:= "COMR010.PRW"		// Nome do programa
Local cString 	:= "SZ6"				// Alias utilizado na Filtragem
Local lDic    	:= .F.					// Habilita/Desabilita Dicionario
Local lComp   	:= .F.					// Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro 	:= .F.					// Habilita/Desabilita o Filtro

Private Tamanho := "M"					// P/M/G
Private Limite  := 132					// 80/132/220
Private aReturn := { "Zebrado",;		// [1] Reservado para Formulario
					 1,;				// [2] Reservado para N� de Vias
					 "Administrador",;	// [3] Destinatario
					 2,;				// [4] Formato => 1-Comprimido 2-Normal	
					 1,;	    		// [5] Midia   => 1-Disco 2-Impressora
					 1,;				// [6] Porta ou Arquivo 1-LPT1... 4-COM1...
					 "",;				// [7] Expressao do Filtro
					 1 } 				// [8] Ordem a ser selecionada
					 					// [9]..[10]..[n] Campos a Processar (se houver)
Private m_pag   := 1					// Contador de Paginas
Private nLastKey:= 0					// Controla o cancelamento da SetPrint e SetDefault
Private cPerg   := "COMS10"				// Pergunta do Relatorio
Private aOrdem  := {}					// Ordem do Relatorio

AjustaSX1(cPerg)
Pergunte(cPerg, .F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)

If (nLastKey == 27)
	DbSelectArea(cString)
	DbSetOrder(1)
	DbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If (nLastKey == 27)
	DbSelectArea(cString)
	DbSetOrder(1)
	DbClearFilter()
	Return
Endif

Processa( { |lEnd| ImpRCom(@lEnd,wnRel,cString,nomeprog,Titulo) } )

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpRCom   �Autor  �Armando M. Tessaroli� Data �  25/10/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de impressao dos dados.                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Aromatica                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpRCom(lEnd,wnrel,cString,nomeprog,Titulo)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao Do Cabecalho e Rodape    �
//����������������������������������������������������������������
Local nLi		:= 0			// Linha a ser impressa
Local nMax		:= 58			// Maximo de linhas suportada pelo relatorio
Local cbCont	:= 0			// Numero de Registros Processados
Local cbText	:= SPACE(10)	// Mensagem do Rodape
Local cCabec1	:= "Entida  Nome da Entidade"			// Label dos itens
Local cCabec2	:= "     Produto     Descricao do Produto                       Qtdade     SFT Bruto  SFT Impost  SFW Liquid     HRD Bruto  HRD Impost  HRD Liquid    Val Comiss" 			// Label dos itens

//�������������������������������������������������������Ŀ
//�Declaracao de variaveis especificas para este relatorio�
//���������������������������������������������������������
Local cQuery	:= ""			// Armazena a expressao da query para top
Local nQtd		:= 0
Local aStruct	:= {}
Local cNome		:= ""
Local cCatSFW	:= "('" + StrTran(GetNewPar("MV_GARSFT", "2"),",","','") + "')"
Local cCatHRD	:= "('" + StrTran(GetNewPar("MV_GARHRD", "1"),",","','") + "')"
Local cCodEnt	:= ""
Local cBruSfw	:= 0
Local cImpSfw	:= 0
Local cLiqSfw	:= 0
Local cBruHrd	:= 0
Local cImpHrd	:= 0
Local cLiqHrd	:= 0
Local cValCom	:= 0
Local nTotRec	:= 0
Local lSomaProd := .T.
Local cPedGar	:= ""

If Mv_Par06 == 1
	Tamanho := "G"					// P/M/G
	Limite  := 220					// 80/132/220
	cCabec2	:= "     Posto       Nome do Posto                   Nome do Agente                  Produto     Descricao do Produto            Pedido  Dat.Ped.  Emissao   Nome do Agente             Valor Soft  Valor Hard    Comissao" 			// Label dos itens
Endif

Aadd( aStruct, { "Z6_CODENT",	"C", 006, 0 } )
Aadd( aStruct, { "Z6_PROGAR",	"C", 020, 0 } )
Aadd( aStruct, { "Z6_PEDGAR",	"C", 010, 0 } )
Aadd( aStruct, { "Z6_DESPRO",	"C", 100, 0 } )
Aadd( aStruct, { "Z6_QTDVAL",	"N", 012, 0 } )
Aadd( aStruct, { "Z6_BRUSFW",	"N", 012, 2 } )
Aadd( aStruct, { "Z6_IMPSFW",	"N", 012, 2 } )
Aadd( aStruct, { "Z6_LIQSFW",	"N", 012, 2 } )
Aadd( aStruct, { "Z6_BRUHRD",	"N", 012, 2 } )
Aadd( aStruct, { "Z6_IMPHRD",	"N", 012, 2 } )
Aadd( aStruct, { "Z6_LIQHRD",	"N", 012, 2 } )
Aadd( aStruct, { "Z6_VALCOM",	"N", 012, 2 } )
Aadd( aStruct, { "Z5_CODPOS",	"C", 020, 0 } )
Aadd( aStruct, { "Z5_DESPOS",	"C", 100, 0 } )
Aadd( aStruct, { "Z5_NOMAGE",	"C", 100, 0 } )
Aadd( aStruct, { "Z5_DATPED",	"D", 008, 0 } )
Aadd( aStruct, { "Z5_EMISSAO",	"D", 008, 0 } )
Aadd( aStruct, { "A1_NOME",		"C", 060, 0 } )

cNome := CriaTrab(aStruct)
DbUseArea(.t.,,cNome,"SZ6TMP",.F.,.F.)
IndRegua("SZ6TMP",cNome+"1","Z6_CODENT+Z6_PROGAR",,,"Indexando")
IndRegua("SZ6TMP",cNome+"2","Z6_CODENT+Z6_PROGAR+Z6_PEDGAR",,,"Indexando")

//�������������������������������������������������������������������Ŀ
//�Pesquisa se existe o fechamento solicitado e o fechamento anterior.�
//���������������������������������������������������������������������
cQuery :=	" SELECT   COUNT(*) TOTREC " +;
			" FROM    " + RetSqlName("SZ5") + " SZ5, " + RetSqlName("SZ6") + " SZ6, " + RetSqlName("SZ3") + " SZ3 " +;
			" WHERE   SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' AND " +;
			"         SZ5.Z5_COMISS = '2' AND " +;
			"         SUBSTR(SZ5.Z5_DATVAL,1,6) = '" + Mv_Par01 + "' AND " +;
			"         SZ5.D_E_L_E_T_ = ' ' AND " +;
			"         SZ6.Z6_FILIAL = '" + xFilial("SZ6") + "' AND " +;
			"         SZ6.Z6_PEDGAR = SZ5.Z5_PEDGAR AND " +;
			"         SZ6.Z6_VALCOM <> 0 AND "

If !Empty(Mv_Par02)
	cQuery +=	"     SZ6.Z6_CODENT = '" + Mv_Par02 + "' AND "
Endif

cQuery +=	"         SZ6.D_E_L_E_T_ = ' ' AND " +;
			"         SZ3.Z3_FILIAL = '" + xFilial("SZ3") + "' AND " +;
			"         SZ3.Z3_CODENT = SZ6.Z6_CODENT AND "

If !Empty(Mv_Par03)
	cQuery +=	"     SZ3.Z3_CLASSI = '" + Mv_Par03 + "' AND "
Endif

If !Empty(Mv_Par05)
	cQuery +=	"     TRIM(SZ3.Z3_TIPENT) IN ('" + StrTran(Mv_Par05,",","','") + "') AND "
Endif

cQuery +=	"         SZ3.D_E_L_E_T_ = ' ' "

PLSQuery( cQuery, "SZ5TMP" )

nTotRec := SZ5TMP->TOTREC

SZ5TMP->( DbCloseArea() )

cQuery :=	" SELECT  Z5_PRODUTO, Z6_CODENT, Z5_CNPJ, Z6_CODENT, Z5_PEDGAR, Z5_CODPOS, Z5_DESPOS, " +;
			"         Z5_NOMAGE, Z5_DATPED, Z5_EMISSAO, Z6_VALCOM, Z6_CATPROD, Z6_VLRPROD, Z6_BASECOM " +;
			" FROM    " + RetSqlName("SZ5") + " SZ5, " + RetSqlName("SZ6") + " SZ6, " + RetSqlName("SZ3") + " SZ3 " +;
			" WHERE   SZ5.Z5_FILIAL = '" + xFilial("SZ5") + "' AND " +;
			"         SZ5.Z5_COMISS = '2' AND " +;
			"         SUBSTR(SZ5.Z5_DATVAL,1,6) = '" + Mv_Par01 + "' AND " +;
			"         SZ5.D_E_L_E_T_ = ' ' AND " +;
			"         SZ6.Z6_FILIAL = '" + xFilial("SZ6") + "' AND " +;
			"         SZ6.Z6_PEDGAR = SZ5.Z5_PEDGAR AND " +;
			"         SZ6.Z6_VALCOM <> 0 AND "

If !Empty(Mv_Par02)
	cQuery +=	"     SZ6.Z6_CODENT = '" + Mv_Par02 + "' AND "
Endif

cQuery +=	"         SZ6.D_E_L_E_T_ = ' ' AND " +;
			"         SZ3.Z3_FILIAL = '" + xFilial("SZ3") + "' AND " +;
			"         SZ3.Z3_CODENT = SZ6.Z6_CODENT AND "

If !Empty(Mv_Par03)
	cQuery +=	"     SZ3.Z3_CLASSI = '" + Mv_Par03 + "' AND "
Endif

If !Empty(Mv_Par05)
	cQuery +=	"     TRIM(SZ3.Z3_TIPENT) IN ('" + StrTran(Mv_Par05,",","','") + "') AND "
Endif

cQuery +=	"         SZ3.D_E_L_E_T_ = ' ' " +;
			" ORDER BY Z5_PEDGAR "

PLSQuery( cQuery, "SZ5TMP" )

ProcRegua( nTotRec )

While SZ5TMP->( !Eof() )
	
	nQtd++
	IncProc("Gerando " + AllTrim(Str(nQtd)) + " de " + AllTrim(Str(nTotRec)) )
	ProcessMessage()
	
	If lEnd
		@Prow()+1,000 PSay "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
//	SZ5->( DbGoTo( SZ5TMP->R_E_C_N_O_ ) )
	
	//��������������������������������������������������������������Ŀ
	//� Considera filtro do usuario                                  �
	//����������������������������������������������������������������
//	If (!Empty(aReturn[7])) .AND. (!&(aReturn[7]))
//		SZ5TMP->( DbSkip() )
//		Loop
//	Endif
	
	If cPedGar <> SZ5TMP->Z5_PEDGAR
		lSomaProd := .T.
		cPedGar := SZ5TMP->Z5_PEDGAR
	Endif
	
	If Mv_Par06 == 1	// Analitico
		SZ6TMP->( DbSetIndex(cNome+"2") )
		If SZ6TMP->( !MsSeek( SZ5TMP->Z6_CODENT+Padr(SZ5TMP->Z5_PRODUTO,10)+Padr(SZ5TMP->Z5_PEDGAR,10) ) )
			
			PA8->( DbSetOrder(1) )		// PA8_FILIAL + PA8_CODBPG
			PA8->( MsSeek( xFilial("PA8")+SZ5TMP->Z5_PRODUTO ) )
			
			SA1->( DbSetOrder(3) )		// A1_FILIAL+A1_CGC
			SA1->( MsSeek( xFilial("SA1")+U_CSFMTSA1(SZ5TMP->Z5_CNPJ) ) )
			
			SZ6TMP->( RecLock("SZ6TMP",.T.) )
			SZ6TMP->Z6_CODENT	:= SZ5TMP->Z6_CODENT
			SZ6TMP->Z6_PROGAR	:= SZ5TMP->Z5_PRODUTO
			SZ6TMP->Z6_PEDGAR	:= SZ5TMP->Z5_PEDGAR
			SZ6TMP->Z6_DESPRO	:= Upper(PA8->PA8_DESBPG)
			SZ6TMP->Z5_CODPOS	:= SZ5TMP->Z5_CODPOS
			SZ6TMP->Z5_DESPOS	:= SZ5TMP->Z5_DESPOS
			SZ6TMP->Z5_NOMAGE	:= SZ5TMP->Z5_NOMAGE
			SZ6TMP->Z5_DATPED	:= SZ5TMP->Z5_DATPED
			SZ6TMP->Z5_EMISSAO	:= SZ5TMP->Z5_EMISSAO
			SZ6TMP->A1_NOME		:= SA1->A1_NOME
		Else
			SZ6TMP->( RecLock("SZ6TMP",.F.) )
		Endif
	Else				// Sintetico
		SZ6TMP->( DbSetIndex(cNome+"1") )
		If SZ6TMP->( !MsSeek( SZ5TMP->Z6_CODENT+PadR(SZ5TMP->Z5_PRODUTO,10) ) )
			
			PA8->( DbSetOrder(1) )		// PA8_FILIAL + PA8_CODBPG
			PA8->( MsSeek( xFilial("PA8")+SZ5TMP->Z5_PRODUTO ) )
			
			SZ6TMP->( RecLock("SZ6TMP",.T.) )
			SZ6TMP->Z6_CODENT	:= SZ5TMP->Z6_CODENT
			SZ6TMP->Z6_PROGAR	:= SZ5TMP->Z5_PRODUTO
			SZ6TMP->Z6_DESPRO	:= Upper(PA8->PA8_DESBPG)
		Else
			SZ6TMP->( RecLock("SZ6TMP",.F.) )
		Endif
	Endif
	
	If lSomaProd
		SZ6TMP->Z6_QTDVAL ++
		lSomaProd := .F.
	Endif
	
	SZ6TMP->Z6_VALCOM += SZ5TMP->Z6_VALCOM
	
	If SZ5TMP->Z6_CATPROD $ cCatSFW
		SZ6TMP->Z6_BRUSFW += SZ5TMP->Z6_VLRPROD
		SZ6TMP->Z6_IMPSFW += SZ5TMP->Z6_VLRPROD-SZ5TMP->Z6_BASECOM
		SZ6TMP->Z6_LIQSFW += SZ5TMP->Z6_BASECOM
	Endif
	
	If SZ5TMP->Z6_CATPROD $ cCatHrd
		SZ6TMP->Z6_BRUHRD += SZ5TMP->Z6_VLRPROD
		SZ6TMP->Z6_IMPHRD += SZ5TMP->Z6_VLRPROD-SZ5TMP->Z6_BASECOM
		SZ6TMP->Z6_LIQHRD += SZ5TMP->Z6_BASECOM
	Endif
	
	SZ6TMP->( MsUnLock() )

	SZ5TMP->( DbSkip() )
End
SZ5TMP->( DbCloseArea() )

nTotRec := SZ6TMP->( RecCount() )
ProcRegua( nTotRec )
nQtd := 0

SZ6TMP->( DbGoTop() )
While SZ6TMP->( !Eof() )
	
	nQtd++
	IncProc("Imprimindo " + AllTrim(Str(nQtd)) + " de " + AllTrim(Str(nTotRec)) )
	ProcessMessage()
	
	If lEnd
		@Prow()+1,000 PSay "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	If cCodEnt <> SZ6TMP->Z6_CODENT
		SZ3->( DbSetOrder(1) )
		SZ3->( MsSeek( xFilial("SZ3")+SZ6TMP->Z6_CODENT ) )
		If Mv_Par04 == 1
			TkIncLine(@nLi,nMax+1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		Else
			TkIncLine(@nLi,3,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		Endif
		@ nLi,000		PSay SZ6TMP->Z6_CODENT
		@ nLi,PCol()+2	PSay Upper(SZ3->Z3_DESENT)
		cCodEnt := SZ6TMP->Z6_CODENT
	Endif
	
	TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	If Mv_Par06 == 1	// Analitico
		@ nLi,005		PSay PadR(SZ6TMP->Z5_CODPOS,5)
		@ nLi,PCol()+2	PSay PadR(Upper(SZ6TMP->Z5_DESPOS),30)
		@ nLi,PCol()+2	PSay PadR(Upper(SZ6TMP->Z5_NOMAGE),25)
		@ nLi,PCol()+2	PSay SZ6TMP->Z6_PROGAR
		@ nLi,PCol()+2	PSay PadR(SZ6TMP->Z6_DESPRO,30)
		@ nLi,PCol()+2	PSay PadR(SZ6TMP->Z6_PEDGAR,6)
		@ nLi,PCol()+2	PSay SZ6TMP->Z5_DATPED
		@ nLi,PCol()+2	PSay SZ6TMP->Z5_EMISSAO
		@ nLi,PCol()+2	PSay PadR(SZ6TMP->A1_NOME,25)
		@ nLi,PCol()+2	PSay SZ6TMP->Z6_LIQSFW Picture("@E 999,999.99")
		@ nLi,PCol()+2	PSay SZ6TMP->Z6_LIQHRD Picture("@E 999,999.99")
		@ nLi,PCol()+2	PSay SZ6TMP->Z6_VALCOM Picture("@E 999,999.99")
	Else
		@ nLi,005		PSay SZ6TMP->Z6_PROGAR
		@ nLi,PCol()+2	PSay PadR(SZ6TMP->Z6_DESPRO,40)
		@ nLi,PCol()+2	PSay SZ6TMP->Z6_QTDVAL Picture("@E 999,999")
		@ nLi,PCol()+4	PSay SZ6TMP->Z6_BRUSFW Picture("@E 999,999.99")
		@ nLi,PCol()+2	PSay SZ6TMP->Z6_IMPSFW Picture("@E 999,999.99")
		@ nLi,PCol()+2	PSay SZ6TMP->Z6_LIQSFW Picture("@E 999,999.99")
		@ nLi,PCol()+4	PSay SZ6TMP->Z6_BRUHRD Picture("@E 999,999.99")
		@ nLi,PCol()+2	PSay SZ6TMP->Z6_IMPHRD Picture("@E 999,999.99")
		@ nLi,PCol()+2	PSay SZ6TMP->Z6_LIQHRD Picture("@E 999,999.99")
		@ nLi,PCol()+4	PSay SZ6TMP->Z6_VALCOM Picture("@E 999,999.99")
	Endif
	
	cBruSfw += SZ6TMP->Z6_BRUSFW
	cImpSfw += SZ6TMP->Z6_IMPSFW
	cLiqSfw += SZ6TMP->Z6_LIQSFW
	cBruHrd += SZ6TMP->Z6_BRUHRD
	cImpHrd += SZ6TMP->Z6_IMPHRD
	cLiqHrd += SZ6TMP->Z6_LIQHRD
	cValCom += SZ6TMP->Z6_VALCOM
	
	SZ6TMP->( DbSkip() )
	
	If cCodEnt <> SZ6TMP->Z6_CODENT
		TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
		@ nLi,005		PSay PadR("Sub total da entidade",63)
		@ nLi,PCol()+2	PSay cBruSfw Picture("@E 999,999.99")
		@ nLi,PCol()+2	PSay cImpSfw Picture("@E 999,999.99")
		@ nLi,PCol()+2	PSay cLiqSfw Picture("@E 999,999.99")
		@ nLi,PCol()+4	PSay cBruHrd Picture("@E 999,999.99")
		@ nLi,PCol()+2	PSay cImpHrd Picture("@E 999,999.99")
		@ nLi,PCol()+2	PSay cLiqHrd Picture("@E 999,999.99")
		@ nLi,PCol()+4	PSay cValCom Picture("@E 999,999.99")
		cBruSfw := 0
		cImpSfw := 0
		cLiqSfw := 0
		cBruHrd := 0
		cImpHrd := 0
		cLiqHrd := 0
		cValCom := 0
	Endif
	
End
SZ6TMP->( DbCloseArea() )

If nLi == 0
	TkIncLine(@nLi,1,nMax,titulo,cCabec1,cCabec2,nomeprog,tamanho)
	@ nLi+1,000 PSay "N�o h� informa��es para imprimir este relat�rio"
Endif

Roda(cbCont,cbText,Tamanho)

Set Device To Screen
If ( aReturn[5] = 1 )
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AJUSTASX1 �Autor  �Armando M. Tessaroli� Data �  31/07/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria o pergunte padrao                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Aromatica                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1(cPerg)

Local aRegs	:=	{}

Aadd(aRegs,{cPerg,"01","Competencia AAAAMM",	"","","MV_CH1","C",06,0,0,"G","","Mv_Par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Entidade",				"","","MV_CH2","C",06,0,0,"G","","Mv_Par02","","","","","","","","","","","","","","","","","","","","","","","","","SZ3_04","","","","",""})
Aadd(aRegs,{cPerg,"03","Grupo",					"","","MV_CH3","C",03,0,0,"G","","Mv_Par03","","","","","","","","","","","","","","","","","","","","","","","","","SZA_01","","","","",""})
Aadd(aRegs,{cPerg,"04","Salta Pagina",			"","","MV_CH4","C",01,0,0,"C","","Mv_Par04","SIM","","","","","NAO","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Entidades? Ex: 1,2,3",	"","","MV_CH5","C",03,0,0,"G","","Mv_Par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Analitico/Sintetico",	"","","MV_CH6","C",01,0,0,"C","","Mv_Par06","Analitico","","","","","Sintetico","","","","","","","","","","","","","","","","","","","","","","","",""})

// 1=Canal;2=AC;3=AR;4=Posto

PlsVldPerg( aRegs )

Return()
