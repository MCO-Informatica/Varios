#INCLUDE "RPTDEF.CH"  
#INCLUDE "protheus.ch"
#INCLUDE "FWPrintSetup.ch" 
#Include "Ap5Mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR01   บ Autor ณ Anderson Goncalves บ Data ณ  21/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao e impressao do boleto bancario atraves do pedido   บฑฑ
ฑฑบ          ณ de vendas                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gold Hair                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/ 
                                                                                   
User Function RFATR01(nRecSE1,oPrnExt) 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis da rotina                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private Titulo   	:= OemToAnsi("Boletos Banc rios")
Private cDesc    	:= OemToAnsi("Este programa ira imprimir Boletos Bancarios")
Private wnrel    	:= "RFATR01"
Private aOrd     	:= {}
Private aReturn  	:= { "Zebrado", 1,"Administracao", 2, 2, 2, "",2 }
Private cString  	:= "SE1"
Private cPerg    	:= "RFATR01"
Private nTamanho 	:= "G"         
Private nLastKey 	:= 0
Private nLin     	:= 0
Private lEnd     	:= .F.
Private limite   	:= 80
Private nLastKey 	:= 0
Private lAuto    	:= .F.
Private lImpresAut 	:= .F.

Private oFont		:= Nil
Private cCode		:= ""
Private nHeight   	:= 15
Private lBold     	:= .F.
Private lUnderLine	:= .F.
Private lPixel    	:= .T.
Private lPrint    	:=.F.
Private oFont		:= TFont():New( "Arial",,nHeight,,lBold,,,,,lUnderLine )
Private oFont5		:= TFont():New( "Arial",,5,,.f.,,,,,.f. )
Private oFont6		:= TFont():New( "Arial",,6,,.f.,,,,,.f. ) 
Private oFont7		:= TFont():New( "Arial",,7,,.f.,,,,,.f. ) 
Private oFont9		:= TFont():New( "Arial",,9,,.f.,,,,,.f. )
Private oFont9b		:= TFont():New( "Arial",,9,,.t.,,,,,.f. )
Private oFont10b	:= TFont():New( "Arial",,10,,.t.,,,,,.f.)
Private oFont102	:= TFont():New( "Arial",,10,,.f.,,,,,.f.)
Private oFont10i	:= TFont():New( "Arial",,10,,.t.,,,,.t.,.f. )
Private oFont12		:= TFont():New( "Arial",,12,,.t.,,,,,.f. )
Private oFont12i	:= TFont():New( "Arial",,12,,.t.,,,,.t.,.f. )
Private oFont122	:= TFont():New( "Arial",,12,,.t.,,,,,.f. )
Private oFont14		:= TFont():New( "Arial",,14,,.f.,,,,,.f. )
Private oFont142	:= TFont():New( "Arial Narrow",,14,,.T.,,,,,.f. )
Private oFont152	:= TFont():New( "Arial",,15,,.T.,,,,,.f. )
Private oFont162	:= TFont():New( "Arial Narrow",,14,,.T.,,,,,.f. )
Private oFont18		:= TFont():New( "Arial",,18,,.f.,,,,,.f. )
Private oFont20		:= TFont():New( "Arial",,20,,.f.,,,,,.f. )
Private oFont22		:= TFont():New( "Arial",,22,,.f.,,,,,.f. )

Private oFont8  	:= TFont():New("Arial",9,08,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont10 	:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont16 	:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
Private oFont16n	:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont14n	:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.) //oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
Private oFont24 	:= TFont():New( "Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
Private t1	 		:= 6
Private t15  		:= 8
Private t2	 		:= 10
Private t3	 		:= 12
Private t4	 		:= 16
Private t5	 		:= 18
Private t6	 		:= 24
Private t7	 		:= 36
Private oFt2b		:= TFont():New( "Courier New" ,,t2 ,,.t.,,,,,.f. )

Private _ValBol		:= 0

dbSelectArea("SE1")
SE1->(dbSetOrder(1))
SE1->(dbGoTo(nRecSE1))    

If SE1->E1_ORIGEM <> "MATA410"
	MSGStop("Nใo existem boletos gerados para este titulo!","Aten็ใo")
	Return Nil
Endif

mv_par01 := SE1->E1_PREFIXO
mv_par02 := SE1->E1_NUM
mv_par03 := SE1->E1_NUM

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicia modo grafico                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private nDevice
Private oSetup
Private aDevice  := {}
Private cSession := GetPrinterSession()

cFilePrint := "boleto_"+SC5->C5_NUM+"_"+Dtos(MSDate())+StrTran(Time(),":","")

//oPrn      := FWMSPrinter():New(cFilePrint,6,.T.,,.T.) 
oPrn      := FwMSPrinter():New(cFilePrint,6,.F.,,.T.,,,,,,,.T.) 
oPrn:SetPortrait()   
oPrn:SetResolution(78)
oPrn:SetPaperSize(DMPAPER_A4)
oPrn:SetMargin(60,60,60,60)
oPrn:cPathPDF := GetTempPath()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicia a montagem do relatorio                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({|| Imprime(@oPrn,SE1->(Recno())) },"Imprimindo...")   

oPrn:Preview()

FreeObj(oPrn)                                                                      
oPrn := Nil   

Return({GetTempPath()+cFilePrint+".pdf",cFilePrint+".pdf"})

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImprime   บ Autor ณ Anderson Goncalves บ Data ณ  21/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Impressao do boleto                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gold Hair                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/ 
                                                                                   
Static Function Imprime(oPrn,nRecnoSE1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis da rotina                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private cBitMap 	:= "" //"LogoBr.Bmp"
Private aDadosEmp 	:= {	SM0->M0_NOMECOM,;																//[1]Nome da Empresa
						  	SM0->M0_ENDCOB,; 																//[2]Endere็o
						  	AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; 	//[3]Complemento
						  	"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3),; 				//[4]CEP
						  	"PABX/FAX: "+SM0->M0_TEL,; 														//[5]Telefones
						  	"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+;			//[6]
						  	Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+;							//[6]
						  	Subs(SM0->M0_CGC,13,2),;														//[6]CGC
						  	"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+;				//[7]
						  	Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)}							//[7]I.E
Private aDadosTit	:= {}
Private aDadosBanco	:= {}
Private aDatSacado	:= {}
Private aBolText  	:= {"","",""}
Private _cFixo1   := "4329876543298765432987654329876543298765432"
Private _cFixo2   := "21212121212121212121212121212"
   
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abertura das tabelas                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SE1")
SE1->(dbSetOrder(1))
SE1->(dbGoTo(nRecnoSE1))  

ProcRegua(1)
IncProc("Processando "+AllTrim(SE1->E1_PREFIXO)+"/"+AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA))

_ValBol := CalcTit() // Retorno o Saldo do Titulo menos os titulos de abatimentos 
lImpres := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posiciona no cliente                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
dbSelectArea("SA1")
SA1->(dbSetOrder(1))
If SA1->(!dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA ))
	MsgStop("Cliente do boleto "+SE1->E1_PREFIXO+SE1->E1_NUMERO+SE1->E1_PARCELA+" nao cadastrado!")
    Return(.F.)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posiciona no banco                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
cBanco := SE1->E1_PORTADO 
dbSelectArea("SA6")
SA6->(dbSetOrder(1))
SA6->(dbSeek(xFilial("SA6")+cBanco+SE1->E1_AGEDEP+SE1->E1_CONTA,.F.))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posiciona no cliente                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
dbSelectArea("SEE")
dbSetOrder(1)
If !dbSeek(xFilial("SEE")+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON,.F.)
	MsgStop("Parametros para a conta "+xFilial("SEE")+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON+" nao cadastrada!")
    Return(.F.)
EndIf
  
_DacBco 	:= ""
_NomBco 	:= ""
_NomBc2 	:= ""
cPictBanc	:=""
_cEspDoc 	:=""
_cEspecie 	:="REAL"
_cCartDoc	:=""
_cDescCart	:=""
_nossonum	:=""
_dc      	:=""
cBanco   	:= SA6->A6_COD  

