#include "topconn.ch"      
#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณACDFB2B8 บAutor ณRenato S. Parreira บ Data ณ 01/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAcerto das diferen็as SB2 e SB8.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ACDFB2B8()                                    

Local cTitulo := "Aguarde o calculo dos Estoques"

MsgInfo("ษ recomendแvel executar a rotina de Saldo Atual antes das corre็๕es!","Aviso")

if !msgyesno("Deseja Continuar?","Dif. B2 B8")
     Return .T.
endif

RptStatus({|lEnd| ExibeDif()},ctitulo)

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณExibeDif บAutor ณRenato S. Parreira บ Data ณ 01/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessa as diferencas e exibe em tela                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExibeDif()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis utilizadas na query de verifica็ใo de dif. SB2 e SB8ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cQuery := ""

Local cFilSB2 := xFilial("SB2")
Local cFilSB8 := xFilial("SB8")
Local cFilSB1 := xFilial("SB1")

Local cArqSB2 := RetSqlName("SB2")
Local cArqSB8 := RetSqlName("SB8")
Local cArqSB1 := RetSqlName("SB1")                               

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariแveis utilizadas na tela de exibi็ใo das diferen็asณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local oBtnCancel
Local cTitulo := "Diferen็as SB2 x SB8"
Local bCancel := {|| oDlg:End(), WORK1->(dbclosearea())} 
Private nTotal := 0

Private aCampos := {}
Private oDlg                             
Private oMark                         

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis utilizadas no arquivo de trabalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private aStruct := {} 
Private cArqTrab := ""
                            
IncProc(OemToANSI("Pesquisando Registros..."))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
//ณCria arquivo de trabalho para armazenar resultado da query validado.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

Aadd(aStruct, {"PRODUTO","C",AVSX3("B1_COD",3),0})
Aadd(aStruct, {"QLOCAL" ,"C",AVSX3("B2_LOCAL",3),0})     
Aadd(aStruct, {"QATU" ,"N",AVSX3("B2_QATU",3),2})                                                               
Aadd(aStruct, {"SALDO" ,"N",AVSX3("B8_SALDO",3),2})                                                               
Aadd(aStruct, {"RESULTADO" ,"N",AVSX3("B2_QATU",3),2})                                                               

cArqTrab := CriaTrab(aStruct)

