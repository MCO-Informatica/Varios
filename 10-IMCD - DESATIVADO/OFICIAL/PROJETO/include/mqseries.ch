 /* Open Options */
#define MQ_INPUT_AS_Q_DEF           1
#define MQ_INPUT_SHARED             2
#define MQ_INPUT_EXCLUSIVE          4
#define MQ_BROWSE                   8
#define MQ_OUTPUT                   16
#define MQ_INQUIRE                  32
#define MQ_SET                      64
#define MQ_BIND_ON_OPEN             16384
#define MQ_BIND_NOT_FIXED           32768
#define MQ_BIND_AS_Q_DEF            0
#define MQ_SAVE_ALL_CONTEXT         128
#define MQ_PASS_IDENTITY_CONTEXT    256
#define MQ_PASS_ALL_CONTEXT         512
#define MQ_SET_IDENTITY_CONTEXT     1024
#define MQ_SET_ALL_CONTEXT          2048
#define MQ_ALTERNATE_USER_AUTHORITY 4096
#define MQ_FAIL_IF_QUIESCING        8192
#define MQ_RESOLVE_NAMES            65536

/* Get-Message Options */
#define MQ_WAIT                    1
#define MQ_NO_WAIT                 0
#define MQ_SYNCPOINT               2
#define MQ_SYNCPOINT_IF_PERSISTENT 4096
#define MQ_NO_SYNCPOINT            4
#define MQ_MARK_SKIP_BACKOUT       128
#define MQ_BROWSE_FIRST            16
#define MQ_BROWSE_NEXT             32
#define MQ_BROWSE_MSG_UNDER_CURSOR 2048
#define MQ_MSG_UNDER_CURSOR        256
#define MQ_LOCK                    512
#define MQ_UNLOCK                  1024
#define MQ_ACCEPT_TRUNCATED_MSG    64
#define MQ_SET_SIGNAL              8
#define MQ_FAIL_IF_QUIESCING       8192
#define MQ_CONVERT                 16384
#define MQ_LOGICAL_ORDER           32768
#define MQ_COMPLETE_MSG            65536
#define MQ_ALL_MSGS_AVAILABLE      131072
#define MQ_ALL_SEGMENTS_AVAILABLE  262144
#define MQ_NONE                    0

/* Completion Codes */
#define MQCC_OK       0
#define MQCC_WARNING  1
#define MQCC_FAILED   2
#define MQCC_UNKNOWN -1

