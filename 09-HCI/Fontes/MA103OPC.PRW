#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA103OPC  ºAutor  ³ROBSON BUENO        º Data ³  07/20/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para ajustes de dados da nf de entrada     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA103OPC()             

Return({{"Ajustes NF"	,"U_MA103AJN()" , 0 , 3}})


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA030RO1  ºAutor  ³Robson Bueno        º Data ³  07/20/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de Manutencao de Dados                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA103AJN()

Local oDlgl
Local oNumdi
Local oDatdi
Local oTransp
Local oTpfrete
Local oPlaca
Local oUfplaca
LOCAL oVolume
Local oEmbalag
Local oMarca
Local oNumvol
Local oPesob
Local oPesol
Local oObsnota
Local oOrigem
Local oDlgl

PRIVATE cTransp :=SF1->F1_TRANSP
PRIVATE cTpfrete:=SF1->F1_TPFRETE
PRIVATE cPlaca  :=SF1->F1_PLACA
PRIVATE cUfplaca:=SF1->F1_UFPLAC
PRIVATE nVolume :=SF1->F1_VOLUME
PRIVATE cEmbalag:=SF1->F1_EMBALAG
PRIVATE cMarca  :=SF1->F1_MARCA
PRIVATE cNumvol :=SF1->F1_NUMVOL
PRIVATE nPesob  :=SF1->F1_PESOB 
PRIVATE nPesol  :=SF1->F1_PESOL
PRIVATE nNumdi  :=SF1->F1_NUMDI 
PRIVATE dDatdi  :=SF1->F1_DATDI 
PRIVATE cObsnota:=SF1->F1_OBSNOTA
PRIVATE cOrigem :=SF1->F1_FORNORI
PRIVATE cTe		:="301"
//Local cNfCli := Space(06) 
		
@ 000,000 To 400,400 Dialog Odlg1 Title OemToAnsi("Ajustes permitidos da NF")
@ 003,004 To 25,200 Title OemToAnsi("Dados Da Importacao") 
@ 010,015 Say OemToAnsi("Numero da DI") OF Odlgl PIXEL
//@ 035,015 GET cTpAverb SIZE 30,10 F3 "12" 
@ 010,055 msGET nNumdi SIZE 45,10 PICTURE PesqPict("SF1","F1_NUMDI")OF Odlgl PIXEL
@ 010,115 Say OemToAnsi("Data da DI")OF Odlgl PIXEL
//@ 035,015 GET cTpAverb SIZE 30,10 F3 "12" 
@ 010,155 msGET dDatdi SIZE 30,10 PICTURE PesqPict("SF1","F1_DATDI")OF Odlgl PIXEL


@ 027,004 To 120,200 Title OemToAnsi("Dados de Transporte") 
@ 035,015 Say OemToAnsi("Transportadora")OF Odlgl PIXEL
@ 035,055 msGET cTransp SIZE 30,10 F3 "SA4" PICTURE PesqPict("SF1","F1_TRANSP") OF Odlgl PIXEL  
@ 035,115 Say OemToAnsi("Cif/Fob") OF Odlgl PIXEL
@ 035,155 msGET cTpfrete SIZE 30,10 PICTURE PesqPict("SF1","F1_TPFRETE")OF Odlgl PIXEL
@ 047,015 Say OemToAnsi("Placa Veiculo")OF Odlgl PIXEL
@ 047,055 msGET cPlaca SIZE 30,10 PICTURE PesqPict("SF1","F1_PLACA")OF Odlgl PIXEL
@ 047,115 Say OemToAnsi("UF Placa") OF Odlgl PIXEL
@ 047,155 msGET cUfplaca SIZE 30,10 PICTURE PesqPict("SF1","F1_UFPLAC")OF Odlgl PIXEL
@ 059,015 Say OemToAnsi("N. Volumes")OF Odlgl PIXEL
@ 059,055 msGET nVolume SIZE 30,10 PICTURE PesqPict("SF1","F1_VOLUME")OF Odlgl PIXEL
@ 071,015 Say OemToAnsi("Embalagem")OF Odlgl PIXEL
@ 071,055 msGET cEmbalag SIZE 130,10 PICTURE PesqPict("SF1","F1_EMBALAG")OF Odlgl PIXEL
@ 083,015 Say OemToAnsi("Marca do V.")OF Odlgl PIXEL
@ 083,055 msGET cMarca SIZE 30,10 OF Odlgl PIXEL 
@ 083,115 Say OemToAnsi("Romaneio") OF Odlgl PIXEL
@ 083,155 msGET cNumvol SIZE 30,10 PICTURE PesqPict("SF1","F1_NUMVOL") OF Odlgl PIXEL
@ 095,015 Say OemToAnsi("Peso Bruto") OF Odlgl PIXEL
@ 095,055 msGET nPesob SIZE 50,10 PICTURE PesqPict("SF1","F1_PESOB")OF Odlgl PIXEL
@ 107,015 Say OemToAnsi("Peso Liquido")OF Odlgl PIXEL
@ 107,055 msGET nPesol SIZE 50,10 PICTURE PesqPict("SF1","F1_PESOL")OF Odlgl PIXEL

@ 123,004 To 170,200 Title OemToAnsi("Observacoes") 
@ 130,015 msGET cObsnota SIZE 170,10 PICTURE PesqPict("SF1","F1_OBSNOTA")OF Odlgl PIXEL
@ 145,015 msGET cOrigem  SIZE 170,10 PICTURE PesqPict("SF1","F1_FORNORI")OF Odlgl PIXEL
  
@ 180,100 BMPBUTTON TYPE 1 ACTION OkProc(odlg1)
@ 180,150 BMPBUTTON TYPE 2 ACTION FINALIZA(odlg1)

Activate Dialog Odlg1 CENTER

Return(.T.)

Static Function Finaliza(Odlg1)

Close(Odlg1)

RETURN
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OkProc    ºAutor  ³Robson Bueno        º Data ³ 10/08/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Confirmacao do Processo de digitacao dados                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³HCI                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function OkProc(odlg1)
*
Local cAliasSF1 := GetArea()
RecLock("SF1",.F.)
SF1->F1_TRANSP := cTransp 
SF1->F1_TPFRETE:= cTpfrete
SF1->F1_PLACA  := cPlaca
SF1->F1_UFPLAC := cUfplaca
SF1->F1_VOLUME := nVolume 
SF1->F1_EMBALAG:= cEmbalag
SF1->F1_MARCA  := cMarca 
SF1->F1_NUMVOL := cNumvol 
SF1->F1_PESOB  := nPesob
SF1->F1_PESOL  := nPesol  
SF1->F1_NUMDI  := nNumdi 
SF1->F1_DATDI  := dDatdi 
SF1->F1_OBSNOTA:= cObsnota
SF1->F1_FORNORI:= cOrigem
MsUnLock()
*
Close(Odlg1)
RestArea(cAliasSF1)
*
Return

/* 