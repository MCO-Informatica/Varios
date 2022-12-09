#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Arquivo   ³RFINM01   ³Autor  ³Cosme da Silva Nunes   ³Data  ³02/02/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Arquivo com os programas de validacao do arquivo CNAB mod. 2³±±
±±³          ³do Banco do Brasil                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Financeiro -   Baesa                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
/*/

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Rdmake    ³BB01      ³Autor  ³Cosme da Silva Nunes   ³Data  ³22/03/2004³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡ao ³Zera o parametro com o numero sequencial do reg. no lote    ³
³          ³Esta rotina deve ser executada na chamada da rotina FINA420,³
³          ³que eh disparada por esta. Substituir a chamada da rotina   ³
³          ³FINA420 em todos os menus para BB01.                        ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
User Function BB01()
Private _cRegLt := "00000"
PutMV("MV_CNABRL",_cRegLt)
FINA420()
Return()

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Rdmake    ³BB02      ³Autor  ³Cosme da Silva Nunes   ³Data  ³02/02/2004³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡ao ³Numero sequencial do registro no lote                       ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/

User Function BB02() 

_cRegLt := StrZero(Val(GetMV("MV_CNABRL"))+1,5)
PutMV("MV_CNABRL",_cRegLt)
Return(_cRegLt)

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Rdmake    ³BB03      ³Autor  ³Cosme da Silva Nunes   ³Data  ³31/03/2004³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡ao ³Recebe digito verificador codigo de barras / linha digitavel³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
User Function BB03()

SetPrvt("cDigVer")

If Len(Alltrim(SE2->E2_CODBAR)) == 44
	cDigVer := Substr(SE2->E2_CODBAR,5,1)
Else
	If Len(Alltrim(SE2->E2_CODBAR)) > 44
		cDigVer := Substr(SE2->E2_CODBAR,33,1)
	EndIf
EndIf	

Return(cDigVer)

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Rdmake    ³BB04      ³Autor  ³Cosme da Silva Nunes   ³Data  ³31/03/2004³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡ao ³Extrai campo livre codigo de barras / linha digitavel       ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
User Function BB04()

SetPrvt("cCF")

If Len(Alltrim(SE2->E2_CODBAR)) == 44
	cCF := Substr(SE2->E2_CODBAR,20,25)
Else
	If Len(Alltrim(SE2->E2_CODBAR)) > 44
		cCF := Substr(SE2->E2_CODBAR,5,5)
		cCF += Substr(SE2->E2_CODBAR,11,10)
		cCF += Substr(SE2->E2_CODBAR,22,10)
	EndIf	
EndIf	

Return(cCF)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Arquivo   ³CPFPrep   ³Autor  ³Cosme da Silva Nunes   ³Data  ³08/12/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Programa p/ criacao de interface p/ atualizacao do parametro³±±
±±³          ³de usuario utilizado no CNAB pagamento tipo ordem de pagto  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Financeiro -   Baesa                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
/*/

User Function CPFPrep()

