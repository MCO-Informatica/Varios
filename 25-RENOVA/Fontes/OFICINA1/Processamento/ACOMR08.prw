#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPConn.ch'
#INCLUDE "FWMVCDEF.CH"         
#INCLUDE "FWCOMMAND.CH"         
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE 'TOPConn.ch'
#INCLUDE 'Rwmake.ch'

#DEFINE ENTER Chr(13)+Chr(10)
#DEFINE DIRXML  "XMLNFE\"
#DEFINE DIRALER "NEW\"
#DEFINE DIRLIDO "OLD\"
#DEFINE DIRERRO "ERR\" 


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACOMR08   บAutor  ณFelipi Marques      บ Data ณ  10/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Programa de conversao de NFSe TXT para XML                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function ACOMR08(cFile,lJob)

Local cXml := ''
Local cProduto	    := " "
Local cXML          := ""
Local cError        := ""
Local cWarning      := ""
Local cTipoNF       := ""
Local cTabEmit      := ""
Local cDoc	        := ""
Local cSerie        := ""
Local cSerXML       := ""
Local cCodigo       := ""
Local cCampo1       := ""
Local cCampo2       := ""
Local cCampo3       := ""
Local cCampo4       := ""
Local cCampo5       := ""
Local cQuery        := ""
Local cNFECFAP      := SuperGetMV("MV_NFECFAP",.F.,"")
Local lFound        := .F.
Local lProces       := .T.
Local lCFOPEsp      := .T.
Local nX		    := 0
Local nY	    	:= 0
Local oFullXML      := NIL
Local aItens        := {}
Local aHeadSDS      := {}
Local aItemSDT      := {}
Local oDlg
Local lStatus       := .F.
Local cProduto2     := " "
Local lXmlCliFor    := (SuperGetMv("MV_XMLCADF" ,,.T. ))
Local cStatus       := ""
Local lNumX5        := .F.
Local nQuant	    := 0
Local nPrecUni	    := 0
Local nVrCalc	    := 0
Local cCNPJTran     := ""
Local cCodTransp    := ""
Local cPlacaTran    := ""
Local nPesoLiq      := 0
Local nPesoBruto    := 0
Local cTipoFrete    := ""
Local aQtdVol	    := {}
Local aEspVol	    := {}
Local lA140ICFOP    := ExistBlock("A140ICFOP")
Local cPedido	    := Space(TamSx3("DT_PEDIDO")[1])
Local cItemPed	    := Space(TamSx3("DT_ITEMPC")[1])
Local cNFECFAP      := SuperGetMV("MV_XMLCFPC",.F.,"")
Local cNFECFBN      := SuperGetMV("MV_XMLCFBN",.F.,"")
Local cNFECFDV      := SuperGetMV("MV_XMLCFDV",.F.,"")
Local cNFECFND      := SuperGetMV("MV_XMLCFND",.F.,"")
Local lProXFor      := SuperGetMV("MV_XMLPXF" ,.F.,.T.)
Local lForDupli     := .F.
Local lCOM10PC	    := .F.
Local _nContProd    := 0
Local aRegs			:= {}
Local nHdlPrv     	:= 0
Local lHeader     	:= .F.
Local nX		 	:= 0
Local aDados	  	:= {}
Local aColunas	  	:= {"",""}
Local nCol		  	:= 0
Local cType		  	:=	"Arquivos CSV|*.CSV|Todos os Arquivos|*.*"
Local cDelimited  	:= ";"
Local lDigita     	:= .T.
Local lAglut      	:= .F.
Local cDocCtb     	:= ""
Local cArquivo		:= ""
Private cXMLOri     := ""
Private cArq		:= ""
Private nHdl		:= Nil
Private cCadastro	:= "Importa็ใo Ativo Fixo em CSV"

Static lConvAsc	    := FindFunction("ConvAsc")

Private cCGC	    := CriaVar("A1_CGC")
Private cEmailAdm 	:= GETMV("MV_WFADMIN")
Private cEmailErro  := "user@suaempresa.com.br"
Private oAuxXML     := NIL
Private oXML	    := NIL
Private lMsErroAuto := .F.
Private cA100For	:= ""
Private cLoja		:= ""
Private aCols       := {}
Default lJob        := .T.
Private aProc  	    := {}
Private aErros      := {}
Private aErroERP	:= {}
Private lNfeCompl	:= .F.
Private cTXTOri	    := ""
Private cStartLido	:= Trim(DIRXML)+DIRLIDO
Private c2StartPath	:= Trim(cStartLido)+AllTrim(Str(Year(Date())))+"\"
Private c3StartPath	:= Trim(c2StartPath)+AllTrim(Str(Month(Date())))+"\"	//MES
Private cArqRPS     := ""
Private oTXTFile
Private cLine := ''
Private nLines := 0
Private aCabeRPS   	:= {}
Private aItemRPS   	:= {}
Private aRodaRPS	:= {}  
Private aItemNFE    := {}
Private aProds		:= {}

If !ExistDir(DIRXML)
	MakeDir(DIRXML)
	MakeDir(DIRXML +DIRALER)
	MakeDir(DIRXML +DIRLIDO)
	MakeDir(DIRXML +DIRERRO)
EndIf

If .NOT. ExistDir(c2StartPath)
	nMake := MakeDir(c2StartPath)
	if nMake != 0
		conOut( "Nใo foi possํvel criar o diret๓rio. Erro: " + cValToChar( FError() ) )
	endIf
Endif

If .NOT. ExistDir(c3StartPath)		
	nMake := MakeDir(c3StartPath)
	if nMake != 0
		conOut( "Nใo foi possํvel criar o diret๓rio. Erro: " + cValToChar( FError() ) )
	endIf	
Endif

If !File(DIRXML+DIRALER +cFile)
	If lJob
		ConOut(Replicate("=",80))
		ConOut("ACOMR07 Error:")
		ConOut("Arquivo: " +cFile)
		ConOut("Ocorrencia: Arquivo inexistente.")
		ConOut(Replicate("=",80))
	Else
		Aviso("Error","Arquivo " +cFile +" inexistente.",{"OK"},2,"ACOMR07")
	EndIf
	lProces := .F.
	Return lProces
Else
	cTXTOri := MemoRead(DIRXML+DIRALER +cFile)
endif

cArqRPS := DIRXML+DIRALER +cFile

//Carrega XML
fXMLCabec()

FT_Fuse(cArqRPS)

ProcRegua(FT_FLASTREC())
FT_FGOTOP()


