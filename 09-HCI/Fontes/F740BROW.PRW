#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH" 
#INCLUDE "Rwmake.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT1120BRW บAutor  ณROBSON BUENO        บ Data ณ  24/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPONTO DE ENTRADA PARA IMPRESSAO E ENVIO DE FOLLOW P/ DILIG  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F740BROW()             
  Local aHRot01:={}
  
  
  aHRot01 :=	{	{ "Div.Titulo" ,"U_HFIN001(3)", 0 , 3},; 
					{ "Aj.Impostos","U_HFIN001(4)", 0 , 4},;
					{ "Incl.Impostos","U_HFIN001(5)", 0 , 5}}
				
  
  
  
  aAdd(aRotina, {"HCI"	,ahRot01 , 0 , 6})			
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTC450R01  บAutor  ณROBSON BUENO        บ Data ณ  24/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTRATAMENTO PARA ROTINA DE LIQUIDACAO EM MASSA               บฑฑ
ฑฑบ          ณInclui Botoes Socios e Documentos no menu da rotina         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HFIN001(nOpc,cAlias,nReg)

Local lRet		:= .T.
Local oDlgL
STATIC cNum:=Space(6)
STATIC cCliente:=Space(6)
STATIC cLoja:=Space(2)
STATIC cNomecli:=Space(50)
STATIC dEmissao:=ctod("  /  /  ")
STATIC dVencto :=ctod("  /  /  ")
STATIC dReal   :=ctod("  /  /  ") 
STATIC nValor1:=0, nValor2:=0
STATIC nPIS1:=0, nPIS2:=0
STATIC nCOFINS1:=0, nCOFINS2:=0
STATIC nCSLL1:=0, nCSLL2:=0
STATIC nIRRF1:=0, nIRRF2:=0
STATIC nSaldo1:=0,nSaldo2:=0
STATIC nDesconto:=0
STATIC nValdesc:=0
STATIC nDecresc:=0
STATIC cPrefixo:=space(3)
static cTtipo   :=space(3) 
STATIC cMotivo:=Space(60)
STATIC cParcela:=Space(2)
Local cTitulo :="Ajustes de Valores dos Titulos"
Local aAreaAtu	:= GetArea()												// Salva a area atual
DEFINE FONT oBold NAME "MS Sans Serif" SIZE 0, -9 BOLD
IF nOpc=3
   AxAltera(cAlias,nReg,,,,,,)
