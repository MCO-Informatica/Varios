#Include "Rwmake.ch"

/*
* Manutencao na Data do Limite do Orçamento
* R.Cavalini & de Paula Ltda.
* Ricardo Cavalini --> 17/07/2004 
*/

User Function verbco()

Dbselectarea("SE5")  
DbsetOrder(1)

aRotina:={{"Pesquisar"   ,"AxPesqui"   ,0,1},;
          {"Ajusta Vcto" ,"U_VERAJT()" ,0,4}}


//          {"Visualizar"  ,"AxVisual"   ,0,2},;
mBrowse( 6,1,22,75,"SE5",,,,,,,,)

Dbselectarea("SE5")  
DbSetOrder(1)

return

/*
Função de ajuste de data limite. 
*/
User Function VERAjt()       

_cNum         := SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA
_cNumCli      := POSICIONE("SA1",1,XFILIAL("SA1")+SE5->E5_CLIFOR+SE5->E5_LOJA,"A1_NOME")
_dEmis        := SE5->E5_DATA
_cMOT         := SE5->E5_MOTBX
_CBCO         := SE5->E5_BANCO
_cAG          := SE5->E5_AGENCIA
_cCC          := SE5->E5_CONTA

@ 000,000 To 245,410 Dialog oDlg0 Title "Pedido de Vendas." 
@ 010,005 SAY "Titulo :"
@ 010,040 Get _cNum SIZE 50,10 When .F.
@ 030,005 SAY "Cliente :"
@ 030,040 Get _cNumCli SIZE 150,10 When .F.
@ 050,005 Say "Data Emissao"
@ 050,060 Say "Motivo"
@ 050,130 Say "Banco"
@ 075,005 Say "Agencia"
@ 075,060 Say "Conta"
@ 060,005 Get _dEmis                             SIZE 50,10 
@ 060,055 Get _CMOT                              SIZE 50,10 
@ 060,130 Get _CBCO   F3 'SA6'                   SIZE 50,10
@ 085,005 Get _CAG                               SIZE 50,10
@ 085,055 Get _CCC                               SIZE 50,10 

@ 100,015 BmpButton Type 1 Action _ArsDtOk()
@ 100,130 BmpButton Type 2 Action _ArsFech()
Activate Dialog oDlg0 Centered
return

/*
Função de sair da tela de ajuste de data limite.
*/
Static Function _ArsDtOk()

Dbselectarea("SE5")
Reclock("SE5",.F.)     
  SE5->E5_DATA    := _dEmis
  SE5->E5_MOTBX   := _cMOT
  SE5->E5_BANCO   := _CBCO
  SE5->E5_AGENCIA := _CAG
  SE5->E5_CONTA   := _CCC
MsUnlock("SE5")
Close(oDlg0)
Return

Static function _ArsFech()
Close(oDlg0)
Return