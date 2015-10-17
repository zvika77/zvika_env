--lp_15744040
 --------------------------------------------------------
--  DDL for Table DIM_END_REASON
--------------------------------------------------------
 
 drop table lp_15744040."DIM_END_REASON" ;
 
 CREATE TABLE lp_15744040."DIM_END_REASON" 
   ( "END_REASON_ID" NUMBER, 
   "LP_END_REASON_ID" VARCHAR2(20 ),
   "END_REASON_DESC" VARCHAR2(200 ),
   "END_REASON_GROUP" VARCHAR2(100 ),
   "ACTIVE_IND" NUMBER(1,0)
    ) UNSEGMENTED ALL NODES;


     --------------------------------------------------------
--  DDL for Table DIM_IMPRESSION_OBJECT
--------------------------------------------------------
drop table lp_15744040."DIM_IMPRESSION_OBJECT" ;

 CREATE TABLE lp_15744040."DIM_IMPRESSION_OBJECT" 
   ( "IMPRESSION_OBJECT_ID" NUMBER, 
   "LP_ACCOUNT_ID" VARCHAR2(20 ),
   "LP_IMPRESSION_OBJECT_ID" VARCHAR2(20 ), 
   "IMPRESSION_OBJECT_TYPE" VARCHAR2(100 ),
   "IMPRESSION_OBJECT_NAME" VARCHAR2(100 ), 
   "ACTIVE_IND" NUMBER(1,0)
    ) UNSEGMENTED ALL NODES;


--------------------------------------------------------
--  DDL for Table DIM_RESPONSE
--------------------------------------------------------

drop table lp_15744040."DIM_RESPONSE" ;

 CREATE TABLE lp_15744040."DIM_RESPONSE" 
   ( "RESPONSE_ID" NUMBER, 
   "LP_RESPONSE_ID" NUMBER,
   "RESPONSE_NAME" VARCHAR2(20), 
   "ACTIVE_IND" NUMBER(1,0)
    ) UNSEGMENTED ALL NODES;


  --------------------------------------------------------
--  DDL for Table MAP_AGENT_GROUP
--------------------------------------------------------


drop table lp_15744040."MAP_AGENT_GROUP" ;

  CREATE TABLE lp_15744040."MAP_AGENT_GROUP" 
   (	
   "AGENT_ID" NUMBER ,
	"AGENT_GROUP_ID" NUMBER,
    "LP_ACCOUNT_ID" VARCHAR2(20 ),
     "LP_AGENT_ID" VARCHAR2(20 ),
   "LP_AGENT_GROUP_ID" VARCHAR2(20 )
   )  UNSEGMENTED ALL NODES;
   

 --------------------------------------------------------
--  DDL for Table MAP_AGENT_SKILL
--------------------------------------------------------


drop table lp_15744040."MAP_AGENT_SKILL" ;

  CREATE TABLE lp_15744040."MAP_AGENT_SKILL" 
   (	
	"AGENT_ID" NUMBER, 
	"SKILL_ID" NUMBER,
    "LP_ACCOUNT_ID" VARCHAR2(20 ),
     "LP_AGENT_ID" VARCHAR2(20 ),
     "LP_SKILL_ID" VARCHAR2(20 )
   ) UNSEGMENTED ALL NODES;


--------------------------------------------------------
--  DDL for Table FACT_AGENT_SESSION
--------------------------------------------------------


drop table lp_15744040."FACT_AGENT_SESSION" ;

 CREATE TABLE lp_15744040."FACT_AGENT_SESSION" 
  (	
  "LP_AGENT_SESSION_ID" VARCHAR2(400), 
  "ACCOUNT_ID" NUMBER,
  "LP_ACCOUNT_ID" VARCHAR2(20 ),
  "AGENT_ID" NUMBER,
  "LP_AGENT_ID" VARCHAR2(20), 
  "FROM_DT_TRUNC" TIMESTAMP not null, 
  "FROM_DT_ACTUAL" TIMESTAMPTZ, 
  "TO_DT_ACTUAL" TIMESTAMPTZ, 
  "AGENT_STATUS_ID" NUMBER, 
  "CHANNEL_ID" NUMBER, 
  "DURATION" NUMBER, 
  "CONCURRENT_ENG" NUMBER
  )
   SEGMENTED BY hash(LP_AGENT_SESSION_ID) ALL NODES  
   PARTITION BY EXTRACT(year FROM FROM_DT_TRUNC)*100 + EXTRACT(month FROM FROM_DT_TRUNC) 
;  



--------------------------------------------------------
--  DDL for Table FACT_ENGAGEMENT
--------------------------------------------------------