endif
if nopc=4 
   IF SE1->E1_NUMBCO<>'               '
      Aviso("Atencao","Operacao nao permitida para titulos em BANCO",{"Voltar"},2)
      return
   ENDIF
   IF SE1->E1_TIPO <>'NF'
      Aviso("Atencao","Atividade programada somente para titulos tipo <NF>",{"Voltar"},2)
      return
   ENDIF
   IF SE1->E1_VALOR<>SE1->E1_SALDO
      Aviso("Atencao","Atividade programada somente para titulos Sem registros de Pagamento. Para ajustar por esta rotina e necessario extornar baixa",{"Voltar"},2)
      return
   ENDIF   
   cNum		:=	SE1->E1_NUM
   cCliente	:=	SE1->E1_CLIENTE
   cLoja	:=	SE1->E1_LOJA
   cNomecli	:=	SE1->E1_NOMCLI
   nValor1	:=  SE1->E1_VALOR 
   nValor2	:=  SE1->E1_VALOR
   nIRRF1	:=	SE1->E1_IRRF
   nPIS1	:=  SE1->E1_PIS 
   nCOFINS1	:=	SE1->E1_COFINS
   nCSLL1	:=  SE1->E1_CSLL 
   nIRRF2	:=	SE1->E1_IRRF
   nPIS2	:=  SE1->E1_PIS 
   nCOFINS2	:=	SE1->E1_COFINS
   nCSLL2	:=  SE1->E1_CSLL 
   nDecresc :=  SE1->E1_DECRESC
   cPrefixo :=  SE1->E1_PREFIXO
   cTipo    :=  SE1->E1_TIPO
   cParcela :=  SE1->E1_PARCELA 
   dEmissao	:=	SE1->E1_EMISSAO
   dVencto 	:=	SE1->E1_VENCTO
   dReal   	:=	SE1->E1_VENCREA
   nSaldo1:=nValor1-nIRRF1-nPIS1-nCOFINS1-nCSLL1-nDecresc
   nSaldo2:=nValor2-nIRRF2-nPIS2-nCOFINS2-nCSLL2-nDecresc
   @ 000,000 To 350,500 Dialog Odlg1 Title OemToAnsi("Ajustes de Valores dos Titulos ")
   @ 003,005 To 38,250 Title OemToAnsi("Dados do Titulo") 
   @ 010,010 Say OemToAnsi("Numero:") OF Odlgl PIXEL
   @ 017,010 SAY cNum SIZE 30,10  PICTURE PesqPict('SE1','E1_NUM') FONT oBold COLOR CLR_RED OF Odlgl PIXEL
   @ 010,040 Say OemToAnsi("Cliente:") OF Odlgl PIXEL
   @ 017,040 SAY cCliente SIZE 30,10 PICTURE PesqPict('SE1','E1_CLIENTE') FONT oBold COLOR CLR_RED OF Odlgl PIXEL
   @ 010,065 Say OemToAnsi("Loja:") OF Odlgl PIXEL
   @ 017,065 SAY cLoja SIZE 30,10 PICTURE PesqPict('SE1','E1_LOJA') FONT oBold COLOR CLR_RED OF Odlgl PIXEL
   @ 010,085 Say OemToAnsi("Nome CLiente:") OF Odlgl PIXEL
   @ 017,085 SAY cNomeCli SIZE 50,10 PICTURE PesqPict('SE1','E1_NOMCLI') FONT oBold COLOR CLR_RED OF Odlgl PIXEL
   @ 010,155 Say OemToAnsi("Valor R$:") OF Odlgl PIXEL
   @ 017,140 SAY nValor1 SIZE 60,10  PICTURE PesqPict('SE1','E1_VALOR') FONT oBold COLOR CLR_RED OF Odlgl PIXEL
   
   
   @ 040,005 To 160,250 Title OemToAnsi("Ajuste de Valores")
   @ 065,010 Say OemToAnsi("Valor Titulo:") OF Odlgl PIXEL
   @ 065,050 GET nvalor1  SIZE 60,10  PICTURE "@E 99,999,999.99"  FONT oBold COLOR CLR_RED WHEN .F. OF Odlgl PIXEL 
   @ 080,010 Say OemToAnsi("Valor IRRF..:") OF Odlgl PIXEL
   @ 080,050 GET nirrf1   SIZE 60,10  PICTURE "@E 99,999,999.99"  FONT oBold COLOR CLR_RED WHEN .F. OF Odlgl PIXEL
   @ 095,010 Say OemToAnsi("Valor CSLL..:") OF Odlgl PIXEL
   @ 095,050 GET ncsll1   SIZE 60,10  PICTURE "@E 99,999,999.99"  FONT oBold COLOR CLR_RED WHEN .F. OF Odlgl PIXEL
   @ 110,010 Say OemToAnsi("Valor PIS...:") OF Odlgl PIXEL
   @ 110,050 GET npis1    SIZE 60,10  PICTURE "@E 99,999,999.99"  FONT oBold COLOR CLR_RED WHEN .F. OF Odlgl PIXEL
   @ 125,010 Say OemToAnsi("Valor COFINS:") OF Odlgl PIXEL
   @ 125,050 GET nCofins1 SIZE 60,10  PICTURE "@E 99,999,999.99"  FONT oBold COLOR CLR_RED WHEN .F. OF Odlgl PIXEL
   @ 140,010 Say OemToAnsi("Vl. Liquido.:") OF Odlgl PIXEL
   @ 140,050 GET nsaldo1  SIZE 60,10  PICTURE "@E 99,999,999.99"  FONT oBold COLOR CLR_GREEN WHEN .F. OF Odlgl PIXEL
   
  
   @ 050,130 Say OemToAnsi("Desconto:") OF Odlgl PIXEL
   @ 050,170 GET nDecresc  SIZE 60,10  PICTURE "@E 99,999,999.99" VALID F74CC(.T.) FONT oBold COLOR CLR_BLUE WHEN .T.  OF Odlgl PIXEL    
   @ 065,130 Say OemToAnsi("Valor Titulo:") OF Odlgl PIXEL
   @ 065,170 GET nvalor2  SIZE 60,10  PICTURE "@E 99,999,999.99"  FONT oBold COLOR CLR_BLUE WHEN .F. OF Odlgl PIXEL 
   @ 080,130 Say OemToAnsi("Valor IRRF..:") OF Odlgl PIXEL
   @ 080,170 GET nirrf2   SIZE 60,10  PICTURE "@E 99,999,999.99"  VALID F74CI(.T.) FONT oBold COLOR CLR_BLUE WHEN .T. OF Odlgl PIXEL
   @ 095,130 Say OemToAnsi("Valor CSLL..:") OF Odlgl PIXEL
   @ 095,170 GET ncsll2   SIZE 60,10  PICTURE "@E 99,999,999.99"  VALID F74CI(.T.) FONT oBold COLOR CLR_BLUE WHEN .T. OF Odlgl PIXEL
   @ 110,130 Say OemToAnsi("Valor PIS...:") OF Odlgl PIXEL
   @ 110,170 GET npis2    SIZE 60,10  PICTURE "@E 99,999,999.99"  VALID F74CI(.T.) FONT oBold COLOR CLR_BLUE WHEN .T. OF Odlgl PIXEL
   @ 125,130 Say OemToAnsi("Valor COFINS:") OF Odlgl PIXEL
   @ 125,170 GET nCofins2 SIZE 60,10  PICTURE "@E 99,999,999.99"  VALID F74CI(.T.) FONT oBold COLOR CLR_BLUE WHEN .T. OF Odlgl PIXEL
   @ 140,130 Say OemToAnsi("Vl. Liquido.:") OF Odlgl PIXEL
   @ 140,170 GET nsaldo2  SIZE 60,10  PICTURE "@E 99,999,999.99"  FONT oBold COLOR CLR_GREEN WHEN .F. OF Odlgl PIXEL        
   @ 162,005 BMPBUTTON TYPE 1 ACTION 	Processa({|| OkProc()},cTitulo,"Atualizando dados, aguarde...")
   @ 162,035 BMPBUTTON TYPE 2 ACTION Finaliza(odlg1)
   Activate Dialog Odlg1 CENTER
