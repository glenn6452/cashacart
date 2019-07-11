select

b.orderNo loanID
,DATE(b.createdAt) dateApplied
,s.name so_name
,s.code so_code
,pos.name pos_name
,pos.code pos_code
,ucase(pos.region)  region
,concat(ucase(left(c.firstname,1)),substring(c.firstname,2) ,' ',
        ucase(left(c.middlename,1)),substring(c.middlename,2),' ',
        ucase(left(c.lastname,1)),substring(c.lastname,2)) clientName
,c.gender Gender
,c.birthday
,timestampdiff(YEAR,c.birthday,b.createdAt) AS Age
,concat(truncate(timestampdiff(YEAR,c.birthday,b.createdAt),-1),'s') AS ageGroup
,ROUND(b.billAmount,2) billAmount
,ROUND(b.loanAmount,2) loanAmount
,ROUND(b.downPayment,2) downPayment
,ROUND(cb.dueAmount/cb.installments,2) monthly_ins
,cb.installments term
,@pos_group := SUBSTRING_INDEX(pos.code, 0, 1) 'pos_group'
,case when cb.interestRate > 0 then "POS Standard" ELSE "POS Zero" END pos_type
,1 apps
,case when cb.status = 'Processing' and lh.status='Published' then 1
			when (cb.status = 'Canceled' and lh.status='Published') then 1
      when cb.status = 'Success' then 1 else 0 end appr
,CASE
    WHEN cb.status = 'Rejected' THEN 1 ELSE 0 END rej
,CASE
    WHEN cb.status = 'Canceled' and lh.status='Published' THEN 1 ELSE 0 END canc
,CASE
    WHEN (cb.status = 'Processing' and lh.status='Published') then  1 ELSE 0 END proc
,CASE
    WHEN cb.status = 'Success' THEN 1 ELSE 0 END sign
,CASE WHEN cb.status = 'Success' then round(b.loanAmount,2) else 0 END salesVolume
,case when (cb.status = 'Canceled' and lh.status is null) then 1
      else 0 end canc_pre_result
,b.downPayment/b.billAmount dp_perc
,pos.retailerName retailer


FROM trade.Cashacart_CF_Borroworders b
LEFT JOIN trade.Cashacart_Borroworders cb on b.orderNo = cb.orderNo
LEFT JOIN trade.Cashacart_Sales_Client c on c.accountid = cb.accountid
LEFT JOIN trade.SalesAgents s on s.code = b.sacode
LEFT JOIN trade.Cashacart_Sales_POS pos on pos.id = b.storeId
LEFT JOIN (select loanOrderNo,status from trade.Cashacart_LoanApprovalHistories where status = 'Published' group by loanOrderNo) lh on lh.loanOrderNo = b.orderNo
LEFT JOIN trade.Cashacart_PurchaseInfo p on p.cfBorrowOrderId=b.id

where (b.createdAt >= curdate()
			and b.saCode not in ('S0029','S0032','S0035','S0034','S0036','S0005','S0002','S0001','S0338','S0005','S0033','S0486','S0487','S0488') 
			and b.storename not in ('Robinsons','CashaCart','feifei')
			AND b.orderNo not in ('B180802123502589', 'B180817123519716','B180824123526640','B180807123508364', 'B180901123541727', 'B180901123541697', 'B180901123541695', 'B180901123541683','B180901123541668','B180904123548298',
'B180904123548327','B180904123548333','B180910123556352','B180910123556348','B180910123556164','B180911123558387','B180911123558353','B180913123562197','B180914123562953','B181009123615008',
'B181010123616574','B181010123616550','B181010123616546','B181010123616545','B181010123616543','B181010123616474','B181009123616424','B181011123621370','B181014123630237','B181102127760568','B181105128283934') and pos.code!='Robinsons')
group by b.orderNo
order by b.createdAt asc