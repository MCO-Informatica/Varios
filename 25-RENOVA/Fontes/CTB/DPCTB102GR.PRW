#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT105LOK   ºAutor  ³Wellington Mendes  º Data ³  Fev/2015   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada antes da Gravação do lançamento contabil  º±±
º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

*/




User Function DPCTB102GR(nOpc,dDataLanc,cLote,cSubLote,cDoc)

Local _cOrig:= {}
Local nOpc := PARAMIXB[1]
Local dDataLanc:= PARAMIXB[2]
Local cLote := PARAMIXB[3]
Local cSubLote := PARAMIXB[4]
Local cDoc := PARAMIXB[5]
Local _nX


dbSelectArea( 'CT2' )
dbSetOrder( 1 )
DbSeek(xFilial() + DTOS(dDataLanc) + cLote + cSubLote + cDoc )
While !CT2->( EOF() ) .And. CT2->CT2_FILIAL + DTOS(CT2->CT2_DATA) + CT2->CT2_LOTE + CT2->CT2_SBLOTE + CT2->CT2_DOC + CT2->CT2_LINHA == xFilial() + DTOS(dDataLanc) + cLote + cSubLote + cDoc + CT2->CT2_LINHA
	IF nOpc == 4 //Alteração de lançamentos Contail
		aAdd(_cOrig,"Alterado por" +"/ "+cUserName)
		
	Elseif nOpc == 6 //Estorno de lançamento contabil
		aAdd(_cOrig,"Estornado por" +"/ "+cUserName)
		
	Elseif nOpc == 7 //cópia de lançamentos Contail
		aAdd(_cOrig,"Copiado por" +"/ "+cUserName)
	Else
		aAdd(_cOrig,ALLTRIM(CT2_ORIGEM))//Mantem o que ja esta.
	Endif
	
	For _nX := 1 to Len( _cOrig)
		Reclock("CT2",.F.)
		CT2_ORIGEM:= _cOrig[_nX]
		MsUnLock()
	Next _nX
	CT2->( dbSkip())
	
Enddo


Return({ nOpc,dDataLanc,cLote,cSubLote,cDoc })