If SA6->A6_COD $ "008/033/353" // Meridional/Santander/Banespa
	cBanco   		:= "033" // Considera Banco 033-BANESPA na composicao do Codigo de Barras
    _DacBco  		:= "033-7"
    _NomBco  		:= "SANTANDER"
    cBitMap  		:= "santander.jpg" //"santander.bmp"
    cPictBanc		:= "@R 999999999999 9"
    _cEspDoc 		:= "DM"
    _cCartDoc		:= "102"
    _cDescCart		:= ""
    If !Empty(SE1->E1_NUMBCO)
    	_nossonum 	:= SUBSTR(SE1->E1_NUMBCO,1,12)
        _dc       	:= SUBSTR(SE1->E1_NUMBCO,13,1)
    Else      
        _nossonum 	:= STRZERO(VAL(SEE->EE_FAXATU),12)
        _dc       	:= Modulo11(_Nossonum)         // Calculo do Digito de Verificacao
    EndIf

ElseIf SA6->A6_COD == "275"
    _DacBco 	:= "275-5"
    _NomBco 	:= "BANCO REAL"
    cPictBanc	:= "@R 9999999"
    _cEspDoc 	:= "NB"
    _cCartDoc	:= "20"
    _cDescCart	:=""
    _nossonum	:= SEE->EE_FAXATU
    _dc      	:= "" // NAO TEM DV  
    
ElseIf SA6->A6_COD == "399"
    _DacBco 	:= "399-9"
    _NomBco 	:= "HSBC"
    _NomBc2 	:= "BANK BRASIL"
    cPictBanc	:= "@R 99 999 999 99 9"
    _cEspDoc 	:= "PD"
    _cCartDoc	:= "CSB"
    _cDescCart	:=""
    _nossonum	:= SEE->EE_FAXATU
    _dc       	:= U_DCHSBC(_Nossonum)         // Calculo do Digito de Verificacao

ElseIf SA6->A6_COD == "479"
    _DacBco 	:= "479-9"
    _NomBco 	:= "BOSTON"
    _NomBc2 	:= "BANK BOSTON"
    cPictBanc	:="@R 99999999-9"
    _cEspDoc 	:= "DM"
    _cCartDoc	:= "RAP"
    _cDescCart	:=""
    _nossonum	:= Alltrim(SEE->EE_FAXATU)
    If (Val(SEE->EE_FAXFIM) - Val(SEE->EE_FAXATU)) <= 50 .And. (Val(SEE->EE_FAXFIM) - Val(SEE->EE_FAXATU)) > 0
    	msgInfo("Solicitar nova faixa de n๚meros bancแrios ao Banco Boston")
    ElseIf Val(SEE->EE_FAXFIM) - Val(SEE->EE_FAXATU) <= 0
        msgInfo("Nใo existe faixa de n๚meros bancแrios disponํveis, favor solicitar ao Banco Boston")
        Return(.F.)
    EndIf
    _dc         := U_DCBOSTON(_Nossonum)         // Calculo do Digito de Verificacao

ElseIf SA6->A6_COD == "001"
    _DacBco     := "001-9"
    _NomBco     := "BANCO BRASIL" 
    _NomBc2     := "BANCO DO BRASIL"
    _cEspDoc    := "DM"
    _cEspecie   := "R$"
    _cCartDoc   := "17/019" //"17-019" 
    _cDescCart  := ""
    cConvenio   := "1259019"
    cBitMap     := "bb.jpg" 
    cPictBanc   := "@R 99999999999999999"
    cPictBanc2  := "@R 99999999999999999"
    If Empty(SE1->E1_NUMBCO)
    	_nossonum := U_NNBRASIL()
    Else
        _nossonum := SE1->E1_NUMBCO
        If LEFT(_nossonum,LEN(cConvenio)) <> cConvenio 
        	MsgStop("Titulo emitido para outro convenio!")
        	Return(.F.)
        EndIf
    EndIf
    _dc       := ""   
    
ElseIf SA6->A6_COD $ "104" //Caixa Economica Federal
	cBanco   		:= "104" 
    _DacBco  		:= "104-0"
    _NomBco  		:= "CEF"
    cBitMap  		:= "caixa.jpg" 
    cPictBanc		:= "@R 999999999999999 9"
    _cEspDoc 		:= "DM"
    _cCartDoc		:= "SR"
    _cDescCart		:= " "
    If !Empty(SE1->E1_NUMBCO)
    	_nossonum 	:= SUBSTR(SE1->E1_NUMBCO,1,15)
        _dc       	:= SUBSTR(SE1->E1_NUMBCO,16,1)
    Else      
        _nossonum 	:= "8"+STRZERO(VAL(SEE->EE_FAXATU),14)
        _dc       	:= Modulo11(_Nossonum)         // Calculo do Digito de Verificacao
    EndIf
    
ElseIf SA6->A6_COD == "341"
    _DacBco   	:= "341-7" 
    cBitMap     := "itau.jpg" 
    _NomBco   	:= "BANCO ITAU S/A"
    _NomBc2   	:= "BANCO ITAU S.A."      
    cPictBanc 	:= "@R 999/99999999-9"
    cPictBanc2	:= "@R 999999999999"
    _cEspDoc  	:= "DM" //"DV"
    _cCartDoc 	:= "109" //ATUAL 112 BOLETO BANCO
    _cDescCart	:= ""
    If !Empty(SE1->E1_NUMBCO)
    	_nossonum := SUBSTR(SE1->E1_NUMBCO,01,08)
        _dc       := SUBSTR(SE1->E1_NUMBCO,09,01)
    Else
        _nossonum := _cCartDoc+STRZERO(VAL(SEE->EE_FAXATU),08)
        _dc       := Modulo10(PADR(SA6->A6_AGENCIA,4)+PADR(SA6->A6_NUMCON,5)+_Nossonum)  // Calculo do Digito de Verificacao 
    EndIf 
    
ElseIf SA6->A6_COD == "422" // SAFRA
	_DacBco   	:= "422-7"
    _NomBco   	:= "SAFRA"
    _NomBc2   	:= "BANCO SAFRA SA"
    cPictBanc 	:= "@R 99999999-9"
    cPictBanc2	:= "@R 999999999"
    _cEspDoc  	:= "DM"
    _cCartDoc 	:= "02"
    _cDescCart	:= ""
    If !Empty(SE1->E1_NUMBCO)
       	_nossonum := SUBSTR(SE1->E1_NUMBCO,01,08)
       	_dc       := SUBSTR(SE1->E1_NUMBCO,09,01)
    Else
        _nossonum := STRZERO(VAL(SEE->EE_FAXATU),08)
        _dc       := Mod11Safra(_Nossonum)//Modulo11(_Nossonum)  // Calculo do Digito de Verificacao
    EndIf
   
ElseIf SA6->A6_COD == "237" // BRADESCO
    _DacBco   := "237-2"
    _NomBco   := "BRADESCO"
    _NomBc2   := "BANCO BRADESCO S.A."
    cPictBanc := "@R 99 / 99999999999-X"
    cPictBanc2:= "@R 99 / 99999999999X"
    _cEspDoc  := "DM"
    _cCartDoc := "09" //"02"
    _cDescCart:= ""
    If !Empty(SE1->E1_NUMBCO)
    	_nossonum := SUBSTR(SE1->E1_NUMBCO,01,11)
        _dc       := SUBSTR(SE1->E1_NUMBCO,12,01)
    Else
        _nossonum := STRZERO(VAL(SEE->EE_FAXATU),11)
        _dc       := Mod11Base7(_cCartDoc+_Nossonum)  // Calculo do Digito de Verificacao
    EndIf
   
ElseIf SA6->A6_COD == "745"
    _DacBco   := "745" //-7"
    _NomBco   := "CITIBANK"      
    _NomBc2   := "CITIBANK"      
    cPictBanc := "@R 999/99999999-9"
    cPictBanc2:= "@R 999999999999"
    _cEspDoc  := "DM"
    _cCartDoc := "112"
    _cDescCart:= ""
    If !Empty(SE1->E1_NUMBCO)
        _nossonum := SUBSTR(SE1->E1_NUMBCO,01,11)
        _dc       := SUBSTR(SE1->E1_NUMBCO,12,01)
    Else
        _nossonum := _cCartDoc+STRZERO(VAL(SEE->EE_FAXATU),08)
        _dc       := Modulo10(PADR(SA6->A6_AGENCIA,4)+PADR(SA6->A6_NUMCON,5)+_Nossonum)  // Calculo do Digito de Verificacao 
    EndIf      
