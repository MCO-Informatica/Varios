//-----------------------------------------------------------------------
// Rotina | UPD260     | Autor | Robson Gonçalves     | Data | 27/11/2015
//-----------------------------------------------------------------------
// Descr. | Rotina de update - Campos da capa de despesa.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function UPD611()
	Local cModulo := 'COM'
	Local bPrepar := {||.T.}
	Local nVersao := 7
	
	If nVersao == 1
		bPrepar := {|| U_U611Ini() }
	Elseif nVersao == 2
		bPrepar := {|| U_U611Ini2() }
	Elseif nVersao == 3
		bPrepar := {|| U_U611Ini3() }
	Elseif nVersao == 4
		bPrepar := {|| U_U611Ini4() }
	Elseif nVersao == 5
		bPrepar := {|| U_U611Ini5() }
	Elseif nVersao == 6
		bPrepar := {|| U_U611Ini6() }
	Elseif nVersao == 7
		bPrepar := {|| U_U611Ini7() }
	Endif
	
	If nVersao > 0
		NGCriaUpd( cModulo, bPrepar, nVersao )
	Endif
Return

//-----------------------------------------------------------------------
// Rotina | U611Ini    | Autor | Robson Gonçalves     | Data | 27/11/2015
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U611Ini()
	/*****
	 *
	 * versão 1
	 *
	 */
	aSX7 := {}
	aSX3 := {}
	aHelp := {}

	AAdd( aSX3, { 'CTT',NIL,'CTT_GARFIX','C',6,0,'Grp.Ap.Fixo','Grp.Ap.Fixo','Grp.Ap.Fixo','Grp.Aprov.Recorrente Fixo','Grp.Aprov.Recorrente Fixo','Grp.Aprov.Recorrente Fixo','@!','','€€€€€€€€€€€€€€ ','','SAL',0,'þÀ','','','U','N','A','R','','Vazio().OR.ExistCpo("SAL")','','','','','','','','1','','','','','N','N','','' } )
	AAdd( aSX3, { 'CTT',NIL,'CTT_GARVAR','C',6,0,'Grp.Ap.Recor','Grp.Ap.Recor','Grp.Ap.Recor','Grp.Aprov.Recorrente Var.','Grp.Aprov.Recorrente Var.','Grp.Aprov.Recorrente Var.','@!','','€€€€€€€€€€€€€€ ','','SAL',0,'þÀ','','','U','N','A','R','','Vazio().OR.ExistCpo("SAL")','','','','','','','','1','','','','','N','N','','' } )
	AAdd( aSX3, { 'CTT',NIL,'CTT_GAPONT','C',6,0,'Grp.Ap.Pontu','Grp.Ap.Pontu','Grp.Ap.Pontu','Grupo de aprov. pontual','Grupo de aprov. pontual','Grupo de aprov. pontual','@!','','€€€€€€€€€€€€€€ ','','SAL',0,'þÀ','','','U','N','A','R','','Vazio().OR.ExistCpo("SAL")','','','','','','','','1','','','','','N','N','',''  } )
	
	AAdd( aSX3, { 'SC7',NIL,'C7_CCAPROV','C',9,0,'C.C.Aprov.','C.C.Aprov.','C.C.Aprov.','Centro Custo Aprovacao','Centro Custo Aprovacao','Centro Custo Aprovacao','@!','','€€€€€€€€€€€€€€ ','','CTT',0,'þÀ','','S','U','N','A','R','','Vazio() .Or. Ctb105CC()','','','','','','','','','','','','','N','N','',''  } )
	AAdd( aSX3, { 'SC7',NIL,'C7_DESCCCA','C',40,0,'Descr.C.C.Ap','Descr.C.C.Ap','Descr.C.C.Ap','Descric.C.Custo Aprovacao','Descric.C.Custo Aprovacao','Descric.C.Custo Aprovacao','@!','','€€€€€€€€€€€€€€ ','IIF(!INCLUI,POSICIONE("CTT",1,XFILIAL("CTT")+SC7->C7_CCAPROV,"CTT_DESC01"),"")','',0,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_GRPAPDE','C',6,0,'Grp. Aprov.','Grp. Aprov.','Grp. Aprov.','Grupo de aprovacao','Grupo de aprovacao','Grupo de aprovacao','@!','ExistCpo("SAL")','€€€€€€€€€€€€€€ ','','SAL',0,'þÀ','','S','U','N','A','R','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_DGRPADE','C',20,0,'Desc.G.Aprov','Desc.G.Aprov','Desc.G.Aprov','Descricao grupo aprovacao','Descricao grupo aprovacao','Descricao grupo aprovacao','@!','','€€€€€€€€€€€€€€ ','IIF(!INCLUI,POSICIONE("SAL",1,XFILIAL("SAL")+SC7->C7_GRPAPDE,"AL_DESC"),"")','',0,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_APBUDGE','C',1,0,'Aprov.Budget','Aprov.Budget','Aprov.Budget','Aprovado em budget?','Aprovado em budget?','Aprovado em budget?','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','Vazio().OR.Pertence("12")','1=Sim;2=Nao','1=Sim;2=Nao','1=Sim;2=Nao','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_DESCCOR','C',40,0,'Descr.CC Orc','Descr.CC Orc','Descr.CC Orc','Descricao conta orcada','Descricao conta orcada','Descricao conta orcada','@!','','€€€€€€€€€€€€€€ ','IIF(!INCLUI,POSICIONE("CT1",1,XFILIAL("CT1")+SC7->C7_CTAORC,"CT1_DESC01"),"")','',0,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_DEITCTA','C',40,0,'Desc.Cta.Res','Desc.Cta.Res','Desc.Cta.Res','Descricao conta resultado','Descricao conta resultado','Descricao conta resultado','@!','','€€€€€€€€€€€€€€ ','IIF(!INCLUI,POSICIONE("CTD",1,XFILIAL("CTD")+SC7->C7_ITEMCTA,"CTD_DESC01"),"")','',0,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_DESCLVL','C',40,0,'Descr.Proj.','Descr.Proj.','Descr.Proj.','Descricao do projeto','Descricao do projeto','Descricao do projeto','@!','','€€€€€€€€€€€€€€ ','IIF(!INCLUI,POSICIONE("CTH",1,XFILIAL("CTH")+SC7->C7_CLVL,"CTH_DESC01"),"")','',0,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_DESCRCP','M',10,0,'Descricao CP','Descricao CP','Descricao CP','Descricao CP','Descricao CP','Descricao CP','','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_EMISDOC','D',8,0,'Emiss.Doc.F.','Emiss.Doc.F.','Emiss.Doc.F.','Emissao documento fiscal','Emissao documento fiscal','Emissao documento fiscal','','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_DEPTO','C',30,0,'Departamento','Departamento','Departamento','Nome do departamento','Nome do departamento','Nome do departamento','@!','','€€€€€€€€€€€€€€ ','','SQB610',0,'þÀ','','','U','N','A','R','','Vazio().OR.ExistCpo("SQB",M->C7_DEPTO,2)','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_DESCCC','C',40,0,'D.C.C.Desp.','D.C.C.Desp.','D.C.C.Desp.','Descric. C. C. da despesa','Descric. C. C. da despesa','Descric. C. C. da despesa','@!','','€€€€€€€€€€€€€€ ','IIF(!INCLUI,POSICIONE("CTT",1,XFILIAL("CTT")+SC7->C7_CC,"CTT_DESC01"),"")','',0,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_RATCC','C',1,0,'Rateio C.C.','Rateio C.C.','Rateio C.C.','Rateio por centro custo','Rateio por centro custo','Rateio por centro custo','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','Vazio().OR.Pertence("12")','1=Sim;2=Nao','1=Sim;2=Nao','1=Sim;2=Nao','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_CTAORC','C',20,0,'Conta C. Orc','Conta C. Orc','Conta C. Orc','Conta contabil orcada','Conta contabil orcada','Conta contabil orcada','@S10','','€€€€€€€€€€€€€€ ','','CT1',0,'þÀ','','S','U','N','A','R','','Vazio() .Or. Ctb105Cta()','','','','','U_C610When("C7_CTAORC")','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_DOCFIS','C',9,0,'Nr.Doc.Fis.','Nr.Doc.Fis.','Nr.Doc.Fis.','Numero documento fiscal','Numero documento fiscal','Numero documento fiscal','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_FORMPG','C',15,0,'Forma Pagto.','Forma Pagto.','Forma Pagto.','Forma de pagamento','Forma de pagamento','Forma de pagamento','@!','','€€€€€€€€€€€€€€ ','','FPG610',0,'þÀ','','','U','N','A','R','','U_A610VFPg()','','','','','','','','','','','','','N','N','','' } )
	
	AAdd( aHelp, { 'CTT_GARFIX', 'Grupo de aprovação recorrente fixo.' } )
	AAdd( aHelp, { 'CTT_GARVAR', 'Grupo de aprovação recorrente variável.' } )
	AAdd( aHelp, { 'CTT_GAPONT', 'Grupo de aprovação pontual.' } )
	AAdd( aHelp, { 'C7_CCAPROV', 'Código do centro de custo do aprovador.' } )
	AAdd( aHelp, { 'C7_DESCCCA', 'Descrição do centro de custo do aprovador.' } )
	AAdd( aHelp, { 'C7_GRPAPDE', 'Código do grupo de aprovação da despesa.' } )
	AAdd( aHelp, { 'C7_DGRPADE', 'Descricao do grupo de aprovacao da despesa.' } )
	AAdd( aHelp, { 'C7_APBUDGE', 'Aprovado em budget? Sim ou Não.' } )
	AAdd( aHelp, { 'C7_CTAORC' , 'Código da conta contábil orçada.' } )
	AAdd( aHelp, { 'C7_DESCCOR', 'Descrição da conta contábil orçada.' } )
	AAdd( aHelp, { 'C7_DEITCTA', 'Descrição da conta de resultado orçada.' } )
	AAdd( aHelp, { 'C7_DESCLVL', 'Descricao do projeto.' } )
	AAdd( aHelp, { 'C7_DESCRCP', 'Descrição da capa de despesa' } )
	AAdd( aHelp, { 'C7_EMISDOC', 'Emissão doc documento fiscal.' } )
	
	AAdd(aSX7,{'C7_CC'     ,'002','CTT->CTT_DESC01','C7_DESCCC' ,'P','S','CTT',1,'xFilial("CTT")+M->C7_CC'     ,'','U'})
	AAdd(aSX7,{'C7_GRPAPDE','001','SAL->AL_DESC'   ,'C7_DGRPADE','P','S','SAL',1,'xFilial("SAL")+M->C7_GRPAPDE','','U'})
	AAdd(aSX7,{'C7_ITEMCTA','001','CTD->CTD_DESC01','C7_DEITCTA','P','S','CTD',1,'xFilial("CTD")+M->C7_ITEMCTA','','U'})
	AAdd(aSX7,{'C7_CLVL'   ,'001','CTH->CTH_DESC01','C7_DESCLVL','P','S','CTH',1,'xFilial("CTH")+M->C7_CLVL'   ,'','U'})
	AAdd(aSX7,{'C7_CCAPROV','001','CTT->CTT_DESC01','C7_DESCCCA','P','S','CTT',1,'xFilial("CTT")+M->C7_CCAPROV','','U'})
	AAdd(aSX7,{'C7_CTAORC' ,'001','CT1->CT1_DESC01','C7_DESCCOR','P','S','CT1',1,'xFilial("CT1")+M->C7_CTAORC' ,'','U'})
