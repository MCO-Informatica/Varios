#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE DMPAPER_A4 9 // A4 210 x 297 mm
#DEFINE ENT (CHR(13)+CHR(10))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFINR003  ºAutor  ³Ricardo Nisiyama             ³  30/05/16 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para impressão do boleto do Banco Bradesco S/A.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus11 - Específico para a empresa Prozyn     .        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFINR003()

Private oFont
Private nLastKey   := 0
Private _cRotina   := "RFINR003"
Private cPerg      := _cRotina
Private BaseDac    := ""
Private cNumero    := ""
Private Modulo     := 11
Private sDigit     := ""
Private cCondicao  := ""
Private _cNum      := ""
Private cBanco     := ""	 //Banco
Private _cNumAg    := ""	 //Agência
Private _cNumCta   := ""	 //Conta
Private cSubCta    := ""	 //Sub-Conta
Private _nPJurPd   := 0.0667 //% de Juros Padrão
Private ModuloNN   := 10
Private ModuloCB   := 11
Private _cDiaProt:="" 
Private _cLogoEmp  := "Logoret.bmp"  
Private _cLogoBco  := ""
Private _cNosso	   := ""


MsgInstr01 := " "
MsgInstr02 := " "
oFont08    := TFont():New( "Arial"       ,,08,,.F.,,,,,.F. )
oFont08B   := TFont():New( "Arial"       ,,08,,.T.,,,,,.F. )
oFont12    := TFont():New( "Arial"       ,,09,,.t.,,,,,.f. )
oFont13    := TFont():New( "Arial"       ,,06,,.f.,,,,,.f. )
oFont14    := TFont():New( "Arial"       ,,08,,.F.,,,,,.f. )
oFont14B   := TFont():New( "Arial"       ,,12,,.T.,,,,,.F. )
oFont15    := TFont():New( "Arial"       ,,09,,.t.,,,,,.f. )
oFont17    := TFont():New( "Arial"       ,,14,,.T.,,,,,.f. )
oFont18    := TFont():New( "Arial"       ,,09,,.T.,,,,,.f. )
oFont20    := TFont():New( "Arial Black" ,,16,,.t.,,,,,.f. )
oFont21    := TFont():New( "Arial"       ,,18,,.t.,,,,,.f. )
oFont22B   := TFont():New( "Arial"       ,,22,,.T.,,,,,.F. )
oFont24    := TFont():New( "Arial"       ,,07,,.T.,,,,,.f. )

ValidPerg()
If Pergunte(cPerg,.T.)
	cBanco     := Padr(MV_PAR08   ,TamSx3("EE_CODIGO" )[1])	//Banco
	_cNumAg    := Padr(MV_PAR09   ,TamSx3("EE_AGENCIA")[1])	//Agência
	_cNumCta   := Padr(MV_PAR10   ,TamSx3("EE_CONTA"  )[1])	//Conta
	cSubCta    := Padr(MV_PAR11   ,TamSx3("EE_SUBCTA" )[1])	//Sub-Conta
	ImprimeDup()
EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImprimeDupºAutor  ³Anderson C. P. Coelho º Data ³  20/10/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processamento de impressão da rotina.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa Principal.                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/            

Static Function ImprimeDup()
Local xx:=1
Set Century ON

dbSelectArea("SE1")
_cQry := "SELECT DISTINCT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, R_E_C_N_O_ RECSE1 "
_cQry += "FROM " + RetSqlName("SE1") + " SE1 "
_cQry += "WHERE SE1.D_E_L_E_T_ = '' "
_cQry += "  AND SE1.E1_FILIAL = '" + xFilial("SE1") + "' "
_cQry += "  AND SE1.E1_PREFIXO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'  "
_cQry += "  AND SE1.E1_NUM     BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'  "
_cQry += "  AND SE1.E1_NUMBOR  BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'  "
_cQry += "  AND SE1.E1_SALDO         > 0 "
_cQry += "  AND SE1.E1_TIPO         <> 'CH' "
_cQry += "  AND (SE1.E1_PORTADO      = '' OR SE1.E1_PORTADO = '" + MV_PAR08 + "') "
_cQry += "  AND (SE1.E1_AGEDEP       = '' OR SE1.E1_AGEDEP  = '" + MV_PAR09 + "') "
_cQry += "  AND (SE1.E1_CONTA        = '' OR SE1.E1_CONTA   = '" + MV_PAR10 + "') "
_cQry += "ORDER BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA "
If __cUserId == "000000"
	MemoWrite("\"+_cRotina+"_QRY_001.TXT",_cQry)
EndIf
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),"SE1TMP",.T.,.F.)
dbSelectArea("SEE")
dbSetOrder(1)
If !dbSeek(xFilial("SEE") + cBanco + _cNumAg + _cNumCta + cSubCta)
	Alert("Arquivo de parametros banco/cnab incorreto. Verifique banco/agencia/conta/sub-conta.")
	Return()
EndIf
dbSelectArea("SE1TMP")
If SE1TMP->(EOF())
	Alert("Nada a imprimir!")
	Return
