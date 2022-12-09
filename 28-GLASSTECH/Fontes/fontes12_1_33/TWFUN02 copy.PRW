#Include 'Protheus.ch' 
#Include 'FWMVCDef.ch'
#INCLUDE 'totvs.ch'

#DEFINE OP_LIB	"001" // Liberado
#DEFINE OP_EST	"002" // Estornar
#DEFINE OP_SUP	"003" // Superior
#DEFINE OP_TRA	"004" // Transferir Superior
#DEFINE OP_REJ	"005" // Rejeitado
#DEFINE OP_BLQ	"006" // Bloqueio
#DEFINE OP_VIW	"007" // Visualizacao 

/*/{Protheus.doc} TWFUN02
//TODO Relatório de Movimentações Financeiras customizado.
@author Pirolo
@since 16/07/2020
@version undefined
@return return, return_description
/*/
User Function TWFUN02()
Local cFilePrint := "report"

If MsgYesNo("Gerar relatório em formato csv?")
	GeraCsv()
Else
	oPrint := FwMSPrinter():New(cFilePrint,6,.F.,,.F.,,,,,,,.T.)
	
	If Empty(oPrint:oFileWriter:oErroLog:Message)
		oPrint	:= GeraLinha(oPrint)

		If oPrint <> Nil
			oPrint:EndPage()
			oPrint:Preview()
		EndIf
	EndIf
	
	If Type("oPrint:nHandle") <> 'U'
		FClose(oPrint:nHandle)
	EndIf
	
	FreeObj(oPrint)
EndIf
Return

/*/{Protheus.doc} GeraLinha
//TODO Gera o relatório em FwMsPrinter.
@author Pirolo
@since 16/07/2020
@return return, return_description
/*/
Static Function GeraLinha(oPrint)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaração de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cLogo			:= FisxLogo("1")
Local cCodEmp		:= FWCodEmp()
Local cCodFil		:= FWCodFil()
Local nLin			:= 10
Local nLimPag		:= 700
Local cQry			:= ''

Local oFonte06		:= tFont():New("ARIAL",06,06,,.F.,,,,.T.,.F.)
Local oFonte06N		:= tFont():New("ARIAL",06,06,,.T.,,,,.T.,.F.)
Local oFonte08		:= tFont():New("ARIAL",08,08,,.F.,,,,.T.,.F.)
Local oFonte08N		:= tFont():New("ARIAL",08,08,,.T.,,,,.T.,.F.)
Local oFonte10		:= tFont():New("ARIAL",10,10,,.F.,,,,.T.,.F.)
Local oFonte10N		:= tFont():New("ARIAL",10,10,,.T.,,,,.T.,.F.)
Local oFonte11N		:= tFont():New("ARIAL",11,11,,.T.,,,,.T.,.F.)
Local oFonte12		:= tFont():New("ARIAL",12,12,,.F.,,,,.T.,.F.)
Local oFonte12N		:= tFont():New("ARIAL",12,12,,.T.,,,,.T.,.F.)
Local oFonte13N		:= tFont():New("ARIAL",13,13,,.T.,,,,.T.,.F.)
Local oFonte14		:= tFont():New("ARIAL",14,14,,.F.,,,,.T.,.F.)
Local oFonte14N		:= tFont():New("ARIAL",14,14,,.T.,,,,.T.,.F.)
Local oFonte16		:= tFont():New("ARIAL",16,16,,.F.,,,,.T.,.F.)
Local oFonte16N		:= tFont():New("ARIAL",16,16,,.T.,,,,.T.,.F.)
Local oFonte18		:= tFont():New("ARIAL",18,18,,.F.,,,,.T.,.F.)
Local oFonte18N		:= tFont():New("ARIAL",18,18,,.T.,,,,.T.,.F.)
Local oFonte20		:= tFont():New("ARIAL",20,20,,.F.,,,,.T.,.F.)
Local oFonte20N		:= tFont():New("ARIAL",20,20,,.T.,,,,.T.,.F.)
Local oFonte22		:= tFont():New("ARIAL",22,22,,.F.,,,,.T.,.F.)
Local oFonte22N		:= tFont():New("ARIAL",22,22,,.T.,,,,.T.,.F.)
Local oFonte24		:= tFont():New("ARIAL",24,24,,.F.,,,,.T.,.F.)
Local oFonte24N		:= tFont():New("ARIAL",24,24,,.T.,,,,.T.,.F.)
Local _oFonte06		:= tFont():New("Courier New",06,06,,.F.,,,,.T.,.F.)
Local _oFonte06N	:= tFont():New("Courier New",06,06,,.T.,,,,.T.,.F.)
Local _oFonte08		:= tFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
Local _oFonte08N	:= tFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)
Local _oFonte10		:= tFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
Local _oFonte10N	:= tFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
Local _oFonte12		:= tFont():New("Courier New",12,12,,.F.,,,,.T.,.F.)
Local _oFonte12N	:= tFont():New("Courier New",12,12,,.T.,,,,.T.,.F.)
Local _oFonte14		:= tFont():New("Courier New",14,14,,.F.,,,,.T.,.F.)
Local _oFonte14N	:= tFont():New("Courier New",14,14,,.T.,,,,.T.,.F.)
Local _oFonte16		:= tFont():New("Courier New",16,16,,.F.,,,,.T.,.F.)
Local _oFonte16N	:= tFont():New("Courier New",16,16,,.T.,,,,.T.,.F.)

