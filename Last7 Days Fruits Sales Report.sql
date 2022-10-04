Select   Cast(dbo.ToBdt(s.ReconciledOn) as date) [Date]
		,pv.Id 									 [PVID]
		,pv.Name 								 [Product]
		,Count(tr.SalePrice) 					 [SaleQty]
		,Sum(tr.SalePrice) 						 [Price]
		,Sum(pv.Weight) / 1000 	                 [Weight/Ton]


From ThingRequest tr 
Join Shipment s on s.Id = tr.ShipmentId 
join ProductVariant pv on pv.Id = tr.ProductVariantId 

Where s.ReconciledOn is not null
And s.ReconciledOn >= '2022-07-24 00:00 +06:00'
And s.ReconciledOn < '2022-07-31 00:00 +06:00'
And tr.IsCancelled = 0
And tr.IsReturned = 0
And tr.IsMissingAfterDispatch = 0
And tr.HasFailedBeforeDispatch = 0
And s.ShipmentStatus not in (1,9,10)
And pv.DistributionNetworkId = 1
And pv.Id in (
	Select ProductVariantId 
	From ProductVariantCategoryMapping 
	Where CategoryId in (11)
)

Group by Cast(dbo.ToBdt(s.ReconciledOn) as date)
		,pv.Id
		,pv.Name

Order By 1 