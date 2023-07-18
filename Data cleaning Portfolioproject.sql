/*

Cleaning Data in SQL Queries

*/


Select *
From NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------
--Standardize Date Format


Select Saledate, convert(Date,Saledate)
From NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleConvertedDate Date;

Update NashvilleHousing
SET SaleConvertedDate = Convert(Date, Saledate)

Select Saledate,Saleconverteddate
From NashvilleHousing

---Populate Property Address data 

Select ParcelID, Propertyaddress
From NashvilleHousing
Where Propertyaddress is Null

   ---Here a uniqueId has same parcelid so therefore we can populate from the addresses of these parcelid of same uniqeID.

Select a.ParcelID, a.Propertyaddress,b.Parcelid,b.Propertyaddress
From NashvilleHousing a
Join NashvilleHousing b
On a.ParcelId=b.Parcelid
 AND a.UniqueId <> b.uniqueid
Where a.Propertyaddress is Null

Update a
SET propertyaddress = ISNULL(a.propertyaddress,b.propertyaddress)
From NashvilleHousing a
Join NashvilleHousing b
On a.ParcelId=b.Parcelid
 AND a.UniqueId <> b.uniqueid
Where a.Propertyaddress is Null
--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select 
substring(Propertyaddress,1,CHARINDEX(',', Propertyaddress)-1)AS Address
,substring(Propertyaddress,CHARINDEX(',',Propertyaddress)+1,LEN(Propertyaddress))
from NashvilleHousing


ALTER TABLE NashvilleHousing
ADD Propertysplitaddress nvarchar(250);

Update NashvilleHousing
SET Propertysplitaddress =substring(Propertyaddress,1,CHARINDEX(',', Propertyaddress)-1)

ALTER TABLE NashvilleHousing
ADD Propertysplitcity nvarchar(250);

Update NashvilleHousing
SET Propertysplitcity  = substring(Propertyaddress,CHARINDEX(',',Propertyaddress)+1,LEN(Propertyaddress))

--Anotherway we can also perform this by PARSENAME!!---
Select*
From NashvilleHousing

Select 
Parsename(Replace(PropertyAddress, ',', '.'),2) as Newpropertyaddress
,Parsename(Replace(PropertyAddress, ',', '.'),1) as Newcityaddress
From NashvilleHousing


ALTER TABLE NashvilleHousing
ADD NewPropertySplitaddress nvarchar(250);

Update NashvilleHousing
SET NewPropertySplitaddress = Parsename(Replace(PropertyAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
ADD NewPropertySplitcity nvarchar(250);

Update NashvilleHousing
SET NewPropertySplitcity = Parsename(Replace(PropertyAddress, ',', '.'),1)

Select  NewPropertySplitaddress, NewPropertySplitcity
From NashvilleHousing




--Spliting Owner address into (address,city and State)


Select Owneraddress
From NashvilleHousing
where owneraddress is not null

Select 
Parsename(Replace(Owneraddress, ',', '.'),3),
Parsename(Replace(Owneraddress, ',', '.'),2),
Parsename(Replace(Owneraddress, ',', '.'),1)
From NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitaddress nvarchar(250);

Update NashvilleHousing
SET OwnerSplitaddress = Parsename(Replace(Owneraddress, ',', '.'),3)

ALTER TABLE NashvilleHousing
ADD Ownersplitcity nvarchar(250);

Update NashvilleHousing
SET Ownersplitcity = Parsename(Replace(Owneraddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
ADD Ownersplitstate nvarchar(250);

Update NashvilleHousing
SET Ownersplitstate = Parsename(Replace(Owneraddress, ',', '.'),1)


Select OwnerSplitaddress,OwnerSplitcity,OwnerSplitstate
From NashvilleHousing



-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct Soldasvacant, count(Soldasvacant)
From NashvilleHousing
Group by Soldasvacant

Select Soldasvacant
,Case 
 When Soldasvacant = 'Y' then 'Yes'
 When Soldasvacant = 'N' then 'No'
 Else Soldasvacant
End
From NashvilleHousing

Update NashvilleHousing
Set  Soldasvacant = Case  When Soldasvacant = 'Y' then 'Yes'
 When Soldasvacant = 'N' then 'No'
 Else Soldasvacant
 End

 -----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

With RowNumcte As
( 
Select*,
   Row_Number() over
   (Partition by parcelid,
			     PropertyAddress,
				 Saledate,
				 LegalReference
			Order by
				  Uniqueid
				  ) row_num
From NashvilleHousing
)
Delete 
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From NashvilleHousing

Alter Table NashvilleHousing
Drop column Propertyaddress,owneraddress,taxdistrict