Private oDlg 		:= Nil
Private cTitulo 	:= OemToAnsi("Inf. CPF prepostos - CNAB Ordem Pagto")
Private cLabel1 	:= OemToAnsi("CPF Preposto 1:")
Private cLabel2 	:= OemToAnsi("CPF Preposto 2:")
Private cCPFPrp1 	:= Space(11)
Private cCPFPrp2 	:= Space(11)
Private lT	 		:= .F.
cCPFPrp1 	:= If(Empty(GetMV("MV_CPFPRP1")),Space(11),GetMV("MV_CPFPRP1"))
cCPFPrp2 	:= If(Empty(GetMV("MV_CPFPRP2")),Space(11),GetMV("MV_CPFPRP2"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao da Interface                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 088,178 To 390,478 Dialog oDlg Title cTitulo

	@ 15,15 Say cLabel1 Size 40,10
	@ 40,15 Say cLabel2 Size 40,10

	@ 15,60 Get cCPFPrp1 Picture "@R 999.999.999-99" Size 70,10 //Picture "@R 999.999.999-99" 
	@ 40,60 Get cCPFPrp2 Picture "@R 999.999.999-99" Size 70,10 //Picture "@R 999.999.999-99" 
	
	@ 127, 37 BmpButton Type 01 Action Eval( {||lT:=.T.,  oDlg:End() }	)
	@ 127, 85 BmpButton Type 02 Action Eval( {||oDlg:End() } 		  	)

Activate Dialog oDlg Centered

If lT
	PutMV("MV_CPFPRP1",cCPFPrp1)
	PutMV("MV_CPFPRP2",cCPFPrp2)
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CNABPG    ºAutor  ³Ricardo Nunes       º Data ³  06/13/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para ira retornar o codigo do tipo de pagamento do   º±±
±±º          ³Banco BankBoston de acordo com o manual do banco.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CNAB A PAGAR AP                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CNABPG(_cParam)

Local _cRet:="000"

If _cParam == "TP"
	_cRet := If(SA2->A2_BANCO=="479","CC ",If(EMPTY(SE2->E2_CODBAR),"DOC","COB"))			     
ElseIf _cParam == "CC"
	If !Empty(SE2->E2_MODSPB)
		_cRet := If(SA2->A2_BANCO=="479","000",If(SE2->E2_MODSPB $("2,3"),"700","018"))
	Else
		If SA2->A2_BANCO <> "479"
			If SE2->E2_SALDO < 5000
				_cRet := "700"					// DOC
			Else
				_cRet := "018"					// TED
			EndIf
		Else
			_cRet := "000"						// Credito Conta Corrente
		EndIf
	EndIf
Endif

Return(_cRet)

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Rdmake    ³BB03      ³Autor  ³Jeremias Lameze Junior ³Data  ³08/04/2002³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descricao ³Transformacao da Linha digitavel em codigo de barra         ³
ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³           Atualiza‡oes sofridas desde a constru‡ao inicial            ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Programador ³Data      ³Motivo da Altera‡ao                            ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Cosme da    |26/03/2004|Personaliza‡ao para o projeto AAPAS            ³
³Silva Nunes |          |	                                            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function BB03()

SetPrvt("_cRetorno")
SetPrvt("CSTR,I,NMULT,NMODULO,CCHAR")
SetPrvt("CDIGITO,CDV1,CDV2,CDV3,CCAMPO1,CCAMPO2")
SetPrvt("CCAMPO3,NVAL,NCALC_DV1,NCALC_DV2,NCALC_DV3,NREST")

_cRetorno := ''

if ValType(SE2->E2_LINHDIG) == NIL
  Return(_cRetorno)      
Endif

cStr := SE2->E2_LINHDIG

i := 0
nMult := 2
nModulo := 0
cChar   := SPACE(1)
cDigito := SPACE(1)

cDV1    := SUBSTR(cStr,10, 1) 
cDV2    := SUBSTR(cStr,21, 1) 
cDV3    := SUBSTR(cStr,32, 1) 
   
cCampo1 := SUBSTR(cStr, 1, 9)
cCampo2 := SUBSTR(cStr,11,10)
cCampo3 := SUBSTR(cStr,22,10)

nMult   := 2
nModulo := 0
nVal    := 0
   
// Calcula DV1

For i := Len(cCampo1) to 1 Step -1
  cChar := Substr(cCampo1,i,1)
  If isAlpha(cChar)
    Help(" ", 1, "ONLYNUM")
    Return(_cRetorno) 
  endif
  nModulo := Val(cChar)*nMult
  If nModulo >= 10
    nVal := NVAL + 1
    nVal := nVal + (nModulo-10)
  Else
    nVal := nVal + nModulo	
  EndIf	
  nMult:= if(nMult==2,1,2)
Next        
nCalc_DV1 := 10 - (nVal % 10)

//Calcula DV2

nMult   := 2
nModulo := 0
nVal    := 0
   
For i := Len(cCampo2) to 1 Step -1
  cChar := Substr(cCampo2,i,1)
  If isAlpha(cChar)
    Help(" ", 1, "ONLYNUM")
      Return(_cRetorno)
  endif        
  nModulo := Val(cChar)*nMult
  If nModulo >= 10
    nVal := nVal + 1
	nVal := nVal + (nModulo-10)
  Else
	nVal := nVal + nModulo	
  EndIf	
	nMult:= if(nMult==2,1,2)
Next        
nCalc_DV2 := 10 - (nVal % 10)

// Calcula DV3

nMult   := 2
nModulo := 0
nVal    := 0
   
For i := Len(cCampo3) to 1 Step -1
  cChar := Substr(cCampo3,i,1)
  if isAlpha(cChar)
    Help(" ", 1, "ONLYNUM")
    Return(_cRetorno)
  endif        
  nModulo := Val(cChar)*nMult
  If nModulo >= 10
	nVal := nVal + 1
	nVal := nVal + (nModulo-10)
  Else
	nVal := nVal + nModulo	
  EndIf	
    nMult:= if(nMult==2,1,2)
Next        
nCalc_DV3 := 10 - (nVal % 10)                      

If nCalc_DV1 == 10
  nCalc_DV1 := 0  
EndIf
If nCalc_DV2 == 10
  nCalc_DV2 := 0  
EndIf
If nCalc_DV3 == 10
  nCalc_DV3 := 0  
EndIf

if !(nCalc_DV1 == Val(cDV1) .and. nCalc_DV2 == Val(cDV2) .and. nCalc_DV3 == Val(cDV3) )
  Help(" ",1,"INVALCODBAR")
  Return(_cRetorno)
endif                
   
_cRetorno := SUBSTR(cStr, 1, 4)+SUBSTR(cStr, 33, 1)+iif(Len(alltrim(SUBSTR(cStr, 34, 14)))<14,StrZero(Val(Alltrim(SUBSTR(cStr, 34, 14))),14),SUBSTR(cStr, 34, 14))+SUBSTR(cStr, 5, 5)+SUBSTR(cStr, 11, 10)+SUBSTR(cStr, 22, 10)
Return(_cRetorno)

// Calcula DV3

nMult   := 2
nModulo := 0
nVal    := 0
   
For i := Len(cCampo3) to 1 Step -1
  cChar := Substr(cCampo3,i,1)
  if isAlpha(cChar)
    Help(" ", 1, "ONLYNUM")
    Return(_cRetorno)
  endif        
  nModulo := Val(cChar)*nMult
  If nModulo >= 10
	nVal := nVal + 1
	nVal := nVal + (nModulo-10)
  Else
	nVal := nVal + nModulo	
  EndIf	
    nMult:= if(nMult==2,1,2)
Next        
nCalc_DV3 := 10 - (nVal % 10)                      

If nCalc_DV1 == 10
  nCalc_DV1 := 0  
EndIf
If nCalc_DV2 == 10
  nCalc_DV2 := 0  
EndIf
If nCalc_DV3 == 10
  nCalc_DV3 := 0  
EndIf

if !(nCalc_DV1 == Val(cDV1) .and. nCalc_DV2 == Val(cDV2) .and. nCalc_DV3 == Val(cDV3) )
  Help(" ",1,"INVALCODBAR")
  Return(_cRetorno)
endif                
   
_cRetorno := SUBSTR(cStr, 1, 4)+SUBSTR(cStr, 33, 1)+iif(Len(alltrim(SUBSTR(cStr, 34, 14)))<14,StrZero(Val(Alltrim(SUBSTR(cStr, 34, 14))),14),SUBSTR(cStr, 34, 14))+SUBSTR(cStr, 5, 5)+SUBSTR(cStr, 11, 10)+SUBSTR(cStr, 22, 10)
Return(_cRetorno)
/*/



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Arquivo   ³ CNABPER ³Autor  ³ J.Marcelino Correa   ³Data  ³ 12.01.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gravacao do percentual da taxa para envio ao banco  -  CNAB³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Financeiro -   Baesa                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
/*/
User Function CNABPER()
Local cRet := "0"

cNatureza := SubStr(SE2->E2_NATUREZ,1,7)
dbSelectArea("SED")
dbSetOrder(1)
dbSeek(xFilial("SED")+cNatureza)
Do Case
Case SubStr(SE2->E2_NATUREZ,8,3) == "001"						//	IRRF
	//cRet := StrZero(ED_PERCIRF,5)
	cRet := Round(xMoeda(SED->ED_PERCIRF,SE2->E2_MOEDA,1),2)*100
Case SubStr(SE2->E2_NATUREZ,8,3) == "002"						//	PIS
	//cRet := StrZero(ED_PERCPIS,5)
	cRet := Round(xMoeda(SED->ED_PERCPIS,SE2->E2_MOEDA,1),2)*100
Case SubStr(SE2->E2_NATUREZ,8,3) == "003"						//	COFINS
	//cRet := StrZero(ED_PERCCOF,5)
	cRet := Round(xMoeda(SED->ED_PERCCOF,SE2->E2_MOEDA,1),2)*100
Case SubStr(SE2->E2_NATUREZ,8,3) == "004"						//	CSLL
	//cRet := StrZero(ED_PERCCSL,5)
	cRet := Round(xMoeda(SED->ED_PERCCSL,SE2->E2_MOEDA,1),2)*100
Case SubStr(SE2->E2_NATUREZ,8,3) == "005"						//	INSS
	//cRet := StrZero(ED_PERCINS,5)
	cRet := Round(xMoeda(SED->ED_PERCINS,SE2->E2_MOEDA,1),2)*100
Case SubStr(SE2->E2_NATUREZ,8,3) == "006"						//	ISS
	//cRet := StrZero(GetMV("MV_ALIQISS"),5)
	nAliqISS	:= GetMV("MV_ALIQISS")
	cRet			:= Round(xMoeda(nAliqISS,SE2->E2_MOEDA,1),2)*100
EndCase

Return cRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Arquivo   ³ CNABAPUR ³Autor  ³ J.Marcelino Correa   ³Data  ³ 12.01.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Gravacao da data de apuracao do DARF para envio ao banco  -  CNAB³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Financeiro -   Baesa                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
/*/
User Function CNABAPUR()
cDtApur1	:= SubStr(DtoS(dDataBase),7,2)+SubStr(DtoS(dDataBase),5,2)+SubStr(DtoS(dDataBase),1,4)
//cDtApur2	:= SubStr(DtoS(SE2->E2_DTAPUR),7,2)+SubStr(DtoS(SE2->E2_DTAPUR),5,2)+SubStr(DtoS(SE2->E2_DTAPUR),1,4)
cDtApur2	:= SubStr(DtoS(SE2->E2_EMISSAO),7,2)+SubStr(DtoS(SE2->E2_EMISSAO),5,2)+SubStr(DtoS(SE2->E2_EMISSAO),1,4)
cRet := Iif(Empty(cDtApur2),cDtApur1,cDtApur2)

Return cRet