EndIf
_cNumCta := AllTrim(_cNumCta)+AllTrim(SEE->EE_DVCTA)
oPrn := TMSPrinter():New()			// Declara o objeto a ser impresso
oPrn:Setup()						// Configuração de impressão
oPrn:SetPaperSize(DMPAPER_A4)		// Tamanho/Tipo do Papel
oPrn:SetPortRait()					// Impressão em formato "retrato"
dbSelectArea("SE1TMP")
While !SE1TMP->(EOF())
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbGoTo(SE1TMP->RECSE1)
	MsgInstr01	:= SE1->E1_INSTR1
	MsgInstr02	:= SE1->E1_INSTR2
	_cNosso := alltrim(SE1->E1_NUM)
	_cNosso := strzero(val(_cNosso),7)
    _cParc	:= alltrim(SE1->E1_PARCELA)
    _cNosso += STRZERO(val(_cParc),2) 
	//_cParcel:= Parcel()
	//U_VNNUM237(cNumero,_cNosso,_cParcel) 
	U_VNNUM237(cNumero)

	SA1->(dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.))

	_cDiaProt:= Dias()
	nJuros := 0
	nJuros := RETJBOL(nJuros)
	
	nMulta := 0
	nTxmulta := 0.02
	nMulta := Round((SE1->E1_SALDO - (SE1->E1_SALDO*(SE1->E1_DESCFIN/100))) * nTxmulta,2)
	nMulta := transf(nMulta,"@E 999,999.99")
	
	ndesconto := 0
	_cDesconto:=""
	nDesconto := Round((SE1->E1_SALDO * (SE1->E1_DESCFIN/100)),2)
  	nDesconto +=SE1->E1_DECRESC 

	                                         
 

	// Calculo do codigo de barras + digito
	StrMult := "4329876543298765432987654329876543298765432"

