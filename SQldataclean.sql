SELECT SaleDate
from dbo.housing

--standardizing the date format
alter table housing
add SaleDate2 Date

Select SaleDate ,CONVERT(date,SaleDate)
from dbo.housing

update housing
set SaleDate2=CONVERT(date,SaleDate)

SELECT saledate2
from dbo.housing

--populating property adrress data 
--some data is missing in propert address columns in this we will try to fill it 

SELECT PropertyAddress
from dbo.housing
where PropertyAddress is null



select a.parcelID,a.propertyaddress,b.parcelID,b.propertyaddress --ISNULL(a.propertyaddress,b.PropertyAddress)
from PortfolioProject.dbo.housing a
JOIN PortfolioProject.dbo.housing b
on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--updating null values as parcelid is same for same addresses 
update a
set propertyaddress=ISNULL(a.propertyaddress,b.PropertyAddress)
from PortfolioProject.dbo.housing a
JOIN PortfolioProject.dbo.housing b
on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


select a.parcelID,a.OwnerAddress,b.parcelID,b.OwnerAddress ,ISNULL(a.Owneraddress,b.PropertyAddress)
from PortfolioProject.dbo.housing a
JOIN PortfolioProject.dbo.housing b
on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.OwnerAddress is null 

update a
set Owneraddress=ISNULL(a.Owneraddress,b.PropertyAddress)
from PortfolioProject.dbo.housing a
JOIN PortfolioProject.dbo.housing b
on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.OwnerAddress is null

--now we will break address in columns propertyaddress and owneraddress

SELECT 
substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as address
,substring(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress)) as address1
from PortfolioProject.dbo.housing

alter table housing
add address nvarchar(255);

update housing
set address= substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)


alter table housing
add cityaddress nvarchar(255);


update housing 
set cityaddress= substring(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress))

select OwnerAddress
from dbo.housing
where OwnerAddress is  null

--now i will do the split in owneraddress but using parsename function

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.housing
where OwnerAddress is not null

alter table housing
add streetaddress nvarchar(255);


update housing
set streetaddress=PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

alter table housing
add city_address nvarchar(255);


update housing
set city_address=PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

alter table housing
add stateaddress nvarchar(255);


update housing
set stateaddress=PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select *
from dbo.housing

-- Change Y and N to Yes and No in "Sold as Vacant" field
 Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From  portfolioproject.dbo.Housing
Group by SoldAsVacant
order by 2


select soldasvacant ,
case when soldasvacant='Y' then 'Yes'
		when soldasvacant='N' then 'No'
		else soldasvacant
		end
From portfolioproject.dbo.housing


Update PortfolioProject.dbo.housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant


	   END
--creating a CTE fro same rows
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.housing

)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


	select *
	from portfolioproject.dbo.housing

--removing unsed columns
select *
	from portfolioproject.dbo.housing

alter table portfolioproject.dbo.housing 
drop column owneraddress,propertyaddress,saledate,taxdistrict