Do While ! FT_Feof()
	
	cBuffer := FT_Freadln()
	cTpReg	:= Left( Alltrim( cBuffer ) ,1 )
	
	If Len(cBuffer) >= 1023
		cBuffAnt:= cBuffer
		lSkip := .T.
	Else
		lSkip := .F.
	EndIf
	
	If cTpReg  == '1'
		
		FT_FSkip()
		Loop
		
	ElseIf cTpReg == '2'  
		If !lSkip
			cNumNFE   := Substr(cBuffer,002,08)//01-Numero NFE
			cDtNFE    := Substr(cBuffer,010,08)//02-Data NFE
			cHrNFE    := Substr(cBuffer,018,06)//03-Hora NFE
			cCodVrf   := Substr(cBuffer,024,08)//04-Codigo Verifica็ใo NFE
			cTpRPS    := Substr(cBuffer,032,05)//05-Tipo RPS
			cSerRPS   := Substr(cBuffer,037,05)//06-Serie RPS
			cNumRPS   := Substr(cBuffer,042,12)//07-Numero RPS
			cDtEmiRPS := Substr(cBuffer,054,08)//08-Data Emissao RPS
			cInsMunPre:= Substr(cBuffer,062,08)//09-Inscri็ใo Municipal Prestador
			cIndTpCad := Substr(cBuffer,070,01)//10-Indicador CNPJ / CPF Prestador
			cCNPJCPF  := Substr(cBuffer,071,14)//11-CNPJ / CPF Prestador
			cRazaoPre := Substr(cBuffer,085,75)//12-Razใo Social Prestador
			cTpEndPre := Substr(cBuffer,160,03)//13-Tipo Endere็o Prestador
			cEndPre   := Substr(cBuffer,163,50)//14-Endere็o Prestador
			cNrEndPre := Substr(cBuffer,213,10)//15-Numero Endere็o Prestador
			cCompPre  := Substr(cBuffer,223,30)//16-Complemento Endere็o Prestador
			cBairrPre := Substr(cBuffer,253,30)//17-Bairro do Prestador
			cCidadePre:= Substr(cBuffer,283,50)//18-Cidade do Prestador
			cUFPre    := Substr(cBuffer,333,02)//19-UF Prestador
			cCEPPre   := Substr(cBuffer,335,08)//20-CEP Prestador
			cEmailPre := Substr(cBuffer,343,75)//21-Email Prestador
			cOpcSimp  := Substr(cBuffer,418,01)//22-Op็ใo pelo simples
			cSituacNF := Substr(cBuffer,419,01)//23-Situa็ใo Nota Fiscal
			cDtCancNF := Substr(cBuffer,420,08)//24-Data do Cancelamento NF
			cNumGuia  := Substr(cBuffer,428,12)//25-Numero Guia NF
			cDtPgGuia := Substr(cBuffer,440,08)//26-Data quita็ใo guia vinculada NF
			cValServ  := Substr(cBuffer,448,15)//27-Valor dos Servi็os
			cValDed   := Substr(cBuffer,463,15)//28-Valor das dedu็๕es
			cCodServ  := Substr(cBuffer,478,05)//29-Codigo servi็o prestado NF
			cAliqServ := Substr(cBuffer,483,04)//30-Aliquota ISS
			cValISSNF := Substr(cBuffer,487,15)//31-Valor ISS NF
			cValCred  := Substr(cBuffer,502,15)//32-Valor Credito
			cISSRet   := Substr(cBuffer,517,01)//33-ISS Retido?
			cIndTomad := Substr(cBuffer,518,01)//34-Indicador CNPJ / CPF Tomador
			cCPFCGCTom:= Substr(cBuffer,519,14)//35-CNPJ / CPF Tomador
			cInsMunTom:= Substr(cBuffer,533,08)//36-Inscri็ใo Municipal Tomador
			cInsEstTom:= Substr(cBuffer,541,12)//37-Inscri็ใo Estadual Tomador
			cRazaoTom := Substr(cBuffer,553,75)//38-Razใo Social Tomador
			cTpEndTom := Substr(cBuffer,628,03)//39-Tipo Endere็o Tomador
			cEndTom   := Substr(cBuffer,631,50)//40-Endere็o do Tomador
			cNumEndTom:= Substr(cBuffer,681,10)//41-Numero Endere็o Tomador
			cCmpEndTom:= Substr(cBuffer,691,30)//42-Complemento Endere็o Tomador
			cBairroTom:= Substr(cBuffer,721,30)//43-Bairro Tomador
			cCidadeTom:= Substr(cBuffer,751,50)//44-Cidade Tomador
			cUFTom    := Substr(cBuffer,801,02)//45-UF Tomador
			cCEPTom   := Substr(cBuffer,803,08)//46-CEP Tomador
			cEmailTom := Substr(cBuffer,811,75)//47-Email Tomador
			
			aDescServ := TXTtoARRAY( Substr( cBuffer,886,Len( cBuffer ) ) ) //48-Descritivo Servi็os
			
			aAdd( aItemNFE,{cNumNFE,cDtNFE,cHrNFE,cCodVrf,cTpRPS,cSerRPS,cNumRPS,cDtEmiRPS,cInsMunPre,cIndTpCad,cCNPJCPF,cRazaoPre,cTpEndPre,cEndPre,cNrEndPre,cCompPre,cBairrPre,cCidadePre,cUFPre,cCEPPre,cEmailPre,cOpcSimp,cSituacNF,cDtCancNF,cNumGuia,cDtPgGuia,Val(cValServ)/100,Val(cValDed)/100,cCodServ,Val(cAliqServ)/100,Val(cValISSNF)/100,Val(cValCred)/100,cISSRet,cIndTomad,cCPFCGCTom,cInsMunTom,cInsEstTom,cRazaoTom,cTpEndTom,cEndTom,cNumEndTom,cCmpEndTom,cBairroTom,cCidadeTom,cUFTom,cCEPTom,cEmailTom,aDescServ } )
			
			AADD(aProds,{aItemNFE[Len(aItemNFE)][48][1],;//Descri็ใo
			1.00,;//Quantidade
			aItemNFE[Len(aItemNFE)][27],;//Total
			aItemNFE[Len(aItemNFE)][29],;//Codigo Servi็o
			aItemNFE[Len(aItemNFE)][06],;//Serie NFE
			aItemNFE[Len(aItemNFE)][01]})//Numero NFE
		Else
			FT_FSkip()
			cBuffer := FT_Freadln()
			cNumNFE   := Substr(cBuffAnt,002,08)//01-Numero NFE
			cDtNFE    := Substr(cBuffAnt,010,08)//02-Data NFE
			cHrNFE    := Substr(cBuffAnt,018,06)//03-Hora NFE
			cCodVrf   := Substr(cBuffAnt,024,08)//04-Codigo Verifica็ใo NFE
			cTpRPS    := Substr(cBuffAnt,032,05)//05-Tipo RPS
			cSerRPS   := Substr(cBuffAnt,037,05)//06-Serie RPS
			cNumRPS   := Substr(cBuffAnt,042,12)//07-Numero RPS
			cDtEmiRPS := Substr(cBuffAnt,054,08)//08-Data Emissao RPS
			cInsMunPre:= Substr(cBuffAnt,062,08)//09-Inscri็ใo Municipal Prestador
			cIndTpCad := Substr(cBuffAnt,070,01)//10-Indicador CNPJ / CPF Prestador
			cCNPJCPF  := Substr(cBuffAnt,071,14)//11-CNPJ / CPF Prestador
			cRazaoPre := Substr(cBuffAnt,085,75)//12-Razใo Social Prestador
			cTpEndPre := Substr(cBuffAnt,160,03)//13-Tipo Endere็o Prestador
			cEndPre   := Substr(cBuffAnt,163,50)//14-Endere็o Prestador
			cNrEndPre := Substr(cBuffAnt,213,10)//15-Numero Endere็o Prestador
			cCompPre  := Substr(cBuffAnt,223,30)//16-Complemento Endere็o Prestador
			cBairrPre := Substr(cBuffAnt,253,30)//17-Bairro do Prestador
			cCidadePre:= Substr(cBuffAnt,283,50)//18-Cidade do Prestador
			cUFPre    := Substr(cBuffAnt,333,02)//19-UF Prestador
			cCEPPre   := Substr(cBuffAnt,335,08)//20-CEP Prestador
			cEmailPre := Substr(cBuffAnt,343,75)//21-Email Prestador
			cOpcSimp  := Substr(cBuffAnt,418,01)//22-Op็ใo pelo simples
			cSituacNF := Substr(cBuffAnt,419,01)//23-Situa็ใo Nota Fiscal
			cDtCancNF := Substr(cBuffAnt,420,08)//24-Data do Cancelamento NF
			cNumGuia  := Substr(cBuffAnt,428,12)//25-Numero Guia NF
			cDtPgGuia := Substr(cBuffAnt,440,08)//26-Data quita็ใo guia vinculada NF
			cValServ  := Substr(cBuffAnt,448,15)//27-Valor dos Servi็os
			cValDed   := Substr(cBuffAnt,463,15)//28-Valor das dedu็๕es
			cCodServ  := Substr(cBuffAnt,478,05)//29-Codigo servi็o prestado NF
			cAliqServ := Substr(cBuffAnt,483,04)//30-Aliquota ISS
			cValISSNF := Substr(cBuffAnt,487,15)//31-Valor ISS NF
			cValCred  := Substr(cBuffAnt,502,15)//32-Valor Credito
			cISSRet   := Substr(cBuffAnt,517,01)//33-ISS Retido?
			cIndTomad := Substr(cBuffAnt,518,01)//34-Indicador CNPJ / CPF Tomador
			cCPFCGCTom:= Substr(cBuffAnt,519,14)//35-CNPJ / CPF Tomador
			cInsMunTom:= Substr(cBuffAnt,533,08)//36-Inscri็ใo Municipal Tomador
			cInsEstTom:= Substr(cBuffAnt,541,12)//37-Inscri็ใo Estadual Tomador
			cRazaoTom := Substr(cBuffAnt,553,75)//38-Razใo Social Tomador
			cTpEndTom := Substr(cBuffAnt,628,03)//39-Tipo Endere็o Tomador
			cEndTom   := Substr(cBuffAnt,631,50)//40-Endere็o do Tomador
			cNumEndTom:= Substr(cBuffAnt,681,10)//41-Numero Endere็o Tomador
			cCmpEndTom:= Substr(cBuffAnt,691,30)//42-Complemento Endere็o Tomador
			cBairroTom:= Substr(cBuffAnt,721,30)//43-Bairro Tomador
			cCidadeTom:= Substr(cBuffAnt,751,50)//44-Cidade Tomador
			cUFTom    := Substr(cBuffAnt,801,02)//45-UF Tomador
			cCEPTom   := Substr(cBuffAnt,803,08)//46-CEP Tomador
			cEmailTom := Substr(cBuffAnt,811,75)//47-Email Tomador
			
			cBuffAnt  := Substr( cBuffAnt,886,Len( cBuffAnt ) )
			cBuffAnt  := cBuffAnt + Alltrim(cBuffer)
			
			aDescServ := TXTtoARRAY( Substr(cBuffAnt,337,1000) ) //48-Descritivo Servi็os
			
			aAdd( aItemNFE,{cNumNFE,cDtNFE,cHrNFE,cCodVrf,cTpRPS,cSerRPS,cNumRPS,cDtEmiRPS,cInsMunPre,cIndTpCad,cCNPJCPF,cRazaoPre,cTpEndPre,cEndPre,cNrEndPre,cCompPre,cBairrPre,cCidadePre,cUFPre,cCEPPre,cEmailPre,cOpcSimp,cSituacNF,cDtCancNF,cNumGuia,cDtPgGuia,Val(cValServ)/100,Val(cValDed)/100,cCodServ,Val(cAliqServ)/100,Val(cValISSNF)/100,Val(cValCred)/100,cISSRet,cIndTomad,cCPFCGCTom,cInsMunTom,cInsEstTom,cRazaoTom,cTpEndTom,cEndTom,cNumEndTom,cCmpEndTom,cBairroTom,cCidadeTom,cUFTom,cCEPTom,cEmailTom,aDescServ } )
			
			AADD(aProds,{aItemNFE[Len(aItemNFE)][48][1],;//Descri็ใo
			1.00,;//Quantidade
			aItemNFE[Len(aItemNFE)][27],;//Total
			aItemNFE[Len(aItemNFE)][29],;//Codigo Servi็o
			aItemNFE[Len(aItemNFE)][06],;//Serie NFE
			aItemNFE[Len(aItemNFE)][01]})//Numero NFE
			
		EndIf
	ElseIf cTpReg == '9'
		
		FT_FSkip()
		Loop
		
	EndIf
	
	FT_FSkip()
	