//	cValor  := StrZero(100 * (SE1->E1_VALOR+SE1->E1_ACRESC-SE1->E1_DECRESC), 30)       //14
//	cValor  := StrZero(100 * (SE1->E1_VALOR+SE1->E1_ACRESC-SE1->E1_DECRESC), 10)       //14
	cValor  := StrZero(100 * SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES), 10)       //14
	cNumero := Substr(SE1->E1_NUMBCO,1,11)

	cAgencia := SubStr(_cNumAg,1,4)
	cConta   := StrZero(VAL(SubStr(_cNumCta,1,Len(AllTrim(_cNumCta))-1)),7)
	cFator   := StrZero(SE1->E1_VENCTO - CTOD("07/10/97"),4)
	cMoeda   := "9"
	cCart    := AllTrim(SEE->EE_CODCART)

	livre   := cAgencia + cCart + cNumero + cConta + "0"
	sBarra  := cBanco + cMoeda + cfator + cValor + livre
	BaseDiv := 0

	For xx := 1 To 43
		_nMult := Val(Subs(sBarra, xx, 1)) * Val(Subs(strmult, xx, 1))
		If Len(cValToChar(AllTrim(_nMult))) > 1
			_nMult := Val(SubStr(cValToChar(AllTrim(_nMult)),1,1) + SubStr(cValToChar(AllTrim(_nMult)),2,1))
		EndIf
		BaseDiv := BaseDiv + _nMult
	Next xx

	resto  := BaseDiv % modulo
	resto  := modulo - resto
	resto  := Str(Iif (resto > 9 .or. resto == 0 .or. resto == 1, 1,resto),1)
	sBarra := cBanco + cMoeda + resto + cfator + cValor + livre

	// Calculo da linha digit vel
	sDigit := cBanco + cMoeda + cAgencia + cCart + cNumero + cConta
	sDigi1 := cBanco + cMoeda + Subs(livre, 1, 5)
	sDigi2 := Subs (livre,  6, 10)
	sDigi3 := Subs (livre, 16, 10)

	V_Base := sDigi1
	cDigi()
	sDigi1 := V_Base
	V_Base := sDigi2
	cDigi()
	sDigi2 := V_Base
	V_Base := sDigi3
	cDigi()
	sDigi3 := V_Base

	sDigi1 := Subs (sDigi1, 1, 5) + "." + Subs (sdigi1, 6, 5) + " "
	sDigi2 := Subs (sDigi2, 1, 5) + "." + Subs (sdigi2, 6, 6) + " "
	sDigi3 := Subs (sDigi3, 1, 5) + "." + Subs (sdigi3, 6, 6) + " "
	sDigit := sDigi1 + sDigi2 + sDigi3 + resto + " " + cfator + Strzero(100 * SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES),10,0)


	oPrn:StartPage()
	
	_cLogoBco	   := "Bradesco.bmp"			// Logotipo do Banco
	cRaizBitMap	   := "lgmid02.bmp"				// Logotipo do Banco // ALTERADO iSAQUE
	
	
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAIXAÄÄÄÄAIXAÄÄÄÄAIXAAIXA³
	//³                                                 ³
	//³       MONTA O RECIBO DO SACADO                  ³
	//³                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAIXAÄÄÄÄAIXAÄÄÄÄAIXAÄÄÄÄAI
	*/

	oPrn:Say ( 0075, 1730, "RECIBO DO PAGADOR",oFont15,100)
	oPrn:Box ( 0120, 0200, 0955, 2180)
	oPrn:Line( 0045, 0550, 0120, 0550)
	oPrn:Line( 0045, 0551, 0120, 0551)
	oPrn:Line( 0045, 0553, 0120, 0553)
	oPrn:Line( 0045, 0730, 0120, 0730)
	oPrn:Line( 0045, 0731, 0120, 0731)
	oPrn:Line( 0045, 0732, 0120, 0732)


	oPrn:SayBitmap( 0045, 220,_cLogoBco,300,68 )
	oPrn:Say( 0045, 0560, "237-2",oFont21,100)
	oPrn:SayBitmap( 0122, 0220,_cLogoEmp,320,109 )
	oPrn:Say( 0130, 0560, "Beneficiário " ,oFont13,100 )	
	oPrn:Say ( 150, 0560, AllTrim(SM0->M0_NOMECOM),oFont14B,100)
	
	_cCEPc := IIf(!Empty(SA1->A1_CEPC),SA1->A1_CEPC,SA1->A1_CEP)
	_cEndc := IIf(!Empty(SA1->A1_ENDCOB),SA1->A1_ENDCOB,SA1->A1_END)
	_cBair := IIf(!Empty(SA1->A1_BAIRROC),SA1->A1_BAIRROC,SA1->A1_BAIRRO)
	_cMunc := IIf(!Empty(SA1->A1_MUNC),SA1->A1_MUNC,SA1->A1_MUN)
	_cEstc := IIf(!Empty(SA1->A1_ESTC),SA1->A1_ESTC,SA1->A1_EST)
	_cCompl  := AllTrim(IIF(!Empty(SA1->A1_CEPC).AND.!Empty(SA1->A1_ESTC).AND.!Empty(SA1->A1_ENDCOB).AND.!Empty(SA1->A1_BAIRROC),SA1->A1_COMPLC ,SA1->A1_COMPLEM))
	If Len(AllTrim(SM0->M0_CGC)) == 14
		_cCnpj := "CNPJ: " + SubStr(SM0->M0_CGC,1,2)+"."+SubStr(SM0->M0_CGC,3,3)+"."+SubStr(SM0->M0_CGC,6,3)+"/"+SubStr(SM0->M0_CGC,9,4)+"-"+SubStr(SM0->M0_CGC,13,2)
	ElseIf Len(AllTrim(SM0->M0_CGC)) == 11
		_cCnpj := "CPF:  " + SubStr(SM0->M0_CGC,1,3)+"."+SubStr(SM0->M0_CGC,4,3)+"."+SubStr(SM0->M0_CGC,7,3)+"-"+SubStr(SM0->M0_CGC,10,2)
	Else
		_cCnpj := "CPF/CNPJ: " + AllTrim(SM0->M0_CGC)
	EndIf
	oPrn:Say ( 200, 560,AllTrim(FisGetEnd(SM0->M0_ENDCOB,SM0->M0_ESTCOB)[1]) + ", " + ;
	AllTrim(IIF(!Empty(FisGetEnd(SM0->M0_ENDCOB,SM0->M0_ESTCOB)[3]),FisGetEnd(SM0->M0_ENDCOB,SM0->M0_ESTCOB)[3],"S/N")) + ;
	" - " + AllTrim(SM0->M0_CIDCOB) + "/" + SM0->M0_ESTCOB + " CEP: " + Transform(SM0->M0_CEPCOB,"@R 99999-999") + ;
	"  Tel: " + AllTrim(Transform(SM0->M0_TEL,"@R (99) 9999-9999")) + " " + _cCnpj ,oFont13,100)
	
	oPrn:line(235, 200, 235, 2180)
	oPrn:line(385, 200, 386, 2180)
	oPrn:line(120, 1720,235, 1720)
	oPrn:Line(455, 0500, 385, 0500)
	oPrn:Line(455, 0900, 385, 0900)
	oPrn:Line(455, 1100, 385, 1100)
	oPrn:Line(455, 1400, 385, 1400)
	oPrn:Line(455, 0200, 455, 2180)
	oPrn:Say ( 130, 1730,"Vencimento",oFont13,100)
	oPrn:Say( 263, 0240, AllTrim(SE1->E1_CLIENTE)+AllTrim(SE1->E1_LOJA) + " - " + ALLTRIM(SA1->A1_NOME), oFont12,100  )
   	oPrn:Say ( 240, 220,"Pagador",oFont13,100)
	If !Empty(_cCompl)
		oPrn:Say( 303, 0240, ALLTRIM(_cEndc) + " - " + Alltrim(_cCompl), oFont12,100  )
	Else
		oPrn:Say( 303, 0240, ALLTRIM(_cEndc)      ,oFont12,100  )
	Endif
	oPrn:Say( 160, 2090, DTOC(SE1->E1_VENCTO)    ,oFont17,100,,,1  )   //Vencimento do Titulo
	oPrn:Say( 343, 0240, SubStr(_cCEPc,1,5)+"-"+SubStr(_cCEPc,6,3)+"  "+RTrim(_cBair)+" - "+ALLTRIM(_cMunc)+"   "+_cEstc, oFont12,100  )
	oPrn:Say( 385, 0220, "Data Documento "        ,oFont13,100  )
	oPrn:Say( 385, 0510, "Nº. Documento "         ,oFont13,100  )
	oPrn:Say( 385, 0910, "Especie Doc. "          ,oFont13,100  )
	oPrn:Say( 385, 1110, "Aceite "                ,oFont13,100  )
	oPrn:Say( 385, 1410, "Data do Processamento " ,oFont13,100  )
	
	oPrn:Say( 420, 0240, DTOC(SE1->E1_EMISSAO)    ,oFont12,100  )
	oPrn:Say( 420, 0530, alltrim(SE1->E1_PREFIXO)+" "+alltrim(SE1->E1_NUM)+" "+alltrim(SE1->E1_PARCELA), oFont12,100  )
	oPrn:Say( 420, 0970, "DM"                     ,oFont12,100  )
	oPrn:Say( 420, 1230, "N"							  ,oFont12,100  )
	oPrn:Say( 420, 1440, DTOC(SE1->E1_EMISSAO)          ,oFont12,100  )
	
	/*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAIXAÄÄÄÄAIXAÄÄÄÄAIXAAIXA³
	//³                                                 ³
	//³       MONTA PARTE INFERIOR DO RECIBO / CAIXA    ³
	//³                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAIXAÄÄÄÄAIXAÄÄÄÄAIXAÄÄÄÄAI
	*/
	// Monta box do boleto
	//        lin   col   lin   col
	//	oPrn:Box (1380, 0200, 1900, 2180)
	
	// Monta linhas horizontais
	//        lin   col   lin   col
	//	oPrn:Line(1230, 1720, 1230, 2180)
	oPrn:Line(455, 1720, 455, 2180)
	oPrn:Line(535, 1720, 535, 2180)
	oPrn:Line(605, 1720, 605, 2180)
	oPrn:Line(675, 1720, 675, 2180)
	oPrn:Line(745, 1720, 745, 2180)
	oPrn:Line(815, 1720, 815, 2180)
	oPrn:Line(885, 1720, 885, 2180)
	oPrn:Line(955, 1720, 955, 2180)
	// Monta linha verticais
	//        lin   col   lin   col
	//oPrn:SayBitmap( 1100, 0900,cPropBitMap,400,400 )
	oPrn:Line(385, 1720, 955, 1720)

	oPrn:Say( 385, 1730, "Agência / Codigo do Beneficiário"         ,oFont13,100  )
	oPrn:Say( 460, 1730, "Nosso - Número "          	,oFont13,100  )
	oPrn:Say( 540, 1730, "Valor do Documento "		,oFont13,100  )
	oPrn:Say( 420, 2090, alltrim(SEE->EE_AGENCIA) + "-" + alltrim(SEE->EE_DVAGE) + "/" + Alltrim(SEE->EE_CONTA)+"-"+ ALLTRIM(SEE->EE_DVCTA), oFont12,100,,,1)
	//oPrn:Say( 420, 1755, SubStr(_cNumAg,1,4) + "-" + SubStr(_cNumAg,5,1) + "/" + AllTrim(cConta)+"-P", oFont12,100)
	//oPrn:Say( 1340, 1800, AllTrim(SE1->E1_PREFIXO)+"  "+AllTrim(SE1->E1_NUM)+"  "+AllTrim(SE1->E1_PARCELA),oFont12,100)
	oPrn:Say( 490, 2090, alltrim(cCart) + "/" + SubStr(SE1->E1_NUMBCO,1,11) + "-" + SubStr(SE1->E1_NUMBCO,12,1), oFont12,100,,,1  )
	oPrn:Say( 570, 2090, TRANSF(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES),"@E 999,999.99") , oFont12,100,,,1)
	oPrn:Say( 610, 1730, "(-) Desconto "          ,oFont13,100  )
		If nDesconto > 0
            
		_cDesconto:= If(nDesconto >0,transf(nDesconto,"@E 999,999.99"),"") 
		oPrn:Say( 640, 2090, _cDesconto				   ,oFont12,100,,,1  )

		EndIf
	oPrn:Say( 460, 0220, "Informações de responsabilidade do beneficiário "            ,oFont13,100  )
	oPrn:Say( 680, 1730, "(-) Outras deduções "   ,oFont13,100  )
	//oPrn:Say( 500, 0240, "Sujeito a protesto", oFont15,100  )
		oPrn:Say( 640, 0240, "Após "+DTOC(SE1->E1_VENCTO)+" cobrar juros de mora de R$ "+AllTrim(Transform(nJuros,"@E 999,999.99"))+" por dia de atraso" ,oFont15,100  ) 
	
	_cValJur := Round(E1_PORCJUR*30,2)/100 * (SE1->E1_SALDO-SE1->E1_SDDECRE+SE1->E1_SDACRES)//Adicionado por Ricardo Nisiyama - 27/05/2016 || Valor Multa Mensal
	                          
	oPrn:Say( 680, 0240, "Após "+DTOC(SE1->E1_VENCTO)+" Multa de ........ R$ "+AllTrim(Transform(_cValJur,"@E 999,999.99")), oFont15,100  )
	oPrn:Say( 720, 0240, "DEVOLVER EM "+DTOC(SE1->E1_VENCTO+60) , oFont15,100)  
	oPrn:Say( 770, 0240, "Após 3 dias do vencimento e não pago, será incluso no Serasa." , oFont15,100  )
	oPrn:Say( 750, 1730, "(+) Mora/Multa/Juros "  ,oFont13,100  )
	oPrn:Say( 820, 1730, "(+) Outros Acrecimos "  ,oFont13,100  )
	oPrn:Say( 890, 1730, "(=) Valor Cobrado "     ,oFont13,100  )
	oPrn:Say(1200,200,"_  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  __  ",ofont08,100)
	
	//******************************************
	//  MONTA FICHA COMPENSAÇÃO
	//******************************************
	// Monta box do boleto
	oPrn:Box (1515, 0200, 2435, 2180)
	
	// Monta linhas horizontais
	oPrn:Line(1625, 0200, 1625, 2180)
	oPrn:Line(1695, 0200, 1695, 2180)
	oPrn:Line(1765, 0200, 1765, 2180)
	oPrn:Line(1835, 0200, 1835, 2180)
	oPrn:Line(2180, 0200, 2180, 2180)
	
	// Monta linha verticais
	oPrn:Line(1435, 0550, 1515, 0550)
	oPrn:Line(1435, 0551, 1515, 0551)
	oPrn:Line(1435, 0552, 1515, 0552)
	oPrn:Line(1435, 0730, 1515, 0730)
	oPrn:Line(1435, 0731, 1515, 0731)
	oPrn:Line(1435, 0732, 1515, 0732)
	oPrn:Line(1515, 1720, 2180, 1720)
	oPrn:Line(1905, 1720, 1905, 2180)
	oPrn:Line(1975, 1720, 1975, 2180)
	oPrn:Line(2045, 1720, 2045, 2180)
	oPrn:Line(2115, 1720, 2115, 2180)
	oPrn:Line(1695, 0500, 1836, 0500)
	oPrn:Line(1695, 0900, 1836, 0900)
	oPrn:Line(1695, 1100, 1766, 1100)            
	oPrn:Line(1695, 1400, 1836, 1400)
	oPrn:Line(1765, 0700, 1836, 0700)
	oPrn:Line(1765, 0400, 1836, 0400)

	oPrn:SayBitmap(1440, 0220,_cLogoBco,300,68 )
	oPrn:Say( 1440, 0560, "237-2"                  ,oFont21,100)
	oPrn:Say( 1440, 0745, sDigit                   ,oFont17,150)
	
	oPrn:Say( 1520, 0220, "Local de Pagamento "       ,oFont13,100  )
	oPrn:Say( 1520, 1730, "Vencimento "               ,oFont13,100  )
	oPrn:Say( 1550, 0240, UPPER("Pagável Preferencialmente na rede Bradesco ou no Bradesco expresso."),oFont12,100 )
	oPrn:Say( 1550, 2090, DTOC(SE1->E1_VENCTO)             ,oFont17,100,,,1  )   //Vencimento do Titulo	
	oPrn:Say( 1630, 0220, "Beneficiario "               ,oFont13,100  )
	oPrn:Say( 1630, 0690, "CNPJ/CPF "               ,oFont13,100  )
	oPrn:Say( 1630, 1000, "Endereço"               ,oFont13,100  )
	oPrn:Say( 1630, 1555, "CEP"               ,oFont13,100  )
	oPrn:Say( 1630, 1730, "Agência / Codigo do Beneficiario "        ,oFont13,100  )
	oPrn:Say( 1655, 0230, AllTrim("PROZYN IND E COM EIRELI"),oFont12,100  )   //Cedente
	oPrn:Say( 1655, 0690, SubStr(_cCnpj,7,18),oFont12,100  )   //Cedente
	oPrn:Say (1655, 1000,AllTrim(FisGetEnd(SM0->M0_ENDCOB,SM0->M0_ESTCOB)[1]) + ", " + ;
	AllTrim(IIF(!Empty(FisGetEnd(SM0->M0_ENDCOB,SM0->M0_ESTCOB)[3]),FisGetEnd(SM0->M0_ENDCOB,SM0->M0_ESTCOB)[3],"S/N"))+"-" + SM0->M0_ESTCOB,oFont12,100)	
   	oPrn:Say( 1655, 1555,  Transform(SM0->M0_CEPCOB,"@R 99999-999"),oFont12,100  )	
	//oPrn:Say( 1655, 1740, SubStr(_cNumAg,1,4) + "-" + SubStr(_cNumAg,5,1) + "/" + AllTrim(cConta)+"-P", oFont12,100  )	
	oPrn:Say( 1655, 2090, alltrim(SEE->EE_AGENCIA) + "-" + alltrim(SEE->EE_DVAGE) + "/" + Alltrim(SEE->EE_CONTA)+"-"+ALLTRIM(SEE->EE_DVCTA), oFont12,100,,,1)
	oPrn:Say( 1700, 0220, "Data Documento "         ,oFont13,100  )
	oPrn:Say( 1700, 0510, "Nº. Documento "          ,oFont13,100  )
	oPrn:Say( 1700, 0910, "Especie Doc. "           ,oFont13,100  )
	oPrn:Say( 1700, 1110, "Aceite "                 ,oFont13,100  )
	oPrn:Say( 1700, 1410, "Data do Processamento "  ,oFont13,100  )
	oPrn:Say( 1700, 1730, "Carteira / Nosso Numero ",oFont13,100  )

	oPrn:Say( 1725, 0240, DTOC(SE1->E1_EMISSAO)                                                           , oFont12,100  )
	oPrn:Say( 1725, 0530, AllTrim(SE1->E1_PREFIXO)+"  "+AllTrim(SE1->E1_NUM)+"  "+AllTrim(SE1->E1_PARCELA), oFont12,100  )
	oPrn:Say( 1725, 0970, "DM"                                                                            , oFont12,100  )
	oPrn:Say( 1725, 1230, "N"                                                                             , oFont12,100  )
	oPrn:Say( 1725, 1440, DTOC(SE1->E1_EMISSAO)                                                                 , oFont12,100  )
	oPrn:Say( 1725, 2090, alltrim(cCart) + "/" + SubStr(SE1->E1_NUMBCO,1,11) + "-" + SubStr(SE1->E1_NUMBCO,12,1) , oFont12,100,,,1  )
	oPrn:Say( 1770, 0220, "Uso do Banco "          ,oFont13,100  )
	oPrn:Say( 1770, 0405, "Cip"                    ,oFont13,100  )
	oPrn:Say( 1770, 0510, "Carteira "			   ,oFont13,100  )
	oPrn:Say( 1770, 0710, "Especie "               ,oFont13,100  )
	oPrn:Say( 1770, 0910, "Quantidade "            ,oFont13,100  )
	oPrn:Say( 1770, 1410, "Valor "                 ,oFont13,100  )
	oPrn:Say( 1770, 1730, "Valor do Documento "    ,oFont13,100  )
	oPrn:Say( 1795, 0408, "000"                    , oFont12,100  )
	oPrn:Say( 1795, 0560, StrZero(VAL(cCart),2)                    , oFont12,100  )   //Carteira SR = Sem Registro CR = Cobrança Rapida
	oPrn:Say( 1795, 0770, "R$"                     , oFont12,100  )
	oPrn:Say( 1795, 2090, TRANSF(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES),"@E 999,999.99") , oFont12,100,,,1  )   //Codigo do Cedente
	oPrn:Say( 1840, 0220, "Informações de responsabilidade do beneficiário "            ,oFont13,100  )
	oPrn:Say( 1840, 1730, "(-) Desconto "          ,oFont13,100  )
	//oPrn:Say( 1900, 0240, "Sujeito a protesto", oFont15,100  )	
  	oPrn:Say( 1865, 2090, _cDesconto,oFont12,100,,,1  )	
	oPrn:Say( 1970, 0240, "Após "+DTOC(SE1->E1_VENCTO)+" cobrar juros de mora de R$ "+AllTrim(TRANSF(nJuros,"@E 999,999.99"))+" por dia de atraso" ,oFont15,100  )
	
	_cValJur := Round(E1_PORCJUR*30,2)/100 * (SE1->E1_SALDO-SE1->E1_SDDECRE+SE1->E1_SDACRES)
	                           
	oPrn:Say( 2010, 0240, "Após "+DTOC(SE1->E1_VENCTO)+" Multa de ........ R$ "+AllTrim(TRANSF(_cValJur,"@E 999,999.99")), oFont15,100  )
	oPrn:Say( 2050, 0240, "DEVOLVER EM "+DTOC(SE1->E1_VENCTO+60) , oFont15,100  ) 
	oPrn:Say( 2090, 0240, "Após 3 dias do vencimento e não pago, será incluso no Serasa." , oFont15,100  )
	oPrn:Say( 1910, 1730, "(-) Outras deduções "   ,oFont13,100  )
	oPrn:Say( 1980, 1730, "(+) Mora/Multa/Juros "  ,oFont13,100  )
	oPrn:Say( 2080, 1730, "(+) Outros Acrecimos "  ,oFont13,100  )
	oPrn:Say( 2120, 1730, "(=) Valor do Documento ",oFont13,100  )
	oPrn:Say( 2180, 0220, "Pagador"                 ,oFont13,100  )
	oPrn:Say( 2205, 0240, SE1->E1_CLIENTE+SE1->E1_LOJA + " - " + ALLTRIM(SA1->A1_NOME) , oFont12,100  )

