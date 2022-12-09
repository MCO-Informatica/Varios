/////////////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------------+//
//| PROGRAMA  | PEDIDOV.PRW         | AUTOR | Luiz Alberto     | DATA | 24/01/2011 |//
//+-----------------------------------------------------------------------------------+//
//| DESCRICAO | Impressão de pedido de venda em modo grafico e HTML.                 |//
//|           |                                                                       |//
//+-----------------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                      |//
//+-----------------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                       |//
//+-----------------------------------------------------------------------------------+//
//|          |                      |                                                 |//
//|          |                      |                                                 |//
//+-----------------------------------------------------------------------------------+//
/////////////////////////////////////////////////////////////////////////////////////////
#include "rwmake.ch"
#include "TopConn.ch"    
#include "ap5mail.ch"
#include "colors.ch"
#include "font.ch"

User Function PEDIDOV() 

Private _PedCom
Private nTarget:=0
Private cFOpen :=""
//Private aBotoes1 := {{"VENDEDOR",{|| MATA105()     },OemToAnsi("Solicitações ao Armazém"    )},;
//                     {"GROUP"   ,{|| TMKA070()     },OemToAnsi("Contatos do Cliente.."      )},;
//                     {"CRITICA" ,{|| _mFSAC2ViaNf()},OemToAnsi("2a. Via de Nota Fiscal .."  )}}
     
Private nOpc   := 0
Private bOk    := {||nOpc:=1,_PedCom:End()}
Private bCancel:= {||nOpc:=0,_PedCom:End()} 
Private lCheck1:=.F.
Private lCheck2:=.T.
IF FunName()=="MATA410"       
   Private _cNumPed := SC5->C5_NUM
Else
   Private _cNumPed := Space(6)
Endif   

lEfet:=.T.

aEscolha :={"IMPRESSORA"} //, "EMAIL"
nEscolha :=1
aObs:=aItem:=aCod:=aDesc:=aQtd:=aDentr:=aTarget  :={}
_cObs    :=""
_cCc     :="                                                             "
_cCco    :="                                                             "

cAlias := Alias()
nRec   := RecNo()
nOrder := IndexOrd()
dbSelectArea("SA4")
dbSetOrder(1)
dbSeek(xFilial("SA4")+(SC5->C5_TRANSP))

If SC5->C5_TPFRETE="C"
   _cTpFrete:="CIF"
Else
   _cTpFrete:="FOB"
Endif 
_cTransp:=RTRIM(SC5->C5_TRANSP)+"-"+SA4->A4_NOME
_cEndEntr:=RTRIM(SA1->A1_ENDENT)+"-"+RTRIM(SA1->A1_BAIRROE)+"-"+RTRIM(SA1->A1_MUNE)+"-"+RTRIM(SA1->A1_CEPE)+"-"+RTRIM(SA1->A1_ESTE)
_cCliente:=Space(60)
_cPara   :=Space(50)
_cSolic  :=Space(6)
_cTel  :=Space(55)
_dEmissao:=cTod("  /  /  ")
_cContato:=Space(15)  

Define MsDialog _PedCom Title "Impressão de Pedido de Venda Gráfico" From 127,037 To 232,774 Pixel 
@ 013,006 To 043,357 Title OemToAnsi("  Dados do Pedido ") 
//@ 046,006 To 078,357 Title OemToAnsi("  Anexos")  
//@ 080,006 To 129,182 Title OemToAnsi("  Destinatários")
//@ 080,187 To 129,357 Title OemToAnsi("  Impressão    ") 
//@ 131,006 To 160,357 Title OemToAnsi("  Observações Gerais   ")  
//@ 162,006 To 194,357 Title OemToAnsi("  Endereço de Entrega  ")  
@ 020,010 Say "Pedido:" Color CLR_HBLUE // Size 25,8 
@ 020,040 Get _cNumPed Picture "@!" Valid fValSC5() F3 "SC5" When lEfet
@ 020,097 Say "Contato: " Color CLR_HBLUE //Size 25,8 
@ 020,125 Say _cContato Object oAutor
@ 020,125 Get _cContato Picture "@" Size 150,08
@ 020,195 Say "Telefone:" Color CLR_HBLUE //Size 30,8 
@ 020,220 Say Substr(_cTel,1,20)   Object oProj
@ 020,280 Say "Emissão:" Color CLR_HBLUE //Size 30,8 
@ 020,305 Say dToc(_dEmissao) Object oEmissao
@ 030,010 Say "Cliente: " Color CLR_HBLUE
@ 030,042 Say _cCliente Color CLR_HRED Object oCliente //Size 19,8 
//@ 052,008 ListBox nTarget Items aTarget Size 185,20 Object oTarget
//@ 050,205 Button OemToAnsi("_Anexar...")      Size 36,12 Action FAbreArq()
//@ 060,205 Button OemToAnsi("_Remover..")      Size 36,12 Action FRemovArq()
/*@ 087,008 Say "Para:"
@ 087,028 Get _cPara Picture "@" Size 150,08
@ 097,008 Say "Cc  :"
@ 097,028 Get _cCc   Picture "@" Size 150,08         
@ 107,008 Say "Cco :"
@ 107,028 Get _cCCo  Picture "@" Size 150,08 
@ 088,192 Radio aEscolha VAR nEscolha 
@ 117,008 CHECKBOX "Receber Cópia " VAR lCheck1
@ 117,080 CHECKBOX "Confirmação de Leitura" VAR lCheck2 */
//@ 137,010 Get _cObs  Object oObs  MEMO Size 340,20
//@ 168,010 Get _cEndEntr Object oProd MEMO Size 340,20

//Activate MsDialog _PedCom On Init EnchoiceBar(_PedCom,bOk,bCancel,,aBotoes1) Centered
Activate MsDialog _PedCom On Init EnchoiceBar(_PedCom,bOk,bCancel,,) Centered
If nOpc == 1
     If nEscolha==1 
        RptStatus({||Relato()})
     Else   
        If _cPara <> ' '     
           Processa ({||ImpHtml()}, 'Processando Envio...')                  
        Else  
           Alert("Pedido sem Destinatário !!")
        Endif  
     Endif   
EndIf

DbSelectArea(cAlias)
DbSetOrder(nOrder)
dbGoTo(nRec)

Return

*--------------------------*
Static Function fValSC5()
*--------------------------*
Local lRet:=.F.
Local _cAlias := Alias()
Local _nRec   := RecNo()
Local _nOrder := IndexOrd()

dbSelectArea("SC5")
DbSetOrder(1)
dbSeek(xFilial()+_cNumPed)   
if !Eof()
   lRet:=.T.     
   If SC5->C5_TIPO=="D" .OR. SC5->C5_TIPO=="B"
      DbSelectArea("SA2")
      DbSetOrder(1)
      dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)    
      _cCliente:=SC5->C5_CLIENTE+" "+SC5->C5_LOJACLI+" - "+SA2->A2_NOME
      _dEmissao:=SC5->C5_EMISSAO
      _cPara   :=SA2->A2_EMAIL
      _cContato:=SA2->A2_CONTATO   
      _cTel:=SA2->A2_DDD+" "+SA2->A2_TEL
   Else 
      DbSelectArea("SA1")
      DbSetOrder(1)
      dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)    
      _cCliente:=SC5->C5_CLIENTE+" "+SC5->C5_LOJACLI+" - "+SA1->A1_NOME
      _dEmissao:=SC5->C5_EMISSAO
      _cPara   :=SA1->A1_EMAIL
      _cContato:=SA1->A1_CONTATO   
      _cTel:=SA1->A1_DDD+" "+SA1->A1_TEL
		_cEndEntr:=RTRIM(SA1->A1_ENDENT)+"-"+RTRIM(SA1->A1_BAIRROE)+"-"+RTRIM(SA1->A1_MUNE)+"-"+RTRIM(SA1->A1_CEPE)+"-"+RTRIM(SA1->A1_ESTE)
   Endif   
Endif
//ObjectMethod(oAutor  , "SetText(_cContato)")
ObjectMethod(oProj   , "SetText(_cTel)")
ObjectMethod(oEmissao, "SetText(_dEmissao)")
ObjectMethod(oCliente, "SetText(_cCliente)")

DbSelectArea(_cAlias)
DbSetOrder(_nOrder)
dbGoTo(_nRec)
Return lRet

*--------------------------*
Static Function FAbreArq()
*--------------------------*
cFOpen := cGetFile("Todos os Arquivos|*.*|Arquivos DOC|*.DOC",OemToAnsi("Abrir Arquivo..."),)
If !Empty(cFOpen)
    aAdd(aTarget,cFOpen)
    ObjectMethod(oTarget,"SetItems(aTarget)")
