#include "RWMAKE.CH"
#include "AP5MAIL.CH"
#include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSuporte   บ Autor ณ Jean Cavalcante    บ Data ณ  07/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Solicitacao de Suporte de Usuarios.					      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบMelhorias ณ AxCadastro para Solicitacao de Suporte de Usuarios.        บฑฑ
ฑฑบ06/10/06  ณ Inclusao de Filtro para Supervisor X Usuario.              บฑฑ
ฑฑบ			 ณ 														      บฑฑ
ฑฑบ			 ณ 													          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Todos os Modulos  - Uso especifico OMNILINK                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
   
User Function SUPORTE()
    
	Local aCores :=  {{"PZ8->PZ8_STATUS='1'"	,"ENABLE"}		,;			// 1=Chamado Aberto         (verde)
					  {"PZ8->PZ8_STATUS='2'"	,"BR_AMARELO"}	,;		   	// 2=Chamado em Andamento   (amarelo)
					  {"PZ8->PZ8_STATUS='3'"	,"DISABLE"}		,;		   	// 3=Chamado Encerrado      (vermelho)
					  {"PZ8->Pz8_STATUS='4'"	,"BR_AZUL"}}	  			// 4=Chamado em Pendencia   (azul)

	Private cCadastro := "Solicitacao Suporte de Usuarios"
	Private aRotina := { {"Pesquisar "		 ,"AxPesqui"		,0,1},;
    	                 {"Visualizar"		 ,"AxVisual"		,0,2},;
        	             {"Incluir"			 ,"u_ZIinclui() "	,0,3},;
            	         {"Atualiza"		 ,"u_ZIaltera() "	,0,4},;
                	     {"Encerra"			 ,"u_ZIencerra()"	,0,5},;
                    	 {"Analista Analise" ,"u_ZIaanalise()"	,0,6},;
                    	 {"Analista Solu็ใo" ,"u_ZIasolucao()"	,0,7},;
                    	 {"Pendencia" 		 ,"u_ZIpendencia()"	,0,8},;
	                     {"Legenda"			 ,"u_ZIlegenda()"	,0,9},;
						 {"Anexar Docto"	 ,"MsDocument"		,0,10}} 

	Private cDelFunc := ".T." 
	Private cString := "PZ8"
    Private cDireitos := " "

	_cUser_ssi	:=	GETMV("MV_XUSRSSI") // Parametro que Guarda os Usuarios que terao acesso a todos os chamados cadastrados

	dbSelectArea("PZX")
	dbSetOrder(1)
    Dbgotop()
    DbSeek(xfilial("PZX")+__CUSERID,.T.)
    
    while !eof() .and. __CUSERID == PZX->PZX_SUP
       cDireitos := cDireitos + "#" + PZX->PZX_FUNC
       Dbskip()
    End   

    cDireitos := cDireitos + "#" + __CUSERID   

	dbSelectArea("PZ8")
	dbSetOrder(1)

	if __CUSERID $ _cUser_ssi 
	    set filter to
	else	
	    set filter to PZ8->PZ8_CODSOL $ cDireitos  //PZ8->PZ8_CODSOL = __CUSERID  .and. PZ8->PZ8_CODSOL $ cDireitos
	endif

	mBrowse( 6, 1,22,75,cString,,,,,,aCores)
                                                                   
	set filter to
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณ ZILegenda                                                  บฑฑ
ฑฑบUso       ณ Exibe a Legenda dos Chamados                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function ZIlegenda()
BrwLegenda(cCadastro,"Legenda de Chamados",{	{"ENABLE","Chamado Aberto"},; 	
												{"BR_AMARELO","Chamado Em andamento"},;
												{"DISABLE","Chamado Encerrado"},;
												{"BR_AZUL","Chamado Em Pendencia"}}	)			

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณ ZIEncerra                                                  บฑฑ
ฑฑบUso       ณ Exibe a Legenda dos Chamados                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ZIencerra()

	if !__CUSERID $ _cUser_ssi 
		Alert("Voce nใo tem acesso para usar esta rotina!")
	    return
	endif

     if PZ8->PZ8_STATUS = "3"
        msginfo("Este chamado foi encerrado em "+dtoc(PZ8->PZ8_DTSOLU))
		return(.F.)
     Elseif PZ8->PZ8_STATUS = "4" .and. empty(PZ8_CLASOL)
        msginfo("Este chamado esta em Pendencia, Classificar a solucao!!")
		return(.F.)
     Elseif PZ8->PZ8_STATUS = "4" .and. !empty(PZ8->PZ8_PENDEN)
		msginfo("Este chamado jแ estแ pendente!! Para encerra-lo tirar de PENDENCIA!!!")
        Return(.F.)
     endif
     
	 if empty(PZ8_ANALIS) .or. empty(PZ8_CODANA) .or. empty(PZ8_SOLUCA) .or. empty(PZ8_CODASL) .or. empty(PZ8_CLASOL)
		msginfo("Atualize o chamado com todos os dados antes de encerrแ-lo.")
		return(.F.)		
	 else
		RecLock("PZ8",.F.)
		PZ8->PZ8_STATUS := "3"
		PZ8->PZ8_PORCEN := "100"
		PZ8->PZ8_DTSOLU := date()
		PZ8->PZ8_HRSOLU := TIME()
	    dbunlock()
		U_EnviaMail("E")		    
	 endif   
