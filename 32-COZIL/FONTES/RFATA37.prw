#include "Protheus.ch"
#include "rwmake.ch"  
#Include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RFATA37  ³ Autor ³ Elvis Kinuta     ³ Data ³ Julho/2010      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Painel de pedidos                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATA37()

Local oDlg1 := ""     
Local aCores    := {{ "C6_XSTATUS == '1'",'BR_VERDE'},;	
                    { "C6_XSTATUS == '2'",'BR_AZUL'},;	
					{ "C6_XSTATUS == '3'",'BR_AMARELO'},;	
					{ "C6_XSTATUS == '4'",'BR_LARANJA'},;	
					{ "C6_XSTATUS == '5'",'BR_PINK'},;	
					{ "C6_XSTATUS == '6'",'BR_CINZA'},;	
					{ "C6_XSTATUS == '7'",'BR_BRANCO'},;	
					{ "C6_XSTATUS == '8'",'BR_MARROM'},;	
					{ "C6_XSTATUS == '9'",'BR_VERMELHO'},;	
					{ "C6_XSTATUS == 'A'",'BR_PRETO'}}	

Local cCondicao := ""
 
Private aIndSC6 := {}
Private bFiltraBrw := {|| Nil}
Private cFiltraSC6
Private cCadastro   := "Painel de Pedidos de Vendas"

Private aRotina	     	:= {{ "PESQUISAR"       , "AxPesqui"      	, 0, 1 },;	
			  		 		{ "VISUALIZAR"      , "U_FATA80()"    	, 0, 2 },;  
							{ "PROJETO"         , "U_FATA37A()"   	, 0, 4 },; 
							{ "APROVACAO"       , "U_FATA37B()"   	, 0, 4 },;
							{ "USR. DESENVOLV." , "U_FATA37CUSR()"  , 0, 4 },;
							{ "DESENVOLVIMENTO" , "U_FATA37C()"   	, 0, 4 },;
							{ "PROGRAMACAO"     , "U_FATA37D()"   	, 0, 4 },;
							{ "CORTE"           , "U_FATA37E()"   	, 0, 4 },;
							{ "MONTAGEM"        , "U_FATA37F()"   	, 0, 4 },;
							{ "EXPEDICAO"       , "U_FATA37G()"   	, 0, 4 },;
							{ "LOGISTICA"       , "U_FATA37H()"   	, 0, 4 },;
                            { "LEGENDA"         , "U_FATA37L()"   	, 0, 4 }}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Filtragem                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SC6")
DbSetorder(1)    
 
cFiltraSC6 := "C6_FILIAL = '"+xFilial("SC6")+"' .And. C6_XFILTRO <> '1' " 
 
bFiltraBrw := {|| FilBrowse("SC6",@aIndSC6,@cFiltraSC6) }   
 
Eval(bFiltraBrw)         
                
mBrowse(06,01,22,75,"SC6",,,,,,aCores)
 
 
Return(bFiltraBrw)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATA37L   ³Autor  ³                       ³ Data ³28/10/2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Demonstra a legenda das cores da mbrowse                     ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina monta uma dialog com a descricao das cores da    ³±±
±±³          ³Mbrowse.                                                     ³±±
±±³          ³                                                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FATA37L()

BrwLegenda(cCadastro,"Lengenda" ,{{"BR_VERDE"	  ,"ATUALMENTE EM PROJETOS"	},;
								   {"BR_AZUL"	  ,"ATUALMENTE EM APROVACAO"},;
								   {"BR_AMARELO"  ,"ATUALMENTE EM DESENVOLVIMENTO"},;
								   {"BR_LARANJA"  ,"ATUALMENTE EM PROGRAMACAO"},;
								   {"BR_PINK"     ,"ATUALMENTE EM CORTE"},;
								   {"BR_CINZA"    ,"ATUALMENTE EM MONTAGEM"},;
								   {"BR_BRANCO"   ,"ATUALMENTE EM EXPEDICAO"},;
								   {"BR_MARROM  " ,"ATUALMENTE EM LOGISTICA"},;
								   {"BR_VERMELHO" ,"FINALIZADO"},;
								   {"BR_PRETO"    ,"EM ANALISE DE CREDITO"}})                    
Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATA37A   ³Autor  ³ Elvis Kinuta          ³ Data ³30.09.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Passa o status do pedido para    APROVACAO                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATA37A()

Local aSays    := {}             
Local aButtons := {}
Local nOpca    := 0
Local _cUser 	:= cUserName
                       
//VERIFICA SE O ITEM ESTA REALMENTE APTO A PASSAR POR ESTA ROTINA
If (SC6->C6_XSTATUS != "1")
 	Alert("Esta aprovacao apenas pode ser realizada com a OP no primeiro status")
  	Return()	