Endif

Return (cFoPen)

*--------------------------*
Static Function FRemovArq()
*--------------------------*
If nTarget != 0
      nNewTam := Len(aTarget) - 1
      aTarget := aSize(aDel(aTarget,nTarget), nNewTam)
      ObjectMethod(oTarget,"SetItems(aTarget)")
Endif
Return

*------------------------*
Static Function Relato()
*------------------------*
Local nReem
Local nOrder
Local cCondBus
Local nSavRec
Local aSavRec := {}
Private lEnc    := .f.
Private cTitulo
Private oFont, cCode, oPrn
Private cCGCPict, cCepPict    
Private lPrimPag :=.t.
Private  nPag  := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCepPict:=PesqPict("SA1","A1_CEP")
cCGCPict:=PesqPict("SA1","A1_CGC")

oFont1 := TFont():New( "Arial",,16,,.t.,,,,,.f. )
oFont2 := TFont():New( "Arial",,16,,.f.,,,,,.f. )
oFont3 := TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont4 := TFont():New( "Arial",,10,,.f.,,,,,.f. )
oFont5 := TFont():New( "Arial",,08,,.t.,,,,,.f. )  
oFont6 := TFont():New( "Arial",,08,,.f.,,,,,.f. )
oFont7 := TFont():New( "Arial",,14,,.t.,,,,,.f. )  
oFont8 := TFont():New( "Arial",,14,,.f.,,,,,.f. )
oFont9 := TFont():New( "Arial",,12,,.t.,,,,,.f. )  
oFont10:= TFont():New( "Arial",,12,,.f.,,,,,.f. ) 
oFont11:= TFont():New( "Arial",,07,,.t.,,,,,.f. )  
oFont12:= TFont():New( "Arial",,07,,.f.,,,,,.f. )

oFont1c := TFont():New( "Courier New",,16,,.t.,,,,,.f. )
oFont2c := TFont():New( "Courier New",,16,,.f.,,,,,.f. )
oFont3c := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
oFont4c := TFont():New( "Courier New",,10,,.f.,,,,,.f. )
oFont5c := TFont():New( "Courier New",,09,,.t.,,,,,.f. )  
oFont6c := TFont():New( "Courier New",,09,,.T.,,,,,.f. )
oFont7c := TFont():New( "Courier New",,14,,.t.,,,,,.f. )  
oFont8c := TFont():New( "Courier New",,14,,.f.,,,,,.f. )
oFont9c := TFont():New( "Courier New",,12,,.t.,,,,,.f. )  
oFont10c:= TFont():New( "Courier New",,12,,.f.,,,,,.f. ) 

nDescProd := 0
nTotal    := 0
nTotMerc  := 0
nOrder	  := 1
nItem     := 0
nTotIcmSol:= 0

nPagD:=1
dbSelectArea("SC6")
dbSetOrder(nOrder)
SetRegua(nPagD)
dbSeek(xFilial("SC6")+_cNumPed)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nNrItem:=0
While !Eof() .And. C6_FILIAL = xFilial("SC6") .And. C6_NUM == _cNumPed
  nNritem+=1
  dbSkip()
Enddo
dbSelectArea("SC6")
dbSetOrder(nOrder)
SetRegua(nPagD)
dbSeek(xFilial("SC6")+_cNumPed)

While !Eof() .And. C6_FILIAL = xFilial("SC6") .And. C6_NUM == _cNumPed
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis para armazenar os valores do pedido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOrdem   := 1
	nReem    := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
  
    ImpCabec()
  
	nTotal   := 0
	nTotMerc	:= 0
	nDescProd:= 0
	nSavRec  := SC6->(Recno())
	NumPed   := SC6->C6_NUM
    li       := 465        
    nTotDesc := 0
    cCliente := SC5->(C5_CLIENTE+C5_LOJACLI)
		

	//+-----------------------------------------------------------------------------------+
    //| MAFIS()  -> Função que calcula os impostos                                        |
    //+-----------------------------------------------------------------------------------+
    nDesconto:=0

    MaFisIni(SC5->C5_CLIENTE,;  // 1-Codigo Cliente/Fornecedor
    SC5->C5_LOJACLI,;  // 2-Loja do Cliente/Fornecedor
     "C",;     // 3-C:Cliente , F:Fornecedor
     SC5->C5_TIPO,;   // 4-Tipo da NF
      SC5->C5_TIPOCLI,;         // 5-Tipo do Cliente/Fornecedor
     MaFisRelImp("MTR700",{"SC5","SC6"}),;   // 6-Relacao de Impostos que suportados no arquivo
     ,;     // 7-Tipo de complemento
     ,;     // 8-Permite Incluir Impostos no Rodape .T./.F.
     "SB1",;     // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
     "MTR700")    // 10-Nome da rotina que esta utilizando a funcao
 
    nItem := 0   
    nValIcmSt := 0
    DbSelectArea("SC6") 
    DbGoTop()
    DbSetOrder(1)
    DbSeek(xFilial("SC6")+NumPed)
    While !Eof() .And. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM == NumPed
	  dbSelectArea("SC6")
			
	  If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
  	     AADD(aSavRec,Recno())
      Endif
			
	  IncRegua()
			
	  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  //³ Verifica se havera salto de formulario                       ³
	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  If li > 1550
		  nOrdem++
		  ImpRodape()			// Imprime rodape do formulario e salta para a proxima folha
		  ImpCabec()
		  li  := 465
	  Endif
			
	  li:=li+60
			
	  oPrn:Say( li, 0060, StrZero(Val(SC6->C6_ITEM),2)  ,oFont4,100 )
      oPrn:Say( li, 0135, UPPER(SC6->C6_PRODUTO),oFont4,100 )
    
      nItem ++
			MaFisAdd(SC6->C6_PRODUTO,;   	   // 1-Codigo do Produto ( Obrigatorio )
					SC6->C6_TES,;		       // 2-Codigo do TES ( Opcional )
					SC6->C6_QTDVEN,;		   // 3-Quantidade ( Obrigatorio )
					SC6->C6_PRCVEN,;	       // 4-Preco Unitario ( Obrigatorio )
					nDesconto,;                // 5-Valor do Desconto ( Opcional )
					nil,;		               // 6-Numero da NF Original ( Devolucao/Benef )
					nil,;		               // 7-Serie da NF Original ( Devolucao/Benef )
					nil,;			       	   // 8-RecNo da NF Original no arq SD1/SD2
					SC5->C5_FRETE/nNritem,;	   // 9-Valor do Frete do Item ( Opcional )
					SC5->C5_DESPESA/nNritem,;  // 10-Valor da Despesa do item ( Opcional )
					SC5->C5_SEGURO/nNritem,;   // 11-Valor do Seguro do item ( Opcional )
					0,;						   // 12-Valor do Frete Autonomo ( Opcional )
					SC6->C6_Valor+nDesconto,;  // 13-Valor da Mercadoria ( Obrigatorio )
					0,;						   // 14-Valor da Embalagem ( Opcional )
					0,;		     			   // 15-RecNo do SB1
					0) 	           	           // 16-RecNo do SF4     
      nIPI        := MaFisRet(nItem,"IT_ALIQIPI")
      nICM        := MaFisRet(nItem,"IT_ALIQICM")
      nValIcm     := MaFisRet(nItem,"IT_VALICM")	           
      nValIpi     := MaFisRet(nItem,"IT_VALIPI")	      
      nTotIpi	    := MaFisRet(,'NF_VALIPI')
      nTotIcms	:= MaFisRet(,'NF_VALICM')        
      nTotDesp	:= MaFisRet(,'NF_DESPESA')
      nTotFrete	:= MaFisRet(,'NF_FRETE')
      nTotalNF	:= MaFisRet(,'NF_TOTAL')
      nTotSeguro  := MaFisRet(,'NF_SEGURO')
      aValIVA     := MaFisRet(,"NF_VALIMP")
      nTotMerc    := MaFisRet(,"NF_TOTAL")
      nTotIcmSol  := MaFisRet(nItem,'NF_VALSOL')
      
	  ImpProd()

      SC6->(DbSkip())  
   EndDo 
   MaFisEnd()//Termino
		
	dbGoto(nSavRec)

	If li>1550
		nOrdem++
		ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
		ImpCabec()
		li  := 465
	Endif     
                  
	FinalPed()		// Imprime os dados complementares do PC

	dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array

	aSavRec := {}
	
	dbSkip()
EndDo

dbSelectArea("SC6")
Set Filter To
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

If lEnc
   oPrn:Preview()
   MS_FLUSH()