EndDo


FT_Fuse()
	
For nZ := 1 to Len(aItemNFE)
	// Gera็ใo do arquivo XML
	fXMLCorpo(aItemNFE[nZ])
Next nZ	

//Carrega XML
fXMLRodape()

// Remove caracteres estranhos antes da abertura da tag inicial do arquivo
If !Empty(cXMLOri)
	If SubStr(cXMLOri,1,1) != "<"
		nPosPesq := At("<",cXMLOri)
		cXMLOri  := SubStr(cXMLOri,nPosPesq,Len(cXMLOri))
	EndIf
	cXML := DecodeUTF8(cXMLOri)
	
	If Empty(cXML)
		cXML := cXMLOri
	EndIf
	//remove caracteres especiais nใo aceitos pelo encode
	cXML := A140IRemASC(cXML)
	
	cXML := EncodeUtf8(cXML)
	
	If Empty(cXML)
		cXML := cXMLOri
	EndIf
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณNota de Servicos- NFS-e  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oFullXML := XmlParser(cXML,"_",@cError,@cWarning)
lProces  := U_XML_NFs(cFile,lJob,@aProc,@aErros,oFullXml)


Return(lProces)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfXMLCabec บAutor  ณFeLipi Marques     บ Data ณ  10/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fXMLCabec()
cXMLOri += ' <?xml version="1.0" encoding="UTF-8" ?>'+ENTER
cXMLOri += ' <ConsultarNfseResposta xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd">'+ENTER
cXMLOri += ' 	<ListaNfse>'+ENTER
return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfXMLCabec บAutor  ณFeLipi Marques     บ Data ณ  10/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fXMLCorpo(aRet)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณValida Nota canceladaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !Empty(aRet[24] )
			// Pula para pr๓xima linha
			Return
		EndIf
		
		cXMLOri += ' 		<CompNfse>'+ENTER
		cXMLOri += ' 			<Nfse>'+ENTER
		cXMLOri += ' 				<InfNfse>'+ENTER
		cXMLOri += ' 					<Numero>'+aRet[1]+'</Numero>'+ENTER
		cXMLOri += ' 					<CodigoVerificacao>'+aRet[4]+'</CodigoVerificacao>'+ENTER
		cXMLOri += ' 					<DataEmissao>'+aRet[2]+'</DataEmissao>'+ENTER
		cXMLOri += ' 					<IdentificacaoRps>'+ENTER
		cXMLOri += ' 						<Numero>'+aRet[7]+'</Numero>'+ENTER
		cXMLOri += ' 						<Serie>'+aRet[6]+'</Serie>'+ENTER
		cXMLOri += ' 						<Tipo>'+aRet[5]+'</Tipo>'+ENTER
		cXMLOri += ' 					</IdentificacaoRps>'+ENTER
		cXMLOri += ' 					<DataEmissaoRps>'+aRet[8]+'</DataEmissaoRps>'+ENTER
		cXMLOri += ' 					<NaturezaOperacao></NaturezaOperacao>'+ENTER
		cXMLOri += ' 					<OptanteSimplesNacional></OptanteSimplesNacional>'+ENTER
		cXMLOri += ' 					<IncentivadorCultural></IncentivadorCultural>'+ENTER
		cXMLOri += ' 					<Competencia></Competencia>'+ENTER
		cXMLOri += ' 					<Servico>'+ENTER
		cXMLOri += ' 						<Valores>'+ENTER
		cXMLOri += ' 							<ValorServicos>'+ Alltrim(Str(aRet[27]))  +'</ValorServicos>'+ENTER
		cXMLOri += ' 							<IssRetido>'+aRet[33]+'</IssRetido>'+ENTER
		cXMLOri += ' 							<ValorIss>'+Alltrim(Str(aRet[31]))+'</ValorIss>'+ENTER
		cXMLOri += ' 							<BaseCalculo></BaseCalculo>'+ENTER
		cXMLOri += ' 							<Aliquota>'+Alltrim(Str(aRet[30]))+'</Aliquota>'+ENTER
		cXMLOri += ' 							<ValorLiquidoNfse>'+ Alltrim(Str(aRet[27])) +'</ValorLiquidoNfse>'+ENTER
		cXMLOri += ' 						</Valores>'+ENTER
		cXMLOri += ' 						<ItemListaServico>'+ SubStr(aRet[29],1,4) +'</ItemListaServico>'+ENTER
		cXMLOri += ' 						<CodigoTributacaoMunicipio>'+ aRet[29] +'</CodigoTributacaoMunicipio>'+ENTER
		cXMLOri += ' 						<Discriminacao>'+ Left( Alltrim( Upper( RetAcent( aRet[48][1] ) ) ) , TamSX3("DT_DESCFOR")[1]) +'</Discriminacao>'+ENTER
		cXMLOri += ' 						<CodigoMunicipio>3550308</CodigoMunicipio>'+ENTER
		cXMLOri += ' 					</Servico>'+ENTER
		cXMLOri += ' 					<PrestadorServico>'+ENTER
		cXMLOri += ' 						<IdentificacaoPrestador>'+ENTER
		cXMLOri += ' 							<Cnpj>'+ aRet[11] +'</Cnpj>'+ENTER
		cXMLOri += ' 							<InscricaoMunicipal>'+ aRet[09] +'</InscricaoMunicipal>'+ENTER
		cXMLOri += ' 						</IdentificacaoPrestador>'+ENTER
		cXMLOri += ' 						<RazaoSocial>'+ AllTrim(aRet[12]) +'</RazaoSocial>'+ENTER
		cXMLOri += ' 						<NomeFantasia>'+ AllTrim(aRet[12]) +'</NomeFantasia>'+ENTER
		cXMLOri += ' 						<Endereco>'+ENTER
		cXMLOri += ' 							<Endereco>'+ AllTrim(aRet[13]) +'</Endereco>'+ENTER
		cXMLOri += ' 							<Numero>'+  AllTrim(aRet[15])  +'</Numero>'+ENTER
		cXMLOri += ' 							<Complemento>'+  AllTrim(aRet[16])  +'</Complemento>'+ENTER
		cXMLOri += ' 							<Bairro>'+  AllTrim(aRet[17])  +'</Bairro>'+ENTER
		cXMLOri += ' 							<CodigoMunicipio></CodigoMunicipio>'+ENTER
		cXMLOri += ' 							<Uf>'+ AllTrim(aRet[19])  +'</Uf>'+ENTER
		cXMLOri += ' 							<Cep>'+ AllTrim(aRet[20])  +'</Cep>'+ENTER
		cXMLOri += ' 						</Endereco>'+ENTER
		cXMLOri += ' 						<Contato>'+ENTER
		cXMLOri += ' 							<Telefone></Telefone>'+ENTER
		cXMLOri += ' 						</Contato>'+ENTER
		cXMLOri += ' 					</PrestadorServico>'+ENTER
		cXMLOri += ' 					<TomadorServico>'+ENTER
		cXMLOri += ' 						<IdentificacaoTomador>'+ENTER
		cXMLOri += ' 							<CpfCnpj>'+ENTER
		cXMLOri += ' 								<Cnpj>'+ AllTrim(aRet[35])  +'</Cnpj>'+ENTER
		cXMLOri += ' 							</CpfCnpj>'+ENTER
		cXMLOri += ' 							<InscricaoMunicipal>'+ AllTrim(aRet[36])  +'</InscricaoMunicipal>'+ENTER
		cXMLOri += ' 						</IdentificacaoTomador>'+ENTER
		cXMLOri += ' 						<RazaoSocial>'+ AllTrim(aRet[38])  +'</RazaoSocial>'+ENTER
		cXMLOri += ' 						<Endereco>'+ENTER
		cXMLOri += ' 							<Endereco>'+ AllTrim(aRet[39])+' '+AllTrim(aRet[40]) +'</Endereco>'+ENTER
		cXMLOri += ' 							<Numero>'+ AllTrim(aRet[41]) +'</Numero>'+ENTER
		cXMLOri += ' 							<Complemento>'+ AllTrim(aRet[42]) +'</Complemento>'+ENTER
		cXMLOri += ' 							<Bairro>'+ AllTrim(aRet[43]) +'</Bairro>'+ENTER
		cXMLOri += ' 							<CodigoMunicipio></CodigoMunicipio>'+ENTER
		cXMLOri += ' 							<Uf>'+ AllTrim(aRet[45]) +'</Uf>'+ENTER
		cXMLOri += ' 							<Cep>'+ AllTrim(aRet[46]) +'</Cep>'+ENTER
		cXMLOri += ' 						</Endereco>'+ENTER
		cXMLOri += ' 						<Contato>'+ENTER
		cXMLOri += ' 							<Telefone></Telefone>'+ENTER
		cXMLOri += ' 							<Email></Email>'+ENTER
		cXMLOri += ' 						</Contato>'+ENTER
		cXMLOri += ' 					</TomadorServico>'+ENTER
		cXMLOri += ' 					<OrgaoGerador>'+ENTER
		cXMLOri += ' 						<CodigoMunicipio></CodigoMunicipio>'+ENTER
		cXMLOri += ' 						<Uf></Uf>'+ENTER
		cXMLOri += ' 					</OrgaoGerador>'+ENTER
		cXMLOri += ' 				</InfNfse>'+ENTER
		cXMLOri += ' 			</Nfse>'+ENTER
		cXMLOri += ' 		</CompNfse>'+ENTER

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfXMLRodapeบAutor  ณFeLipi Marques     บ Data ณ  10/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fXMLRodape()

