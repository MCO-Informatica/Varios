#include "Totvs.ch"
#include "Protheus.ch"
#include "TopConn.ch"

//===========================================================================
// Programa.......: RCOMR01
// Autor..........: Anderson Goncalves
// Data...........: 30/04/2021
// Descricao......: Relatorio em excel de ponto de pedido
// Uso............: Verquimica
//===========================================================================

User Function RCOMR01()

//===========================================================================
// Variaveis da Rotina
//===========================================================================
Local aSays         := {}
Local aButtons      := {}
Local cCadastro     := "Ponto de pedido"

Local cPerg         := "RCOMR01"
Local aRegs         := {}
Local nOpcA         := 0

//===========================================================================
// Criacao dos parametros para filtro do relatorio
//===========================================================================
aAdd(aRegs,{cPerg,"01","Produto inicial" 	,"","","mv_ch1","C",TamSX3("B1_COD")[1]     ,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","" })
aAdd(aRegs,{cPerg,"02","Produto Final"   	,"","","mv_ch2","C",TamSX3("B1_COD")[1]     ,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","" })
aAdd(aRegs,{cPerg,"03","Tipo inicial" 	    ,"","","mv_ch3","C",TamSX3("B1_TIPO")[1]    ,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","02","","","","" })
aAdd(aRegs,{cPerg,"04","Tipo Final"   	    ,"","","mv_ch4","C",TamSX3("B1_TIPO")[1]    ,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","02","","","","" })
aAdd(aRegs,{cPerg,"05","Armazem Inicial"   	,"","","mv_ch5","C",TamSX3("B1_LOCPAD")[1]  ,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","NNR","","","","" })
aAdd(aRegs,{cPerg,"06","Armazem Final"   	,"","","mv_ch6","C",TamSX3("B1_LOCPAD")[1]  ,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","NNR","","","","" })
aAdd(aRegs,{cPerg,"07","Exibir"   	        ,"","","mv_ch7","N",01                      ,0,0,"C","","mv_par04","Ponto de Pedido","","","","","Todos","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"08","Listar Saldo Zerado","","","mv_ch8","N",01                      ,0,0,"C","","mv_par04","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","" })

U_CriaSX1(cPerg,aRegs)
Pergunte(cPerg,.F.)

//===========================================================================
// Monta interface com o usuario
//===========================================================================
aadd(aSays,"Este programa tem como objetivo imprimir relatorio em excel de ponto de"	)
aadd(aSays,"pedido de acordo com os parametros definidos pelo usuário."	            	)
aadd(aSays,""																			)
aadd(aSays,"Clique no botão parâmetros seleção dos dados."	                            )
aadd(aButtons, { 5,.T.	,{|o| (Pergunte(cPerg,.T.),o:oWnd:refresh())			        }})
aadd(aButtons, { 1,.T.	,{|o| (nOpcA := 1,o:oWnd:End())   						        }})
aadd(aButtons, { 2,.T.	,{|o| (nOpcA := 0,o:oWnd:End())							        }})
FormBatch( cCadastro, aSays, aButtons )

If nOpcA == 1
    Processa({|| ImprimeExc(cCadastro) },cCadastro)
EndIf

Return Nil

//===========================================================================
// Programa.......: ImprimeExc
// Autor..........: Anderson Goncalves
// Data...........: 30/04/2021
// Descricao......: Impressao do relatorio em excel, programa principal
// Uso............: Verquimica
//===========================================================================

Static Function ImprimeExc(cCadastro)

//===========================================================================
// Variaveis da Rotina
//===========================================================================
Local cNomeArq      := "Ponto_de_Pedido_" + Replace(TransForm(Date(),"@D"),"/","-")+"_"+Replace(Time(),":","")
Local cQuery        := ""
Local nTotReg       := 0

Local cArquivo  	:= GetTempPath()+cNomeArq+".xml"
Local oExcel		:= Nil
Local cFolder1	    := "SINTETICO"
Local cTabela		:= "PONTO DE PEDIDO"

CursorWait()

//============================================================
// Verifica se existe excel instalado
//============================================================
If !ApOleClient("MSExcel")
    MsgInfo("Microsoft Excel não instalado!","Sem Excel")
    Return Nil
EndIf	

//============================================================
// Cria arquivo em excel
//============================================================
oExcel  := FWMSExcel():New()

oExcel:CBGCOLORHEADER 	:= "#ff0000"
oExcel:CBGCOLORLINE 	:= "#ca9797"
oExcel:CBGCOLOR2LINE 	:= "#fee0e0"
oExcel:CFRCOLORTITLE    := "#000000"

//============================================================
// Criacao do folder
//============================================================  	   				 		 		 	 				 	  	   	   	  	  	
oExcel:AddworkSheet(cFolder1)
oExcel:AddTable (cFolder1,cTabela)
oExcel:AddColumn(cFolder1,cTabela,"PRODUTO"             ,1) 
oExcel:AddColumn(cFolder1,cTabela,"DESCRIÇÃO"           ,1) 
oExcel:AddColumn(cFolder1,cTabela,"TIPO"	            ,2)
oExcel:AddColumn(cFolder1,cTabela,"ARMAZEM"	            ,2) 
oExcel:AddColumn(cFolder1,cTabela,"SALDO FISICO"	    ,3) 
oExcel:AddColumn(cFolder1,cTabela,"EM PEDIDO VENDAS"    ,3) 
oExcel:AddColumn(cFolder1,cTabela,"EM PEDIDO COMPRAS"   ,3) 
oExcel:AddColumn(cFolder1,cTabela,"CONSIDERA ENT E SAI" ,3) 
oExcel:AddColumn(cFolder1,cTabela,"ESTOQUE MINIMO"      ,3) 
oExcel:AddColumn(cFolder1,cTabela,"ESTOQUE SEGURANÇA"   ,3) 
oExcel:AddColumn(cFolder1,cTabela,"ORIGEM"              ,1) 
oExcel:AddColumn(cFolder1,cTabela,"EMBALAGEM"           ,1) 

//=======================================================
// Filtra os registros da operação
//=======================================================
cQuery := "SELECT B1_COD PRODUTO, B1_DESC DESCRICAO, B1_TIPO TIPO, B1_LOCPAD ARMAZEM, SUM(B2_QATU) 'SALDO_FISICO', "
cQuery += "	(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0) FROM "+RetSqlName("SC6")+" (NOLOCK) "
cQuery += "	WHERE C6_FILIAL = '"+xFilial("SC6")+"' "
cQuery += "	AND C6_PRODUTO = B1_COD "
cQuery += "	AND D_E_L_E_T_ = ' ' "
cQuery += "	) PV, "
cQuery += "	(SELECT ISNULL(SUM(C7_QUANT-C7_QUJE),0) FROM "+RetSqlname("SC7")+" (NOLOCK) "
cQuery += "	WHERE C7_FILIAL = '01' "
cQuery += "	AND C7_PRODUTO = B1_COD "
cQuery += "	AND D_E_L_E_T_ = ' ' "
cQuery += "	) PC, "
cQuery += "B1_EMIN 'MINIMO', B1_ESTSEG 'SEGURANCA', B1_ORIGEM+' - '+UPPER(X5_DESCRI) ORIGEM, B1_VQ_EM EMBALAGEM "
cQuery += "FROM "+RetSqlName("SB1")+" SB1 (NOLOCK), "+RetSqlName("SB2")+" SB2 (NOLOCK), "+RetSqlName("SX5")+" SX5 (NOLOCK) " 
cQuery += "WHERE B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery += "AND B1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQuery += "AND B1_TIPO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery += "AND B1_LOCPAD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQuery += "AND SB1.D_E_L_E_T_ = ' ' " 
cQuery += "AND B2_FILIAL = '"+xFilial("SB2")+"' "
cQuery += "AND B2_COD = B1_COD "
If mv_par08 == 2
    cQuery += "AND B2_QATU > 0 "
Endif
cQuery += "AND SB2.D_E_L_E_T_ = ' ' "
cQuery += "AND X5_FILIAL = '"+xFilial("SX5")+"' "
cQuery += "AND X5_TABELA = 'S0' "
cQuery += "AND X5_CHAVE = B1_ORIGEM "
cQuery += "AND SX5.D_E_L_E_T_ = ' ' "
cQuery += "GROUP BY B1_COD, B1_DESC, B1_TIPO, B1_LOCPAD, B1_EMIN, B1_ESTSEG, B1_ORIGEM, X5_DESCRI, B1_VQ_EM "
cQuery += "ORDER BY B1_DESC "

U_FinalArea("QUERY")
TcQuery cQuery New Alias "QUERY"

dbSelectArea("QUERY")
QUERY->(dbGoTop())
QUERY->(dbEval({ || nTotReg++},,{ ||!EOF()}))
QUERY->(dbGoTop())

CursorArrow()

//=======================================================
// Regua de impressao
//=======================================================
ProcRegua(nTotReg)

//=======================================================
// Processa arquivo de consulta
//=======================================================
While QUERY->(!EOF())

    //=======================================================
    // BIncrementa regua
    //=======================================================
    IncProc("Imprimindo registros, aguarde...")

    If mv_par07 == 1
        If QUERY->SALDO_FISICO+QUERY->PC-QUERY->PV > QUERY->MINIMO
            QUERY->(dbSkip())
            Loop
        Endif
    EndIf

    //=======================================================
    // Monta linha do excel
    //=======================================================
    oExcel:AddRow(cFolder1,cTabela,{QUERY->PRODUTO,;
                                    QUERY->DESCRICAO,;
                                    QUERY->TIPO,;
                                    QUERY->ARMAZEM,;
                                    TransForm(QUERY->SALDO_FISICO,PesqPict("SB2","B2_QATU")),;
                                    TransForm(QUERY->PV,PesqPict("SC6","C6_QTDVEN")),;
                                    TransForm(QUERY->PC,PesqPict("SC7","C7_QUANT")),;
                                    TransForm(QUERY->SALDO_FISICO+QUERY->PC-QUERY->PV,PesqPict("SC7","C7_QUANT")),;
                                    QUERY->MINIMO,;
                                    QUERY->SEGURANCA,;
                                    QUERY->ORIGEM,;
                                    QUERY->EMBALAGEM })

    QUERY->(dbSkip())

Enddo
U_FinalArea("QUERY")

//=======================================================
// Finaliza e abre o excel
//=======================================================
oExcel:Activate()
oExcel:GetXMLFile(cArquivo)
 
oExcelApp := MsExcel():New()         
oExcelApp:WorkBooks:Open(cArquivo)  
oExcelApp:SetVisible(.T.)       
oExcelApp:Destroy() 

Return Nil