//	oPrn:Say( 2840, 0240, ALLTRIM(_cEndc), oFont12,100  )
	If !Empty(_cCompl)
		oPrn:Say( 2245, 0240, ALLTRIM(_cEndc) + " - " + Alltrim(_cCompl), oFont12,100  )
	Else
		oPrn:Say( 2245, 0240, ALLTRIM(_cEndc), oFont12,100  )
	Endif	
	oPrn:Say( 2285, 0240, substr(_cCEPc,1,5)+"-"+substr(_cCEPc,6,3)+"  "+ALLTRIM(_cBair)+" - "+ALLTRIM(_cMunc)+"   "+_cEstc, oFont12,100  )
	If SA1->A1_PESSOA = "F" //Caso seja pessoa juridica
		oPrn:Say( 2325, 0240,"CPF:  " + SUBS(SA1->A1_CGC,1,3)+"."+SUBS(SA1->A1_CGC,4,3)+"."+SUBS(SA1->A1_CGC,7,3)+"-"+SUBS(SA1->A1_CGC,10,2), oFont12,100  )
   Else	//Caso seja pessoa fisica.
		oPrn:Say( 2325, 0240,"CNPJ: " + SUBS(SA1->A1_CGC,1,2)+"."+SUBS(SA1->A1_CGC,3,3)+"."+SUBS(SA1->A1_CGC,6,3)+"/"+SUBS(SA1->A1_CGC,9,4)+"-"+SUBS(SA1->A1_CGC,13,2), oFont12,100  )
   Endif

	oPrn:Say( 2410, 0240, "Sacador/Avalista: ", oFont13,100  )
	oPrn:Say( 2445, 1800, "FICHA DE COMPENSAÇÃO",oFont13,100  )
	oPrn:Say( 2480, 1800, "AUTENTICAÇÃO MECÂNICA",oFont13,100  )
	

		MSBAR("INT25",21.1,2.2,Alltrim(sBarra),oPrn,.F.,,.T.,0.025,1.3,NIL,NIL,NIL,.F.)		//impressão normal

	oPrn:EndPage()
	dbSelectArea("SE1TMP")
	SE1TMP->(dbSkip())