cXMLOri += ' 	</ListaNfse>'+ENTER
cXMLOri += ' </ConsultarNfseResposta>'+ENTER

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACOMR07   บAutor  ณMicrosiga           บ Data ณ  10/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function XML_NFs(cFile,lJob,aProc,aErros,oFullXML,aErroERP,cXMLOri)

Local cXML      	:= ""
Local cError     	:= ""
Local cWarning   	:= ""
Local cCGCTT		:= ""
Local cCGCTP		:= ""
Local cCodigo 		:= ""
Local cLoja			:= ""
Local cNomeFor		:= ""
Local cCodServ		:= ""
Local cMunServ		:= "" 
Local cDescServ		:= ""  
Local cDoc			:= ""
Local cSerie		:= ""   
Local cRPS			:= ""
Local cCodNFE		:= ""
Local cHrEmis		:= ""
Local dDtEmis		:= StoD("")
Local nX			:= 0
Local nY			:= 0
Local lProces    	:= .T.
Local lDelFile		:= .T.
Local aItens     	:= {}
Local aHeadSDS		:= {}
Local aItemSDT		:= {} 
Local lProXFor      := SuperGetMV("MV_XMLPXF" ,.F.,.T.)
Local _nContProd    := 0
Local cProduto2     := " "
Local cProduto      := " "
Local cStatus       := ""

