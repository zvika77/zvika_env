SELECT :1 as EPOCH ,TIMESTAMP WITH TIME ZONE  'epoch' + :1 * INTERVAL '1 second' Date;