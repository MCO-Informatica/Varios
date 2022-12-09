#include "rwmake.ch"    
#Include "COLORS.CH"
#Include "FONT.CH"
#include "topconn.ch"

User Function MANUTVEND() 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MANUTVEND ³ Autor ³ Alex Rodrigues       ³ Data ³ 11.11.14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Altera vendedores dos pedidos de acordo com uma regra      ³±±
±±³          ³ pre-determinada pela Verion.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                  
_cUser := UPPER(Alltrim(Substr(cUsuario,7,13)))
If !_cUser $ "RENATA LOPES/ELISANGELA VI/ALEX/ADMINISTRADOR/PEDRO"
	MsgStop("Somente os usuários Eli e Renata estão autorizados a usar essa rotina.")
	Return
Endif

AjustaSx1()

DEFINE FONT oFnt     NAME "ARIAL" SIZE 10,23 BOLD

@ 000,000 TO 180,750 DIALOG oDlg TITLE "Manutenção de Vendedores no Pedido / Cliente / Prospect "
                    
WCOD := SPACE(15) 
nTipo := 1             
aTipo := {"No Pv por Cliente","No PV por Vendedor","No Cli por Município","No Cli por Estado","No Prosp por Estado"}

@ 005,005 TO 065,335
@ 020,010 Radio aTipo Var nTipo
@ 070,045 BMPBUTTON TYPE 1 ACTION FechaDlg(.t.)
@ 070,145 BMPBUTTON TYPE 2 ACTION FechaDlg(.f.)

ACTIVATE DIALOG oDlg CENTERED

Static Function FechaDlg( lOk )

If !lOk //Cancelou
	close(oDlg)   
else  // Confirmou
	ExecRot()
Endif            

Return       

Static Function ExecRot()

cNomeVen := ""
If nTipo == 1 //por cliente
	If Pergunte("MANUTV001",.T.)

		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+MV_PAR01)		
		
		DbSelectArea("SA3")
		DbSetOrder(1)
		If DbSeek(xFilial("SA3")+SA1->A1_VEND)
			cNomeVen := SA3->A3_NOME
		Endif

		DbSelectArea("SA3")
		DbSetOrder(1)
		DbSeek(xFilial("SA3")+MV_PAR02)
		
		If MsgYesNo("Deseja alterar todos os pedidos em aberto do cliente "+SA1->A1_COD+"/"+SA1->A1_LOJA+"-"+ALLTRIM(SA1->A1_NOME)+" para o Novo Vendedor: "+MV_PAR02+"-"+ALLTRIM(SA3->A3_NOME)+" ?")
			Processa( {|| fAjusPed()}, "Em Processamento...") 
		Endif
	Endif

ElseIF nTipo == 2 //por vendedor

	If Pergunte("MANUTV002",.T.)	

		cCodVen := ""
		cNomeVen := ""
		DbSelectArea("SA3")
		DbSetOrder(1)
		If DbSeek(xFilial("SA3")+MV_PAR01)
			cCodVen  := SA3->A3_COD
			cNomeVen := SA3->A3_NOME
		Endif

		DbSelectArea("SA3")
		DbSetOrder(1)
		DbSeek(xFilial("SA3")+MV_PAR02)
			
		If MsgYesNo("Todos os pedidos em aberto que estão com o vendedor "+cCodVen+"-"+cNomeVen+" serão alterados para o Novo Vendedor: "+MV_PAR02+"-"+ALLTRIM(SA3->A3_NOME)+". Deseja continuar ?")
			Processa( {|| AtodosV()}, "Em Processamento...") 
		Endif
	Endif

ElseIF nTipo == 3 //por Município
	If Pergunte("MANUTV003",.T.)	
                                                                                                          
        ProcRegua(500)
        nConV := 0

        DBSELECTAREA("SA1")
        SET FILTER TO A1_EST == MV_PAR01 .AND. A1_COD_MUN == MV_PAR02
        DbGotop()
        
        WHILE !EOF()
        	IncProc("Processando Cliente: " + SA1->A1_COD)
			nConV++

            DBSELECTAREA("SA1")
            RECLOCK("SA1",.F.)
             SA1->A1_VEND := MV_PAR03
            MSUNLOCK("SA1")

           DBSELECTAREA("SA1")
           DBSKIP()
        END
		SET FILTER TO
		
		MsgInfo("Foram alterado(s) "+Alltrim(str(nconv))+" Cliente(s).")
	Endif
