#INCLUDE "topconn.ch"
#INCLUDE "SHELL.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ETAIFF01  �Autor  Luiz Oliveira        � Data �  10/08/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Impressao etiqueta de saida IMCD			                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function ETAIFF04()

Local lContinua := .T.

vSetImp := {}
vSetImp := ExParam()

If Empty(vSetImp[1,5])
	MsgAlert("Informe um local de impressao valido")
	lContinua := .F.
EndIf

If !CB5SetImp(vSetImp[1,5])  
	MsgAlert("Local de Impress�o "+vSetImp[1,2]+" nao Encontrado!") 
	lContinua := .F.
	Return
Endif	

If lContinua
	ImpEti07(vSetImp[1,1],vSetImp[1,2],vSetImp[1,3],vSetImp[1,4])
	MSCBCLOSEPRINTER()             
EndIf

Return
//////////////////////////////////////////
//Rotina de impressao de etiqueta      //
/////////////////////////////////////////
Static Function ImpEti07(vDoc,vDoc1,vDoc2,vDoc3)

Local cQuery	:= ""
Local ZQuery	:= ""
Local cAliasNew	:= GetNextAlias()
Local cCodBar	:= ''
Local sConteudo	:= ""
Local cForn := cProd := cCodProd := cCOdDCB := cDesDCB := cNfiscal := cLote := cFabrinte := cExport := " "
Local cUmidade := cLumin := cOrigem := cProced := " " 
Local cPliq := cPBruto := cTemper := 0 
Local cFabricao := cVal := " "
Local z := 0

Private ENTERL     := CHR(13)+CHR(10)

//+-----------------------
//| Cria filtro temporario
//+-----------------------

cAliasNew:= GetNextAlias()

cQuery 	:= " SELECT D2_COD, SUM(D2_QUANT) AS QUANT, D2_CLIENTE, D2_LOJA, D2_DOC,  D2_SERIE, D2_LOTECTL  FROM " +RetSqlName("SD2") + " WHERE D2_FILIAL = '"+ xFilial("SD2")+"' AND " 
cQuery 	+= "  D2_DOC BETWEEN   '" +vDoc+"' AND '"+vDoc1+"' AND D2_LOTECTL BETWEEN '"+vDoc2+"' AND '"+vDoc3+"'" 
cQuery 	+= "  AND D_E_L_E_T_<>'*'" 
cQuery 	+= "  GROUP BY D2_COD, D2_CLIENTE, D2_LOJA, D2_DOC, D2_SERIE, D2_LOTECTL" 

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)
(cAliasNew)->(dbGoTop())

If Select(cAliasNew) < 1
	Alert("Opera��o Cancelada.")
	Return()
EndIf


While (cAliasNew)->(!Eof())                           

	Dbselectarea("SB1")
	SB1->( dbSetOrder( 1 ) )
	SB1->( DbSeek(xFilial("SB1")+ (cAliasNew)->D2_COD) ) 
	
	xQtdEtq := 0
	xQtdEtq := (cAliasNew)->QUANT / SB1->B1_QE
	
	For z := 1 to xQtdEtq	                   

	Dbselectarea("SA1")
	SA1->( dbSetOrder( 1 ) )
	SA1->( DbSeek(xFilial("SA1")+ (cAliasNew)->D2_CLIENTE + (cAliasNew)->D2_LOJA) )
	
	Dbselectarea("SB1")
	SB1->( dbSetOrder( 1 ) )
	SB1->( DbSeek(xFilial("SB1")+ (cAliasNew)->D2_COD) ) 
	
	Dbselectarea("SD2")
	SD2->( dbSetOrder( 3 ) )
	SD2->( DbSeek(xFilial("SD2")+ (cAliasNew)->D2_DOC+ (cAliasNew)->D2_SERIE+ (cAliasNew)->D2_CLIENTE+ (cAliasNew)->D2_LOJA+ (cAliasNew)->D2_COD) ) 
	

	cCodBar:= ALLTRIM((cAliasNew)->D2_COD) 
	cCodBar1:= ALLTRIM((cAliasNew)->D2_LOTECTL)

	MSCBBEGIN(1,6)