Local cQrySDS
Private lMsErroAuto	:= .F.

Default lJob   	 	:= .T.
Default cFile		:= ""
Default aProc		:= {}
Default aErros		:= {}
Default aErroErp	:= {}
Default oFullXML	:= NIL

If lProces
	
	//-- Verifica erro na sintaxe do XML
	If Empty(oFullXML) .Or. !Empty(cError)
		If lJob
			aAdd(aErros,{cFile,"Erro de sintaxe no arquivo XML: "+cError,"Entre em contato com o emissor do documento e comunique a ocorr๊ncia."})
		Else
			Aviso("Erro",cError,{"OK"},2,"ImpXML_NFs")
		EndIf
		lProces := .F.
	Else
		 
		 If ValType(XmlChildEx(oFullXML,"_CONSULTARNFSERESPOSTA")) == "O"
		 	oFullXML	:= oFullXML:_CONSULTARNFSERESPOSTA:_LISTANFSE:_COMPNFSE
	 	 ElseIf ValType(XmlChildEx(oFullXML,"_COMPNFSE")) == "O"
	 	 	oFullXML	:= oFullXML:_COMPNFSE
	 	 EndIf

	EndIf
Endif


// Tratamento para analisar se contem somente 1 item
oFullXML := IIf(ValType(oFullXML)=="O",{oFullXML},oFullXML)

If Len(oFullXML) < 1
	Return(.F.)
EndIf