ELSEIF nTipo == 4
	If Pergunte("MANUTV004",.T.)	

        ProcRegua(500)
        nConV := 0

        DBSELECTAREA("SA1")
        SET FILTER TO A1_EST == MV_PAR01
        DbGotop()
        
        WHILE !EOF()
        	IncProc("Processando Cliente: " + SA1->A1_COD)
			nConV++

            DBSELECTAREA("SA1")
            RECLOCK("SA1",.F.)
             SA1->A1_VEND := MV_PAR02
            MSUNLOCK("SA1")

           DBSELECTAREA("SA1")
           DBSKIP()
        END
		SET FILTER TO
		
		MsgInfo("Foram alterado(s) "+Alltrim(str(nconv))+" Cliente(s).")
	Endif
ELSEIF nTipo == 5
	If Pergunte("MANUTV005",.T.)	

        ProcRegua(500)
        nConV := 0

        DBSELECTAREA("SUS")
        SET FILTER TO US_EST == MV_PAR01 .AND. US_STATUS <> '6' .AND. US_VEND <> ''
        DbGotop()
        
        WHILE !EOF()
        	IncProc("Processando Prospect: " + SUS->US_COD)
			nConV++

            DBSELECTAREA("SUS")
            RECLOCK("SUS",.F.)
             SUS->US_VEND := MV_PAR02
            MSUNLOCK("SUS")

           DBSELECTAREA("SUS")
           DBSKIP()
        END
		SET FILTER TO
		
		MsgInfo("Foram alterado(s) "+Alltrim(str(nconv))+" Prospect(s).")
	Endif
Endif
Return     

// AJUSTA OS PEDIDOS DE VENDAS EM ABERTO
Static Function fAjusPed()
ProcRegua(500)

DbSelectArea("SC5")
SET FILTER TO ALLTRIM(C5_NOTA) == '' .AND. C5_CLIENTE == MV_PAR01
DbGotop()
nCont := 0
While !Eof()
	IncProc("Processando pedido: "+SC5->C5_NUM)
	nCont++
	Reclock("SC5",.F.)
		SC5->C5_VEND1 := MV_PAR02
	MsUnlock()
	
	DbSelectArea("SC5")
	Dbskip()
End
SET FILTER TO
			
MsgInfo("Foram alterado(s) "+Alltrim(str(ncont))+" pedido(s).")

Return

Static Function AtodosV()
DbSelectArea("SC5")
SET FILTER TO ALLTRIM(C5_NOTA) == '' .AND. C5_VEND1 == MV_PAR01
DbGotop()
ProcRegua(500)
ncont:=0

While !Eof()

	IncProc("Processando pedido:"+SC5->C5_NUM)
	nCont++
	Reclock("SC5",.F.)
		SC5->C5_VEND1 := MV_PAR02
	MsUnlock()

	DbSelectArea("SC5")
	Dbskip()
End

SET FILTER TO

MsgInfo("Foram alterado(s) "+Alltrim(str(ncont))+" pedido(s).")

Return

Static Function AjustaSX1()
//EXEMPLO COMPLETO
//Local aHelpPor	:= {}
//Aadd( aHelpPor, "Digite aqui a data para processamento  "  )
//Aadd( aHelpPor, 'das Notas Fiscais de Entrada. Todas as '  )
//Aadd( aHelpPor, 'NF com essa emissao sera Processada.    ' )
//PutSx1( "FIN150", "35","Quanto a Taxa?","¿Cuanto a tasa?","How about rate?","mv_cht","N",1,0,1,"C","","","","",;
//			"mv_par35","Taxa Contratada","Tasa contratada","Hired Rate","","Taxa Normal","Tasa Normal","Normal Rate","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
//       (cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3, cGrpSxg,cPyme,;
//	     cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)

//PutSx1( cPerg, "01","Da Data ?","¿Cuanto a tasa?","How about rate?","mv_cha","D",08,0,1,"G","","","","",;
//			"mv_par01","","","","","","","","","","","","","","","","",,,)
cPerg:="MANUTV001"
PutSx1( cPerg, "01","Cliente       ?","¿Cuanto a tasa?","How about rate?","mv_cha","C",06,0,1,"G","","CLI","","","mv_par01","","","","","","","","","","","","","","","","",,,)
PutSx1( cPerg, "02","Novo Vendedor ?","¿Cuanto a tasa?","How about rate?","mv_chb","C",06,0,1,"G","","SA3","","","mv_par02","","","","","","","","","","","","","","","","",,,)
			
cPerg:="MANUTV002"
PutSx1( cPerg, "01","Vendedor Atual ?","¿Cuanto a tasa?","How about rate?","mv_cha","C",06,0,1,"G","","SA3","","","mv_par01","","","","","","","","","","","","","","","","",,,)
PutSx1( cPerg, "02","Novo Vendedor  ?","¿Cuanto a tasa?","How about rate?","mv_chb","C",06,0,1,"G","","SA3","","","mv_par02","","","","","","","","","","","","","","","","",,,)			

Return