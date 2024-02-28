select * from uac_payment where payment_ref = '165851059P';


select * from uac_payment where payment_ref = '490324058P';

select * from uac_ref_frais_scolarite;


-- to be investigated
select payment_ref, count(1) from uac_payment up join uac_ref_frais_scolarite urf on up.ref_fsc_id = urf.id and urf.type = 'T'
group by payment_ref
having count(1) > 1

select payment_ref, input_amount, ref_fsc_id, type_of_payment, count(1) from uac_payment up join uac_ref_frais_scolarite urf on up.ref_fsc_id = urf.id and urf.type = 'U'
group by payment_ref, input_amount, ref_fsc_id, type_of_payment
having count(1) > 1






select * from v_left_to_pay_for_user where VSH_ID = 1604;



select * from v_left_to_pay_for_user where REST_TO_PAY < 0;


select * from uac_showuser where username IN ('diarran532', 'valiand582')


select * from uac_xref_cohort_fsc where cohort_id IN (1, 7);


-- Operation get max and delete it

-- Get max and delete
select payment_ref, user_id, input_amount, ref_fsc_id, type_of_payment, count(1) from uac_payment up join uac_ref_frais_scolarite urf on up.ref_fsc_id = urf.id and urf.type IN ('U', 'T')
group by payment_ref, user_id, input_amount, ref_fsc_id, type_of_payment
having count(1) > 1

'485547052P',
'102243052P',
'103522052P',
'110018052P',
'110259052P',
'114659052P',
'143404052P',
'105943054P',
'112624054P',
'155510054P',
'155918054P',
'494824057P',
'495544057P',
'100028057P',
'100446057P',
'104547057P',
'120717057P',
'155453057P',
'155605057P',
'490324058P',
'490848058P',
'494924058P',
'153232058P',
'485830059P',
'493223059P',
'115934059P',
'120132059P',
'165851059P'