EndIf

If SA6->A6_COD <> "001"    // Nใo ้ o Brasil
	If Empty(SE1->E1_NUMBCO) // Soh grava o SEE se o SE1->E1_NUMBCO estiver em Branco      
    	dbselectarea("SEE")
        RecLock("SEE",.F.)
        SEE->EE_FAXATU := SOMA1(ALLTRIM(SEE->EE_FAXATU))
        MsUnLock()
    EndIf
    _NossoNum := Alltrim(_NossoNum) + _Dc
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem do codigo de barras                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cCodBarra := cBanco //SA6->A6_COD                  && 03 Banco
cCodBarra += "9"                                   && 01 Moeda (no banco)
If SA6->A6_COD == "275" // Real
	cCodBarra += "0000"
	cCodBarra += StrZero((_ValBol*100),10) && 10 Valor
Else
	cCodBarra += StrZero(SE1->E1_VENCREA-CTOD("07/10/1997"),4)
	cCodBarra += StrZero((_ValBol*100),10) && 10 Valor
EndIf

// Monta as 25 posi็oes do CAMPO LIVRE com as informa็oes pertinentes a cada banco
If SA6->A6_COD == "001"  
	cCodBarra += _nossonum
  	cCodBarra += "17" 
  	
ElseIf SA6->A6_COD == "104" 
    cCodBarra += "00236"
	cCodBarra += StrZero(Val(Left(AllTrim(SA6->A6_AGENCIA),4)),4)
    cCodBarra += "87"
    cCodBarra += SubStr(_nossonum,2,14)   
    
ElseIf SA6->A6_COD $ "008/033/353" // Meridional/Santander/Banespa
    cCodBarra += "9"
    cCodBarra += "1484338" 
    cCodBarra += PADR(STRZERO(VAL(_nossonum),13),13)   
    cCodBarra += "0"                                    // IOS - SEGURADORAS (SE 7% informar 7 Limitado a 9% ), demais clientes usar 0 (Zero)
    cCodBarra += "102"  
    
ElseIf SA6->A6_COD == "275" // Real
    // Calculo do Digitao - Somente para o Banco Real
    _BaseCal := StrZero(Val(Left(AllTrim(_nossonum      ),7)),7)+;    //SE1->E1_NUMBCO
                StrZero(Val(Left(AllTrim(SA6->A6_AGENCIA),4)),4)+;
                StrZero(Val(Left(AllTrim(SA6->A6_NUMCON ),7)),7)
    _ResMul := 0
    _cFixoNow   := Right(_cFixo2,Len(_BaseCal))
    For _nCont := Len(_BaseCal) to 1 Step -1
    	_nMult := (Val(Substr(_BaseCal,_nCont,1))*Val(Substr(_cFixoNow,_nCont,1)))
        If _nMult > 9
        	_nMult -= 9
        EndIf
        _ResMul += _nMult
    Next
    
    _ResMul := (_ResMul%10)
    
    If _ResMul == 0
    	_ResMul := "0"
    Else
        _ResMul := Str(10-_ResMul,1)
    EndIf
    
    cCodBarra += StrZero(Val(Left(AllTrim(SA6->A6_AGENCIA),4)),4)
    cCodBarra += StrZero(Val(Left(AllTrim(SA6->A6_NUMCON ),7)),7)
    cCodBarra += _ResMul // VERIGICAR DIGITAO
    cCodBarra += StrZero(Val(Left(AllTrim(_nossonum      ),13)),13)   //SE1->E1_NUMBCO

ElseIf SA6->A6_COD == "399" // HSBC
    cCodBarra += StrZero(Val(Left(AllTrim(_nossonum      ),11)),11)   //SE1->E1_NUMBCO
    cCodBarra += StrZero(Val(Left(AllTrim(SA6->A6_AGENCIA),4)),4)
    cCodBarra += StrZero(Val(Left(AllTrim(SA6->A6_NUMCON ),7)),7)
    cCodBarra += "00"
    cCodBarra += "1"

ElseIf SA6->A6_COD == "479" // Boston
    cCodBarra += StrZero(Val(Left(AllTrim("1725119"),9)),9)
    cCodBarra += "000000"
    cCodBarra += StrZero(Val(Left(AllTrim(_nossonum      ),9)),9)    //SE1->E1_NUMBCO
    cCodBarra += "8"   

ElseIf SA6->A6_COD == "341"  //ITAU
    cCodBarra += StrZero(Val(Left(AllTrim(_nossonum),12)),12)     // Nosso Numero   
    cCodBarra += StrZero(Val(Left(AllTrim(SA6->A6_AGENCIA),4)),4)
    cCodBarra += StrZero(Val(Left(AllTrim(SA6->A6_NUMCON ),6)),6)
    cCodBarra += "000"                                            // Posicao Livres Zeros

ElseIf SA6->A6_COD == "422"  //SAFRA
    cCodBarra += "7"        // Sistema
    cCodBarra += StrZero(Val(AllTrim(SA6->A6_AGENCIA)),5)
    cCodBarra += StrZero(Val(AllTrim(SA6->A6_NUMCON )),9)
    cCodBarra += StrZero(Val(Left(AllTrim(_nossonum),09)),09)
    cCodBarra += "2"        // Tipo de Cobranca

ElseIf SA6->A6_COD == "237" //BRADESCO
    cCodBarra += StrZero(Val(AllTrim(SA6->A6_AGENCIA)),4)         // AGENCIA      04 POS AGENCIA SEM O DIGITO
    cCodBarra += _cCartDoc                                        // CARTEIRA     02 POS
    cCodBarra += StrZero(Val(LEFT(AllTrim(_nossonum),11)),11)     // NOSSO NUMERO 11 POS
    If LEN(ALLTRIM(SA6->A6_NUMCON)) = 5
	    cCodBarra += StrZero(Val(AllTrim(LEFT(SA6->A6_NUMCON,4))),7)  // CONTA        07 POS CONTA SEM O DIGITO
    Else 
        cCodBarra += StrZero(Val(AllTrim(LEFT(SA6->A6_NUMCON,5))),7)  // CONTA        07 POS CONTA SEM O DIGITO
    EndIf      
    cCodBarra += "0"                                              // FIXO         01 POS

ElseIf SA6->A6_COD == "745"  //CITIBANK
    cCodBarra += "3"                                              // Codigo do Produto 
                   //3-Cobranca com Registro/Sem registro, 4-Cobranca de seguro-s/registro
    cCodBarra += _cCartDoc                                        // Portifolio 3 ult digitos da id empresa (pos 44 a 46 arq retorno)
    cCodBarra += "000000"                                         // Base
    cCodBarra += "00"                                             // Sequencia                 
    cCodBarra += "0"                                              // Digito Conta Cosmos             
    cCodBarra += StrZero(Val(Left(AllTrim(_nossonum),12)),12)     // Nosso Numero         
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Calculo do DV Geral                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nSomaGer := 0
For nI := 1 to 43
	nSomaGer := nSomaGer + Val(Substr(cCodBarra,nI,1))*Val(Substr(_cFixo1,nI,1))
Next nI

If SA6->A6_COD <> "479" // Nใo ้ o Boston
	If (11-(nSomaGer%11)) > 9
	    cCalcDv := "1"
    Else
        cCalcDv := Str(11-(nSomaGer%11),1)
    EndIf

Else
    If (11-(nSomaGer%11)) > 9 .Or. (11-(nSomaGer%11)) == 0 .Or. (11-(nSomaGer%11)) == 1
        cCalcDv := "1"
    Else
        cCalcDv := Str(11-(nSomaGer%11),1)
    EndIf   

EndIf

cCodBarra := Left(cCodBarra ,4) + cCalcDv + Right(cCodBarra,39)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta sequencia de codigos para o topo do boleto                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cLinDig := Left(cCodBarra,4) + Substr(cCodBarra,20,5) + Substr(cCodBarra,25,10) + Substr(cCodBarra,35,10)