cQry := PegaQry()

If Empty(cQry)
	Return Nil
Endif

DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQry),'QRY',.T.,.T.)
DbSelectArea('QRY')
DbGoTop()

While QRY->(!EOF())

	If nLin >= nLimPag .OR. nLin == 10//540
		If nLin > 10
			oPrint:EndPage()
		EndIf
		
		nLin := 0120 //nLinCab //Melhor aproveitamento da segunda pagina em diante
		oPrint:StartPage()
		oPrint:Say(0060,0210,OemToAnsi("Relatório de Movimentações Financeiras"),oFonte20N)
		oPrint:SayBitmap(0000,0010,cLogo)
		oPrint:Line(nLin+1,0010,nLin+1,0600)
		
		oPrint:Say(nLin, 0010, OemToAnsi("Filial"		),oFonte08)            
		oPrint:Say(nLin, 0030, OemToAnsi("Numero"		),oFonte08)            
		oPrint:Say(nLin, 0075, OemToAnsi("Rec/Pag"		),oFonte08)            
		oPrint:Say(nLin, 0110, OemToAnsi("Prefixo"		),oFonte08)            
		oPrint:Say(nLin, 0140, OemToAnsi("Tipo"			),oFonte08)            
		oPrint:Say(nLin, 0160, OemToAnsi("Cli/For"		),oFonte08)            
		oPrint:Say(nLin, 0190, OemToAnsi("Natureza"		),oFonte08)            
		oPrint:Say(nLin, 0230, OemToAnsi("Historico"	),oFonte08)            
		oPrint:Say(nLin, 0350, OemToAnsi("Data"			),oFonte08)            
		oPrint:Say(nLin, 0390, OemToAnsi("Juros"		),oFonte08)
		oPrint:Say(nLin, 0420, OemToAnsi("Multa"		),oFonte08)
		oPrint:Say(nLin, 0450, OemToAnsi("Desconto"		),oFonte08)
		oPrint:Say(nLin, 0490, OemToAnsi("Valor"		),oFonte08)
		oPrint:Say(nLin, 0520, OemToAnsi("Banco"		),oFonte08)            
		oPrint:Say(nLin, 0550, OemToAnsi("Agencia"		),oFonte08)            
		oPrint:Say(nLin, 0580, OemToAnsi("Conta"		),oFonte08)            

		nLin += 10
	EndIf

	//Detalhe
	oPrint:Say(nLin, 0010, OemToAnsi(Alltrim(QRY->E5_FILIAL   				)),oFonte08)
	oPrint:Say(nLin, 0030, OemToAnsi(Alltrim(QRY->E5_NUMERO   				)),oFonte08)
	oPrint:Say(nLin, 0075, OemToAnsi(Alltrim(QRY->E5_RECPAG   				)),oFonte08)
	oPrint:Say(nLin, 0110, OemToAnsi(Alltrim(QRY->E5_PREFIXO  				)),oFonte08)
	oPrint:Say(nLin, 0140, OemToAnsi(Alltrim(QRY->E5_TIPO     				)),oFonte08)
	oPrint:Say(nLin, 0160, OemToAnsi(Alltrim(QRY->E5_CLIFOR   				)),oFonte08)
	oPrint:Say(nLin, 0190, OemToAnsi(Alltrim(QRY->E5_NATUREZ  				)),oFonte08)
	oPrint:Say(nLin, 0230, OemToAnsi(Alltrim(Substr(QRY->E5_HISTOR, 1,36)   )),oFonte06)
	oPrint:Say(nLin, 0350, OemToAnsi(Alltrim(QRY->E5_DATA     				)),oFonte08)
	oPrint:Say(nLin, 0390, OemToAnsi(Alltrim(cValToChar(QRY->E5_VLJUROS)  	)),oFonte08)
	oPrint:Say(nLin, 0420, OemToAnsi(Alltrim(cValToChar(QRY->E5_VLMULTA)  	)),oFonte08)
	oPrint:Say(nLin, 0450, OemToAnsi(Alltrim(cValToChar(QRY->E5_VLDESCO)  	)),oFonte08)
	oPrint:Say(nLin, 0490, OemToAnsi(Alltrim(cValToChar(QRY->E5_VALOR  )  	)),oFonte08)
	oPrint:Say(nLin, 0520, OemToAnsi(Alltrim(QRY->E5_BANCO    				)),oFonte08)
	oPrint:Say(nLin, 0550, OemToAnsi(Alltrim(QRY->E5_AGENCIA  				)),oFonte08)
	oPrint:Say(nLin, 0580, OemToAnsi(Alltrim(QRY->E5_CONTA    				)),oFonte08)

	nLin += 10
	QRY->(DbSkip())