EndDo

dbSelectArea("SE1TMP")
SE1TMP->(dbCloseArea())

oPrn:Preview()

Set Century OFF

RETURN(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VNNUM237  ºAutor  ³Anderson C. P. Coelho º Data ³ 20/10/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que retorna o nosso número para as cobranças regis- º±±
±±º          ³ tradas do Banco Bradesco.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RFINR001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//User Function VNNUM237(_cNum,_cNNum,cParcel)
User Function VNNUM237(_cNum)
local idac:=1
_cNum  := ""
Modulo := 11
//_cNNum :=_cNNum
 //_cParcment:=_cParcel
 //_cParcment:=strzero(val(_cParcel),2)
 //_cNNum +=_cParcment  

If !Empty(SE1->E1_NUMBCO)
	_cNum := Alltrim(SE1->E1_NUMBCO)
	_nSeq := SubStr(SE1->E1_NUMBCO,1,11)
	StrMult  := "2765432765432"
	BaseDac  := "09" + _nSeq
	VarDac   := 0

	For idac := 1 To 13
		VarDac += Val(SubStr(BaseDac,idac,1)) * Val(SubStr(StrMult,idac,1))
	Next idac
	nResto := MOD(VarDac,Modulo)

	If nResto == 0
		VarDac  := "0"
	ElseIf nResto == 1
		VarDac  := "P"
	Else
		VarDac  := Str(Modulo-nResto,1)
	EndIf

	_cNum := _nSeq + VarDac
	dbSelectArea("SE1")
Else
	If Empty(SEE->EE_FAXATU)
		RecLock("SEE",.F.)
		SEE->EE_FAXATU := Substr(SEE->EE_FAXINI,1,11)
		MsUnLock()
	EndIf
	x := SEE->EE_FAXATU //_cNNum
	If Val(x) > Val(Substr(SEE->EE_FAXFIM,1,11))
		 Alert("O nosso numero atingiu a faixa maxima permitida. A sequencia sera reiniciada.")
		// Reinicia automaticamente conforme a faixa inicial cadastrada no cadastro de 
		x := SEE->EE_FAXINI
	EndIf
	RecLock("SEE",.F.)
	SEE->EE_FAXATU := StrZero(Val(x)+1,11)
	SEE->(MsUnLock())

	_nSeq    := StrZero(VAL(SEE->EE_FAXATU),11)
	StrMult  := "2765432765432"
	BaseDac  := "09" + _nSeq
	VarDac   := 0

	For idac := 1 To 13
		//Soma a versão 5 do layout, relativo ao ano de 2008
		//_cMult := StrZero(Val(SubStr(BaseDac,idac,1)) * Val(SubStr(StrMult,idac,1)),2)
		//VarDac += Val(SubStr(_cMult,1,1)) + Val(SubStr(_cMult,2,1))

		//Soma válida a partir de 12/2009
		VarDac += Val(SubStr(BaseDac,idac,1)) * Val(SubStr(StrMult,idac,1))
	Next idac

//	nResto := Modulo - (VarDac - (INT(VarDac / Modulo) * Modulo))
	nResto := MOD(VarDac,Modulo)

	If nResto == 0
		VarDac  := "0"
	ElseIf nResto == 1
		VarDac  := "P"
	Else
		VarDac  := Str(Modulo-nResto,1)
	EndIf

	_cNum := _nSeq + VarDac

	dbSelectArea("SE1")
	RecLock("SE1",.F.)
	SE1->E1_NUMBCO  := _cNum
	//SE1->E1_PARCEL	:=strzero(val(_cParcment),2)
	SE1->(MsUnLock())
EndIf

Return(_cNum)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RETJBOL   ºAutor  ³Anderson C. P. Coelho º Data ³ 20/10/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o juros por dia em valor.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RFINR001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RETJBOL(_nJrs)

If !Empty(SE1->E1_PORCJUR)
	_nJrs := Round(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES)*((SE1->E1_PORCJUR/100)),2)