nSoma1 := 0
nSoma2 := 0
nSoma3 := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Calcula o DV do primeiro Bloco                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nI := 1 to 9
	_nRes := Val(Substr(cLinDig,nI,1))*Val(Substr(_cFixo2,nI,1))  //_nRes := Val(Substr(cLinDig,nI,1))*Val(Substr(_FixVar,nI,1))
    If _nRes > 9
    	_nRes := 1 + (_nRes-10)
    EndIf
    nSoma1 := nSoma1 + _nRes
Next nI

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Calcula o DV do segundo bloco                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nI := 10 to 19
   	_nRes := Val(Substr(cLinDig,nI,1))*Val(Substr(_cFixo2,nI,1)) //_nRes := Val(Substr(cLinDig,nI,1))*Val(Substr(_FixVar,nI,1))
   	If _nRes > 9
   		_nRes := 1 + (_nRes-10)
    EndIf
    nSoma2 := nSoma2 + _nRes 
Next nI

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Calcula o DV do terceiro Bloco                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_FixVar := Right(_cFixo2,10)
For nI := 20 to 29
	_nRes := Val(Substr(cLinDig,nI,1))*Val(Substr(_cFixo2,nI,1)) //_nRes := Val(Substr(cLinDig,nI,1))*Val(Substr(_FixVar,nI,1))
    If _nRes > 9
    	_nRes := 1 + (_nRes-10)
    EndIf
    nSoma3 := nSoma3 + _nRes
Next

cSoma1 := Right(StrZero(10-(nSoma1%10),2),1)
cSoma2 := Right(StrZero(10-(nSoma2%10),2),1)
cSoma3 := Right(StrZero(10-(nSoma3%10),2),1) 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Uso as funcoes StrZero e Right para pegar o nro correto quando o resto de nSoma/10 for 0 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta sequencia de codigos para o topo do boleto com os dvs e o valorณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If SA6->A6_COD <> "275" // Nao ้ o Real
	cLinDig := Left(cCodBarra,4) + Substr(cCodBarra,20,5) + cSoma1 +;
	           Substr(cCodBarra,25,10) + cSoma2+ Substr(cCodBarra,35,10)+ cSoma3 +;
	           cCalcDv + Substr(cCodBarra,6,4) + StrZero((_ValBol*100),10)
Else
	cLinDig := Left(cCodBarra,4) + Substr(cCodBarra,20,5) + cSoma1 +;
	           Substr(cCodBarra,25,10) + cSoma2+ Substr(cCodBarra,35,10)+ cSoma3 +;
	           cCalcDv + Alltrim(Str((_ValBol*100),10))
EndIf

If Empty(SE1->E1_NUMBCO)
	dbSelectArea("SE1")
	RecLock("SE1",.F.)
	SE1->E1_NUMBCO := AllTrim(_NossoNum)
	If Empty(SE1->E1_PORTADO) .Or. Empty(SE1->E1_AGEDEP) .Or. Empty(SE1->E1_CONTA)
		SE1->E1_PORTADO := SA6->A6_COD
	    SE1->E1_AGEDEP  := SA6->A6_AGENCIA
	    SE1->E1_CONTA   := SA6->A6_NUMCON
	EndIf
	SE1->E1_CODBAR := cCodBarra
	SE1->E1_CODDIG := cLinDig
	MsUnLock()
EndIf

dbSelectArea("SA1")
dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.F.)

Set Century On
lImpres := .T.
lImpresAut := .T.

If SA6->A6_COD == "033" 
	cLocPag := "Pagar preferencialmente no Grupo Santander - GC"
ElseIf SA6->A6_COD == "399"
    cLocPag := "Pagar preferencialmente em ag๊ncia HSBC Bank Brasil"  
ElseIf SA6->A6_COD == "104"
	cLocPag := "Casas Lotericas, Ag.Caixa e Rede Bancaria"
Else
    cLocPag := "Pagavel em qualquer banco at้ o vencimento"
EndIf                 
   
If SA6->A6_COD $ "008/033/353" // Meridional/Santander/Banespa
	If SA6->A6_COD == "033" .And. ALLTRIM(SA6->A6_AGENCIA) == "0188"                                                          
    	cAgencia  := LEFT(SA6->A6_AGENCIA,4)+"-"+"0"
        cConta    := AllTrim(SEE->EE_CODEMP)
        cDigConta := " "
    Else   
        cAgencia  := Right(AllTrim(SA6->A6_AGENCIA),3)
        cConta    := SUBSTR(SEE->EE_CODEMP,1,Len(AllTrim(SEE->EE_CODEMP))-1)
        cDigConta := SUBSTR(SEE->EE_CODEMP,Len(AllTrim(SEE->EE_CODEMP)),1)
    EndIf
   
ElseIf SA6->A6_COD == "001"
    cAgencia  := "0"+SUBSTR(SA6->A6_AGENCIA,1,4)+"-"+SUBSTR(SA6->A6_AGENCIA,5,1)  //Alltrim(SA6->A6_AGENCIA)
    cConta    := SUBSTR(SA6->A6_NUMCON,1,5)   //SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1) //AllTrim(SA6->A6_NUMCON)
    cDigConta := SUBSTR(SA6->A6_NUMCON,7,1)   //SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)

Else
    cAgencia  := SUBSTR(SA6->A6_AGENCIA,1,4)                             //Alltrim(SA6->A6_AGENCIA)
    cConta    := SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1) //AllTrim(SA6->A6_NUMCON)
    cDigConta := SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)
EndIf

If SA6->A6_COD == "001"  .And. _dc == "X"   // Brasil
	cNossoNum := Transform(_nossonum,cPictBanc2)+"-X"
Else
    cNossoNum := Transform(_nossonum,cPictBanc)
EndIf                 
   
aDadosBanco := {	SA6->A6_COD,;									// [1]Numero do Banco
					IIF(SA6->A6_COD = "001",_NomBc2,_NomBco),;		// [2]Nome do Banco
					cAgencia,;								        // [3]Agencia
					cConta,;	                                    // [4]Conta Corrente
					cDigConta,;	                                    // [5]Digito da conta corrente
					_cCartDoc+" "+_cDescCart,;						// [6]Codigo da Carteira
					_DacBco,;                                      	// [7]Numero do Banco com DAC Ex. 033-7						 
					cLocPag}                                        // [8]Local de Pagamento
                
If Empty(SA1->A1_ENDCOB)                                                                                                                     
	aDatSacado := {	AllTrim(SA1->A1_NOME),;									// [1]Razao Social
					AllTrim(SA1->A1_COD)+"-"+SA1->A1_LOJA,;				// [2]Codigo
					AllTrim(SA1->A1_END)+"-"+AllTrim(SA1->A1_BAIRRO),;		// [3]Endereco
					AllTrim(SA1->A1_MUN),;									// [4]Cidade
					SA1->A1_EST,;											// [5]Estado
					SA1->A1_CEP,;											// [6]CEP
					SA1->A1_CGC}											// [7]CGC
Else
	aDatSacado := {	AllTrim(SA1->A1_NOME),;									// [1]Razao Social
					AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA,;				// [2]Codigo
					AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;	// [3]Endereco
					AllTrim(SA1->A1_MUNC),;									// [4]Cidade
					SA1->A1_ESTC,;											// [5]Estado
					SA1->A1_CEPC,;											// [6]CEP
					SA1->A1_CGC}											// [7]CGC
EndIf                           
                                   
cLinDig := SUBSTR(cLinDig,1,5)+"."+SUBSTR(cLinDig,6,5)+" "+SUBSTR(cLinDig,11,5)+"."+SUBSTR(cLinDig,16,6)+" "+SUBSTR(cLinDig,22,5)+"."+SUBSTR(cLinDig,27,6)+" "+SUBSTR(cLinDig,33,1)+" "+SUBSTR(cLinDig,34)                                                                                                            
CB_RN_NN  := {cCodBarra,cLinDig,cNossoNum}             
aDadosTit := {	AllTrim(SE1->E1_NUM)+AllTrim(SE1->E1_PARCELA),;    	// [1] Numero do Titulo
				SE1->E1_EMISSAO,;								    	// [2] Data da Emissao do Titulo
				Date(),;									        	// [3] Data da Emissao do Boleto
				SE1->E1_VENCREA,;							        	// [4] Data do Vencimento
				_ValBol,;						                    	// [5] Valor do Titulo
				CB_RN_NN[3],;									    	// [6] Nosso Numero (Ver Formula para Calculo)
				SE1->E1_PREFIXO,;										// [7] Prefixo da NF
				_cEspDoc,;									    		// [8] Especie do Documento
				_cEspecie}                                        		// [9] Especie Moeda
	                                          
	
