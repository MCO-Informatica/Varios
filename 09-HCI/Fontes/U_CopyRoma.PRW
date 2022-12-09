#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

USER FUNCTION CopyRoma()

	Private _cNRoma	:= "" 
	
	Private oDlg        
	
	_cNRoma := (CriaVar("ZO_ROMAN",.F.),SZO->ZO_ROMAN)
	
	Define MsDialog oDlg Title "Copia de Romaneio HCI" From 000,000 To 200, 200 PIXEL
	
	@ 005,005 SAY "Qual romaneio deseja ser copiado?" Size 085/*052*/,007 Of oDlg Colors 0,16777215 PIXEL
	@ 015,005 MSGET oNRoma VAR _cNRoma Size 040,010 Of oDlg Colors 0,16777215 PIXEL
	
	@ 035,005 Button "Sair" Size 030, 012 PIXEL OF oDlg Action(oDlg:End())
	@ 050,005 Button "Copiar" Size 030, 012 PIXEL OF oDlg Action(__CloneRoman(),oDlg:End())

	ACTIVATE MsDialog oDlg Centered

Return(.T.)		                                                                                      

STATIC FUNCTION __CloneRoman()

	Local cQuery := " "
	
	cQuery	:= " SELECT * FROM " + RetSqlName("SZO")
	cQuery	+= " WHERE ZO_FILIAL = '" + xFilial("SZO") + "'"
	cQuery	+= " AND "
	cQuery	+= " ZO_ROMAN = '" + AllTrim(_cNRoma) + "'"
	cQuery 	+= " AND D_E_L_E_T_ = ''"
	
	cQuery	:= ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"TMP",.F.,.T.)
	
	TCSetField("TMP","ZO_EMISSAO","D")
	TCSetField("TMP","ZO_DIMX","N",5,0)
	TCSetField("TMP","ZO_DIMY","N",5,0)
	TCSetField("TMP","ZO_DIMZ","N",5,0)
	TCSetField("TMP","ZO_CUBAGEM","N",5,2)
	TCSetField("TMP","ZO_PSMERC","N",8,2)
	TCSetField("TMP","ZO_QTD","N",10,4)
	TCSetField("TMP","ZO_PESO","N",8,2)
	TCSetField("TMP","ZO_PESOT","N",8,2)
	
	dbSelectArea("TMP")
	While !TMP->(Eof())                 
	
		dbSelectArea("SZO")
		dbSetOrder(1)
		RecLock("SZO",.T.)                         
		SZO->ZO_FILIAL	:= xFilial("SZO")
		cSequencial := StrTran(TMP->ZO_ROMAN,"-","")
		cSequencial	:= Soma1(AllTrim(cSequencial))
		SZO->ZO_ROMAN	:= AllTrim(SubStr(cSequencial,1,6))+"-"+AllTrim(SuBStr(cSequencial,7,9))
		SZO->ZO_EMISSAO	:= TMP->ZO_EMISSAO
		SZO->ZO_EMBAL	:= AllTrim(TMP->ZO_EMBAL)
		SZO->ZO_DIMX	:= TMP->ZO_DIMX
		SZO->ZO_DIMY	:= TMP->ZO_DIMY
		SZO->ZO_DIMZ	:= TMP->ZO_DIMZ
		SZO->ZO_REFCLI	:= AllTrim(TMP->ZO_REFCLI)
		SZO->ZO_CUBAGEM	:= TMP->ZO_CUBAGEM
		SZO->ZO_PSMERC	:= TMP->ZO_PSMERC
		SZO->ZO_SEQ		:= AllTrim(TMP->ZO_SEQ)
		SZO->ZO_PEDIDO	:= AllTrim(TMP->ZO_PEDIDO)
		SZO->ZO_ITEM	:= AllTrim(TMP->ZO_ITEM)
		SZO->ZO_COD		:= AllTrim(TMP->ZO_COD)
		SZO->ZO_DESCRI	:= AllTrim(TMP->ZO_DESCRI)
		SZO->ZO_QTD		:= TMP->ZO_QTD
		SZO->ZO_PESO	:= TMP->ZO_PESO
		SZO->ZO_PESOT	:= TMP->ZO_PESOT
		SZO->ZO_CODCLI	:= AllTrim(TMP->ZO_CODCLI)
		SZO->ZO_ITEMCLI	:= AllTrim(TMP->ZO_ITEMCLI)		
		/*TMP->(dbSkip())
		MsUnlock()
		SZO->(dbSkip())*/
		MsUnlock()
  		DbSelectArea("TMP")
  		DbSkip()
 	Enddo

	
	dbSelectArea("TMP")
	dbCloseArea()
	
Return()		