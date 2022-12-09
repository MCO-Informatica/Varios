#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH" 


#DEFINE CRLF CHR(10)+CHR(13)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PFINR010  º Autor ³Ellen Santiago      º Data ³  09/08/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio de Comissao de Vendedores                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Prozyn                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PFINR010()

Local aArea		:= GetArea()
Local cPerg	 	:= Padr("PFATR010",len(SX1->X1_GRUPO))
Local aPergunta	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria as perguntas necessárias para a execução do relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aPergunta,{PadR(cPerg,10),"01","Data Emissao De  ?" 	,"MV_CH1" ,"D",008,00,"G","MV_PAR01","" ,"" ,"","","",""})
Aadd(aPergunta,{PadR(cPerg,10),"02","Data Emissao Ate  ?" 	,"MV_CH2" ,"D",008,00,"G","MV_PAR02","" ,"" ,"","","",""})
Aadd(aPergunta,{PadR(cPerg,10),"03","Vendedor de  ?" 		,"MV_CH3" ,"C",006,00,"G","MV_PAR03","" ,"" ,"","","","SA3"})
Aadd(aPergunta,{PadR(cPerg,10),"04","Vendedor ate ?" 		,"MV_CH4" ,"C",006,00,"G","MV_PAR04","" ,"" ,"","","","SA3"})
Aadd(aPergunta,{PadR(cPerg,10),"05","Data de Pagamento  ?" 	,"MV_CH5" ,"D",006,00,"G","MV_PAR05","" ,"" ,"","","",""})
Aadd(aPergunta,{PadR(cPerg,10),"06","Procedimento  ?"  		,"MV_CH06" ,"N",001,00,"C","MV_PAR06","Fechamento","Estorno","","",""	,""})

VldSX1(aPergunta)

If !Pergunte(aPergunta[1,1],.T.)
	Return(Nil)
EndIf

RptStatus({|| RunReport()})

RestArea(aArea)
	
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RunReport º Autor ³ Ellen Santiago     º Data ³  09/08/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport()

Local cQuery	:= ""
Local nTotal	:= 0
Local cArquivo	:= GetTempPath()+'PrazynExc1.xml'
Local cTitulo	:= ""  
Local lContinua := .T.
Local oFWMsExcel
Local oExcel

SetRegua(0)

cQuery := " SELECT MAX(A3_COD) A3_COD," + CRLF
cQuery += "		MAX(A3_NOME) VENDEDOR," + CRLF
cQuery += "		ISNULL(SUM(E3_COMIS) ,0) COMISSAO " + CRLF
cQuery += " FROM  "+RetSqlName("SE3")+" SE3 " + " (Nolock) " + CRLF  
cQuery += " 	INNER JOIN "+RetSqlName("SA3")+" SA3 " + " (Nolock) " + CRLF  
cQuery += " 	ON A3_COD = E3_VEND " + CRLF    
cQuery += " WHERE SE3.D_E_L_E_T_ = '' " + CRLF
cQuery += " 	AND SA3.D_E_L_E_T_ = '' " + CRLF
cQuery += "		AND E3_EMISSAO >= '"+ Dtos(MV_PAR01) +"'"  + CRLF
cQuery += "		AND E3_EMISSAO <= '"+ Dtos(MV_PAR02) +"'"  + CRLF
cQuery += "		AND A3_COD >= '"+ MV_PAR03 +"'"  + CRLF
cQuery += "		AND A3_COD <= '"+ MV_PAR04 +"'"  + CRLF
cQuery += " GROUP BY E3_VEND " + CRLF
cQuery += " ORDER BY E3_VEND " + CRLF
        
If Select("TMP") > 0
	dbSelectArea("TMP")
Else
	dbCloseArea()
EndIf
		
TcQuery cQuery ALIAS "TMP" NEW

// Verifica se o Excel está instalado na máquina
If !ApOleClient("MSExcel")
    MsgAlert("Microsoft Excel não instalado!")
    Return
EndIf

//Criando o objeto que irá gerar o conteudo do Excel
oFWMsExcel := FWMSExcel():New()
 
//Aba 01 - COMISSAO
oFWMsExcel:AddworkSheet("Comissao")

If MV_PAR06 = 1
	cTitulo := "COMISSÃO DE " + DtoC(MV_PAR01) +" à "+ DtoC(MV_PAR02) + Space(20) + "PAGTO EM: " + cValToChar(MV_PAR05)
Else
 	cTitulo := "COMISSÃO DE " + DtoC(MV_PAR01) +" à "+ DtoC(MV_PAR02) + Space(20) + "ESTORNO" 
Endif 
 
//Criando Tabela para os dados
oFWMsExcel:AddTable("Comissao",cTitulo) 
            
oFWMsExcel:AddColumn("Comissao",cTitulo,"Codigo" + Space(10),1)
oFWMsExcel:AddColumn("Comissao",cTitulo,"Nome do Vendedor" + Space(10),1)
oFWMsExcel:AddColumn("Comissao",cTitulo,"Valor Comissao" + Space(10) ,3)

