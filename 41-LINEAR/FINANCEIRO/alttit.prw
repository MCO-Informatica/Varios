#include "rwmake.ch"
#include "colors.ch"

User function CTXF011()

Local aCores  := {{"E2_VALOR <> E2_SALDO .AND. E2_SALDO <> 0" , 'BR_AZUL' },;
{ "E2_SALDO > 0", 'ENABLE'         },;
{ "E2_NUMBOR <> ' ' ",'BR_PRETO'     },;
{ "E2_SALDO == 0",'DISABLE'     }}

Local aArea := GetArea()

Private cCadastro := "Manutencao dos Titulos a Pagar"

Private aRotina := {{"Pesquisar"  	,"AxPesqui"	   ,0,1},;
{"Visualizar"  	,"AxVisual"	   ,0,2},;
{"Manutencao"	,"u_Manut"     ,0,5},;
{"Legenda"  	,"u_xLegenda"  ,0,6} }


dbSelectArea("SE2")
dbSetOrder(1)

dbGoTop()

SET FILTER TO (SE2->E2_VALOR <> 0 .and. SE2->E2_VALOR == SE2->E2_SALDO)     //(SE2->E2_NUMBOR =="")  //FILTRO PARA PEGAR SOMENTE

mBrowse( 6,1,22,75,"SE2",,,,,,aCores)

SET FILTER TO

RestArea(aArea)

Return

User Function xLegenda()

BrwLegenda(cCadastro,"Legenda",;
{ { 'BR_AZUL', 'Titulo Parcialmente Baixado'},;
{ 'ENABLE', 'Titulo em Aberto'},;
{ 'BR_PRETO', 'Titulo em Bordero'},;
{ 'DISABLE', 'Titulo Baixado' }})

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100GE2  �Autor  �Rogerio Costa       � Data �  02/06/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para alterar titulos a pagar.              ���
�������������������������������������������������������������������������͹��
���Uso       � Contemp                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Manut

Local _aForPg  :={"DOC/TED","CHEQUE","COBRANCA","CREDITO C/C","CARTAO","DEPOSITO","WIRE TRANSFER","BOLETO"}
Local _aMODSPB := {"","TED","CIP","COMP"}
Local _cArqAtu  := GetArea()
//Local _cArqSD1  := GetArea("SD1")
PUBLIC _cForPg  := "BOLETO"
PUBLIC _cBarra  := SPACE(48)
PUBLIC _cHist   := SPACE(40)
PUBLIC _cLinDig := SPACE(48)
PRIVATE _cRet    :=  .T.
PUBLIC _cMODSPB := ""
PUBLIC _nValor := 0 //Picture "@99,999,999.99"
PUBLIC _nValAcresc := 0
PUBLIC _nValDecresc := 0
PUBLIC dVenc := CTOD("")
PUBLIC cDados := alltrim(SE2->E2_NOMFOR)//SE2->E2_VALOR
PUBLIC nValor := SE2->E2_VALOR


/*dbSelectArea("SD1")
dbSetOrder(1)
_cChave := SE2->E2_FILIAL+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA
MsSeek(_cChave)*/

@ 100,001 To 390,350 Dialog oDlg Title "Confirma Codigo de Barras"
@ 003,010 To 140,167
@ 005,014 Say OemToAnsi("Fornecedor/Valor " )
@ 005,080 Say cDados  SIZE 060,10
@ 005,120 Say nValor  Picture "@E 999,999.99" SIZE 060,10
@ 015,014 Say OemToAnsi("Cod. Barras") 
@ 015,050 Get _cBarra PICTURE "@!S48" valid (U_nTam())   //@ 014,050 Get _cBarra PICTURE "@!S48"
@ 030,014 Say OemToAnsi("Linha Digitavel")	Size 36,8
@ 030,050 Get _cLinDig Picture "@!S48"  valid (U_cBarCod(),U_nTam1()) //Size 80,21
@ 050,014 Say OemToAnsi("Vlr.Acrescimo")	Size 36,8
@ 050,050 Get _nValAcresc Picture "@E 999,999.99" Size 80,21
@ 070,014 Say OemToAnsi("Vlr.Decrescimo")	Size 36,8
@ 070,050 Get _nValDecresc Picture "@E 999,999.99" Size 80,21
@ 085,014 Say OemToAnsi("Vencimento Real")
@ 085,090 Get dVenc SIZE 35,10 
@ 104,014 Say OemToAnsi("Hist�rico")
@ 104,050 Get _cHist PICTURE "@!S40" Size 110,21
@ 120,100 BMPBUTTON TYPE 01 ACTION xInc()
@ 120,130 BmpButton Type 02 Action Close(oDlg)
Activate Dialog oDlg Centered