EndIf
   
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Altair Teixeira       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec()
Local nOrden, cCGC
LOCAL cMoeda
Local cComprador:=""
LOcal cAlter	:=""
Local cAprova	:=""
Local cCompr	:=""
Local cDe       :=""
Local _aDados   :={}   // Array de 2 dimensões.

Private cSubject
cMoeda := "1"

PswOrder(2) // ordena por user name
If PswSeek( SubStr(cUsuario,7,15), .T. )  // cUsuario eh uma variavel global
 _aDados := PswRet() // Retorna vetor com informacoes do usuario
EndIf

cCompr :=_aDados[1][4]   // Nome completo
_cDe   :=_aDados[1][14]   // E-mail

If !lPrimPag
   oPrn:EndPage()
   oPrn:StartPage() 
   nPag += 1
Else
   lPrimPag := .f.
   lEnc     := .t.
   oPrn  := TMSPrinter():New()
   oPrn:Setup()
EndIF  
oPrn:Say( 0020, 0020, " ",oFont,100 ) // startando a impressora   

//Cabecalho (Enderecos da Empresa e Fornecedor)
oPrn:Box( 0000, 0010, 0420,0410)
oPrn:Box( 0000, 0410, 0175,2550)
oPrn:Box( 0000, 2550, 0175,2900) //3000
oPrn:Box( 0000, 2900, 0175,3300) //3340

oPrn:Box( 0175, 0410, 0420,1380)
oPrn:Box( 0175, 1380, 0420,2550)
oPrn:Box( 0175, 2550, 0420,3300)

//Cabecalho Produto do Pedido

oPrn:Box( 0420, 0010, 1730,0130)
oPrn:Box( 0420, 0130, 1730,0410)
oPrn:Box( 0420, 0410, 1730,1650)
oPrn:Box( 0420, 1650, 1730,1800)
oPrn:Box( 0420, 1800, 1730,1950)
oPrn:Box( 0420, 1950, 1730,2019)
oPrn:Box( 0420, 2019, 1730,2280)
oPrn:Box( 0420, 2280, 1730,2550)
oPrn:Box( 0420, 2550, 1730,2660)
oPrn:Box( 0420, 2660, 1730,2850)
oPrn:Box( 0420, 2850, 1730,3120)
oPrn:Box( 0420, 3120, 1730,3300)

//Espaco dos Itens do Pedido
oPrn:Box( 0480, 0010, 1730,0130)
oPrn:Box( 0480, 0130, 1730,0410)
oPrn:Box( 0480, 0410, 1730,1650)
oPrn:Box( 0480, 1650, 1730,1800)
oPrn:Box( 0480, 1800, 1730,1950)
oPrn:Box( 0480, 1950, 1730,2019)
oPrn:Box( 0480, 2019, 1730,2280)
oPrn:Box( 0480, 2280, 1730,2550)
oPrn:Box( 0480, 2550, 1730,2660)
oPrn:Box( 0480, 2660, 1730,2850)
oPrn:Box( 0480, 2850, 1730,3120)
oPrn:Box( 0480, 3120, 1730,3300)

oPrn:SayBitmap( 0040,0020,"logo.bmp",0380,0260 )

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

//Titulo        
If SC5->C5_TIPOCLI="S" .AND. SA1->A1_EST$"RS/MG"
   oPrn:Say( 0080, 0900, "PEDIDO DE VENDA",oFont1,100 )
Else
   oPrn:Say( 0080, 1200, "PEDIDO DE VENDA",oFont1,100 )
Endif   
oPrn:Say( 0085, 2600, "Nº "+SC5->C5_NUM,oFont1,100 )

oPrn:Say( 0080, 2980, "FOLHA:" ,oFont3,100 )
oPrn:Say( 0080, 3132, Alltrim(StrZero(nPag,2)))//+" / "+Alltrim(StrZero(nPagD,2)) ,oFont3,100 )


//Itens das Empresas

If SC5->C5_TIPO=="D" .OR. SC5->C5_TIPO=="B"
   oPrn:Say( 0185, 0430, "CLIENTE",oFont3,100 )
   oPrn:Say( 0185, 1400, "FORNECEDOR",oFont3,100 )
   oPrn:Say( 0185, 2570, "Data Emissão:" ,oFont3,100 )
   oPrn:Say( 0185, 2940, DTOC(SC5->C5_EMISSAO) ,oFont4,100 )
   oPrn:Say( 0230, 0430, Capital(SM0->M0_NOMECOM),oFont4,100 )
   oPrn:Say( 0230, 1400, Alltrim(Substr(SA2->A2_NOME,1,40))+"  -  ("+SA2->A2_COD+")" ,oFont6,100 )
   oPrn:Say( 0230, 2570, "Dt Impressão:" ,oFont3,100 )
   oPrn:Say( 0230, 2940, DTOC(DDATABASE) ,oFont4,100 )
   oPrn:Say( 0265, 0430, AllTrim(SM0->M0_ENDCOB)+" - "+AllTrim(SM0->M0_BAIRCOB) +" - "+ AllTrim(SM0->M0_COMPCOB),oFont6,100 )
   oPrn:Say( 0265, 1400, UPPER(Substr(SA2->A2_END,1,40)+" - "+Substr(SA2->A2_BAIRRO,1,25)) ,oFont6,100 )
   oPrn:Say( 0300, 0430, "CEP: " + SM0->M0_CEPCOB,oFont6,100 )
   oPrn:Say( 0300, 1060, AllTrim(SM0->M0_CIDCOB)+" - "+ SM0->M0_ESTCOB, oFont6,100 )
   oPrn:Say( 0300, 1400, Upper(Trim(SA2->A2_MUN)+"-"+SA2->A2_EST+"  "+"CEP: "+SA2->A2_CEP) ,oFont6,100 )
   oPrn:Say( 0300, 2170, "FAX: " + "("+Substr(SA2->A2_DDD,1,3)+") "+SA2->A2_FAX ,oFont6,100 )