Return(.T.)


User Function ZIinclui()  

	dbselectarea("PZ8")
	_op := AxInclui("PZ8")	
	if _op == 1
	   	U_EnviaMail("I")	
	endif
Return(.T.)


User Function ZIpendencia()

	if !__CUSERID $ _cUser_ssi 
		Alert("Voce nใo tem acesso para usar esta rotina!")
	    return
	endif
    if PZ8->PZ8_STATUS = "4" .and. !empty(PZ8->PZ8_PENDEN)
		msginfo("Este chamado jแ estแ pendente!! Para tirar de PENDENCIA, Remover o motivo da pend๊ncia!!!")
        Return
    Elseif PZ8->PZ8_STATUS = "3"
		msginfo("Este chamado jแ estแ encerrado!!! Voc๊ nใo pode coloca-lo em pend๊ncia!!")
        Return
    Elseif PZ8->PZ8_STATUS = "4" .and. empty(PZ8->PZ8_PENDEN)
		msginfo("Este chamado serแ retirado do STATUS de PENDสNCIA!!")
		if !empty(PZ8->PZ8_CODANA)
			RecLock("PZ8",.F.)
			PZ8->PZ8_STATUS := "2"
	   		dbunlock()
		Endif
        Return
    Elseif EMPTY(PZ8->PZ8_PENDEN)
		msginfo("Atualize o motivo da PENDสNCIA, Motivo nใo preenchido!!!")
        Return
	Else    
	    if PZ8->PZ8_STATUS = "1" .or. PZ8->PZ8_STATUS = "2"
		   if !empty(PZ8->PZ8_CODANA)
				RecLock("PZ8",.F.)
				PZ8->PZ8_STATUS := "4"
			    dbunlock()
		   		U_EnviaMail("P")	
           Else
		   		msginfo("Preencher os dados do chamado, para deixa-lo em pend๊ncia!!")
		   endif
		endif
	Endif
Return(.T.)



User Function ZIaltera()

	if !__CUSERID $ _cUser_ssi 
		Alert("Voce nใo tem acesso para usar esta rotina!")
	    return
	endif
	
    if PZ8->PZ8_STATUS = "1" .or. PZ8->PZ8_STATUS = "2" .or. PZ8->PZ8_STATUS = "4"
	   AxAltera("PZ8",recno(),4)
	    
	   if !empty(PZ8->PZ8_ANALI)
			RecLock("PZ8",.F.)
			PZ8->PZ8_STATUS := "2"
		    dbunlock()
	    endif
	     
	 endif
Return(.T.)



