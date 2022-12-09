#INCLUDE "protheus.ch"
#INCLUDE "colors.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณB2FBLQMV  บ Autor ณ                    บ Data ณ  08/12/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณINFORMA DATA PARA TRAVAR O MOVIMENTIO FISCAL                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function B2FBLQMV()

If cEmpAnt = '01'

	Private oFis                                                    
	Private cFimLin := (chr(13)+chr(10))
	Private dDTFIS  := getmv("MV_DATAFIS")
	Private oDTFIS
	Private dDTFIN  := getmv("MV_DATAFIN")
	Private oDTFIN                       
	Private dDTMOV  := getmv("MV_DBLQMOV")
	Private oDTMOV                       
	Private cTPVLR	:= getmv("MV_TPVALOR")
	Private oTPVLR	
	Private cMsg1 := "Aten็ใo, nใo serแ possํvel efetuar movimenta็๕es"
	pRIVATE cMsg2 := "anteriores das datas informadas!!!"
	pRIVATE cMsg3 := "S - Sinal / P - Parenteses / D - Debito;Cr้dito"
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declaracao de Variaveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oFis from 000,000 to 200,300 title "Ultimos Fechamentos" pixel
	@ 005,005 Say OemToAnsi("Fiscal") PIXEL COLORS CLR_HBLUE OF oFis 
	@ 005,050 MsGet oDTFIS VAR dDTFIS SIZE 40,08  PIXEL OF oFis Valid !empty(dDTFIS)
	
	@ 020,005 Say OemToAnsi("Financeiro") PIXEL COLORS CLR_HBLUE OF oFis 
	@ 020,050 MsGet oDTFIN VAR dDTFIN SIZE 40,08  PIXEL OF oFis Valid !empty(dDTFIN)
	
	//@ 035,005 Say OemToAnsi("Movimento") PIXEL COLORS CLR_HBLUE OF oFis 
	//@ 035,050 MsGet oDTMOV VAR dDTMOV SIZE 40,08  PIXEL OF oFis Valid !empty(dDTMOV)
	
	@ 050,005 Say OemToAnsi("Ctb SPD") PIXEL COLORS CLR_HBLUE OF oFis 
	@ 050,050 MsGet oTPVLR VAR cTPVLR SIZE 40,08  PIXEL OF oFis Valid (!empty(cTPVLR) .and. Pertence("SPD") )
	
	@ 005,100 BUTTON "Confirma" OF oFIS SIZE 030,015 PIXEL ACTION FisOK(.t.,dDTFIS,dDTFIN,dDTMOV,cTPVLR)
	@ 020,100 BUTTON "Cancela"  OF oFIS SIZE 030,015 PIXEL ACTION FisOk(.f.)
	
	@ 065,005 Say OemToAnsi(cMsg1) PIXEL COLORS CLR_HRED OF oFis                                                  
	@ 075,005 Say OemToAnsi(cMsg2) PIXEL COLORS CLR_HRED OF oFis                                                  
	@ 085,005 Say OemToAnsi(cMsg3) PIXEL COLORS CLR_HRED OF oFis                                                  
	
	ACTIVATE MSDIALOG oFis CENTER

	
Else
	Alert("Rotina s๓ pode ser executada na empresa 01!!!")
EndIf

Return(.T.)


static function FisOk(lPar,dParFIS,dParFIN,dParMOV,cParCtb)

if lPar
	if MsgYESNO("Confirma atualizacao de datas de fechamento?","Atencao...","YESNO")
		putmv("MV_DATAFIS",dParFis)
		putmv("MV_DATAFIN",dParFin)
//		putmv("MV_DBLQMOV",dParMov)
		putmv("MV_TPVALOR",UPPER(cParCtb))
		
	MsgInfo("Fechamento Fiscal     :"+dtoc(dParFIS)+chr(13)+chr(10)+;
	        "Fechamento Financeiro :"+dtoc(dParFIN)+chr(13)+chr(10)+;
	        "Sinal no Balancete    :"+cParCtb)
	endif
endif 

oFis:end()

return