ENDIF 
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFinaliza  บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinalizacao do Objeto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function OkProc()
Local lRet		:= .T.
Local aArea     := GetArea()
Local _cTitPai	:= ""
// ETAPA 1 - TITULO PRINCIPAL
dbSelectArea("SE1")
dbSetOrder(1)
If MsSeek(xFilial("SE1")+cPrefixo+cNum+cParcela+'NF ')
  RecLock("SE1",.F.)
  SE1->E1_IRRF   :=ROUND(nIRRF2,2)
  SE1->E1_PIS    :=ROUND(nPIS2,2)
  SE1->E1_COFINS :=ROUND(nCOFINS2,2)
  SE1->E1_CSLL   :=ROUND(nCSLL2,2)
  SE1->E1_DECRESC:=nDECRESC
  SE1->E1_BASEPIS:=SE1->E1_VALOR-NdECRESC
  SE1->E1_BASECOF:=SE1->E1_VALOR-NdECRESC
  SE1->E1_BASECSL:=SE1->E1_VALOR-NdECRESC
  MsUnlock()
  _cTitPai	:= SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO + SE1->E1_CLIENTE + SE1->E1_LOJA//SE1->E1_TITPAI
ELSE
  Aviso("Atencao","Registro do Titulo Principal nแo encontrado na base de dados",{"Voltar"},2)
  lRET:=.F.