For nX := 1 to Len(oFullXML) 

	lProces    	:= .T.
	cDoc        := ""
	cRPS        := ""
	cSerie      := ""
	aItemSDT    := {}
	aHeadSDS	:= {}
	aItens     	:= {}
	aHeadSDS		:= {}
	cCGCTT		:= oFullXML[nX]:_NFSE:_INFNFSE:_TOMADORSERVICO:_IDENTIFICACAOTOMADOR:_CPFCNPJ:_CNPJ:TEXT   
	cCGCTP		:= oFullXML[nX]:_NFSE:_INFNFSE:_PRESTADORSERVICO:_IDENTIFICACAOPRESTADOR:_CNPJ:TEXT
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฬ
	//ณValida็ใo do CGCณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฬ
	If !CGC(cCGCTP,,.F. )
		Loop	
	EndIf
		
	If cEmpAnt <> '99'
		dbSelectArea("SM0")
		dbSetOrder(1)
		dbGoTop()
		While !Eof()
			If M0_CGC == cCGCTT
				cFilAnt := M0_CODFIL
				cEmpAnt := M0_CODIGO
				lFound := .T.
				Exit
			EndIf
			dbSkip()
		End
	Else
		lFound := .T.
	EndIf
	
	If !lFound
		If lJob
			cEmailErro :="ReadXML Error:"+ENTER
			cEmailErro +="Arquivo: " +cFile+ENTER
			cEmailErro +="Ocorrencia: Nใo encontado a Empresa/Filial do XML ou CNPJ invแlido"
			ConOut(Replicate("=",80))
			ConOut("ReadXML Error:")
			ConOut("Arquivo: " +cFile)
			ConOut("Erro: " +cEmailErro)
			Return
		Else
			cEmailErro :="ReadXML Error:"+ENTER
			cEmailErro +="Arquivo: " +cFile+ENTER
			
			cEmailErro +="Ocorrencia: Nใo encontado a Empresa/Filial do XML ou CNPJ invแlido"
			
			Aviso("Erro",cEmailErro,{"OK"},2,"ReadXML")
			Return
		EndIf
	EndIf
	
	If lProces
		SA2->(dbSetOrder(3))
		If SA2->(dbSeek(xFilial('SA2')+AllTrim(cCGCTP)))
			cCodigo :=	SA2->A2_COD
			cLoja	:=	SA2->A2_LOJA
			cNomeFor:=	SA2->A2_NOME
		ElseIf SimNao("Fornecedor de CNJP/CPF numero " +cCGCTP +" inexistente na base. Deseja cadastrar automaticamente ?") == "S"
				lProces := IncfornServ(oFullXML[nX]:_NFSE:_INFNFSE:_PRESTADORSERVICO)
			SA2->(dbSetOrder(3))
			SA2->(dbSeek(xFilial("SA2")+cCGCTP))
			cCodigo :=	SA2->A2_COD
			cLoja	:=	SA2->A2_LOJA
			cNomeFor:=	SA2->A2_NOME
		Else
			Aviso("Erro","Este XML possui um prestador de servi็o que nใo estแ cadastrado na empresa/filial corrente.",{"OK"},2,"XML_NFs")
			lProces  := .F.
		EndIf
	EndIf
	
	If lProces
		cDoc	:= StrZero(Val(AllTrim(StrTran( oFullXML[nX]:_NFSE:_INFNFSE:_NUMERO:TEXT, "2015","") )),TamSx3("F1_DOC")[1])
   		dDtEmis	:= StoD(StrTran(AllTrim(SubStr( oFullXML[nX]:_NFSE:_INFNFSE:_DATAEMISSAO:TEXT,1,10)),"-",""))
		
		If ValType(XmlChildEx(oFullXML[nX]:_NFSE:_INFNFSE,"_IDENTIFICACAORPS")) == "O"
			cSerie 	:= SubStr(Alltrim(oFullXML[nX]:_NFSE:_INFNFSE:_IDENTIFICACAORPS:_SERIE:TEXT),1,TamSX3("DS_SERIE")[1])
	 		cRPS	:= Alltrim(oFullXML[nX]:_NFSE:_INFNFSE:_IDENTIFICACAORPS:_NUMERO:TEXT)
	    Else
			cSerie 	:= ""
	 		cRPS	:= ""
		EndIf
		
		If Empty(cDoc)
			lProces  := .F.
		EndIf
		
		cHrEmis	:= Substr(oFullXML[nX]:_NFSE:_INFNFSE:_DATAEMISSAO:TEXT,12)
		cCodNFE	:= Alltrim(oFullXML[nX]:_NFSE:_INFNFSE:_CODIGOVERIFICACAO:TEXT)
		
		cQrySDS := "SELECT DS_DOC                                     "
		cQrySDS += " FROM   " + RetSqlName("SDS") + " SDS             "
		cQrySDS += " WHERE  SDS.DS_FILIAL = '"+xFilial("SDS")+"'      "
		cQrySDS += "        AND SDS.DS_DOC = '"+cDoc+"'               "
		cQrySDS += "        AND SDS.DS_SERIE = '"+cSerie+"'           "
		cQrySDS += "        AND SDS.DS_FORNEC = '"+cCodigo+"'         "
		cQrySDS += "        AND SDS.DS_LOJA = '"+cLoja+"'             "
		cQrySDS += "        AND SDS.D_E_L_E_T_ = ''                   "
		If Select("cQrySDS") > 0
			cQrySDS->( dbCloseArea() )
		EndIf
		
		TcQuery cQrySDS New Alias "QrySDS"
		
		QrySDS->( DbGoTop() )
		
		If QrySDS->( !Bof() .OR. !Eof() )
			If Select("QrySDS") > 0
				QrySDS->( dbCloseArea() )
			EndIf
			Loop
		EndIf
		
		If Select("QrySDS") > 0
			QrySDS->( dbCloseArea() )
		EndIf

	
	EndIf
	
	If lFound
	   						
		cCodServ 	:= StrTran( oFullXML[nX]:_NFSE:_INFNFSE:_SERVICO:_ItemListaServico:TEXT, ".", "" ) 	// Codigo de servico do XML    
		cDescServ	:= Upper(Left(Alltrim(oFullXML[nX]:_NFSE:_INFNFSE:_SERVICO:_DISCRIMINACAO:TEXT),TamSx3("DT_DESCFOR")[1]))	// Descricao do servico
		cProduto    := cCodServ
		cProduto2   := ""
		cStatus     := ""
		cMunServ 	:= Right(oFullXML[nX]:_NFSE:_INFNFSE:_SERVICO:_CODIGOMUNICIPIO:TEXT,7)	// Municipio do servico
		
		IF ExistBlock("MT140ISV")
			cCodServ := ExecBlock("MT140ISV",.F.,.F.,{cCodServ, cMunServ})
			If ValType(cCodServ) != "C" .Or. Empty(cCodServ)
				cCodServ := Right(oFullXML[nX]:_NFSE:_INFNFSE:_SERVICO:_CODIGOMUNICIPIO:TEXT,7)
			EndIf
		Endif
		
		

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณSOLICITAวรO DA CAST PARA TRATAR O CODIGO DO SERVICO COMO CODIGO DO PRODUTOณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	    /*
		//Pesquisa um produto que possui amarra็ใo com fornecedor do XML e possui o codigo de servico correto.    
		BeginSQL Alias "SB1TMP"
			SELECT SB1.B1_COD, SB1.B1_DESC
			FROM %Table:SB1% SB1
			INNER JOIN %Table:SA5%  SA5 ON SA5.A5_PRODUTO = SB1.B1_COD AND SA5.%NotDel%
			INNER JOIN %Table:SA2%  SA2 ON SA2.A2_COD = SA5.A5_FORNECE AND SA2.%NotDel%
			WHERE SB1.B1_FILIAL=%xFilial:SB1% AND SB1.B1_CODISS=%Exp:cCodServ% AND SA2.A2_CGC=%Exp:cCGCTP% AND SB1.%NotDel%
		EndSQL
	
		If !SB1TMP->(EOF())
			cProduto2 := SB1TMP->B1_COD
		Else
			If lJob
				_nContProd++
				ConOut(Replicate("=",80))
				ConOut("ACOMR07 Error:")
				ConOut("Arquivo: " +cFile)
				ConOut("Ocorrencia: " +If(cTipoNF == "N","fornecedor ","cliente ") +cCodigo +"/" +cLoja;
				+" sem cadastro de Produto X " +If(cTipoNF == "N","Fornecedor","Cliente");
				+" para o codigo " +cProduto +".")
				ConOut(Replicate("=",80))
			Else
				If _nContProd == 0
					If lProXFor
						_nContProd++
					Else
						lProces := .F.
					EndIf
				EndIf
			EndIf
		EndIf
		
		SB1TMP->(dbCloseArea())
		*/
				cAliasQry := CriaTrab( , .F. )
				
				cQuery := "SELECT A5_PRODUTO  FROM " +RetSqlName("SA5") 
				cQuery += " WHERE D_E_L_E_T_ <> '*' AND "
				cQuery += "A5_FILIAL  = '" +xFilial("SA5") +"' AND "
				cQuery += "A5_FORNECE = '" +cCodigo +"' AND "
				cQuery += "A5_LOJA    = '" +cLoja +"' AND "
				cQuery += "A5_CODPRF  = '" +cCodServ +"'  "
				
				If Select(cAliasQry) > 0
					(cAliasQry)->(dbCloseArea())
				EndIf  
				
				DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasQry,.F.,.T.)
				DbSelectArea(cAliasQry)
		        
				If !(cAliasQry)->(EOF())
					cProduto2 := (cAliasQry)->A5_PRODUTO
				Else
					If lJob
						_nContProd++
						ConOut(Replicate("=",80))
						ConOut("ACOMR07 Error:")
						ConOut("Arquivo: " +cFile)
						ConOut("Ocorrencia: fornecedor "+cCodigo +"/"+cLoja+" sem cadastro de Produto X " +"Fornecedor para o codigo "+cProduto +".")
						ConOut(Replicate("=",80))
					Else
						If _nContProd == 0
							If lProXFor
								_nContProd++
							Else
								lProces := .F.
							EndIf
						EndIf
					EndIf
				EndIf
				
				(cAliasQry)->(dbCloseArea())
				
		
	EndIf
	
	If lProces .Or. lFound  
	
		//aItens := IIF( ValType(oFullXML[nX]:_NFSE:_INFNFSE:_SERVICO) == "O"  ,	{oFullXML[nX]:_NFSE:_INFNFSE:_SERVICO},  oFullXML[nX]:_NFSE:_INFNFSE:_SERVICO  )
	 
	 	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณ Grava os Dados do Cabecalho - SDS  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DbSelectArea("SDS")  
		SDS->(DbSetOrder(1))    
		//DS_FILIAL, DS_DOC, DS_SERIE, DS_FORNEC, DS_LOJA, R_E_C_N_O_, D_E_L_E_T_
		If !(SDS->(DbSeek(xFilial("SDS")+cDoc+cSerie+cCodigo+cLoja)))
			AADD(aHeadSDS,  { {"DS_FILIAL"	,xFilial("SDS")													                	},; //Filial
							{"DS_CNPJ"		,cCGCTP																				},; //CGC
							{"DS_DOC"		,cDoc 																				},; //Numero do Documento
							{"DS_SERIE"		,cSerie 																			},; //Serie
							{"DS_FORNEC"	,cCodigo																			},; //Fornecedor
							{"DS_LOJA"		,cLoja 																				},; //Loja do Fornecedor
							{"DS_NOMEFOR"	,cNomeFor																			},; //Nome do Fornecedor
							{"DS_EMISSA"	,dDtEmis										 						   			},; //Data de Emissใo
							{"DS_EST"		,oFullXML[1]:_NFSE:_INFNFSE:_TOMADORSERVICO:_ENDERECO:_UF:TEXT 						},; //Estado de emissao da NF
							{"DS_TIPO"		,"N"																				},; //Tipo da Nota
							{"DS_FORMUL"	,"N" 																		 		},; //Formulario proprio
							{"DS_CHAVENF"	,xFilial("SDS")+cDoc+cSerie+cCodigo+cLoja											},; //Chave de Acesso da NF
							{"DS_ESPECI"	,"NFS"																		  		},; //Especie
							{"DS_ARQUIVO"	,AllTrim(cFile)																   		},; //Arquivo importado
							{"DS_STATUS"	,"N"			 																	},; //Status  cXMLOri
							{"DS_NFXML"   	,cXMLOri		 																	},; //Status  cXMLOri
							{"DS_USERIMP"	,IIf(!lJob,cUserName,"Via Job")														},; //Usuario na importacao
							{"DS_DATAIMP"	,dDataBase																			},; //Data importacao do XML
							{"DS_HORAIMP"	,SubStr(Time(),1,5)															   		}}) //Hora importacao XML
		
							If FieldPos("DS_CODNFE") > 0 .And. FieldPos("DS_NUMRPS") > 0 .And. FieldPos("DS_HORNFE") > 0
								aAdd(aHeadSDS[1],{"DS_CODNFE" 	,cCodNFE	}) //Codigo de verifica็ao na NFe
								aAdd(aHeadSDS[1],{"DS_NUMRPS"	,cRPS		}) //Numero do RPS
								aAdd(aHeadSDS[1],{"DS_HORNFE"	,cHrEmis	}) //Hora de emissao da NFe
							EndIf
							If FieldPos("DS_STAPED") > 0 
								aAdd(aHeadSDS[1],{"DS_STAPED"	,"1"	    }) //Status pedido
							EndIf
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณ Dados dos Itens - SDT	   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		DbSelectArea("SDT")
		SDT->(DbSetOrder(1))   
		//DT_FILIAL, DT_CNPJ, DT_FORNEC, DT_LOJA, DT_DOC, DT_SERIE, R_E_C_N_O_, D_E_L_E_T_
		IF !SDT->(dbSeek(xFilial("SDT")+cCGCTP+cCodigo+cLoja+cDoc+cSerie))
			aAdd(aItemSDT,{ {"DT_FILIAL" 	,xFilial("SDT")															},; //Filial
							{"DT_CNPJ"		,cCGCTP																	},; //CGC Tag Prestador
							{"DT_COD"		,cProduto2																},; //Codigo do produto
							{"DT_PRODFOR"	,cProduto																},; //Cdgo do pduto do Fornecedor
							{"DT_DESCFOR"	,cDescServ                                                          	},; //Dcao do pduto do Fornecedor
							{"DT_ITEM"   	,PadL(cValToChar(1),TamSX3("D1_ITEM")[1],"0")							},; //Item
							{"DT_QUANT"  	,1           									   						},; //Qtde
							{"DT_VUNIT"		,Val(oFullXML[nX]:_NFSE:_INFNFSE:_SERVICO:_VALORES:_VALORSERVICOS:TEXT)	},; //Vlor Unitแrio
							{"DT_FORNEC"	,cCodigo																},; //Forncedor
							{"DT_LOJA"   	,cLoja																	},; //Lja
							{"DT_DOC"    	,cDoc																	},; //DocmTo
							{"DT_SERIE"		,cSerie							   										},; //Serie
					  		{"DT_TOTAL"		,Val(oFullXML[nX]:_NFSE:_INFNFSE:_SERVICO:_VALORES:_VALORSERVICOS:TEXT)	}}) //Vlor Total
		EndIf
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณGrava os dados do cabe็alho e itens da nota importada do XMLณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Begin Transaction
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณCaso contenha alguma nota com produto em branco DT_COD modificar DS_STATUS X Atualizar produto         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//--Grava Itens
		For nA:=1 To Len(aItemSDT)
			RecLock("SDT",.T.)
			For nB:=1 To Len(aItemSDT[nA])
				If nB == 3
					If Empty(aItemSDT[nA][nB][2])
						cStatus := 'X'
					EndIf
				EndIf
				SDT->&(aItemSDT[nA][nB][1]):= aItemSDT[nA][nB][2]
			Next
			dbCommit()
			MsUnlock()
		Next
		
		//--Grava cabe็alho
		aHeadSDS:=aHeadSDS[1]
		RecLock("SDS",.T.)
		For nA:=1	To Len(aHeadSDS)
			If aHeadSDS[nA][1] == 'DS_STATUS'
				If cStatus == 'X'
					aHeadSDS[nA][2] := cStatus
				EndIf
			EndIF
			SDS->&(aHeadSDS[nA][1]):= aHeadSDS[nA][2]
		Next
		dbCommit()
		MsUnlock()
   		End Transaction
	EndIf