While TMP->(!EOF())
oFWMsExcel:AddRow("Comissao",cTitulo,{;
            TMP->A3_COD,;
            TMP->VENDEDOR,;
            ALLTRIM(Transform(TMP->COMISSAO,PesqPict('SE3','E3_COMIS')));
        })
        nTotal += TMP->COMISSAO	
   TMP->(DbSkip())
EndDo

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Query para gravacao da data de pagamento ou estorno       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
cQuery := "SELECT E3_DATA,  " + CRLF
cQuery += "		SE3.R_E_C_N_O_ SE3RECNO " + CRLF 
cQuery += "FROM  "+RetSqlName("SE3")+" SE3 " + " (Nolock) " + CRLF  
cQuery += "		INNER JOIN "+RetSqlName("SA3")+" SA3 " + " (Nolock) " + CRLF  
cQuery += " 	ON A3_COD = E3_VEND " + CRLF 
cQuery += "WHERE SE3.D_E_L_E_T_ = '' " + CRLF 
cQuery += "		AND SA3.D_E_L_E_T_ = ''  " + CRLF
cQuery += "		AND E3_EMISSAO >= '"+ Dtos(MV_PAR01) +"'"  + CRLF
cQuery += "		AND E3_EMISSAO <= '"+ Dtos(MV_PAR02) +"'"  + CRLF
cQuery += "		AND A3_COD >= '"+ MV_PAR03 +"'"  + CRLF
cQuery += "		AND A3_COD <= '"+ MV_PAR04 +"'"  + CRLF
    
If Select("COM") > 0
	dbSelectArea("COM")
Else
	dbCloseArea()
EndIf
		
TcQuery cQuery ALIAS "COM" NEW

While COM->(!EOF()) 
    If MV_PAR06 = 1 .And. Empty(COM->E3_DATA)
		SE3->(DbGoTo(COM->SE3RECNO))
		SE3->(RecLock("SE3",.F.))
			SE3->E3_DATA  := MV_PAR05 
		SE3->(MsUnlock()) 
	Elseif MV_PAR06 = 1 .And. !Empty(COM->E3_DATA)
		MSGALERT( 'Pagamento efetuado em ' + RIGHT(COM->E3_DATA,2) + "/" +  SUBSTR(COM->E3_DATA,5,2) +"/"+ SUBSTR(COM->E3_DATA,1,4) + " realize o estorno." , 'ATENÇÃO' )
	   	lContinua := .F.
	    Exit
	Elseif MV_PAR06 = 2
		SE3->(DbGoTo(COM->SE3RECNO))   
		SE3->(RecLock("SE3",.F.))
			SE3->E3_DATA := CTOD("  /  /  ")
		SE3->(MsUnlock())         	
    Endif
   COM->(DbSkip())
EndDo

If Select("COM") > 0
	COM->(DbCloseArea())
EndIf
    
If lContinua 
	//Adiciona linhas no Excel
	oFWMsExcel:AddRow("Comissao",cTitulo,{"","","" }) // Linha vazia
	oFWMsExcel:AddRow("Comissao",cTitulo,{"TOTAL","",ALLTRIM(Transform(nTotal,PesqPict('SE3','E3_COMIS'))) })
	
	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)
	     
	//Abrindo o excel e abrindo o arquivo xml
	oExcel:= MsExcel():New()       	//Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo)	//Abre uma planilha
	oExcel:SetVisible(.T.)         	//Visualiza a planilha
	oExcel:Destroy()               	//Encerra o processo do gerenciador de tarefas
Endif

 

Return

/*
+-----------------------------------------------------------------------------+
| PROGRAMA: VldSX1         | AUTOR: Ellen Santiago        | DATA: 09/08/2018  |
+-----------------------------------------------------------------------------+
| DESCRICAO:  Validacao de Perguntas do SX1                                   |
+-----------------------------------------------------------------------------+
| USO: Prozyn                   				                                |
+-----------------------------------------------------------------------------+   
*/
Static Function VldSX1(aPergunta)

Local i

dbSelectArea("SX1")

SX1->(dbSetOrder(1))

For i := 1 To Len(aPergunta)
	SX1->(RecLock("SX1",!dbSeek(aPergunta[i,1]+aPergunta[i,2])))
	SX1->X1_GRUPO 		:= aPergunta[i,1]
	SX1->X1_ORDEM		:= aPergunta[i,2]
	SX1->X1_PERGUNT		:= aPergunta[i,3]
	SX1->X1_VARIAVL		:= aPergunta[i,4]
	SX1->X1_TIPO		:= aPergunta[i,5]
	SX1->X1_TAMANHO		:= aPergunta[i,6]
	SX1->X1_DECIMAL		:= aPergunta[i,7]
	SX1->X1_GSC			:= aPergunta[i,8]
	SX1->X1_VAR01		:= aPergunta[i,9]
	SX1->X1_DEF01		:= aPergunta[i,10]
	SX1->X1_DEF02		:= aPergunta[i,11]
	SX1->X1_DEF03		:= aPergunta[i,12]
	SX1->X1_DEF04		:= aPergunta[i,13]
	SX1->X1_DEF05		:= aPergunta[i,14]
	SX1->X1_F3			:= aPergunta[i,15]
	SX1->(MsUnlock())
Next i

Return(Nil)