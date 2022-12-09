#INCLUDE "TOTVS.CH"

//Renato Ruy - 15/01/2018
//Adicionar os campos na tabela GTLEGADO

user function UPDREM05()

Local nRet := 0

RpcSetType(3)
RpcSetEnv("01","02")

nRet := TCSqlExec("ALTER TABLE GTLEGADO ADD (GT_TXMANUT NUMBER DEFAULT 0.0 )")

if (nRet < 0)
	conout("Campo 1 - TCSQLError() " + TCSQLError())
endif

nRet := TCSqlExec("ALTER TABLE GTLEGADO ADD (GT_TXPAGO NUMBER DEFAULT 0.0 )")

if (nRet < 0)
	conout("Campo 2 - TCSQLError() " + TCSQLError())
endif

nRet := TCSqlExec("ALTER TABLE GTLEGADO ADD (GT_TXRECEB NUMBER DEFAULT 0.0 )")

if (nRet < 0)
	conout("Campo 3 - TCSQLError() " + TCSQLError())
endif

nRet := TCSqlExec("ALTER TABLE GTLEGADO ADD (GT_TXPARC NUMBER DEFAULT 0.0 )")

if (nRet < 0)
	conout("Campo 4 - TCSQLError() " + TCSQLError())
endif


nRet := TCSqlExec("ALTER TABLE GTLEGADO ADD (GT_PEDSITE CHAR(10 BYTE) DEFAULT '          ' NOT NULL)")

if (nRet < 0)
	conout("Campo 5 - TCSQLError() " + TCSQLError())
endif

Return