_nTxMul := 2
_Mul := Round(SE1->E1_VLMULTA,2) //Round((_ValBol*_nTxMul) / 100,2)  				
_Jrs := Round(SE1->E1_VALJUR,2)  //Round((_ValBol*GETMV("MV_TXPER")) / 100,2)   
    
If SA6->A6_COD $ "008/033/353" // Meridional/Santander/Banespa
    aBolText[1] := "PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO, APำS VENCIMENTO COBRAR "
	aBolText[2] := "MULTA DE R$ "+AllTrim(Transform((aDadosTit[5]*3)/100,"@E 9,999.99")) +" MAIS JUROS DE R$ "+AllTrim(Transform((aDadosTit[5]*0.1)/100,"@E 9,999.99")) + " POR DIA DE ATRASO."
	aBolText[3] := " " 
ElseIf SA6->A6_COD == "001"
    aBolText[1] := "PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO, APำS VENCIMENTO COBRAR "
	aBolText[2] := "MULTA DE R$ "+AllTrim(Transform((aDadosTit[5]*3)/100,"@E 9,999.99")) +" MAIS JUROS DE R$ "+AllTrim(Transform((aDadosTit[5]*0.1)/100,"@E 9,999.99")) + " POR DIA DE ATRASO."
	aBolText[3] := " " 
ElseIf SA6->A6_COD == "479"       
    aBolText[1] := "PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO, APำS VENCIMENTO COBRAR "
	aBolText[2] := "MULTA DE R$ "+AllTrim(Transform((aDadosTit[5]*3)/100,"@E 9,999.99")) +" MAIS JUROS DE R$ "+AllTrim(Transform((aDadosTit[5]*0.1)/100,"@E 9,999.99")) + " POR DIA DE ATRASO."
	aBolText[3] := " " 
ElseIf SA6->A6_COD == "341"  
    aBolText[1] := "PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO, APำS VENCIMENTO COBRAR "
	aBolText[2] := "MULTA DE R$ "+AllTrim(Transform((aDadosTit[5]*3)/100,"@E 9,999.99")) +" MAIS JUROS DE R$ "+AllTrim(Transform((aDadosTit[5]*0.1)/100,"@E 9,999.99")) + " POR DIA DE ATRASO."
	aBolText[3] := " " 
ElseIf SA6->A6_COD == "104"  
	aBolText[1] := "APำS O VENCIMENTO, COBRA MULTA DE R$ "+AllTrim(Transform((aDadosTit[5]*3)/100,"@E 9,999.99")) +" MAIS JUROS DE R$ "+AllTrim(Transform((aDadosTit[5]*0.1)/100,"@E 9,999.99")) + " POR DIA DE ATRASO."
	aBolText[2] := "  "
	aBolText[3] := "  " 
ElseIf SA6->A6_COD == "033"  
    aBolText[1] := "PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO, APำS VENCIMENTO COBRAR "
	aBolText[2] := "MULTA DE R$ "+AllTrim(Transform((aDadosTit[5]*3)/100,"@E 9,999.99")) +" MAIS JUROS DE R$ "+AllTrim(Transform((aDadosTit[5]*0.1)/100,"@E 9,999.99")) + " POR DIA DE ATRASO."
	aBolText[3] := " " 
EndIf     

// Modo Grafico
ModoGrafico(oPrn)

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บ Autor ณ Anderson Goncalves บ Data ณ  21/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao do SX1                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gold Hair                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/ 

Static Function ValidPerg()

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))
aRegs:={}

// X1_GRUPO  X1_ORDEM X1_PERGUNT		                X1_PERSPA		                 X1_PERENG  		              X1_VARIAVL X1_TIPO X1_TAMANHO X1_DECIMAL	X1_PRESEL  X1_GSC X1_VALID X1_VAR01	   X1_DEF01          X1_DEFSPA1       X1_DEFENG1      X1_CNT01	 	    X1_VAR02 X1_DEF02         X1_DEFSPA2       X1_DEFENG2       X1_CNT02 X1_VAR03 X1_DEF03 X1_DEFSPA3 X1_DEFENG3 X1_CNT03 X1_VAR04 X1_DEF04 X1_DEFSPA4 X1_DEFENG4 X1_CNT04 X1_VAR05 X1_DEF05  X1_DEFSPA5 X1_DEFENG5 X1_CNT05 X1_F3 X1_GRPSXG    X1_HELP
aAdd(aRegs,{cPerg,"01","Do Prefixo:         ","Do Prefixo:         ","Do Prefixo:         ","mv_ch1"  ,"C"     ,3		   ,0		   ,0		 ,"G"	,""		 ,"mv_par01" ,""	           ,""		        ,""		        ,""	              ,""	   ,""	  	        ,""		         ,""		      ,""	   ,""		        ,""		         ,""	        ,""		 ,""	  ,""		 ,""	    ,""	     ,""	  ,""       ,""	       ,""		  ,""	   ,""	  ,""	,""   ,""})
aAdd(aRegs,{cPerg,"02","Do Numero:          ","Do Numero:          ","Do Numero:          ","mv_ch2"  ,"C"     ,9		   ,0		   ,0		 ,"G"	,""		 ,"mv_par02" ,""	           ,""		        ,""		        ,""	              ,""	   ,""	  	        ,""		         ,""		      ,""	   ,""		        ,""		         ,""	        ,""		 ,""	  ,""		 ,""	    ,""	     ,""	  ,""       ,""	       ,""		  ,""	   ,""	  ,""	,""   ,""})
aAdd(aRegs,{cPerg,"03","Ate Numero:         ","Ate Numero:         ","Ate Numero:         ","mv_ch3"  ,"C"     ,9		   ,0		   ,0		 ,"G"	,""		 ,"mv_par03" ,""	           ,""		        ,""		        ,""	              ,""	   ,""	  	        ,""		         ,""		      ,""	   ,""		        ,""		         ,""	        ,""		 ,""	  ,""		 ,""	    ,""	     ,""	  ,""       ,""	       ,""		  ,""	   ,""	  ,""	,""   ,""})
aAdd(aRegs,{cPerg,"04","Mensagem 1:         ","Mensagem 1:         ","Mensagem 1:         ","mv_ch4"  ,"C"     ,30		   ,0		   ,0		 ,"G"	,""		 ,"mv_par04" ,""	           ,""		        ,""		        ,""	              ,""	   ,""	  	        ,""		         ,""		      ,""	   ,""		        ,""		         ,""	        ,""		 ,""	  ,""		 ,""	    ,""	     ,""	  ,""       ,""	       ,""		  ,""	   ,""	  ,""	,""   ,""})
aAdd(aRegs,{cPerg,"05","Mensagem 2:         ","Mensagem 2:         ","Mensagem 2:         ","mv_ch5"  ,"C"     ,30	       ,0		   ,0		 ,"G"	,""		 ,"mv_par05" ,""	           ,""		        ,""		        ,""	              ,""	   ,""	  	        ,""		         ,""		      ,""	   ,""		        ,""		         ,""	        ,""		 ,""	  ,""		 ,""	    ,""	     ,""	  ,""       ,""	       ,""		  ,""	   ,""	  ,""	,""   ,""})
aAdd(aRegs,{cPerg,"06","Mensagem 3:         ","Mensagem 3:         ","Mensagem 3:         ","mv_ch6"  ,"C"     ,30	       ,0		   ,0		 ,"G"	,""		 ,"mv_par06" ,""	           ,""		        ,""		        ,""	              ,""	   ,""	  	        ,""		         ,""		      ,""	   ,""		        ,""		         ,""	        ,""		 ,""	  ,""		 ,""	    ,""	     ,""	  ,""       ,""	       ,""		  ,""	   ,""	  ,""	,""   ,""})
aAdd(aRegs,{cPerg,"07","Tipo de Papel       ","Tipo de Papel       ","Tipo de Papel       ","mv_ch7"  ,"N"     ,1 	       ,0		   ,1		 ,"C"	,""		 ,"mv_par07" ,"A4"             ,"A4"		    ,"A4"           ,""	              ,"CARTA" ,"CARTA"	        ,"CARTA"         ,""		      ,""	   ,""		        ,""		         ,""	        ,""		 ,""	  ,""		 ,""	    ,""	     ,""	  ,""       ,""	       ,""		  ,""	   ,""	  ,""	,""   ,""})