EndDo

Return oPrint

/*/{Protheus.doc} PegaQry
//TODO Função para centralizar a query em um mesmo local.
@author Pirolo
@since 16/07/2020
@return return, Query para seleção das movimentações financeiras
/*/
Static Function PegaQry()
Local cQry := ""
Local aPergs	:= {}
Local dDataDe	:= FirstDate(Date())
Local dDataAt	:= LastDate(Date())
Local cBanco	:= Space(TAMSX3("A6_COD")[1])
Local cAgencia	:= Space(TAMSX3("A6_AGENCIA")[1])
Local cConta	:= Space(TAMSX3("A6_NUMCON")[1])
 
aAdd(aPergs, {1, "Data De"	,  dDataDe	,  "", ".T.", ""	, ".T.", 80,  .F.})
aAdd(aPergs, {1, "Data Até"	,  dDataAt	,  "", ".T.", ""	, ".T.", 80,  .T.})
aAdd(aPergs, {1, "Banco"	,  cBanco	,  "", ".T.", "SA6"	, ".T.", 80,  .F.})
aAdd(aPergs, {1, "Agencia"	,  cAgencia	,  "", ".T.", ""	, ".T.", 80,  .F.})
aAdd(aPergs, {1, "Conta"	,  cConta	,  "", ".T.", ""	, ".T.", 80,  .F.})

