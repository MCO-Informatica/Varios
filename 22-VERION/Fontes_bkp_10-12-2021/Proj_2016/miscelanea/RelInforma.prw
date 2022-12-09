#include "rwmake.ch"               
#INCLUDE 'PROTHEUS.CH'

User Function RelInforma() //geracao dos relatorio para envio dos informativos

Local oProcess
Local cPerg		:= Padr( "RELINFORM", LEN( SX1->X1_GRUPO ) )
Local aSays		:={}
Local aButtons	:={}
Local nOpca 	:= 0
Local cCadastro := "Envio de Informativos"

Private nReg        := 0
Private aSocios     := {}

AADD(aSays,"Esta rotina tem como objetivo selecionar as ordens de" )
AADD(aSays,"serviços, para analise de horas trabalhadas, conforme parametros selecionados.")

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

ValidPerg(cPerg)
Pergunte(cPerg,.f. )	

FormBatch( cCadastro, aSays, aButtons,, 220, 560 )

If nOpca = 1
	oProcess:= MsNewProcess():New( { |lEnd| OkProces( oProcess, cPerg ) }, "", "", .F. )
	oProcess:Activate()
Endif

Return()


Static Function OkProces( oObj, cPerg )
Local lObj	    := ValType(oObj) == "O"
Local nMAXPASSO := 3

If lObj
	oObj:SetRegua1(nMAXPASSO)
EndIf

If lObj
	oObj:IncRegua1("Criando arquivo de trabalho")  //1
EndIf                                                 

GeraTRB(oObj) //gera arquivo TRB 

If nReg <> 0
  If lObj
	oObj:IncRegua1("Analisando Regras")  //2
  EndIf
  VerRegras(oObj) 
EndIf

If !empty(aSocios)
  TelaSocios() 
 Else
  Alert("Nao ha nenhum Socio a ser enviado Informativo !!!")
EndIf
Return


Static Function GeraTRB(oObj) //gera arquivo TRB 
Local lObj	     := ValType(oObj) == "O"
Local cQuery     := ""
//Local cDtIni     := left(dtos(mv_par01-mv_par02),6)"
//Local cDtFim     := left(dtos(mv_par01-30),6)"

If SELECT("TRB") > 0
	TRB->(dbClosearea())
Endif