Next



If !lProces .And. lDelFile
	//-- Move arquivo para pasta dos erros
	Copy File &(DIRXML+DIRALER+cFile) To &(DIRXML+DIRERRO+cFile)
	FErase(DIRXML+DIRALER+cFile)
Else
	//-- Move arquivo para pasta dos processados
	Copy File &(DIRXML+DIRALER+cFile) To &(DIRXML+DIRLIDO+cFile)
	FErase(DIRXML+DIRALER+cFile)
	aAdd(aProc,{cDoc,cSerie,cNomeFor})
EndIf


Return lProces



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInclui_fornServ บAutor  ณFelipi Marquesบ Data ณ  10/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclui fornecedor de servi็os                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function IncfornServ(oIncFor)

Local cCepT 	:= ""
Local cRecpis	:= ""
Local cRecCof	:= ""
Local cRecCsl	:= ""
Local cCalcIR	:= ""
Local GRTRIB	:= ""
Local cEstado   := ""
Local cGRTRIB   := ""
Local CCOMPLEM  := ""
Local cPessoa   := ""
Local cCod      := ""
Local aDestFor  := {}


cCGC  := UPPER(oIncFor:_IDENTIFICACAOPRESTADOR:_CNPJ:TEXT) 

DbSelectarea('SA2')
SA2->(dbSetorder(3))
If SA2->(dbSeek(xFilial("SA2")+Substr(Alltrim(cCGC),1,8))) //Verifica se o forncecedor nใo ้ uma filial 

	If Substr(Alltrim(cCGC),9,5) <> Substr(SA2->A2_CGC,9,5)
		While SA2->(!Eof()) .and. SA2->A2_COD == cCod
			cLoja		:=	Soma1(SA2->A2_LOJA) //carrega loja novo cliente
			cCod		:=	SA2->A2_COD
		SA1->(dbSkip())
		Enddo
	EndIf
	
Else
	cCod := Getsxenum('SA2','A2_COD')
	cLoja:= '01'
EndIf

cNOME      	:= UPPER(UPPER(oIncFor:_RAZAOSOCIAL:TEXT))
cNREDUZ	    := UPPER(UPPER(oIncFor:_RAZAOSOCIAL:TEXT))
cEstado 	:= Upper(oIncFor:_ENDERECO:_UF:TEXT)
cEND       	:= UPPER(oIncFor:_ENDERECO:_ENDERECO:TEXT)
cNUM       	:= UPPER(oIncFor:_ENDERECO:_NUMERO:TEXT)

