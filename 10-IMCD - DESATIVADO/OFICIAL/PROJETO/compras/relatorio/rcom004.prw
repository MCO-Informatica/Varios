#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RCOM004  บ Autor ณ  Daniel   Gondran  บ Data ณ  28/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Certificados vencidos fornecedores                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RCOM004()
	Local cPerg := 'RCOM04'    
	Local aConf := {}

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RCOM004" , __cUserID )

		Pergunte( cPerg, .T.)  

	MsgRun("Processando Relat๓rio Certificados vencidos fornecedores","",{|| U_ImpR04() })

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IMPR04   บ Autor ณ  Daniel   Gondran  บ Data ณ  29/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Certificados vencidos fornecedores                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function IMPR04()
	Local cAlias, lQuery, cQuery
	Local aCabec := {}
	Local aDados := {}                  
	Local cDatac := Dtos(dDataBase)
	Local lVai

	DbSelectArea("SA2")
	DbSetOrder(1)

	cAlias:= "XSA2"  

	cQuery := "SELECT "
	cQuery += "  A2_COD, A2_LOJA, A2_NOME, A2_ISO9001, A2_ISO1400, A2_OHSAS18, A2_SA8000, A2_TS16949, A2_PRODIR, A2_SASSMAQ, A2_AVALIA "
	cQuery += "FROM " + RetSqlName("SA2") + " SA2 "     
	cQuery += "WHERE "
	cQuery += "  SA2.A2_LISTAM = 'S'                             
	cQuery += "  AND SA2.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SA2.A2_COD,SA2.A2_LOJA"

	cQuery := ChangeQuery(cQuery)  

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.F.)

	dbSelectArea(cAlias)

	aadd(aCabec, "Codigo"  )
	aadd(aCabec, "Loja"  )    
	aadd(aCabec, "Fornecedor"  )              
	aadd(aCabec, "ISO 9001"  )              
	aadd(aCabec, "ISO 14001"  )              
	aadd(aCabec, "OHSAS 18001"  )
	aadd(aCabec, "SA 8000"  )
	aadd(aCabec, "TS 16949"  )
	aadd(aCabec, "PRODIR" )
	aadd(aCabec, "SASSMAQ" )
	aadd(aCabec, "Avalia็ใo" ) 

	dbGoTop()
	While !EOF()                                                            
		lVai := .F.
		If (!EMPTY((cAlias)->A2_ISO9001).AND.(cAlias)->A2_ISO9001 < cDataC)         
			lVai := .T.
		Endif
		If (!EMPTY((cAlias)->A2_ISO1400).AND.(cAlias)->A2_ISO1400 < cDataC)         
			lVai := .T.
		Endif
		If (!EMPTY((cAlias)->A2_OHSAS18).AND.(cAlias)->A2_OHSAS18 < cDataC)         
			lVai := .T.
		Endif
		If (!EMPTY((cAlias)->A2_SA8000 ).AND.(cAlias)->A2_SA8000  < cDataC)         
			lVai := .T.
		Endif
		If (!EMPTY((cAlias)->A2_TS16949).AND.(cAlias)->A2_TS16949 < cDataC)         
			lVai := .T.
		Endif
		If (!EMPTY((cAlias)->A2_PRODIR ).AND.(cAlias)->A2_PRODIR  < cDataC)         
			lVai := .T.
		Endif
		If (!EMPTY((cAlias)->A2_SASSMAQ).AND.(cAlias)->A2_SASSMAQ < cDataC)         
			lVai := .T.
		Endif
		If (!EMPTY((cAlias)->A2_AVALIA ).AND.(cAlias)->A2_AVALIA  < cDataC)         
			lVai := .T.
		Endif        

		If lVai

			aadd(aDados,;
			{"'" + AllTrim((cAlias)->A2_COD) + "'",;                                                                                                    
			("'" + (cAlias)->A2_LOJA) + "'",;                                                                                                       	
			AllTrim((cAlias)->A2_NOME),;
			IIF(!EMPTY((cAlias)->A2_ISO9001).AND.(cAlias)->A2_ISO9001 < cDataC,Substr((cAlias)->A2_ISO9001,7,2) + "/" + Substr((cAlias)->A2_ISO9001,5,2) + "/" + Substr((cAlias)->A2_ISO9001,1,4),""),;   
			IIF(!EMPTY((cAlias)->A2_ISO1400).AND.(cAlias)->A2_ISO1400 < cDataC,Substr((cAlias)->A2_ISO1400,7,2) + "/" + Substr((cAlias)->A2_ISO1400,5,2) + "/" + Substr((cAlias)->A2_ISO1400,1,4),""),;   
			IIF(!EMPTY((cAlias)->A2_OHSAS18).AND.(cAlias)->A2_OHSAS18 < cDataC,Substr((cAlias)->A2_OHSAS18,7,2) + "/" + Substr((cAlias)->A2_OHSAS18,5,2) + "/" + Substr((cAlias)->A2_OHSAS18,1,4),""),;   
			IIF(!EMPTY((cAlias)->A2_SA8000 ).AND.(cAlias)->A2_SA8000  < cDataC,Substr((cAlias)->A2_SA8000 ,7,2) + "/" + Substr((cAlias)->A2_SA8000 ,5,2) + "/" + Substr((cAlias)->A2_SA8000 ,1,4),""),;   
			IIF(!EMPTY((cAlias)->A2_TS16949).AND.(cAlias)->A2_TS16949 < cDataC,Substr((cAlias)->A2_TS16949,7,2) + "/" + Substr((cAlias)->A2_TS16949,5,2) + "/" + Substr((cAlias)->A2_TS16949,1,4),""),;   
			IIF(!EMPTY((cAlias)->A2_PRODIR ).AND.(cAlias)->A2_PRODIR  < cDataC,Substr((cAlias)->A2_PRODIR ,7,2) + "/" + Substr((cAlias)->A2_PRODIR ,5,2) + "/" + Substr((cAlias)->A2_PRODIR ,1,4),""),;   
			IIF(!EMPTY((cAlias)->A2_SASSMAQ).AND.(cAlias)->A2_SASSMAQ < cDataC,Substr((cAlias)->A2_SASSMAQ,7,2) + "/" + Substr((cAlias)->A2_SASSMAQ,5,2) + "/" + Substr((cAlias)->A2_SASSMAQ,1,4),""),;   
			IIF(!EMPTY((cAlias)->A2_AVALIA ).AND.(cAlias)->A2_AVALIA  < cDataC,Substr((cAlias)->A2_AVALIA ,7,2) + "/" + Substr((cAlias)->A2_AVALIA ,5,2) + "/" + Substr((cAlias)->A2_AVALIA ,1,4),""),;   
			})
		Endif
		dbSkip()  
	EndDo   

	DbCloseArea(cAlias)                                     


	If len(aDados) == 0            
		MsgInfo("Nใo existem dados a serem impressos, de acordo com os parโmetros informados!","Aten็ใo")
	Else  
		DlgToExcel({ {"ARRAY", "Relatorio de Certificados vencidos fornecedores", aCabec, aDados} }) 
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidSX1  บAutor  ณ                    บ Data ณ  XX/XX/XX   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria as perguntas necessarias                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