For i := 1 To Len(aRegs)
	If  !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
			   FieldPut(j,aRegs[i,j])
            EndIf
		Next
		MsUnlock()
    EndIf
Next

dbSelectArea(_sAlias)

Return Nil 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDCHSBC    บ Autor ณ Anderson Goncalves บ Data ณ  21/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Digito HSBC                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gold Hair                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/ 

User Function DCHSBC(_cNum)

cFatores := "5432765432"          // Fatores para Multiplicacao
cNumBanc := _cNum                 // Numero Bancario com 10 Posicoes
nValor   := 0                     // Valor da Multiplicacao
nSoma    := 0                     // Valor da Soma dos Resultados

For i := 1 To 10
    nValor := Val(Substr(cNumBanc, i, 1)) * Val(Substr(cFatores, i, 1))
    nSoma  := nSoma + nValor
Next

wxxx := Mod(nSoma,11) // Resto
cDigNsNum := 11 - wxxx

If wxxx == 0 .Or. wxxx == 1    
	cDigNsNum := 0	
EndIf

cDigNsNum := Strzero(cDigNsNum, 1)      // Digito de Verificacao

Return (cDigNsNum)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDCBOSTON  บ Autor ณ Anderson Goncalves บ Data ณ  21/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Digito Boston                                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gold Hair                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function DCBOSTON(_cNum)

cFatores := "98765432"            // Fatores para Multiplicacao
cNumBanc := _cNum                 // Numero Bancario com 8 Posicoes
nValor   := 0                     // Valor da Multiplicacao
nSoma    := 0                     // Valor da Soma dos Resultados

For i := 1 To 8
    nValor := Val(Substr(cNumBanc, i, 1)) * Val(Substr(cFatores, i, 1))
    nSoma  := nSoma + nValor
Next

nSoma := nSoma * 10
wxxx  := Mod(nSoma,11) // Resto
cDigNsNum := wxxx

If wxxx == 10   
	cDigNsNum := 0	
EndIf

cDigNsNum := Strzero(cDigNsNum, 1)      // Digito de Verificacao

Return (cDigNsNum) 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNNBRASIL  บ Autor ณ Anderson Goncalves บ Data ณ  21/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ numero banco do brasil                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gold Hair                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function NNBRASIL()

Local aArea := GetArea()
_nossonum 	:= PADR(cConvenio,7)+RIGHT(ALLTRIM(SEE->EE_FAXATU),10) // 17 Digitos
_dc       	:= ""

dbselectarea("SEE")
RecLock("SEE",.F.)
  	SEE->EE_FAXATU := SOMA1(ALLTRIM(SEE->EE_FAXATU))
MsUnLock()

RestArea(aArea)

Return(_nossonum+_dc) 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณModoGraficบ Autor ณ Anderson Goncalves บ Data ณ  21/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Impressao modelo grafico                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Gold Hair                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/ 

Static Function ModoGrafico(oPrn)

Local  _nLin := 0 //200                       

oPrn:StartPage()              

If SubStr(aDadosBanco[7],1,3) <> "104" 

	oPrn:Line(_nLin+0035,0026,_nLin+0035,0606) //L1
	oPrn:Line(_nLin+0065,0026,_nLin+0065,0606) //L2
	oPrn:Line(_nLin+0094,0026,_nLin+0094,0606) //L3
	oPrn:Line(_nLin+0384,0026,_nLin+0384,0606) //L4
	oPrn:Line(_nLin+0474,0026,_nLin+0474,0606) //L5    
		
	oPrn:Line(_nLin+0035,0148,_nLin+0005,0148) //C1
	oPrn:Line(_nLin+0035,0211,_nLin+0005,0211) //C2
	oPrn:Line(_nLin+0094,0501,_nLin+0035,0501) //C3    
	oPrn:Line(_nLin+0094,0262,_nLin+0065,0262) //C4    
	oPrn:Line(_nLin+0094,0407,_nLin+0065,0407) //C5    

	If !Empty(cBitMap)                       						//450,070
		oPrn:SayBitmap( _nLin+0013,0026,cBitMap,120,020)     		// Bitmap com Logo do Banco
	Else
		oPrn:Say (_nLin+0020,0026,aDadosBanco[2],oFont16)					// [2] Nome do Banco
	EndIf
	   
	oPrn:Say (_nLin+0029,0150,aDadosBanco[7],oFont24)					// [1] Numero do Banco 
	oPrn:Say (_nLin+0029,0216,CB_RN_NN[2],oFont14n)                    // Linha digitavel
	oPrn:Say (_nLin+0000,0520,"Recibo do Sacado",oFont10)
	oPrn:Say (_nLin+0045,0026,"Cedente",oFont8)
	oPrn:Say (_nLin+0060,0026,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6],oFont10)					// [1] Nome + CNPJ
	oPrn:Say (_nLin+0045,0503,"Vencimento",oFont8)
	oPrn:Say (_nLin+0060,0514,DTOC(aDadosTit[4]),oFont10)

	oPrn:Say (_nLin+0075,0026,"Sacado",oFont8)
	oPrn:Say (_nLin+0089,0026,aDatSacado[1],oFont10)					// [1] Nome

	oPrn:Say (_nLin+0075,0265,"Numero do Documento",oFont8)
	oPrn:Say (_nLin+0089,0265,aDadosTit[7]+aDadosTit[1],oFont10)	// [7] Prefixo + [1] Numero + Parcela
	oPrn:Say (_nLin+0075,0410,"Nosso Numero",oFont8) 
	
	//If SubStr(aDadosBanco[7],1,3) == '033'    
	//	oPrn:Say (_nLin+0089,0410,SubStr(aDadosTit[6],1,Len(aDadosTit[6])-2),oFont10)
	//Else
		oPrn:Say (_nLin+0089,0410,aDadosTit[6],oFont10) 
	//EndIf
	//oPrn:Say (_nLin+0089,0410,aDadosTit[6],oFont10)	                // [6] Nosso Numero

	oPrn:Say (_nLin+0075,0503,"Valor do Documento",oFont8) 
	oPrn:Say (_nLin+0089,0514,Transform(aDadosTit[5],"@E 999,999,999.99"),oFont10)
	oPrn:Say (_nLin+0104,0026,"Instru็๕es (termo de responsabilidade do cedente)",oFont8)    
		
	oPrn:Say (_nLin+0416,0395,"Autentica็ใo Mecโnica",oFont8)

	oPrn:Say (_nLin+0395,0026,"Recebimento atrav้s do cheque nฐ "+SPACE(20)+" do Banco",oFont10)
	oPrn:Say (_nLin+0407,0026,"Esta quita็ใo s๓ terแ validade ap๓s pagamento do cheque",oFont10)
	oPrn:Say (_nLin+0419,0026,"pelo banco Sacado:",oFont10)

	oPrn:Say (_nLin+0463,0026,"Sacado",oFont8)
	oPrn:Say (_nLin+0463,0382,"CNPJ:",oFont8)
	