Return

//-----------------------------------------------------------------------
// Rotina | U611Ini2   | Autor | Robson Gonçalves     | Data | 07.01.2016
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U611Ini2()
	/*****
	 *
	 * versão 2
	 *
	 */
	aSX3 := {}
	aHelp := {}
	AAdd( aSX3, { 'SC7',NIL,'C7_DDORC','M',10,0,'D.Desp.Orc.','D.Desp.Orc.','D.Desp.Orc.','Descr. Desp. Orcamento','Descr. Desp. Orcamento','Descr. Desp. Orcamento','','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aHelp, { 'C7_DDORC', 'Descrição da despesa no orçamento.' } )
Return

//-----------------------------------------------------------------------
// Rotina | U611Ini3   | Autor | Robson Gonçalves     | Data | 07.01.2016
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U611Ini3()
	/*****
	 *
	 * versão 3
	 *
	 */
	aSX3 := {}
	aSX7 := {}
	aHelp := {}
	
	AAdd( aSX3, { 'SAK',NIL,'AK_VINCULO','C',8 ,0,'Vinculo'     ,'Vinculo'     ,'Vinculo'     ,'Vinculo funcional','Vinculo funcional'   ,'Vinculo funcional'   ,'@!'           ,''          ,'€€€€€€€€€€€€€€ ','','',1,'þÀ','','' ,'U','N','V','R','',''          ,'','','','','','','','','S','','','N','N','N','','' } )
	
	AAdd( aSX3, { 'CNZ',NIL,'CNZ_PERC'  ,'N',10,6,'% Rat.'      ,'% Rat.'      ,'% Rat.'      ,'% Rateio do Item' ,'% Rateio do Item'    ,'% Rateio do Item'    ,'@E 999.999999',''          ,'€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','S','N','A','R','','Positivo()','','','','','','','','','S','','','N','N','N','','' } )
	AAdd( aSX3, { 'CNZ',NIL,'CNZ_VLRAT' ,'N',9 ,2,'Valor Rateio','Valor Rateio','Valor Rateio','Valor do rateio'  ,'Valor do rateio'     ,'Valor do rateio'     ,'@E 999,999.99',''          ,'€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','A','R','','Positivo()','','','','','','','','','S','','','N','N','N','','' } )
	AAdd( aSX3, { 'SCH',NIL,'CH_PERC'   ,'N',10,6,'% Rat.'      ,'% Prorrat.'  ,'% Apport.'   ,'% Rateio do Item' ,'% Prorrateo del Item','% Item Apportionment','@E 999.999999','Positivo()','€€€€€€€€€€€€€€ ','','',1,'šÀ','','S','' ,'N','' ,'' ,'','Positivo()','','','','','','','','','S','','','N','N','N','','' } )
	AAdd( aSX3, { 'SCH',NIL,'CH_VLRAT'  ,'N',9 ,2,'Valor Rateio','Valor Rateio','Valor Rateio','Valor do rateio'  ,'Valor do rateio'     ,'Valor do rateio'     ,'@E 999,999.99',''          ,'€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','A','R','','Positivo()','','','','','','','','','S','','','N','N','N','','' } )
	AAdd( aSX3, { 'SDE',NIL,'DE_PERC'   ,'N',10,6,'% Rat.'      ,'% Prorrateo' ,'Pror. %'     ,'% Rateio do Item' ,'% Prorrateo del Item','Item Proration %'    ,'@E 999.999999',''          ,'€€€€€€€€€€€€€€ ','','',1,'šÀ','','S','' ,'N','' ,'' ,'','Positivo()','','','','','','','','','S','','','N','N','N','','' } ) 
	AAdd( aSX3, { 'SDE',NIL,'DE_VLRAT'  ,'N',9 ,2,'Valor Rateio','Valor Rateio','Valor Rateio','Valor do rateio'  ,'Valor do rateio'     ,'Valor do rateio'     ,'@E 999,999.99',''          ,'€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','A','R','','Positivo()','','','','','','','','','S','','','N','N','N','','' } )

	AAdd( aSX3, { 'SDE',NIL,'DE_DESCTT','C',40,0,'Descr.CCusto','Descr.CCusto','Descr.CCusto','Descr. Centro Custo','Descr. Centro Custo','Descr. Centro Custo','@!','','€€€€€€€€€€€€€€ ','IIF(!INCLUI,POSICIONE("CTT",1,XFILIAL("CTT")+SDE->DE_CC,"CTT_DESC01"),"")','',1,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SDE',NIL,'DE_DESCT1','C',40,0,'Desc.CContab','Desc.CContab','Desc.CContab','Descr. Cta. Contabil','Descr. Cta. Contabil','Descr. Cta. Contabil','@!','','€€€€€€€€€€€€€€ ','IIF(!INCLUI,POSICIONE("CT1",1,XFILIAL("CT1")+SDE->DE_CONTA,"CT1_DESC01"),"")','',1,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SDE',NIL,'DE_DESCTD','C',40,0,'Desc.C.Resul','Desc.C.Resul','Desc.C.Resul','Descr. Centro Resultado','Descr. Centro Resultado','Descr. Centro Resultado','@!','','€€€€€€€€€€€€€€ ','IIF(!INCLUI,POSICIONE("CTD",1,XFILIAL("CTD")+SDE->DE_ITEMCTA,"CTD_DESC01"),"")','',1,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SDE',NIL,'DE_DESCTH','C',40,0,'Desc.Projeto','Desc.Projeto','Desc.Projeto','Descr. Projeto','Descr. Projeto','Descr. Projeto','@!','','€€€€€€€€€€€€€€ ','IIF(!INCLUI,POSICIONE("CTH",1,XFILIAL("CTH")+SDE->DE_CLVL,"CTH_DESC01"),"")','',1,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','' } )
	
	AAdd( aSX3, { 'SCH',NIL,'CH_DESCTT','C',40,0,'Descr.CCusto','Descr.CCusto','Descr.CCusto','Descr. Centro Custo','Descr. Centro Custo','Descr. Centro Custo','@!','','€€€€€€€€€€€€€€ ','IIF(!INCLUI,POSICIONE("CTT",1,XFILIAL("CTT")+SCH->CH_CC,"CTT_DESC01"),"")','',1,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SCH',NIL,'CH_DESCT1','C',40,0,'Desc.CContab','Desc.CContab','Desc.CContab','Descr. Cta. Contabil','Descr. Cta. Contabil','Descr. Cta. Contabil','@!','','€€€€€€€€€€€€€€ ','IIF(!INCLUI,POSICIONE("CT1",1,XFILIAL("CT1")+SCH->CH_CONTA,"CT1_DESC01"),"")','',1,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SCH',NIL,'CH_DESCTD','C',40,0,'Desc.C.Resul','Desc.C.Resul','Desc.C.Resul','Descr. Centro Resultado','Descr. Centro Resultado','Descr. Centro Resultado','@!','','€€€€€€€€€€€€€€ ','IIF(!INCLUI,POSICIONE("CTD",1,XFILIAL("CTD")+SCH->CH_ITEMCTA,"CTD_DESC01"),"")','',1,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SCH',NIL,'CH_DESCTH','C',40,0,'Desc.Projeto','Desc.Projeto','Desc.Projeto','Descr. Projeto','Descr. Projeto','Descr. Projeto','@!','','€€€€€€€€€€€€€€ ','IIF(!INCLUI,POSICIONE("CTH",1,XFILIAL("CTH")+SCH->CH_CLVL,"CTH_DESC01"),"")','',1,'þÀ','','','U','N','V','V','','','','','','','','','','','','','','','N','N','','' } )
	
	AAdd( aSX3, { 'CNZ',NIL,'CNZ_DESCTT','C',40,0,'Descr.CCusto','Descr.CCusto','Descr.CCusto','Descr. Centro Custo','Descr. Centro Custo','Descr. Centro Custo','@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	AAdd( aSX3, { 'CNZ',NIL,'CNZ_DESCT1','C',40,0,'Desc.CContab','Desc.CContab','Desc.CContab','Descr. Cta. Contabil','Descr. Cta. Contabil','Descr. Cta. Contabil','@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	AAdd( aSX3, { 'CNZ',NIL,'CNZ_DESCTD','C',40,0,'Desc.C.Resul','Desc.C.Resul','Desc.C.Resul','Descr. Centro Resultado','Descr. Centro Resultado','Descr. Centro Resultado','@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	AAdd( aSX3, { 'CNZ',NIL,'CNZ_DESCTH','C',40,0,'Desc.Projeto','Desc.Projeto','Desc.Projeto','Descr. Projeto','Descr. Projeto','Descr. Projeto','@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )

	AAdd( aHelp, { 'AK_VINCULO' , 'Vínculo funcional do aprovador [AABBBBBB] - A=Filial e B=Matrícula.' } )
	AAdd( aHelp, { 'CNZ_VLRAT'  , 'Valor monetário do rateio.' } )
	AAdd( aHelp, { 'CH_VLRAT'   , 'Valor monetário do rateio.' } )
	AAdd( aHelp, { 'DE_VLRAT'   , 'Valor monetário do rateio.' } )

	AAdd( aSX7, { 'CH_PERC'  ,'001','U_A610Rateio("SCH")','CH_VLRAT' ,'P','N','',0,'','','U' } )
	AAdd( aSX7, { 'CH_VLRAT' ,'001','U_A610Rateio("SCH")','CH_PERC'  ,'P','N','',0,'','','U' } )
	
	AAdd( aSX7, { 'DE_PERC'  ,'001','U_A610Rateio("SDE")','DE_VLRAT' ,'P','N','',0,'','','U' } )
	AAdd( aSX7, { 'DE_VLRAT' ,'001','U_A610Rateio("SDE")','DE_PERC'  ,'P','N','',0,'','','U' } )
	
	AAdd( aSX7, { 'CNZ_PERC' ,'002','U_A610Rateio("CNZ")','CNZ_VLRAT','P','N','',0,'','','U' } )
	AAdd( aSX7, { 'CNZ_VLRAT','001','U_A610Rateio("CNZ")','CNZ_PERC' ,'P','N','',0,'','','U' } )
	
	AAdd( aSX7, { 'DE_CC'     ,'001','CTT->CTT_DESC01','DE_DESCTT','P','S','CTT',1,'XFILIAL("CTT")+M->DE_CC'     ,'','U' } )
	AAdd( aSX7, { 'DE_CONTA'  ,'001','CT1->CT1_DESC01','DE_DESCT1','P','S','CT1',1,'XFILIAL("CT1")+M->DE_CONTA'  ,'','U' } )
	AAdd( aSX7, { 'DE_ITEMCTA','001','CTD->CTD_DESC01','DE_DESCTD','P','S','CTD',1,'XFILIAL("CTD")+M->DE_ITEMCTA','','U' } )
	AAdd( aSX7, { 'DE_CLVL'   ,'001','CTH->CTH_DESC01','DE_DESCTH','P','S','CTH',1,'XFILIAL("CTH")+M->DE_CLVL'  ,'','U' } )
	
	AAdd( aSX7, { 'CH_CC'     ,'002','CTT->CTT_DESC01','CH_DESCTT','P','S','CTT',1,'XFILIAL("CTT")+M->CH_CC'     ,'','U' } )
	AAdd( aSX7, { 'CH_CONTA'  ,'001','CT1->CT1_DESC01','CH_DESCT1','P','S','CT1',1,'XFILIAL("CT1")+M->CH_CONTA'  ,'','U' } )
	AAdd( aSX7, { 'CH_ITEMCTA','001','CTD->CTD_DESC01','CH_DESCTD','P','S','CTD',1,'XFILIAL("CTD")+M->CH_ITEMCTA','','U' } )
	AAdd( aSX7, { 'CH_CLVL'   ,'001','CTH->CTH_DESC01','CH_DESCTH','P','S','CTH',1,'XFILIAL("CTH")+M->CH_CLVL'   ,'','U' } )
	
	AAdd( aSX7, { 'CNZ_CC'    ,'001','CTT->CTT_DESC01','CNZ_DESCTT','P','S','CTT',1,'XFILIAL("CTT")+M->CNZ_CC'    ,'','U' } )
	AAdd( aSX7, { 'CNZ_CONTA' ,'001','CT1->CT1_DESC01','CNZ_DESCT1','P','S','CT1',1,'XFILIAL("CT1")+M->CNZ_CONTA' ,'','U' } )
	AAdd( aSX7, { 'CNZ_ITEMCT','001','CTD->CTD_DESC01','CNZ_DESCTD','P','S','CTD',1,'XFILIAL("CTD")+M->CNZ_ITEMCT','','U' } )
	AAdd( aSX7, { 'CNZ_CLVL'  ,'001','CTH->CTH_DESC01','CNZ_DESCTH','P','S','CTH',1,'XFILIAL("CTH")+M->CNZ_CLVL'  ,'','U' } )
Return

//-----------------------------------------------------------------------
// Rotina | U611Ini4   | Autor | Robson Gonçalves     | Data | 28.01.2016
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U611Ini4()
	/*****
	 *
	 * versão 4
	 *
	 */
	aSX3 := {}
	
	AAdd( aSX3, { 'SDE',NIL,'DE_DESCTT','C',40,0,'Descr.CCusto','Descr.CCusto','Descr.CCusto','Descr. Centro Custo','Descr. Centro Custo','Descr. Centro Custo'             ,'@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	AAdd( aSX3, { 'SDE',NIL,'DE_DESCT1','C',40,0,'Desc.CContab','Desc.CContab','Desc.CContab','Descr. Cta. Contabil','Descr. Cta. Contabil','Descr. Cta. Contabil'          ,'@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	AAdd( aSX3, { 'SDE',NIL,'DE_DESCTD','C',40,0,'Desc.C.Resul','Desc.C.Resul','Desc.C.Resul','Descr. Centro Resultado','Descr. Centro Resultado','Descr. Centro Resultado' ,'@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	AAdd( aSX3, { 'SDE',NIL,'DE_DESCTH','C',40,0,'Desc.Projeto','Desc.Projeto','Desc.Projeto','Descr. Projeto','Descr. Projeto','Descr. Projeto'                            ,'@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	
	AAdd( aSX3, { 'SCH',NIL,'CH_DESCTT','C',40,0,'Descr.CCusto','Descr.CCusto','Descr.CCusto','Descr. Centro Custo','Descr. Centro Custo','Descr. Centro Custo'             ,'@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	AAdd( aSX3, { 'SCH',NIL,'CH_DESCT1','C',40,0,'Desc.CContab','Desc.CContab','Desc.CContab','Descr. Cta. Contabil','Descr. Cta. Contabil','Descr. Cta. Contabil'          ,'@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	AAdd( aSX3, { 'SCH',NIL,'CH_DESCTD','C',40,0,'Desc.C.Resul','Desc.C.Resul','Desc.C.Resul','Descr. Centro Resultado','Descr. Centro Resultado','Descr. Centro Resultado' ,'@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	AAdd( aSX3, { 'SCH',NIL,'CH_DESCTH','C',40,0,'Desc.Projeto','Desc.Projeto','Desc.Projeto','Descr. Projeto','Descr. Projeto','Descr. Projeto'                            ,'@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	
	AAdd( aSX3, { 'CNZ',NIL,'CNZ_DESCTT','C',40,0,'Descr.CCusto','Descr.CCusto','Descr.CCusto','Descr. Centro Custo','Descr. Centro Custo','Descr. Centro Custo'            ,'@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	AAdd( aSX3, { 'CNZ',NIL,'CNZ_DESCT1','C',40,0,'Desc.CContab','Desc.CContab','Desc.CContab','Descr. Cta. Contabil','Descr. Cta. Contabil','Descr. Cta. Contabil'         ,'@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	AAdd( aSX3, { 'CNZ',NIL,'CNZ_DESCTD','C',40,0,'Desc.C.Resul','Desc.C.Resul','Desc.C.Resul','Descr. Centro Resultado','Descr. Centro Resultado','Descr. Centro Resultado','@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	AAdd( aSX3, { 'CNZ',NIL,'CNZ_DESCTH','C',40,0,'Desc.Projeto','Desc.Projeto','Desc.Projeto','Descr. Projeto','Descr. Projeto','Descr. Projeto'                           ,'@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','S','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
Return

//-----------------------------------------------------------------------
// Rotina | U611Ini5   | Autor | Robson Gonçalves     | Data | 18.02.2016
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U611Ini5()
	/*****
	 *
	 * versão 5
	 *
	 */
	aSX3 := {}
	AAdd( aSX3, { 'SCR',NIL,'CR_MAIL_ID','C',20,0,'Mail ID','Mail ID','Mail ID','Mail ID','Mail ID','Mail ID','@!','','€€€€€€€€€€€€€€ ','','',1,'þÀ','','','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
	AAdd( aSX3, { 'SCR',NIL,'CR_LOG'    ,'M',10,0,'Log'    ,'Log'    ,'Log'    ,'Log'    ,'Log'    ,'Log'    ,''  ,'','€€€€€€€€€€€€€€ ','','',1,'þÀ','','','U','N','V','R','','','','','','','','','','','','','','N','N','N','','' } )
Return

//-----------------------------------------------------------------------
// Rotina | U611Ini6   | Autor | Robson Gonçalves     | Data | 28.03.2016
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U611Ini6()
	/*****
	 *
	 * versão 6
	 *
	 */
	aSX3 := {}
	AAdd( aSX3, { 'SC7',NIL,'C7_DOCFIS','C',20,0,'Nr.Doc.Fis.','Nr.Doc.Fis.','Nr.Doc.Fis.','Numero documento fiscal','Numero documento fiscal','Numero documento fiscal','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','','','','','','','','','','','','','','N','N','','' } )
	AAdd( aSX3, { 'SC7',NIL,'C7_CNPJ'  ,'C',14,0,'CNPJ Filial','CNPJ Filial','CNPJ Filial','CNPJ Filial'            ,'CNPJ Filial'            ,'CNPJ Filial'            ,'@R 99.999.999/9999-99','','€€€€€€€€€€€€€€ ','','C7CNPJ',0,'þÀ','','','U','N','A','R','','','','','','','','','','','','','','','N','N','','' } )
Return

//-----------------------------------------------------------------------
// Rotina | U611Ini7   | Autor | Robson Gonçalves     | Data | 14.09.2016
//-----------------------------------------------------------------------
// Descr. | Rotina auxiliar do update.
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function U611Ini7()
	/*****
	 *
	 * versão 6
	 *
	 */
	aSX3 := {}
	AAdd( aSX3, { 'CT1',NIL,'CT1_NOTDES','C',1,0,'Notif. Desp.','Notif. Desp.','Notif. Desp.','Notifica despesa?','Notifica despesa?','Notifica despesa?','@!','','€€€€€€€€€€€€€€ ','','',0,'þÀ','','','U','N','A','R','','Vazio().OR.Pertence("12")','1=Sim;2=Nao','1=Sim;2=Nao','1=Sim;2=Nao','','','','','','','','','','N','N','','' } )
	AAdd( aHelp, { 'CT1_NOTDES', 'Esta conta contábil quando utilizada no pedido de compras deve notificar o gestor do centro de custo? Sim ou Não.' } )	
Return