drop table lp_15744040."FACT_ENGAGEMENT" ;

  CREATE TABLE lp_15744040."FACT_ENGAGEMENT" 
   (	
   "ENG_LP_SESSION_ID" VARCHAR2(400), 
   "VS_LP_SESSION_ID" VARCHAR2(400), 
   "IMD_LP_SESSION_ID" VARCHAR2(400),
   "IMR_LP_SESSION_ID" VARCHAR2(400),
   "QUEUE_LP_SESSION_ID" VARCHAR2(400), 
   "ACCOUNT_ID" NUMBER,
   "LP_ACCOUNT_ID" VARCHAR2(20),
   "AGENT_ID" NUMBER,
   "LP_AGENT_ID" VARCHAR2(20), 
   "ROOM_ID" NUMBER,
   "CHANNEL_ID" NUMBER, 
   "APPROACH_TYPE_ID" NUMBER, 
   "END_REASON_ID" NUMBER, 
   "IMPRESSION_OBJECT_ID" NUMBER, 
   "VISIT_FROM_DT_TRUNC" timestamp, 
   "VISIT_FROM_DT_ACTUAL" timestamptz, 
   "VISIT_TO_DT_ACTUAL" timestamptz, 
   "ENG_FROM_DT_TRUNC" timestamp not null, 
   "ENG_FROM_DT_ACTUAL" timestamptz, 
   "ENG_TO_DT_ACTUAL" timestamptz, 
   "ENTER_QUEUE_DT_ACTUAL" timestamptz,
   "END_QUEUE_DT_ACTUAL" timestamptz,
   "EXIT_SURVEY_VIEW_DT_ACTUAL" timestamptz,
   "EXIT_SURVEY_FILLED_DT_ACTUAL" timestamptz, 
   "DURATION" NUMBER,
   "CSAT_SCORE" NUMBER,
	 "INTERACTIVE_IND" NUMBER(1,0),
   "HOT_LEAD_IND" NUMBER(1,0),
   "EXIT_SURVEY_VIEW_IND" NUMBER(1,0),
   "EXIT_SURVEY_FILLED_IND" NUMBER(1,0)
   )
   SEGMENTED BY hash(ENG_LP_SESSION_ID) ALL NODES  
   PARTITION BY EXTRACT(year FROM ENG_FROM_DT_TRUNC)*100 + EXTRACT(month FROM ENG_FROM_DT_TRUNC) 
   ;


 --------------------------------------------------------
--  DDL for Table FACT_IMD
--------------------------------------------------------

drop table lp_15744040."FACT_IMD" ;

CREATE TABLE lp_15744040."FACT_IMD" 
   (
   "IMD_LP_SESSION_ID" varchar2(400), 
   "VS_LP_SESSION_ID" varchar2(400),
    "ACCOUNT_ID" NUMBER,
    "LP_ACCOUNT_ID" VARCHAR2(20 ),
    "ROOM_ID" NUMBER,
   "APPROACH_TYPE_ID" NUMBER,
   "CHANNEL_ID" NUMBER,
   "IMPRESSION_OBJECT_ID" NUMBER,
   "VISIT_FROM_DT_TRUNC" timestamp not null, 
   "VISIT_FROM_DT_ACTUAL" timestamptz, 
   "VISIT_TO_DT_ACTUAL" timestamptz, 
   "IMD_DT_ACTUAL" timestamptz,
   "HOT_LEAD_IND" NUMBER(1,0)
     )
     SEGMENTED BY hash(VS_LP_SESSION_ID) ALL NODES  
    PARTITION BY EXTRACT(year FROM VISIT_FROM_DT_TRUNC)*100 + EXTRACT(month FROM VISIT_FROM_DT_TRUNC) 
;



--------------------------------------------------------
--  DDL for Table FACT_IMR
--------------------------------------------------------

drop table lp_15744040."FACT_IMR" ;

CREATE TABLE lp_15744040."FACT_IMR" 
   (
   "IMR_LP_SESSION_ID" varchar2(400), 
   "VS_LP_SESSION_ID" varchar2(400), 
   "IMD_LP_SESSION_ID" varchar2(400),
   "ACCOUNT_ID" NUMBER,
    "LP_ACCOUNT_ID" VARCHAR2(20 ),
   "ROOM_ID" NUMBER,
   "APPROACH_TYPE_ID" NUMBER,
   "CHANNEL_ID" NUMBER,
   "IMPRESSION_OBJECT_ID" NUMBER,
   "RESPONSE_ID" NUMBER,
   "VISIT_FROM_DT_TRUNC" timestamp not null, 
   "VISIT_FROM_DT_ACTUAL" timestamptz, 
   "VISIT_TO_DT_ACTUAL" timestamptz, 
   "IMR_DT_ACTUAL" timestamptz,
   "HOT_LEAD_IND" NUMBER(1,0)
    )
    SEGMENTED BY hash(VS_LP_SESSION_ID) ALL NODES  
   PARTITION BY EXTRACT(year FROM VISIT_FROM_DT_TRUNC)*100 + EXTRACT(month FROM VISIT_FROM_DT_TRUNC) 