dbUseArea(.T.,,cArqTrab,"WORK1",.T.,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFaz a Query de Verifica็ใo de produtos com diferen็aณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQuery := ""

cQuery += "SELECT " + cArqSB8 + ".B8_PRODUTO AS PRODUTO, "
cQuery += cArqSB8 + ".B8_LOCAL AS QLOCAL, "
cQuery += "ROUND(" + cArqSB2 + ".B2_QATU,2) AS QATU, "
cQuery += "ROUND(SUM(" + cArqSB8 + ".B8_SALDO),2) AS SALDO, " 
cQuery += "ROUND(SUM(" + cArqSB8 + ".B8_SALDO),2) - ROUND(" + cArqSB2 + ".B2_QATU,2) AS RESULTADO "
cQuery += "FROM " + cArqSB8 + " " 
cQuery += "INNER JOIN " + cArqSB2 + " ON " + cArqSB8 + ".B8_PRODUTO = " + cArqSB2 + ".B2_COD "
cQuery += "AND " + cArqSB8 + ".B8_LOCAL = " + cArqSB2 + ".B2_LOCAL "
cQuery += "GROUP BY " + cArqSB8 + ".B8_PRODUTO, "
cQuery += cArqSB8 + ".B8_LOCAL, "
cQuery += cArqSB8 + ".D_E_L_E_T_, "
cQuery += cArqSB2 + ".D_E_L_E_T_, "
cQuery += cArqSB2 + ".B2_COD, "
cQuery += cArqSB2 + ".B2_LOCAL, "
cQuery += cArqSB2 + ".B2_QATU, " 
cQuery += cArqSB2 + ".B2_FILIAL, "
cQuery += cArqSB8 + ".B8_FILIAL "
cQuery += "HAVING (" + cArqSB8 + ".D_E_L_E_T_ <> '*') AND (" + cArqSB2 + ".D_E_L_E_T_ <> '*') "
cQuery += "AND (ROUND(SUM(" + cArqSB8 + ".B8_SALDO),2) <> ROUND(" + cArqSB2 + ".B2_QATU,2)) "
cQuery += "AND " + cArqSB2 + ".B2_FILIAL = '" + cFilSB2 + "' "
cQuery += "AND " + cArqSB8 + ".B8_FILIAL = '" + cFilSB8 + "' "
cQuery += "ORDER BY " + cArqSB8 + ".B8_PRODUTO, " + cArqSB8 + ".B8_LOCAL "

cQuery := ChangeQuery(cQuery)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o arquivo de trabalhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

TcQuery cQuery Alias "TRB1" New

TRB1->(DBGOTOP())
                                    
IncProc(OemToANSI("Atualizando Arquivo de Diferen็as..."))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤDฟ
//ณFaz a verifica็ใo se o produto utiliza controle por loteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤDู

While TRB1->(!EOF())
	If TRB1->PRODUTO <> 'LM19ZP' .And. TRB1->QLOCAL <> 'EX'
		TRB1->(dbSkip(1));Loop
	Endif


     If SB1->(DBSEEK(cFilSB1 + TRB1->PRODUTO))          
          //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤXฟ
          //ณCaso B1_RASTRO = N, nao controla lotes. Entao elimina do arquivo de trabalhoณ
          //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤXู
          IF SB1->B1_RASTRO <> "N" 
               IF RECLOCK("WORK1",.T.)
                 WORK1->PRODUTO := TRB1->PRODUTO
                 WORK1->QLOCAL   := TRB1->QLOCAL
                 WORK1->QATU     := TRB1->QATU
                 WORK1->SALDO    := TRB1->SALDO
                 WORK1->RESULTADO:= TRB1->RESULTADO                    
                    WORK1->(MSUNLOCK())
                    WORK1->(DBCOMMIT())
                    nTotal++
               ENDIF
          ENDIF
     endif
     TRB1->(DBSKIP())
Enddo                             

TRB1->(DBCLOSEAREA())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCampos que serใo exibidos na tela (Array aCampos)ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Aadd(aCampos, {"PRODUTO" ,,"Cod. Produto"})     
Aadd(aCampos, {"QLOCAL" ,,"Armaz้m"})                                                               
Aadd(aCampos, {"QATU" ,,"Saldo Atual (SB2)"})     
Aadd(aCampos, {"SALDO" ,,"Total Saldo lote (SB8)"})     
Aadd(aCampos, {"RESULTADO" ,,"Diferen็a"})     

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฬฟ
//ณExibe a tela com as diferen็asณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฬู

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 9,0 TO 28,80 OF oMainWnd
     @ 9,01 SAY "Selecione o item e pressione o Botใo Corrigir:" SIZE 232,10 PIXEL OF oDlg
     DBSELECTAREA("WORK1")                                           
     WORK1->(DBGOTOP())
     oMark := MsSelect():New("WORK1",,,aCampos,,,{18,3,125,312})   
    DEFINE SBUTTON oBtnCancel FROM 130,288 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg
     @130,001 SAY "Total de Itens:" SIZE 232,10 PIXEL OF oDlg
     @130,50 SAY nTotal picture "@! 9999999" SIZE 232,10 PIXEL OF oDlg
    @130,100 button "Corrigir" SIZE 34,13 ACTION ExibeLotes() OF oDlg PIXEL 
ACTIVATE MSDIALOG oDlg CENTERED

if select("WORK1") <> 0
     WORK1->(DBCLOSEAREA())
ENDIF


Return .T.                  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณEXIBELOTESบAutor ณRenato S. Parreira บ Data ณ 01/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEXIBE OS LOTES DISPONIVEIS PARA EFETUAR O ACERTO            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function ExibeLotes()                                  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis utilizadas na query de verifica็ใo de dif. SB2 e SB8ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cQuery := ""

Local cFilSB2 := xFilial("SB2")
Local cFilSB8 := xFilial("SB8")
Local cFilSB1 := xFilial("SB1")

Local cArqSB2 := RetSqlName("SB2")
Local cArqSB8 := RetSqlName("SB8")
Local cArqSB1 := RetSqlName("SB1")                               

Local cArqTrab1 := ""
Local lExibeZero := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariแveis utilizadas na tela de exibi็ใo das diferen็asณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local oBtnCancel
Local cTitulo := "Acerto de Lotes"
Local bCancel := {|| oDlgLotes:End(), WORK2->(dbclosearea())} 

Private nTotalLote := 0   
Private nTotalDif := WORK1->QATU - ntotalLote
Private aCampos1 := {}
Private oDlgLotes                             
Private oMarkLotes                                        

IF WORK1->QATU < 0
     MSGSTOP("Favor regularizar Saldo Negativo no SB2 para prosseguir!","Aviso")
     Return .T.
ENDIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ<ฟ
//ณCria arquivo de Trabalho para armazenar os lotesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ<ู

aStruct := {}

Aadd(aStruct, {"LOTECTL","C",AVSX3("B8_LOTECTL",3),0})
Aadd(aStruct, {"NUMLOTE" ,"C",AVSX3("B8_NUMLOTE",3),0})     
Aadd(aStruct, {"QLOCAL" ,"C",AVSX3("B8_LOCAL",3),0})     
Aadd(aStruct, {"SALDO" ,"N",AVSX3("B8_SALDO",3),2})     

cArqTrab1 := CriaTrab(aStruct)

dbUseArea(.T.,,cArqTrab1,"WORK2",.T.,.F.)                    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤpXส0NZฟ
//ณPergunta se exibe lotes zeradosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤpXส0NZู

lExibeZero := msgyesno("Exibe Lotes com Saldos Zerados?","Saldos Por lote")
     
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria query para consulta aos Lotes do produto selecionado na Work1.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQuery := ""
cQuery += "SELECT " + cArqSB8 + ".B8_LOTECTL, "
cQuery += cArqSB8 + ".B8_NUMLOTE, "        
cQuery += cArqSB8 + ".B8_LOCAL, "        
cQuery += cArqSB8 + ".B8_SALDO "        
cQuery += "FROM " + cArqSB8 + " "
cQuery += "WHERE " + cArqSB8 + ".B8_PRODUTO = '" + WORK1->PRODUTO + "' "
cQuery += "AND " + cArqSB8 + ".B8_LOCAL = '" + WORK1->QLOCAL + "' "

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ฟ
//ณFiltra se exibe lotes zerados ou nใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ู

if !lExibeZero
     cQuery += "AND " + cArqSB8 + ".B8_SALDO <> 0 "
endif

cQuery += "AND " + cArqSB8 + ".D_E_L_E_T_ <> '*' "

TcQuery cQuery ALIAS "TRB1" NEW

TRB1->(DBGOTOP())

WHILE TRB1->(!EOF())      
     //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
     //ณAlimenta Work2 com dados da Query para exibi็ใo em browseณ
     //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
     IF RECLOCK("WORK2",.T.)
          WORK2->LOTECTL := TRB1->B8_LOTECTL
          WORK2->NUMLOTE := TRB1->B8_NUMLOTE
          WORK2->QLOCAL := TRB1->B8_LOCAL
          WORK2->SALDO   := TRB1->B8_SALDO
          ntotallote := ntotallote + TRB1->B8_SALDO
          WORK2->(MSUNLOCK())
          WORK2->(DBCOMMIT())
     ENDIF
     TRB1->(DBSKIP())
ENDDO                                        

nTotalDif := WORK1->QATU - ntotalLote
                    
TRB1->(DBCLOSEAREA())

WORK2->(DBGOTOP())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCampos que serใo exibidos na tela (Array aCampos)ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Aadd(aCampos1, {"LOTECTL" ,,"Lote"})     
Aadd(aCampos1, {"NUMLOTE" ,,"Sub-Lote"})                                                               
Aadd(aCampos1, {"QLOCAL" ,,"Armaz้m"})     
Aadd(aCampos1, {"SALDO" ,,"Saldo do Lote"})     



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฬฟ
//ณExibe a tela com as diferen็asณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฬู

DEFINE MSDIALOG oDlgLotes TITLE cTitulo FROM 9,0 TO 31,95 OF oMainWnd
     @010,005 SAY "Cod. Produto: " + WORK1->PRODUTO PIXEL OF oDlgLotes      
     @030,005 SAY "Desc. Produto: " + Posicione("SB1",1,cFilSB1 + WORK1->PRODUTO,"B1_DESC") PIXEL OF oDlgLotes
     @050,005 SAY "Tipo: " + Posicione("SB1",1,cFilSB1 + WORK1->PRODUTO,"B1_TIPO") SIZE 232,10 PIXEL OF oDlgLotes
     @050,050 SAY "Armaz้m: " + WORK1->QLOCAL PIXEL OF oDlgLotes                                    
     @050,100 SAY "Unid. Medida: " + Posicione("SB1",1,cFilSB1 + WORK1->PRODUTO,"B1_UM") SIZE 232,10 PIXEL OF oDlgLotes      
        @070,005 SAY "Total Quantidade SB2 (Saldo Atual): " PIXEL OF oDlgLotes
        @070,150 SAY WORK1->QATU picture "@! 999,999,999.99" PIXEL OF oDlgLotes
        @090,005 SAY "Total Quantidade dos Lotes SB8 (Saldo por Lote): " PIXEL OF oDlgLotes
     @090,150 SAY nTotalLote picture "@! 999,999,999.99" PIXEL OF oDlgLotes                       
     @110,005 SAY "Diferen็a Total (Total SB2 - Total SB8): " PIXEL OF oDlgLotes
     @110,150 SAY nTotalDif picture "@! 999,999,999.99" PIXEL OF oDlgLotes
     DBSELECTAREA("WORK2")                                           
     WORK2->(DBGOTOP())
     oMark := MsSelect():New("WORK2",,,aCampos1,,,{9,185,145,370})   
    DEFINE SBUTTON oBtnCancel FROM 150,340 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlgLotes
    @130,005 button "Modificar Lote" SIZE 68,26 ACTION ModifLotes() OF oDlgLotes PIXEL 
    @130,100 button "Proc. Altera็๕es" SIZE 68,26 ACTION ProcessaAlt() OF oDlgLotes PIXEL 
ACTIVATE MSDIALOG oDlgLotes CENTERED 

if select("WORK2") <> 0
     WORK2->(DBCLOSEAREA())
ENDIF

Return .T.                                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณModifLotesบAutor ณRenato S. Parreira บ Data ณ 01/12/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณModifica saldos dos lotes na Work2 para posterior atualiza- บฑฑ
ฑฑบ          ณ็ใo                                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ModifLotes()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariแveis utilizadas na tela de exibi็ใo do lote       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local oBtnCancel
Local oBtnOk
Local cTitulo := "Acerto do Lote " + WORK2->LOTECTL + " - " + WORK2->NUMLOTE
Local nOpc    := 0
Local bCancel := {|| oDlgAcLote:End(), nOpc := 0} 
Local bOk     := {|| oDlgAcLote:End(), nOpc := 1} 
Local nQatu   := WORK2->SALDO
Local nQnova := WORK2->SALDO 
Local cFilSB1 := xFilial("SB1")

Private oDlgAcLote
Private nBkpTotLote := nTotalLote
Private nBkpTotDif := nTotalDif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ4ฟ
//ณExibe a tela para acertos das diferen็asณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ4ู

DEFINE MSDIALOG oDlgAcLote TITLE cTitulo FROM 9,0 TO 33,40 OF oMainWnd
     @010,005 SAY "Cod. Produto: " + WORK1->PRODUTO PIXEL OF oDlgAcLote
     @030,005 SAY "Desc. Produto: " + Posicione("SB1",1,cFilSB1 + WORK1->PRODUTO,"B1_DESC") PIXEL OF oDlgAcLote
     @050,005 SAY "Tipo: " + Posicione("SB1",1,cFilSB1 + WORK1->PRODUTO,"B1_TIPO") SIZE 232,10 PIXEL OF oDlgAcLote
     @050,050 SAY "Armaz้m: " + WORK1->QLOCAL PIXEL OF oDlgAcLote
     @070,005 SAY "Lote: " + WORK2->LOTECTL PIXEL OF oDlgAcLote
     @070,100 SAY "Sub-Lote: " + WORK2->NUMLOTE PIXEL OF oDlgAcLote
     @090,005 SAY "Quantidade Atual do Lote: " PIXEL OF oDlgAcLote
     @090,080 Get nQatu SIZE 70,10 PICTURE "@! 999,999,999.99" When .F. PIXEL OF oDlgAcLote
     @110,005 SAY "Quantidade a ser Aplicada: " PIXEL OF oDlgAcLote
     @110,080 Get nQNova SIZE 70,10 PICTURE "@! 999,999,999.99" When .T. valid(ValidaQtd(nQnova,nQatu)) PIXEL OF oDlgAcLote
     @130,005 SAY "Soma dos Lotes: " PIXEL OF oDlgAcLote
     @130,080 Get nBkpTotLote SIZE 70,10 PICTURE "@! 999,999,999.99" When .F. PIXEL OF oDlgAcLote
     @150,005 SAY "Diferen็a: " PIXEL OF oDlgAcLote
     @150,080 Get nBkpTotDif SIZE 70,10 PICTURE "@! 999,999,999.99" When .F. PIXEL OF oDlgAcLote
    DEFINE SBUTTON oBtnOk FROM 170,100 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlgAclote
    DEFINE SBUTTON oBtnCancel FROM 170,130 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlgAclote
ACTIVATE MSDIALOG oDlgAclote CENTERED           


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe clicou em Ok, processa atualiza็ใo dos arquivos temporแrios.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
                                                        
if nOpc == 1 .and. nQnova <> nQatu                             
     //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
     //ณGrava saldo atualizado do lote na Work2ณ
     //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
     IF RECLOCK("WORK2",.F.)          
          //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
          //ณAtualiza as variแveis de cแlculo das diferen็asณ
          //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
          if nQnova > nQatu    
               nTotalLote := nTotalLote + (nQnova - nQatu)
          elseif nQnova < nQatu
               nTotalLote := nTotalLote - (nQatu - nQnova)     
          endif                               
          nTotalDif := WORK1->QATU - nTotalLote 
          WORK2->SALDO := nQnova
          WORK2->(MSUNLOCK())
          WORK2->(DBCOMMIT())          
     ENDIF     
endif

Return .T.     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณValidaQtd บAutor ณRenato S. Parreira บ Data ณ 01/12/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida a Quantidade digitada na tela de acerto de lotes.    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidaQtd(nValor,nValor2)                      

Local lRetorno := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValor do lote nใo pode ser negativoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

if(nValor < 0, lRetorno := .F., lRetorno := .T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฉ๐ดฉ๐ฟ
//ณCaso valor Ok, atualiza as variแveis de calculoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฉ๐ดฉ๐ู

if !lRetorno
     msgstop("Quantidade nใo pode ser negativa!","Aviso")
else          
     //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ,ฟ
     //ณAtualiza as variแveis de calculoณ
     //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ,ู
     if nValor > nValor2    
          nBkpTotLote := nTotalLote + (nValor - nValor2)
     elseif nValor < nValor2
          nBkpTotLote := nTotalLote - (nValor2 - nValor)     
     endif                      
     nBkpTotDif := WORK1->QATU - nBkpTotLote 
endif
     
Return(lRetorno)              


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณProcessaAltAutor ณRenato S. Parreira บ Data ณ 01/12/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCompara a Work2 com Saldos no SB8 e realiza os movimentos   บฑฑ
ฑฑบ          ณde acerto no SD5                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcessaAlt()

Local lAchouB8 := .T.
Local lSaldoNeg := .T.
Local nTotWork2 := 0

Private cMovDev := "201"
Private cMovReq := "501"

SB8->(DBSETORDER(2))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica e Valida se Todos os Lotes existem no SB8 e se hแ Quantidade negativaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
WORK2->(DBGOTOP())

WHILE WORK2->(!EOF())     
     //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
     //ณVerifica se existe saldo negativo. Se sim, para processamento.ณ
     //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
     if WORK2->SALDO < 0
          lSaldoNeg := .F.
     else
          nTotWork2 := nTotWork2 + WORK2->SALDO
     endif
     //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
     //ณProcura o Lote no SB8 para verifica็๕esณ
     //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู     
     IF !SB8->(DBSEEK(xFilial("SB8") + WORK2->NUMLOTE + WORK2->LOTECTL + WORK1->PRODUTO + WORK2->QLOCAL))
          lAchouB8 := .F. //Se nใo Achou qualque dos lotes, nใo executa o processamento
     endif                   
     WORK2->(DBSKIP())
ENDDO                                                                     


WORK2->(DBGOTOP())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCaso existam Negativos nos Lotes, Aborta Fun็ใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lSaldoNeg
     MsgAlert("Aten็ใo! Existem Saldo(s) Negativo(s) no(s) Lote(s)! Favor Corrigir!","Aviso")
     Return .T.
endif                                                                                       

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCaso nใo ache algum lote no SB8, Aborta Fun็ใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if !lAchouB8
     MsgStop("Aten็ใo! Lote nใo encontrado no SB8! Contate o Administrador!","Erro")
     Return .T.
endif           

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHฟ
//ณCaso ainda Existam diferen็as entre os saldos, Aborta Fun็ใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHู
if nTotWork2 <> WORK1->QATU
     MsgAlert("Aten็ใo! Existem Diferen็as entre Saldo Atual e Saldos Por Lote! Favor Corrigir!","Aten็ใo")
     Return .T.
endif             

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida o Movimento de Devolu็ใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

IF SF5->(DBSEEK(xFilial("SF5") + cMovDev))
     if Val(cMovDev) > 500
          msgStop("Codigo do Movimento de Dev. Nใo pode ser maior que 500! Contate o Administrador!","Aviso")
          Return .T.
     endif
     if SF5->F5_TIPO <> "D"
          msgstop("Tipo do Movimento de Dev. estแ incorreto! Contate o Administrador!","Aviso")
          Return .T.
     endif
     if SF5->F5_TRANMOD == "S"
          msgstop("Movimento de Dev. Nใo deve movimentar MOD! Contate o Administrador","Aviso")
          Return .T.
     endif        
     if SF5->F5_ENVCQPR == "S"
          msgstop("Movimento de Dev. Nใo deve utilizar o CQ! Contate o Administrador!","Aviso")
          Return .T.
     endif        
     if SF5->F5_LIBPVPR == "S"
          msgstop("Movimento de Dev. Nใo deve Liberar PV! Contate o Administrador!","Aviso")
          Return .T.
     endif
else 
     msgStop("Movimento de Devolu็ใo cadastrado no Parametro MV_DFB2B8D nใo encontrado! Contate o Administrador!","Aviso")
     Return .T.
endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida o Movimento de Requisi็ใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF SF5->(DBSEEK(xFilial("SF5") + cMovReq))
     if Val(cMovReq) <= 500
          msgStop("Codigo do Movimento de Req. Nใo pode ser menor que 500! Contate o Administrador!","Aviso")
          Return .T.
     endif
     if SF5->F5_TIPO <> "R"
          msgstop("Tipo do Movimento de Req. estแ incorreto! Contate o Administrador!","Aviso")
          Return .T.
     endif
     if SF5->F5_TRANMOD == "S"
          msgstop("Movimento de Req. Nใo deve movimentar MOD! Contate o Administrador","Aviso")
          Return .T.
     endif        
     if SF5->F5_ENVCQPR == "S"
          msgstop("Movimento de Req. Nใo deve utilizar o CQ! Contate o Administrador!","Aviso")
          Return .T.
     endif        
     if SF5->F5_LIBPVPR == "S"
          msgstop("Movimento de Req. Nใo deve Liberar PV! Contate o Administrador!","Aviso")
          Return .T.
     endif
else 
     msgStop("Movimento de Requisi็ใo cadastrado no Parametro MV_DFB2B8R nใo encontrado! Contate o Administrador!","Aviso")
     Return .T.
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCaso tenha chegado aqui, estแ ok. Prossegue com a atualiza็ใo dos Saldos Por Loteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

WORK2->(DBGOTOP())
WHILE WORK2->(!EOF())
     //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
     //ณPosiciona no Lote SB8 para compara็ใoณ
     //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู     
     SB8->(DBSEEK(xFilial("SB8") + WORK2->NUMLOTE + WORK2->LOTECTL + WORK1->PRODUTO + WORK2->QLOCAL))
     IF WORK2->SALDO > SB8->B8_SALDO          
          //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
          //ณChama fun็ใo que atualiza o SD5. Caso atualiza็ใo OK, Atualiza Saldo no SB8ณ
          //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
          Begin Transaction
               if CriaMovD5(1)
                    IF RECLOCK("SB8",.F.)
                         SB8->B8_SALDO := WORK2->SALDO
                         SB8->(MSUNLOCK())
                         SB8->(DBCOMMIT())
                    ENDIF             
               endif            
          End Transaction
     ELSEIF WORK2->SALDO < SB8->B8_SALDO
          //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
          //ณChama fun็ใo que atualiza o SD5. Caso atualiza็ใo OK, Atualiza Saldo no SB8ณ
          //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
          Begin Transaction
               if CriaMovD5(2)                   
                    IF RECLOCK("SB8",.F.)
                         SB8->B8_SALDO := WORK2->SALDO
                         SB8->(MSUNLOCK())
                         SB8->(DBCOMMIT())
                    ENDIF          
               endif
          End Transaction
     ENDIF
     WORK2->(DBSKIP())
ENDDO     

                      
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ@ฟ
//ณExclui o registro do WORK1 pois o saldo foi acertadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ@ู
DBSELECTAREA("WORK1")
IF RECLOCK("WORK1",.F.)
     DELETE
     WORK1->(MSUNLOCK())
     WORK1->(DBCOMMIT())                                                        
ENDIF                                                                          

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ4ฟ
//ณFecha a Janela dos Lotes e Fecha o Work2ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ4ู

WORK1->(DBGOTOP())

nTotal--

oMark:oBrowse:Refresh()

oDlgLotes:End() 

IF SELECT("WORK2") <> 0
     WORK2->(DBCLOSEAREA())
ENDIF                           

msgInfo("Saldos Atualizados com สxito!","Ok!")

Return .T.                 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณCriaMovD5 บAutor ณRenato S. Parreira บ Data ณ 01/12/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria Movimentos de Acerto no SD5                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaMovD5(nTipo)

Local lRetorno := .T.                   
Local nNumSeq := 0 
Local cFilSD5 := xFilial("SD5")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBusca o ultimo Sequencial do SD5ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SD5->(DBGOBOTTOM())
nNumSeq := SD5->D5_NUMSEQ           

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGrava o Movimento no SD5 de acordo com o loteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if RecLock("SD5",.T.)
     SD5->D5_FILIAL := cFilSD5
     SD5->D5_PRODUTO := SB8->B8_PRODUTO
     SD5->D5_LOCAL   := SB8->B8_LOCAL
     SD5->D5_DOC     := "DFB2B8"
     SD5->D5_DATA    := DDATABASE
     SD5->D5_NUMSEQ := nNumSeq
     SD5->D5_NUMLOTE := SB8->B8_NUMLOTE
     SD5->D5_LOTECTL := SB8->B8_LOTECTL
     SD5->D5_DTVALID := SB8->B8_DTVALID
     SD5->D5_POTENCI := SB8->B8_POTENCI                                                           
     //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤabOr4T@4T@ฟ
     //ณCaso Tipo = 1, Movimento de Devolu็ใo. Caso Tipo = 2 movimento de Requisi็ใoณ
     //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤabOr<งใ<งใู
     if ntipo == 1
          SD5->D5_QUANT   := WORK2->SALDO - SB8->B8_SALDO
          SD5->D5_ORIGLAN := cMovDev
     elseif nTipo == 2                                
          SD5->D5_QUANT   := SB8->B8_SALDO - WORK2->SALDO
          SD5->D5_ORIGLAN := cMovReq
     endif            
     SD5->(MSUNLOCK())
     SD5->(DBCOMMIT())
else
     lRetorno := .F.
endif               
Return(lRetorno) 
