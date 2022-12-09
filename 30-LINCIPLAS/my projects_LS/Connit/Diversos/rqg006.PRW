#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rqg006  			 Ricardo Felipelli   º Data ³  14/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Corrige ativo sem conta contabil                           º±±
±±º          ³ filial R0                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function rqg006()
Local _Opcao := .f.

If MsgYesNO("Inclui conta contabil  ","executa")
	Processa({|| ImpAtiv()},"Processando...")
EndIf

Return nil


Static Function ImpAtiv()
Local aATFA010 := {}
Local aItens   := {}
Local aLinha   := {}
Local _arquivo := "e:\DBF_CUST.dtc"
Local _arquivo2:= "\system\PRO_SN3.dtc"

dbselectarea("CT1")
dbsetorder(01)

DBUseArea( .T.,,"PRO_SN3", "TMPSN3", .F., .F. )
cChave := "N3_FILIAL"
cindex := Criatrab(Nil,.F.)
IndRegua("TMPSN3",cindex,cChave,,,"Selecionando Registros")

cArqrf1:="\system\PRO_SN1_RF"

DBUseArea(.T.,,"PRO_SN1_RF", "RF1", .F., .F. )

cChave:="N1_FILIAL+N1_CBASE"
IndRegua("RF1",cArqrf1,cChave,,,"Selecionando Registros...")
dbSelectArea("RF1")
dbGoTop()


while TMPSN3->(!eof())                                                                                      

	if TMPSN3->N3_FILIAL == 'R0'
	
		RF1->(DBSEEK(TMPSN3->N3_FILIAL+TMPSN3->N3_CBASE))
		If rf1->(found())
			RecLock('TMPSN3', .F. )
			TMPSN3->N3_CCONTAB := RF1->N1_CSEGURO
			TMPSN3->( MsUnLock() )
		endif                 
	endif
	
	dbselectarea("TMPSN3")
	TMPSN3->(dbskip())
enddo

dbselectarea("TMPSN3")
TMPSN3->(dbclosearea())   
dbselectarea("RF1")
RF1->(dbclosearea())   


return nil