//RestArea(_cArqSD1)
//RestArea(_cArqAtu)
Return(_cRet)                                            

User Function cBarCod()
cRet1 := .T.
  if !Empty(_cBarra) .and. !Empty(_cLinDig)
    Alert("Codigo de Barras e Linha Digitavel preenchida. DEIXE APENAS UM CAMPO PREENCHIDO!")
    cRet1 := .F.
  endif    
Return cRet1

User Function nTam()
nRet := .T.
 IF !EMPTY(_CBARRA)
  IF LEN(ALLTRIM(_CBARRA))<47// .and. !Empty(_cLinDig)
    Alert("Tamanho do codigo de barras invalido. Verifique!")
    nRet := .F.
  END IF    
 ENDIF
Return nRet

User Function nTam1()
aRet := .T.
IF EMPTY(_cBarra)
	IF !EMPTY(_cLinDig)
		IF LEN(ALLTRIM(_cLinDig))<47// .and. !Empty(_cLinDig)
			Alert("Tamanho da linha digit�vel invalido. Verifique!")
			aRet := .F.
		END IF
	END IF
END IF
Return aRet


Static function xInc() //ValCodBar()

cStr:= SPACE(48)

RecLock("SE2",.F.)

//If ALLTRIM(SE2->E2_CODBAR)==""

//SETPRVT("cStr")

IF !EMPTY(_cBarra)  
	
	cStr := _cBarra
	
	//	IF VALTYPE(_cLinDig) == NIL .OR. EMPTY(_cLinDig)
	// Se o Campo est� em Branco n�o Converte nada.
	//cStr := 0
	//	ELSE
	// Se o Tamanho do String for menor que 44, completa com zeros at� 47 d�gitos. Isso �
	// necess�rio para Bloquetos que N�O t�m o vencimento e/ou o valor informados na LD.
	//IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)
		
ENDIF
	
  /*	DO CASE
		CASE LEN(cStr) == 48
			cStr := SUBSTR(cStr,5,7)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11)
						
		CASE LEN(cStr) == 47
			cStr := SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10)
			
		
		OTHERWISE
			cStr := cStr+SPACE(48-LEN(cStr))
	ENDCASE */
	
	IF !EMPTY(_cLinDig)		
		cStr := _cLinDig
		
		//	IF VALTYPE(_cLinDig) == NIL .OR. EMPTY(_cLinDig)
		// Se o Campo est� em Branco n�o Converte nada.
		//cStr := 0
		//	ELSE
		// Se o Tamanho do String for menor que 44, completa com zeros at� 47 d�gitos. Isso �
		// necess�rio para Bloquetos que N�O t�m o vencimento e/ou o valor informados na LD.
		//cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)
	ENDIF

	DO CASE
		CASE LEN(Alltrim(cStr)) == 48
			cStr := SUBSTR(cStr,5,7)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11)
			
		CASE LEN(Alltrim(cStr)) == 47
			cStr := SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10)
		OTHERWISE
			cStr := cStr+SPACE(48-LEN(alltrim(cStr)))
	ENDCASE
	
	SE2->E2_CODBAR:=cStr
	
	If SE2->E2_ACRESC==0
		SE2->E2_ACRESC  := _nValAcresc
	End If
	
	If SE2->E2_SDACRES==0
		SE2->E2_SDACRES:= _nValAcresc
	End IF
	
	If SE2->E2_DECRESC==0
		SE2->E2_DECRESC :=_nValDecresc
	End If
	
	If SE2->E2_SDDECRE==0
		SE2->E2_SDDECRE :=_nValDecresc
	End If
	
	//SE2->E2_VLCRUZ    := SE2->E2_VALOR+_nValAcresc-_nValDecresc
	//SE2->E2_VALOR += _nValAcresc-_nValDecresc
	//SE2->E2_SALDO := SE2->E2_VALOR
	
	IF !EMPTY(_cHist)
		
		SE2->E2_HIST    := Alltrim(_cHist)
		
	END IF
	
	IF !EMPTY(dVenc)
		
		SE2->E2_VENCREA    := dVenc
		
	END IF


	