EndIf


AADD(aSays,OemToAnsi( "Esta rotina realizara a passagem do status do pedido para PROJETO" ) )

cCadastro := OemToAnsi("Status PROJETO") 

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } ) // OK
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )             // CANCELA


FormBatch( cCadastro, aSays, aButtons )


DbSelectArea("SC6")
DbSetOrder()

If nOpca == 1  

_cNomcli 	:= POSICIONE("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NOME")
_cPed       := POSICIONE("SC5",1,xFilial("SC5")+SC6->C6_NUM,"C5_NUM")
_cOBS   	:= SC6->C6_XOBSPRJ
_cNUMOP   	:= SC6->C6_XOP
_cPDESC   	:= SC6->C6_DESCRI
	
         //____Nome dos Campos do BROWSE______
@ 151,252 To 562,834 Dialog oDlg1 Title OemToAnsi("OBSERVACAO PROJETO") 
@ 012,017 Say OemToAnsi("PEDIDO")               Size 35,8
@ 035,017 Say OemToAnsi("CLIENTE")              Size 35,8
@ 057,017 Say OemToAnsi("NUM. OP")              Size 35,8 
@ 080,017 Say OemToAnsi("PRODUTO")              Size 35,8
@ 103,017 Say OemToAnsi("OBSERVACAO")           Size 35,8
          
          //_____CONTEUDO DO CAMPO______
@ 012,054 Get _cPed                                 Size 30,10        When .F. //"When .F." = SOMENTE VISUALIZA
@ 035,054 Get _cNomcli                              Size 200,10       When .F.
@ 057,054 Get _cNUMOP                               Size  30,10       When .F. 
@ 080,054 Get _cPDESC                               Size 200,10       When .F.
@ 103,054 Get _cOBS                                 Size 200,10                  

	@ 190,094 BMPBUTTON TYPE 01 Action U_cozila()
	@ 190,156 BMPBUTTON TYPE 02 Action Close(oDlg1)
	Activate Dialog oDlg1 CENTERED     
Endif

User Function cozila()
 	RecLock("SC6",.F.)
   		SC6->C6_XOBSPRJ	:= _cOBS
   		SC6->C6_XSTATUS 	:= "2"
   		SC6->C6_XDTPRJ  	:= Date()
   		SC6->C6_XHRPRJ  	:= Time ()
	MsUnlock()
	Close(oDlg1)
return


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATA37B   ³Autor  ³Elvis Kinuta           ³ Data ³02.09.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Passa o status do pedido para Para a DESENVOLVIMENTO         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATA37B()

Local aSays    := {}             
Local aButtons := {}
Local nOpca    := 0
                   
//VERIFICA SE O ITEM ESTA REALMENTE APTO A PASSAR POR ESTA ROTINA
If (SC6->C6_XSTATUS != "2")
 	Alert("Esta opcao esta disponivel apenas com a OP com o status em PROJETOS")
  	Return()	
EndIf

AADD(aSays,OemToAnsi( "Esta rotina realizara a passagem do status do pedido para Para a APROVACAO" ) )

cCadastro := OemToAnsi("Status APROVACAO") 

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
 
_cNomcli 	:= POSICIONE("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NOME")
_cPed     := SC5->C5_NUM 
_cOBSB   	:= SC6->C6_XOBSAPR
_cNUMOP  	:= SC6->C6_XOP
_cPDESC   := SC6->C6_DESCRI


         //____Nome dos Campos do BROWSE______
@ 151,252 To 562,834 Dialog oDlg1 Title OemToAnsi("OBSERVACAO APROVACAO") 
@ 012,017 Say OemToAnsi("PEDIDO")               Size 35,8
@ 035,017 Say OemToAnsi("CLIENTE")              Size 35,8
@ 057,017 Say OemToAnsi("NUM. OP")              Size 35,8 
@ 080,017 Say OemToAnsi("PRODUTO")              Size 35,8
@ 103,017 Say OemToAnsi("OBSERVACAO")           Size 35,8

          
          //_____CONTEUDO DO CAMPO______
@ 012,054 Get _cPed                                 Size 30,10        When .F. //"When .F." = SOMENTE VISUALIZA
@ 035,054 Get _cNomcli                              Size 200,10       When .F.
@ 057,054 Get _cNUMOP                               Size  30,10       When .F. 
@ 080,054 Get _cPDESC                               Size 200,10       When .F.
@ 103,054 Get _cOBSB                                Size 200,10         

	@ 190,094 BMPBUTTON TYPE 01 Action U_cozilb()
	@ 190,156 BMPBUTTON TYPE 02 Action Close(oDlg1)
	Activate Dialog oDlg1 CENTERED     