Else 

	oPrn:SayBitmap( 010,026,"\system\caixa724_119.jpg",578.51,94.51)  
	
	oPrn:Box(110,026,500,606)
	
	oPrn:Box(120,036,220,333)
	oPrn:Box(120,343,220,596) 
	
	oPrn:Box(230,036,450,596)  
	oPrn:Say (240,040,"Texto de Responsabilidade do Cedente: ",oFont10)
	
	oPrn:Say (260,0040,aBolText[1],oFont10)
	oPrn:Say (275,0040,aBolText[2],oFont10)
	oPrn:Say (290,0040,aBolText[3],oFont10)
	
	oPrn:Say (130,040,"Cedente: "+AllTrim(aDadosEmp[1]),oFont8)
	oPrn:Say (140,040,"Ag./Cod. Cedente: 0246.870.00000236-4",oFont8)
	oPrn:Say (150,040,"Data do Documento: "+DTOC(aDadosTit[2]),oFont8)
	oPrn:Say (160,040,"Nosso N๚mero: "+aDadosTit[6],oFont8)
	oPrn:Say (170,040,"Nบ do Documento: "+aDadosTit[7]+aDadosTit[1],oFont8)
	oPrn:Say (180,040,"Esp้cie Doc.: "+aDadosTit[8],oFont8)
	oPrn:Say (190,040,"Carteira: "+aDadosBanco[6],oFont8)
	oPrn:Say (200,040,"Aceite: N",oFont8)
	oPrn:Say (210,040,"Esp้cie: "+aDadosTit[8],oFont8)  
	
	If Len(AllTrim(aDatSacado[1])) > 35
		oPrn:Say (130,347,"Sacado: "+SubStr(aDatSacado[1],1,35),oFont8) 
		oPrn:Say (140,347,SubStr(aDatSacado[1],36,35),oFont8)
	Else
		oPrn:Say (130,347,"Sacado: "+aDatSacado[1],oFont8)
	EndIf  
	
	If Len(AllTrim(aDatSacado[3])) > 35
		oPrn:Say (150,347,"Endere็o: "+SubStr(aDatSacado[3],1,35),oFont8) 
		oPrn:Say (160,347,SubStr(aDatSacado[3],36,35),oFont8)
	Else
		oPrn:Say (150,347,"Endere็o: "+aDatSacado[3],oFont8)
	EndIf   
		 
	oPrn:Say (170,347,"CEP: "+Transform(aDatSacado[6],"@R 99999-999"),oFont8)  
	oPrn:Say (190,347,"Cidade: "+aDatSacado[4]+" - "+aDatSacado[5],oFont8)      
	
	oPrn:Box(460,036,490,596)
	
	oPrn:Line(460,150,490,150)
	oPrn:Line(460,300,490,300) 
	
	oPrn:Say (470,040,"Vencimento",oFont8)
	oPrn:Say (470,154,"Valor",oFont8)
	oPrn:Say (470,304,"Autentica็ใo Mecโnica",oFont8)  
	
	oPrn:Say (480,040,DTOC(aDadosTit[4]),oFont8)
	oPrn:Say (480,154,Transform(aDadosTit[5],"@E 999,999,999.99"),oFont8)

EndIf                                                                                         
    
// Linha tracejada
FOR i := 026 TO 606 STEP 13
	oPrn:Line(_nLin+0523,i,_nLin+0523,i+8)
NEXT i

///////////////////////////////////////////////////
// Segunda parte  - FICHA DE COMPENSACAO         //
//                  Linha digitavel              //
///////////////////////////////////////////////////
oPrn:Line(_nLin+0556,0026,_nLin+0556,0606) //L1
oPrn:Line(_nLin+0586,0026,_nLin+0586,0606) //L2
oPrn:Line(_nLin+0616,0026,_nLin+0616,0606) //L3
oPrn:Line(_nLin+0637,0026,_nLin+0637,0606) //L4
oPrn:Line(_nLin+0658,0026,_nLin+0658,0606) //L5
oPrn:Line(_nLin+0678,0501,_nLin+0678,0606) //L6
oPrn:Line(_nLin+0699,0501,_nLin+0699,0606) //L7
oPrn:Line(_nLin+0720,0501,_nLin+0720,0606) //L8
oPrn:Line(_nLin+0741,0501,_nLin+0741,0606) //L9
oPrn:Line(_nLin+0762,0026,_nLin+0762,0606) //L10
oPrn:Line(_nLin+0834,0026,_nLin+0834,0606) //L11

oPrn:Line(_nLin+0556,0148,_nLin+0526,0148) //C1
oPrn:Line(_nLin+0556,0211,_nLin+0526,0211) //C2
oPrn:Line(_nLin+0616,0132,_nLin+0637,0132) //C3
oPrn:Line(_nLin+0637,0198,_nLin+0658,0198) //C4
oPrn:Line(_nLin+0616,0263,_nLin+0658,0263) //C5
oPrn:Line(_nLin+0616,0356,_nLin+0637,0356) //C6
oPrn:Line(_nLin+0616,0408,_nLin+0658,0408) //C7
oPrn:Line(_nLin+0556,0501,_nLin+0762,0501) //C8

If !Empty(cBitMap)                       //650,070	
	oPrn:SayBitmap( _nLin+0535,0026,cBitMap,120,020)     // Bitmap com Logo do Banco
Else
   	oPrn:Say (_nLin+0542,0026,aDadosBanco[2],oFont16)	// [2] Nome do Banco
EndIf

oPrn:Say (_nLin+0550,0149,aDadosBanco[7],oFont24)	// [7] Numero do Banco com Dac
oPrn:Say (_nLin+0550,0216,CB_RN_NN[2],oFont14n)		// [2] Linha Digitavel do Codigo de Barras
oPrn:Say (_nLin+0566,0026,"Local de Pagamento",oFont8)
oPrn:Say (_nLin+0578,0026,aDadosBanco[8],oFont10)
oPrn:Say (_nLin+0566,0503,"Vencimento",oFont8)
oPrn:Say (_nLin+0578,0514,DTOC(aDadosTit[4]),oFont10)
oPrn:Say (_nLin+0596,0026,"Cedente",oFont8)
oPrn:Say (_nLin+0608,0026,AllTrim(aDadosEmp[1])+" - "+aDadosEmp[6],oFont10) //Nome + CNPJ
oPrn:Say (_nLin+0596,0503,"Ag๊ncia/C๓digo Cedente",oFont8)  

If SubStr(aDadosBanco[7],1,3) == "104" 
	oPrn:Say (_nLin+0608,0514,"0246.870.00000236-4",oFont10) 
ElseIf SubStr(aDadosBanco[7],1,3) == "033" 
	If SubStr(SA6->A6_NUMCON,1,8) == "13002648" 
		//oPrn:Say (_nLin+0608,0514,aDadosBanco[3]+"/1484338",oFont10)
		oPrn:Say (_nLin+0608,0514,aDadosBanco[3]+"/1484338",oFont10)
	ElseIf SubStr(SA6->A6_NUMCON,1,8) == "13003189" 
		oPrn:Say (_nLin+0608,0514,aDadosBanco[3]+"/5978785",oFont10)
	EndIf
Else
	oPrn:Say (_nLin+0608,0514,aDadosBanco[3]+" / "+aDadosBanco[4]+IIF(!Empty(aDadosBanco[5]),"-"+aDadosBanco[5],""),oFont10)
EndIf  

oPrn:Say (_nLin+0626,0026,"Data do DocumIento",oFont8)
oPrn:Say (_nLin+0635,0026,DTOC(aDadosTit[2]),oFont10)			// Emissao do Titulo (E1_EMISSAO)
oPrn:Say (_nLin+0626,0133,"Nro.Documento",oFont8)
oPrn:Say (_nLin+0635,0159,aDadosTit[7]+aDadosTit[1],oFont10)	//Prefixo + Numero + Parcela
oPrn:Say (_nLin+0626,0265,"Esp้cie Documento",oFont8)
oPrn:Say (_nLin+0635,0277,aDadosTit[8],oFont10)					//Especie do Documento
oPrn:Say (_nLin+0626,0357,"Aceite",oFont8)
oPrn:Say (_nLin+0635,0383,"N",oFont10)
oPrn:Say (_nLin+0626,0410,"Data do Processamento",oFont8)
oPrn:Say (_nLin+0635,0436,DTOC(aDadosTit[3]),oFont10) // Data impressao
oPrn:Say (_nLin+0626,0503,"Nosso N๚mero",oFont8)
//If SubStr(aDadosBanco[7],1,3) == '033'    
//	oPrn:Say (_nLin+0635,0514,SubStr(aDadosTit[6],1,Len(aDadosTit[6])-2),oFont10)
//Else
	oPrn:Say (_nLin+0635,0514,aDadosTit[6],oFont10) 