cQuery := " SELECT ZA_IDOS NR_OS, ZA_CLIENTE CLIENTE, ZA_LOJA LOJA, ZA_NOME NOME_CLI, SUBSTRING(ZA_EMISSAO,7,2)+'/'+SUBSTRING(ZA_EMISSAO,5,2)+'/'+SUBSTRING(ZA_EMISSAO,1,4) EMISSAO, ZA_HORAINI HORA_OS,"
cQuery += "        SUBSTRING(ZA_DTINICI,7,2)+'/'+SUBSTRING(ZA_DTINICI,5,2)+'/'+SUBSTRING(ZA_DTINICI,1,4) DT_INICIO,"
cQuery += "        SUBSTRING(ZA_DTPREVI,7,2)+'/'+SUBSTRING(ZA_DTPREVI,5,2)+'/'+SUBSTRING(ZA_DTPREVI,1,4) DT_PREVISAO,"
cQuery += "        ZA_PEDVEND PEDIDO,"
cQuery += " 	   CASE ZA_TIPO "
cQuery += " 	     WHEN '1' THEN 'CONSERTO'"
cQuery += "          WHEN '2' THEN 'ESTOQUE'"
cQuery += "          WHEN '3' THEN 'MANUTENCAO'"
cQuery += "          WHEN '4' THEN 'MONTAGEM'"
cQuery += " 	     WHEN '5' THEN 'TRANSFORMACAO'"
cQuery += "          WHEN '6' THEN 'USINAGEM'"
cQuery += "          WHEN '7' THEN 'FABRICA'"
cQuery += " 		 ELSE ' '"
cQuery += " 	   END  OPERACAO,"
cQuery += " 	   ZA_VEND VENDEDOR,ZA_NOMVED NOME_VEND, "
cQuery += " 	   CASE ZA_STATUS"
cQuery += "          WHEN 'E' THEN 'ENCERRADO'"
cQuery += "          WHEN 'S' THEN 'SEPARACAO'"
cQuery += "          WHEN 'J' THEN 'PENDENTE'"
cQuery += "          WHEN 'O' THEN 'APONTAMENTO FABRICA'"
cQuery += "          WHEN 'M' THEN 'RECUSA FABRICA'"
cQuery += "          WHEN 'C' THEN 'ENCERRADO FABRICA'"
cQuery += "          WHEN 'R' THEN 'RECUSA ALMOX'"
cQuery += "          WHEN 'L' THEN 'APROVADO'"
cQuery += " 		 WHEN 'P' THEN 'PENDENTE FABRICA'"
cQuery += " 		 WHEN ' ' THEN 'INCLUSAO'"
cQuery += "          ELSE 'NAO ENCONTRADO'"
cQuery += " 	   END OS_STATUS,"
cQuery += " 	   SUBSTRING(ZE_EMISSAO,7,2)+'/'+SUBSTRING(ZE_EMISSAO,5,2)+'/'+SUBSTRING(ZE_EMISSAO,1,4) AP_EMISSAO,"
cQuery += " 	   ZE_HORAINI AP_HORAINI,"
cQuery += " 	   SUBSTRING(ZE_DTFIM,7,2)+'/'+SUBSTRING(ZE_DTFIM,5,2)+'/'+SUBSTRING(ZE_DTFIM,1,4) AP_DT_FIM,"
cQuery += " 	   ZE_HORAFIM AP_HORAFIM,ZE_FUNC FUNCIONARIO, ZE_NOME NOME_FUNC,ZE_OBS OBS "
cQuery += " FROM " + RetSqlName("SZE") + " ZE  "
cQuery += " INNER JOIN " + RetSqlName("SZA") + " ZA ON ZA_FILIAL = ZE_FILIAL AND ZA_IDOS = ZE_IDOS AND ZA.D_E_L_E_T_ = '' "
cQuery += " WHERE ZE.D_E_L_E_T_ = '' AND ZE_IDOS <> '' "
cQuery += " ORDER BY ZE_IDOS,ZE_EMISSAO,ZE_HORAINI "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,, cQuery ), "TRB", .F., .T. )

dbSelectArea( "TRB" )
DbGoTop()
bAcao:= {|| nReg ++ }
dbEval(bAcao,,{||!Eof()},,,.T.)
dbSelectArea("TRB") 
dbGotop()

Return


Static Function VerRegras(oObj)

Local lObj	     := ValType(oObj) == "O"
Local cCliente   := ""
Local lOk        := .T.

If lObj
	oObj:SetRegua2(nReg)
Endif

dbSelectArea("TRB") 
dbGotop()

While !eof()                    
// tratamento de hora de inicio e final respeitando data e qtde de horas 
      OS  := "."+TRB->NR_OS     
      CLI := "."+TRB->CLIENTE 
      LOJ := "."+TRB->LOJA 
      NOM := TRB->NOME_CLI
      EMI := TRB->EMISSAO
      HOS := TRB->HORA_OS 
      DTI := STOD(TRB->DT_INICIO)
      DTP := STOD(TRB->DT_PREVISAO)
      PED := "."+TRB->PEDIDO 
      OPE := TRB->OPERACAO
      VED := "."+TRB->VENDEDOR 
      VNO := TRB->NOME_VEND
      STA := TRB->OS_STATUS
      APE := STOD(TRB->AP_EMISSAO)
      HAI := TRB->AP_HORAINI 
      DTF := STOD(TRB->AP_DT_FIM)
      HRF := TRB->AP_HORAFIM 
      FUC := "."+TRB->FUNCIONARIO 
      NFC := IIF(SUBSTR(TRB->NOME_FUNC,1,1)='-',SUBSTR(TRB->NOME_FUNC,2,20),TRB->NOME_FUNC)
      OBS := TRB->OBS                                                    

   	 If lObj
	   oObj:IncRegua2("Analisando Regras ")   
	 Endif

     dbSelectArea("TRB") 
      
     If lOk 
        aadd(aSocios,{OS,CLI,LOJ,NOM,EMI,HOS,DTI,DTP,PED,OPE,VED,VNO,STA,APE,HAI,DTF,HRF,FUC,NFC,OBS})
     EndIf

     dbSelectArea("TRB") 
     DBSKIP()
