#include "rwmake.ch"
User Function FISEXPNFE()
Local cXML 		:= PARAMIXB[1]

If !Empty(cXML)                                	
	nIniPos := At('<nNF>',cXML)+Len('<nNF>')
	nFimPos := At('</nNF>',cXML)
    cNota	:= StrZero(Val(SubStr(cXML,nIniPos,nFimPos-nIniPos)),TamSX3("F2_DOC")[1])

	nIniPos := At('<infNFe Id="NFe',cXML)+Len('<infNFe Id="NFe')
	nFimPos := At('" versao="3.10"><ide>',cXML)
    cArquivo:= AllTrim(MV_PAR04)+SubStr(cXML,nIniPos,nFimPos-nIniPos)+'-nfe.xml'
    
    If File(cArquivo)
    	cXML    := MemoRead(cArquivo)
		cXML 	:= StrTran(cXML,'<vFCPUFDest>0</vFCPUFDest><vICMSUFDest>0</vICMSUFDest><vICMSUFRemet>0</vICMSUFRemet>','')
	    If SF2->(dbSetOrder(1), dbSeek(xFilial("SF2")+cNota))
	    	If SF2->F2_TIPO == 'N'
	    		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
	    		
	    		If 'C&A'$SA1->A1_NOME
					cDestino := 'C:\TEMP\'
					cArquivo := 'XML_CA_'+SF2->F2_DOC+'.XML'
					MemoWrite(cDestino+cArquivo,cXML)
					msgalert("Arquivo XML Para Envio C&A Gerado na Pasta C:\TEMP\"+cArquivo)	
				Endif
			Endif
		Endif
	Endif
EndIF	


Return Nil