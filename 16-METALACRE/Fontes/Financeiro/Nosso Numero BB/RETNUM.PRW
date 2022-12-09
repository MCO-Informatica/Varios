/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SCNABMET  ºAutor  ³Ricardo Sancar      º Data ³  25/03/12   º±±
±±  Contato                                                                ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcoes utilizadas no CNAB                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±ºUso       ³ Metalacre                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function RETNUM()

LOCAL CVARI
LOCAL DDATA := DTOC(DATE())
LOCAL CMES  := SUBSTR(DDATA,4,2)
LOCAL CIMPUT := ""
//LOCAL CMESMV := GETMV("MV_MESLOTE")   
LOCAL NCONT  := GETMV("MV_NUMLOTE") 
//PRIVATE aArea := GetArea()
PRIVATE TipoLote
PRIVATE cCod


//CMESMV := CVALTOCHAR(CMESMV)
//CMESMV := PADL(CMESMV,2,"0")

//PUTMV("MV_NUMLOTE", 0000)
//CMES := VAL(CMES)
//PUTMV("MV_MESLOTE", CMES)
//NCONT := 0000	

NCONT := NCONT + 1
PUTMV("MV_NUMLOTE", NCONT) 

//NCONT := CVALTOCHAR(NCONT) 
//NCONT := PADL(NCONT,4,"0")

//CVARI := "AK" + SUBSTR(DDATA,7,2) + SUBSTR(DDATA,4,2) + NCONT
CVARI := STR(NCONT)
CIMPUT := PADL(ALLTRIM(CVARI),10,"0")
//RestArea(aArea) 

Return(CIMPUT)






/// -> Contador de Registros para o CNAB do Banco do Brasil

User Function IncNum()
Static nRet := 1

If Type("lFim") == "U"
	Public lFim := .t.
Endif

nRet++

cRet := strzero(nRet,6)

If lFim
	nRet := 0
	lFim := .f.
Endif

Return cRet



/// -> Converte Linha Digitavel para Codigo de Barras

User Function LinCb(cLinDig)
Local aArea := GetArea()
Local cBarPag := Space(44)

cBarPag := ''
cBarPag += Left(AllTrim(cLinDig),3)	// Banco
cBarPag += SubStr(AllTrim(cLinDig),4,1)	// Moeda
cBarPag += SubStr(AllTrim(cLinDig),33,1)	// Dac
cBarPag += SubStr(AllTrim(cLinDig),34,14)	// Fator de Vencimento e Valor
cBarPag += SubStr(AllTrim(cLinDig),5,5)// Campo Livre
cBarPag += SubStr(AllTrim(cLinDig),7,10)// Campo Livre
cBarPag += SubStr(AllTrim(cLinDig),22,10)// Campo Livre

//Alert(cBarPag)

RestArea(aArea)
Return cBarPag






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SCNABMET  ºAutor  ³Ricardo Sancar      º Data ³  25/03/12   º±±
±±  Contato                                                                ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcoes utilizadas no CNAB                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±ºUso       ³ Metalacre                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function NNBB()
Local cNnum := ''

If Empty(SE1->E1_NUMBCO)
	NossoNum()
	cNnum     := AllTrim(SEE->EE_CODEMP)+Right(AllTrim(SE1->E1_NUMBCO),10)
	
	If RecLock("SE1",.f.)
		SE1->E1_NUMBCO	:=	cNnum
		SE1->(MsUnlock())
	Endif
Else
	cNnum := SE1->E1_NUMBCO
Endif
Return(cNnum)