If ParamBox(aPergs, "Informe os parâmetros")

	cQry := "select E5_FILIAL, E5_NUMERO, E5_RECPAG, E5_NUMERO, E5_PREFIXO, E5_TIPO, E5_CLIFOR, E5_NATUREZ, E5_HISTOR, SUBSTRING(E5_DATA,7,2)+'/'+SUBSTRING(E5_DATA,5,2)+'/'+SUBSTRING(E5_DATA,1,4) E5_DATA, E5_VLJUROS, E5_VLMULTA, E5_VLDESCO, E5_VALOR, E5_BANCO, E5_AGENCIA, E5_CONTA,    "+CRLF
	cQry += "       CASE                                                                                                                                                                                                                                                                      "+CRLF
	cQry += "			WHEN E5_RECPAG = 'R' THEN (SELECT TOP 1 SUBSTRING(E1_EMISSAO,7,2)+'/'+SUBSTRING(E1_EMISSAO,5,2)+'/'+SUBSTRING(E1_EMISSAO,1,4) FROM SE1010 WHERE D_E_L_E_T_ = ' ' AND E1_FILIAL = E5_FILIAL AND E1_NUM = E5_NUMERO AND E1_CLIENTE = E5_CLIFOR AND E1_TIPO = E5_TIPO)   "+CRLF
	cQry += "			WHEN E5_RECPAG = 'P' THEN (SELECT TOP 1 SUBSTRING(E2_EMISSAO,7,2)+'/'+SUBSTRING(E2_EMISSAO,5,2)+'/'+SUBSTRING(E2_EMISSAO,1,4) FROM SE2010 WHERE D_E_L_E_T_ = ' ' AND E2_FILIAL = E5_FILIAL AND E2_NUM = E5_NUMERO AND E2_FORNECE = E5_CLIFOR AND E2_TIPO = E5_TIPO)   "+CRLF
	cQry += "		END EMISSAO,                                                                                                                                                                                                                                                              "+CRLF
	cQry += "       CASE                                                                                                                                                                                                                                                                      "+CRLF
	cQry += "			WHEN E5_RECPAG = 'R' THEN (SELECT TOP 1 E1_VALOR FROM SE1010 WHERE D_E_L_E_T_ = ' ' AND E1_FILIAL = E5_FILIAL AND E1_NUM = E5_NUMERO AND E1_CLIENTE = E5_CLIFOR AND E1_TIPO = E5_TIPO)                                                                                "+CRLF
	cQry += "			WHEN E5_RECPAG = 'P' THEN (SELECT TOP 1 E2_VALOR FROM SE2010 WHERE D_E_L_E_T_ = ' ' AND E2_FILIAL = E5_FILIAL AND E2_NUM = E5_NUMERO AND E2_FORNECE = E5_CLIFOR AND E2_TIPO = E5_TIPO)                                                                                "+CRLF
	cQry += "		END VALOR_ORIG, SUBSTRING(E5_DTDIGIT,7,2)+'/'+SUBSTRING(E5_DTDIGIT,5,2)+'/'+SUBSTRING(E5_DTDIGIT,1,4),                                                                                                                                                                    "+CRLF
	cQry += "		SUBSTRING(E5_DTDISPO,7,2)+'/'+SUBSTRING(E5_DTDISPO,5,2)+'/'+SUBSTRING(E5_DTDISPO,1,4) E5_DTDISPO                                                                                                                                                                          "+CRLF
	cQry += "from "+RetSqlName("SE5")+"                                                                                                                                                                                                                                                       "+CRLF
	cQry += "WHERE D_E_L_E_T_ = ' '                                                                                                                                                                                                                                                           "+CRLF
	
	If !Empty(MV_PAR03)
		cQry += "AND   E5_BANCO   = '"+MV_PAR03+"'                                                                                                                                                                                                                                                  "+CRLF
	EndIf
	
	If !Empty(MV_PAR04)
		cQry += "AND   E5_AGENCIA = '"+MV_PAR04+"'                                                                                                                                                                                                                                                "+CRLF
	EndIf
	
	If !Empty(MV_PAR05)
		cQry += "AND   E5_CONTA   = '"+MV_PAR05+"'                                                                                                                                                                                                                                                  "+CRLF
	EndIf
	
	cQry += "AND   E5_DATA    BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'                                                                                                                                                                                                                           "+CRLF
EndIf

Return cQry

/*/{Protheus.doc} GeraCsv
//TODO Função que gera o relatório em formato CSV.
@author Pirolo
@since 16/07/2020
@return return, return_description
@example
(examples)
@see (https://tdn.totvs.com/display/framework/FWFileWriter), (https://centraldeatendimento.totvs.com/hc/pt-br/articles/360020133472-MP-ADVPL-FWFileWriter-como-gravar-no-arquivo)
/*/
Static Function GeraCsv()
Local oFile := FWFILEWRITER():new("C:\Temp\MOVFIN"+Dtos(Date())+".csv")
Local cQry	:= PegaQry()

//Verifica se o arquivo existe
If oFile:Exists()
	oFile:Erase()
EndIf
 