//cabe�alho	
	MSCBSAY(010,005,"IMCD","N","0","035,040")	
    MSCBSAY(024,006,"Brasil Farma","N","0","025,025")	

	MSCBSAY(050,003,"Fone: (11) 5591-2300","N","0","020,020")
	MSCBSAY(050,006,"CNPJ: 62.651.955/0001-66","N","0","020,020")     

    MSCBSAY(090,006,alltrim(str(z)) + "/" + alltrim(str(xQtdEtq)),"N","0","020,020")

    MSCBLineH(01,10,100)
	       
//Fornecedor
	MSCBSAY(005,011, substr(SA1->A1_NOME,1,37) ,"N","0","028,028")

	MSCBSAY(005,014, ALLTRIM(SA1->A1_MUN) + " - " + ALLTRIM(SA1->A1_EST),"N","0","028,028") 
	
//Produto
    MSCBSAY(005,019, "Produto: ","N","0","028,028")

	MSCBSAY(019,019, substr(SB1->B1_DESC,1,25),"N","0","025,028")
	
	MSCBSAY(005,024, "DCB: " + ALLTRIM(SB1->B1_DCB),"N","0","025,028")
	
	MSCBSAY(030,024, "CAS: " + ALLTRIM(SB1->B1_CASNUM),"N","0","025,028")
	
	xDescDCB := " " 
	xDescDCB := Posicione("ZDC",1,xFilial("ZDC")+SB1->B1_DCB,"ZDC_DESC")  
	
	MSCBSAY(005,028,ALLTRIM(xDescDCB),"N","0","025,028")

	MSCBSAY(005,033,"N.Fiscal: " + ALLTRIM((cAliasNew)->D2_DOC),"N","0","025,028")

	MSCBSAY(040,033,"P.Liquido: " + ALLTRIM(STR(round(SB1->B1_QE,2))) +" "+ALLTRIM(SB1->B1_UM),"N","0","025,028")

	If SB1->B1_PESBRU > 0 .and. SB1->B1_PESO > 0
   		MSCBSAY(073,033,"P.Bruto: " + ALLTRIM(STR(round(SB1->B1_QE*(SB1->B1_PESBRU/SB1->B1_PESO),2)))+" "+ ALLTRIM(SB1->B1_UM),"N","0","025,028") 
	Else
   		MSCBSAY(073,033,"P.Bruto: " + ALLTRIM(STR(round(SB1->B1_QE,2)))+" "+ALLTRIM(SB1->B1_UM),"N","0","025,028") 
	Endif

	DBSELECTAREA("SB8")
	dbsetorder(5)
	DBSEEK(xFilial("SB8")+(cAliasNew)->D2_COD + (cAliasNew)->D2_LOTECTL)

	MSCBSAY(005,037,"Lote Forn.: " + ALLTRIM(SB8->B8_LOTECTL),"N","0","025,028")

	MSCBSAY(073,037,"Fab.: " + DTOC(SB8->B8_DFABRIC) ,"N","0","025,028")

	MSCBSAY(073,041,"Val.: " + DTOC(SB8->B8_DTVALID) ,"N","0","025,028")

	MSCBSAY(005,042, "Cond. Armazenagem: " + ALLTRIM(strtran(SB1->B1_XTEMP, "�", " ")),"N","0","020,020")
	
	MSCBSAY(005,047, "Umidade: " + ALLTRIM(strtran(SB1->B1_XDUMI, "�", " ")),"N","0","020,020")

	MSCBSAY(005,052, "Luminosidade: " + ALLTRIM(strtran(SB1->B1_XDLUM, "�", " ")),"N","0","020,020")
	
		If Select("RMIN3") > 0
			RMIN3->( dbCloseArea() )
		EndIf
		
		ZQuery 	:= " SELECT *  FROM " +RetSqlName("SD1") + " WHERE D1_FILIAL = '"+ xFilial("SD1")+"' AND " 
		ZQuery 	+= " D1_COD = '"+SB1->B1_COD+"' AND D1_LOTEFOR = '"+SB8->B8_LOTEFOR+"' " 
		ZQuery 	+= "  AND D_E_L_E_T_<>'*'" 
		
		TCQUERY ZQuery  NEW ALIAS "RMIN3" 
		
		DbSelectArea("RMIN3")
		DbGotop()
		
	xFabric := " " 
	xFabric := Posicione("SA2",1,xFilial("SA2")+RMIN3->D1_FABRIC+RMIN3->D1_LOJFABR,"A2_NOME")  
	
	MSCBSAY(005,057, "Fabricante: " + ALLTRIM(xFabric),"N","0","020,020")                   
	
	DBSELECTAREA("SA2")
	dbsetorder(1)
	DBSEEK(xFilial("SA2")+RMIN3->D1_FABRIC+RMIN3->D1_LOJFABR)
	
	DBSELECTAREA("SYA")
	dbsetorder(1)
	DBSEEK(xFilial("SYA")+SA2->A2_PAIS)
	
	MSCBSAY(073,057, "Origem: " + ALLTRIM(SYA->YA_DESCR),"N","0","020,020") 
	
	DBSELECTAREA("SA2")
	dbsetorder(1)
	DBSEEK(xFilial("SA2")+RMIN3->D1_FORNECE+RMIN3->D1_LOJA)

	DBSELECTAREA("SYA")
	dbsetorder(1)
	DBSEEK(xFilial("SYA")+SA2->A2_PAIS)


	MSCBSAY(005,062, "Exportador: " + ALLTRIM(SA2->A2_NOME),"N","0","020,020") 		

	MSCBSAY(073,062, "Procedencia: " + ALLTRIM(SYA->YA_DESCR) ,"N","0","020,020") 	

	MSCBSAY(015,070,"Farmac�utico Respons�vel: Beatriz Fernandes Machado - CRF - SP 36.245 ","N","0","018,018")  

	MSCBSAY(012,073,"Rua Arquiteto Olav Redig de Campos, 105 - Torre B - 25 Andar - S�o Paulo/SP ","N","0","018,018")
 
    sConteudo:=MSCBEND()
	Next Z
		
	(cAliasNew)->(dbSkip())