Endif



User Function cozilb()
  
    RecLock("SC6",.F.)
	   SC6->C6_XOBSAPR 	:= _cOBSB 
	   SC6->C6_XSTATUS 	:= "3"
	   SC6->C6_XDTAPR  	:= Date()
	   SC6->C6_XHRAPR  	:= Time ()
  	MsUnlock()
	Close(oDlg1)


Return 




/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATA37C   ³Autor  ³ Elvis Kinuta          ³ Data ³02.09.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Passa o status do pedido  PROGRAMACAO	                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATA37C()

Local aSays    := {}             
Local aButtons := {}
Local nOpca    := 0
                                                         
//VERIFICA SE O ITEM ESTA REALMENTE APTO A PASSAR POR ESTA ROTINA
If (SC6->C6_XSTATUS != "3")
 	Alert("Esta opcao esta disponivel apenas com a OP com o status APROVACAO DO CLIENTE")
  	Return()	
EndIf

AADD(aSays,OemToAnsi( "Esta rotina realizara a passagem do status do pedido para DESENVOLVIMENTO" ) )

cCadastro := OemToAnsi("Status DESENVOLVIMENTO") 

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1

_cNomcli 	:= POSICIONE("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NOME")
_cPed     := SC5->C5_NUM 
_cOBSC   	:= SC6->C6_XOBSDES
_cNUMOP  	:= SC6->C6_XOP
_cPDESC   := SC6->C6_DESCRI
_cUSRD    := SC6->C6_XUSRDES


         //____Nome dos Campos do BROWSE______
@ 151,252 To 562,834 Dialog oDlg1 Title OemToAnsi("OBSERVACAO DESENVOLVIMENTO") 
@ 012,017 Say OemToAnsi("PEDIDO")               Size 35,8
@ 035,017 Say OemToAnsi("CLIENTE")              Size 35,8
@ 057,017 Say OemToAnsi("NUM. OP")              Size 35,8 
@ 080,017 Say OemToAnsi("PRODUTO")              Size 35,8
@ 103,017 Say OemToAnsi("OBSERVACAO")           Size 35,8 
@ 126,017 Say OemToAnsi("USR. RESP.")           Size 35,8

          
          //_____CONTEUDO DO CAMPO______
@ 012,054 Get _cPed                                 Size 30,10        When .F. //"When .F." = SOMENTE VISUALIZA
@ 035,054 Get _cNomcli                              Size 200,10       When .F.
@ 057,054 Get _cNUMOP                               Size  30,10       When .F. 
@ 080,054 Get _cPDESC                               Size 200,10       When .F.
@ 103,054 Get _cOBSC                                Size 200,10          
@ 126,054 Get _cUSRD                                Size 30,10         

	@ 190,094 BMPBUTTON TYPE 01 Action U_cozilc()
	@ 190,156 BMPBUTTON TYPE 02 Action Close(oDlg1)
	Activate Dialog oDlg1 CENTERED     
Endif



User Function cozilc()
  
    RecLock("SC6",.F.)
		SC6->C6_XOBSDES 	:= _cOBSC   
		SC6->C6_XSTATUS 	:= "4"
		SC6->C6_XDTDES  	:= Date()
		SC6->C6_XHRDES  	:= Time ()
    MsUnlock()
	Close(oDlg1)


Return 


/*__________________________________________________
Gravacao do Usuario responsavel pelo Desenvolvimeto
____________________________________________________*/


User Function FATA37CUSR()

Local aSays    := {}             
Local aButtons := {}
Local nOpca    := 0

AADD(aSays,OemToAnsi( "Esta rotina realizara a gravacao do usuario responsavel pelo DESENVOLVIMENTO" ) )

cCadastro := OemToAnsi("Status DESENVOLVIMENTO") 

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1

_cNomcli 	:= POSICIONE("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NOME")
_cPed       := SC5->C5_NUM 
_cOBSC   	:= SC6->C6_XOBSDES
_cNUMOP   	:= SC6->C6_XOP
_cPDESC   	:= SC6->C6_DESCRI
_cUSRD       := SC6->C6_XUSRDES

  

         //____Nome dos Campos do BROWSE______
@ 151,252 To 562,834 Dialog oDlg1 Title OemToAnsi("OBSERVACAO DESENVOLVIMENTO") 
@ 012,017 Say OemToAnsi("PEDIDO")               Size 35,8
@ 035,017 Say OemToAnsi("CLIENTE")              Size 35,8
@ 057,017 Say OemToAnsi("NUM. OP")              Size 35,8 
@ 080,017 Say OemToAnsi("PRODUTO")              Size 35,8
@ 103,017 Say OemToAnsi("OBSERVACAO")           Size 35,8 
@ 126,017 Say OemToAnsi("USR. RESP.")           Size 35,8

          
          //_____CONTEUDO DO CAMPO______