//EndIf
oPrn:Say (_nLin+0647,0028,"Uso do Banco",oFont8)
oPrn:Say (_nLin+0656,0041,"",oFont10)
oPrn:Say (_nLin+0647,0134,"Carteira",oFont8)
oPrn:Say (_nLin+0656,0138,aDadosBanco[6],oFont10)  
oPrn:Line(0637,0132,0658,0132) 

oPrn:Say (_nLin+0647,0199,"Esp้cie",oFont8)
oPrn:Say (_nLin+0656,0212,aDadosTit[9],oFont10)
oPrn:Say (_nLin+0647,0265,"Quantidade",oFont8)
oPrn:Say (_nLin+0647,0410,"Valor",oFont8)
oPrn:Say (_nLin+0647,0503,"Valor do Documento",oFont8)
oPrn:Say (_nLin+0656,0514,Transform(aDadosTit[5],"@E 999,999,999.99"),oFont10)
oPrn:Say (_nLin+0668,0026,"Instru็๕es (termo de responsabilidade do CEDENTE)",oFont8)
oPrn:Say (_nLin+0697,0026,aBolText[1],oFont10)
oPrn:Say (_nLin+0712,0026,aBolText[2],oFont10)
oPrn:Say (_nLin+0727,0026,aBolText[3],oFont10)
oPrn:Say (_nLin+0668,0503,"(-)Desconto/Abatimento",oFont8)
oPrn:Say (_nLin+0688,0503,"(-)Outras Dedu็๕es",oFont8)
oPrn:Say (_nLin+0709,0503,"(+)Mora/Multa",oFont8)
oPrn:Say (_nLin+0730,0503,"(+)Outros Acr้scimos",oFont8)
oPrn:Say (_nLin+0751,0503,"(=)Valor Cobrado",oFont8)
oPrn:Say (_nLin+0772,0026,"Sacado",oFont8)
oPrn:Say (_nLin+0781,0040,aDatSacado[1]+"- CNPJ: "+Transform(Trim(aDatSacado[7]),IIf(" "$aDatSacado[7],"@R 999.999.999-99","@R 99.999.999/9999-99"))+" ("+aDatSacado[2]+")",oFont10)
oPrn:Say (_nLin+0797,0040,aDatSacado[3],oFont10)
oPrn:Say (_nLin+0813,0040,Transform(aDatSacado[6],"@R 99999-999")+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10)	// CEP+Cidade+Estado
If SubStr(aDadosBanco[7],1,3) <> "104" 
	oPrn:Say (_nLin+0813,0514,aDadosTit[6],oFont10)
EndIf
oPrn:Say (_nLin+0833,0026,"Sacado",oFont8)
oPrn:Say (_nLin+0833,0382,"CNPJ:",oFont8)

oPrn:Say (_nLin+0845,0395,"Autentica็ใo Mecโnica -",oFont8)
oPrn:Say (_nLin+0845,0487,"Ficha de Compensa็ใo",oFont10)

MSBAR3(  "INT25" ,7.20,0.25,CB_RN_NN[1],oPrn  ,.F.   ,Nil  ,Nil  ,0.005 ,0.300  ,Nil    ,Nil  ,"A"  ,.F.   )               
    
oPrn:EndPage()

Return Nil

////////////////////////////////////////////
// CALCULO DIGITO MODULO DE 10 COM BASE 9 //
// MODELO NOSSO NUMERO DO BANCO ITAU      //
////////////////////////////////////////////
Static Function Modulo10(cData)

Local L,D,P  := 0
Local B      := .F.
Local nResto := 0
L := Len(cData)
B := .T.
D := 0

While L > 0
	P := Val(SubStr(cData, L, 1))
    If (B)
    	P := P * 2
    EndIf
    D := D + IIF(P>9,(P-10)+1,P)
    L := L - 1
    B := !B
EndDo

nResto = Mod(D,10)
If nResto = 0
	D := 0
Else
    D := 10 - nResto
EndIf

Return(STR(D,1))

/////////////////////////////////
Static Function Mod11Base7(cData) 

Local L,D,P := 0
Local B := 2
L := Len(cData)
D := 0

While L > 0
	P := Val(SubStr(cData, L, 1))
    D += ( P * B )
    B += 1
    If B > 7
    	B := 2
    EndIf
    L := L - 1
EndDo

R := Mod(D,11)
If R = 1
	D := "P"
ElseIf R = 0
    D := "0"
Else
    D := STR(11 - R,1)
EndIf

Return(D)

/////////////////////////////////
Static Function Mod11Safra(cData)

Local L,D,P := 0
Local B := 2
L := Len(cData)
D := 0

While L > 0
	P := Val(SubStr(cData, L, 1))
    D += ( P * B )
    B += 1
    If B > 9
	    B := 2
    EndIf
    L := L - 1
EndDo

R := Mod(D,11)

If R = 1
	D := "0"
ElseIf R = 0
    D := "1"
Else
   	D := STR(11 - R,1)
EndIf

Return(D)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEFINR01   บAutor  ณAnderson Gon็alves  บ Data ณ  19/10/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRecalcula o saldo do titulo considerando os abatimentos     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGoldHair                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CalcTit()

Local nSaldo   := SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE 
Local nVlrAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

nSaldo := ROUND(nSaldo - nVlrAbat,2)

Return(nSaldo)          


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSENDMAIL  บAutor  ณAnderson Goncalves  บ Data ณ  19/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envio de e-mail                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Contuflex                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


User Function SndMail2(cMailDestino,cAssunto,cTexto,cAnexos,lJob)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis da Rotina                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cOrigem			:= ""
Local lConexao			:= .F.
Local lEnvio   			:= .F.
Local lDesconexao		:= .F.
Local cMailServer  		:= ""
Local cMailSenha   		:= ""
Local cErro_Conexao		:= ""
Local cErro_Envio		:= ""
Local cErro_Desconexao	:= ""

Default cAssunto 		:= ""
Default cTexto 			:= ""
Default cAnexos			:= ""   

cMailConta := Lower(AllTrim(If(!Empty(UsrRetMail(__cUserID)),UsrRetMail(__cUserID),"atendimento@goldhairadvance.com.br")))
cMailServer := "smtp.goldhairadvance.com.br:587"
cMailSenha  := "atend07"    

cMailDestino += "; "+AllTrim(Lower(UsrRetMail(__cUserId)))

If !lJob
	ProcRegua(3) 
	IncProc("Conectando ao servidor de Email !!!")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Conecta no servidor de e-mails                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Connect Smtp Server cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lConexao
If lConexao 
	lConexao := Mailauth("atendimento@goldhairadvance.com.br", cMailSenha)	
	If lConexao
		If !Empty( cANEXOS )
			Send Mail From cMAILCONTA To cMAILDESTINO SubJect cASSUNTO BODY cTEXTO FORMAT TEXT ATTACHMENT cANEXOS RESULT lENVIO
		Else
			Send Mail From cMAILCONTA To cMAILDESTINO SubJect cASSUNTO BODY cTEXTO FORMAT TEXT RESULT lENVIO
		EndIf 
	Else 
		GET MAIL ERROR cErro_Conexao
		If !lJob
			Aviso( "Envio de WorkFlow", OemToAnsi("Nao foi possivel estabelecer a Conexao com o servidor - " + cErro_Conexao + " SERVIDOR:"+cMailServer+"  CONTA:"+cMailConta), {"&Ok"} )
			Return(.F.)
		EndIf
	EndIf
Else
	GET MAIL ERROR cErro_Conexao
	If !lJob
		Aviso( "Envio de WorkFlow", OemToAnsi("Nao foi possivel estabelecer a Conexao com o servidor - " + cErro_Conexao + " SERVIDOR:"+cMailServer+"  CONTA:"+cMailConta), {"&Ok"} )
		Return(.F.)
	EndIf
EndIf

If !lJob
	IncProc("Enviando Email !!!")
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                                             
//ณ Desconecta do servidor de e-mail                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lJob
	IncProc("Desconectando do servidor de Email !!!")
EndIf  
DisConnect Smtp Server Result lDesconexao

Return(.T.)