/*If SE2->E2_NUMBOR == " "
	If SE2->E2_SALDO == SE2->E2_VALOR
	SE2->E2_HIST    := Alltrim(_cHist)
	SE2->E2_VALOR    := _nValor
	If AllTrim(_cMODSPB) == "TED"
	SE2->E2_MODSPB  := "1"
	ElseIf AllTrim(_cMODSPB) == "CIP"
	SE2->E2_MODSPB  := "2"
	ElseIf AllTrim(_cMODSPB) == "COMP"
	SE2->E2_MODSPB  := "3"
	Endif
	Endif
	Endif
	
	/*
	///--------------------------------------------------------------------------\
	//| Fun��o: CODBAR				Autor: Fl�vio Novaes		Data: 19/10/2003 |
	//|--------------------------------------------------------------------------|
	//| Essa Fun��o foi desenvolvida com base no Manual do Bco. Ita� e no RDMAKE:|
	//| CODBARVL - Autor: Vicente Sementilli - Data: 26/02/1997.                 |
	//|--------------------------------------------------------------------------|
	//| Descri��o: Fun��o para Valida��o de C�digo de Barras (CB) e Representa��o|
	//|            Num�rica do C�digo de Barras - Linha Digit�vel (LD).		     |
	//|                                                                          |
	//|            A LD de Bloquetos possui tr�s Digitos Verificadores (DV) que  |
	//|				s�o consistidos pelo M�dulo 10, al�m do D�gito Verificador    |
	//|				Geral (DVG) que � consistido pelo M�dulo 11. Essa LD t�m 47   |
	//|            D�gitos.                                                      |
	//|                                                                          |
	//|            A LD de T�tulos de Concessin�rias do Servi�o P�blico e IPTU   |
	//|				possui quatro Digitos Verificadores (DV) que s�o consistidos  |
	//|            pelo M�dulo 10, al�m do Digito Verificador Geral (DVG) que    |
	//|            tamb�m � consistido pelo M�dulo 10. Essa LD t�m 48 D�gitos.   |
	//|                                                                          |
	//|            O CB de Bloquetos e de T�tulos de Concession�rias do Servi�o  |
	//|            P�blico e IPTU possui apenas o D�gito Verificador Geral (DVG) |
	//|            sendo que a �nica diferen�a � que o CB de Bloquetos �         |
	//|            consistido pelo M�dulo 11 enquanto que o CB de T�tulos de     |
	//|            Concession�rias � consistido pelo M�dulo 10. Todos os CB�s    |
	//|            t�m 44 D�gitos.                                               |
	//|                                                                          |
	//|            Para utiliza��o dessa Fun��o, deve-se criar o campo E2_CODBAR,|
	//|            Tipo Caracter, Tamanho 48 e colocar na Valida��o do Usu�rio:  |
	//|            EXECBLOCK("CODBAR",.T.).                                      |
	//|                                                                          |
	//|            Utilize tamb�m o gatilho com a Fun��o CONVLD() para converter |
	//|            a LD em CB.																     |
	//\--------------------------------------------------------------------------/
	
	USER FUNCTION CodBar()
	SETPRVT("cStr,lRet,cTipo,nConta,nMult,nVal,nDV,cCampo,i,nMod,nDVCalc")
	
	// Retorna .T. se o Campo estiver em Branco.
	IF VALTYPE(_cBarra) == NIL .OR. EMPTY(_cBarra)
	RETURN(.T.)
	ENDIF
	
	cStr := LTRIM(RTRIM(_cBarra))
	
	// Se o Tamanho do String for 45 ou 46 est� errado! Retornar� .F.
	lRet := IF(LEN(cStr)==45 .OR. LEN(cStr)==46,.F.,.T.)
	
	// Se o Tamanho do String for menor que 44, completa com zeros at� 47 d�gitos. Isso �
	// necess�rio para Bloquetos que N�O t�m o vencimento e/ou o valor informados na LD.
	cStr := IF(LEN(cStr)<44,cStr+REPL("0",47-LEN(cStr)),cStr)
	
	// Verifica se a LD � de (B)loquetos ou (C)oncession�rias/IPTU. Se for CB retorna (I)ndefinido.
	cTipo := IF(LEN(cStr)==47,"B",IF(LEN(cStr)==48,"C","I"))
	
	// Verifica se todos os d�gitos s�o num�rios.
	FOR i := LEN(cStr) TO 1 STEP -1
	lRet := IF(SUBSTR(cStr,i,1) $ "0123456789",lRet,.F.)
	NEXT
	
	IF LEN(cStr) == 47 .AND. lRet
	// Consiste os tr�s DV�s de Bloquetos pelo M�dulo 10.
	nConta  := 1
	WHILE nConta <= 3
	nMult  := 2
	nVal   := 0
	nDV    := VAL(SUBSTR(cStr,IF(nConta==1,10,IF(nConta==2,21,32)),1))
	cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,11,22)),IF(nConta==1,9,10))
	FOR i := LEN(cCampo) TO 1 STEP -1
	nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
	nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
	nMult := IF(nMult==2,1,2)
	NEXT
	nDVCalc := 10-MOD(nVal,10)
	// Se o DV Calculado for 10 � assumido 0 (Zero).
	nDVCalc := IF(nDVCalc==10,0,nDVCalc)
	lRet    := IF(lRet,(nDVCalc==nDV),.F.)
	nConta  := nConta + 1
	ENDDO
	// Se os DV�s foram consistidos com sucesso (lRet=.T.), converte o n�mero para CB para consistir o DVG.
	cStr := IF(lRet,SUBSTR(cStr,1,4)+SUBSTR(cStr,33,15)+SUBSTR(cStr,5,5)+SUBSTR(cStr,11,10)+SUBSTR(cStr,22,10),cStr)
	ENDIF
	
	IF LEN(cStr) == 48 .AND. lRet
	// Consiste os quatro DV�s de T�tulos de Concession�rias de Servi�o P�blico e IPTU pelo M�dulo 10.
	nConta  := 1
	WHILE nConta <= 4
	nMult  := 2
	nVal   := 0
	nDV    := VAL(SUBSTR(cStr,IF(nConta==1,12,IF(nConta==2,24,IF(nConta==3,36,48))),1))
	cCampo := SUBSTR(cStr,IF(nConta==1,1,IF(nConta==2,13,IF(nConta==3,25,37))),11)
	FOR i := 11 TO 1 STEP -1
	nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
	nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
	nMult := IF(nMult==2,1,2)
	NEXT
	nDVCalc := 10-MOD(nVal,10)
	// Se o DV Calculado for 10 � assumido 0 (Zero).
	nDVCalc := IF(nDVCalc==10,0,nDVCalc)
	lRet    := IF(lRet,(nDVCalc==nDV),.F.)
	nConta  := nConta + 1
	ENDDO
	// Se os DV�s foram consistidos com sucesso (lRet=.T.), converte o n�mero para CB para consistir o DVG.
	cStr := IF(lRet,SUBSTR(cStr,1,11)+SUBSTR(cStr,13,11)+SUBSTR(cStr,25,11)+SUBSTR(cStr,37,11),cStr)
	ENDIF
	
	IF LEN(cStr) == 44 .AND. lRet
	IF cTipo $ "BI"
	// Consiste o DVG do CB de Bloquetos pelo M�dulo 11.
	nMult  := 2
	nVal   := 0
	nDV    := VAL(SUBSTR(cStr,5,1))
	cCampo := SUBSTR(cStr,1,4)+SUBSTR(cStr,6,39)
	FOR i := 43 TO 1 STEP -1
	nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
	nVal  := nVal + nMod
	nMult := IF(nMult==9,2,nMult+1)
	NEXT
	nDVCalc := 11-MOD(nVal,11)
	// Se o DV Calculado for 0,10 ou 11 � assumido 1 (Um).
	nDVCalc := IF(nDVCalc==0 .OR. nDVCalc==10 .OR. nDVCalc==11,1,nDVCalc)
	lRet    := IF(lRet,(nDVCalc==nDV),.F.)
	// Se o Tipo � (I)ndefinido E o DVG N�O foi consistido com sucesso (lRet=.F.), tentar�
	// consistir como CB de T�tulo de Concession�rias/IPTU no IF abaixo.
	ENDIF
	IF cTipo == "C" .OR. (cTipo == "I" .AND. !lRet)
	// Consiste o DVG do CB de T�tulos de Concession�rias pelo M�dulo 10.
	lRet   := .T.
	nMult  := 2
	nVal   := 0
	nDV    := VAL(SUBSTR(cStr,4,1))
	cCampo := SUBSTR(cStr,1,3)+SUBSTR(cStr,5,40)
	FOR i := 43 TO 1 STEP -1
	nMod  := VAL(SUBSTR(cCampo,i,1)) * nMult
	nVal  := nVal + IF(nMod>9,1,0) + (nMod-IF(nMod>9,10,0))
	nMult := IF(nMult==2,1,2)
	NEXT
	nDVCalc := 10-MOD(nVal,10)
	// Se o DV Calculado for 10 � assumido 0 (Zero).
	nDVCalc := IF(nDVCalc==10,0,nDVCalc)
	lRet    := IF(lRet,(nDVCalc==nDV),.F.)
	ENDIF
	ENDIF
	
	IF !lRet
	HELP(" ",1,"ONLYNUM")
	ENDIF
	
	RETURN(lRet)   */
	
	MsUnlock()
	
	Close(oDlg)
	Return (_cRet)
