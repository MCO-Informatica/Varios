#INCLUDE "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SD1100I   ºAutor  ³ Antonio Carlos    º Data ³  30/07/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravar campos especificos de contrato nos itens da nota    º±±
±±º          ³ de entrada e gravacado do SD1 para SN1, SN3 e SZ0.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ renova                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                       
User function SD1100I()

Local _cQuery  := ''
Local _cQuery2 := ''
Local _cQuery3 := ''
Local _cNomPro := ''
Local _cConta  := ''
////Fontes Renova - Compatibilização dos Fontes 23/10/2015
Local aAreaAtu	:= GetArea()
Local aDados	:= {}

If !Empty(SD1->D1_PEDIDO)
	aDados := GetAdvFval("SC7",{"C7_CONTRA","C7_CONTREV"},xFilial('SC7')+SD1->D1_PEDIDO,1)
EndIf

If Len(aDados) > 0
  RecLock("SD1",.F.)
  	SD1->D1_XCONTR 	:= aDados[1]
  	SD1->D1_XREVIS	:= aDados[2]
  SD1->(msunlock())
EndIF  
////Final Fontes Renova

If !Empty(SD1->D1_XPROJIM)
	
	If Substr(SD1->D1_CONTA,1,7)= '1232103'
		_cConta := SD1->D1_CONTA
	Else
		_cConta := '1232101010104'
	EndIf
	DbSelectArea("SZ0")
	DbSetOrder(1)
	If MsSeek(xFilial("SD1")+SD1->D1_XPROJIM)
		_cNomPro := SZ0->Z0_NOME	                                           
	EndIf

	//Atualiza SN3          
	_cQuery := "UPDATE " + RetSqlName("SN3") + " SET N3_XPROJIM = '"+ SD1->D1_XPROJIM +"'"
	_cQuery += " , N3_TIPO = '03'" 
	_cQuery += " , N3_HISTOR = '"+_cNomPro+"'" 	
	_cQuery += " , N3_CCONTAB = '"+_cConta+"'" 
	_cQuery += " , N3_CUSTBEM = '"+SD1->D1_CC+"'"
	_cQuery += " , N3_SUBCTA = '"+SD1->D1_ITEMCTA+"'"
	_cQuery += " , N3_CLVL = '"+SD1->D1_CLVL+"'"
	_cQuery += " , N3_EC05DB = '"+SD1->D1_EC05DB+"'"
	_cQuery += " , N3_EC05CR = '"+SD1->D1_EC05CR+"'"
	_cQuery += " WHERE  N3_FILIAL = '" +xFilial("SD1")+ "'" 
	_cQuery += " AND N3_CBASE = '"+ SUBSTR(SD1->D1_CBASEAF,1,10) +"'"  
	_cQuery += " AND D_E_L_E_T_ <> '*'" 
	
	//_cQuery := ChangeQuery(_cQuery)

	TCSQLEXEC(_cQuery)
	
	//Atualiza SN1
	_cQuery2 := "UPDATE " + RetSqlName("SN1") + " SET N1_STATUS = '1' "
    _cQuery2 += " WHERE  N1_FILIAL = '" +xFilial("SD1")+ "'" 
	_cQuery2 += " AND N1_CBASE = '"+ SUBSTR(SD1->D1_CBASEAF,1,10) +"'"  
	_cQuery2 += " AND D_E_L_E_T_ <> '*'" 
	
    TCSQLEXEC(_cQuery2)
    
    //Atualiza SZ0
    _cQuery3 := "UPDATE " + RetSqlName("SZ0") + " SET Z0_STATUS = '3'" ///Deixa status do projeto em andamento
	_cQuery3 += " WHERE Z0_CODIGO = '"+ SD1->D1_XPROJIM +"'"
	_cQuery3 += " AND Z0_STATUS = '1'"  
	_cQuery3 += " AND D_E_L_E_T_ <> '*'"
    	
	TCSQLEXEC(_cQuery3)            
	
EndIF 

RestArea( aAreaAtu )

Return()