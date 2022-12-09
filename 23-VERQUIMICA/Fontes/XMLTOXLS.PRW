#INCLUDE "TOTVS.CH"
#include "PROTHEUS.CH"
#include "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "TBICONN.CH"

//===========================================================================
// Programa.....: XMLTOXLS
// Data.........: 20/06/2021
// Autor........: Anderson Goncalves
// Descrição....: Leitura de arquivo xml passada para excel
// Uso..........: Verquimica
//===========================================================================

User Function XMLTOXLS()

//==============================================
// Variaveis da Rotina
//==============================================
Local aSays         := {}
Local aButtons      := {}
Local nOpcA         := 0

Private cCadastro   := "Leitura XML para extração em Excel"
Private aArquivos   := {}
Private cPasta      := ""

If !ApOleClient("MSExcel")
    MsgInfo("Este programa funciona apenas com o excel instalado na maquina executada!","Sem Excel")
    Return Nil
EndIf	

aAdd(aSays,OemToAnsi(cCadastro ))
aAdd(aSays,OemToAnsi(""))
aAdd(aSays,OemToAnsi("Este programa tem como objetivo a realização de leitura de notas fiscais e extração"))
aAdd(aSays,OemToAnsi("dos dados em planilha excel.")) 
aAdd(aSays,OemToAnsi(""))
aAdd(aSays,OemToAnsi("Clique em parametros para filtragem dos registros "))

aAdd(aButtons, { 1,.T.,{|o| nOpcA:= 1,o:oWnd:End() } 					})
aAdd(aButtons, { 2,.T.,{|o| o:oWnd:End() }								})

FormBatch( cCadastro, aSays, aButtons )

If nOpcA == 1
    cPasta := cGetFile(,"Selecione o diretorio",,"",.T.,GETF_LOCALFLOPPY+GETF_LOCALHARD+128)
    aArquivos := Directory(cPasta+"*.xml")   

	Processa({|| Converte()},"Processando...")

EndIf

Return Nil

//===========================================================================
// Programa.....: Converte
// Data.........: 20/06/2021
// Autor........: Anderson Goncalves
// Descrição....: Programa principal
// Uso..........: Verquimica
//===========================================================================

Static Function Converte()

//=============================================
// Variaveis da Rotina
//=============================================
Local nX            := 0
Local nY            := 0
Local nLinha        := 0
Local cExcel        := "Planilha_"+dtos(Date())+"_"+Replace(Time(),":","")
Local oExcel		:= Nil
Local cFolder1	    := "Notas Fiscais"
Local cTabela		:= "Análise dos Créditos dos PIS e COFINS - Base Cédito ICMS"

Local cNfiscal      := ""
Local dEmissao      := ""
Local cProduto      := ""
Local cCfop         := ""
Local cUm           := ""
Local nQuant        := 0
Local nUnit         := 0
Local nTotal        := 0
Local nAliPis       := 0
Local nValPis       := 0
Local nAliCof       := 0
Local nValCof       := 0

Local oXml          := Nil
Local cError        := ""
Local cWarning      := ""

cExcel  := GetTempPath()+cExcel+".xml"

//============================================================
// Cria arquivo em excel
//============================================================
oExcel  := FWMSExcel():New()

//============================================================
// Criacao do folder
//============================================================  	   				 		 		 	 				 	  	   	   	  	  	
oExcel:AddworkSheet(cFolder1)
oExcel:AddTable (cFolder1,cTabela)
oExcel:AddColumn(cFolder1,cTabela,"NF"              ,1) 
oExcel:AddColumn(cFolder1,cTabela,"DATA"            ,2) 
oExcel:AddColumn(cFolder1,cTabela,"PRODUTO"	        ,1) 
oExcel:AddColumn(cFolder1,cTabela,"CFOP"	        ,2) 
oExcel:AddColumn(cFolder1,cTabela,"QTDE"            ,3) 
oExcel:AddColumn(cFolder1,cTabela,"UM"              ,2) 
oExcel:AddColumn(cFolder1,cTabela,"UNITARIO"        ,3) 
oExcel:AddColumn(cFolder1,cTabela,"TOTAL"           ,3) 
oExcel:AddColumn(cFolder1,cTabela,"BASE ICMS"       ,3) 
oExcel:AddColumn(cFolder1,cTabela,"ALIQ ICMS"       ,3) 
oExcel:AddColumn(cFolder1,cTabela,"VALOR ICMS"      ,3) 
oExcel:AddColumn(cFolder1,cTabela,"ALIQ PIS"        ,3) 
oExcel:AddColumn(cFolder1,cTabela,"VALOR PIS"       ,3) 
oExcel:AddColumn(cFolder1,cTabela,"ALIQ COFINS"     ,3) 
oExcel:AddColumn(cFolder1,cTabela,"VALOR COFINS"    ,3) 

