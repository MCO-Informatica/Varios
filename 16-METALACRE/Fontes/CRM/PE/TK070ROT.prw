#INCLUDE "rwmake.ch" 
#INCLUDE 'PROTHEUS.CH' 
/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ 
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ 
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ 
ฑฑบPrograma  ณ TK070ROT บAutor ณ Luiz Alberto         บ Data ณ 05/04/17   บฑฑ 
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ 
ฑฑบDesc.     ณ                                                            บฑฑ 
ฑฑบ          ณ                                                            บฑฑ 
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ 
ฑฑบUso       ณ AP                                                        บฑฑ 
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ 
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ 
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
*/ 
User Function TK070ROT() 
Local aArea := GetArea()
Local aOpcao := {}

     AADD(aOpcao, {"Replica Contato","U_RPLCONT",0,6}) 

RestArea(aArea)
Return(aOpcao) 



User Function RplCont()
Local aArea := GetArea()
Local cPerg := PadR("RPLCONT",10)

ValidPerg(cPerg)

If !Pergunte(cPerg)
	RestArea(aArea)
	Return .t.
Endif

If !MsgYesNo("Confirma a Replica do Contato " + SU5->U5_CODCONT + " - " + Capital(SU5->U5_CONTAT) + " Para o(s) Cliente(s) " + MV_PAR01 + "/" + MV_PAR02 + " Ate " + MV_PAR03+"/"+MV_PAR04+" ? ")	
	RestArea(aArea)
	Return .t.
Endif

Processa( {|| fReplCnt()   },"Replicando Contato..." )

RestArea(aArea)
Return .t.

Static Function fReplCnt()
Local aArea := GetArea()
Local lOk := .f.
If SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+MV_PAR01+MV_PAR02))
	ProcRegua(0)
	While SA1->(!Eof()) .And. SA1->A1_FILIAL == xFilial("SA1") .And. SA1->A1_COD+SA1->A1_LOJA <= MV_PAR03+MV_PAR04
		IncProc("Processando Cliente " + SA1->A1_COD+"/"+SA1->A1_LOJA+", Aguarde...")
	
		lOk := .t.
		
		If !AC8->(dbSetOrder(1), dbSeek(xFilial("AC8")+SU5->U5_CODCONT+'SA1'+xFilial("AC8")+SA1->A1_COD+SA1->A1_LOJA))
			If RecLock("AC8",.t.)
				AC8->AC8_FILIAL :=	xFilial("AC8")
				AC8->AC8_ENTIDA	:=	"SA1"
				AC8->AC8_CODENT	:=	SA1->A1_COD+SA1->A1_LOJA
				AC8->AC8_CODCON	:=	SU5->U5_CODCONT
				AC8->(MsUnlock())
			Endif
		Endif
				
		SA1->(dbSkip(1))
	Enddo
Endif

If lOk
	MsgInfo("Processamento Efetuado com Sucesso !")
Endif

RestArea(aArea)
Return .t.		
		
		



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณValidPerg บ Autor ณ AP6 IDE            บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica os parametro cadastrados. Se nao existir, cria-os.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg(cPerg)

PutSx1( cPerg   ,"01","De Cliente"             ,"","","mv_ch1","C",6,0,0,"G","","SA1","","","MV_PAR01","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg   ,"02","De Loja"		           ,"","","mv_ch2","C",2,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg   ,"03","Ate Cliente"            ,"","","mv_ch3","C",6,0,0,"G","","SA1","","","MV_PAR03","","","","","","","","","","","","","","","","",{},{},{})
PutSx1( cPerg   ,"04","Ate Loja"		       ,"","","mv_ch4","C",2,0,0,"G","","","","","MV_PAR04","","","","","","","","","","","","","","","","",{},{},{})

Return Nil