ENDIF  
// ETAPA 2 - IR-
dbSelectArea("SE1")
dbSetOrder(1)
If MsSeek(xFilial("SE1")+cPrefixo+cNum+cParcela+'IR-') .AND. LRET=.T.
  RecLock("SE1",.F.)
  SE1->E1_VALOR  :=ROUND(nIRRF2,2)
  SE1->E1_SALDO  :=ROUND(nIRRF2,2)
  SE1->E1_VLCRUZ :=ROUND(nIRRF2,2)
  If !Empty(_cTitPai)
  	SE1->E1_TITPAI	:= _cTitPai
  EndIf
  MsUnlock()
ELSE
  RecLock("SE1",.T.)
  SE1->E1_NUM		:=cNum		
  SE1->E1_CLIENTE   :=cCliente
  SE1->E1_LOJA		:=cLoja	
  SE1->E1_VALOR  	:=ROUND(nIRRF2,2)
  SE1->E1_SALDO  	:=ROUND(nIRRF2,2)
  SE1->E1_VLCRUZ 	:=ROUND(nIRRF2,2)
  SE1->E1_NOMCLI 	:= cNomecli
  SE1->E1_DECRESC   := nDecresc 
  SE1->E1_PREFIXO   := cPrefixo   
  SE1->E1_TIPO      :="IR-"
  SE1->E1_PARCELA	:=cParcela
  SE1->E1_NATUREZ	:="2216"
  SE1->E1_EMISSAO   :=dEmissao
  SE1->E1_VENCTO    :=dVencto	
  SE1->E1_VENCREA   :=dReal
  If !Empty(_cTitPai)
  	SE1->E1_TITPAI	:= _cTitPai
  EndIf
  MsUnlock()
ENDIF

// ETAPA 3 - PI-
dbSelectArea("SE1")
dbSetOrder(1)
If MsSeek(xFilial("SE1")+cPrefixo+cNum+cParcela+'PI-') .AND. LRET=.T.
  RecLock("SE1",.F.)
  SE1->E1_VALOR  :=ROUND(nPIS2,2)
  SE1->E1_SALDO  :=ROUND(nPIS2,2)
  SE1->E1_VLCRUZ :=ROUND(nPIS2,2)
  If !Empty(_cTitPai)
  	SE1->E1_TITPAI	:= _cTitPai
  EndIf
  MsUnlock()
ELSE
  RecLock("SE1",.T.)
  SE1->E1_NUM		:=cNum		
  SE1->E1_CLIENTE   :=cCliente
  SE1->E1_LOJA		:=cLoja	
  SE1->E1_VALOR  :=ROUND(nPIS2,2)
  SE1->E1_SALDO  :=ROUND(nPIS2,2)
  SE1->E1_VLCRUZ :=ROUND(nPIS2,2)
  SE1->E1_NOMCLI 	:= cNomecli
  SE1->E1_DECRESC   := nDecresc 
  SE1->E1_PREFIXO   := cPrefixo   
  SE1->E1_TIPO      :="PI-"
  SE1->E1_PARCELA	:=cParcela
  SE1->E1_NATUREZ	:="2205"
  SE1->E1_EMISSAO   :=dEmissao
  SE1->E1_VENCTO    :=dVencto	
  SE1->E1_VENCREA   :=dReal
  If !Empty(_cTitPai)
  	SE1->E1_TITPAI	:= _cTitPai
  EndIf
  MsUnlock()
ENDIF
// ETAPA 4 - CF-
dbSelectArea("SE1")
dbSetOrder(1)
If MsSeek(xFilial("SE1")+cPrefixo+cNum+cParcela+'CF-') .AND. LRET=.T.
  RecLock("SE1",.F.)
  SE1->E1_VALOR  :=ROUND(nCOFINS2,2)
  SE1->E1_SALDO  :=ROUND(nCOFINS2,2)
  SE1->E1_VLCRUZ :=ROUND(nCOFINS2,2)
  If !Empty(_cTitPai)
  	SE1->E1_TITPAI	:= _cTitPai
  EndIf
  MsUnlock()