@ 012,054 Get _cPed                                 Size 30,10        When .F. //"When .F." = SOMENTE VISUALIZA
@ 035,054 Get _cNomcli                              Size 200,10       When .F.
@ 057,054 Get _cNUMOP                               Size  30,10       When .F. 
@ 080,054 Get _cPDESC                               Size 200,10       When .F.
@ 103,054 Get _cOBSC                                Size 200,10       When .F.   
@ 126,054 Get _cUSRD                                Size 30,10         

	@ 190,094 BMPBUTTON TYPE 01 Action U_cozilcusr()
	@ 190,156 BMPBUTTON TYPE 02 Action Close(oDlg1)
	Activate Dialog oDlg1 CENTERED     
Endif



User Function cozilcusr()
  
    RecLock("SC6",.F.)
   		SC6->C6_XOBSDES := _cOBSC
   		SC6->C6_XUSRDES := _cUSRD
   MsUnlock()
	Close(oDlg1)


Return 


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATA37D   ³Autor  ³ Elvis Kinuta          ³ Data ³02.09.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Passa o status do pedido para CORTE                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATA37D()

Local aSays    := {}             
Local aButtons := {}
Local nOpca    := 0

//VERIFICA SE O ITEM ESTA REALMENTE APTO A PASSAR POR ESTA ROTINA
If (SC6->C6_XSTATUS != "4")
 	Alert("Esta opcao esta disponivel apenas com a OP com o status em DESENVOLVIMENTO")
  	Return()	
EndIf

AADD(aSays,OemToAnsi( "Esta rotina realizara a passagem do status do pedido PROGRAMACAO" ) )

cCadastro := OemToAnsi("Status PROGRAMACAO") 

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
_cNomcli 	:= POSICIONE("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NOME")
_cPed       := SC5->C5_NUM 
_cOBSPRG   	:= SC6->C6_XOBSPRG
_cNUMOP   	:= SC6->C6_XOP
_cPDESC   	:= SC6->C6_DESCRI

         //____Nome dos Campos do BROWSE______
@ 151,252 To 562,834 Dialog oDlg1 Title OemToAnsi("OBSERVACAO PROGRAMACAO") 
@ 012,017 Say OemToAnsi("PEDIDO")               Size 35,8
@ 035,017 Say OemToAnsi("CLIENTE")              Size 35,8
@ 057,017 Say OemToAnsi("NUM. OP")              Size 35,8 
@ 080,017 Say OemToAnsi("PRODUTO")              Size 35,8
@ 103,017 Say OemToAnsi("OBSERVACAO")           Size 35,8

          
          //_____CONTEUDO DO CAMPO______
@ 012,054 Get _cPed                                 Size 30,10        When .F. //"When .F." = SOMENTE VISUALIZA
@ 035,054 Get _cNomcli                              Size 200,10       When .F.
@ 057,054 Get _cNUMOP                               Size  30,10       When .F. 
@ 080,054 Get _cPDESC                               Size 200,10       When .F.
@ 103,054 Get _cOBSPRG                              Size 200,10         

	@ 190,094 BMPBUTTON TYPE 01 Action U_cozild()
	@ 190,156 BMPBUTTON TYPE 02 Action Close(oDlg1)
	Activate Dialog oDlg1 CENTERED     
Endif



User Function cozild()
  
	RecLock("SC6",.F.)
		SC6->C6_XOBSPRG 	:= _cOBSPRG
		SC6->C6_XSTATUS 	:= "5"
		SC6->C6_XDTPRG  	:= Date()
		SC6->C6_XHRPRG  	:= Time ()
 	MsUnlock()
	Close(oDlg1)

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATA37E   ³Autor  ³ Elvis Kinuta          ³ Data ³02.09.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Passa o status do pedido para MONTAGEM                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATA37E()

Local aSays    := {}             
Local aButtons := {}
Local nOpca    := 0                   

//VERIFICA SE O ITEM ESTA REALMENTE APTO A PASSAR POR ESTA ROTINA
If (SC6->C6_XSTATUS != "5")
 	Alert("Esta opcao esta disponivel apenas com a OP com o status em PROGRAMACAO")
  	Return()	
EndIf

AADD(aSays,OemToAnsi( "Esta rotina realizara a passagem do status do pedido para CORTE" ) )

