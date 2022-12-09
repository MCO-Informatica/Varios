#include "PROTHEUS.CH"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXTOLEDO   บAutor  ณMicrosiga           บ Data ณ  13/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function XToledo(lTela)
//Local aArea     := GetArea()

Local cPerg 	:= "XTOLEDO001"		// Nome do grupo de perguntas
Local aPerg 	:= {}			// Array do grupo de perguntas
Local cSettings	:= ""			// Parametro da funcao FOpenPort 
Local cChar 	:= ""			// Variavel Buffer
Local nH       	 				// Variavel Handle 
Local nbytes 	:= 0
Local nPeso 	:= 0
Local cPeso 	:= ""
Local cConteudo := ""  

Default lTela := .T.               


/* Parametros conforme testes na balanca de Embu.
MV_PAR01	( Porta   := "COM1" )
MV_PAR02	( BaudRate:= "4800" )
MV_PAR03	( Parity  := "2"  0=NoParity,1=OddParity,2=EvenParity,3=MarkParity,4=SpaceParity )
MV_PAR04 	( Data    := "7" )
MV_PAR05	( Stop    := "0" 0=OneStopBit,1=One5StopBits,2=TwoStopBits )
MV_PAR06 	( TimeOut := "00500" )
MV_PAR07	( Divisor := "1" )
*/

PutSX1(cPerg,"01","Porta"		,"","","mv_ch1","C",4,0,0,"G","","MV_PAR01","","","","COM1","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","BaudRate"	,"","","mv_ch2","C",4,0,0,"G","","MV_PAR02","","","","4800","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Parity"		,"","","mv_ch3","C",1,0,0,"G","","MV_PAR03","","","","2"   ,"","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"04","Data"		,"","","mv_ch4","C",1,0,0,"G","","MV_PAR04","","","","7"   ,"","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"05","Stop"		,"","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","0"   ,"","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"06","TimeOut"	,"","","mv_ch6","C",5,0,0,"G","","MV_PAR06","","","","00500","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"07","Divisor"	,"","","mv_ch7","N",3,0,0,"G","","MV_PAR07","","","","1"   ,"","","","","","","","","","","","","","","","","","","","","","","","")                     

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria variaveis de parametros                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//pergunte(cPerg,lTela)

// cSettings := cBaudRate+','+cParity+','+cData+','+cStop+','+cTimeOut 
//cSettings:= MV_PAR02+','+MV_PAR03+','+MV_PAR04+','+MV_PAR05+','+MV_PAR06
cSettings:= '4800,2,7,2,00900'                                                                                                                   
cPorta := "COM1" //MV_PAR01
nH := FOpenPort(cPorta,cSettings,2)

If nH < 0      
	cPorta := "COM2"
	nH := FOpenPort(cPorta,cSettings,2)

	If nH < 0      
                   
		cPorta := "COM3"
		nH := FOpenPort(cPorta,cSettings,2)
	
	Else
   
 		 MsgAlert("ERRO DE COMUNICAO ENTRE PROTHEUS E BALANCA - NAO ABRIU A PORTA "+cPorta)
 		fclose(nH)   
		return(0)
   EndIf
EndIf

While cChar <> chr(2)
   nbytes:= fread(nH,@cChar,1)
   Sleep(100)
   ProcessMessage()   
Enddo

nbytes:= fread(nH,@cConteudo,80)

// Calculo para considerar as casas decimais da balanca de acordo com o MV_PAR07
cPeso := Alltrim(Substr(cConteudo,5,4))
cPeso += Substr(cConteudo,9,1)
nPeso := Val(cPeso) / 1

  
If nPeso <= 0
	MsgStop("Problemas na integra็ใo com a balan็a. O peso ้ nulo (Zero).","Balan็a")
	nPeso := 0

Else
	If lTela
		MsgAlert(Str(nPeso))
	EndIf	
EndIf
            
CBClosePort(nH)
//RestArea(aArea)

Return(nPeso)     