/* Reason Codes */
#define MQ_NONE                         0
#define MQ_ALIAS_BASE_Q_TYPE_ERROR   2001
#define MQ_ALREADY_CONNECTED         2002
#define MQ_BACKED_OUT                2003
#define MQ_BUFFER_ERROR              2004
#define MQ_BUFFER_LENGTH_ERROR       2005
#define MQ_CHAR_ATTR_LENGTH_ERROR    2006
#define MQ_CHAR_ATTRS_ERROR          2007
#define MQ_CHAR_ATTRS_TOO_SHORT      2008
#define MQ_CONNECTION_BROKEN         2009
#define MQ_DATA_LENGTH_ERROR         2010
#define MQ_DYNAMIC_Q_NAME_ERROR      2011
#define MQ_ENVIRONMENT_ERROR         2012
#define MQ_EXPIRY_ERROR              2013
#define MQ_FEEDBACK_ERROR            2014
#define MQ_GET_INHIBITED             2016
#define MQ_HANDLE_NOT_AVAILABLE      2017
#define MQ_HCONN_ERROR               2018
#define MQ_HOBJ_ERROR                2019
#define MQ_INHIBIT_VALUE_ERROR       2020
#define MQ_INT_ATTR_COUNT_ERROR      2021
#define MQ_INT_ATTR_COUNT_TOO_SMALL  2022
#define MQ_INT_ATTRS_ARRAY_ERROR     2023
#define MQ_SYNCPOINT_LIMIT_REACHED   2024
#define MQ_MAX_CONNS_LIMIT_REACHED   2025
#define MQ_MD_ERROR                  2026
#define MQ_MISSING_REPLY_TO_Q        2027
#define MQ_MSG_TYPE_ERROR            2029
#define MQ_MSG_TOO_BIG_FOR_Q         2030
#define MQ_MSG_TOO_BIG_FOR_Q_MGR     2031
#define MQ_NO_MSG_AVAILABLE          2033
#define MQ_NO_MSG_UNDER_CURSOR       2034
#define MQ_NOT_AUTHORIZED            2035
#define MQ_NOT_OPEN_FOR_BROWSE       2036
#define MQ_NOT_OPEN_FOR_INPUT        2037
#define MQ_NOT_OPEN_FOR_INQUIRE      2038
#define MQ_NOT_OPEN_FOR_OUTPUT       2039
#define MQ_NOT_OPEN_FOR_SET          2040
#define MQ_OBJECT_CHANGED            2041
#define MQ_OBJECT_IN_USE             2042
#define MQ_OBJECT_TYPE_ERROR         2043
#define MQ_OD_ERROR                  2044
#define MQ_OPTION_NOT_VALID_FOR_TYPE 2045
#define MQ_OPTIONS_ERROR             2046
#define MQ_PERSISTENCE_ERROR         2047
#define MQ_PERSISTENT_NOT_ALLOWED    2048
#define MQ_PRIORITY_EXCEEDS_MAXIMUM  2049
#define MQ_PRIORITY_ERROR            2050
#define MQ_PUT_INHIBITED             2051
#define MQ_Q_DELETED                 2052
#define MQ_Q_FULL                    2053
#define MQ_Q_NOT_EMPTY               2055
#define MQ_Q_SPACE_NOT_AVAILABLE     2056
#define MQ_Q_TYPE_ERROR              2057
#define MQ_Q_MGR_NAME_ERROR          2058
#define MQ_Q_MGR_NOT_AVAILABLE       2059
#define MQ_REPORT_OPTIONS_ERROR      2061
#define MQ_SECOND_MARK_NOT_ALLOWED   2062
#define MQ_SECURITY_ERROR            2063
#define MQ_SELECTOR_COUNT_ERROR      2065
#define MQ_SELECTOR_LIMIT_EXCEEDED   2066
#define MQ_SELECTOR_ERROR            2067
#define MQ_SELECTOR_NOT_FOR_TYPE     2068
#define MQ_SIGNAL_OUTSTANDING        2069
#define MQ_SIGNAL_REQUEST_ACCEPTED   2070
#define MQ_STORAGE_NOT_AVAILABLE     2071
#define MQ_SYNCPOINT_NOT_AVAILABLE   2072
#define MQ_TRIGGER_CONTROL_ERROR     2075
#define MQ_TRIGGER_DEPTH_ERROR       2076
#define MQ_TRIGGER_MSG_PRIORITY_ERR  2077
#define MQ_TRIGGER_TYPE_ERROR        2078
#define MQ_TRUNCATED_MSG_ACCEPTED    2079
#define MQ_TRUNCATED_MSG_FAILED      2080
#define MQ_UNKNOWN_ALIAS_BASE_Q      2082
#define MQ_UNKNOWN_OBJECT_NAME       2085
#define MQ_UNKNOWN_OBJECT_Q_MGR      2086
#define MQ_UNKNOWN_REMOTE_Q_MGR      2087
#define MQ_WAIT_INTERVAL_ERROR       2090
#define MQ_XMIT_Q_TYPE_ERROR         2091
#define MQ_XMIT_Q_USAGE_ERROR        2092
#define MQ_NOT_OPEN_FOR_PASS_ALL     2093
#define MQ_NOT_OPEN_FOR_PASS_IDENT   2094
#define MQ_NOT_OPEN_FOR_SET_ALL      2095
#define MQ_NOT_OPEN_FOR_SET_IDENT    2096
#define MQ_CONTEXT_HANDLE_ERROR      2097
#define MQ_CONTEXT_NOT_AVAILABLE     2098
#define MQ_SIGNAL1_ERROR             2099
#define MQ_OBJECT_ALREADY_EXISTS     2100
#define MQ_OBJECT_DAMAGED            2101
#define MQ_RESOURCE_PROBLEM          2102
#define MQ_ANOTHER_Q_MGR_CONNECTED   2103
#define MQ_UNKNOWN_REPORT_OPTION     2104
#define MQ_STORAGE_CLASS_ERROR       2105
#define MQ_COD_NOT_VALID_FOR_XCF_Q   2106
#define MQ_XWAIT_CANCELED            2107
#define MQ_XWAIT_ERROR               2108
#define MQ_SUPPRESSED_BY_EXIT        2109
#define MQ_FORMAT_ERROR              2110
#define MQ_SOURCE_CCSID_ERROR        2111
#define MQ_SOURCE_INTEGER_ENC_ERROR  2112
#define MQ_SOURCE_DECIMAL_ENC_ERROR  2113
#define MQ_SOURCE_FLOAT_ENC_ERROR    2114
#define MQ_TARGET_CCSID_ERROR        2115
#define MQ_TARGET_INTEGER_ENC_ERROR  2116
#define MQ_TARGET_DECIMAL_ENC_ERROR  2117
#define MQ_TARGET_FLOAT_ENC_ERROR    2118
#define MQ_NOT_CONVERTED             2119
#define MQ_CONVERTED_MSG_TOO_BIG     2120
#define MQ_TRUNCATED                 2120
#define MQ_NO_EXTERNAL_PARTICIPANTS  2121
#define MQ_PARTICIPANT_NOT_AVAILABLE 2122
#define MQ_OUTCOME_MIXED             2123
#define MQ_OUTCOME_PENDING           2124
#define MQ_BRIDGE_STARTED            2125
#define MQ_BRIDGE_STOPPED            2126
#define MQ_ADAPTER_STORAGE_SHORTAGE  2127
#define MQ_UOW_IN_PROGRESS           2128
#define MQ_ADAPTER_CONN_LOAD_ERROR   2129
#define MQ_ADAPTER_SERV_LOAD_ERROR   2130
#define MQ_ADAPTER_DEFS_ERROR        2131
#define MQ_ADAPTER_DEFS_LOAD_ERROR   2132
#define MQ_ADAPTER_CONV_LOAD_ERROR   2133
#define MQ_BO_ERROR                  2134
#define MQ_DH_ERROR                  2135
#define MQ_MULTIPLE_REASONS          2136
#define MQ_OPEN_FAILED               2137
#define MQ_ADAPTER_DISC_LOAD_ERROR   2138
#define MQ_CNO_ERROR                 2139
#define MQ_CICS_WAIT_FAILED          2140
#define MQ_DLH_ERROR                 2141
#define MQ_HEADER_ERROR              2142
#define MQ_SOURCE_LENGTH_ERROR       2143
#define MQ_TARGET_LENGTH_ERROR       2144
#define MQ_SOURCE_BUFFER_ERROR       2145
#define MQ_TARGET_BUFFER_ERROR       2146
#define MQ_IIH_ERROR                 2148
#define MQ_PCF_ERROR                 2149
#define MQ_DBCS_ERROR                2150
#define MQ_OBJECT_NAME_ERROR         2152
#define MQ_OBJECT_Q_MGR_NAME_ERROR   2153
#define MQ_RECS_PRESENT_ERROR        2154
#define MQ_OBJECT_RECORDS_ERROR      2155
#define MQ_RESPONSE_RECORDS_ERROR    2156
#define MQ_ASID_MISMATCH             2157
#define MQ_PMO_RECORD_FLAGS_ERROR    2158
#define MQ_PUT_MSG_RECORDS_ERROR     2159
#define MQ_CONN_ID_IN_USE            2160
#define MQ_Q_MGR_QUIESCING           2161
#define MQ_Q_MGR_STOPPING            2162
#define MQ_DUPLICATE_RECOV_COORD     2163
#define MQ_PMO_ERROR                 2173
#define MQ_API_EXIT_NOT_FOUND        2182
#define MQ_API_EXIT_LOAD_ERROR       2183
#define MQ_REMOTE_Q_NAME_ERROR       2184
#define MQ_INCONSISTENT_PERSISTENCE  2185
#define MQ_GMO_ERROR                 2186
#define MQ_CICS_BRIDGE_RESTRICTION   2187
#define MQ_STOPPED_BY_CLUSTER_EXIT   2188
#define MQ_CLUSTER_RESOLUTION_ERROR  2189
#define MQ_CONVERTED_STRING_TOO_BIG  2190
#define MQ_TMC_ERROR                 2191
#define MQ_PAGESET_FULL              2192
#define MQ_PAGESET_ERROR             2193
#define MQ_NAME_NOT_VALID_FOR_TYPE   2194
#define MQ_UNEXPECTED_ERROR          2195
#define MQ_UNKNOWN_XMIT_Q            2196
#define MQ_UNKNOWN_DEF_XMIT_Q        2197
#define MQ_DEF_XMIT_Q_TYPE_ERROR     2198
#define MQ_DEF_XMIT_Q_USAGE_ERROR    2199
#define MQ_NAME_IN_USE               2201
#define MQ_CONNECTION_QUIESCING      2202
#define MQ_CONNECTION_STOPPING       2203
#define MQ_ADAPTER_NOT_AVAILABLE     2204
#define MQ_MSG_ID_ERROR              2206
#define MQ_CORREL_ID_ERROR           2207
#define MQ_FILE_SYSTEM_ERROR         2208
#define MQ_NO_MSG_LOCKED             2209
#define MQ_FILE_NOT_AUDITED          2216
#define MQ_CONNECTION_NOT_AUTHORIZED 2217
#define MQ_MSG_TOO_BIG_FOR_CHANNEL   2218
#define MQ_CALL_IN_PROGRESS          2219
#define MQ_RMH_ERROR                 2220
#define MQ_Q_MGR_ACTIVE              2222
#define MQ_Q_MGR_NOT_ACTIVE          2223
#define MQ_Q_DEPTH_HIGH              2224
#define MQ_Q_DEPTH_LOW               2225
#define MQ_Q_SERVICE_INTERVAL_HIGH   2226
#define MQ_Q_SERVICE_INTERVAL_OK     2227
#define MQ_UNIT_OF_WORK_NOT_STARTED  2232
#define MQ_CHANNEL_AUTO_DEF_OK       2233
#define MQ_CHANNEL_AUTO_DEF_ERROR    2234
#define MQ_CFH_ERROR                 2235
#define MQ_CFIL_ERROR                2236
#define MQ_CFIN_ERROR                2237
#define MQ_CFSL_ERROR                2238
#define MQ_CFST_ERROR                2239
#define MQ_INCOMPLETE_GROUP          2241
#define MQ_INCOMPLETE_MSG            2242
#define MQ_INCONSISTENT_CCSIDS       2243
#define MQ_INCONSISTENT_ENCODINGS    2244
#define MQ_INCONSISTENT_UOW          2245
#define MQ_INVALID_MSG_UNDER_CURSOR  2246
#define MQ_MATCH_OPTIONS_ERROR       2247
#define MQ_MDE_ERROR                 2248
#define MQ_MSG_FLAGS_ERROR           2249
#define MQ_MSG_SEQ_NUMBER_ERROR      2250
#define MQ_OFFSET_ERROR              2251
#define MQ_ORIGINAL_LENGTH_ERROR     2252
#define MQ_SEGMENT_LENGTH_ZERO       2253
#define MQ_UOW_NOT_AVAILABLE         2255
#define MQ_WRONG_GMO_VERSION         2256
#define MQ_WRONG_MD_VERSION          2257
#define MQ_GROUP_ID_ERROR            2258
#define MQ_INCONSISTENT_BROWSE       2259
#define MQ_XQH_ERROR                 2260
#define MQ_SRC_ENV_ERROR             2261
#define MQ_SRC_NAME_ERROR            2262
#define MQ_DEST_ENV_ERROR            2263
#define MQ_DEST_NAME_ERROR           2264
#define MQ_TM_ERROR                  2265
#define MQ_CLUSTER_EXIT_ERROR        2266
#define MQ_CLUSTER_EXIT_LOAD_ERROR   2267
#define MQ_CLUSTER_PUT_INHIBITED     2268
#define MQ_CLUSTER_RESOURCE_ERROR    2269
#define MQ_NO_DESTINATIONS_AVAILABLE 2270
#define MQ_CONNECTION_ERROR          2273
#define MQ_OPTION_ENVIRONMENT_ERROR  2274
#define MQ_CD_ERROR                  2277
#define MQ_CLIENT_CONN_ERROR         2278
#define MQ_CHANNEL_STOPPED_BY_USER   2279
#define MQ_HCONFIG_ERROR             2280
#define MQ_FUNCTION_ERROR            2281
#define MQ_CHANNEL_STARTED           2282
#define MQ_CHANNEL_STOPPED           2283
#define MQ_CHANNEL_CONV_ERROR        2284
#define MQ_SERVICE_NOT_AVAILABLE     2285
#define MQ_INITIALIZATION_FAILED     2286
#define MQ_TERMINATION_FAILED        2287
#define MQ_UNKNOWN_Q_NAME            2288
#define MQ_SERVICE_ERROR             2289
#define MQ_Q_ALREADY_EXISTS          2290
#define MQ_USER_ID_NOT_AVAILABLE     2291
#define MQ_UNKNOWN_ENTITY            2292
#define MQ_UNKNOWN_AUTH_ENTITY       2293
#define MQ_UNKNOWN_REF_OBJECT        2294
#define MQ_CHANNEL_ACTIVATED         2295
#define MQ_CHANNEL_NOT_ACTIVATED     2296
#define MQ_UOW_CANCELED              2297
#define MQ_SELECTOR_TYPE_ERROR       2299
#define MQ_COMMAND_TYPE_ERROR        2300
#define MQ_MULTIPLE_INSTANCE_ERROR   2301
#define MQ_SYSTEM_ITEM_NOT_ALTERABLE 2302
#define MQ_BAG_CONVERSION_ERROR      2303
#define MQ_SELECTOR_OUT_OF_RANGE     2304
#define MQ_SELECTOR_NOT_UNIQUE       2305
#define MQ_INDEX_NOT_PRESENT         2306
#define MQ_STRING_ERROR              2307
#define MQ_ENCODING_NOT_SUPPORTED    2308
#define MQ_SELECTOR_NOT_PRESENT      2309
#define MQ_OUT_SELECTOR_ERROR        2310
#define MQ_STRING_TRUNCATED          2311
#define MQ_SELECTOR_WRONG_TYPE       2312
#define MQ_INCONSISTENT_ITEM_TYPE    2313
#define MQ_INDEX_ERROR               2314
#define MQ_SYSTEM_BAG_NOT_ALTERABLE  2315
#define MQ_ITEM_COUNT_ERROR          2316
#define MQ_FORMAT_NOT_SUPPORTED      2317
#define MQ_SELECTOR_NOT_SUPPORTED    2318
#define MQ_ITEM_VALUE_ERROR          2319
#define MQ_HBAG_ERROR                2320
#define MQ_PARAMETER_MISSING         2321
#define MQ_CMD_SERVER_NOT_AVAILABLE  2322
#define MQ_STRING_LENGTH_ERROR       2323
#define MQ_INQUIRY_COMMAND_ERROR     2324
#define MQ_NESTED_BAG_NOT_SUPPORTED  2325
#define MQ_BAG_WRONG_TYPE            2326
#define MQ_ITEM_TYPE_ERROR           2327
#define MQ_SYSTEM_BAG_NOT_DELETABLE  2328
#define MQ_SYSTEM_ITEM_NOT_DELETABLE 2329
#define MQ_CODED_CHAR_SET_ID_ERROR   2330
#define MQ_MSG_TOKEN_ERROR           2331
#define MQ_MISSING_WIH               2332
#define MQ_WIH_ERROR                 2333
#define MQ_RFH_ERROR                 2334
#define MQ_RFH_STRING_ERROR          2335
#define MQ_RFH_COMMAND_ERROR         2336
#define MQ_RFH_PARM_ERROR            2337
#define MQ_RFH_DUPLICATE_PARM        2338
#define MQ_RFH_PARM_MISSING          2339
#define MQ_APPL_FIRST                 900
#define MQ_APPL_LAST                  999