User Function ZIaanalise()
	if !__CUSERID $ _cUser_ssi 
		Alert("Voce nใo tem acesso para usar esta rotina!")
	    return
	endif

    if PZ8->PZ8_STATUS = "1" .or. PZ8->PZ8_STATUS = "2"

		_op := AxAltera("PZ8",recno(),6)

	    if !empty(PZ8->PZ8_CODANA)
			RecLock("PZ8",.F.)
			PZ8->PZ8_STATUS := "2"
		    dbunlock()
			if _op == 1
	   			U_EnviaMail("A")	
			endif
	    endif
  	endif
Return(.T.)


User Function ZIasolucao()
	if !__CUSERID $ _cUser_ssi 
		Alert("Voce nใo tem acesso para usar esta rotina!")
	    return
	endif

    if PZ8->PZ8_STATUS = "1" .or. PZ8->PZ8_STATUS = "2"

		_op := AxAltera("PZ8",recno(),6)

	    if !empty(PZ8->PZ8_CODASL)
			RecLock("PZ8",.F.)
			PZ8->PZ8_STATUS := "2"
		    dbunlock()
			if _op == 1
	   			U_EnviaMail("S")	
			endif
	    endif
  	 endif
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnvMail   บAutor  ณJean Cavalcante     บ Data ณ  04/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz o envio do email para o usuario, conforme andamento do  บฑฑ
ฑฑบDesc.     ณchamado tecnico.											  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EnviaMail(opc)
  Local c_para     := GetMV('MV_XCHRESP') // Email para quem sera enviado abertura de chamado do usuario.
  Local cMensagem  	:= ''  