//   If !Empty(SC5->C5_PEDCLI)
//      oPrn:Say( 0300, 2570, "ORDEM DE COMPRA: ",oFont5,100 )
//      oPrn:Say( 0300, 2880, SC5->C5_PEDCLI,oFont6,100 )
//   Endif   
   oPrn:Say( 0335, 2570, "VENDEDOR: ",oFont5,100 )
   oPrn:Say( 0335, 2770, Capital(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME")),oFont6,100 )
   oPrn:Say( 0335, 0430, "FONE: "+AllTrim(SM0->M0_TEL),oFont6,100 )
   oPrn:Say( 0335, 1060, "FAX: "+AllTrim(SM0->M0_FAX),oFont6,100 )
//   oPrn:Say( 0335, 1400, "VENDEDOR: " + Upper(Substr(SC5->C5_VEND1,1,10)),oFont6,100 )
   oPrn:Say( 0335, 2170, "FONE: " + "("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15) ,oFont6,100 )
   oPrn:Say( 0370, 2570, "EMAIL: ",oFont5,100 )
   oPrn:Say( 0370, 2680, alltrim(_cDe),oFont6,100 )   
Else
   oPrn:Say( 0185, 0430, "FORNECEDOR",oFont3,100 )
   oPrn:Say( 0185, 1400, "CLIENTE",oFont3,100 )   
   oPrn:Say( 0185, 2570, "Data Emissão:" ,oFont3,100 )
   oPrn:Say( 0185, 2940, DTOC(SC5->C5_EMISSAO) ,oFont4,100 )
   oPrn:Say( 0230, 0430, Capital(SM0->M0_NOMECOM),oFont4,100 )
   oPrn:Say( 0230, 1400, Alltrim(Substr(SA1->A1_NOME,1,40))+"  -  ("+SA1->A1_COD+")" ,oFont6,100 )
   oPrn:Say( 0230, 2570, "Dt Impressão:" ,oFont3,100 )
   oPrn:Say( 0230, 2940, DTOC(DDATABASE) ,oFont4,100 )
   oPrn:Say( 0265, 0430, AllTrim(SM0->M0_ENDCOB)+" - "+AllTrim(SM0->M0_BAIRCOB) +" - "+ AllTrim(SM0->M0_COMPCOB),oFont6,100 )
   oPrn:Say( 0265, 1400, UPPER(Substr(SA1->A1_END,1,40)+" - "+Substr(SA1->A1_BAIRRO,1,25)) ,oFont6,100 )
   oPrn:Say( 0300, 0430, "CEP: " + SM0->M0_CEPCOB,oFont6,100 )
   oPrn:Say( 0300, 1060, AllTrim(SM0->M0_CIDCOB)+" - "+ SM0->M0_ESTCOB, oFont6,100 )
   oPrn:Say( 0300, 1400, Upper(Trim(SA1->A1_MUN)+"-"+SA1->A1_EST+"  "+"CEP: "+SA1->A1_CEP) ,oFont6,100 )
   oPrn:Say( 0300, 2170, "FAX: " + "("+Substr(SA1->A1_DDD,1,3)+") "+SA1->A1_FAX ,oFont6,100 )
//   If !Empty(SC5->C5_PEDCLI)
//      oPrn:Say( 0300, 2570, "ORDEM DE COMPRA: ",oFont5,100 )
//      oPrn:Say( 0300, 2880, SC5->C5_PEDCLI,oFont6,100 )
//   Endif   
   oPrn:Say( 0335, 2570, "VENDEDOR: ",oFont5,100 )
   oPrn:Say( 0335, 2770, Capital(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME")),oFont6,100 )
   oPrn:Say( 0335, 0430, "FONE: "+AllTrim(SM0->M0_TEL),oFont6,100 )
   oPrn:Say( 0335, 1060, "FAX: "+AllTrim(SM0->M0_FAX),oFont6,100 )
//   oPrn:Say( 0335, 1400, "VENDEDOR: " + Upper(Substr(SC5->C5_VEND1,1,10)),oFont6,100 )
   oPrn:Say( 0335, 2170, "FONE: " + "("+Substr(SA1->A1_DDD,1,3)+") "+Substr(SA1->A1_TEL,1,15) ,oFont6,100 )
   oPrn:Say( 0370, 2570, "EMAIL: ",oFont5,100 )
   oPrn:Say( 0370, 2680, alltrim(_cDe),oFont6,100 )   
Endif   

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("A1_CGC")
cCGC := 'CNPJ/CPF:' //Alltrim(X3TITULO())
nOrden = IndexOrd()

oPrn:Say( 0370, 0430,  (cCGC) + " "+ Transform(SM0->M0_CGC,cCgcPict) ,oFont6,100 )
//oPrn:Say( 0370, 0430, "CNPJ: 01.743.139/0001-98" ,oFont6,100 )
//oPrn:Say( 0370, 1060, "IE:" + InscrEst() ,oFont6,100 )
if (SM0->M0_ESTCOB == "SP")
   	inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 999.999.999.999"))
elseif (SM0->M0_ESTCOB == "RJ")
   	inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 99.999999"))
Else                                                                    
	inscEst           := Alltrim(Transform(SM0->M0_INSC,"@R 99.999999"))	
endif
oPrn:Say( 0370, 1060, "IE: " + inscEst ,oFont6,100 )

dbSelectArea("SA1")
dbSetOrder(nOrden)
oPrn:Say( 0370, 1400, 'CNPJ/CPF:' + Transform(SA1->A1_CGC,cCgcPict) ,oFont6,100 )
oPrn:Say( 0370, 2170, "IE: " + SA1->A1_INSCR ,oFont6,100 )

oPrn:Say( 0435, 0030, "Item"  ,oFont3,100 )
oPrn:Say( 0435, 0155, "Código" ,oFont3,100 )
oPrn:Say( 0435, 0430, "Descrição do Produto" ,oFont3,100 )
oPrn:Say( 0433, 1657, "Norma" ,oFont3,100 )
oPrn:Say( 0433, 1807, "Compr." ,oFont3,100 )
oPrn:Say( 0433, 1957, "UN" ,oFont3,100 )
oPrn:Say( 0435, 2060, "Quantidade"  ,oFont3,100 )
oPrn:Say( 0435, 2300, "Valor Unitário" ,oFont3,100 )
oPrn:Say( 0435, 2570, "%IPI" ,oFont3,100 )
oPrn:Say( 0435, 2680, "Valor IPI" ,oFont3,100 )
oPrn:Say( 0435, 2890, "Valor Total" ,oFont3,100 )
oPrn:Say( 0435, 3140, "Entrega" ,oFont3,100 )

cSubject := "Pedido de Venda nr."+SC5->C5_NUM+" / "+AllTrim(Left(SA1->A1_NOME,30))

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpProd  ³ Autor ³ Altair Teixeira       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisar e imprimir  dados Cadastrais do Produto.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpProd()
LOCAL cDesc, nLinRef := 1, nBegin := 0, cDescri := "", nLinha:=0,;
		nTamDesc := 50 , aColuna := Array(8)   
	
Public nEsp := " "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//cDescri := Trim(Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"SB1->B1_DESC"))
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial()+SC6->C6_PRODUTO)
cDescri := rTRIM(SB1->B1_DESC) //Rtrim(SB1->B1_DESCTIP)+" "+
If SB1->B1_LE==0
   nEsp := nesp+" - "+SC6->C6_ITEM
endif
//cObs := "TES: "+SC6->C6_TES +"-"+POSICIONE("SF4",1,xFILIAL("SF4")+SC6->C6_TES,"F4_TEXTO")

dbSelectArea("SC6")
If RTRIM(SC6->C6_PRODUTO)=="999999999999999"
   cDescri := Trim(SC6->C6_DESCRI) 	// pega descriçao do pedido (cod generico)
Endif   

//nLinhaD:= MLCount(cDescri,nTamDesc)
//nLinhaO:= MLCount(cObs,30)
//nLinha := If(nLinhaD>nLInhaO,nLinhaD,nLinhaO)
//oPrn:Say( li, 0430, MemoLine(cDescri,nTamDesc,1) ,oFont4,100 )
//oPrn:Say( li, 1400, If(nLinhaO>0,MemoLine(cObs,30,1),""),oFont6,100 )
oPrn:Say( li, 0430,cDescri,oFont4,100 )
//li:=li+50
//oPrn:Say( li, 0430,cObs,oFont4,100 )

oPrn:Say( li, 2460, Transform(MaFisRet(nitem,"IT_ALIQIPI"),tm(MaFisRet(nitem,"IT_ALIQIPI"),10,MsDecimais(2))) ,oFont6c,100 )
oPrn:Say( li, 2570, Transform(MaFisRet(nitem,"IT_VALIPI"),tm(MaFisRet(nitem,"IT_VALIPI"),14,MsDecimais(2))) ,oFont6c,100 )


ImpCampos()
/*
For nBegin := 2 To nLinha
	//	li+=35
	li+=50              
	If nLinhaD>=nBegin
		oPrn:Say( li, 0430, MemoLine(cDescri,nTamDesc,nBegin) ,oFont4,100 )
	EndIf
	If nLinhaO>=nBegin
		oPrn:Say( li, 1400, MemoLine(cObs,30,nBegin),oFont6,100 )
	EndIf
Next nBegin
*/
Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCampos³ Autor ³ Altair Teixeira       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir dados Complementares do Produto no Pedido.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCampos(Void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCampos()
dbSelectArea("SC6")   

oPrn:Say( li, 1665, SC6->C6_ARANOR ,oFont6,100 )
oPrn:Say( li, 1800, Transform(SC6->C6_COMPRI,'@E 99999999') ,oFont6,100 )
oPrn:Say( li, 1965, SC6->C6_UM ,oFont6,100 )
oPrn:Say( li, 2040, Transform(SC6->C6_QTDVEN,'@E 9,999,999.99') ,oFont6c,100 )
oPrn:Say( li, 2260, Transform(SC6->C6_PRCVEN,'@E 9,999,999.9999') ,oFont6c,100 )
oPrn:Say( li, 2830, Transform(SC6->C6_VALOR,PesqPict("SC6","C6_VALOR",14,2)) ,oFont6c,100 )
oPrn:Say( li, 3150, DTOC(SC6->C6_ENTREG) ,oFont4,100 )
If !Empty(SC6->C6_ARADESC)
   li+=50
   oPrn:Say( li, 0430,SC6->C6_ARADESC,oFont6,100 )
Endif

nTotal  :=nTotal+SC6->C6_VALOR
nTotDesc+=SC6->C6_VALDESC

Return .T.  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Altair Teixeira       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o rodape do formulario e salta para a proxima folha³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpRodape(Void)   			         					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 					                     				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodape()

oPrn:Say( 1700, 0070, "CONTINUA ..." ,oFont3,100 )

Return .T. 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalPed ³ Autor ³ Altair Teixeira       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares do Pedido de Compra        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalPed(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinalPed()

Local nk 		:= 1,nG
Local nQuebra	:= 0
Local lNewAlc	:= .F.
Local lLiber 	:= .F.
Local lImpLeg	:= .T.
Local cComprador:=""
LOcal cAlter	:=""
Local cAprova	:=""
Local cCompr	:=""
Local aColuna   := Array(8), nTotLinhas 
Local _cTexto := " "
//Rodape
//oPrn:Box( 1380, 0010, 1460,2550)
//oPrn:Box( 1380, 2550, 1460,3375)
oPrn:Box( 1730, 0010, 1950,1820)
oPrn:Box( 1730, 1820, 1950,2550)
oPrn:Box( 1730, 2550, 1950,3300)
oPrn:Box( 1840, 2550, 1950,3300)
oPrn:Box( 1950, 0010, 2230,3300)
oPrn:Box( 1950, 1820, 2230,3300)
oPrn:Box( 2230, 0010, 2350,3300)   

If cPaisLoc <> "BRA" .And. !Empty(aValIVA)
   For nG:=1 to Len(aValIVA)
       nValIVA+=aValIVA[nG]
   Next
Endif

/*
cMensagem:= Formula(C5_MSG)

If !Empty(cMensagem)
	li++
	@ li,002 PSAY Padc(cMensagem,129)
Endif
*/

//oPrn:Say( 1400, 0420, "D E S C O N T O S -->" ,oFont3,100 )
//oPrn:Say( 1400, 0950, Transform(SC6->C6_DESC1,"@E999.99") ,oFont4,100 )
//oPrn:Say( 1400, 1170, Transform(SC6->C6_DESC2,"@E999.99") ,oFont4,100 )
//oPrn:Say( 1400, 1400, Transform(SC6->C6_DESC3,"@E999.99") ,oFont4,100 )
//oPrn:Say( 1400, 1750, Transform(xMoeda(nTotDesc,SC6->C6_MOEDA,1,SC6->C6_DATPRF),PesqPict("SC6","C6_VLDESC",14, 1)) ,oFont4,100 )

oPrn:Say( 1765, 2580, "SUB TOTAL: " ,oFont9,100 )
oPrn:Say( 1765, 2810, Transform(nTotal,tm(nTotal,14,MsDecimais(1))) ,oFont9c,100 )
                          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
//dbSeek(SUBS(cNumEmp,1,2)+SC5->C5_FILENT)

oPrn:Say( 1750, 0050, "Tipo do Frete   : ",oFont3,100 )
oPrn:Say( 1750, 0420, Upper(Alltrim(_cTpFrete)) ,oFont4,100 )
oPrn:Say( 1795, 0050, "Transportadora  : ",oFont3,100 )
oPrn:Say( 1795, 0420, Upper(Alltrim(_cTransp)) ,oFont4,100 )

If Empty(SC5->C5_CLIENTR) 
	oPrn:Say( 1840, 0050, "Local de Entrega: " ,oFont3,100 )  
	//oPrn:Say( 1750, 0420, "RUA SERRA DA DIVISÕES, 740", oFont4,100 )
	//oPrn:Say( 1750, 0420, Upper(Alltrim(_cEndEntr)) ,oFont4,100 )
	li:=1795
	For j:= 1 To 2
		li+=45              
		If 2>=j
			oPrn:Say( li, 0420, MemoLine(_cEndEntr,100,j) ,oFont4,100 )
		EndIf
	Next j
Endif

dbGoto(nRegistro)
dbSelectArea( cAlias )

//oPrn:Say( 1795,0050, "Local de Cobrança  : ",oFont3,100 )
//oPrn:Say( 1795, 0420,"RUA: SERRA DAS DIVISÕES, 740 - CIDADE LÍDER-CEP 03587-000-SÃO PAULO-SP", oFont4,100 )

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SC5->C5_CONDPAG)

oPrn:Say( 1885, 0050, "Condição de Pagto  :",oFont3,100 ) 

oPrn:Say( 1885, 0420, Alltrim(SE4->E4_DESCRI),oFont4,100 )
oPrn:Say( 1885, 1050, "Moeda :",oFont3,100 ) 
If SC5->C5_MOEDA=1
   oPrn:Say( 1885, 1200, "R$-Real",oFont3,100 ) 
Endif   
If SC5->C5_MOEDA=2
   oPrn:Say( 1885, 1200, "US$-Dolar",oFont3,100 ) 
Endif   
oPrn:Say( 1870, 2580, "TOTAL : ",oFont9,100 )
oPrn:Say( 1870, 2810, Transform(nTotMerc,tm(nTotMerc,14,MsDecimais(1))),oFont9c,100 )
oPrn:Say( 1735, 1850, "IPI :" ,oFont3,100 )
oPrn:Say( 1735, 2050, Transform(nTotIPI,tm(nTotIpi,14,MsDecimais(2))) ,oFont4c,100 )
oPrn:Say( 1780, 1850, "ICMS :" ,oFont3,100 )
oPrn:Say( 1780, 2050, Transform(nTotIcms,tm(nTotIcms,14,MsDecimais(1))) ,oFont4c,100 )
oPrn:Say( 1825, 1850, "ICMS Solid.:" ,oFont3,100 )
oPrn:Say( 1825, 2050, Transform(nTotIcmSol,tm(nTotIcmSol,14,MsDecimais(1))) ,oFont4c,100 )
oPrn:Say( 1870, 1850, "Frete :" ,oFont3,100 )
oPrn:Say( 1870, 2050, Transform(nTotFrete,tm(nTotFrete,14,MsDecimais(1))) ,oFont4c,100 )
oPrn:Say( 1913, 1850, "Seguro :" ,oFont3,100 )
oPrn:Say( 1913, 2050, Transform(nTotSeguro,tm(nTotSeguro,14,MsDecimais(1))) ,oFont4c,100 )
//oPrn:Say( 1915, 1850, "Despesas :" ,oFont3,100 )
//oPrn:Say( 1915, 2050, Transform(nTotDesp,tm(nTotDesp,14,MsDecimais(1))) ,oFont4c,100 )

If !Empty(SC5->C5_CLIENTR) 
	Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTR+SC5->C5_LOJAENT,"")
		
	oPrn:Say( 1980, 0050, "Local de Entrega: ",oFont5,100 )
   oPrn:Say( 1980, 0300, Alltrim(Substr(SA1->A1_NOME,1,40))+"  -  ("+SA1->A1_COD+")" ,oFont6,100 )
   oPrn:Say( 2015, 0300, UPPER(Substr(SA1->A1_END,1,40)+" - "+Substr(SA1->A1_BAIRRO,1,25)) ,oFont6,100 )
   oPrn:Say( 2045, 0300, Upper(Trim(SA1->A1_MUN)+"-"+SA1->A1_EST+"  "+"CEP: "+SA1->A1_CEP) ,oFont6,100 )
   oPrn:Say( 2080, 0300, "FAX: " + "("+Substr(SA1->A1_DDD,1,3)+") "+SA1->A1_FAX ,oFont6,100 )
   oPrn:Say( 2115, 0300, "FONE: " + "("+Substr(SA1->A1_DDD,1,3)+") "+Substr(SA1->A1_TEL,1,15) ,oFont6,100 )
Endif

oPrn:Say( 1980, 1850, "Observações: ",oFont5,100 )
_cTexto := AllTrim(SC5->C5_ARAME15)
nLinha:= MLCount(_ctexto,164)
li:=1980
For nBegin := 1 To nLinha
	li+=50              
	oPrn:Say( li, 1850, MemoLine(_cTexto,164,nBegin) ,oFont5,100 )
Next nBegin
//oPrn:Say( 2250, 0050,  " NOTAS: ",oFont7,100 )
//oPrn:Say( 2250, 0265,  "1)  VALOR MÍNIMO PARA VENDA R$ 150,00 - VALOR MÍNIMO PARA FATURAMENTO E ENTREGA R$ 300,00.(SOMENTE ALGUNS BAIRROS DA GRANDE SP)",oFont3,100 )
//oPrn:Say( 2295, 0265,  "2)  O PEDIDO SÓ SERÁ VALIDADO APÓS O ACEITE FORMAL DO CLIENTE.",oFont3,100 )

Return .T.
//incio do pedido em html

*------------------------*
Static Function ImpHtml()
*------------------------*
Local nTotIpi
Local nTotIcms
Local nTotFrete
Local nTotSeguro
Local nTorDesp
Local nTotalNF
local nCondPagDescr
Local cDescri
Local CodProd
Local nCondpagCod
Local cMoeda
Local _cDe      
Local cObs
Local _cTexto := " "

Private cMsg    
Public nEsp := " "

cCGCPict:=PesqPict("SA1","A1_CGC")

psworder(2)  // email e nome do comprador
if pswseek(Substr(cUsuario,7,15),.t.)
   _daduser:=pswret(1)
   _cDe   := Alltrim(_daduser[1,14])
   cCompr := Alltrim(_daduser[1,4])
endif

ProcRegua(10)

dbSelectArea("SC6")
dbSetOrder(1)    
dbSeek(xFilial()+_cNumPed)

cSubject := "Pedido de Venda Nº."+SC5->C5_NUM+" / "+AllTrim(Left(SA1->A1_NOME,30))

nCondPagDescr:=" "
nCondpagCod:=" "
nCondPagDescr:=Trim(Posicione("SE4",1,"01"+Trim(SC5->C5_CONDPAG),"SE4->E4_DESCRI"))
nCondpagCod :=Trim(SC5->C5_CONDPAG)    
If SC5->C5_MOEDA=1
   cMoeda:="R$-Real"
Endif
If SC5->C5_MOEDA=2
   cMoeda:="US$-Dolar Americano"
Endif

cMsg :="<html>"
cMsg += "<head>"
cMsg += "<meta http-equiv='Content-Type' content='text/html; charset=windows-1252'>"
cMsg += "<meta name='GENERATOR' content='Microsoft FrontPage 4.0'>"
cMsg += "<meta name='ProgId' content='FrontPage.Editor.Document'>"
cMsg += "<title>"+SM0->M0_NOMECOM+"</title>"
cMsg += "</head>"
cMsg += "<body>"
cMsg += "<table border='2' width='808' cellspacing='1' cellpadding='0'>"
cMsg += "<tr>"
cMsg += "<th width='566' height='19' colspan='6' valign='middle' align='center'>"
cMsg += "<div align='center'>"
cMsg += "<center>"
cMsg += "<pre align='center'><font face='Arial' size='1'><b><img "
cMsg += "src='http://www.tecnotron.ind.br/images/logo.gif' width='147' height='73' align='left'></b></font>"
cMsg += "<b><font face='Arial' size='3'> PEDIDO DE VENDA </font></b></pre>"
cMsg += "</center>"
cMsg += "</div>"
cMsg += "</th>"
cMsg += "<td width='150' height='19' colspan='4'>"
cMsg += "<pre><center><font face='Arial' size='3'><b>Nº: "+SC5->C5_NUM+"</b></font></center></pre>"
cMsg += "<pre><center><font face='Arial' size='2'><b>Emissão:"+Substr(Dtos(dDatabase),7,2)+"/"+Substr(Dtos(dDatabase),5,2)+"/"+Substr(Dtos(dDatabase),1,4)+"</b></font></center></pre>"
cMsg += "</td>"
cMsg += "</tr>"
cMsg += "<td width='425' colspan='4' height='94'>"
cMsg += "<pre><b><font face='Arial' size='1'>FORNECEDOR</font></b><br>"
cMsg += "<font face='Arial' size='2'color='blue'><b>"+SM0->M0_NOMECOM+"</b>&nbsp;</font><br>"
cMsg += "<font face='Arial' size='1'>"+AllTrim(SM0->M0_ENDCOB)+" - "+AllTrim(SM0->M0_BAIRCOB) +" - "+ AllTrim(SM0->M0_COMPCOB)+"RUA: SERRA DAS DIVISÕES, 740 - CIDADE LÍDER&nbsp;<br>"
cMsg += "CEP: "+SM0->M0_CEPCOB+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
cMsg += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
cMsg += AllTrim(SM0->M0_CIDCOB)+" - "+ SM0->M0_ESTCOB+"<br>"
cMsg += "TEL: "+AllTrim(SM0->M0_TEL)+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
cMsg += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
cMsg += "FAX: "+AllTrim(SM0->M0_FAX)+"<br>"
cMsg += "CNPJ: "+Transform(SM0->M0_CGC,cCgcPict)+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
cMsg += "&nbsp;&nbsp;"
cMsg += "IE: "+Alltrim(Transform(SM0->M0_INSC,"@R 999.999.999.999"))+"</font>"
cMsg += "    </td>"
cMsg += "    <td width='347' colspan='7' height='94'>"
cMsg += "     <pre><b><font face='Arial' size='1'><b>CLIENTE&nbsp;<br></b>"
cMsg += "<font face='Arial' size='2'color='red'><b>"+Alltrim(Substr(SA1->A1_NOME,1,28))+ "- ("+SA1->A1_COD+"/"+SA1->A1_LOJA+")</b>&nbsp;</font><br>"
cMsg += " <font face='Arial' size='1'>Comprador: "+SA1->A1_CONTATO+"  Email: "+SA1->A1_EMAIL+"&nbsp;<br>"
cMsg += " "+Upper(Substr(SA1->A1_END,1,30)+" - Bairro:"+ Substr(SA1->A1_BAIRRO,1,10))+"&nbsp;<br>"
cMsg += " CIDADE: "+SA1->A1_MUN +"&nbsp;<br>"
cMsg += " CEP: "+Upper(SA1->A1_CEP)+"&nbsp;<br>"
cMsg += " FONE:"+"("+Substr(SA1->A1_DDD,1,3)+") "+Substr(SA1->A1_TEL,1,9)+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FAX: "+SA1->A1_FAX +"<br>"
cMsg += " CNPJ:"+ Upper(Trim(SA1->A1_CGC))+ "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;IE:"  +Upper(Trim(SA1->A1_INSCR))+"</font>"
cMsg += "    </td>"
cMsg += "  </tr>"
cMsg += "  <tr>"
cMsg += "    <td width='785' height='16' colspan='10'>"
cMsg += "        <font face='Arial' size='1'><b>Vendedor:</b> "+cCompr+"<br>"
cMsg += "        <b>Email: "+_cDe+"</b></font>"
cMsg += "    </td>"
cMsg += "  </tr>"
cMsg += "  <tr>"
cMsg += "    <td width='11' height='16' align='center'>"
cMsg += "      <pre><font face='Arial' size='1'><b>Item</b></font></pre>"
cMsg += "    </td>"
cMsg += "    <td width='50' height='16' align='center'>"
cMsg += "      <pre><font face='Arial' size='1'><b>Código</b></font></pre>"
cMsg += "    </td>"
cMsg += "    <td width='357' height='16' align='center'>"
cMsg += "      <pre><font face='Arial' size='1'><b>Descrição do Produto</b></font></pre>"
cMsg += "    </td>"
cMsg += "    <td width='21' height='16' align='center'>"
cMsg += "      <pre><font face='Arial' size='1'><b>UN</b></font></pre>"
cMsg += "    </td>"
cMsg += "    <td width='58' height='16' align='center'>"
cMsg += "      <pre><font face='Arial' size='1'><b>QTD</b></font></pre>"
cMsg += "    </td>"
cMsg += "    <td width='69' height='16' align='center'>"
cMsg += "      <pre><font face='Arial' size='1'><b>VLR. UNIT.</b></font></pre>"
cMsg += "    </td>"
cMsg += "    <td width='24' height='16' align='center'>"
cMsg += "      <pre><font face='Arial' size='1'><b>%IPI</b></font></pre>"
cMsg += "    </td>"
cMsg += "    <td width='69' height='16' align='center'>"
cMsg += "      <pre><font face='Arial' size='1'><b>VLR. IPI</b></font></pre>"
cMsg += "    </td>"
cMsg += "    <td width='69' height='16' align='center'>"
cMsg += "      <pre><font face='Arial' size='1'><b>VLR. TOTAL</b></font></pre>"
cMsg += "    </td>"
cMsg += "    <td width='57' height='16' align='center'>"
cMsg += "      <pre><font size='1' face='Arial'><b>Data Entrega</b></font></pre>"
cMsg += "    </td>"
cMsg += "  </tr>"    
//VARIAVEL DE CONTAGEM 
nTotIpi := 0
nTotIcms  := 0
nTotFrete := 0
nTotSeguro:= 0
nTotDesp  := 0
nTotalNF  := 0       
nTotal    := 0
CodProd   :=" "
//Imprime Itens do no formato HTML
nItem:=0
nNrItem:=0
While !Eof() .And. C6_FILIAL = xFilial("SC6") .And. C6_NUM == _cNumPed
  nNritem+=1
  dbSelectArea("SB1")
  dbSetOrder(1)
  dbSeek(xFilial()+SC6->C6_PRODUTO)
  cDescri := rTRIM(SB1->B1_DESC)   //Rtrim(SB1->B1_DESCTIP)+" "+
  If SB1->B1_LE==0
     nEsp := nesp+" - "+SC6->C6_ITEM
  endif  
  SC6->(dbSkip())  
Enddo
dbSelectArea("SC6")
dbSetOrder(1)    
dbSeek(xFilial()+_cNumPed)

While !Eof() .And. SC6->C6_NUM == _cNumPed 
  	    
         IncProc()  
    //+-----------------------------------------------------------------------------------+
    //| MAFIS()  -> Função que calcula os impostos                                        |
    //+-----------------------------------------------------------------------------------+
    nDesconto:=0

    MaFisIni(SC5->C5_CLIENTE,;  // 1-Codigo Cliente/Fornecedor
    SC5->C5_LOJACLI,;  // 2-Loja do Cliente/Fornecedor
     "C",;     // 3-C:Cliente , F:Fornecedor
     SC5->C5_TIPO,;   // 4-Tipo da NF
      SC5->C5_TIPOCLI,;         // 5-Tipo do Cliente/Fornecedor
     MaFisRelImp("MTR700",{"SC5","SC6"}),;   // 6-Relacao de Impostos que suportados no arquivo
     ,;     // 7-Tipo de complemento
     ,;     // 8-Permite Incluir Impostos no Rodape .T./.F.
     "SB1",;     // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
     "MTR700")    // 10-Nome da rotina que esta utilizando a funcao
 
    nItem := 0   
    nValIcmSt := 0
    DbSelectArea("SC6") 
    DbGoTop()
    DbSetOrder(1)
    DbSeek(xFilial("SC6")+_cNumPed)
    While !Eof() .And. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM == _cNumPed
	  dbSelectArea("SC6")		  
      //atribuindo a variavel ao produto
      CodProd:= SC6->C6_PRODUTO 
      cDescri:= " "
  

      nItem ++
			MaFisAdd(SC6->C6_PRODUTO,;   	   // 1-Codigo do Produto ( Obrigatorio )
					SC6->C6_TES,;		       // 2-Codigo do TES ( Opcional )
					SC6->C6_QTDVEN,;		   // 3-Quantidade ( Obrigatorio )
					SC6->C6_PRCVEN,;	       // 4-Preco Unitario ( Obrigatorio )
					nDesconto,;                // 5-Valor do Desconto ( Opcional )
					nil,;		               // 6-Numero da NF Original ( Devolucao/Benef )
					nil,;		               // 7-Serie da NF Original ( Devolucao/Benef )
					nil,;			       	   // 8-RecNo da NF Original no arq SD1/SD2
					SC5->C5_FRETE/nNritem,;	   // 9-Valor do Frete do Item ( Opcional )
					SC5->C5_DESPESA/nNritem,;  // 10-Valor da Despesa do item ( Opcional )
					SC5->C5_SEGURO/nNritem,;   // 11-Valor do Seguro do item ( Opcional )
					0,;						   // 12-Valor do Frete Autonomo ( Opcional )
					SC6->C6_Valor+nDesconto,;  // 13-Valor da Mercadoria ( Obrigatorio )
					0,;						   // 14-Valor da Embalagem ( Opcional )
					0,;		     			   // 15-RecNo do SB1
					0) 	           	           // 16-RecNo do SF4          
      nIPI        := MaFisRet(nItem,"IT_ALIQIPI")
      nICM        := MaFisRet(nItem,"IT_ALIQICM")
      nValIcm     := MaFisRet(nItem,"IT_VALICM")	           
      nValIpi     := MaFisRet(nItem,"IT_VALIPI")	      
      nTotIpi	    := MaFisRet(,'NF_VALIPI')
      nTotIcms	:= MaFisRet(,'NF_VALICM')        
      nTotDesp	:= MaFisRet(,'NF_DESPESA')
      nTotFrete	:= MaFisRet(,'NF_FRETE')
      nTotalNF	:= MaFisRet(,'NF_TOTAL')
      nTotSeguro  := MaFisRet(,'NF_SEGURO')
      aValIVA     := MaFisRet(,"NF_VALIMP")
      nTotMerc    := MaFisRet(,"NF_TOTAL")
      nTotIcmSol  := MaFisRet(nItem,'NF_VALSOL')
      
        
		
	     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	     //³ Pesquisa Descricao do Produto                                ³
	     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//       cDescri := Trim(Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"SB1->B1_DESC"))
         dbSelectArea("SB1")
         dbSetOrder(1)
         dbSeek(xFilial()+CodProd)
         cDescri := rTRIM(SB1->B1_DESC)

         If RTRIM(CodProd)=="999999999999999"
  	        cDescri := Trim(SC6->C6_DESCRI) 	// pega descriçao do pedido (cod generico)
  	     Endif   
//         cObs := "TES: "+SC6->C6_TES +"-"+POSICIONE("SF4",1,xFILIAL("SF4")+SC6->C6_TES,"F4_TEXTO")
       	 cMsg += "  <tr>"
    	 cMsg += "    <td width='11'>"
	     cMsg += "      <pre><font face='Arial' size='1'>"+StrZero(nItem,2)+"</font></pre>" 
	     cMsg += "    </td>"
    	 cMsg += "    <td width='50'>"
	     cMsg += "      <pre><font face='Arial' size='1'>"+CodProd+"</font></pre>" 
    	 cMsg += "    </td>"
	     cMsg += "    <td width='357'>"
    	 cMsg += "<pre><font face='Arial' size='1'>"+Trim(cDescri)+"</font><pre>"
//	     IF !Empty(cObs)
//		    cMsg += "<pre><font face='Arial' size='1'>"+Trim(cObs)+"</font>"
//     	 ENDIF
  //       If !Empty(SC6->C6_OBS)
//		    cMsg += "<pre><font face='Arial' size='1'>Cod.Prod.Cliente: "+Rtrim(SC6->C6_OBS)+"</font><pre>"
//         Endif
//         If !Empty(SC6->C6_PROCLI)
//		    cMsg += "<pre><font face='Arial' size='1'>Cod.Prod.Cliente: "+AllTrim(SC6->C6_PROCLI)+"</font><pre>"
//         Endif
//         If !Empty(SC6->C6_PROCLI)
//		    cMsg += "<pre><font face='Arial' size='1'>Ord . de Compra do Item: "+AllTrim(SC6->C6_PEDCLI)+"</font>"
//         Endif
	     cMsg += "    </td>"
	     cMsg += "    <td width='21'>"
	     cMsg += "      <pre><font face='Arial' size='1'>"+SC6->C6_UM+"</font></pre>"
	     cMsg += "    </td>"
	     cMsg += "    <td width='58'>"
	     cMsg += "      <div align='right'>"
	     cMsg += "        <pre><font face='Arial' size='1'>"+TransForm(SC6->C6_QTDVEN,"@E 9,999,999.9999")+"</font></pre>"
	     cMsg += "      </div>"
	     cMsg += "    </td>"
	     cMsg += "    <td width='69'>"
	     cMsg += "      <div align='right'>"
	     cMsg += "        <pre><font face='Arial' size='1'>"+TransForm(SC6->C6_PRCVEN,"@E 9,999,999.999999")+"</font></pre>"
	     cMsg += "      </div>"
         cMsg += "    </td>"
	     cMsg += "    <td width='24'>"
	     cMsg += "      <div align='right'>"
	     cMsg += "        <pre><font face='Arial' size='1'>"+Transform(nIPI,"@E 99,999,999.99")+"</font><pre>"            
	     cMsg += "      </div>"
         cMsg += "    </td>"	     
	     cMsg += "    <td width='69'>"	     
	     cMsg += "      <div align='right'>"
	     cMsg += "        <pre><font face='Arial' size='1'>"+TransForm(nValIPI,"@E 9,999,999.99")+"</font></pre>"
 	     cMsg += "      </div>"
         cMsg += "    </td>"
	     cMsg += "    <td width='69'>"
	     cMsg += "      <div align='center'>"
	     cMsg += "        <center>"
	     cMsg += "        <pre></center><font face='Arial' size='1'>"+TransForm(SC6->C6_VALOR,"@E 9999,999.99")+"</center></font></pre>"
	     cMsg += "        </center>"
	     cMsg += "      </div>"
	     cMsg += "    </td>"
	     cMsg += "    <td width='57'>"
	     cMsg += "      <pre><font face='Arial' size='1'>"+Substr(Dtos(SC6->C6_ENTREG),7,2)+"/"+Substr(Dtos(SC6->C6_ENTREG),5,2)+"/"+Substr(Dtos(SC6->C6_ENTREG),1,4)+ "</font></pre>"
	     cMsg += "    </td>"
	     cMsg += "  </tr>"
         nTotal  :=nTotal+SC6->C6_VALOR
	
	     dbSelectArea("SC6")
         SC6->(dbSkip())
       Enddo  
EndDo 
MaFisEnd()

/*if !Empty(nEsp)          
   _ctexto:= "** A T E N Ç Ã O **  POR SE TRATAR DE PRODUTO FABRICADO EXCLUSIVAMENTE PARA VOSSA EMPRESA, "+; 
   "ESTE PEDIDO SOMENTE SERÁ ACEITO PELA TECNOTRON, MEDIANTE A CONCORDÂNCIA POR PARTE DE VOSSA SENHORIA "+; 
   "DE QUE OS ITENS RELACIONADOS NÃO SERÃO CANCELADOS, REPROGRAMADOS OU MODIFICADOS SEM O PRÉVIO CONSENTIMENTO "+;
   "POR ESCRITO. NÃO SERÁ ACEITA DEVOLUÇÃO DE NENHUM ITEM RELACIONADO POR QUALQUER MOTIVO ALEGADO, EXCETO NOS "+; 
   "CASOS EM QUE O MESMO APRESENTAR DEFEITO DE FABRICAÇÃO DURANTE O PERÍODO DE GARANTIA OU CASO NÃO SEJA "+; 
   "CUMPRIDO O PRAZO DE ENTREGA ESTIPULADO POR NÓS. ITENS RELACIONADOS: "+nEsp 
endif
nLinha1:= MLCount(_cTexto,125)   
nLinha2:= MLCount(_cObs,125)   
nLinha3:= MLCount(Rtrim(SC5->C5_OBSERV1)+" "+Rtrim(SC5->C5_OBSERV2)+" "+Rtrim(SC5->C5_OBSERV3),125)   
*/
cMsg += "</table>"
cMsg += "<table border='2' width='808' cellspacing='1' height='115'>"
cMsg += "  <tr>"
cMsg += "    </td>"
cMsg += "    <td width='188' height='59' rowspan='2'>"
cMsg += "      <div align='Right'>"
cMsg += "<font face='Arial' size='1'><b>IPI:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+TransForm(nTotIpi,"@E 999,999.99")+"<br>"
cMsg += "      </div>"
cMsg += "      <div align='Right'>"
cMsg += "<font face='Arial' size='1'><b>ICMS:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+TransForm(nTotIcms,"@E 999,999.99")+"<br>"
cMsg += "      </div>"
cMsg += "      <div align='Right'>"
cMsg += "<font face='Arial' size='1'><b>ICMS Solid.:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+TransForm(nTotIcmSol,"@E 999,999.99")+"<br>"
cMsg += "      </div>"
cMsg += "      <div align='Right'>"
cMsg += "<font face='Arial' size='1'><b>FRETE:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+TransForm(nTotFrete,"@E 999,999.99")+"<br>"
cMsg += "      </div>"
cMsg += "      <div align='Right'>"
cMsg += "<font face='Arial' size='1'><b>SEGURO:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+TransForm(nTotSeguro,"@E 999,999.99")+"<br>"
cMsg += "      </div>"
cMsg += "      <div align='Right'>"
cMsg += "<font face='Arial' size='1'><b>DESPESA:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+TransForm(nTotDesp,"@E 999,999.99")+"<br>"
cMsg += "      </div>"
cMsg += "    </td>"
cMsg += "    <td width='195' height='30'>"
cMsg += "      <pre><b><font face='Arial' size='2'>SUB TOTAL:"+TransForm(nTotal,"@E 9,999,999.99")+"</font></b></pre>"
cMsg += "    </td>"
cMsg += "  </tr>"
cMsg += "  <tr>"
cMsg += "    <td width='195' height='29'>"
cMsg += "      <pre><b><font face='Arial' size='2'>TOTAL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+TransForm(nTotMerc,"@E 9,999,999.99")+"</font></b></pre>"
cMsg += "    </td>"
cMsg += "  </tr>"
cMsg += "   <tr>"
cMsg += "    <td width='773' height='19' colspan='3'>"
//cMsg += "<pre><b><font face='Arial' size='2'>Ordem de Compra: "+SC5->C5_PEDCLI+"</font></b><br>"
cMsg += "<pre><b><font face='Arial' size='2'>Moeda: "+cMoeda+"                Condição de Pagto:&nbsp;<b>(&nbsp;"+nCondpagCod +"&nbsp;)&nbsp;&nbsp;"+nCondPagDescr+ "</font></b><br>"
cMsg += "<pre><b><font face='Arial' size='2'>Tipo do Frete: "+_cTpfrete+"</font></b><br>"
cMsg += "<pre><b><font face='Arial' size='2'>Transportadora: "+_cTransp+"</font></b><br>"
cMsg += "<pre><b><font face='Arial' size='2'>Local de Entrega: "+_cEndEntr+"</font></b>"
cMsg += "    </td>"
cMsg += "  </tr>"
cMsg += "   <tr>"
cMsg += "    <td width='773' height='19' colspan='3'>"
cMsg += "      <pre><b><font face='Arial' size='2'>Observações Gerais:</font></b><br>"
/*For nBegin := 1 To nLinha1
    cMsg += "<font face='Arial' size='1'><b>&nbsp;&nbsp;"+MemoLine(_ctexto,125,nBegin)+"</font></b><br>"
Next nBegin
For nBegin := 1 To nLinha2
    cMsg += "<font face='Arial' size='1'><b>&nbsp;&nbsp;"+MemoLine(_cObs,125,nBegin)+"</font></b><br>"
Next nBegin
For nBegin := 1 To nLinha3
    cMsg += "<font face='Arial' size='1'><b>&nbsp;&nbsp;"+MemoLine(Rtrim(SC5->C5_OBSERV1)+" "+Rtrim(SC5->C5_OBSERV2)+" "+Rtrim(SC5->C5_OBSERV3),125,nBegin)+"</font></b><br>"
Next nBegin*/
cMsg += "    </td>"
cMsg += "  </tr>"
cMsg += "  <tr>"
//cMsg += "    <td width='723' height='19' colspan='3'>"
//cMsg += "      <pre><b><font face='Arial' size='2'>NOTAS:</font></b><br>"
//cMsg += "<pre><font face='Arial' size='2'><b>1) VALOR MÍNIMO PARA VENDA R$ 150,00. &nbsp;<br>" 
//cMsg += "2) VALOR MÍNIMO PARA FATURAMENTO E ENTREGA R$ 300,00 (SOMENTE ALGUNS BAIRROS DA GRANDE SP).&nbsp;<br>"
//cMsg += "3) O PEDIDO SÓ SERÁ VALIDADO APÓS O ACEITE FORMAL DO CLIENTE. </b></font></pre>"
//cMsg += "    </td>"
cMsg += "  </tr>"
cMsg += "</table>"
cMsg += "</body>"
cMsg += "</html>" 

EnvEMail() 

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ENVEMAIL ³ Autor ³ Altair Teixeira       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia e-mail da Cotação para o Fornecedor                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function EnvEmail()
Local nI        := 1
Local cMensagem := ''
Local CRLF      := Chr(13) + Chr(10)
Local cAnexos:=""                      
psworder(2)  // email e nome do comprador
if pswseek(Substr(cUsuario,7,15),.t.)
   _daduser:=pswret(1)
   _cDe   := Alltrim(_daduser[1,14])
   cCompr := Alltrim(_daduser[1,4])
endif


Private cServer  := Trim(GetMV("MV_RELSERV")) // smtp.tecnotron.ind.br
Private cEmail   := Trim(GetMV("MV_RELACNT")) // 
Private cPass    := Trim(GetMV("MV_RELPSW"))  // 


For nI:=1 to Len(aTarget)
  cAnexos+=aTarget[nI]+";"  
Next
cAnexos:=Left(cAnexos,Len(cAnexos)-1)

cMensagem := 'Encaminhamos nosso Pedido de Venda abaixo, conforme sua cotação. '+CRLF+CRLF +;
			 'Ficamos no aguardo da confirmação de recebimento, bem como, aceite do mesmo.'+ CRLF+CRLF+;
			 'Qualquer dúvida, por favor, entrar em contato.'+ CRLF+CRLF+;
			 'Atenciosamente,'+CRLF+CRLF+;
			 cCompr+CRLF+_cDe+CRLF+CRLF+'Departamento de Vendas'+CRLF
If lCheck1==.T. // Deseja receber cópia
   If !Empty(_cCc)
     _cCc := Alltrim(_cCc+";"+_cDe)
   Else
     _cCc := Alltrim(_cDe)     
   Endif  
Endif			 
CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lOk

//If (lOk)
   lRet := Mailauth(cEmail,cPass)
If lRet  
   If lCheck2==.T. // Deseja receber confirmação de leitura
      ConfirmMailRead(.T.)
   Endif          
   SEND MAIL FROM _cDe; 
               TO alltrim(_cPara);
               CC _cCc;
              BCC _cCco;
  	      SUBJECT cSubject ;
		     BODY cMensagem + CRLF + cMsg ;
	   ATTACHMENT cAnexos;
           RESULT lOK
   If lCheck2==.T. // Deseja receber confirmação de leitura
      ConfirmMailRead(.F.) 
   Endif   
   DISCONNECT SMTP SERVER 
Endif 
If (lOk)
   MsgAlert("Pedido Enviado com Sucesso!", "ENVIO OK")
Else
   MsgStop("Pedido não pode ser Enviado!", "FALHA NO ENVIO")
Endif      


Return