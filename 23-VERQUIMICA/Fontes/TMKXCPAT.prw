#Include "Protheus.ch"

User Function TMKXCPAT()

Private dData := ParamIXB[1]
Private cCodCli := ParamIXB[2]
Private cCodLoja := ParamIXB[3]
Private cOperad := ParamIXB[4]
Private dDataEntrega := ParamIXB[5]
Private lMantemDataEntrega := ParamIXB[6]
Private lEditCmps := ParamIXB[7]

Return {dData,cCodCli,cCodLoja,cOperad,dDataEntrega,lMantemDataEntrega,lEditCmps}