cCadastro := OemToAnsi("Status CORTE") 

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
_cNomcli 	:= POSICIONE("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NOME")
_cPed       := SC5->C5_NUM 
_cOBSCRT   	:= SC6->C6_XOBSCRT
_cNUMOP   	:= SC6->C6_XOP
_cPDESC   	:= SC6->C6_DESCRI


         //____Nome dos Campos do BROWSE______
@ 151,252 To 562,834 Dialog oDlg1 Title OemToAnsi("OBSERVACAO CORTE") 
@ 012,017 Say OemToAnsi("PEDIDO")               Size 35,8
@ 035,017 Say OemToAnsi("CLIENTE")              Size 35,8
@ 057,017 Say OemToAnsi("NUM. OP")              Size 35,8 
@ 080,017 Say OemToAnsi("PRODUTO")              Size 35,8
@ 103,017 Say OemToAnsi("OBSERVACAO")           Size 35,8

          
          //_____CONTEUDO DO CAMPO______
@ 012,054 Get _cPed                                 Size 30,10        When .F. //"When .F." = SOMENTE VISUALIZA
@ 035,054 Get _cNomcli                              Size 200,10       When .F.
@ 057,054 Get _cNUMOP                               Size  30,10       When .F. 
@ 080,054 Get _cPDESC                               Size 200,10       When .F.
@ 103,054 Get _cOBSCRT                              Size 200,10         

	@ 190,094 BMPBUTTON TYPE 01 Action U_cozile()
	@ 190,156 BMPBUTTON TYPE 02 Action Close(oDlg1)
	Activate Dialog oDlg1 CENTERED     
Endif



User Function cozile()
  
	RecLock("SC6",.F.)
		SC6->C6_XOBSCRT 	:= _cOBSCRT
		SC6->C6_XSTATUS 	:= "6"
   		SC6->C6_XDTCRT  	:= Date()
   		SC6->C6_XHRCRT  	:= Time ()
	MsUnlock()
	Close(oDlg1)
	
Return 

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATA37F   ³Autor  ³ Elvis Kinuta          ³ Data ³02.09.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Passa o status do pedido para EXPEDICAO                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATA37F()

Local aSays    := {}             
Local aButtons := {}
Local nOpca    := 0                                                           

//VERIFICA SE O ITEM ESTA REALMENTE APTO A PASSAR POR ESTA ROTINA
If (SC6->C6_XSTATUS != "6")
 	Alert("Esta opcao esta disponivel apenas com a OP com o status em CORTE")
  	Return()	
EndIf

AADD(aSays,OemToAnsi( "Esta rotina realizara a passagem do status do pedido para MONTAGEM" ) )

cCadastro := OemToAnsi("Status MONTAGEM") 

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
_cNomcli 	:= POSICIONE("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NOME")
_cPed     := SC5->C5_NUM 
_cOBSMTG  := SC6->C6_XOBSMTG
_cNUMOP   := SC6->C6_XOP
_cPDESC   := SC6->C6_DESCRI


         //____Nome dos Campos do BROWSE______
@ 151,252 To 562,834 Dialog oDlg1 Title OemToAnsi("OBSERVACAO MONTAGEM") 
@ 012,017 Say OemToAnsi("PEDIDO")               Size 35,8
@ 035,017 Say OemToAnsi("CLIENTE")              Size 35,8
@ 057,017 Say OemToAnsi("NUM. OP")              Size 35,8 
@ 080,017 Say OemToAnsi("PRODUTO")              Size 35,8
@ 103,017 Say OemToAnsi("OBSERVACAO")           Size 35,8

          
          //_____CONTEUDO DO CAMPO______
@ 012,054 Get _cPed                                 Size 30,10        When .F. //"When .F." = SOMENTE VISUALIZA
@ 035,054 Get _cNomcli                              Size 200,10       When .F.
@ 057,054 Get _cNUMOP                               Size  30,10       When .F. 
@ 080,054 Get _cPDESC                               Size 200,10       When .F.
@ 103,054 Get _cOBSMTG                              Size 200,10         

	@ 190,094 BMPBUTTON TYPE 01 Action U_cozilf()
	@ 190,156 BMPBUTTON TYPE 02 Action Close(oDlg1)
	Activate Dialog oDlg1 CENTERED     
Endif



User Function cozilf()
  
	RecLock("SC6",.F.)
		SC6->C6_XOBSMTG 	:= _cOBSMTG
		SC6->C6_XSTATUS 	:= "7"
		SC6->C6_XDTMTG  	:= Date()
		SC6->C6_XHRMTG  	:= Time ()
	MsUnlock()
	Close(oDlg1)


Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATA37G   ³Autor  ³ Elvis Kinuta          ³ Data ³02.09.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Passa o status do pedido para LOGISTICA                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATA37G()

