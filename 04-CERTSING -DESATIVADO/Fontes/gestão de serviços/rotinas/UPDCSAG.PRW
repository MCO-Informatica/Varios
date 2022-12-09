//-----------------------------------------------------------------------
// Rotina | UPDCSAG    | Autor | Claudio H. Corrêa    | Data | 22.02.2016
//-----------------------------------------------------------------------
// Descr. | Rotina de update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPDCSAG()
	Local cModulo := 'TEC'
	Local bPrepar := {|| U_CSAGIni() }
	Local nVersao := 01
	Local bVerEmp := {|| SM0->M0_CODIGO == "01"}
	
	NGCriaUpd(cModulo,bPrepar,nVersao,,bVerEmp)
Return

//-----------------------------------------------------------------------
// Rotina | UPDCSAG  | Autor | Claudio H. Corrêa     | Data | 22.02.2016
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CSAGIni()

	aSX2 := {}
	aSX3 := {}
	aSIX := {}
	aSX7 := {}
	aSXB := {}
	
	// Gera Updates SX2
	
	AAdd(aSX2,{"PAU","","Postos de Atendimento","Postos de Atendimento","Postos de Atendimento","E","",})
	AAdd(aSX2,{"PAV","","Detalhes de Postos de Atendimento","Detalhes de Postos de Atendimento","Detalhes de Postos de Atendimento","E","PAV_FILIAL+PAV_AR",})
	AAdd(aSX2,{"PAX","","Tecnicos Atendimento","Tecnicos Atendimento","Tecnicos Atendimento","E","",})
	AAdd(aSX2,{"PAW","","Agendamento","Agendamento","Agendamento","E","PAW_FILIAL+PAW_COD",})
	AAdd(aSX2,{"PAY","","Execoes de Atendimento","Execoes de Atendimento","Execoes de Atendimento","E","PAY_FILIAL+PAY_COD",})
	AAdd(aSX2,{"PAZ","","Apontamento de Atendimento","Apontamento de Atendimento","Apontamento de Atendimento","E","",})
	
	// Gera Updates Indices
	
	AAdd(aSIX,{"PA0","4","PA0_FILIAL+PA0_AR","Filial + AR","Filial + AR","Filial + AR","U","S"})
	AAdd(aSIX,{"PA1","1","PA1_FILIAL + PA1_OS + PA1_ITEM", "Ordem + Item", "Ordem + Item", "Ordem + Item","U","S"})
	AAdd(aSIX,{"PAU","1","PAU_FILIAL+PAU_COD","Filial + Codigo","Filial + Codigo","Filial + Codigo","U","S"})
	AAdd(aSIX,{"PAV","1","PAV_FILIAL+PAV_AR","Filial + AR","Filial + AR","Filial + AR","U","S"})
	AAdd(aSIX,{"PAX","1","PAX_FILIAL+PAX_MAT","Filial + Matricula","Filial + Matricula","Filial + Matricula","U","S"})
	AAdd(aSIX,{"PAX","2","PAX_FILIAL+PAX_AR","Filial + AR","Filial + AR","Filial + AR","U","S"})
	AAdd(aSIX,{"PAW","1","PAW_FILIAL+PAW_COD","Filial + Codigo","Filial + Codigo","Filial + Codigo","U","S"})
	AAdd(aSIX,{"PAW","2","PAW_FILIAL+PAW_COD+PAW_AR","Filial + Codigo + AR","Filial + Codigo + AR","Filial + Codigo + AR","U","S"})
	AAdd(aSIX,{"PAW","3","PAW_FILIAL+PAW_AR+PAW_DATA","Filial + AR + Data","Filial + AR + Data","Filial + AR + Data","U","S"})
	AAdd(aSIX,{"PAW","4","PAW_FILIAL+PAW_OS","Filial + Ordem","Filial + Ordem","Filial + Ordem","U","S"})
	AAdd(aSIX,{"PAY","1","PAY_FILIAL+PAY_AR","Filial + AR","Filial + AR","Filial + AR","U","S"})
	AAdd(aSIX,{"PA4","1","PA4_FILIAL+PA4_REGIAO","Filial + Regiao","Filial + Regiao","Filial + Regiao","U","S"})
	AAdd(aSIX,{"PA4","2","PA4_FILIAL+PA4_DESCRI","Filial + Descrição","Filial + Descrição","Filial + Descrição","U","S"})
	AAdd(aSIX,{"PA4","3","PA4_FILIAL+PA4_AR","Filial + AR","Filial + AR","Filial + AR","U","S"})
	AAdd(aSIX,{"PAZ","1","PAZ_FILIAL+PAZ_COD","Filial + Codigo","Filial + Codigo","Filial + Codigo","U","S"})
	AAdd(aSIX,{"ADE","S","ADE_FILIAL+ADE_OS", "Filial + Ordem","Filial + Ordem","Filial + Ordem","U","S"})
	AAdd(aSIX,{"ADF","5","ADF_FILIAL+ADF_OS", "Filial + Ordem","Filial + Ordem","Filial + Ordem","U","S"})
	
	// Gera Updates de Gatilhos
	
	AAdd(aSX7,{"PA0_CLIFAT","001","SA1->A1_LOJA"  ,"PA0_LOJAFA","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLIFAT","","U"})
	AAdd(aSX7,{"PA0_CLIFAT","002","SA1->A1_NOME"  ,"PA0_CLFTNM","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLIFAT","003","SA1->A1_END"  ,"PA0_ENDFAT","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLIFAT+M->PA0_LOJAFA","","U"})
	AAdd(aSX7,{"PA0_CLIFAT","004","SA1->A1_CGC"  ,"PA0_CGCFAT","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLIFAT+M->PA0_LOJAFA","","U"})
	AAdd(aSX7,{"PA0_CLIFAT","005","SA1->A1_BAIRRO"  ,"PA0_BAIFAT","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLIFAT+M->PA0_LOJAFA","","U"})
	AAdd(aSX7,{"PA0_CLIFAT","006","SA1->A1_CEP"  ,"PA0_CEPFAT","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLIFAT+M->PA0_LOJAFA","","U"})
	AAdd(aSX7,{"PA0_CLIFAT","007","SA1->A1_MUN"  ,"PA0_CIDFAT","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLIFAT+M->PA0_LOJAFA","","U"})
	AAdd(aSX7,{"PA0_CLIFAT","008","SA1->A1_EST"  ,"PA0_ESTFAT","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLIFAT+M->PA0_LOJAFA","","U"})
	AAdd(aSX7,{"PA0_CLIFAT","009","SA1->A1_COMPLEM"  ,"PA0_FATCOM","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLIFAT+M->PA0_LOJAFA","","U"})
	AAdd(aSX7,{"PA0_CLILOC","001","SA1->A1_LOJA"  ,"PA0_LOJLOC","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","002","SA1->A1_NOME"  ,"PA0_CLLCNO","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","003","SA1->A1_BAIRRO"  ,"PA0_BAIRRO","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","004","SA1->A1_MUN"  ,"PA0_CIDADE","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","005","SA1->A1_CEP"  ,"PA0_CEP","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","006","SA1->A1_EST"  ,"PA0_ESTADO","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","007","AllTrim(SA1->A1_TEL)"  ,"PA0_TEL","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","008","ALLTRIM(SA1->A1_END)"  ,"PA0_END","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","009","SA1->A1_DDD"  ,"PA0_DDD","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","010","SA1->A1_LOJA"  ,"PA0_LOJAFA","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","011","SA1->A1_NOME"  ,"PA0_CLFTNM","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","012","ALLTRIM(SA1->A1_END)"  ,"PA0_ENDFAT","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","013","SA1->A1_CGC"  ,"PA0_CGCFAT","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","014","SA1->A1_BAIRRO"  ,"PA0_BAIFAT","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","015","SA1->A1_CEP"  ,"PA0_CEPFAT","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","016","SA1->A1_MUN"  ,"PA0_CIDFAT","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","017","SA1->A1_EST"  ,"PA0_ESTFAT","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","018","SA1->A1_LOJA"  ,"PA0_LOJAFA","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","019","SA1->A1_COMPLEM"  ,"PA0_ENDFAT","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CLILOC","020","SA1->A1_COMPLEM"  ,"PA0_FATCOM","P","S","SA1",1,"xFilial('PA0')+M->PA0_CLILOC+M->PA0_LOJLOC","","U"})
	AAdd(aSX7,{"PA0_CONTAT","001","POSICIONE('SU5',1,XFILIAL('SU5')+M->PA0_CONTAT,'U5_CONTAT')"  ,"PA0_NMCONT","P","N","SU5",0,"","","U"})	
	AAdd(aSX7,{"PA1_PRCUNI","001","M->PA1_VALOR:=M->PA1_PRCUNI*M->PA1_QUANT"  ,"PA1_VALOR","P","N","",0,"","","U"})
	AAdd(aSX7,{"PA1_PRODUT","001","SB1->B1_DESC"  ,"PA1_DESCRI","P","S","SB1",1,"xFilial('SB1')+M->PA1_PRODUT","","U"})
	AAdd(aSX7,{"PA1_QUANT","001","M->PA1_VALOR:=M->PA1_QUANT*M->PA1_PRCUNI"  ,"PA1_VALOR","P","N","",0,"","","U"})
	AAdd(aSX7,{"PAX_MAT","001","RD0->RD0_NOME"  ,"PAX_NOME","P","S","RD0",9,"xFIlial('RD0')+ M->PAX_MAT","","U"})
	AAdd(aSX7,{"PAX_MAT","002","RD0->RD0_CIC"  ,"PAX_CPF","P","S","RD0",9,"xFIlial('RD0')+ M->PAX_MAT","","U"})
	AAdd(aSX7,{"PAX_MAT","003","RD0->RD0_EMAIL"  ,"PAX_EMAIL","P","S","RD0",9,"xFIlial('RD0')+ M->PAX_MAT","","U"})
	AAdd(aSX7,{"PA2_NUMOS","001","PA2_DTINI := PA0->PA0_DTAGEN"  ,"PA2_DTINI","P","N","",0,"","","U"})
	AAdd(aSX7,{"PA2_NUMOS","002","M->PA2_HRINI:= PA0->PA0_HRAGEN"  ,"PA2_HRINI","P","N","",0,"","","U"})
	AAdd(aSX7,{"PA2_HRINI","001","PA2_HRTOT:=Str(Val(M->PA2_HRFIM)-Val(M->PA2_HRINI))"  ,"PA2_HRTOT","P","N","",0,"","","U"})
	AAdd(aSX7,{"PA2_HRFIM","001","PA2_HRTOT:= Str(Val(M->PA2_HRFIM)-Val(M->PA2_HRINI))"  ,"PA2_HRTOT","P","N","",0,"","","U"})
	AAdd(aSX7,{"PA2_CODTEC","001","Posicione('PAX',1,xFilial('PAX')+M->PA2_CODTEC,'PAX_NOME')"  ,"PA2_NOMTEC","P","S","PAX",1,"xFIlial('PA2')+M->PA2_CODTEC","","U"})
	
	// Gera Updates de Consultas Padrões
	
	AAdd(aSXB,{"PA0","1","01","DB","SA","SA","SA","PA0",""})
	AAdd(aSXB,{"PA0","2","01","01","O.S.","O.S.","O.S.","",""})
	AAdd(aSXB,{"PA0","2","02","02","Nome","Nome","Nome","",""})
	AAdd(aSXB,{"PA0","4","01","01","Atendimento","Atendimento","Atendimento","PA0_OS",""})
	AAdd(aSXB,{"PA0","4","01","02","Nome Cli","Nome Cli","Nome Cli","PA0_CLLCNO",""})
	AAdd(aSXB,{"PA0","4","02","01","Nome","Nome","Nome","PA0_CLLCNO",""})
	AAdd(aSXB,{"PA0","4","02","02","Atendimento","Atendimento","Atendimento","PA0_OS",""})
	AAdd(aSXB,{"PA0","5","01","","","","","PA0->PA0_OS",""})
	AAdd(aSXB,{"CONPA0","1","01","RE","Consulta de contatos","Consulta de contatos","Consulta de contatos","AC8",""})
	AAdd(aSXB,{"CONPA0","2","01","01","","","","U_CSAGVACL()",""})
	AAdd(aSXB,{"CONPA0","5","01","","","","","U_CSRETUR()",""})
	AAdd(aSXB,{"PAU","1","01","DB","PAU","PAU","PAU","PAU",""})
	AAdd(aSXB,{"PAU","2","01","01","PAU","PAU","PAU","",""})
	AAdd(aSXB,{"PAU","4","01","01","Codigo","Codigo","Codigo","PAU_COD",""})
	AAdd(aSXB,{"PAU","4","01","01","Nome.Ar","Nome.Ar","Nome.Ar","PAU_NOME",""})
	AAdd(aSXB,{"PAU","5","01","","","","","PAU->PAU_COD",""})
	AAdd(aSXB,{"PAU1","1","01","DB","PAU","PAU","PAU","PAU",""})
	AAdd(aSXB,{"PAU1","2","01","01","PAU","PAU","PAU","PAU",""})
	AAdd(aSXB,{"PAU1","4","01","01","Codigo","Codigo","Codigo","PAU_COD",""})
	AAdd(aSXB,{"PAU1","4","01","02","Nome.Ar","Nome.Ar","Nome.Ar","PAU_NOME",""})
	AAdd(aSXB,{"PAU1","5","01","","","","","PAU->PAU_COD",""})
	AAdd(aSXB,{"PAX","1","01","DB","PAX","PAX","PAX","PAX",""})
	AAdd(aSXB,{"PAX","2","01","01","PAX","PAX","PAX","PAX",""})
	AAdd(aSXB,{"PAX","4","01","01","Matricula","Matricula","Matricula","PAX_MAT",""})
	AAdd(aSXB,{"PAX","4","01","02","Nome","Nome","Nome","PAX_NOME",""})
	AAdd(aSXB,{"PAX","4","01","03","CPF","CPF","CPF","PAX_CPF",""})
	AAdd(aSXB,{"PAX","5","01","","","","","PAX->PAX_MAT",""})
	AAdd(aSXB,{"PA4","1","01","DB","Regiao","Regiao","Regiao","PA4",""})
	AAdd(aSXB,{"PA4","2","01","01","Cod. Regiao","Cod. Regiao","Cod. Regiao","",""})
	AAdd(aSXB,{"PA4","2","02","02","Descricao","Descricao","Descricao","",""})
	AAdd(aSXB,{"PA4","4","01","01","Cod. Regiao","Cod. Regiao","Cod. Regiao","PA4_REGIAO",""})
	AAdd(aSXB,{"PA4","4","01","02","Descricao","Descricao","Descricao","PA4_DESCRI",""})
	AAdd(aSXB,{"PA4","4","02","01","Descricao","Descricao","Descricao","PA4_DESCRI",""})
	AAdd(aSXB,{"PA4","4","02","02","Cod. Regiao","Cod. Regiao","Cod. Regiao","PA4_REGIAO",""})
	AAdd(aSXB,{"PA4","5","01","","","","","PA4->PA4_REGIAO",""})
	AAdd(aSXB,{"CONPA4","1","01","RE","Consulta Regioes","Consulta Regioes","Consulta Regioes","PA4",""})
	AAdd(aSXB,{"CONPA4","2","01","01","","","","U_CSAGVAAR()",""})
	AAdd(aSXB,{"CONPA4","5","01","","","","","U_CSRETAR()",""})

	// Gera Updates de Campos
	
	aAdd( aSX3, {'ADE',NIL,'ADE_GERAOS','C',1,0,'Tipo de Aten','Tipo de Aten','Tipo de Aten','Tipo de Atendimento','Tipo de Atendimento','Tipo de Atendimento','','',;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),;
	'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','1=Gera Ordem de Servico;2=Nao Gera Ordem de Servico',; 
	'1=Gera Ordem de Servico;2=Nao Gera Ordem de Servico',;
	'1=Gera Ordem de Servico;2=Nao Gera Ordem de Servico',;
	'','U_WhenGrupos()','','','','','','','N','','','N','','',''})

	aAdd( aSX3, {'ADE',NIL,'ADE_OS','C',6,0,'Num OS','Num OS','Num OS','Num OS de Atendimento','Num OS de Atendimento','Num OS de Atendimento',;							
	'@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),;					
	'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','','','','','N','','','N','','',''})

	aAdd( aSX3, {'ADE',NIL,'ADE_KTRIB','C',50,0,'Tp Tributaca','','','Tipo Tributacao','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',1,Chr(254) + Chr(192),'',;
	'','U','S','A','R','','','Lucro Real;Lucro Presumido;Lucro Arbitrado;Micro Empresa;Simples Nacional;Outros','','','','IIF( M->ADE_KTIPO == "J", .T. , .F. )',;
	'','','4','','','','','','','','','',''})
	
	aAdd( aSX3, {'ADF',NIL,'ADF_OS','C',6,0,'Cod.OS','Cod.OS','Cod.OS','Codigo Ordem de Servico','Codigo Ordem de Servico','Codigo Ordem de Servico',;
	'@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),;
	'','',0,Chr(254) + Chr(65),'','','U','N','V','R','','','','','','','','','','','','','N','N','','','N','','N',''})

	aAdd( aSX3, {'PA0',"01",'PA0_FILIAL','C',2,0,'Filial','Sucursal','Branch','Filial do Sistema','Sucursal','Branch of the System','@!','',;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),;
	'','',1,Chr(254) + Chr(192),'','','U','N','','','','','','','','','','','033','','','','','','','','','','',''})
	
	aAdd( aSX3, {'PA0',"02",'PA0_OS','C',6,0,'Atendimento','Atendimento','Atendimento','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),"GETSXENUM('PA0','PA0_OS',,1)",;
	'',0,Chr(254) + Chr(192),'','','U','S','V','R','€','ExistChav("PA0")','','','','','','','','1','','','','N','','','N','','',''})

	aAdd( aSX3, {'PA0',"04",'PA0_CLILOC','C',6,0,'Cliente','Cliente','Cliente','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','SA1VIS',0,Chr(254) + Chr(192),;
	'','S','U','S','A','R','€','ExistCpo("SA1")','','','','','','','','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"05",'PA0_LOJLOC','C',2,0,'Loja','Loja','Loja','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'',;
	'','U','S','V','R','€','','','','','','INCLUI','','','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"06",'PA0_CLLCNO','C',60,0,'Nome','Nome','Nome','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'',;
	'','U','S','V','R','€','','','','','','','','','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"07",'PA0_CONTAT','C',6,0,'Contato','Contato','Contato','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CONPA0',0,Chr(254) + Chr(192),'',;
	'S','U','N','A','R','€','','','','','','','','','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"08",'PA0_NMCONT','C',40,0,'Nome Contato','Nome Contato','Nome Contato','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(129) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','',;
	'U','S','V','V','','','','','','','',"POSICIONE('SU5',1,XFILIAL('SU5')+PA0->PA0_CONTAT,'U5_CONTAT')", ;
	'','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"11",'PA0_CLFTNM','C',60,0,'Nome. Fat.','Nome. Fat.','Nome. Fat.','Nome. Fat.','Nome. Fat.','Nome. Fat.','@!','',;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),;
	'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','2','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"12",'PA0_END','C',100,0,'Endereco','Endereco','Endereco','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','',;
	'U','N','A','R','€','','','','','','','','','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"13",'PA0_COMPLE','C',50,0,'Complemento','Complemento','Complemento','Complemento','Complemento','Complemento','@!','',;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),;
	'','',0,Chr(254) + Chr(65),'','','U','S','A','R','','','','','','','','','','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"14",'PA0_BAIRRO','C',30,0,'Bairro','Bairro','Bairro','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'',;
	'','U','N','A','R','','','','','','','','','','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"16",'PA0_CIDADE','C',35,0,'Cidade','Cidade','Cidade','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'',;
	'','U','N','A','R','€','','','','','','','','','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"17",'PA0_ESTADO','C',2,0,'Estado','Estado','Estado','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','12',0,Chr(254) + Chr(192),'',;
	'','U','S','A','R','','ExistCpo("SX5","12"+M->PA0_ESTADO)','','','','','','','','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"18",'PA0_DDD','C',3,0,'DDD','DDD','DDD','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),;
	'','','U','N','A','R','','','','','','','','','','1','','','','','','','','','',''})
	
	aAdd( aSX3, {'PA0',"19",'PA0_REGIAO','C',3,0,'Regiao','Regiao','Regiao','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','CONPA4',0,Chr(254) + Chr(192),;
	'','','U','N','A','R','€','ExistCpo("PA4")','','','','','','','','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"37",'PA0_CONDPA','C',3,0,'Cond.Pag.','Cond.Pag.','Cond.Pag.','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'"000"','',0,Chr(254) + Chr(192),;
	'','','U','N','V','R','€','ExistCpo("SE4")','','','','','','','','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"25",'PA0_CUSTRA','N',14,2,'Custo Deslo.','Custo Deslo.','Custo Deslo.','','','','@e 99,999,999,999.99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','',;
	'','','','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"26",'PA0_DTAGEN','D',8,0,'Dt. Agenda','Dt. Agenda','Dt. Agenda','','','','','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'',;
	'','U','N','V','R','','','','','','','','','','1','','','','','','','','','',''})
	
	aAdd( aSX3, {'PA0',"27",'PA0_HRAGEN','C',5,0,'Hr. Agenda','Hr. Agenda','Hr. Agenda','','','','@! 99:99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'',;
	'','U','N','V','R','','','','','','','','','','1','','','','','','','','','',''})
	
	aAdd( aSX3, {'PA0',"28",'PA0_HRCHEG','C',5,0,'Hr.Chegada','Hr.Chegada','Hr.Chegada','','','','@! 99:99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'',;
	'','U','N','V','R','','','','','','','','','','1','','','','','','','','','',''})
	
	aAdd( aSX3, {'PA0',"29",'PA0_HRINIC','C',5,0,'Hr. Inicio','Hr. Inicio','Hr. Inicio','','','','@! 99:99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'',;
	'','U','N','V','R','','','','','','','','','','1','','','','','','','','','',''})
	
	aAdd( aSX3, {'PA0',"30",'PA0_HRTERM','C',5,0,'Hr.Termino','Hr.Termino','Hr.Termino','','','','@! 99:99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','',0,Chr(254) + Chr(192),'',;
	'','U','N','V','R','','','','','','','','','','1','','','','','','','','','',''})
	
	aAdd( aSX3, {'PA0',"32",'PA0_OBS','C',250,0,'Observacao','Observacao','Observacao','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'',;
	'','U','N','A','R','','','','','','','','','','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"21",'PA0_AR','C',6,0,'AR','AR','AR','','','','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),'','SZ3',0,Chr(254) + Chr(192),'',;
	'','U','S','V','R','','ExistCpo("SZ3")','','','','','','','','1','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"38",'PA0_PREVAL','C',3,0,'Pre Valida','Pre Valida','Pre Valida','Pre Validacao? SIM ou NAO','Pre Validacao? SIM ou NAO','Pre Validacao? SIM ou NAO',;
	'@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),;
	'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','SIM=SIM;NAO=NAO','SIM=SIM;NAO=NAO','SIM=SIM;NAO=NAO','','','','','1','','','','N','','','N','','',''})

	aAdd( aSX3, {'PA0',"39",'PA0_ENDFAT','C',100,0,'Endereco Fat','Endereco Fat','Endereco Fat','Endereco Faturamento','Endereco Faturamento','Endereco Faturamento','@!','',;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'',;
	'',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','2','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"40",'PA0_CGCFAT','C',20,0,'CNPJ Fat.','CNPJ Fat.','CNPJ Fat.','CNPJ Faturamento','CNPJ Faturamento','CNPJ Faturamento','@R 99.999.999/9999-99','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'',;
	'','U','N','A','R','','','','','','','','','','2','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"41",'PA0_FATCOM','C',50,0,'Complem.Fatu','Complem.Fatu','Complem.Fatu','Complemento Faturamento','Complemento Faturamento','Complemento Faturamento','@!','',;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,;
	Chr(254) + Chr(65),'','','U','S','A','R','','','','','','','','','','2','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"42",'PA0_BAIFAT','C',50,0,'Bairro Fat.','Bairro Fat.','Bairro Fat.','Bairro Faturamento','Bairro Faturamento','Bairro Faturamento','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'',;
	'','U','N','A','R','','','','','','','','','','2','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"43",'PA0_CEPFAT','C',10,0,'CEP Fat.','CEP Fat.','CEP Fat.','CEP Faturamento','CEP Faturamento','CEP Faturamento','@R 99999-999','',;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),;
	'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','','','2','','','','N','','','N','','',''})
	
	aAdd( aSX3,{'PA0', "44",'PA0_CIDFAT','C',50,0,'Cidade Fat.','Cidade Fat.','Cidade Fat.','Cidade Faturamento','Cidade Faturamento','Cidade Faturamento','@!','',Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N','A','R','','','','','','','','',;
	'','2','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"45",'PA0_ESTFAT','C',2,0,'Estado Fat.','Estado Fat.','Estado Fat.','Estado Faturamento','Estado Faturamento','Estado Faturamento','@!','',Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),'','',0,Chr(254) + Chr(192),'','','U','N',;
	'A','R','','','','','','','','','','2','','','','N','','','N','','',''})
	
	aAdd( aSX3, {'PA0',"46",'PA0_LINDIG','C',55,0,;	//X3_DECIMAL
	'LINHA DIGITA',; //X3_TITULO
	 'LINHA DIGITA',; //X3_TITSPA
	 'LINHA DIGITA',; //X3_TITENG
	 ''			,; //X3_DESCRIC
	 ''			,; //X3_DESCSPA
	 ''			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''			} ) //X3_PYME

	 aAdd( aSX3, { ;
	'PA0'			,; //X3_ARQUIVO
	"47"			,; //X3_ORDEM
	'PA0_EMAIL'	,; //X3_CAMPO
	'C'			,; //X3_TIPO
	 80			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'E-Mail Cont.',; //X3_TITULO
	 'E-Mail Cont.',; //X3_TITSPA
	 'E-Mail Cont.',; //X3_TITENG
	 'Email do solicitante'							,; //X3_DESCRIC
	 ''			,; //X3_DESCSPA
	 ''			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(32) + Chr(32),; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 '1'			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''			} ) //X3_PYME
	 
	 aAdd( aSX3, { ;
	 'PA0'			,; //X3_ARQUIVO
	 "48"			,; //X3_ORDEM
	 'PA0_DTEBOL'	,; //X3_CAMPO
	 'D'			,; //X3_TIPO
	 8				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Emissao Bole',; //X3_TITULO
	 'Emissao Bole',; //X3_TITSPA
	 'Emissao Bole',; //X3_TITENG
	 ''			,; //X3_DESCRIC
	 ''			,; //X3_DESCSPA
	 ''			,; //X3_DESCENG
	 ''			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 '1'			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME
	 
	 aAdd( aSX3, { ;
	 'PA0'			,; //X3_ARQUIVO
	 "49"			,; //X3_ORDEM
	 'PA0_DTVBOL'	,; //X3_CAMPO
	 'D'			,; //X3_TIPO
	 8				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Venc. Boleto',; //X3_TITULO
	 'Venc. Boleto',; //X3_TITSPA
	 'Venc. Boleto',; //X3_TITENG
	 ''			,; //X3_DESCRIC
	 ''			,; //X3_DESCSPA
	 ''			,; //X3_DESCENG
	 ''			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 '1'			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''			} ) //X3_PYME
	 
	 aAdd( aSX3, { ;
	 'PA0'			,; //X3_ARQUIVO
	 "50"			,; //X3_ORDEM
	 'PA0_PROTOC'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Protoc. Aten',; //X3_TITULO
	 'Protoc. Aten',; //X3_TITSPA
	 'Protoc. Aten',; //X3_TITENG
	 ''			,; //X3_DESCRIC
	 ''			,; //X3_DESCSPA
	 ''			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 '1'			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

aAdd( aSX3, { ;
	 'PA0'			,; //X3_ARQUIVO
	 "51"			,; //X3_ORDEM
	 'PA0_AVISO'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 1				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Aviso de Env',; //X3_TITULO
	 'Aviso de Env',; //X3_TITSPA
	 'Aviso de Env',; //X3_TITENG
	 'Aviso de Envio de E-mail'						,; //X3_DESCRIC
	 'Aviso de Envio de E-mail'						,; //X3_DESCSPA
	 'Aviso de Envio de E-mail'						,; //X3_DESCENG
	 '!@'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 '1'			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

aAdd( aSX3, { ;
	 'PA0'			,; //X3_ARQUIVO
	 "52"			,; //X3_ORDEM
	 'PA0_DTABER'	,; //X3_CAMPO
	 'D'			,; //X3_TIPO
	 8				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Data Abertur',; //X3_TITULO
	 'Data Abertur',; //X3_TITSPA
	 'Data Abertur',; //X3_TITENG
	 'Data de Abertura da OS'							,; //X3_DESCRIC
	 'Data de Abertura da OS'							,; //X3_DESCSPA
	 'Data de Abertura da OS'							,; //X3_DESCENG
	 ''			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(129) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 '1'			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PA0'			,; //X3_ARQUIVO
	 "53"			,; //X3_ORDEM
	 'PA0_DTFECH'	,; //X3_CAMPO
	 'D'			,; //X3_TIPO
	 8				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Data Fechame',; //X3_TITULO
	 'Data Fechame',; //X3_TITSPA
	 'Data Fechame',; //X3_TITENG
	 'Data de Fechamento da OS'						,; //X3_DESCRIC
	 'Data de Fechamento da OS'						,; //X3_DESCSPA
	 'Data de Fechamento da OS'						,; //X3_DESCENG
	 ''			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 '1'			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PA0'			,; //X3_ARQUIVO
	 "54"			,; //X3_ORDEM
	 'PA0_HORABR'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 5				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Hora de Aber',; //X3_TITULO
	 'Hora de Aber',; //X3_TITSPA
	 'Hora de Aber',; //X3_TITENG
	 'Hora de Abertura da OS'							,; //X3_DESCRIC
	 'Hora de Abertura da OS'							,; //X3_DESCSPA
	 'Hora de Abertura da OS'							,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 '1'			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME
	 
	 aAdd( aSX3, { ;
	 'PA0'			,; //X3_ARQUIVO
	 "55"			,; //X3_ORDEM
	 'PA0_HORFEC'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 5				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Hora de Fech',; //X3_TITULO
	 'Hora de Fech',; //X3_TITSPA
	 'Hora de Fech',; //X3_TITENG
	 'Hora de Fechamento da OS'						,; //X3_DESCRIC
	 'Hora de Fechamento da OS'						,; //X3_DESCSPA
	 'Hora de Fechamento da OS'						,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 '1'			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PA0'			,; //X3_ARQUIVO
	 "56"			,; //X3_ORDEM
	 'PA0_TIPATE'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 3				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Tipo Atendim',; //X3_TITULO
	 'Tipo Atendim',; //X3_TITSPA
	 'Tipo Atendim',; //X3_TITENG
	 'Tipo de Atedimento'								,; //X3_DESCRIC
	 'Tipo de Atedimento'								,; //X3_DESCSPA
	 'Tipo de Atedimento'								,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 'ADM=Administrativo;BKO=BackOffice'				,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 '1'			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PA0'			,; //X3_ARQUIVO
	 "57"			,; //X3_ORDEM
	 'PA0_USER'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 100			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Usuario.Loga',; //X3_TITULO
	 'Usuario.Loga',; //X3_TITSPA
	 'Usuario.Loga',; //X3_TITENG
	 'Usuario Logado na Finaliz'						,; //X3_DESCRIC
	 'Usuario Logado na Finaliz'						,; //X3_DESCSPA
	 'Usuario Logado na Finaliz'						,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PA0'			,; //X3_ARQUIVO
	 "58"			,; //X3_ORDEM
	 'PA0_CONAGE'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 60			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Cont. Agenda',; //X3_TITULO
	 'Cont. Agenda',; //X3_TITSPA
	 'Cont. Agenda',; //X3_TITENG
	 'Contato do Agendamento'							,; //X3_DESCRIC
	 'Contato do Agendamento'							,; //X3_DESCSPA
	 'Contato do Agendamento'							,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(65)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 '1'			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME
//
// Campos Tabela PA1
//

	aAdd( aSX3, { ;
	 'PA1'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PA1_FILIAL'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 2				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Filial'		,; //X3_TITULO
	 'Sucursal'	,; //X3_TITSPA
	 'Branch'		,; //X3_TITENG
	 'Filial do Sistema'								,; //X3_DESCRIC
	 'Sucursal'	,; //X3_DESCSPA
	 'Branch of the System'							,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 1				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 ''			,; //X3_VISUAL
	 ''			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 '033'			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PA1'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PA1_QUANT'	,; //X3_CAMPO
	 'N'			,; //X3_TIPO
	 14			,; //X3_TAMANHO
	 2				,; //X3_DECIMAL
	 'Quantidade'	,; //X3_TITULO
	 'Quantidade'	,; //X3_TITSPA
	 'Quantidade'	,; //X3_TITENG
	 ''			,; //X3_DESCRIC
	 ''			,; //X3_DESCSPA
	 ''			,; //X3_DESCENG
	 '@E 999,999,999.99'								,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 '1'			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 'S'			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

aAdd( aSX3, { ;
	 'PA1'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PA1_CNPJ'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 20			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'CNPJ/CPF'	,; //X3_TITULO
	 'CNPJ/CPF'	,; //X3_TITSPA
	 'CNPJ/CPF'	,; //X3_TITENG
	 ''			,; //X3_DESCRIC
	 ''			,; //X3_DESCSPA
	 ''			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 'IIF(CGC(M->PA1_CNPJ),.T., .F.)'					,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PA1'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PA1_FATURA'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 1				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Fatura'		,; //X3_TITULO
	 'Fatura'		,; //X3_TITSPA
	 'Fatura'		,; //X3_TITENG
	 ''			,; //X3_DESCRIC
	 ''			,; //X3_DESCSPA
	 ''			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 'Pertence("SNF")',; //X3_VLDUSER
	 'S=SIM;N=CORTESIA;F=FATURADO'						,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PA1'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PA1_REALIZ'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 3				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'At.Realizado',; //X3_TITULO
	 ''			,; //X3_TITSPA
	 ''			,; //X3_TITENG
	 'At.Realizado',; //X3_DESCRIC
	 ''			,; //X3_DESCSPA
	 ''			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(65)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

aAdd( aSX3, { ;
	 'PA1'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PA1_MOTIVO'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 3				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'At.Motivo'	,; //X3_TITULO
	 ''			,; //X3_TITSPA
	 ''			,; //X3_TITENG
	 'At.Motivo'	,; //X3_DESCRIC
	 ''			,; //X3_DESCSPA
	 ''			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(65)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PA1'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PA1_NPSITE'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 10			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Ped.Site'	,; //X3_TITULO
	 'Ped.Site'	,; //X3_TITSPA
	 'Ped.Site'	,; //X3_TITENG
	 'Pedido Site'	,; //X3_DESCRIC
	 'Pedido Site'	,; //X3_DESCSPA
	 'Pedido Site'	,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

//
// Campos Tabela PA4
//
	
	aAdd( aSX3, { ;
	 'PA4'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PA4_AR'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Posto de Ate',; //X3_TITULO
	 'Posto de Ate',; //X3_TITSPA
	 'Posto de Ate',; //X3_TITENG
	 'Posto de Atendimento'							,; //X3_DESCRIC
	 'Posto de Atendimento'							,; //X3_DESCSPA
	 'Posto de Atendimento'							,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 'SZ3'			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(65)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 ''			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

aAdd( aSX3, { ;
	 'PA4'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PA4_DESLOC'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 5				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Deslocamento',; //X3_TITULO
	 'Deslocamento',; //X3_TITSPA
	 'Deslocamento',; //X3_TITENG
	 'Deslocamento',; //X3_DESCRIC
	 'Deslocamento',; //X3_DESCSPA
	 'Deslocamento',; //X3_DESCENG
	 '@! 99:99'	,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(65)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 ''			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

//
// Campos Tabela PAU
//
	aAdd( aSX3, { ;
	 'PAU'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAU_FILIAL'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 2				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Filial'		,; //X3_TITULO
	 'Sucursal'	,; //X3_TITSPA
	 'Branch'		,; //X3_TITENG
	 'Filial do Sistema'								,; //X3_DESCRIC
	 'Sucursal'	,; //X3_DESCSPA
	 'Branch of the System'							,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 1				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 ''			,; //X3_VISUAL
	 ''			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 '033'			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAU'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAU_COD'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Codigo'		,; //X3_TITULO
	 'Codigo'		,; //X3_TITSPA
	 'Codigo'		,; //X3_TITENG
	 'Codigo da AR',; //X3_DESCRIC
	 'Codigo da AR',; //X3_DESCSPA
	 'Codigo da AR',; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 'GETSXENUM("PAU","PAU_COD")'						,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAU'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAU_NOME'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 30			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Nome.Ar'		,; //X3_TITULO
	 'Nome.Ar'		,; //X3_TITSPA
	 'Nome.Ar'		,; //X3_TITENG
	 'Nome.Ar'		,; //X3_DESCRIC
	 'Nome.Ar'		,; //X3_DESCSPA
	 'Nome.Ar'		,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(65)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAU'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAU_ENDE'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 50			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Endereco'	,; //X3_TITULO
	 'Endereco'	,; //X3_TITSPA
	 'Endereco'	,; //X3_TITENG
	 'Endereco'	,; //X3_DESCRIC
	 'Endereco'	,; //X3_DESCSPA
	 'Endereco'	,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAU'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAU_COMPLE'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 30			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Complemento'	,; //X3_TITULO
	 'Complemento'	,; //X3_TITSPA
	 'Complemento'	,; //X3_TITENG
	 'Complemento'	,; //X3_DESCRIC
	 'Complemento'	,; //X3_DESCSPA
	 'Complemento'	,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAU'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAU_BAIRRO'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 20			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Bairro'		,; //X3_TITULO
	 'Bairro'		,; //X3_TITSPA
	 'Bairro'		,; //X3_TITENG
	 'Bairro'		,; //X3_DESCRIC
	 'Bairro'		,; //X3_DESCSPA
	 'Bairro'		,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAU'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAU_CIDADE'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 20			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Cidade'		,; //X3_TITULO
	 'Cidade'		,; //X3_TITSPA
	 'Cidade'		,; //X3_TITENG
	 'Cidade'		,; //X3_DESCRIC
	 'Cidade'		,; //X3_DESCSPA
	 'Cidade'		,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAU'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAU_UF'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 2				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'UF'			,; //X3_TITULO
	 'UF'			,; //X3_TITSPA
	 'UF'			,; //X3_TITENG
	 'UF'			,; //X3_DESCRIC
	 'UF'			,; //X3_DESCSPA
	 'UF'			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAU'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAU_CEP'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 8				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'CEP'			,; //X3_TITULO
	 'CEP'			,; //X3_TITSPA
	 'CEP'			,; //X3_TITENG
	 'CEP'			,; //X3_DESCRIC
	 'CEP'			,; //X3_DESCSPA
	 'CEP'			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAU'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAU_ATIVO'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 1				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Ativo'		,; //X3_TITULO
	 'Ativo'		,; //X3_TITSPA
	 'Ativo'		,; //X3_TITENG
	 'Ativo'		,; //X3_DESCRIC
	 'Ativo'		,; //X3_DESCSPA
	 'Ativo'		,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 '1=ATIVO;2=INATIVO'								,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

//
// Campos Tabela PAV
//
	aAdd( aSX3, { ;
	 'PAV'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAV_FILIAL'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 2				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Filial'		,; //X3_TITULO
	 'Sucursal'	,; //X3_TITSPA
	 'Branch'		,; //X3_TITENG
	 'Filial do Sistema'								,; //X3_DESCRIC
	 'Sucursal'	,; //X3_DESCSPA
	 'Branch of the System'							,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 1				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 ''			,; //X3_VISUAL
	 ''			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 '033'			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAV'			,; //X3_ARQUIVO
	 '02'			,; //X3_ORDEM
	 'PAV_AR'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'AR'			,; //X3_TITULO
	 'AR'			,; //X3_TITSPA
	 'AR'			,; //X3_TITENG
	 'AR'			,; //X3_DESCRIC
	 'AR'			,; //X3_DESCSPA
	 'AR'			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAV'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAV_ALOC'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 3				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Alocacao'	,; //X3_TITULO
	 'Alocacao'	,; //X3_TITSPA
	 'Alocacao'	,; //X3_TITENG
	 'Alocacao'	,; //X3_DESCRIC
	 'Alocacao'	,; //X3_DESCSPA
	 'Alocacao'	,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 'SH7'			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(65)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAV'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAV_SIMULT'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 2				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'At.Simultane',; //X3_TITULO
	 'At.Simultane',; //X3_TITSPA
	 'At.Simultane',; //X3_TITENG
	 'At.Simultane',; //X3_DESCRIC
	 'At.Simultane',; //X3_DESCSPA
	 'At.Simultane',; //X3_DESCENG
	'@! 99'		,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

//
// Campos Tabela PAW
//
	aAdd( aSX3, { ;
	 'PAW'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAW_FILIAL'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 2				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Filial'		,; //X3_TITULO
	 'Sucursal'	,; //X3_TITSPA
	 'Branch'		,; //X3_TITENG
	 'Filial do Sistema'								,; //X3_DESCRIC
	 'Sucursal'	,; //X3_DESCSPA
	 'Branch of the System'							,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 1				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 ''			,; //X3_VISUAL
	 ''			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 '033'			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAW'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAW_COD'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Codigo'		,; //X3_TITULO
	 'Codigo'		,; //X3_TITSPA
	 'Codigo'		,; //X3_TITENG
	 'Codigo'		,; //X3_DESCRIC
	 'Codigo'		,; //X3_DESCSPA
	 'Codigo'		,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 'GETSXENUM("PAW","PAW_COD")'						,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

aAdd( aSX3, { ;
	 'PAW'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAW_AR'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'AR'			,; //X3_TITULO
	 'AR'			,; //X3_TITSPA
	 'AR'			,; //X3_TITENG
	 'AR'			,; //X3_DESCRIC
	 'AR'			,; //X3_DESCSPA
	 'AR'			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 'SZ3'			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAW'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAW_DATA'	,; //X3_CAMPO
	 'D'			,; //X3_TIPO
	 8				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Data'		,; //X3_TITULO
	 'Data'		,; //X3_TITSPA
	 'Data'		,; //X3_TITENG
	 'Data'		,; //X3_DESCRIC
	 'Data'		,; //X3_DESCSPA
	 'Data'		,; //X3_DESCENG
	 ''			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAW'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAW_HORINI'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 5				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Hora Ini'	,; //X3_TITULO
	 'Hora Ini'	,; //X3_TITSPA
	 'Hora Ini'	,; //X3_TITENG
	 'Hora Inicial Atendimento'						,; //X3_DESCRIC
	 'Hora Inicial Atendimento'						,; //X3_DESCSPA
	 'Hora Inicial Atendimento'						,; //X3_DESCENG
	 '@! 99:99'	,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAW'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAW_HORFIM'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 5				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Hora Fim'	,; //X3_TITULO
	 'Hora Fim'	,; //X3_TITSPA
	 'Hora Fim'	,; //X3_TITENG
	 'Hora Final Atendimento'							,; //X3_DESCRIC
	 'Hora Final Atendimento'							,; //X3_DESCSPA
	 'Hora Final Atendimento'							,; //X3_DESCENG
	 '@! 99:99'	,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(65)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAW'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAW_OS'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'OS'			,; //X3_TITULO
	 'OS'			,; //X3_TITSPA
	 'OS'			,; //X3_TITENG
	 'OS'			,; //X3_DESCRIC
	 'OS'			,; //X3_DESCSPA
	 'OS'			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 'PA0'			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAW'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAW_STATUS'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 1				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Status'		,; //X3_TITULO
	 'Status'		,; //X3_TITSPA
	 'Status'		,; //X3_TITENG
	 'Status'		,; //X3_DESCRIC
	 'Status'		,; //X3_DESCSPA
	 'Status'		,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

//
// Campos Tabela PAX
//

	aAdd( aSX3, { ;
	 'PAX'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAX_FILIAL'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 2				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Filial'		,; //X3_TITULO
	 'Sucursal'	,; //X3_TITSPA
	 'Branch'		,; //X3_TITENG
	 'Filial do Sistema'								,; //X3_DESCRIC
	 'Sucursal'	,; //X3_DESCSPA
	 'Branch of the System'							,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 1				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 ''			,; //X3_VISUAL
	 ''			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 '033'			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAX'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAX_MAT'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Matricula'	,; //X3_TITULO
	 'Matricula'	,; //X3_TITSPA
	 'Matricula'	,; //X3_TITENG
	 'Matricula'	,; //X3_DESCRIC
	 'Matricula'	,; //X3_DESCSPA
	 'Matricula'	,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 'IIF(M->PAX_TERCEI == "1",.T.,U_CSAGMATF())'		,; //X3_RELACAO
	 'RD0MAT'		,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 'S'			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 'IIF(M->PAX_TERCEI == "1",.T.,.F.)'				,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAX'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAX_CPF'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 11			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'CPF'			,; //X3_TITULO
	 'CPF'			,; //X3_TITSPA
	 'CPF'			,; //X3_TITENG
	 'CPF'			,; //X3_DESCRIC
	 'CPF'			,; //X3_DESCSPA
	 'CPF'			,; //X3_DESCENG
	 '@R 999.999.999-99'								,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAX'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAX_AR'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'AR'			,; //X3_TITULO
	 'AR'			,; //X3_TITSPA
	 'AR'			,; //X3_TITENG
	 'AR'			,; //X3_DESCRIC
	 'AR'			,; //X3_DESCSPA
	 'AR'			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 'SZ3'			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(65)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAX'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAX_NOME'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 30			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Nome'		,; //X3_TITULO
	 'Nome'		,; //X3_TITSPA
	 'Nome'		,; //X3_TITENG
	 'Nome'		,; //X3_DESCRIC
	 'Nome'		,; //X3_DESCSPA
	 'Nome'		,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAX'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAX_EMAIL'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 60			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'E-Mail'		,; //X3_TITULO
	 'E-Mail'		,; //X3_TITSPA
	 'E-Mail'		,; //X3_TITENG
	 'E-Mail'		,; //X3_DESCRIC
	 'E-Mail'		,; //X3_DESCSPA
	 'E-Mail'		,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAX'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAX_DTFIMD'	,; //X3_CAMPO
	 'D'			,; //X3_TIPO
	 8				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Dt.Fim.Disp'	,; //X3_TITULO
	 'Dt.Fim.Disp'	,; //X3_TITSPA
	 'Dt.Fim.Disp'	,; //X3_TITENG
	 'Dt.Fim.Disp'	,; //X3_DESCRIC
	 'Dt.Fim.Disp'	,; //X3_DESCSPA
	 'Dt.Fim.Disp'	,; //X3_DESCENG
	 ''			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAX'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAX_TERCEI'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 1				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Terceiro'	,; //X3_TITULO
	 'Terceiro'	,; //X3_TITSPA
	 'Terceiro'	,; //X3_TITENG
	 'Terceiro? Sim ou Nao'							,; //X3_DESCRIC
	 'Terceiro? Sim ou Nao'							,; //X3_DESCSPA
	 'Terceiro? Sim ou Nao'							,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(65)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 ''			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 '1=Colaborador;2=Terceiro'						,; //X3_CBOX
	 '1=Colaborador;2=Terceiro'						,; //X3_CBOXSPA
	 '1=Colaborador;2=Terceiro'						,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 '1'			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

//
// Campos Tabela PAY
//

	aAdd( aSX3, { ;
	 'PAY'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAY_FILIAL'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 2				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Filial'		,; //X3_TITULO
	 'Sucursal'	,; //X3_TITSPA
	 'Branch'		,; //X3_TITENG
	 'Filial do Sistema'								,; //X3_DESCRIC
	 'Sucursal'	,; //X3_DESCSPA
	 'Branch of the System'							,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 1				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 ''			,; //X3_VISUAL
	 ''			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 '033'			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAY'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAY_COD'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Codigo'		,; //X3_TITULO
	 'Codigo'		,; //X3_TITSPA
	 'Codigo'		,; //X3_TITENG
	 'Codigo'		,; //X3_DESCRIC
	 'Codigo'		,; //X3_DESCSPA
	 'Codigo'		,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 "GETSXENUM('PAY','PAY_COD')"						,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAY'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAY_AR'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'AR'			,; //X3_TITULO
	 'AR'			,; //X3_TITSPA
	 'AR'			,; //X3_TITENG
	 'AR'			,; //X3_DESCRIC
	 'AR'			,; //X3_DESCSPA
	 'AR'			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 'SZ3'			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAY'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAY_DATA'	,; //X3_CAMPO
	 'D'			,; //X3_TIPO
	 8				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Data'		,; //X3_TITULO
	 'Data'		,; //X3_TITSPA
	 'Data'		,; //X3_TITENG
	 'Data'		,; //X3_DESCRIC
	 'Data'		,; //X3_DESCSPA
	 'Data'		,; //X3_DESCENG
	 ''			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAY'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAY_QTDATE'	,; //X3_CAMPO
	 'N'			,; //X3_TIPO
	 2				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Quant.Atendi',; //X3_TITULO
	 'Quant.Atendi',; //X3_TITSPA
	 'Quant.Atendi',; //X3_TITENG
	 'Quant.Atendi',; //X3_DESCRIC
	 'Quant.Atendi',; //X3_DESCSPA
	 'Quant.Atendi',; //X3_DESCENG
	 '@E'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAY'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAY_USUARI'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 30			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Usuario.Loga',; //X3_TITULO
	 'Usuario.Loga',; //X3_TITSPA
	 'Usuario.Loga',; //X3_TITENG
	 'Usuario.Loga',; //X3_DESCRIC
	 'Usuario.Loga',; //X3_DESCSPA
	 'Usuario.Loga',; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 'Alltrim(UsrRetName(__CUSERID))'					,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAY'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAY_MOTIVO'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 100			,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Motivo'		,; //X3_TITULO
	 'Motivo'		,; //X3_TITSPA
	 'Motivo'		,; //X3_TITENG
	 'Motivo'		,; //X3_DESCRIC
	 'Motivo'		,; //X3_DESCSPA
	 'Motivo'		,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

//
// Campos Tabela PAZ
//

	aAdd( aSX3, { ;
	 'PAZ'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAZ_FILIAL'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 2				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Filial'		,; //X3_TITULO
	 'Sucursal'	,; //X3_TITSPA
	 'Branch'		,; //X3_TITENG
	 'Filial do Sistema'								,; //X3_DESCRIC
	 'Sucursal'	,; //X3_DESCSPA
	 'Branch of the System'							,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 1				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 ''			,; //X3_VISUAL
	 ''			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 '033'			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 ''			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 ''			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAZ'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAZ_COD'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Codigo'		,; //X3_TITULO
	 'Codigo'		,; //X3_TITSPA
	 'Codigo'		,; //X3_TITENG
	 'Codigo'		,; //X3_DESCRIC
	 'Codigo'		,; //X3_DESCSPA
	 'Codigo'		,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 'GETSXENUM("PAZ","PAZ_COD")'						,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAZ'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAZ_OS'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'OS'			,; //X3_TITULO
	 'OS'			,; //X3_TITSPA
	 'OS'			,; //X3_TITENG
	 'OS'			,; //X3_DESCRIC
	 'OS'			,; //X3_DESCSPA
	 'OS'			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 'PA0'			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAZ'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAZ_FUNCIO'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	'Funcionario'	,; //X3_TITULO
	 'Funcionario'	,; //X3_TITSPA
	 'Funcionario'	,; //X3_TITENG
	 'Funcionario'	,; //X3_DESCRIC
	 'Funcionario'	,; //X3_DESCSPA
	 'Funcionario'	,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAZ'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAZ_HORAIN'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 5				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Hora.Ini.Ate',; //X3_TITULO
	 'Hora.Ini.Ate',; //X3_TITSPA
	 'Hora.Ini.Ate',; //X3_TITENG
	 'Hora.Ini.Ate',; //X3_DESCRIC
	 'Hora.Ini.Ate',; //X3_DESCSPA
	 'Hora.Ini.Ate',; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

aAdd( aSX3, { ;
	 'PAZ'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAZ_HORAFI'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 5				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Hora.Fim.Ate',; //X3_TITULO
	 'Hora.Fim.Ate',; //X3_TITSPA
	 'Hora.Fim.Ate',; //X3_TITENG
	 'Hora.Fim.Ate',; //X3_DESCRIC
	 'Hora.Fim.Ate',; //X3_DESCSPA
	 'Hora.Fim.Ate',; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAZ'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAZ_INTERV'	,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 5				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Hora.Interva',; //X3_TITULO
	 'Hora.Interva',; //X3_TITSPA
	 'Hora.Interva',; //X3_TITENG
	 'Hora.Interva',; //X3_DESCRIC
	 'Hora.Interva',; //X3_DESCSPA
	 'Hora.Interva',; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

aAdd( aSX3, { ;
	 'PAZ'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAZ_DTREAL'	,; //X3_CAMPO
	 'D'			,; //X3_TIPO
	 8				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Data.Real'	,; //X3_TITULO
	 'Data.Real'	,; //X3_TITSPA
	 'Data.Real'	,; //X3_TITENG
	 'Data.Real'	,; //X3_DESCRIC
	 'Data.Real'	,; //X3_DESCSPA
	 'Data.Real'	,; //X3_DESCENG
	 ''			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

	 aAdd( aSX3, { ;
	 'PAZ'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'PAZ_DTORIG'	,; //X3_CAMPO
	 'D'			,; //X3_TIPO
	 8				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'Data.Origina',; //X3_TITULO
	 'Data.Origina',; //X3_TITSPA
	 'Data.Origina',; //X3_TITENG
	 'Data.Origina',; //X3_DESCRIC
	 'Data.Origina',; //X3_DESCSPA
	 'Data.Origina',; //X3_DESCENG
	 ''			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'S'			,; //X3_BROWSE
	 'A'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 '€'			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 ''			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 ''			,; //X3_MODAL
	 ''}) //X3_PYME

//
// Campos Tabela SE1
//
	
	aAdd( aSX3, { ;
	 'SE1'			,; //X3_ARQUIVO
	 NIL			,; //X3_ORDEM
	 'E1_OS'		,; //X3_CAMPO
	 'C'			,; //X3_TIPO
	 6				,; //X3_TAMANHO
	 0				,; //X3_DECIMAL
	 'OS'			,; //X3_TITULO
	 'OS'			,; //X3_TITSPA
	 'OS'			,; //X3_TITENG
	 ''			,; //X3_DESCRIC
	 ''			,; //X3_DESCSPA
	 ''			,; //X3_DESCENG
	 '@!'			,; //X3_PICTURE
	 ''			,; //X3_VALID
	 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128),; //X3_USADO
	 ''			,; //X3_RELACAO
	 ''			,; //X3_F3
	 0				,; //X3_NIVEL
	 Chr(254) + Chr(192)								,; //X3_RESERV
	 ''			,; //X3_CHECK
	 ''			,; //X3_TRIGGER
	 'U'			,; //X3_PROPRI
	 'N'			,; //X3_BROWSE
	 'V'			,; //X3_VISUAL
	 'R'			,; //X3_CONTEXT
	 ''			,; //X3_OBRIGAT
	 ''			,; //X3_VLDUSER
	 ''			,; //X3_CBOX
	 ''			,; //X3_CBOXSPA
	 ''			,; //X3_CBOXENG
	 ''			,; //X3_PICTVAR
	 ''			,; //X3_WHEN
	 ''			,; //X3_INIBRW
	 ''			,; //X3_GRPSXG
	 ''			,; //X3_FOLDER
	 ''			,; //X3_CONDSQL
	 ''			,; //X3_CHKSQL
	 'N'			,; //X3_IDXSRV
	 'N'			,; //X3_ORTOGRA
	 ''			,; //X3_TELA
	 ''			,; //X3_POSLGT
	 'N'			,; //X3_IDXFLD
	 ''			,; //X3_AGRUP
	 'N'			,; //X3_MODAL
	 ''}) //X3_PYME

Return