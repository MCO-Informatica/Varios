
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
//TODO Relatório de Movimentações Financeiras de PAs.
@author Pirolo
@since 21/09/2020
@version undefined
@return return, return_description
/*/
User Function RFINTW01()
Local cFilePrint := "report"

RpcSetType(3)
RpcSetEnv("01","0101")

oPrint := FwMSPrinter():New(cFilePrint,6,.F.,,.F.,,,,,,,.T.)

If Empty(oPrint:oFileWriter:oErroLog:Message)
	oPrint	:= GeraLinha(oPrint)
	oPrint:EndPage()
	oPrint:Preview()
EndIf

If Type("oPrint:nHandle") <> 'U'
	FClose(oPrint:nHandle)
EndIf

FreeObj(oPrint)
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
Local cQry			:= ""
Local cUltiPA       := ""
Local lMudou        := .F.
Local nTotVal		:= 0
Local nTotSal		:= 0

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

DbUseArea(.T.,'TOPCONN',TcGenQry(,,cQry),'QRY',.T.,.T.)
DbSelectArea('QRY')
DbGoTop()

While QRY->(!EOF())

	If nLin >= nLimPag .OR. nLin == 10 .OR. cUltiPA <> QRY->(FIL_PA+FORNEC+NUM_PA+PA_PARCE)
		lMudou := .T.

        If nLin > 10
			oPrint:Line(nLin+2,0010,nLin+1,0600)
        	oPrint:Say(nLin, 0220, OemToAnsi("Total Titulos"		),oFonte08N)            
			oPrint:Say(nLin, 0280, OemToAnsi("R$"+Transform(nTotVal, "@E 999,999,999.99")),oFonte08N)
        	oPrint:Say(nLin, 0350, OemToAnsi("R$"+Transform(nTotSal, "@E 999,999,999.99")),oFonte08N)

			nTotVal := 0
			nTotSal := 0
			oPrint:EndPage()
		EndIf
		
		nLin := 0120 //nLinCab //Melhor aproveitamento da segunda pagina em diante
		oPrint:StartPage()
		oPrint:Say(0060,0150,OemToAnsi("Relatório de Movimentações Financeiras de PAs"),oFonte20N)
		oPrint:SayBitmap(0000,0010,cLogo)
		oPrint:Line(nLin+1,0010,nLin+1,0600)
		
		oPrint:Say(nLin, 0010, OemToAnsi("Filial"		),oFonte08N)            
		oPrint:Say(nLin, 0030, OemToAnsi("Fornecedor"	),oFonte08N)            
        oPrint:Say(nLin, 0175, OemToAnsi("Numero"   	),oFonte08N)            
		oPrint:Say(nLin, 0220, OemToAnsi("Parcela"   	),oFonte08N)            
		oPrint:Say(nLin, 0260, OemToAnsi("Valor"		),oFonte08N)            
		oPrint:Say(nLin, 0330, OemToAnsi("Saldo"    	),oFonte08N)            
		oPrint:Say(nLin, 0400, OemToAnsi("Emissão"		),oFonte08N)            

		nLin += 10

        oPrint:Say(nLin, 0010, OemToAnsi(Alltrim(QRY->FIL_PA       				)),oFonte08)
        oPrint:Say(nLin, 0030, OemToAnsi(Alltrim(QRY->FORNEC       				)),oFonte08)
        oPrint:Say(nLin, 0175, OemToAnsi(Alltrim(QRY->NUM_PA       				)),oFonte08)
		oPrint:Say(nLin, 0220, OemToAnsi(Alltrim(QRY->PA_PARCE     				)),oFonte08)
        oPrint:Say(nLin, 0260, OemToAnsi("R$"+Transform(QRY->E2_VALOR, "@E 999,999,999.99")),oFonte08)
        oPrint:Say(nLin, 0330, OemToAnsi("R$"+Transform(QRY->SALDO_PA, "@E 999,999,999.99")),oFonte08)
        oPrint:Say(nLin, 0400, OemToAnsi(AllToChar(STOD(QRY->E2_EMISSAO))),oFonte08)

		nLin += 10

		oPrint:Say(nLin, 0030, OemToAnsi("Titulo"		),oFonte08N)            
		oPrint:Say(nLin, 0070, OemToAnsi("Tipo"	        ),oFonte08N)            
        oPrint:Say(nLin, 0140, OemToAnsi("Prefixo"   	),oFonte08N)            
		oPrint:Say(nLin, 0210, OemToAnsi("Parcela"		),oFonte08N)            
		oPrint:Say(nLin, 0280, OemToAnsi("Valor"    	),oFonte08N)            
		oPrint:Say(nLin, 0350, OemToAnsi("Saldo"		),oFonte08N)            
        oPrint:Say(nLin, 0420, OemToAnsi("Baixa"		),oFonte08N)            
	    //oPrint:Line(nLin+1,0010,nLin+1,0600)

        nLin += 10
        
        
	EndIf

    //Cabeçalho do PA
    oPrint:Say(nLin, 0030, OemToAnsi(Alltrim(QRY->NUM_TITB       			)),oFonte08)
    oPrint:Say(nLin, 0070, OemToAnsi(Alltrim(QRY->TIPO_TIT       			)),oFonte08)
    oPrint:Say(nLin, 0140, OemToAnsi(Alltrim(QRY->PRF_TITB       			)),oFonte08)
    oPrint:Say(nLin, 0210, OemToAnsi(Alltrim(QRY->PARC_TIT   				)),oFonte08)
    oPrint:Say(nLin, 0280, OemToAnsi("R$"+Transform(QRY->E5_VALOR, "@E 999,999,999.99")+Iif(QRY->E5_TIPODOC == "ES", "(E)", "")),oFonte08)

    oPrint:Say(nLin, 0350, OemToAnsi("R$"+Transform(QRY->SLD_TITB, "@E 999,999,999.99")),oFonte08)
    oPrint:Say(nLin, 0420, OemToAnsi(AllToChar(STOD(QRY->BAIX_TIT   				))),oFonte08)

	//Totaliza os titulos que consumiram
	nTotVal += QRY->E5_VALOR*(Iif(QRY->E5_TIPODOC == "ES", -1, 1))
	nTotSal += Iif(QRY->E5_TIPODOC == "ES", QRY->SLD_TITB, 0)

    nLin += 10

    //Atualiza variavel do ultimo PA lido
    cUltiPA := QRY->(FIL_PA+FORNEC+NUM_PA+PA_PARCE)
	QRY->(DbSkip())
EndDo

oPrint:Line(nLin+2,0010,nLin+1,0600)
oPrint:Say(nLin, 0220, OemToAnsi("Total Titulos"		),oFonte08N)            
oPrint:Say(nLin, 0280, OemToAnsi("R$"+Transform(nTotVal, "@E 999,999,999.99")),oFonte08N)
oPrint:Say(nLin, 0350, OemToAnsi("R$"+Transform(nTotSal, "@E 999,999,999.99")),oFonte08N)

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
Local dDataDe	:= FirstDate(Date()-30)
Local dDataAt	:= LastDate(Date())
Local cFilPA    := Space(TAMSX3("E2_FILIAL")[1])

aAdd(aPergs, {1, "Filial"	,  cFilPA	,  "", ".T.", "SM0"	, ".T.", 80,  .F.}) 
aAdd(aPergs, {1, "Data De"	,  dDataDe	,  "", ".T.", ""	, ".T.", 80,  .T.})
aAdd(aPergs, {1, "Data Até"	,  dDataAt	,  "", ".T.", ""	, ".T.", 80,  .T.})

If ParamBox(aPergs, "Informe os parâmetros")

    cQry := "select A.E2_FILIAL FIL_PA, A.E2_NUM NUM_PA, A.E2_TIPO TIPO_PA, A.E2_SALDO SALDO_PA, A.E2_FORNECE +'/'+ A.E2_LOJA+' - '+A.E2_NOMFOR FORNEC, A.E2_VALOR, A.E2_EMISSAO, A.E2_PARCELA PA_PARCE,"+CRLF
    cQry += "	    B.E5_DATA, B.E5_VALOR, B.E5_SEQ, B.E5_TIPODOC,                                                                                                                                      "+CRLF
    cQry += "	    C.E2_NUM NUM_TITB, C.E2_TIPO TIPO_TIT, C.E2_PREFIXO PRF_TITB, C.E2_PARCELA PARC_TIT, C.E2_VALOR VLR_TITB, C.E2_SALDO SLD_TITB, C.E2_BAIXA BAIX_TIT                                  "+CRLF
    cQry += "from "+RetSqlName("SE2")+" A                                                                                                                                                               "+CRLF
    cQry += "		INNER JOIN "+RetSqlName("SE5")+" B                                                                                                                                                  "+CRLF
    cQry += "			ON(    E5_FILIAL    = A.E2_FILIAL                                                                                                            "+CRLF
    cQry += "			   AND E5_NUMERO    = A.E2_NUM                                                                                                               "+CRLF
    cQry += "			   AND E5_TIPO      = A.E2_TIPO                                                                                                              "+CRLF
    cQry += "			   AND E5_PREFIXO   = A.E2_PREFIXO                                                                                                           "+CRLF
    cQry += "			   AND E5_CLIFOR    = A.E2_FORNECE                                                                                                           "+CRLF
    cQry += "			   AND E5_LOJA      = A.E2_LOJA                                                                                                              "+CRLF
    cQry += "			   AND E5_PARCELA   = A.E2_PARCELA                                                                                                           "+CRLF
    cQry += "			   AND A.D_E_L_E_T_ = ''                                                                                                                     "+CRLF
    cQry += "			   AND B.D_E_L_E_T_ = '')                                                                                                                    "+CRLF
    cQry += "		INNER JOIN "+RetSqlName("SE2")+" C                                                                                                               "+CRLF
    cQry += "			ON(    B.E5_FILIAL  = C.E2_FILIAL                                                                                                            "+CRLF
    cQry += "			   AND B.E5_DOCUMEN = C.E2_PREFIXO+C.E2_NUM+C.E2_PARCELA+C.E2_TIPO+C.E2_FORNECE+C.E2_LOJA                                                    "+CRLF
    cQry += "			   AND C.D_E_L_E_T_ = '')                                                                                                                    "+CRLF
    cQry += "WHERE A.E2_TIPO     = 'PA'                                                                                                                              "+CRLF
    
	If !Empty(MV_PAR01)
		cQry += "AND   A.E2_FILIAL   = '"+MV_PAR01+"'                                                                                                                      "+CRLF
	EndIf
	
    cQry += "AND   E5_TIPODOC   <> 'PA'                                                                                                                              "+CRLF
    cQry += "AND   A.E2_EMISSAO >= '"+Dtos(MV_PAR02)+"'                                                                                                               "+CRLF
    cQry += "AND   A.E2_EMISSAO <= '"+Dtos(MV_PAR03)+"'                                                                                                               "+CRLF
    cQry += "AND   A.D_E_L_E_T_ = ''                                                                                                                                 "+CRLF
    cQry += "ORDER BY A.E2_FILIAL, A.E2_NUM, A.E2_TIPO, A.E2_FORNECE, A.E2_PARCELA, C.E2_PARCELA, A.E2_SALDO, B.E5_SEQ                                                                           "+CRLF
	
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
	oFile:Write("Filial;Numero;Rec/Pag;Prefixo;Tipo;Cli/For;Natureza;Historico;Data;Juros;Multa;Desconto;Valor;Banco;Agencia;Conta"+CRLF)
	
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
					Alltrim(QRY->E5_CONTA    			)+CRLF)
		
		QRY->(DbSkip())
	EndDo
	
	//Fecha o arquivo
	oFile:Close()
	FreeObj(oFile)
Endif
 
Return