Local aSays    := {}             
Local aButtons := {}
Local nOpca    := 0                                                           

//VERIFICA SE O ITEM ESTA REALMENTE APTO A PASSAR POR ESTA ROTINA
If (SC6->C6_XSTATUS != "7")
 	Alert("Esta opcao esta disponivel apenas com a OP com o status em MONTAGEM")
  	Return()	
EndIf

AADD(aSays,OemToAnsi( "Esta rotina realizara a passagem do status do pedido para EXPEDICAO" ) )

cCadastro := OemToAnsi("Status EXPEDICAO") 

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
_cNomcli 	:= POSICIONE("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NOME")
_cPed     := SC5->C5_NUM 
_cOBSEXP  := SC6->C6_XOBSEXP
_cNUMOP   := SC6->C6_XOP
_cPDESC   	:= SC6->C6_DESCRI


         //____Nome dos Campos do BROWSE______
@ 151,252 To 562,834 Dialog oDlg1 Title OemToAnsi("OBSERVACAO EXPEDICAO") 
@ 012,017 Say OemToAnsi("PEDIDO")               Size 35,8
@ 035,017 Say OemToAnsi("CLIENTE")              Size 35,8
@ 057,017 Say OemToAnsi("NUM. OP")              Size 35,8 
@ 080,017 Say OemToAnsi("PRODUTO")              Size 35,8
@ 103,017 Say OemToAnsi("OBSERVACAO")           Size 35,8

          
          //_____CONTEUDO DO CAMPO______
@ 012,054 Get _cPed                                 Size 30,10        When .F. //"When .F." = SOMENTE VISUALIZA
@ 035,054 Get _cNomcli                              Size 200,10       When .F.
@ 057,054 Get _cNUMOP                               Size  30,10       When .F. 
@ 080,054 Get _cPDESC                               Size 200,10       When .F.
@ 103,054 Get _cOBSEXP                              Size 200,10         

	@ 190,094 BMPBUTTON TYPE 01 Action U_cozilg()
	@ 190,156 BMPBUTTON TYPE 02 Action Close(oDlg1)
	Activate Dialog oDlg1 CENTERED     
Endif



User Function cozilg()
  
	RecLock("SC6",.F.)
   		SC6->C6_XOBSEXP 	:= _cOBSEXP
   		SC6->C6_XSTATUS 	:= "8"
   		SC6->C6_XDTEXP  	:= Date()
   		SC6->C6_XHREXP  	:= Time ()
	MsUnlock()
	Close(oDlg1)

Return
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATA37H   ³Autor  ³ Elvis Kinuta          ³ Data ³02.09.2010 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Passa o status do pedido para FINALIZADO                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATA37H()

Local aSays    := {}             
Local aButtons := {}
Local nOpca    := 0                                  

//VERIFICA SE O ITEM ESTA REALMENTE APTO A PASSAR POR ESTA ROTINA
If (SC6->C6_XSTATUS != "8")
 	Alert("Esta opcao esta disponivel apenas com a OP com o status em EXPEDICAO")
  	Return()	
EndIf

AADD(aSays,OemToAnsi( "Esta rotina realizara a passagem do status do pedido para LOGISTICA" ) )

Cadastro := OemToAnsi("Status LOGISTICA") 

AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End() } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
_cNomcli 	:= POSICIONE("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NOME")
_cPed     := SC5->C5_NUM 
_cOBSLOG  := SC6->C6_XOBSLOG
_cNUMOP   := SC6->C6_XOP
_cPDESC   := SC6->C6_DESCRI


         //____Nome dos Campos do BROWSE______
@ 151,252 To 562,834 Dialog oDlg1 Title OemToAnsi("OBSERVACAO LOGOSTICA") 
@ 012,017 Say OemToAnsi("PEDIDO")               Size 35,8
@ 035,017 Say OemToAnsi("CLIENTE")              Size 35,8
@ 057,017 Say OemToAnsi("NUM. OP")              Size 35,8 
@ 080,017 Say OemToAnsi("PRODUTO")              Size 35,8
@ 103,017 Say OemToAnsi("OBSERVACAO")           Size 35,8

          
          //_____CONTEUDO DO CAMPO______
@ 012,054 Get _cPed                                 Size 30,10        When .F. //"When .F." = SOMENTE VISUALIZA
@ 035,054 Get _cNomcli                              Size 200,10       When .F.
@ 057,054 Get _cNUMOP                               Size  30,10       When .F. 
@ 080,054 Get _cPDESC                               Size 200,10       When .F.
@ 103,054 Get _cOBSLOG                              Size 200,10         

	@ 190,094 BMPBUTTON TYPE 01 Action U_cozilh()
	@ 190,156 BMPBUTTON TYPE 02 Action Close(oDlg1)
	Activate Dialog oDlg1 CENTERED     