ProcRegua(Len(aArquivos))

//============================================================
// Leitura do xml
//============================================================  
For nX := 1 To Len(aArquivos)

    IncProc("Gerando excel, aguarde...")

    //=========================================================
    // Verifica se conseguiu abrir o arquivo xml 
    //=========================================================
     If !ExistDir("\xml\")
        MakeDir( "\xml\" )
    EndIf
    CpyT2S( cPasta+aArquivos[nX,1], "\xml\" )
    oXml := XmlParserFile("\xml\"+aArquivos[nX,1],"_",@cError,@cWarning)	
    If (oXml == NIL )
        CursorArrow()
        MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
        Return Nil
    Endif
    
    If "PROCNFE.XML" $ aArquivos[nX,1]
  
        nLinha := If(ValType(oXml:_nfeproc:_nfe:_infnfe:_det)=="A",Len(oXml:_nfeproc:_nfe:_infnfe:_det),1)

        For nY := 1 To nLinha

            nAliICMS  := 0
            nBasICMS  := 0
            nValICMS  := 0

            If nLinha == 1
                dEmissao  := TransForm(stod(Replace(oXml:_nfeproc:_nfe:_infnfe:_ide:_demi:TEXT,"-","")),"@D")
                cNfiscal  := oXml:_nfeproc:_nfe:_infnfe:_ide:_nnf:TEXT
                cProduto  := oXml:_nfeproc:_nfe:_infnfe:_det:_prod:_cprod:TEXT
                cUm       := oXml:_nfeproc:_nfe:_infnfe:_det:_prod:_uTrib:TEXT
                cCfop     := oXml:_nfeproc:_nfe:_infnfe:_det:_prod:_cfop:TEXT
                nQuant    := Val(oXml:_nfeproc:_nfe:_infnfe:_det:_prod:_qTrib:TEXT)
                nUnit     := Val(oXml:_nfeproc:_nfe:_infnfe:_det:_prod:_vUnTrib:TEXT)
                nTotal    := Val(oXml:_nfeproc:_nfe:_infnfe:_det:_prod:_vprod:TEXT)

                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms, "_ICMS00")) == "O"
                nAliICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms00:_picms:TEXT)
                nBasICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms00:_vbc:TEXT)
                nValICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms00:_vicms:TEXT)
                EndIf
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms, "_ICMS10")) == "O"
                    nAliICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms10:_picms:TEXT)
                    nBasICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms10:_vbc:TEXT)
                    nValICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms10:_vicms:TEXT)
                EndIf
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms, "_ICMS20")) == "O"
                    nAliICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms20:_picms:TEXT)
                    nBasICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms20:_vbc:TEXT)
                    nValICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms20:_vicms:TEXT)
                EndIf
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms, "_ICMS50")) == "O"
                    nAliICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms50:_picms:TEXT)
                    nBasICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms50:_vbc:TEXT)
                    nValICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms50:_vicms:TEXT)
                EndIf
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms, "_ICMS80")) == "O"
                    nAliICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms80:_picms:TEXT)
                    nBasICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms80:_vbc:TEXT)
                    nValICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms80:_vicms:TEXT)
                EndIf
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms, "_ICMS90")) == "O"
                    nAliICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms90:_picms:TEXT)
                    nBasICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms90:_vbc:TEXT)
                    nValICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_icms:_icms90:_vicms:TEXT)
                EndIf

                nAliPIS   := 0
                nBasPIS   := 0
                nValPIS   := 0
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_pis,"_PISALIQ")) == "O"
                    If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_pis:_pisaliq, "_PPIS")) == "O"
                        nAliPIS   := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_pis:_pisaliq:_ppis:TEXT)
                        nBasPIS   := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_pis:_pisaliq:_vbc:TEXT)
                        nValPIS   := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_pis:_pisaliq:_vpis:TEXT)
                    Endif
                Endif

                nAliCOF   := 0
                nBasCOF   := 0
                nValCOF   := 0
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_cofins,"_COFINSALIQ")) == "O"
                    If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_cofins:_cofinsaliq,"_PCOFINS")) == "O"
                        nAliCOF   := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_cofins:_cofinsaliq:_pcofins:TEXT)
                        nBasCOF   := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_cofins:_cofinsaliq:_vbc:TEXT)
                        nValCOF   := Val(oXml:_nfeproc:_nfe:_infnfe:_DET:_imposto:_cofins:_cofinsaliq:_vcofins:TEXT)
                    EndIf
                EndIf

            Else

                dEmissao  := TransForm(stod(Replace(oXml:_nfeproc:_nfe:_infnfe:_ide:_demi:TEXT,"-","")),"@D")
                cNfiscal  := oXml:_nfeproc:_nfe:_infnfe:_ide:_nnf:TEXT
                cProduto  := oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_prod:_cprod:TEXT
                cUm       := oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_prod:_uTrib:TEXT
                cCfop     := oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_prod:_cfop:TEXT
                nQuant    := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_prod:_qTrib:TEXT)
                nUnit     := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_prod:_vUnTrib:TEXT)
                nTotal    := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_prod:_vprod:TEXT)

                //=======================================
                // Bloca de ICMS
                //=======================================
                nAliICMS  := 0
                nBasICMS  := 0
                nValICMS  := 0 

                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms, "_ICMS00")) == "O"
                    nAliICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms00:_picms:TEXT)
                    nBasICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms00:_vbc:TEXT)
                    nValICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms00:_vicms:TEXT)
                EndIf
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms, "_ICMS10")) == "O"
                    nAliICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms10:_picms:TEXT)
                    nBasICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms10:_vbc:TEXT)
                    nValICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms10:_vicms:TEXT)
                EndIf
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms, "_ICMS20")) == "O"
                    nAliICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms20:_picms:TEXT)
                    nBasICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms20:_vbc:TEXT)
                    nValICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms20:_vicms:TEXT)
                EndIf
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms, "_ICMS50")) == "O"
                    nAliICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms50:_picms:TEXT)
                    nBasICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms50:_vbc:TEXT)
                    nValICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms50:_vicms:TEXT)
                EndIf
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms, "_ICMS80")) == "O"
                    nAliICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms80:_picms:TEXT)
                    nBasICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms80:_vbc:TEXT)
                    nValICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms80:_vicms:TEXT)
                EndIf
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms, "_ICMS90")) == "O"
                    nAliICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms90:_picms:TEXT)
                    nBasICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms90:_vbc:TEXT)
                    nValICMS  := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_icms:_icms90:_vicms:TEXT)
                EndIf
                /*
                nAliIPI   := 0
                nBasIPI   := 0
                nValIPI   := 0
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_ipi,"_IPITRIB")) == "O"
                        If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_ipi:_ipitrib,"_PIPI")) == "O"
                            nAliIPI   := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_ipi:_ipitrib:_pipi:TEXT)
                            nBasIPI   := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_ipi:_ipitrib:_vbc:TEXT)
                            nValIPI   := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_ipi:_ipitrib:_vipi:TEXT)
                    EndIf
                EndIf 
                */
                nAliPIS   := 0
                nBasPIS   := 0
                nValPIS   := 0
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_pis,"_PISALIQ")) == "O"
                    If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_pis:_pisaliq, "_PPIS")) == "O"
                            nAliPIS   := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_pis:_pisaliq:_ppis:TEXT)
                            nBasPIS   := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_pis:_pisaliq:_vbc:TEXT)
                            nValPIS   := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_pis:_pisaliq:_vpis:TEXT)
                    Endif
                Endif

                nAliCOF   := 0
                nBasCOF   := 0
                nValCOF   := 0
                If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_cofins,"_COFINSALIQ")) == "O"
                    If ValType(XmlChildEx(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_cofins:_cofinsaliq,"_PCOFINS")) == "O"
                            nAliCOF   := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_cofins:_cofinsaliq:_pcofins:TEXT)
                            nBasCOF   := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_cofins:_cofinsaliq:_vbc:TEXT)
                            nValCOF   := Val(oXml:_nfeproc:_nfe:_infnfe:_det[nY]:_imposto:_cofins:_cofinsaliq:_vcofins:TEXT)
                    EndIf
                EndIf
                
            EndIf

            If nValCof > 0 .and. nValPis > 0

                oExcel:AddRow(cFolder1,cTabela,{cNfiscal,;
                                                dEmissao,;
                                                cProduto,;
                                                cCfop,;
                                                nQuant,;
                                                cUm,;
                                                nUnit,;
                                                nTotal,;
                                                nBasICMS,;
                                                nAliICMS,;
                                                nValICMS,;
                                                nAliPis,;
                                                nValPis,;
                                                nAliCof,;
                                                nValCof })
            EndIf
       Next nY
    EndIf
    oXml := Nil

Next nX


//=======================================================
// Finaliza e abre o excel
//=======================================================
oExcel:Activate()
oExcel:GetXMLFile(cExcel)
      
oExcelApp := MsExcel():New()         
oExcelApp:WorkBooks:Open(cExcel)  
oExcelApp:SetVisible(.T.)       
oExcelApp:Destroy() 

Return Nil





            