ELSE
  RecLock("SE1",.T.)
  SE1->E1_NUM		:=cNum		
  SE1->E1_CLIENTE   :=cCliente
  SE1->E1_LOJA		:=cLoja	
  SE1->E1_VALOR  :=ROUND(nCOFINS2,2)
  SE1->E1_SALDO  :=ROUND(nCOFINS2,2)
  SE1->E1_VLCRUZ :=ROUND(nCOFINS2,2)
  SE1->E1_NOMCLI 	:= cNomecli
  SE1->E1_DECRESC   := nDecresc 
  SE1->E1_PREFIXO   := cPrefixo   
  SE1->E1_TIPO      :="CF-"
  SE1->E1_PARCELA	:=cParcela
  SE1->E1_NATUREZ	:="2208"
  SE1->E1_EMISSAO   :=dEmissao
  SE1->E1_VENCTO    :=dVencto	
  SE1->E1_VENCREA   :=dReal
  If !Empty(_cTitPai)
  	SE1->E1_TITPAI	:= _cTitPai
  EndIf
  MsUnlock()
ENDIF
// ETAPA 5 - CS-
dbSelectArea("SE1")
dbSetOrder(1)
If MsSeek(xFilial("SE1")+cPrefixo+cNum+cParcela+'CS-') .AND. LRET=.T.
  RecLock("SE1",.F.)
  SE1->E1_VALOR  :=ROUND(nCSLL2,2)
  SE1->E1_SALDO  :=ROUND(nCSLL2,2)
  SE1->E1_VLCRUZ :=ROUND(nCSLL2,2)
  If !Empty(_cTitPai)
  	SE1->E1_TITPAI	:= _cTitPai
  EndIf
  MsUnlock()
ELSE
  RecLock("SE1",.T.)
  SE1->E1_NUM		:=cNum		
  SE1->E1_CLIENTE   :=cCliente
  SE1->E1_LOJA		:=cLoja	
  SE1->E1_VALOR  :=ROUND(nCSLL2,2)
  SE1->E1_SALDO  :=ROUND(nCSLL2,2)
  SE1->E1_VLCRUZ :=ROUND(nCSLL2,2)
  SE1->E1_NOMCLI 	:= cNomecli
  SE1->E1_DECRESC   := nDecresc 
  SE1->E1_PREFIXO   := cPrefixo   
  SE1->E1_TIPO      :="CS-"
  SE1->E1_PARCELA	:=cParcela
  SE1->E1_NATUREZ	:="2214"
  SE1->E1_EMISSAO   :=dEmissao
  SE1->E1_VENCTO    :=dVencto	
  SE1->E1_VENCREA   :=dReal
  If !Empty(_cTitPai)
  	SE1->E1_TITPAI	:= _cTitPai
  EndIf
  MsUnlock()
ENDIF
IF lRET:=.T.
  Aviso("Operacao Concluida","Registros alterados com sucesso",{"Voltar"},2)
ENDIF  

Close(Odlg1)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFinaliza  บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinalizacao do Objeto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Finaliza()
 Close(Odlg1)
Return .T.
                 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFinaliza  บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinalizacao do Objeto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC Function F74CC()
   Local nFator
   nIRRF2:=		round((nValor2-nDecresc)*0.012,2)
   nPIS2:=     	round((nValor2-nDecresc)*0.0065,2) 
   nCOFINS2:=	round((nValor2-nDecresc)*0.03,2)
   nCSLL2:=     round((nValor2-nDecresc)*0.01,2) 
   nSaldo1:=nValor1-nIRRF1-nPIS1-nCOFINS1-nCSLL1-nDecresc
   nSaldo2:=nValor2-nDecresc-nIRRF2-nPIS2-nCOFINS2-nCSLL2
   odlg1:refresh()
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFinaliza  บAutor  ณRobson Bueno        บ Data ณ 18/04/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinalizacao do Objeto                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณHCI                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC Function F74CI()
   nSaldo2:=nValor2-nDecresc-nIRRF2-nPIS2-nCOFINS2-nCSLL2
   odlg1:refresh()
Return .T.