//  Local c_para 		:= ";jean.cavalcante@uol.com.br"  //Teste do envio.
  Local opcao  		:= opc
  Private cDescri   := PZ8->PZ8_DESCRI
  Private cAnalise  := PZ8->PZ8_ANALIS
  Private cSolucao  := PZ8->PZ8_SOLUCA
  Private c_CodMod  := PZ8->PZ8_MODUSP
  Private c_priori  := " "
  Private cPendencia:= " "
  Private c_nomeanal:= " "
  Private c_modulo	:= " "
  
  If Alltrim(PZ8->PZ8_PRIORI) == "A"
     c_priori:= "Alta."
  elseif Alltrim(PZ8->PZ8_PRIORI) == "M" 
     c_priori:= "Media."
  elseif Alltrim(PZ8->PZ8_PRIORI) == "B" 
     c_priori:= "Baixa."
  Endif	         

  DbselectArea("SX5")
  DbSetOrder(1)
  DbSeek(xfilial()+"Z6"+c_CodMod)

  c_modulo:=SX5->X5_DESCRI  
  
  DbSelectarea("PZ8")
  DbSetOrder(1)

  if opc == "I"
	  c_para  :=  alltrim(PZ8->PZ8_EMAIL) + c_para 
  	  cmensagem := EnvMail("\HTML\cham_abertura.htm", "C:\cham_abertura.HTML", c_para)

  elseif opc == "E"
	  c_para  :=  alltrim(PZ8->PZ8_EMAIL) + c_para 
      cCod_Anal:= PZ8->PZ8_CODASL
      DbSelectArea("PZ9")
      DbSetOrder(1)
      DBSeek(Xfilial()+cCod_Anal)
      c_nomeanal := PZ9->PZ9_NOME

  	  cmensagem := EnvMail_Fech("\HTML\cham_fechamento.htm", "C:\cham_fechamento.HTML", c_para)

  elseif opc == "A" 
	  c_para := " "
      cCod_Anal:= PZ8->PZ8_CODANA
      DbSelectArea("PZ9")
      DbSetOrder(1)
      DBSeek(Xfilial()+cCod_Anal)
      c_para := Alltrim(PZ9->PZ9_EMAIL) + ";" + alltrim(PZ8->PZ8_EMAIL)
      DbSelectArea("PZ8")  
      cmensagem := EnvMail_atrib("\HTML\cham_atrib_a.htm", "C:\cham_atrib_a.HTML", c_para)

  elseif opc == "S" 
	  c_para := " "
      cCod_Anal:= PZ8->PZ8_CODASL
      DbSelectArea("PZ9")
      DbSetOrder(1)
      DBSeek(Xfilial()+cCod_Anal)
      c_para := Alltrim(PZ9->PZ9_EMAIL) + ";" + alltrim(PZ8->PZ8_EMAIL)
      DbSelectArea("PZ8")  
   	  cmensagem := EnvMail_atrib("\HTML\cham_atrib_s.htm", "C:\cham_atrib_s.HTML", c_para)

  elseif opc == "P"
	  c_gestor := GetMV('MV_XCHRESP')
      c_Con_ANA:= " "
      c_Con_Sol:= " " 
      
      If PZ8->PZ8_PENDEN == "1"
         cpendencia := "Aguardando retorno do usuแrio."
      elseif PZ8->PZ8_PENDEN == "2" 
         cpendencia := "Aguardando retorno da Microsiga."
      elseif PZ8->PZ8_PENDEN == "3" 
         cpendencia := "Aguardando retorno de terceiros."
	  Endif	         

      If !empty(PZ8->PZ8_CODANA)
	      cCod_Ana:= PZ8->PZ8_CODANA
	      DbSelectArea("PZ9")
	      DbSetOrder(1)
	      DBSeek(Xfilial()+cCod_Ana)
		  c_Con_ANA:=PZ9->PZ9_NOME
	  Endif
	  
      If  !empty(PZ8->PZ8_CODASL)
	      cCod_Asl:= PZ8->PZ8_CODASL
	      DbSelectArea("PZ9")
	      DbSetOrder(1)
	      DBSeek(Xfilial()+cCod_Asl)
		  c_Con_SOL:=PZ9->PZ9_NOME
	  Endif    

	  c_para  :=  alltrim(PZ8->PZ8_EMAIL) + c_gestor

      DbSelectArea("PZ8")  
  	  cmensagem := EnvMail_Pend("\HTML\cham_pend.htm", "C:\cham_pend.HTML", c_para)

  endif
  return(nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnvMail   บAutor  ณAlexandre Martins   บ Data ณ  04/18/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz o envio do email para o usuario.                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnvMail(c_FileOrig, c_FileDest, c_para)

	Local l_Continua	:= .T.
	Private c_texto 	:= ''
	Private c_msgerro	:= ''
    cNome_user := u_Busca_nome(PZ8->PZ8_CODSOL)

	fArq(c_FileOrig, c_FileDest)

	If !U_FGEN010(c_para,"Abertura de Chamado Tecnico Microsiga - Num: "+PZ8->PZ8_COD+" Usuario: "+cnome_user+" ",c_texto,,.t.)	
		Return c_msgerro
	EndIf

Return ""

Static Function fArq(c_FileOrig, c_FileDest)

	Local l_Ret 	:= .T.
	Local c_Buffer	:= ""
	Local n_Posicao	:= 0
	Local n_QtdReg	:= 0
	Local n_RegAtu	:= 0

	If !File(c_FileOrig)
		l_Ret := .F.
		MsgStop("Arquivo [ "+c_FileOrig+" ] nใo localizado.", "Nใo localizou")
	Else
		
		Ft_fuse( c_FileOrig ) 		// Abre o arquivo
		Ft_FGoTop()
		n_QtdReg := Ft_fLastRec()
		
		nHandle	:= MSFCREATE( c_FileDest )

		///////////////////////////////////
		// Carregar o array com os itens //
		///////////////////////////////////
		While !ft_fEof() .And. l_Ret
			
			c_Buffer := ft_fReadln()
			
			FWrite(nHandle, &("'" + c_Buffer + "'"))
			c_texto += &("'" + c_Buffer + "'")
			ft_fSkip()
			
		Enddo
		
		FClose(nHandle)

	Endif
	
Return l_Ret
  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnvMail   บAutor  ณJean Cavalcante     บ Data ณ  04/18/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz o envio do email para o usuario.                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnvMail_Fech(c_FileOrig, c_FileDest, c_para)

	Local l_Continua	:= .T.
	Private c_texto 	:= ''
	Private c_msgerro	:= ''
    cNome_user := u_Busca_nome(PZ8->PZ8_CODSOL)

	fArq(c_FileOrig, c_FileDest)
 
	If !U_FGEN010(c_para,"Encerramento do Chamado Tecnico Microsiga Num: "+PZ8->PZ8_COD+" Usuario: "+cnome_user+" ",c_texto,,.t.)	
		Return c_msgerro
	EndIf

Return ""

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnvMail   บAutor  ณJean Cavalcante     บ Data ณ  11/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz o envio do email para o usuario.                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnvMail_Pend(c_FileOrig, c_FileDest, c_para)

	Local l_Continua	:= .T.
	Private c_texto 	:= ''
	Private c_msgerro	:= ''
    cNome_user := u_Busca_nome(PZ8->PZ8_CODSOL)

	fArq(c_FileOrig, c_FileDest)
 
	If !U_FGEN010(c_para,"PENDENCIA do Chamado Tecnico Microsiga Num: "+PZ8->PZ8_COD+" Usuario: "+cnome_user+" ",c_texto,,.t.)	
		Return c_msgerro
	EndIf

Return ""

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnvMail   บAutor  ณJean Cavalcante     บ Data ณ  04/18/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz o envio do email para o usuario.                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnvMail_Atrib(c_FileOrig, c_FileDest, c_para)

	Local l_Continua	:= .T.
	Private c_texto 	:= ''
	Private c_msgerro	:= ''
    cNome_user := U_Busca_nome(PZ8->PZ8_CODSOL)

	fArq(c_FileOrig, c_FileDest)

	If !U_FGEN010(c_para,"Atribuicao de chamado tecnico microsiga num: "+PZ8->PZ8_COD+" Usuario: "+cNome_user+" ",c_texto,,.t.)	
		Return c_msgerro
	EndIf

Return ""


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBusca_usu บAutor  ณJean Cavalcante     บ Data ณ  08/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna dados do cadastro dos usuarios.                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Busca_Depto(c_user) 

	c_user := Iif(c_user=Nil, __CUSERID,c_user)
	_aUser := {}
	
	psworder(1)
	pswseek(__CUSERID)
	_aUser := PSWRET()
	_cDepart	:= _aUser[1,12]				
	
Return(_cDepart)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBusca_usu บAutor  ณJean Cavalcante     บ Data ณ  08/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna dados do cadastro dos usuarios.                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Busca_Email(c_User) 

	c_user := Iif(c_User=Nil, __CUSERID, c_user)

	_aUser := {}
	psworder(1)
	pswseek(c_user)
	_aUser := PSWRET()

	_cEMail		:= Substr(_aUser[1,14],1,50)

Return(_cEmail) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVer_BLOQ  บAutor  ณJean Cavalcante     บ Data ณ  03/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se o consultor esta bloqueado.                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Ver_BLOQ(cChave)
DbSelectArea("PZ9")
DbSetOrder(1)
DbSeek(xfilial()+cChave)
c_bloqueio := PZ9->PZ9_BLOQUE 

if c_bloqueio = "2"
	msginfo("Este analista esta bloqueado para uso, nใo poderแ ser utilizado!")
    return(.F.)
Endif

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVer_BLOQ  บAutor  ณJean Cavalcante     บ Data ณ  03/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica quem tem acesso a atribuir chamado.                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Ver_ATRIB()
DbSelectarea("PZ8")

c_master := GETMV("MV_XMASTER") // Parametro que da direitos de atribuir os chamados.

if Empty(M->PZ8_CODANA)
	Return(.T.)
Elseif !__CUSERID $ c_master 
	msginfo("Voc๊ nใo tem acesso para atribuir chamados, Falar com Depto de TI!!")
    return(.F.)
endif
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBusca_NomeบAutor  ณJean Cavalcante     บ Data ณ  09/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca o Nome do Usuแrio Logado.				              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Busca_Nome(c_User) 

	c_user := Iif(c_User=Nil, __CUSERID, c_user)

	_aUser := {}
	psworder(1)
	pswseek(c_user)
	_aUser := PSWRET()

	_cnome		:= Substr(_aUser[1,4],1,50)

Return(_cnome) 



