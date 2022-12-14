#include "rwmake.ch"               
#INCLUDE 'PROTHEUS.CH'

User Function ESTRVERM() 

Local oProcess
Local cPerg		:= Padr( "ESTRVERMU", LEN( SX1->X1_GRUPO ) )
Local aSays		:={}
Local aButtons	:={}
Local nOpca 	:= 0
Local cCadastro := "Estruturas Bloqueadas (Pasta Vermelha)"

Private nReg        := 0
Private aSocios     := {}

AADD(aSays,"Esta rotina tem como objetivo gerar informacoes de" )
AADD(aSays,"das Estruturas Bloqueadas (( Pasta Vermelha )). ")

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

//ValidPerg(cPerg)
//Pergunte(cPerg,.f. )	

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
  Alert("Nao ha nenhum registro a ser enviado Informativo !!!")
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

cQuery := " SELECT G1_COD,G1_COMP,
cQuery += "       (CASE B1A.B1_MSBLQL
cQuery += " 	   WHEN '1' THEN 'SIM'
cQuery += "		   WHEN '2' THEN 'NAO'
cQuery += "	   	   ELSE 'NAO'
cQuery += "	   	   END) 'BLOQUEADO',
cQuery += "	  	  (CASE B1A.B1_ESTRUT 
cQuery += "	   	    WHEN '1' THEN 'KIT'
cQuery += "	        WHEN '2' THEN 'SUB_KIT'
cQuery += "	        ELSE 'PECA'
cQuery += "	        END)'ESTRUTURA'
cQuery += "FROM " + RetSqlName("SG1") + " G1 (NOLOCK) "
cQuery += "INNER JOIN " + RetSqlName("SB1") + "  B1 (NOLOCK) ON B1_COD = G1_COD AND B1_MSBLQL <> '1' AND B1.D_E_L_E_T_ = '' "
cQuery += "INNER JOIN " + RetSqlName("SB1") + "  B1A (NOLOCK) ON B1A.B1_COD = G1_COMP AND B1A.D_E_L_E_T_ = '' "
cQuery += "WHERE G1_FIM <= '" + DTOS(DDATABASE) + "' AND G1.D_E_L_E_T_ = '' "
cQuery += "ORDER BY 4,1 "

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
	  __CCOD := TRB->G1_COD
	  __CCMP := TRB->G1_COMP
	  __CBLO := TRB->BLOQUEADO
	  __CEST := TRB->ESTRUTURA

   	 If lObj
	   oObj:IncRegua2("Analisando Regras ")   
	 Endif

     dbSelectArea("TRB") 
      
     If lOk 
        aadd(aSocios,{CHR(160)+__CCOD,CHR(160)+__CCMP,__CBLO,__CEST})
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
AADD(aRegs,{cPerg,"01","Da Emissao      ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Emissao     ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Do Vendedor     ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA3","",""})
AADD(aRegs,{cPerg,"04","Ate Vendedor    ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA3","",""})
AADD(aRegs,{cPerg,"05","Do Cliente      ?","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA1","",""})
AADD(aRegs,{cPerg,"06","Ate Cliente     ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA1","",""})

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
Local cCabec   := "Estruturas Bloqueads (( Pasta Vermelha ))"
Local oOk      := LoadBitmap( GetResources(), "BR_VERDE" )
Local oNo      := LoadBitmap( GetResources(), "BR_VERMELHO" )


Private aPosObj  := {}
Private oDlg2
Private oListBox2, bLine2
Private cTitulo2 := "Estruturas Bloqueads (( Pasta Vermelha ))"
Private cLine2   := "{ aSocios[oListBox2:nAt][1] "  
Private aHead_2  := {"Codigo_PA","Componente","Bloqueado","Estrutura"}

For nI:=2 To Len(aHead_2)
	cLine2 += " ,aSocios[oListBox2:nAt][" + AllTrim(Str(nI)) + "]"
Next
cLine2 += "}"
bLine2 := &( "{|| " + cLine2 + "}" )

//????????????????????????????????????????????????????????????????????????????
//? Monta Dialog...                                                          ?
//????????????????????????????????????????????????????????????????????????????
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

oListBox2 := TWBrowse():New( aPosObj[2][1]-32,aPosObj[2][2]-105,aPosObj[2][4],aPosObj[2][3],,aHead_2,,oDlg2,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oListBox2:SetArray(aSocios)
oListBox2:bLine := bLine2

ACTIVATE DIALOG oDlg2  CENTERED

Return