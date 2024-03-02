select * from uac_payment where payment_ref = '165851059P';


select * from uac_payment where payment_ref = '490324058P';

select * from uac_ref_frais_scolarite;


-- to be investigated

select payment_ref, user_id, input_amount, ref_fsc_id, type_of_payment, count(1) from uac_payment up join uac_ref_frais_scolarite urf on up.ref_fsc_id = urf.id and urf.type = 'U'
group by payment_ref, user_id, input_amount, ref_fsc_id, type_of_payment
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