EndDo 

(cAliasNew)->(DbCloseArea())

If Empty(sConteudo)
	MsgAlert("Sem Dados para Impress�o! Verifique os Parametros!!!","A T E N � � O!!!")
	Return
Else
	Return sConteudo
EndIf


Static Function ExParam()
Local aPergs := {}
Local aRet := {}
Local lRet  
Local xImp := '000001'
Local vConf := {}                           

		xDoc := SPACE( TamSX3( 'D2_DOC' )[1] )
		xDoc1 := SPACE( TamSX3( 'D2_DOC' )[1] )
		xDoc2 := xDoc3 :=space(18)
		aAdd( aPergs ,{1,"Nota de saida De : ",xDoc  ,"@!",'.T.', ,'.T.',40,.T.})
		aAdd( aPergs ,{1,"Nota de saida Ate : ",xDoc1  ,"@!",'.T.', ,'.T.',40,.T.})
		aAdd( aPergs ,{1,"Lote Interno De : ",xDoc2  ,"@!",'.T.', ,'.T.',40,.F.}) 
		aAdd( aPergs ,{1,"Lote Interno Ate : ",xDoc3  ,"@!",'.T.', ,'.T.',40,.T.})    
		aAdd( aPergs ,{1,"Impressora: ",xImp  ,"@!",'.T.',"CB5",'.T.',40,.T.}) 

	If ParamBox(aPergs ,"Parametros4 ",aRet)      
		lRet := .T.   
	Else      
   
		lRet := .F.   
	EndIf 
If lRet = .F. 
	Alert("Bot�o Cancelar")
	Return()
Else
	aAdd( vConf ,{aRet[1],aRet[2],aRet[3],aRet[4],aRet[5]}) 
Endif    


	               

Return (vConf)