Endif



User Function cozilh()
  
	RecLock("SC6",.F.)
		SC6->C6_XOBSLOG 	:= _cOBSLOG
		SC6->C6_XSTATUS 	:= "9"
		SC6->C6_XDTLOG  	:= Date()
   		SC6->C6_XHRLOG  	:= Time ()
	MsUnlock()
	Close(oDlg1)

Return    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³ RFATA31  ³ Autor ³ ELVIS KINUTA          ³ Data ³ 21/05/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Rotina de Alteracao de Dados Pedidos de Vendas             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico - FLC                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FATA80()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local 	_cNomcli	:= Space(60)
Local 	_cPed       := SC6->C6_NUM
Local	nQtdLib	    := ""


		_cNomcli 	:= POSICIONE("SA1",1,xFilial("SA1")+SC6->C6_CLI,"A1_NOME")
	
		nQtdLib		:= Posicione("SC9",1,xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM,"C9_QTDLIB") 	
		nBlest		:= Posicione("SC9",1,xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM,"C9_BLEST") 			
		
Private _cOp     	:= SC6->C6_XOP
Private _cProd   	:= SC6->C6_PRODUTO
Private _cQnt    	:= SC6->C6_QTDVEN
Private _nVlru   	:= SC6->C6_PRCVEN
Private _nVlrt   	:= SC6->C6_VALOR

If Empty(nBlest)
nQuantp := 	_cQnt-nQtdLib
ElseIf nBlest == "10"   
nQuantp := 	_cQnt-nQtdLib
ElseIf	nBlest == "02"
nQuantp :=	_cQnt
ElseIf 	nBlest == "03"
nQuantp := 	nQtdLib
EndIf

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FATA29B   ³ Autor ³ ELVIS KLIAMCA         ³ Data ³ 21.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³                Criacao da interface                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
@ 151,252 To 790,1034 Dialog oDlg1 Title OemToAnsi("Dados da Pedido")  //850 é o tamanho do quadrado 
@ 010,017 Say OemToAnsi("PEDIDO:")          	    Size 40,8 
@ 010,120 Say OemToAnsi("OP:")             	      	Size 40,8
@ 030,017 Say OemToAnsi("CLIENTE:")        	       	Size 40,8
@ 050,017 Say OemToAnsi("PRODUTO:")        	       	Size 40,8
@ 050,120 Say OemToAnsi("QUANTIDADE:")     	       	Size 40,8
//@ 070,017 Say OemToAnsi("VLR UNITARIO:") 	        Size 40,8
//@ 070,120 Say OemToAnsi("VLR TOTAL:") 	            Size 40,8
@ 070,017 Say OemToAnsi("ESPECIFICACOES TECNICAS:")	Size 80,8
@ 071,017 Say OemToAnsi("_____________________")	Size 80,8
@ 070,200 Say OemToAnsi("Acessorio 01:")	Size 80,8
@ 110,200 Say OemToAnsi("Acessorio 02:")	Size 80,8
@ 150,200 Say OemToAnsi("Acessorio 03:")	Size 80,8
@ 190,200 Say OemToAnsi("Acessorio 04:")	Size 80,8
@ 230,200 Say OemToAnsi("Acessorio 05:")	Size 80,8


@ 010,062 Get _cPed                                	Size 50,10        When .F. 
@ 010,165 Get _cOp                                 	Size 50,10        When .F.
@ 030,062 Get _cNomcli                             	Size 160,10       When .F.
@ 050,062 Get _cProd                               	Size 50,10        When .F.
@ 050,165 Get nQuantp  Picture "@E 999,999,999.99" 	Size 50,10        When .F.          
//@ 070,062 Get _nVlru  Picture "@E 999,999,999.99"	Size 50,10        When .F. 
//@ 070,165 Get _nVlrt  Picture "@E 999,999,999.99"	Size 50,10        When .F.

cCac1	:=	SC6->C6_XAC1    //	Codigo do Acessorio 01
cCac2	:=	SC6->C6_XAC2	//	Codigo do Acessorio 02
cCac3	:=	SC6->C6_XAC3	//	Codigo do Acessorio 03
cCac4	:=	SC6->C6_XAC4	//	Codigo do Acessorio 04
cCac5	:=	SC6->C6_XAC5	//	Codigo do Acessorio 05
cDac1	:= 	SC6->C6_XDAC1  	//	Descricao do Acessorio 01            
cDac2	:= 	SC6->C6_XDAC2   //	Descricao do Acessorio 02              
cDac3	:= 	SC6->C6_XDAC3   //	Descricao do Acessorio 03           
cDac4	:= 	SC6->C6_XDAC4   //	Descricao do Acessorio 04             
cDac5	:= 	SC6->C6_XDAC5	//	Descricao do Acessorio 05

