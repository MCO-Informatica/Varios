User function F750BROW()

aRotina := u_MenuDef()



Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Ana Paula N. Silva     ³ Data ³28/11/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados     ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MenuDef()
Local aRot080 := {}
Local aRot050 := {}
Local aRot090 := {}
Local aRot240 := {}
Local aRot241 := {}
Local aRot290 := {}
Local aRot390 := {}
Local aRot580 := {}
Local aRot426 := {}
Local aRotina := {}
Local lAgrBot := GetNewPar("MV_BOTFUNP",.F.)	//Agrupa as Baixas e Borderos em sub-menus.
Local aRot080A:= {}
Local aRot240A:= {}

aRot080 :=	{	{ "Baixar", "Fin750080" , 0 , 4},; //"Baixar"
{ "Lote", "Fin750080" , 0 , 4},; //"Lote"
{ "Canc Baixa", "Fin750080" , 0 , 5},; //"Canc Baixa"
{ "Excluir Baixa", "Fin750080" , 0 , 5,53}} //"Excluir Baixa"

//Passado como parametro a posicao da opcao dentro da arotina
aRot050 :=	{	{ "Incluir", "Fin750050", 0 , 3},; //"Incluir"
{ "Alterar", "Fin750050", 0 , 4},;  //"Alterar"
{ "Excluir", "Fin750050", 0 , 5},; //"Excluir"
{ "Substituir", "Fin750050", 0 , 6} } //"Substituir"

If CtbInUse() .Or. MV_MULNATP
	Aadd(aRot050, { "Vis Rateio","Fin750050", 0 , 2}) //"Vis Rateio"
Endif

aRot090 :=	{	{ "Parâmetros", "Fin750090"   ,0,1},; //"Parâmetros"
{ "Automática", "Fin750090"   ,0,4} } //"Automática"

If cPaisLoc != "BRA"
	Aadd(aRot090, { "Cancela Chq","Fin750090", 0 , 2}) //"Cancela Chq"
EndIf

//aRot240 :=	{	{ "Borderô", "Fin750240",0,3},; //"Borderô"
//					{ "Cancelar", "Fin750240",0,3} } //"Cancelar"

aRot241 :=	{	{ "Borderô Imp.", "Fin750241",0,3},; //"Borderô Imp."
{ "Cancelar", "Fin750241",0,3} } //"Cancelar"

aRot290 :=	{	{ "Selecionar", "Fin750290",0,3},; //"Selecionar"
{ "Cancelar", "Fin750290",0,6} } //"Cancelar"

aRot340 :=	{	{ "Selecionar", "Fin750340",0,4},; //"Selecionar"
{"Cancelar", "Fin750340",0,6},; //"Cancelar"
{ "Estornar", "Fin750340",0,6} } //"Estornar"

aRot390 :=	{	{ "Chq s/Tit", "Fin750390",0,2},; //"Chq s/Tit"
{ "Avulsos", "Fin750390",0,2},; //"Avulsos"
{ "Redeposito", "Fin750390",0,2},; //"Redeposito"
{ "Cancelar", "Fin750390",0,3} } //"Cancelar"

aRot580 :=	{	{ "Manual", "Fin750580",0,2},; //"Manual"
{ "Automatica", "Fin750580",0,2},; //"Automatica"
{"Cancelar", "Fin750580",0,2} } //"Cancelar"

aRot426 :=	{	{ "Gerar Arquivo", "Fin750426",0,3},; //"Gerar Arquivo"
{ "Receber Arquivo", "Fin750426",0,0}	 } //"Receber Arquivo"

If lAgrBot
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Agrupa as baixas em sub-menus.							     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRot080A :=	{	{ "Bai&xa Manual",aRot080,0,4},;	//"Bai&xa Manual"
	{ "Baixa &Autom.",aRot090,0,4}}		//"Baixa &Autom."
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Agrupa os borderos em sub-menus.							 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	///	aRot240A :=	{	{ "Borderô",aRot240,0,3},; 	//"Borderô"
	///					{ "Borderô Imp.",aRot241,0,1} } 	//"Borderô Imp."
	aRot240A :=	{   { "Borderô Imp.",aRot241,0,1} } 	//"Borderô Imp."
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa 	  ³
//³ ----------- Elementos contidos por dimensao ------------	  ³
//³ 1. Nome a aparecer no cabecalho 									  ³
//³ 2. Nome da Rotina associada											  ³
//³ 3. Usado pela rotina													  ³
//³ 4. Tipo de Transa‡„o a ser efetuada								  ³
//³	 1 -Pesquisa e Posiciona em um Banco de Dados				  ³
//³	 2 -Simplesmente Mostra os Campos								  ³
//³	 3 -Inclui registros no Bancos de Dados						  ³
//³	 4 -Altera o registro corrente									  ³
//³	 5 -Exclui um registro cadastrado								  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aRotina,	{ "Pesquisar", "AxPesqui" , 0 , 1,,.F.})  //"Pesquisar"
aAdd( aRotina,	{ "Visualizar","Fa050Visua", 0 , 2})  //"Visualizar"
aAdd( aRotina,	{ "Contas a Pagar",aRot050, 0 , 3}) //"Contas a Pagar"
If !lAgrBot
	aAdd( aRotina,	{ "Baixa &Manual",aRot080, 0 , 5})  //"Baixa &Manual"
	aAdd( aRotina,	{ "Baixa &Autom.",aRot090, 0 , 4}) //"Baixa &Autom."
//	aAdd( aRotina,	{ "&Borderô",aRot240, 0 , 5}) //"&Borderô"
	aAdd( aRotina,	{ "Bo&rderô Imp.",aRot241, 0 , 5}) //"Bo&rderô Imp."
Else
	aAdd( aRotina,	{ "Bai&xas",aRot080A, 0 , 3}) //"Bai&xas"
//	aAdd( aRotina,	{ "&Borderôs",aRot240A, 0 , 5}) //"&Borderôs"
EndIf
aAdd( aRotina,	{ "&Faturas",aRot290, 0 , 6}) //"&Faturas"
aAdd( aRotina,	{ "Co&mpensação",aRot340, 0 , 6}) //"Co&mpensação"
aAdd( aRotina,	{ "Cheq s/&Título",aRot390, 0 , 6}) //"Cheq s/&Título"
aAdd( aRotina,	{ "Lib p/Pagto",aRot580, 0 , 6}) //"Lib p/Pagto"
aAdd( aRotina,	{ "C&NAB",aRot426, 0 , 6}) //"C&NAB"
aAdd( aRotina,	{ "Le&genda","FA040Legenda", 0 , 6, ,.F.}) //"Le&genda"


Return(aRotina)