ElseIf !Empty(_nPJurPd)
	_nJrs := Round(SE1->(E1_SALDO-E1_SDDECRE+E1_SDACRES)*((_nPJurPd/100)),2)
EndIf

Return(_nJrs)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³cDigi     ºAutor  ³Anderson C. P. Coelho º Data ³  20/10/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do digito.                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RFINR001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function cDigi()

lBase  := Len(V_Base)
umdois := 2
sumdig := 0
auxi   := 0

iDig := lBase

Do While iDig >= 1
	auxi   := Val (Subs(V_base, idig, 1)) * umdois
	sumdig := SumDig + Iif (auxi < 10, auxi, INT (auxi / 10) + auxi % 10)
	umdois := 3 - umdois
	iDig   := iDig - 1
EndDo

auxi   := Str (Round (sumdig / 10 + 0.49, 0) * 10 - sumdig, 1)
V_Base := V_Base + auxi

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Anderson C. P. Coelho º Data ³  20/10/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Sub-rotina utilizada para verificar se as perguntas ja     º±±
±±º          ³estao cadastradas na SX1, as criando, caso nao existam.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RFINR001                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg()
local i:=0
local j:=0
_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs := {}

_aTam := TamSx3("E1_PREFIXO")
AAdd(aRegs,{cPerg,"01","Prefixo de         ?","","","mv_ch1",_aTam[03],_aTam[01],_aTam[02],0,"G","","mv_par01",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"",""})
AAdd(aRegs,{cPerg,"02","Prefixo ate        ?","","","mv_ch2",_aTam[03],_aTam[01],_aTam[02],0,"G","","mv_par02",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"",""})
_aTam := TamSx3("E1_NUM"    )
AAdd(aRegs,{cPerg,"03","Numero de          ?","","","mv_ch3",_aTam[03],_aTam[01],_aTam[02],0,"G","","mv_par03",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"",""})
AAdd(aRegs,{cPerg,"04","Numero ate         ?","","","mv_ch4",_aTam[03],_aTam[01],_aTam[02],0,"G","","mv_par04",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"",""})
_aTam := TamSx3("E1_NUMBOR" )
AAdd(aRegs,{cPerg,"05","Bordero de         ?","","","mv_ch5",_aTam[03],_aTam[01],_aTam[02],0,"G","","mv_par05",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"",""})
AAdd(aRegs,{cPerg,"06","Bordero ate        ?","","","mv_ch6",_aTam[03],_aTam[01],_aTam[02],0,"G","","mv_par06",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"",""})
AADD(aRegs,{cPerg,"07","Impressora PDF     ?","","","mv_ch7","N"      ,01       ,0        ,0,"C","","mv_par07","Sim","","","","","Não","","","","","","","","","","","","","","","","","","",""   ,"",""})
_aTam := TamSx3("EE_CODIGO" )
AADD(aRegs,{cPerg,"08","Banco              ?","","","mv_ch8",_aTam[03],_aTam[01],_aTam[02],0,"G","","mv_par08",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","","SA6","",""})
_aTam := TamSx3("EE_AGENCIA")
AADD(aRegs,{cPerg,"09","Agencia            ?","","","mv_ch9",_aTam[03],_aTam[01],_aTam[02],0,"G","","mv_par09",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"",""})
_aTam := TamSx3("EE_CONTA"  )
AADD(aRegs,{cPerg,"10","Conta              ?","","","mv_cha",_aTam[03],_aTam[01],_aTam[02],0,"G","","mv_par10",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"",""})
_aTam := TamSx3("EE_SUBCTA" )
AADD(aRegs,{cPerg,"11","Sub-Conta          ?","","","mv_chb",_aTam[03],_aTam[01],_aTam[02],0,"G","","mv_par11",""   ,"","","","",""   ,"","","","","","","","","","","","","","","","","","",""   ,"",""})

For i := 1 To Len(aRegs)
    If !DbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For J:=1 to FCount()
            If J <= Len(aRegs[i])
                FieldPut(J,aRegs[i,j])
            Else
               Exit
            EndIf
        Next
        MsUnlock()
    EndIf
Next

dbSelectArea(_sAlias)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Parcel()   ºAutor  ³ Isaque O. Silva   º Data ³  16/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cálculo numero de parcelas								  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus11 - Específico empresa Labirdental                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
Static Function Parcel()
local _cAlias:= GetNextAlias()
local _cParcel:=""
local cQuery:=""

cQuery :="SELECT COUNT(*) AS [PARC] FROM " +RetSqlName("SE1") + " SE1 "
cQuery +="WHERE SE1.D_E_L_E_T_ = '' "
cQuery += "AND SE1.E1_FILIAL = '" + xFilial("SE1")+ "' "
cQuery +="AND SE1.E1_PREFIXO ='"+SE1->E1_PREFIXO+"'"
cQuery +="AND SE1.E1_NUM ='"+SE1->E1_NUM+"'"
cQuery +="AND SE1.E1_TIPO='"+SE1->E1_TIPO+"'"
cQuery +="AND SE1.E1_CLIENTE='"+SE1->E1_CLIENTE+"'"
cQuery +="AND SE1.E1_LOJA='"+SE1->E1_LOJA+"'"
cQuery := ChangeQuery(cQuery)  // padroniza com o banco existente ChangeQuery

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cAlias,.T.,.F.)
dbSelectArea(_cAlias)
dbgotop()
_cParcel := (_cAlias)->PARC
_cParcel := cvaltochar(_cParcel)

Return(_cParcel)
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Dias()   ºAutor  ³ Júlio Soares        º Data ³  21/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cálculo de dias úteis para validação de data do vencimento.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus11 - Específico empresa Arcolor                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Dias()

Local _nCont := 1
Local _dData := SE1->E1_VENCTO
Local _nDias := Val(SEE->EE_DIASPRT)
While  _nCont <= _nDias
	_dData := _dData + 1 //(incrementar 1 dia no vencimento)
	If _dData == DataValida(_dData,.T.)
		_nCont++
	EndIf
EndDo
_dData := dtoc(_dData)
Return(_dData)

Return()