If ValType(XmlChildEx(oIncFor:_ENDERECO,"_COMPLEMENTO")) == "O"
	cCOMPLEM    := UPPER(oIncFor:_ENDERECO:_COMPLEMENTO:TEXT)
Else
	cCOMPLEM    := ""
EndIf
cBAIRRO    	:= UPPER(oIncFor:_ENDERECO:_BAIRRO:TEXT)
cCOD_MUN   	:= ""
cINSCR     	:= UPPER(oIncFor:_IDENTIFICACAOPRESTADOR:TEXT)
cCEP       	:= UPPER(oIncFor:_ENDERECO:_CEP:TEXT)


if val(cNUM) # 0 // Se numero for valido, sera inserido no endereco, caso contrario sera inserido no complemento
	cEND := STRTRAN(cEND,",",".")
	cEND += ", "+cNUM
endif

cTIPO      := IF(LEN(cCGC)=11,'F','J')

		 
aDestFor  := {      {"A2_FILIAL"     ,xFilial("SA2")    ,Nil},;
					{"A2_COD"       ,cCod    			,Nil},;
					{"A2_LOJA"      ,cLoja   			,Nil},;
					{"A2_TPESSOA"	,cPessoa 			,Nil},;
					{"A2_CGC"       ,cCGC    			,Nil},;
					{"A2_CEP"       ,cCEP    			,Nil},;
					{"A2_EST"       ,cESTADO 			,Nil},;
					{"A2_END"       ,cEND    			,Nil},;
					{"A2_BAIRRO"    ,cBAIRRO 			,Nil},;
					{"A2_COD_MUN"   ,cCOD_MUN 			,Nil},;
					{"A2_COMPLEM"   ,cCOMPLEM			,Nil},;
					{"A2_INSCR"     ,cINSCR  			,Nil},;
					{"A2_NOME"      ,cNOME   			,Nil},;
					{"A2_NREDUZ"    ,cNREDUZ 			,Nil},;
					{"A2_TIPO"      ,cTIPO   			,Nil}}


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณGrava cadastro do fornecedor.                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RecLock("SA2",.T.)
For nC := 1 To Len(aDestFor)	
	SA2->&(aDestFor[nC,1])	:= aDestFor[nC,2]	
Next
MsUnLock() 
ConfirmSX8()

Return(.T.)
 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACOMR08   บAutor  ณMicrosiga           บ Data ณ  12/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TXTtoARRAY( cLinNFE )

Local cDelim	:= '|'
Local aCpoNFE	:= {}
Default cLinNFE := ""

Do While Len(cLinNFE) > 0
	
	aAdd( aCpoNFE, Alltrim( Substr( cLinNFE, 1, IIF( At( cDelim, cLinNFE ) == 0, Len(cLinNFE),At( cDelim, cLinNFE )-1) ) ) )
	If  At( cDelim, cLinNFE ) == 0
		exit
	Else
		cLinNFE := Substr( cLinNFE, At( cDelim, cLinNFE )+1 )
	EndIf
	
Enddo

Return( aCpoNFE )    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออหออออัออออออออออปฑฑ
ฑฑบPrograma   ณ RetAcent บ Autor ณ Jaime Wikanski            บDataณ04.11.2002บฑฑ
ฑฑฬอออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออสออออฯออออออออออนฑฑ
ฑฑบDescricao  ณ Troca caracteres especificos                                 บฑฑ
ฑฑศอออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetAcent(_cTexto,lConverte)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณ Declaracao de variaveis  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local i				:= 0
Local _cTextoDev 	:= ""
Local _carac 		:= ""

Default lConverte	:= .F.

for i:=1 to len(_cTexto )
	_carac := substr( _ctexto,i,1 )
	do Case
		Case Asc(_carac) = 224 .Or. Asc(_carac) = 225 .Or. Asc(_carac) = 226 .Or. Asc(_carac) = 227 .Or. Asc(_carac) = 228 .Or. Asc(_carac) = 229
			If lConverte
				_carac	:= "A"
			Else
				_carac	:= "a"
			EndIf
		Case Asc(_carac) = 232 .Or. Asc(_carac) = 233 .Or. Asc(_carac) = 234 .Or. Asc(_carac) = 235 .Or. Asc(_carac) = 144
			If lConverte
				_carac	:= "E"
			Else
				_carac	:= "e"
			EndIf
		Case Asc(_carac) = 236 .Or. Asc(_carac) = 237 .Or. Asc(_carac) = 238 .Or. Asc(_carac) = 239
			If lConverte
				_carac	:= "I"
			Else
				_carac	:= "i"
			EndIf
		Case Asc(_carac) = 240 .Or. Asc(_carac) = 242 .Or. Asc(_carac) = 243 .Or. Asc(_carac) = 244 .Or. Asc(_carac) = 245 .Or. Asc(_carac) = 246
			If lConverte
				_carac	:= "O"
			Else
				_carac	:= "o"
			EndIf
		Case Asc(_carac) = 249 .Or. Asc(_carac) = 250 .Or. Asc(_carac) = 251 .Or. Asc(_carac) = 252
			If lConverte
				_carac	:= "U"
			Else
				_carac	:= "u"
			EndIf
		Case Asc(_carac) = 231
			If lConverte
				_carac	:= "C"
			Else
				_carac	:= "c"
			EndIf
		Case Asc(_carac) = 241
			If lConverte
				_carac	:= "N"
			Else
				_carac	:= "n"
			EndIf
		Case Asc(_carac) = 253 .Or. Asc(_carac) = 255
			If lConverte
				_carac	:= "Y"
			Else
				_carac	:= "y"
			EndIf
		Case Asc(_carac) = 192 .Or. Asc(_carac) = 193 .Or. Asc(_carac) = 194 .Or. Asc(_carac) = 195 .Or. Asc(_carac) = 196 .Or. Asc(_carac) = 197
			_carac	:= "A"
		Case Asc(_carac) = 200 .Or. Asc(_carac) = 201 .Or. Asc(_carac) = 202 .Or. Asc(_carac) = 203
			_carac	:="E"
		Case Asc(_carac) = 204 .Or. Asc(_carac) = 205 .Or. Asc(_carac) = 206 .Or. Asc(_carac) = 207
			_carac	:= "I"
		Case Asc(_carac) = 210 .Or. Asc(_carac) = 211 .Or. Asc(_carac) = 212 .Or. Asc(_carac) = 213 .Or. Asc(_carac) = 214
			_carac	:= "O"			
		Case Asc(_carac) = 217 .Or. Asc(_carac) = 218 .Or. Asc(_carac) = 219 .Or. Asc(_carac) = 220
			_carac	:= "U"
		Case Asc(_carac) = 199
			_carac	:= "C"
		Case Asc(_carac) = 209
			_carac	:= "N"
		Case Asc(_carac) = 221
			_carac	:= "Y"
	EndCase
	
	_cTextoDev += _carac
	
Next

_cTextoDev := Alltrim(StrTran(Alltrim(_cTextoDev),chr(13)+chr(10),""))
_cTextoDev := Alltrim(StrTran(Alltrim(_cTextoDev),chr(13),""))
_cTextoDev := Alltrim(StrTran(Alltrim(_cTextoDev),chr(10),""))

Return( _cTextoDev )         