//Cria o arquivo
If (oFile:Create())
	If Select("QRY")>0
		QRY->(dbCloseArea())
	EndIf
	//Executa a query
	DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQry),'QRY',.T.,.T.)
	
	//Grava o cabeçalho do CSV
	oFile:Write("Filial;Numero;Rec/Pag;Prefixo;Tipo;Cli/For;Natureza;Historico;Data;Juros;Multa;Desconto;Valor;Banco;Agencia;Conta;Data Disp."+CRLF)
	
	//Percorre a query, gravando as linhas
	While QRY->(!EOF())
		oFile:Write(Alltrim(QRY->E5_FILIAL   			)+";"+;
					Alltrim(QRY->E5_NUMERO   			)+";"+;
					Alltrim(QRY->E5_RECPAG   			)+";"+;
					Alltrim(QRY->E5_PREFIXO  			)+";"+;
					Alltrim(QRY->E5_TIPO     			)+";"+;
					Alltrim(QRY->E5_CLIFOR   			)+";"+;
					Alltrim(QRY->E5_NATUREZ  			)+";"+;
					Alltrim(QRY->E5_HISTOR				)+";"+;
					Alltrim(QRY->E5_DATA     			)+";"+;
					Alltrim(StrTran(cValToChar(QRY->E5_VLJUROS),".", ",") )+";"+;
					Alltrim(StrTran(cValToChar(QRY->E5_VLMULTA),".", ",") )+";"+;
					Alltrim(StrTran(cValToChar(QRY->E5_VLDESCO),".", ",") )+";"+;
					Alltrim(StrTran(cValToChar(QRY->E5_VALOR  ),".", ",") )+";"+;
					Alltrim(QRY->E5_BANCO    			)+";"+;
					Alltrim(QRY->E5_AGENCIA  			)+";"+;
					Alltrim(QRY->E5_CONTA    			)+";"+;
					Alltrim(QRY->E5_DTDISPO    			)+CRLF)
		
		QRY->(DbSkip())
	EndDo
	
	//Fecha o arquivo
	oFile:Close()
	FreeObj(oFile)
Endif
 
Return

/*/{Protheus.doc} TWFUN02A
//TODO Função de Aprovação de Alçada customizada do Pedido de Compras.
@author Pirolo
@since 07/08/2020
@return return, return_description
/*/
User Function TWFUN02A()
Local aAreaSC7	:= SC7->(GetArea())
Local lLib		:= .F.

If MsgYesNo("Confirma a Aprovação do Pedido?", "Liberação de Alçada")
	DbSelectArea("SCR")
	SCR->(DbSetOrder(2))//CR_FILIAL, CR_TIPO, CR_NUM, CR_USER, R_E_C_N_O_, D_E_L_E_T_
	
	If SCR->(DbSeek(SC7->(C7_FILIAL+"PC"+Padr(C7_NUM, TamSX3("CR_NUM")[1]))+RetCodUsr()))
		
		//Inicia Transação
		Begin Transaction
			
			//Se a alçada estiver pendente de aprovação
			If SCR->CR_STATUS == "02"
			
				//Marca a alçada como aprovada
				RecLock("SCR", .F.)
					SCR->CR_DATALIB := dDataBase
					SCR->CR_STATUS	:= "03"
					SCR->CR_LIBAPRO	:= SCR->CR_APROV
					SCR->CR_VALLIB	:= SCR->CR_TOTAL
					SCR->CR_USERLIB	:= RetCodUsr()
					SCR->CR_TIPOLIM	:= "D"
				SCR->(MsUnlock())
				
				//Seleciona o filtro do Pedido de Compras
				SC7->(DbSetOrder(1))//C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN
				
				//Posiciona no primeiro item do Pedido de Compra
				If SC7->(DBSeek(C7_FILIAL+C7_NUM+"0001"))
					
					//Percorre todos os itens do pedido
					While SC7->(!Eof() .AND. AllTrim(C7_FILIAL+C7_NUM) == AllTrim(SCR->(CR_FILIAL+CR_NUM)) .AND. SCR->CR_TIPO == "PC")
						lLib := .T.
						//Libera o item do pedido
						RecLock("SC7", .F.)
							SC7->C7_CONAPRO := "L"
						SC7->(MsUnLock())
						
						SC7->(DbSkip())
					EndDo
				EndIf
			Else
				MsgInfo("Pedido não se encontra pendente de Aprovação.", "Alçada")
			EndIf
		END Transaction
	Else
		MsgInfo("Não localizada aprovação pendente em seu nome.", "Alçada")
	Endif
	
	If lLib
		MsgInfo("Pedido liberado com sucesso.")
	EndIf
EndIf
RestArea(aAreaSC7)
Return