End 

If SELECT("TRB") > 0
	TRB->(dbClosearea())
Endif

Return

Static Function ValidPerg(cPerg)
sAlias := Alias()
aRegs  := {}
i      := j := 0

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

//GRUPO,ORDEM,PERGUNTA              ,PERGUNTA,PERGUNTA,VARIAVEL,TIPO,TAMANHO,DECIMAL,PRESEL,GSC,VALID,VAR01,DEF01,DEFSPA01,DEFING01,CNT01,VAR02,DEF02,DEFSPA02,DEFING02,CNT02,VAR03,DEF03,DEFSPA03,DEFING03,CNT03,VAR04,DEF04,DEFSPA04,DEFING04,CNT04,VAR05,DEF05,DEFSPA05,DEFING05,CNT05,F3,GRPSXG
AADD(aRegs,{cPerg,"01","DA EMISSAO      ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","ATE EMISSAO     ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(sAlias)

Return

Static Function TelaSocios()
Local aSize    := {}
Local aObjects := {}
Local aInfo    := {}
Local cCabec   := "Horarios "
Local oOk      := LoadBitmap( GetResources(), "BR_VERDE" )
Local oNo      := LoadBitmap( GetResources(), "BR_VERMELHO" )


Private aPosObj  := {}
Private oDlg2
Private oListBox2, bLine2
Private cTitulo2 := "Horarios"
Private cLine2   := "{ aSocios[oListBox2:nAt][1] "  
Private aHead_2  := {"OS","Codigo","Loja","Nome","Emissao","Hora_OS","Dt_Inicio","Dt_Previsao","Pedido","Operacao","Vendedor","Nome","Status",;
                     "Apont_Emissao","Apont_Hora_Ini","Apont_Dt_Fim","Apont_Hora_Fim","Funcionario","Nome","Observacao"}

For nI:=2 To Len(aHead_2)
	cLine2 += " ,aSocios[oListBox2:nAt][" + AllTrim(Str(nI)) + "]"
Next
cLine2 += "}"
bLine2 := &( "{|| " + cLine2 + "}" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Dialog...                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSize    := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 1, .F., .T., .F. } )
AAdd( aObjects, { 1, 1, .T., .T., .F. } )

aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects, .t., .t. )
aPosObj[2][3] -= 14

DEFINE MSDIALOG oDlg2 TITLE cTitulo2 FROM aSize[7],0 TO aSize[6],aSize[5] OF GetWndDefault() Pixel
SButton():New(aPosObj[2][3] + 3, aPosObj[2][4] - 30 , 01 , { || oDlg2:End() }, oDlg2, .T. )
tButton():New(aPosObj[2][3] + 3,aPosObj[2][4] - 250, "Excel", , { || MsAguarde ( { || DlgToExcel({ {"ARRAY",cCabec,aHead_2,aSocios} }) } )}, 085, 010 ,,,,.T.)

oListBox2 := TWBrowse():New( aPosObj[2][1],aPosObj[2][2]-100,aPosObj[2][4]-10,aPosObj[2][3]-20,,aHead_2,,oDlg2,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox2:SetArray(aSocios)
oListBox2:bLine := bLine2

ACTIVATE DIALOG oDlg2  CENTERED

Return