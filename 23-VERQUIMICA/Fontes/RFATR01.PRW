#include "Totvs.ch"
#include "Protheus.ch"
#include "TopConn.ch"

//===========================================================================
// Programa.......: RFATR01
// Autor..........: Anderson Goncalves
// Data...........: 10/06/2021
// Descricao......: Relatorio de pedidos não entregues (Excel)
// Uso............: Verquimica
//===========================================================================

User Function RFATR01()

//===========================================================================
// Variaveis da Rotina
//===========================================================================
Local aSays         := {}
Local aButtons      := {}
Local cCadastro     := "Pedidos não Entregues"

Local cPerg         := "RFATR01"
Local aRegs         := {}
Local nOpcA         := 0

//===========================================================================
// Criacao dos parametros para filtro do relatorio
//===========================================================================
aAdd(aRegs,{cPerg,"01","Pedido inicial" 	    ,"","","mv_ch1","C",TamSX3("C5_NUM")[1] ,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC5","","","","" })
aAdd(aRegs,{cPerg,"02","Pedido Final"   	    ,"","","mv_ch2","C",TamSX3("C5_NUM")[1] ,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC5","","","","" })
aAdd(aRegs,{cPerg,"03","Produto inicial" 	    ,"","","mv_ch3","C",TamSX3("B1_COD")[1] ,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","" })
aAdd(aRegs,{cPerg,"04","Produto Final"   	    ,"","","mv_ch4","C",TamSX3("B1_COD")[1] ,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","" })
aAdd(aRegs,{cPerg,"05","Dt Emissao Inicial"     ,"","","mv_ch5","D",08                  ,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"06","Dt Emissao Final"       ,"","","mv_ch6","D",08                  ,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"07","Dt Entrega Inicial"     ,"","","mv_ch7","D",08                  ,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"08","Dt Entrega Final"       ,"","","mv_ch8","D",08                  ,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })

U_CriaSX1(cPerg,aRegs)
Pergunte(cPerg,.F.)

//===========================================================================
// Monta interface com o usuario
//===========================================================================
aadd(aSays,"Este programa tem como objetivo imprimir relatório em excel de pedidos não"	)
aadd(aSays,"entregues de acordo com os parametros definidos pelo usuário."	            )
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
Local cNomeArq      := "pedidos_nao_entregues_" + Replace(TransForm(Date(),"@D"),"/","-")+"_"+Replace(Time(),":","")
Local cQuery        := ""
Local nTotReg       := 0

Local cArquivo  	:= GetTempPath()+cNomeArq+".xml"
Local oExcel		:= Nil
Local cFolder1	    := "SINTETICO"
Local cTabela		:= "PEDIDOS NÃO ENTREGUES"

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
oExcel:AddColumn(cFolder1,cTabela,"ENTREGA"             ,2) 
oExcel:AddColumn(cFolder1,cTabela,"NUM. PEDIDO"         ,1) 
oExcel:AddColumn(cFolder1,cTabela,"EMISSAO"	            ,2)
oExcel:AddColumn(cFolder1,cTabela,"CODIGO"	            ,2) 
oExcel:AddColumn(cFolder1,cTabela,"LOJA"	            ,2) 
oExcel:AddColumn(cFolder1,cTabela,"NOME"                ,1) 
oExcel:AddColumn(cFolder1,cTabela,"ITEM"                ,2) 
oExcel:AddColumn(cFolder1,cTabela,"PRODUTO"             ,1) 
oExcel:AddColumn(cFolder1,cTabela,"DESCRICAO"           ,1) 
oExcel:AddColumn(cFolder1,cTabela,"QUANTIDADE"          ,3) 
oExcel:AddColumn(cFolder1,cTabela,"QUANT ENTREGUE"      ,3) 
oExcel:AddColumn(cFolder1,cTabela,"SALDO"               ,3) 
oExcel:AddColumn(cFolder1,cTabela,"TRANSPORTADORA"      ,1) 
oExcel:AddColumn(cFolder1,cTabela,"NOME"                ,1) 
oExcel:AddColumn(cFolder1,cTabela,"FRETE VERQUIMICA"    ,2) 
oExcel:AddColumn(cFolder1,cTabela,"FRETE CLIENTE"       ,2) 
oExcel:AddColumn(cFolder1,cTabela,"OBS OPERACIONAL"     ,1) 

//=======================================================
// Filtra os registros da operação
//=======================================================
cQuery := "SELECT C6_ENTREG ENTREGA, C5_NUM PEDIDO, C5_EMISSAO EMISSAO, A1_COD CODIGO, A1_LOJA LOJA, A1_NREDUZ FANTASIA, C6_ITEM ITEM, "
cQuery += "C6_PRODUTO PRODUTO, B1_DESC DESCRICAO, C6_QTDVEN QUANT, C6_QTDENT QENT, (C6_QTDVEN-C6_QTDENT) PENDENTE, A4_COD TRANSP, A4_NOME NOME, "
cQuery += "C5_VQ_FVER FRETE, C5_VQ_FCLI FRETEC, ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), A1_VQ_OBSO)),'') OBSS "
cQuery += "FROM "+RetSqlName("SC6") + " SC6 (NOLOCK), "+RetSqlName("SA1")+ " SA1 (NOLOCK), "+RetSqlName("SC5")+" SC5 (NOLOCK), "+RetSqlName("SB1")+" SB1 (NOLOCK), "+RetSqlName("SA4") + " SA4 (NOLOCK) "
cQuery += "WHERE C5_FILIAL = '" + xFilial("SC5") + "' "
cQuery += "AND C5_NUM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
cQuery += "AND C5_EMISSAO BETWEEN '" + dtos(mv_par05) + "' AND '" + dtos(mv_par06) + "' "
cQuery += "AND SC5.D_E_L_E_T_ = ' ' "
cQuery += "AND A1_FILIAL = '" + xFilial("SA1") + "' "
cQuery += "AND A1_COD = C5_CLIENTE "
cQuery += "AND A1_LOJA = C5_LOJACLI "
cQuery += "AND SA1.D_E_L_E_T_ = ' ' "
cQuery += "AND C6_FILIAL = '" + xFilial("SC6") + "' "
cQuery += "AND C6_NUM = C5_NUM "
cQuery += "AND C6_PRODUTO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
cQuery += "AND C6_ENTREG BETWEEN '" + dtos(mv_par07) + "' AND '" + dtos(mv_par08) + "' "
cQuery += "AND C6_QTDVEN - C6_QTDENT > 0 "
cQuery += "AND SC6.D_E_L_E_T_ = ' ' "
cQuery += "AND B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery += "AND B1_COD = C6_PRODUTO "
cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
cQuery += "AND A4_FILIAL = '" + xFilial("SA4") + "' "
cQuery += "AND A4_COD = C5_TRANSP "
cQuery += "AND SA4.D_E_L_E_T_ = ' ' "

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

    //=======================================================
    // Monta linha do excel
    //=======================================================
    oExcel:AddRow(cFolder1,cTabela,{TransForm(stod(QUERY->ENTREGA),"@D"),;
                                    QUERY->PEDIDO,;
                                    TransForm(stod(QUERY->EMISSAO),"@D"),;
                                    QUERY->CODIGO,;
                                    QUERY->LOJA,;
                                    QUERY->FANTASIA,;
                                    QUERY->ITEM,;
                                    QUERY->PRODUTO,;
                                    QUERY->DESCRICAO,;
                                    TransForm(QUERY->QUANT,PesqPict("SC6","C6_QTDVEN")),;
                                    TransForm(QUERY->QENT,PesqPict("SC6","C6_QTDVEN")),;
                                    TransForm(QUERY->PENDENTE,PesqPict("SC6","C6_QTDVEN")),;
                                    QUERY->TRANSP,;
                                    QUERY->NOME,;
                                    QUERY->FRETE,;
                                    QUERY->FRETEC,;
                                    QUERY->OBSS })

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

