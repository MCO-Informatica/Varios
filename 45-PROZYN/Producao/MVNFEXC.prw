#INCLUDE "protheus.ch"
#INCLUDE "colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPZNSPEDEXC  บ Autor ณ                    บ Data ณ  08/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณINFORMA DATA PARA LIMITE DE EXCLUSAO DE NFE                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MVNFEXC()

If cEmpAnt = '01'

	Private oFis                                                    
	Private cFimLin := (chr(13)+chr(10))
	Private nSPDEXC  := getmv("MV_SPEDEXC")
	Private oSPDEXC
	Private cMsg1 := "Aten็ใo, nใo serแ possํvel efetuar Exclusใo"
	pRIVATE cMsg2 := " de NFE fora do prazo de horas informado!"

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oFis from 000,000 to 200,300 title "Periodo Exclusao de NF" pixel
	@ 005,005 Say OemToAnsi("Hr Exc. NF") PIXEL COLORS CLR_HBLUE OF oFis 
	@ 005,050 MsGet oSPDEXC VAR nSPDEXC PICTURE "@E 999" SIZE 40,08  PIXEL OF oFis Valid !empty(nSPDEXC)
	
	//@ 020,005 Say OemToAnsi("Financeiro") PIXEL COLORS CLR_HBLUE OF oFis 
	//@ 020,050 MsGet oDTFIN VAR dDTFIN SIZE 40,08  PIXEL OF oFis Valid !empty(dDTFIN)
	
	//@ 035,005 Say OemToAnsi("Movimento") PIXEL COLORS CLR_HBLUE OF oFis 
	//@ 035,050 MsGet oDTMOV VAR dDTMOV SIZE 40,08  PIXEL OF oFis Valid !empty(dDTMOV)
	
	//@ 050,005 Say OemToAnsi("Ctb SPD") PIXEL COLORS CLR_HBLUE OF oFis 
	//@ 050,050 MsGet oTPVLR VAR cTPVLR SIZE 40,08  PIXEL OF oFis Valid (!empty(cTPVLR) .and. Pertence("SPD") )
	
	@ 005,100 BUTTON "Confirma" OF oFIS SIZE 030,015 PIXEL ACTION FisOK(.t.,nSPDEXC)
	@ 020,100 BUTTON "Cancela"  OF oFIS SIZE 030,015 PIXEL ACTION FisOk(.f.)
	
	@ 065,005 Say OemToAnsi(cMsg1) PIXEL COLORS CLR_HRED OF oFis                                                  
	@ 075,005 Say OemToAnsi(cMsg2) PIXEL COLORS CLR_HRED OF oFis                                                  
	                                                 
	
	ACTIVATE MSDIALOG oFis CENTER

	
Else
	Alert("Rotina s๓ pode ser executada na empresa 01!!!")
EndIf

Return(.T.)


static function FisOk(lPar,nSPDEXC)

if lPar
	if MsgYESNO("Confirma atualizacao de Horas para Exclusao de NF?","Atencao...","YESNO")
		putmv("MV_SPEDEXC",nSPDEXC)
	endif
endif 

oFis:end()

return
