--example q show_epoch_by_tz.sql '2014-03-30 04:59:40'
SELECT :1 as Date,EXTRACT(EPOCH FROM :1::timestamptz) as expoch