;


  --------------------------------------------------------
--  DDL for Table FACT_INSESSION_CONVERSION
--------------------------------------------------------

drop table lp_15744040."FACT_INSESSION_CONVERSION" ;
  
 CREATE TABLE lp_15744040."FACT_INSESSION_CONVERSION" 
   (
    CONV_LP_SESSION_ID VARCHAR2(400),
    VS_LP_SESSION_ID VARCHAR2(400),
    IMD_LP_SESSION_ID  VARCHAR2(400),
    IMR_LP_SESSION_ID VARCHAR2(400),
    QUEUE_LP_SESSION_ID VARCHAR2(400),
    ENG_LP_SESSION_ID VARCHAR2(400),
    "CREDIT_ALGORITHM_ID" NUMBER, 
    "ACCOUNT_ID" NUMBER, 
    "LP_ACCOUNT_ID" VARCHAR2(20), 
    "AGENT_ID" NUMBER,
     "LP_AGENT_ID" VARCHAR2(20), 
    IMPRESSION_OBJECT_ID NUMBER,
     "CHANNEL_ID" NUMBER, 
    "ROOM_ID" NUMBER, 
    "APPROACH_TYPE_ID" NUMBER, 
    "CONVERSION_DEF_ID" NUMBER, 
    "CONV_DT_TRUNC" TIMESTAMP, 
    "CONV_DT_ACTUAL" TIMESTAMPTZ, 
    VISIT_FROM_DT_TRUNC TIMESTAMP not null,
    VISIT_FROM_DT_ACTUAL TIMESTAMPTZ,
    VISIT_TO_DT_ACTUAL TIMESTAMPTZ,
    "ORDER_NUMBER" VARCHAR2(500),
   "CONVERSION_VALUE" NUMBER,
   "CONVERSION_RATIO" NUMBER(4,2),
    HOT_LEAD_IND  NUMBER(1,0),
    SELF_SERVICE_IND  NUMBER(1,0)
  )
     SEGMENTED BY hash(VS_LP_SESSION_ID) ALL NODES  
     PARTITION BY EXTRACT(year FROM VISIT_FROM_DT_TRUNC)*100 + EXTRACT(month FROM VISIT_FROM_DT_TRUNC) 
;



 --------------------------------------------------------
--  DDL for Table FACT_VISIT_ROOM
--------------------------------------------------------   

drop table lp_15744040."FACT_VISIT_ROOM" ;

CREATE TABLE lp_15744040."FACT_VISIT_ROOM" 
   (
   "VS_LP_VISITOR_ID" varchar2(400), 
   "VS_LP_SESSION_ID" varchar2(400), 
   "ACCOUNT_ID" NUMBER,
   "LP_ACCOUNT_ID" VARCHAR2(20 ),
   "ROOM_ID" NUMBER, 
   "VISIT_FROM_DT_TRUNC" timestamp not null, 
   "VISIT_FROM_DT_ACTUAL" timestamptz, 
   "VISIT_TO_DT_ACTUAL" timestamptz, 
   "HOT_LEAD_IND" NUMBER(1,0)
    )
	 SEGMENTED BY hash(VS_LP_SESSION_ID) ALL NODES  
         PARTITION BY EXTRACT(year FROM VISIT_FROM_DT_TRUNC)*100 + EXTRACT(month FROM VISIT_FROM_DT_TRUNC) 
;



 --------------------------------------------------------
--  DDL for Table FACT_VISIT_ROOM
--------------------------------------------------------   

drop table lp_15744040."FACT_VISIT_ROOM" ;

CREATE TABLE lp_15744040."FACT_VISIT_ROOM" 
   (
   "VS_LP_VISITOR_ID" varchar2(400), 
   "VS_LP_SESSION_ID" varchar2(400), 
   "ACCOUNT_ID" NUMBER,
   "LP_ACCOUNT_ID" VARCHAR2(20 ),
   "ROOM_ID" NUMBER, 
   "VISIT_FROM_DT_TRUNC" timestamp not null, 
   "VISIT_FROM_DT_ACTUAL" timestamptz, 
   "VISIT_TO_DT_ACTUAL" timestamptz, 
   "HOT_LEAD_IND" NUMBER(1,0)
    )
	 SEGMENTED BY hash(VS_LP_SESSION_ID) ALL NODES  
         PARTITION BY EXTRACT(year FROM VISIT_FROM_DT_TRUNC)*100 + EXTRACT(month FROM VISIT_FROM_DT_TRUNC) 
;
 
 