@ 069,250 Get cCac1                               	Size 50,10        When .F.
@ 109,250 Get cCac2                               	Size 50,10        When .F.
@ 149,250 Get cCac3                               	Size 50,10        When .F.
@ 189,250 Get cCac4                               	Size 50,10        When .F.
@ 229,250 Get cCac5                               	Size 50,10        When .F.
@  80,200 Get cDac1                             	Size 160,10       When .F.
@ 120,200 Get cDac2                             	Size 160,10       When .F.
@ 160,200 Get cDac3                             	Size 160,10       When .F.
@ 200,200 Get cDac4                             	Size 160,10       When .F.
@ 240,200 Get cDac5                             	Size 160,10       When .F.

  
cMemo     := Posicione("SC6",1,xFilial("SC6")+SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO,"C6_XESPEC")	 
                                          
@ 095,017 Say OemToAnsi (Memoline(cMemo,62,01,))                             	Size 160,10           
@ 100,017 Say OemToAnsi (Memoline(cMemo,62,02,))                             	Size 160,10            
@ 105,017 Say OemToAnsi (Memoline(cMemo,62,04,))                             	Size 160,10            
@ 110,017 Say OemToAnsi (Memoline(cMemo,62,05,))                             	Size 160,10           
@ 115,017 Say OemToAnsi (Memoline(cMemo,62,06,))                             	Size 160,10           
@ 120,017 Say OemToAnsi (Memoline(cMemo,62,07,))                             	Size 160,10           
@ 125,017 Say OemToAnsi (Memoline(cMemo,62,08,))                             	Size 160,10           
@ 130,017 Say OemToAnsi (Memoline(cMemo,62,09,))                             	Size 160,10           
@ 140,017 Say OemToAnsi (Memoline(cMemo,62,10,))                             	Size 160,10           
@ 145,017 Say OemToAnsi (Memoline(cMemo,62,11,))                             	Size 160,10           
@ 150,017 Say OemToAnsi (Memoline(cMemo,62,12,))                             	Size 160,10           
@ 155,017 Say OemToAnsi (Memoline(cMemo,62,13,))                             	Size 160,10           
@ 160,017 Say OemToAnsi (Memoline(cMemo,62,14,))                             	Size 160,10           
@ 165,017 Say OemToAnsi (Memoline(cMemo,62,15,))                             	Size 160,10           
@ 170,017 Say OemToAnsi (Memoline(cMemo,62,16,))                             	Size 160,10           
@ 175,017 Say OemToAnsi (Memoline(cMemo,62,17,))                             	Size 160,10           
@ 180,017 Say OemToAnsi (Memoline(cMemo,62,18,))                             	Size 160,10           
@ 185,017 Say OemToAnsi (Memoline(cMemo,62,19,))                             	Size 160,10           
@ 190,017 Say OemToAnsi (Memoline(cMemo,62,20,))                             	Size 160,10           
@ 195,017 Say OemToAnsi (Memoline(cMemo,62,21,))                             	Size 160,10           
@ 205,017 Say OemToAnsi (Memoline(cMemo,62,22,))                             	Size 160,10           
@ 210,017 Say OemToAnsi (Memoline(cMemo,62,23,))                             	Size 160,10           
@ 215,017 Say OemToAnsi (Memoline(cMemo,62,24,))                             	Size 160,10           
@ 220,017 Say OemToAnsi (Memoline(cMemo,62,25,))                             	Size 160,10           
@ 225,017 Say OemToAnsi (Memoline(cMemo,62,26,))                             	Size 160,10           
@ 230,017 Say OemToAnsi (Memoline(cMemo,62,27,))                             	Size 160,10           
@ 235,017 Say OemToAnsi (Memoline(cMemo,62,28,))                             	Size 160,10           
@ 240,017 Say OemToAnsi (Memoline(cMemo,62,29,))                             	Size 160,10           
@ 245,017 Say OemToAnsi (Memoline(cMemo,62,30,))                             	Size 160,10           
@ 250,017 Say OemToAnsi (Memoline(cMemo,62,31,))                             	Size 160,10           
@ 255,017 Say OemToAnsi (Memoline(cMemo,62,32,))                             	Size 160,10           
@ 260,017 Say OemToAnsi (Memoline(cMemo,62,33,))                             	Size 160,10           



@ 270,200 BMPBUTTON TYPE 01 Action Close(oDlg1)
Activate Dialog oDlg1 CENTERED     

Return
